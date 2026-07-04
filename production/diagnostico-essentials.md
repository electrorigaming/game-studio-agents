# Diagnóstico Essentials — Fase 1

**Fecha**: 2026-07-04
**Alcance**: Auditoría de terreno real antes de adaptar agentes/reglas/skills. No se modificó ningún agente, regla ni skill en esta sesión.

## Contexto importante: estado previo del repo

Los commits `6315301` (Fase 2.3), `5b2442f` (Fase 3), `779e872` (Fase 4) y `ba029b4` (Fase 5-6)
ya ejecutaron una adaptación completa bajo el plan anterior (`PLAN-ADAPTACION.md`), **antes** de
que existiera este plan corregido. Esa adaptación acertó en estructura (conteo de agentes, rutas
de wiki) pero **hereda exactamente los errores C1-C4** que este plan existe para corregir, porque
se escribió sin verificar contra fuentes reales. Este diagnóstico documenta los hechos verificados
para que las próximas sesiones (2-5) corrijan sobre ellos en vez de reescribir desde cero.

Hallazgos concretos de contaminación C1-C4 en el estado actual:
- `.claude/agents/ruby-rgss-specialist.md:45,50` y `.claude/rules/ruby-scripts.md:10` afirman
  "Ruby 1.9.3" — **incorrecto**, ver sección 3.
- `.claude/agents/essentials-specialist.md:72` y `.claude/rules/essentials-plugins.md:48,53,59`
  usan `Events.onXYZ` — **API obsoleta**, ver sección 5.
- `.claude/docs/technical-preferences.md` sigue con placeholders `[TO BE CONFIGURED]` sin rellenar
  (Engine, Language, Naming Conventions, etc. todos vacíos).

---

## 1. Auditoría de `.claude/agents/`

Estado actual (ya migrado por el plan anterior, estructura correcta):

- **37 agentes activos** en `.claude/agents/*.md`
- **15 agentes desactivados** en `.claude/agents/disabled/` (5 godot-*, 5 unity-*, 4 ue-*, 1 unreal-specialist)
- Fórmula del plan (49 originales − 15 desactivados + 3 nuevos = 37) **cuadra exactamente**

### Clasificación

**CREADOS (3)** — nuevos, específicos de Essentials:
| Agente | Estado |
|---|---|
| `essentials-specialist.md` | Creado, pero contiene API de eventos obsoleta (línea 72) — necesita corrección puntual, no rehacer |
| `ruby-rgss-specialist.md` | Creado, pero fija Ruby 1.9.3 (líneas 45,50) — necesita corrección puntual |
| `pbs-compiler-specialist.md` | Creado; no se hallaron afirmaciones de sintaxis incorrectas al grep |

**ADAPTADOS (4)** — ya migrados de Godot/Unity/Unreal a Essentials:
| Agente | Estado |
|---|---|
| `lead-programmer.md` | Adaptado, referencia a los 3 especialistas nuevos |
| `level-designer.md` | Adaptado, referencias a RPG Maker XP/05-Mundo |
| `gameplay-programmer.md` | Adaptado, RGSS en vez de GDScript/C# |
| `ui-programmer.md` | Adaptado, MUI en vez de Godot/Unity UI |

**DESACTIVADOS (15)** — correctamente movidos a `disabled/`:
godot-csharp-specialist, godot-gdextension-specialist, godot-gdscript-specialist, godot-shader-specialist,
godot-specialist, ue-blueprint-specialist, ue-gas-specialist, ue-replication-specialist, ue-umg-specialist,
unity-addressables-specialist, unity-dots-specialist, unity-shader-specialist, unity-specialist,
unity-ui-specialist, unreal-specialist

**MANTENIDOS (30)** — agentes genéricos de estudio sin dependencia de motor (game-designer, narrative-director,
writer, producer, qa-lead, qa-tester, etc.) — no requieren cambios.

**Gap adicional detectado (fuera del alcance original de Fase 2)**: `qa-tester.md:74-111` conserva una
tabla de frameworks de testing específica de Godot/Unity/Unreal (`grep -rilE "\bunity\b|\bgodot\b|\bunreal\b"`
solo la marca a ella; los demás matches eran falsos positivos de "comm**unity**"/"**unreal**istic"). No bloquea
nada pero conviene reemplazarla por el equivalente RGSS (no hay test runner formal; ver sección 2/6 herramientas).

---

## 2. Estado de scripts de La Base de Sky

- `../la-base-de-sky/LA BASE DE SKY/Data/Scripts/` **ya existe** con 47 carpetas / cientos de `.rb` — los scripts
  están extraídos y en uso activo (no solo `Scripts.rxdata`).
