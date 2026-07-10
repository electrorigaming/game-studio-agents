# La Base de Sky — Game Studio Agent Architecture

Pokémon game development using RPG Maker XP + Pokémon Essentials v21.1/v22.
Managed through coordinated Claude Code agents adapted for La Base de Sky.

## Technology Stack

- **Engine**: RPG Maker XP + Pokémon Essentials v21.1/v22, running on the **mkxp-z** runtime
- **Editors**: RPG Maker XP + Maker Studio (community .rxdata-compatible editor — see `.claude/docs/maker-studio.md`)
- **Language**: Ruby 3.1.3 (RGSS - RPG Game Scripting System) — NOT classic RGSS/Ruby 1.9.3
- **Version Control**: Git with trunk-based development
- **Build System**: RPG Maker XP (Game.exe) + scripts_combine.rb
- **Asset Pipeline**: RPG Maker XP (Graphics/, Audio/) + PBS files
- **Reference Documentation**: `../wiki-la-base-de-sky/wiki_markdown/`

> **Note**: This framework has been adapted from the original Claude Code Game Studios
> to work specifically with La Base de Sky (Pokémon Essentials in Spanish).
> Engine-specific agents for Godot/Unity/Unreal have been disabled and replaced
> with Essentials/Ruby/PBS specialists.

## Project Structure

@.claude/docs/directory-structure.md

## Wiki Reference

@.claude/docs/wiki-reference.md

> **MANDATORY**: Before suggesting implementations, consult the wiki reference above.
> The wiki is the authoritative source for La Base de Sky implementation patterns.

## Technical Preferences

@.claude/docs/technical-preferences.md

## Coordination Rules

@.claude/docs/coordination-rules.md

## Collaboration Protocol

**User-driven collaboration, not autonomous execution.**
Every task follows: **Question -> Options -> Decision -> Draft -> Approval**

- Agents MUST ask "May I write this to [filepath]?" before using Write/Edit tools
- Agents MUST show drafts or summaries before requesting approval
- Multi-file changes require explicit approval for the full changeset
- No commits without user instruction

See `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` for full protocol and examples.

> **First session?** Run `/setup-essentials` to configure the project for La Base de Sky,
> then `/start` to begin the guided onboarding flow.

## Coding Standards

@.claude/docs/coding-standards.md

## Context Management

@.claude/docs/context-management.md

## Guías de comportamiento (Karpathy)

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
