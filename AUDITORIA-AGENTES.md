# Auditoría de Agentes

Clasificación de los 49 agentes del framework para adaptación a La Base de Sky.

## Resumen

| Categoría | Cantidad |
|-----------|----------|
| Agentes a desactivar | 15 |
| Agentes a mantener | 34 |
| Agentes a crear | 3 |
| **Total** | **52** (49 actuales + 3 nuevos) |

---

## Agentes a DESACTIVAR (15)

Estos agentes son específicos de motores que no usamos (Godot, Unity, Unreal).
Se moverán a `.claude/agents/disabled/`.

### Godot (5)
- godot-specialist.md
- godot-gdscript-specialist.md
- godot-shader-specialist.md
- godot-gdextension-specialist.md
- godot-csharp-specialist.md

### Unity (5)
- unity-specialist.md
- unity-dots-specialist.md
- unity-shader-specialist.md
- unity-addressables-specialist.md
- unity-ui-specialist.md

### Unreal (5)
- unreal-specialist.md
- ue-blueprint-specialist.md
- ue-gas-specialist.md
- ue-replication-specialist.md
- ue-umg-specialist.md

---

## Agentes a MANTENER (34)

Estos agentes son genéricos o adaptables a La Base de Sky.
Algunos necesitarán adaptación para trabajar con RPG Maker XP / Pokémon Essentials.

### Directores y Leads (7)
- creative-director.md
- technical-director.md
- producer.md
- lead-programmer.md ⚠️ (necesita adaptación)
- art-director.md
- audio-director.md
- narrative-director.md

### Programadores (8)
- engine-programmer.md ⚠️ (necesita adaptación)
- gameplay-programmer.md ⚠️ (necesita adaptación)
- ai-programmer.md
- network-programmer.md
- tools-programmer.md
- ui-programmer.md ⚠️ (necesita adaptación)
- systems-designer.md
- level-designer.md ⚠️ (necesita adaptación)

### Diseño (5)
- game-designer.md
- economy-designer.md
- systems-designer.md
- ux-designer.md
- world-builder.md

### QA y Testing (3)
- qa-lead.md
- qa-tester.md
- performance-analyst.md

### Arte y Audio (3)
- technical-artist.md
- sound-designer.md
- accessibility-specialist.md

### Producción y Operaciones (5)
- release-manager.md
- devops-engineer.md
- live-ops-designer.md
- community-manager.md
- analytics-engineer.md

### Otros (3)
- localization-lead.md
- security-engineer.md
- prototyper.md
- writer.md

---

## Agentes a CREAR (3)

Nuevos agentes específicos para La Base de Sky.

### essentials-specialist.md
- **Rol**: Especialista en arquitectura Pokémon Essentials
- **Responsabilidades**:
  - Conocer la estructura de Pokémon Essentials v21.1/v22
  - Guiar en el uso de scripts RGSS
  - Entender el sistema de PBS (PBS files)
  - Conocer las particularidades de La Base de Sky
- **Referencias**: wiki-la-base-de-sky/wiki_markdown/

### ruby-rgss-specialist.md
- **Rol**: Especialista en Ruby y RGSS (RPG Maker XP Scripting System)
- **Responsabilidades**:
  - Escribir y revisar código Ruby/RGSS
  - Conocer las limitaciones de RGSS
  - Optimizar scripts para RPG Maker XP
  - Crear plugins compatibles
- **Referencias**: wiki-la-base-de-sky/wiki_markdown/08-Herramientas/

### pbs-compiler-specialist.md
- **Rol**: Especialista en formato PBS y compilación
- **Responsabilidades**:
  - Validar sintaxis de archivos PBS
  - Conocer la estructura de cada archivo PBS
  - Detectar errores en datos de Pokémon, movimientos, etc.
  - Guiar en la creación de datos PBS
- **Referencias**: wiki-la-base-de-sky/wiki_markdown/08-Herramientas/pbs.md

---

## Próximos Pasos

1. Mover 15 agentes a `.claude/agents/disabled/`
2. Crear 3 nuevos agentes especializados
3. Adaptar 6 agentes que necesitan cambios (marcados con ⚠️)
4. Actualizar `.claude/settings.json` si es necesario