- `Data/Scripts.rxdata` actual = 576 bytes (stub "loader", esperado cuando ya se extrajo).
- `Data/ScriptsBackup.rxdata` = 1,224,347 bytes (el combinado real, usado como fuente para pruebas).
- **Prueba de extracción**: copié `ScriptsBackup.rxdata` a un entorno aislado (`scratchpad/script-test/`,
  fuera de los 3 repos) y ejecuté `ruby scripts_extract.rb` con Ruby 3.4.9 del sistema.
  - Resultado: **exit 0**, 355 archivos `.rb` en 48 carpetas, `Scripts.rxdata` reemplazado por el stub de 576
    bytes, `ScriptsBackup.rxdata` generado — comportamiento idéntico al del proyecto real.
- **Prueba de combinación**: ejecuté `ruby scripts_combine.rb` sobre esa extracción.
  - Resultado: **exit 0**, `Scripts.rxdata` reconstruido (1,225,313 bytes, diferencia de ~1KB frente al
    original por los IDs aleatorios que asigna `rand(999_999)` a cada sección — no afecta funcionalidad),
    carpeta `Data/Scripts/` eliminada por el propio script (`FileUtils.rm_rf`, comportamiento esperado y
    documentado en el código).
- **Advertencia para skills futuras** (`/extract-scripts`, `/combine-scripts`): `scripts_combine.rb` borra
  la carpeta `Data/Scripts/` al terminar — cualquier skill que lo invoque debe advertir esto antes de ejecutar.

---

## 3. Runtime real

- `mkxp.json` existe en la raíz del proyecto → confirma motor **mkxp-z**, no RGSS clásico.
- `Game.ini` declara `Library=RGSS104E.dll` (dll de compatibilidad heredada de RMXP), pero el ejecutable real
  es `Game.exe` (21 MB, tamaño típico de un build mkxp-z, no del stub RGSS de ~300 KB).
- `grep -a` sobre `Game.exe` encontró los marcadores `mkxp`, `mkxp-z`, `mkxp_kernel_caller_alias`,
  `mkxp_load_alias` → confirma que el ejecutable **es** mkxp-z.
- `grep -a` sobre `x64-msvcrt-ruby310.dll` encontró la cadena `ruby 3.1.3p185` → **la versión real del
  intérprete Ruby es 3.1.3**, no 1.9.3 ni la "3.3.0" que sugiere el nombre de la carpeta
  `Ruby Library 3.3.0` (esa carpeta solo contiene la stdlib empaquetada, su nombre es engañoso).
- `preload.rb` incluye un shim para `Dir.exists?`/`File.exists?` citando el changelog de **Ruby 3.2.0**
  como referencia de la deprecación — consistente con un runtime Ruby 3.x.

**Conclusión para la Sesión 3 (reglas)**: `ruby-scripts.md` debe fijar **Ruby 3.1.3 (mkxp-z)**, no 1.9.3.
Se permite sintaxis Ruby moderna (`->`, `**kwargs`, pattern matching) sujeta a lo que realmente usen los
scripts base — no asumir Ruby 1.8/1.9 clásico.

---

## 4. Inventario PBS

Archivos en `PBS/` (34 archivos + 4 carpetas de respaldo de generación: Gen 5/6/7/8 backup, Shadow Pokémon backup).

Conteo de secciones (`grep -c "^\["`):
- `pokemon.txt`: **1025** secciones
- `moves.txt`: **834** secciones
- `trainers.txt`: **20** secciones

Muestra real de `pokemon.txt` (primeras líneas):
```
[BULBASAUR]
Name = Bulbasaur
Types = GRASS,POISON
BaseStats = 45,49,49,45,65,65
GenderRatio = FemaleOneEighth
GrowthRate = Parabolic
BaseExp = 64
EVs = SPECIAL_ATTACK,1
CatchRate = 45
Happiness = 50
```

Muestra real de `moves.txt`:
```
[MEGAHORN]
Name = Megacuerno
Type = BUG
Category = Physical
Power = 120
Accuracy = 85
TotalPP = 10
Target = NearOther
FunctionCode = None
Flags = Contact,CanProtect,CanMirrorMove
```

Confirma: sintaxis `Clave = Valor`, sin comillas, listas separadas por comas sin espacio, sección `[ID]`
en mayúsculas. Esto coincide con lo que ya declara `.claude/rules/pbs-files.md` — **esa regla no tiene el
error C1**, ya estaba bien derivada.

---

