# Verificación Fase 7 — Adaptación Essentials

**Fecha**: 2026-07-04/05
**Alcance**: Batería de 8 pruebas del plan de implementación, ejecutadas contra el proyecto real
(`la-base-de-sky`) y el framework (`game-studio-agents`), no simuladas.

---

## Resumen de veredictos

| # | Prueba | Veredicto |
|---|--------|-----------|
| 1 | Conocimiento de agentes | ✅ PASS |
| 2 | Referencia obligatoria a la wiki | ✅ PASS |
| 3 | Golden path E2E | ✅ PASS (tras corregir 1 bug real encontrado en el proceso) |
| 4 | Ciclo de scripts (extract/combine) | ✅ PASS |
| 5 | Detección de formato PBS malo | ✅ PASS |
| 6 | Protocolo de colaboración | ✅ PASS |
| 7 | Hooks en Windows/Git Bash | ✅ PASS |
| 8 | Auditoría AgentShield | ✅ PASS (0 hallazgos reales; 9 "altos" eran falsos positivos) |

**Las 8 pruebas en verde.** El proceso de verificación encontró y corrigió, en el camino,
más contaminación heredada del plan anterior de la que había detectado en las Sesiones 2-5
(ver sección "Hallazgos adicionales" — plugin structure, campos PBS inventados en `pbs-files.md`
y `pbs-compiler-specialist.md`, y un bug real de tipo de entrenador confirmado contra el
compilador PBS real).

---

## 1. Conocimiento de agentes

Se lanzó `essentials-specialist` (vía subagente real, no simulado) con 3 preguntas conceptuales.

- **Evolución por objeto**: respondió correctamente citando `evolucion.md`, con el campo real
  `Evolutions`/`Evolution` y ejemplos reales (Raichu, Eevee).
- **Hook de entrada a mapa**: el agente fue **honesto sobre la incertidumbre** — no encontró
  `Events.onMapSceneChange` en ninguna página de la wiki, señaló que sus propias reglas de
  proyecto lo mencionaban sin verificación, y recomendó verificar contra el código fuente en
  vez de inventar la firma. Esto es exactamente el comportamiento deseado.
- **Estructura de plugins**: detectó una discrepancia real entre las reglas del proyecto
  (`PluginManager.register(...)`) y la wiki (formato `meta.txt`) — hallazgo que llevó a una
  corrección real (ver sección de hallazgos adicionales).

**Veredicto: PASS.** El agente cita fuentes, y cuando algo no está documentado, lo dice en vez
de inventar — el comportamiento anti-alucinación funciona incluso mejor de lo esperado.

## 2. Referencia obligatoria + 6. Protocolo de colaboración

Se pidió a `gameplay-programmer` "añade un movimiento que drene PP al golpear" sin más contexto.

- Consultó la wiki (`definir-movimiento.md`, `efectos-movimientos.md`) Y el código fuente real,
  encontrando precedentes exactos (Rencor/Spite, Conjuro Funesto/Eerie Spell) con archivo y línea.
- Formuló 7 preguntas de diseño concretas antes de proponer nada.
- Confirmó explícitamente que preguntaría "¿Puedo escribir esto en [archivo]?" antes de usar
  Write/Edit — **no escribió ni editó ningún archivo**.

**Veredicto: PASS** para ambas pruebas.

## 3. Golden path E2E

Ejecutado en el proyecto real, no simulado:

1. `/setup-essentials` — instalación verificada, CLAUDE.md/technical-preferences.md ya correctos.
2. `/brainstorm` abreviado (mini-concepto: Pokémon Bicho/Planta de bosque) — el brainstorm
   completo (6 fases con gates de directores) se consideró desproporcionado para una prueba
   de verificación y se acordó con el usuario abreviarlo.
3. Contenido creado en el PBS real: `[HOJARRON]` (pokemon.txt), `[POLVOHOJAS]` (moves.txt),
   `[BUGCATCHER,Kip]` (trainers.txt).
4. `/validate-pbs all` → 0 errores.
5. `Game.exe debug` → **el compilador PBS real rechazó el entrenador**:
   `RuntimeError: Valor BUGCATCHER_Kip no definido en GameData::TrainerType`.
6. Depuración sistemática (root cause): el ID de entrenador `[BUGCATCHER_Kip,Kip]` inventaba un
   tipo de entrenador por instancia, generalizando incorrectamente el patrón `LEADER_Brock`
   (válido porque cada líder de gimnasio SÍ tiene su propio tipo dedicado) a una clase genérica
   (Cazabichos), que en realidad comparte un único tipo `[BUGCATCHER]` para todos sus miembros.
7. Corregido → `/validate-pbs` sigue en 0 errores → `Game.exe debug` relanzado → **el usuario
   confirmó visualmente que Hojarrón aparece en el menú de debug con su información correcta**.
8. Contenido de prueba revertido en `la-base-de-sky` (`git checkout`) tras la validación — no
   era diseño real, solo prueba de pipeline.

**Hallazgo operativo, no un bug**: `Game.exe` debe lanzarse con el argumento `debug` en el primer
arranque (o mientras `Data/PluginScripts.rxdata` no exista), o `PluginManager.needCompiling?`
devuelve `false` sin comprobar si el archivo existe, y `load_data` falla. Documentado en
`wiki_markdown/08-Herramientas/debug.md:38-39`.

