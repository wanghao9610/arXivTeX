# convert-template Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a Claude Code Skill and a matching Codex Skill, `convert-template`, that converts the arXivTeX `main/` paper tree into a submission copy for an officially-supplied venue template (CVPR-style or otherwise), in anonymous or camera-ready mode, under `submit/<venue>/`, without ever touching `main/` or `main/main.bib`.

**Architecture:** This is a prompt-engineering deliverable, not application code — the "implementation" is the SKILL.md operator checklist itself (per the approved spec's Workflow section) plus two small repo-hygiene changes (`.gitignore` entries). There is no compiled program to unit test; verification is (a) structural checks that the skill files are complete and internally consistent, and (b) a documented manual smoke test to run whenever a real venue zip is available.

**Tech Stack:** Markdown (SKILL.md format for Claude Code and Codex CLI skills), LaTeX/latexmk (used by the skill at runtime, not by this plan).

---

## Reference: spec

Full design is at `docs/superpowers/specs/2026-07-01-convert-template-design.md`. Read it before starting Task 2 — the Workflow section (steps 1-8) is the authoritative source for what the SKILL.md body must instruct.

## File Structure

- Modify: `.gitignore` — add `templates/` and `submit/`.
- Create: `.claude/skills/convert-template/SKILL.md` — the Claude Code skill body.
- Create: `.codex/skills/convert-template/SKILL.md` — the Codex skill body, same operator checklist, Codex tool names.

Two SKILL.md files are intentionally near-duplicates: Claude Code and Codex are separate tools with separate skill directories and no shared-include mechanism between them, so the existing repo convention (empty `.claude/skills/` and `.codex/skills/` sitting side by side) is mirrored here rather than introducing a shared-template build step for two files.

---

### Task 1: Ignore generated/derived directories

**Files:**
- Modify: `.gitignore`

- [ ] **Step 1: Add the two new entries**

Current content of `.gitignore`:
```
.temp/
arXiv/
```

Change it to:
```
.temp/
arXiv/
templates/
submit/
```

- [ ] **Step 2: Verify git ignores a probe file**

Run:
```bash
mkdir -p templates/probe submit/probe && touch templates/probe/x.zip submit/probe/main.tex
git status --porcelain
```
Expected: no output (both probe files are ignored). Then clean up:
```bash
rm -rf templates/probe submit/probe
```

- [ ] **Step 3: Commit**

```bash
git add .gitignore
git commit -m "Ignore generated templates/ and submit/ directories"
```

---

### Task 2: Write the Claude Code `convert-template` skill

**Files:**
- Create: `.claude/skills/convert-template/SKILL.md`

- [ ] **Step 1: Write the skill file**

```markdown
---
name: convert-template
description: Convert the arXivTeX paper in main/ into a submission copy for an officially-supplied venue LaTeX template (e.g. CVPR, ICCV, NeurIPS). Use when the user provides a venue template zip and asks to convert, reformat, or submit the paper to that venue, in anonymous review or camera-ready mode.
---

# convert-template

Converts the modular arXivTeX paper under `main/` into a standalone,
compilable copy that follows an officially-provided venue LaTeX
template. The user always supplies the official template as a zip —
never fetch, guess, or reconstruct a venue template from memory or the
web. Never modify `main/` or `main/main.bib`; all output goes under
`submit/<venue>/`.

## When to use

Trigger when the user:
- Provides a path to a venue template zip (e.g. a CVPR/ICCV/NeurIPS
  author kit) and asks to convert, reformat, or prepare the paper for
  submission to that venue.
- Asks for an anonymous review draft or a camera-ready version of the
  paper in a specific venue's format.

## Inputs to establish before starting

Ask only what is missing:
1. Path to the venue template zip.
2. Venue name (`<venue>`), if not obvious from the zip filename — used
   as the directory name under `templates/` and `submit/`.
3. Mode: `anonymous` (blind review — no author names, affiliations, or
   identifying links) or `camera-ready` (full author/affiliation/link
   metadata). Ask if not stated.

## Workflow

1. **Unpack.** Extract the zip into `templates/<venue>/`. If a
   directory of that name already exists with different contents,
   confirm with the user before overwriting.
2. **Inspect the target kit.** Read its sample `.tex` file, its
   `.cls`/`.sty`/`.bst` files, and any README/instructions bundled with
   it. Identify:
   - The required `\documentclass` line and options (columns, page
     size).
   - Required packages the kit's own class does not already load.
   - The kit's native title/author/affiliation macros and their exact
     call signatures.
   - The bibliography style the kit expects (bibstyle/bst name).
   - Any anonymous-mode toggle the kit defines (e.g.
     `\iccvfinalcopy`, `\cvprfinalcopy`, a `final` class option).
3. **Scaffold the output directory.** Create `submit/<venue>/`. Copy
   every `.cls`, `.sty`, and `.bst` file from `templates/<venue>/` into
   `submit/<venue>/` byte-for-byte. Never edit an official file's
   contents — if something about it seems wrong, flag it in the final
   report instead of patching it.
4. **Copy paper content unmodified.** Copy, byte-for-byte, into
   `submit/<venue>/`:
   - `main/main.bib`
   - `main/secs/`
   - `main/figs/` (including `main/figs/srcs/`)
   - `main/tabs/`
   - `main/algs/`
   - `main/appx.tex`

   Do not edit any of these files. `.bib` content is never touched,
   per this repo's `CLAUDE.md` — if the venue needs a different
   citation style, that is a `\bibliographystyle{...}` change in the
   generated `main.tex`, not a `.bib` edit.
5. **Generate `submit/<venue>/compat.sty`.** This repo's content files
   use arXivTeX-only macros that the venue class will not define:
   `\parahead`, `\figref`, `\tabref`, `\algref`, `\eqnref`,
   `\tablestyle`, `\cmark`, `\xmark`, and the `x`/`y`/`z`/`P`/`Y`
   compact table column types (all defined in `main/main.cls` — read
   it for exact behavior). Re-implement each one used by the content
   files as plain LaTeX on top of packages the venue class already
   loads (or minimal, widely-available packages like `array`,
   `pifont`, if the venue class doesn't already provide the
   equivalent). This is what lets `secs/`, `figs/`, `tabs/`, `algs/`
   compile unmodified against the new class.
6. **Generate `submit/<venue>/main.tex`.** New entry point built from:
   - The venue's own `\documentclass` line, required packages, and
     `\input{compat.sty}`.
   - Title, author, affiliation, abstract, and keyword values parsed
     out of the existing `main/main.tex` preamble (its
     `\title`/`\author`/`\affiliation`/`\abstract`/`\keywords` calls),
     re-emitted using the venue's own native macros from step 2.
   - The same `\input{secs/...}` order as `main/main.tex`, plus
     `\input{appx.tex}` if the original includes it.
   - `\bibliographystyle{...}` set to whatever the venue kit expects,
     and `\bibliography{main}` pointing at the copied `main.bib`.

   Mode-specific handling:
   - **camera-ready:** real author names, affiliations, and metadata
     links (`\code`, `\project`, `\dataset` values from `main/main.tex`).
   - **anonymous:** replace every author with "Anonymous Author(s)" and
     every affiliation with "Anonymous Institution"; replace
     `\code`/`\project`/`\dataset`/`\demo` URLs with the literal text
     "Link redacted for review"; enable the venue's anonymous-mode
     toggle found in step 2 if one exists.
7. **Build and iterate.** Run `latexmk -pdf` (or the kit's documented
   build command, if different) inside `submit/<venue>/`. Read
   compile errors and fix `compat.sty`/`main.tex` — never patch the
   venue's own `.cls`/`.sty`/`.bst` files to work around an error.
8. **Report.** Tell the user, in plain text:
   - What was auto-mapped (title/author fields, bib style, column
     macros).
   - Anything needing manual attention: page-limit overflow, a
     venue-mandated formatting rule not fully automated, a package the
     venue kit doesn't provide that the content relies on, or any
     content that could not be mapped 1:1.
   - Never silently drop content to make it compile — call out the
     gap instead.

## Guardrails

- Never modify anything under `main/`, including `main/main.bib`.
- Never modify the official venue `.cls`/`.sty`/`.bst` files copied
  into `submit/<venue>/` — if the official files seem to need a
  change, that means `compat.sty` or `main.tex` needs to change
  instead, or the issue belongs in the final report.
- Never fetch a venue template from the web or reconstruct one from
  memory. The user-supplied zip is the only source of truth.
- Re-running this skill after the user edits `main/` fully regenerates
  `submit/<venue>/` (byte-for-byte content, regenerated `main.tex`/
  `compat.sty`). There is no incremental/live sync — say so if asked.
```

- [ ] **Step 2: Verify required sections are present**

Run:
```bash
grep -c '^## ' .claude/skills/convert-template/SKILL.md
```
Expected: `4` (the four `## ` section headings: When to use, Inputs to
establish before starting, Workflow, Guardrails). If the grep prints a
different number, re-check the file for a missing section rather than
assuming the check is wrong.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/convert-template/SKILL.md
git commit -m "Add convert-template Claude Code skill"
```

---

### Task 3: Mirror the skill for Codex

**Files:**
- Create: `.codex/skills/convert-template/SKILL.md`

- [ ] **Step 1: Copy Task 2's file as the starting point**

```bash
mkdir -p .codex/skills/convert-template
cp .claude/skills/convert-template/SKILL.md .codex/skills/convert-template/SKILL.md
```

- [ ] **Step 2: Adjust the frontmatter description if Codex's skill
  frontmatter schema differs**

Read `.codex/skills/` (currently empty except this new file) and any
Codex CLI skill documentation available in this environment. If Codex
skill frontmatter requires different keys than Claude Code's
`name`/`description`, adjust the frontmatter block at the top of
`.codex/skills/convert-template/SKILL.md` to match Codex's schema. If
no Codex-specific schema is discoverable, leave the frontmatter as-is
(the two tools currently accept the same `name`/`description` shape).

The body content (When to use / Inputs / Workflow / Guardrails) does
not reference any Claude-Code-specific tool names, so it does not need
further editing — it is tool-agnostic operator instructions.

- [ ] **Step 3: Verify the two files match in body content**

```bash
diff <(tail -n +2 .claude/skills/convert-template/SKILL.md) <(tail -n +2 .codex/skills/convert-template/SKILL.md)
```
Expected: no output, unless Step 2 made a deliberate frontmatter-only
change — in that case confirm the only diff lines are within the
frontmatter block (between the leading and trailing `---`).

- [ ] **Step 4: Commit**

```bash
git add .codex/skills/convert-template/SKILL.md
git commit -m "Mirror convert-template skill for Codex"
```

---

### Task 4: Document the manual smoke test

**Files:**
- Modify: `docs/superpowers/specs/2026-07-01-convert-template-design.md:98-107` (the existing "Testing / verification" section — confirm it already states the manual smoke test; do not duplicate it elsewhere)

- [ ] **Step 1: Confirm the smoke test is actionable as written**

Read `docs/superpowers/specs/2026-07-01-convert-template-design.md`'s
"Testing / verification" section. It already specifies: run the skill
against a real venue zip in both modes, confirm
`submit/<venue>/main.tex` compiles with `latexmk`, and confirm the
anonymous variant contains no author names/affiliations/identifying
links. No environment in this plan has a real venue zip or a working
TeX installation available, so this step cannot be executed as part of
this plan — it is a follow-up the user runs the next time they have an
actual venue zip in hand.

- [ ] **Step 2: No code change needed**

This task is a confirmation step only. If the spec's testing section
were missing or vague, this task would instead patch it — it is not,
so there is nothing to commit.

---

## Post-implementation check

- [ ] Read back both SKILL.md files once more and confirm neither one
  contains a placeholder like "TBD" or "fill in" (`grep -riE '\bTBD\b|fill in|to be determined' .claude/skills/convert-template/SKILL.md .codex/skills/convert-template/SKILL.md` should print nothing).
- [ ] Confirm `main/`, `main/main.bib` are untouched (`git status` should show no modifications under `main/`).