## 5. API vigente (eventos y prefijo Kernel)

Búsqueda en `../la-base-de-sky/LA BASE DE SKY/Data/Scripts/` (scripts reales extraídos):

- `EventHandlers.add(...)`: **68 ocurrencias** — ejemplos reales:
  - `037_Overworld/002_Overworld.rb:5` → `EventHandlers.add(:on_frame_update, :pokerus_counter, ...)`
  - `037_Overworld/002_Overworld.rb:70` → `EventHandlers.add(:on_player_step_taken, :gain_happiness, ...)`
- `Events.onXYZ` (API vieja): **2 ocurrencias**, ambas en **comentarios muertos**, no en código ejecutable
  (`038_Overworld visuals/007_Barras entrenadores.rb:195-196`).
- `pbMessage(...)` sin prefijo: **761 ocurrencias**.
- `Kernel.pbMessage(...)`: **1 ocurrencia** (caso aislado, no el patrón dominante).
- `Kernel.pbShowCommands` / `Kernel.pbMessageDisplay` sí aparecen con prefijo en un puñado de sitios
  (`018_Objects and windows/012_Messages.rb`), pero son la excepción, no la norma.

**Conclusión para Sesión 3**: la API vigente de hooks es `EventHandlers.add(:hook_name, :id, proc {...})`.
La forma dominante de mensaje es `pbMessage(texto)` sin prefijo `Kernel.`.

---

## 6. Hooks en Windows (Git Bash)

Los 12 hooks de `.claude/hooks/` se probaron en dos fases: `bash -n` (chequeo de sintaxis) y ejecución
real con JSON de muestra por stdin donde aplicaba.

| Hook | Sintaxis | Ejecución |
|---|---|---|
| `session-start.sh` | OK | OK (exit 0) |
| `detect-gaps.sh` | OK | OK (exit 0) |
| `notify.sh` | OK | OK (exit 0, dispara toast de Windows vía PowerShell) |
| `log-agent.sh` | OK | OK (exit 0) |
| `log-agent-stop.sh` | OK | OK (exit 0) |
| `pre-compact.sh` | OK | OK (exit 0) |
| `post-compact.sh` | OK | OK (exit 0) |
| `session-stop.sh` | OK | OK (exit 0) |
| `validate-assets.sh` | OK | OK (exit 0) |
| `validate-skill-change.sh` | OK | OK (exit 0) |
| `validate-commit.sh` | OK | OK (exit 0) |
| `validate-push.sh` | OK | OK (exit 0) |

**Los 12 hooks corren limpios bajo Git Bash en Windows.** `ruby` está en el PATH (Ruby 3.4.9 del sistema,
distinto del Ruby 3.1.3 embebido en mkxp-z — ambos coexisten sin conflicto porque `scripts_extract.rb`/
`scripts_combine.rb` solo usan la stdlib de `zlib`/`fileutils`, compatible entre versiones).

---

## Wiki-reference.md (entregable B)

`.claude/docs/wiki-reference.md` ya existía (generado en la Fase 5-6 del plan anterior). Se verificó en
esta sesión con `Glob` sobre `../wiki-la-base-de-sky/wiki_markdown/`: las rutas citadas para
`02-Pokemon` (`definir-especie.md`, `editar-pokemon.md`), `03-Combate` (`combate.md`),
`04-Interfaz` (`mui-interfaz.md`), `05-Mundo` (`eventos.md`), `08-Herramientas`
(`pbs.md`, `scripts-utiles.md`, `secciones-scripts.md`, `compilador.md`) **existen tal cual**.
No requirió reescritura.

---

## Resumen de acciones recomendadas para próximas sesiones

1. **Sesión 2 (agentes)**: no rehacer estructura — solo corregir `essentials-specialist.md:72` (API de
   eventos) y `ruby-rgss-specialist.md:45,50` (versión Ruby) con los hechos de este diagnóstico.
2. **Sesión 3 (reglas)**: corregir `ruby-scripts.md` (Ruby 3.1.3/mkxp-z) y `essentials-plugins.md`
   (`EventHandlers.add`); `pbs-files.md` ya está correcta, no tocar.
3. **Sesión 5**: rellenar `technical-preferences.md` (sigue en placeholders) con los hechos de este
   diagnóstico (Ruby 3.1.3, mkxp-z, RGSS104E.dll como stub legacy).
4. Opcional: actualizar la tabla de frameworks de testing en `qa-tester.md` (Godot/Unity/Unreal → sin
   equivalente formal en RGSS, o referenciar el proceso manual de `Game.exe`).
