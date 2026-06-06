# La Base de Sky — Game Studio Agent Architecture

Pokémon game development using RPG Maker XP + Pokémon Essentials v21.1/v22.
Managed through coordinated Claude Code agents adapted for La Base de Sky.

## Technology Stack

- **Engine**: RPG Maker XP + Pokémon Essentials v21.1/v22
- **Language**: Ruby (RGSS - RPG Game Scripting System)
- **Version Control**: Git with trunk-based development
- **Build System**: RPG Maker XP (Game.exe) + scripts_combine.rb
- **Asset Pipeline**: RPG Maker XP (Graphics/, Audio/) + PBS files
- **Reference Documentation**: wiki-la-base-de-sky/wiki_markdown/

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
