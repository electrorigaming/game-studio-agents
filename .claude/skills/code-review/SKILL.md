---
name: code-review
description: "Performs an architectural and quality code review for La Base de Sky (Pokémon Essentials). Checks for RGSS coding standards, PBS data validation, architectural pattern adherence, memory management, and performance concerns."
argument-hint: "[path-to-file-or-directory]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, Task, AskUserQuestion
model: sonnet
agent: lead-programmer
---

## Phase 1: Load Target Files

Read the target file(s) in full. Read CLAUDE.md for project coding standards.

---

## Phase 2: Identify Essentials Specialists

Read `.claude/docs/technical-preferences.md`, section `## Essentials Specialists`. Note:

- The **Primary** specialist: `essentials-specialist` (used for architecture and broad Essentials concerns)
- The **Ruby/RGSS Specialist**: `ruby-rgss-specialist` (used when reviewing Ruby scripts)
- The **PBS Specialist**: `pbs-compiler-specialist` (used when reviewing PBS data files)
- The **UI Specialist**: `ui-programmer` (used when reviewing MUI/UI code)

If the section reads `[TO BE CONFIGURED]`, run `/setup-essentials` first.

---

## Phase 3: ADR Compliance Check

**Argument:** `/code-review [file(s)]` may optionally include a story file path as the last argument (e.g., `/code-review Plugins/MyPlugin/MyPlugin.rb production/epics/combat/story-001.md`). If a story path is provided, read it to extract the governing ADR reference.

Search for ADR references in, in priority order:
1. The story file (if provided as argument)
2. Header comments at the top of the implementation files
3. Commit messages referencing these files (`git log --oneline -- [file]`)

Look for patterns like `ADR-NNN` or `docs/architecture/ADR-`.

If no ADR references found, note: "No ADR references found — ADR compliance check skipped. For full ADR compliance review, provide the story path: `/code-review [files] [story-path]`."

For each referenced ADR: read the file, extract the **Decision** and **Consequences** sections, then classify any deviation:

- **ARCHITECTURAL VIOLATION** (BLOCKING): Uses a pattern explicitly rejected in the ADR
- **ADR DRIFT** (WARNING): Meaningfully diverges from the chosen approach without using a forbidden pattern
- **MINOR DEVIATION** (INFO): Small difference from ADR guidance that doesn't affect overall architecture

---

## Phase 4: Standards Compliance (RGSS-Specific)

Identify the system category (Essentials architecture, gameplay, UI, plugins, PBS data) and evaluate:

- [ ] Public methods and classes have doc comments
- [ ] Cyclomatic complexity under 10 per method
- [ ] No method exceeds 40 lines (excluding data declarations)
- [ ] Use `alias` for method overriding (no direct monkey-patching)
- [ ] Plugins are self-contained in `Plugins/[PluginName]/[PluginName].rb`
- [ ] All game data from PBS files (no hardcoded values)
- [ ] Use `:SPECIES`, `:MOVE`, `:ITEM` symbols (no numeric IDs)
- [ ] Respect script section ordering

---

## Phase 5: Architecture and Memory Management

**Architecture:**
- [ ] Correct dependency direction (plugins <- core, not reverse)
- [ ] No circular dependencies between modules
- [ ] Proper layer separation (UI does not own game state)
- [ ] Essentials event hooks used when available
- [ ] Consistent with established patterns in the codebase

**Memory Management (CRITICAL for RGSS):**
- [ ] All `Sprite`, `Viewport`, `Window`, `Bitmap` objects are disposed
- [ ] Disposed objects are set to `nil`
- [ ] No orphaned sprites in update loops
- [ ] Proper cleanup in scene transitions

---

## Phase 6: Game-Specific Concerns (Essentials)

- [ ] Use `pbMessage(text)` for dialog (not `print` or `puts`)
- [ ] Use `pbTransferPlayer` for map transfers
- [ ] Use `pbFadeOutIn` for scene transitions
- [ ] Global variables used correctly ($game_player, $game_variables, etc.)
- [ ] No infinite loops in update methods
- [ ] Save/load compatibility (data persists correctly)

---

## Phase 7: PBS Data Validation (if applicable)

