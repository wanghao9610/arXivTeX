# Overleaf Branch Auto-Sync Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish `main/` as the root of a bot-managed `overleaf` branch, kept in sync by a GitHub Actions workflow, and point the "Open in Overleaf" badges at that branch instead of the whole repo.

**Architecture:** A new workflow `.github/workflows/overleaf-sync.yml` runs `git subtree split --prefix=main -b overleaf-tmp` on every push to `main` that touches `main/**` (plus manual `workflow_dispatch`), then force-pushes the result to `overleaf`. `README.md` and `README.zh-CN.md` badge URLs change from `archive/refs/heads/main.zip` to `archive/refs/heads/overleaf.zip`.

**Tech Stack:** GitHub Actions (`actions/checkout@v4`), `git subtree`, no new dependencies.

Full design context: [docs/superpowers/specs/2026-07-02-overleaf-branch-sync-design.md](../specs/2026-07-02-overleaf-branch-sync-design.md)

---

### Task 1: Create the GitHub Actions sync workflow

**Files:**
- Create: `.github/workflows/overleaf-sync.yml`

- [ ] **Step 1: Write the workflow file**

```yaml
name: Sync overleaf branch

on:
  push:
    branches:
      - main
    paths:
      - 'main/**'
  workflow_dispatch: {}

permissions:
  contents: write

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout full history
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Configure git identity
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"

      - name: Split main/ into a standalone branch
        run: git subtree split --prefix=main -b overleaf-tmp

      - name: Force-push to overleaf branch
        run: git push origin overleaf-tmp:overleaf --force
```

- [ ] **Step 2: Validate YAML syntax**

