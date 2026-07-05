---
name: editor-guide
description: Step-by-step instructions for tasks that require the RPG Maker XP editor GUI (Database, Map Editor) instead of a text file or script
argument-hint: "[tarea]"
user-invocable: true
allowed-tools: Read, Glob, Grep
model: sonnet
---

# Editor Guide

Give the user step-by-step instructions for a task that lives in the RPG Maker XP editor's GUI
(Database, Map Editor, event placement) rather than in a text file, PBS entry, or Ruby script.
This skill never writes or edits any file — it only produces instructions for the user to follow
in RPG Maker XP themselves.

## Workflow

### 1. Identify the task
- Read `.claude/docs/rpgmaker-editor-guide.md` for the task→editor-location→wiki-page reference table.
- Match `[tarea]` (the argument) against the table. If ambiguous or not listed, ask the user to
  clarify what they're trying to do rather than guessing.

### 2. Read the source
- Read the wiki page(s) the reference table points to (`../wiki-la-base-de-sky/wiki_markdown/...`)
  for the authoritative step-by-step process. Do not invent steps from memory or generic RPG
  Maker XP knowledge — this project's exact menu paths and field names come from the wiki.

### 3. Give instructions
Follow the instruction pattern from `.claude/docs/rpgmaker-editor-guide.md`:
- Numbered steps, specific menu paths and keyboard shortcuts (e.g. `F9` for Database)
- Name the exact tab/field the user needs
- End with "cuando termines, avísame" if there's a follow-up text/PBS/script step this session
  should do afterward (e.g. linking an animation to a move in `moves.txt`)

### 4. Handle the follow-up
If the task has a text/PBS/script counterpart (e.g. an animation needs a matching `moves.txt`
entry, a new tileset needs `map_metadata.txt` updates), wait for the user to confirm they
completed the editor steps, then continue with that part using the normal collaboration
protocol (draft → approve → write).

## What this skill must NOT do
- Never attempt to write or patch `.rxdata` files directly (Animations.rxdata, Tilesets.rxdata,
  Map*.rxdata, System.rxdata) — these are binary editor-managed files.
- Never guess at RPG Maker XP's UI from generic training-data knowledge when the wiki documents
  this project's actual version/menu layout — read the wiki page first.

## Reference
- `.claude/docs/rpgmaker-editor-guide.md` — task → editor location → wiki page table
- `../wiki-la-base-de-sky/wiki_markdown/01-Inicio/01-Inicio/instalacion.md` — opening the project
