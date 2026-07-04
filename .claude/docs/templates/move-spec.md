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
```
[[ID]]
Name = [name]
Type = [type]
Category = [Physical/Special/Status]
Power = [value]
Accuracy = [value]
PP = [value]
Effect = [effect code]
EffectChance = [chance]
Target = [target]
Priority = [priority]
Flags = [flags]
Description = [description]
```

## Implementation Notes
- Reference: `../wiki-la-base-de-sky/wiki_markdown/02-Pokemon/02-Movimientos/definir-movimiento.md`
- Check `efectos-movimientos.md` for effect codes
- Test in battle to verify animation and effect work correctly
- Ensure type effectiveness is correct
