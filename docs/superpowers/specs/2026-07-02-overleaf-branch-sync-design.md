# Design: `overleaf` branch auto-sync

Date: 2026-07-02

## Problem

The "Open in Overleaf" badge in `README.md` / `README.zh-CN.md` points
at `.../archive/refs/heads/main.zip` — a zip of the entire `main`
branch. That pulls in everything in the repo (`.agents/`, `.claude/`,
`.codex/`, `.cursor/`, `docs/`, `Makefile`, `README*.md`, `LICENSE`),
not just the paper source under `main/`. Anyone using the badge to
start an Overleaf project ends up with a cluttered project containing
files Overleaf never needs.

## Goal

An `overleaf` branch whose root *is* the current contents of `main/`
(i.e. `main/main.tex` → `main.tex`, `main/secs/` → `secs/`, etc.),
kept in sync automatically, plus updated "Open in Overleaf" badges so
opening the badge pulls only that branch.

## Non-goals

- Bidirectional sync. `overleaf` is a one-way mirror generated from
  `main`'s `main/` directory. Edits made directly in an Overleaf
  project are not synced back; if the user changes something on
  Overleaf, they manually port it back into `main/` themselves.
- Verifying the `overleaf` branch compiles in CI. `main/` is already
  the source of truth and is expected to compile; re-verifying a
  mechanical copy of it adds no signal.
- Any change trigger outside `main/**` (e.g. edits to `docs/` or
  `Makefile` do not trigger a sync).

## Architecture

```
.github/workflows/overleaf-sync.yml   # new GitHub Actions workflow
  on: push to `main` touching `main/**`, or workflow_dispatch
  steps:
    - checkout with fetch-depth: 0 (subtree split needs full history)
    - git subtree split --prefix=main -b overleaf-tmp
    - git push origin overleaf-tmp:overleaf --force

README.md, README.zh-CN.md
  "Open in Overleaf" badge snip_uri:
    .../archive/refs/heads/main.zip  →  .../archive/refs/heads/overleaf.zip
```

The `overleaf` branch is entirely bot-managed: every run force-pushes
a freshly split history, so nobody should commit to it directly (a
direct commit would just be overwritten on the next sync).

## Workflow details

1. **Trigger.** `push` to `main` with a path filter on `main/**`, plus
   `workflow_dispatch` for manual re-runs (first-time bootstrap, or
   recovering from a missed/failed run).
2. **Permissions.** `permissions: contents: write` on the job, using
   the default `GITHUB_TOKEN` — no extra secrets needed since the
   workflow only pushes within the same repo.
3. **Split.** `git subtree split --prefix=main -b overleaf-tmp` walks
   `main`'s history and produces a new commit graph containing only
   the changes that touched `main/`, with `main/` promoted to the
   branch root. This preserves per-commit history for the paper
   content instead of collapsing everything into one snapshot commit.
4. **Publish.** `git push origin overleaf-tmp:overleaf --force`. On
   the very first run `overleaf` doesn't exist yet, so this creates
   it. Force-push is intentional and safe because the branch has no
   independent history worth preserving — its entire content is
   reproducible from `main`'s `main/` directory.
5. **Badges.** Update the `snip_uri` query param in both README files
   from `archive/refs/heads/main.zip` to
   `archive/refs/heads/overleaf.zip`. Overleaf auto-detects the root
   `.tex` document inside the zip (`main.tex`), same as it does today.

## Isolation guarantees

- `main/` and everything else on the `main` branch is untouched by
  this workflow — it only reads from `main` and writes to `overleaf`.
- No `.bib` content is altered; `main.bib` is copied byte-for-byte by
  the subtree split, same as every other file under `main/`.
- The workflow only runs on push to `main` (plus manual dispatch), so
  it never runs against PR branches or forks.

## Testing / verification

- Manually trigger the workflow (`workflow_dispatch`) after adding it,
  confirm the `overleaf` branch is created with `main.tex` at its
  root and matching the current `main/` contents.
- Edit a file under `main/secs/`, push to `main`, confirm the workflow
  re-runs automatically and `overleaf` picks up the change.
- Confirm the updated badge URL
  (`.../archive/refs/heads/overleaf.zip`) downloads a zip containing
  only the former `main/` contents, and that importing it into
  Overleaf compiles with `main.tex` auto-detected as the root doc.
