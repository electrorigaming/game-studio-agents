---
name: custom-extension
description: Implement a feature, UI redesign, or minigame that isn't documented in the official La Base de Sky wiki — researches community sources, implements via the right specialist, and logs a reusable record without requiring a full framework adaptation pass
argument-hint: "[idea o funcionalidad]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, WebSearch, WebFetch, Task, AskUserQuestion
model: sonnet
---

# Custom Extension

Implement something Pokémon Essentials / La Base de Sky can technically support but that isn't
covered by the official wiki — a new feature, a UI redesign, a minigame, or any community-style
addition. This skill is the entry point specifically because it has web access
(`WebSearch`/`WebFetch`); the specialist agents it delegates to (`ruby-rgss-specialist`,
`ui-programmer`, `level-designer`, etc.) intentionally do not, so they never invent
implementation details from generic training data.

## Why this exists

The framework's core discipline is "the wiki is law" — but the wiki only covers what La Base de
Sky's maintainers have documented. Real fangame development constantly needs things the wiki
doesn't cover: a community plugin, a custom minigame, a UI overhaul. This skill lets you build
those things now, with the same anti-hallucination rigor (verify against real sources, don't
guess), without waiting for a full adaptation session to fold new knowledge into the permanent
agents/rules/wiki-reference.md.

## Workflow

### 1. Confirm it's genuinely not in the official wiki
- Check `.claude/docs/wiki-reference.md` for the relevant domain.
- If it plausibly IS covered, stop and route to the normal specialist instead (don't duplicate
  this skill's research for something the wiki already documents).

### 2. Check for prior art
- Read `docs/custom-extensions/INDEX.md`. If this or something close was already built/researched,
  read its full record instead of re-researching from scratch — extend or reference it.

### 3. Check for user-supplied materials first
- Glob `docs/custom-extensions/incoming/` for a folder matching `[idea o funcionalidad]` (or close
  to it). The user may have already dropped a link, markdown notes, or actual `.rb` script files
  there (see `docs/custom-extensions/incoming/README.md` for the convention) instead of just
  describing the idea in conversation.
- If material exists: read `notas.md` for the source URL/description, read any pasted `.md`
  reference, and read any files under `scripts/` to understand what's actually in them. Treat
  this as the primary source — verify it (it's still real material to check against, not to
  blindly trust), and skip straight to step 4 unless it's incomplete or you need more context,
  in which case supplement with step 3b.
- If no folder exists for this idea, ask the user: "¿Tienes ya un enlace, notas o scripts para
  esto? Si es así, puedo revisarlos si los dejas en `docs/custom-extensions/incoming/[nombre]/`
  antes de que yo busque por mi cuenta." Give them the chance to supply a source before you
  search — a source they already vetted is better than a fresh web search.

### 3b. Research community sources (if nothing was supplied)
- `WebSearch` for the feature against Pokémon Essentials v21.1 specifically (version matters —
  older/newer Essentials versions have different APIs). Good sources: Relic Castle forums,
  PokéCommunity, GitHub (search for Essentials plugin repos).
- `WebFetch` the most relevant results — plugin READMEs, forum threads with code samples.
- If nothing credible turns up, say so explicitly and ask the user how they want to proceed
  (build from scratch based on adjacent verified patterns, or drop it) — do not fabricate a
  plausible-sounding API.

### 4. Propose before implementing
Follow the project's standard collaboration protocol:
- Present what you found (sources, the approach you'd take, trade-offs)
- Ask clarifying/design questions via `AskUserQuestion` where the community source leaves
  choices open
- Get the user's direction before writing any code

### 5. Delegate implementation
Use `Task` to hand the actual implementation to the right specialist, passing along the
research findings (sources, code patterns, file locations) as full context — the specialist
doesn't have web access, so this skill must give it everything it needs:
- Ruby scripts / plugins → `ruby-rgss-specialist`
- UI / MUI screens → `ui-programmer`
- Maps / minigame world design → `level-designer`
- PBS data → `pbs-compiler-specialist`
- Cross-cutting architecture → `essentials-specialist`

The specialist still follows its own approval-before-write protocol.

### 6. Log the extension record
Once implemented (or once the user decides not to proceed, if the record is still worth keeping
for future reference):
1. Use `.claude/docs/templates/custom-extension-record.md` as the template.
2. Write it to `docs/custom-extensions/[slug].md` (ask before writing, as always).
3. Append a row to `docs/custom-extensions/INDEX.md`.
4. Explicitly tell the user this is a **local record, not yet part of the permanent
   framework** — folding it into `wiki-reference.md`, a rule, or an agent's default knowledge
   is a deliberate future decision (like a mini version of the adaptation sessions in
   `design/PLAN-IMPLEMENTACION-CC.md`), not automatic. Flag whether it looks like a good
   candidate for that in the record's "Candidato para contribución/inclusión permanente" section.

## What this skill must NOT do
- Never claim something is "standard Essentials behavior" without a verified source (wiki or a
  fetched community source) — if uncertain, say so.
- Never skip logging the record, even for small extensions — the whole point is that future
  agents (and future sessions) can find what already exists instead of re-researching it.
- Never grant the underlying specialist agents web access as a workaround — route all research
  through this skill so there's one place new external knowledge enters the project.

## Reference
- `docs/custom-extensions/INDEX.md` — what's already been built
- `docs/custom-extensions/incoming/` — raw materials the user already supplied (links, notes, scripts) not yet implemented
- `.claude/docs/templates/custom-extension-record.md` — the record template
- `.claude/docs/wiki-reference.md` — check this first; don't duplicate official coverage