Run: `ruby -ryaml -e "YAML.load_file('.github/workflows/overleaf-sync.yml'); puts 'valid'"`
Expected: `valid`

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/overleaf-sync.yml
git commit -m "Add workflow to sync main/ into overleaf branch"
```

---

### Task 2: Point the English README badge at the overleaf branch

**Files:**
- Modify: `README.md:3`

- [ ] **Step 1: Update the badge URL**

Current line:
```
[![Open in Overleaf](https://img.shields.io/badge/Open%20in-Overleaf-47A141?logo=overleaf&logoColor=white)](https://www.overleaf.com/docs?snip_uri=https%3A%2F%2Fgithub.com%2Fwanghao9610%2FarXivTeX%2Farchive%2Frefs%2Fheads%2Fmain.zip)
```

New line:
```
[![Open in Overleaf](https://img.shields.io/badge/Open%20in-Overleaf-47A141?logo=overleaf&logoColor=white)](https://www.overleaf.com/docs?snip_uri=https%3A%2F%2Fgithub.com%2Fwanghao9610%2FarXivTeX%2Farchive%2Frefs%2Fheads%2Foverleaf.zip)
```

Use the Edit tool with `old_string` = the current line and `new_string` = the new line, on `README.md`.

- [ ] **Step 2: Verify the change**

Run: `grep -o 'archive%2Frefs%2Fheads%2F[a-z]*\.zip' README.md`
Expected: `archive%2Frefs%2Fheads%2Foverleaf.zip`

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "Point Overleaf badge at overleaf branch"
```

---

### Task 3: Point the Chinese README badge at the overleaf branch

**Files:**
- Modify: `README.zh-CN.md:3`

- [ ] **Step 1: Update the badge URL**

Same substitution as Task 2, applied to `README.zh-CN.md`:

Current line:
```
[![Open in Overleaf](https://img.shields.io/badge/Open%20in-Overleaf-47A141?logo=overleaf&logoColor=white)](https://www.overleaf.com/docs?snip_uri=https%3A%2F%2Fgithub.com%2Fwanghao9610%2FarXivTeX%2Farchive%2Frefs%2Fheads%2Fmain.zip)
```

New line:
```
[![Open in Overleaf](https://img.shields.io/badge/Open%20in-Overleaf-47A141?logo=overleaf&logoColor=white)](https://www.overleaf.com/docs?snip_uri=https%3A%2F%2Fgithub.com%2Fwanghao9610%2FarXivTeX%2Farchive%2Frefs%2Fheads%2Foverleaf.zip)
```

- [ ] **Step 2: Verify the change**

Run: `grep -o 'archive%2Frefs%2Fheads%2F[a-z]*\.zip' README.zh-CN.md`
Expected: `archive%2Frefs%2Fheads%2Foverleaf.zip`

- [ ] **Step 3: Commit**

```bash
git add README.zh-CN.md
git commit -m "Point Overleaf badge at overleaf branch (zh-CN)"
```

---

### Task 4: Locally verify the subtree split produces the right layout

This is a read-only dry run against the local repo — no push, and the test branch is deleted afterward. It exists to catch a wrong `--prefix` or unexpected file layout before trusting CI to do it.

**Files:** none (verification only)

- [ ] **Step 1: Run the split locally**

Run: `git subtree split --prefix=main -b overleaf-dry-run-test`
Expected: prints a commit SHA, no errors

- [ ] **Step 2: Inspect the resulting tree**

Run: `git ls-tree -r --name-only overleaf-dry-run-test | sort`
Expected output (paths have no `main/` prefix):
```
algs/00_example.tex
algs/10_procedure.tex
appx.tex
figs/00_teaser.tex
figs/10_figure.tex
figs/srcs/00_teaser.pdf
main.bib
main.cls
main.tex
secs/00_abstract.tex
secs/01_introduction.tex
secs/02_related.tex
secs/03_method.tex
secs/04_experiments.tex
secs/09_conclusion.tex
secs/10_results.tex
secs/11_reproducibility.tex
secs/12_impact.tex
tabs/00_example.tex
tabs/10_extra.tex
```

If any path still starts with `main/`, stop and re-check the `--prefix` value in both this dry run and the workflow file from Task 1 — do not proceed to Task 5 with a wrong prefix.

- [ ] **Step 3: Delete the local test branch**

Run: `git branch -D overleaf-dry-run-test`
Expected: `Deleted branch overleaf-dry-run-test (was <sha>).`

No commit for this task — it's local verification only, nothing to check in.

---

### Task 5: Push and bootstrap the overleaf branch

**This task pushes to the `origin` remote (github.com/wanghao9610/arXivTeX) and creates a new branch there.** Confirm with the user before running Step 1 — this is the point where the change becomes live on GitHub and, once the `overleaf` branch exists, every future push touching `main/**` will force-push to it automatically.

**Files:** none (deployment/verification only)

- [ ] **Step 1: Push `main` to origin**

Run: `git push origin main`
Expected: the design-spec, workflow, and README commits from Tasks 1-3 (and the earlier design-doc commit) appear on `origin/main`.

- [ ] **Step 2: Bootstrap the overleaf branch with a manual run**

The workflow's `paths: ['main/**']` filter means the push in Step 1 won't trigger it (no files under `main/` changed). Trigger it manually once via the GitHub UI, since the `gh` CLI isn't installed in this environment:

1. Open `https://github.com/wanghao9610/arXivTeX/actions/workflows/overleaf-sync.yml`
2. Click "Run workflow", select branch `main`, click the green "Run workflow" button
3. Wait for the run to finish (should take well under a minute)

- [ ] **Step 3: Verify the overleaf branch was created correctly**

Run:
```bash
git fetch origin overleaf
git ls-tree -r --name-only origin/overleaf | sort
```
Expected: the same file list as Task 4 Step 2 (no `main/` prefix, `main.tex` at the root).

- [ ] **Step 4: Verify the badge downloads the right content**

Run:
```bash
curl -sL https://github.com/wanghao9610/arXivTeX/archive/refs/heads/overleaf.zip -o /tmp/overleaf-branch-check.zip
unzip -l /tmp/overleaf-branch-check.zip
```
Expected: the zip's top-level entries are `main.tex`, `main.bib`, `main.cls`, `secs/`, `tabs/`, `algs/`, `figs/`, `appx.tex` — no `.claude/`, `.agents/`, `docs/`, `Makefile`, or `README*.md`.

- [ ] **Step 5: Clean up the local verification artifact**

Run: `rm /tmp/overleaf-branch-check.zip`

---

## Notes for whoever runs this plan

- Tasks 1-4 are fully local and reversible (file edits + local commits + a throwaway local branch). Task 5 is the only one that touches the shared GitHub remote and should not be run without the user's go-ahead at that point, even if earlier tasks were approved in bulk.
- If Task 4's dry run reveals unexpected paths, fix the `--prefix` argument in `.github/workflows/overleaf-sync.yml` (Task 1) before re-running the dry run — don't patch around it in Task 5.