**Veredicto: PASS.** El pipeline completo funciona; el bug de tipo de entrenador que encontró
es exactamente el tipo de error que `/validate-pbs` debía prevenir — y ahora lo previene
(se añadió la verificación cruzada al validador, ver `scripts/validate_pbs.rb`).

## 4. Ciclo de scripts

`/extract-scripts` ejecutado directamente contra el proyecto real (con aprobación explícita,
ya que el clasificador de modo automático lo bloqueó por precaución al no saber que el resultado
era un no-op seguro). Resultado: `"Scripts appear to already be extracted. Skipping extraction."`,
exit 0, `Data/Scripts/` intacto (47 carpetas, sin cambios). Ya se había probado el ciclo completo
extract→combine en un entorno aislado durante la Fase 1.

**Veredicto: PASS.**

## 5. Detección de formato PBS malo

Se pidió a `pbs-compiler-specialist` revisar un Pokémon con 4 violaciones deliberadas (7 valores
en `BaseStats`, sintaxis `Key: Value`, espacio tras coma en `Abilities`, y campo `Evolution` con
especie inexistente). El agente detectó las 4, explicó la causa y corrección de cada una, y
señaló correctamente el problema de integridad referencial (especie de evolución inexistente)
sin escribir ningún archivo.

**Veredicto: PASS.**

## 7. Hooks en Windows/Git Bash

Los 12 hooks re-confirmados limpios (ya verificados exhaustivamente en la Fase 1): sintaxis
POSIX válida y ejecución sin errores bajo Git Bash.

**Veredicto: PASS.**

## 8. Auditoría AgentShield

`npx ecc-agentshield scan` → Grade C (60/100), 0 críticos, 9 altos, 30 medios.

Se verificó manualmente el contexto real de los 9 hallazgos "altos" contra el archivo fuente:
**los 9 son falsos positivos** de un escáner de patrones sin comprensión semántica — 6 son
coincidencias de texto ingenuas ("backward through Dynamics to Mechanics" es jerga del framework
MDA, no texto invertido; "Skip validation" está dentro de una prohibición explícita, no es una
instrucción maliciosa), y 3 son patrones de shell normales (`&` no bloqueante para un toast de
Windows, `> /dev/null 2>&1` para silenciar `json.tool` cuando solo importa el exit code).

De los 30 "medios", 27 son la heurística genérica "archivo de agente >5000 caracteres". De las
3 sugerencias sustantivas restantes, se aplicaron las 2 de costo cero (deny de `ssh` y de
escritura a `/dev/`); la tercera no aplicaba (se refería a `settings.local.json`, un override
local del usuario que hereda la seguridad del `settings.json` principal).

**Veredicto: PASS** (sin hallazgos de seguridad reales; 2 mejoras de endurecimiento aplicadas).

---

## Hallazgos adicionales corregidos durante esta fase

Ninguno de estos estaba en el alcance original de la batería de 8 pruebas, pero surgieron al
ejecutarlas de verdad en vez de darlas por buenas:

1. **Estructura de plugins incorrecta** (`essentials-plugins.md`, `ruby-rgss-specialist.md`):
   describían el formato genérico de Essentials (`PluginManager.register(...)`) en vez del
   formato real de La Base de Sky (`meta.txt` + N archivos `.rb`), verificado contra
   `wiki_markdown/08-Herramientas/plugins.md`.
2. **Campos PBS inventados que sobrevivieron a la Fase 3** (`pbs-files.md`,
   `pbs-compiler-specialist.md`): sintaxis `Key: Value` en 3 lugares, y nombres de campo
   (`EVYield`, `GenderRate`, `BaseEXP`, `StepsToHatch`, `Kind`, `PP`, `Effect`, `Evolves`) que
   no existen en el PBS real — no se habían detectado en la Fase 3 porque solo se revisó el
   bloque de ejemplo principal de cada archivo, no el resto del contenido.
3. **Bug de tipo de entrenador inventado** (`trainer-spec.md`, `pbs-compiler-specialist.md`):
   confirmado contra el compilador PBS real durante el golden path E2E — ver sección 3 arriba.
4. **Caso "no es un bug"**: un subagente sugirió renombrar `Evolution` → `Evolutions` citando
   la wiki. Verificado contra el compilador real (`Data/Scripts/026_PBS data/009_Species.rb:
   108-109`): ambas formas son alias válidos. Documentado en `pbs-files.md` para que futuros
   agentes no lo "corrijan" innecesariamente.

---

## Cierre

Todas las correcciones de esta fase están comiteadas (`6ac9d76`, `3bf6f09`, `a6bbaab`). El
contenido de prueba del golden path se revirtió en `la-base-de-sky` tras la validación.

**Checkpoint Spec-Kit** (pendiente, per el plan Parte 3): decidir si se adopta Spec-Kit para la
primera feature grande del juego (p. ej. un sistema de misiones o un minijuego), donde
`constitution → spec → clarify → tasks → implement` aportaría trazabilidad real. No evaluado en
esta sesión — queda como decisión abierta para cuando surja esa primera feature grande.