If reviewing PBS files:
- [ ] Syntax correct (sections start with `[ID]`, fields are `key = value`)
- [ ] No duplicate IDs
- [ ] All cross-references valid
- [ ] Required fields present
- [ ] Lists comma-separated without spaces

---

## Phase 8: Specialist Reviews (Parallel)

Spawn all applicable specialists simultaneously via Task — do not wait for one before starting the next.

### Essentials Specialists

Determine which specialist applies to each file and spawn in parallel:

- Ruby scripts (`.rb`) → `ruby-rgss-specialist`
- PBS data files (`PBS/*.txt`) → `pbs-compiler-specialist`
- UI/MUI code → `ui-programmer`
- General architecture → `essentials-specialist`
- Shader files (`.gdshader`, `.hlsl`, shader graph) → Shader Specialist
- UI screen/widget code → UI Specialist
- Cross-cutting or unclear → Primary Specialist

Also spawn the **Primary Specialist** for any file touching engine architecture (scene structure, node hierarchy, lifecycle hooks).

### QA Testability Review

For Logic and Integration stories, also spawn `qa-tester` via Task in parallel with the engine specialists. Pass:
- The implementation files being reviewed
- The story's `## QA Test Cases` section (the pre-written test specs from qa-lead)
- The story's `## Acceptance Criteria`

Ask the qa-tester to evaluate:
- [ ] Are all test hooks and interfaces exposed (not hidden behind private/internal access)?
- [ ] Do the QA test cases from the story's `## QA Test Cases` section map to testable code paths?
- [ ] Are any acceptance criteria untestable as implemented (e.g., hardcoded values, no seam for injection)?
- [ ] Does the implementation introduce any new edge cases not covered by the existing QA test cases?
- [ ] Are there any observable side effects that should have a test but don't?

For Visual/Feel and UI stories: qa-tester reviews whether the manual verification steps in `## QA Test Cases` are achievable with the implementation as written — e.g., "is the state the manual checker needs to reach actually reachable?"

Collect all specialist findings before producing output.

---

## Phase 8: Output Review

```
## Code Review: [File/System Name]

### Engine Specialist Findings: [N/A — no engine configured / CLEAN / ISSUES FOUND]
[Findings from engine specialist(s), or "No engine configured." if skipped]

### Testability: [N/A — Visual/Feel or Config story / TESTABLE / GAPS / BLOCKING]
[qa-tester findings: test hooks, coverage gaps, untestable paths, new edge cases]
[If BLOCKING: implementation must expose [X] before tests in ## QA Test Cases can run]

### ADR Compliance: [NO ADRS FOUND / COMPLIANT / DRIFT / VIOLATION]
[List each ADR checked, result, and any deviations with severity]

### Standards Compliance: [X/6 passing]
[List failures with line references]

### Architecture: [CLEAN / MINOR ISSUES / VIOLATIONS FOUND]
[List specific architectural concerns]

### SOLID: [COMPLIANT / ISSUES FOUND]
[List specific violations]

### Game-Specific Concerns
[List game development specific issues]

### Positive Observations
[What is done well -- always include this section]

### Required Changes
[Must-fix items before approval — ARCHITECTURAL VIOLATIONs always appear here]

### Suggestions
[Nice-to-have improvements]

### Verdict: [APPROVED / APPROVED WITH SUGGESTIONS / CHANGES REQUIRED]
```

This skill is read-only — no files are written.

---

## Phase 9: Next Steps

Use `AskUserQuestion`:
- Prompt: "Code review complete — verdict: [APPROVED / CHANGES REQUIRED / MAJOR REVISION]. How would you like to proceed?"
- Options (adjust based on verdict):
  - If APPROVED:
    - `[A] Run /story-done to mark the story complete`
    - `[B] Stop here`
  - If CHANGES REQUIRED or MAJOR REVISION:
    - `[A] Fix the issues and re-run /code-review`
    - `[B] Run /story-done anyway with noted exceptions`
    - `[C] Stop here`

If an ARCHITECTURAL VIOLATION is found:
- If the violation contradicts an **existing ADR**: fix the implementation to comply with `docs/architecture/[adr-file].md`. If the design has legitimately changed, run `/architecture-decision` to formally *revise* the existing ADR — do not create a competing one.
- If **no ADR exists** for the pattern that was violated: run `/architecture-decision` to document the correct approach before fixing the code.
