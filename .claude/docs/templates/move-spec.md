# Move: [Name]

## Basic Info
- **Name**: [English name]
- **Name (Spanish)**: [Spanish name]
- **Type**: [type]
- **Category**: [Physical/Special/Status]
- **Power**: [value or "---"]
- **Accuracy**: [value or "---"]
- **PP**: [value]

## Effect
- **Effect**: [description]
- **Effect Chance**: [percentage or "---"]
- **Target**: [target type]
- **Priority**: [value]

## Flags
- [flag1], [flag2], [flag3]

## PBS Entry
Field names and order verified against real entries in `PBS/moves.txt` (e.g. `[TACKLE]`, `[MEGAHORN]`):
```
[ID]
Name = [name]
Type = [type]
Category = [Physical/Special/Status]
Power = [value — omit entirely for most Status moves, see wiki]
Accuracy = [value, 0 = never misses]
TotalPP = [value]
Target = [target, e.g. NearOther, User]
Priority = [value — omit if 0, the default]
FunctionCode = [effect code, e.g. None, LowerTargetAttack1]
EffectChance = [chance — omit unless the move has a secondary-effect chance]
Flags = [flag1],[flag2],...
Description = [description]
```

## Implementation Notes
- Reference: `../wiki-la-base-de-sky/wiki_markdown/02-Pokemon/02-Movimientos/definir-movimiento.md`
- Check `efectos-movimientos.md` for effect codes
- Test in battle to verify animation and effect work correctly
- Ensure type effectiveness is correct
