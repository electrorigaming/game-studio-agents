# Guía de Uso — game-studio-agents (adaptado para La Base de Sky)

> **Versión navegable (Artifact)**: https://claude.ai/code/artifact/1e1fe080-8828-4eab-84d5-8cb93210a655
> — mismo contenido, con índice lateral fijo y navegación por sección.

**Estado actual del proyecto** (2026-07-05): el framework está completamente adaptado y
verificado (ver `production/verificacion-fase7.md`), pero el juego en sí **todavía no está
diseñado** — no existe `design/gdd/game-concept.md`, no hay GDDs, no hay sprints. Estás en el
punto de partida: el siguiente comando útil es `/brainstorm`.

Esta guía explica: (1) los conceptos básicos de cómo funciona el framework, (2) el protocolo de
colaboración, (3) el catálogo completo de agentes, (4) el catálogo completo de skills, y (5) el
paso a paso recomendado para diseñar y construir tu juego con La Base de Sky.

---

## 1. Conceptos básicos

El framework tiene 4 piezas que trabajan juntas:

| Pieza | Qué es | Dónde vive | Se activa |
|-------|--------|------------|-----------|
| **Skills** | Flujos de trabajo guiados, paso a paso (crear un GDD, validar PBS, planear un sprint...) | `.claude/skills/[nombre]/SKILL.md` | Escribiendo `/nombre-skill` |
| **Agentes** | Especialistas con un rol fijo (diseñador, programador Ruby, QA...) que un skill o tú invocáis para una tarea concreta | `.claude/agents/[nombre].md` | Automáticamente cuando un skill los necesita, o pidiéndomelo directamente ("usa el agente X para...") |
| **Reglas** | Estándares de código/datos que se activan solas cuando tocas cierto tipo de archivo (p. ej. `PBS/*.txt`) | `.claude/rules/[nombre].md` | Automático, según el archivo que se esté editando |
| **Hooks** | Scripts que corren en momentos fijos (antes de un commit, al iniciar sesión...) — auditoría y seguridad, no los invocas tú | `.claude/hooks/*.sh` | Automático |

**Tú normalmente solo interactúas con los skills** (escribiendo `/algo`). Los skills deciden
internamente qué agente especialista necesitan y lo invocan por ti.

### Especialistas propios de La Base de Sky

Estos 3 agentes son específicos de esta adaptación (no existen en el framework genérico) y
son el corazón técnico del proyecto:

- **`essentials-specialist`** — arquitectura de Pokémon Essentials, PBS, RPG Maker XP. El agente
  principal para casi todo lo técnico.
- **`ruby-rgss-specialist`** — código Ruby/RGSS, plugins, scripts. Runtime real: **mkxp-z, Ruby
  3.1.3** (no la versión clásica 1.9.3 de RPG Maker XP).
- **`pbs-compiler-specialist`** — sintaxis PBS, validación de datos, referencias cruzadas.

---

## 2. Protocolo de colaboración (siempre activo)

Todo agente en este proyecto sigue: **Pregunta → Opciones → Decisión → Borrador → Aprobación**.

- Nunca escriben un archivo sin antes preguntarte "¿Puedo escribir esto en [archivo]?"
- Te muestran el borrador o resumen antes de pedir aprobación
- Cambios que tocan varios archivos piden aprobación del conjunto completo
- Nadie hace commit sin que tú lo pidas explícitamente

Esto ya se verificó funcionando en la Fase 7 (ver `production/verificacion-fase7.md`, prueba 6).

---

## 3. Catálogo de agentes (37 activos)

### Liderazgo y coordinación
| Agente | Rol |
|--------|-----|
| `producer` | Planificación de sprints, hitos, riesgos, coordinación entre departamentos |
| `creative-director` | Máxima autoridad creativa — visión, tono, resuelve conflictos de diseño |
| `technical-director` | Decisiones técnicas de alto nivel, arquitectura, evaluación de riesgo técnico |

### Diseño de juego
| Agente | Rol |
|--------|-----|
| `game-designer` | Mecánicas core, progresión, combate, economía, reglas del juego |
| `systems-designer` | Diseño detallado de subsistemas — fórmulas de combate, curvas, crafteo |
| `economy-designer` | Economías de recursos, loot, mercados internos |
| `narrative-director` | Arquitectura de historia, worldbuilding, personajes (dirección, no texto final) |
| `world-builder` | Lore detallado — facciones, culturas, historia, geografía |
| `writer` | Diálogos, descripciones de objetos/habilidades, texto final del juego |
| `ux-designer` | Flujos de experiencia, interacción, accesibilidad, mapas de navegación |
| `accessibility-specialist` | Estándares de accesibilidad — remapeo, escalado de texto, daltonismo |

### Ingeniería Essentials/RGSS (específico de La Base de Sky)
| Agente | Rol |
|--------|-----|
| `lead-programmer` | Arquitectura de código, estándares, code review, asigna trabajo a los 3 de abajo |
| `essentials-specialist` | Ver sección 1 |
| `ruby-rgss-specialist` | Ver sección 1 |
| `pbs-compiler-specialist` | Ver sección 1 |
| `engine-programmer` | Sistemas core RGSS (scene management, memoria, arquitectura de scripts) |
| `gameplay-programmer` | Mecánicas de batalla, encuentros, gestión de Pokémon, features interactivas |
| `ui-programmer` | Menús, HUD, Pokédex, mochila, PC — usando MUI (Modular UI) |
| `level-designer` | Mapas, tilesets, eventos, encuentros para RPG Maker XP |
| `ai-programmer` | IA de batalla, pathfinding de NPCs |
| `tools-programmer` | Herramientas internas de desarrollo, utilidades de debug |
| `performance-analyst` | Perfilado de rendimiento, cuellos de botella |
| `devops-engineer` | Pipeline de build, CI/CD, flujo de versionado |
| `security-engineer` | Anti-cheat, seguridad de partidas guardadas |
| `network-programmer` | Multijugador — **probablemente no aplica**: el proyecto está configurado como PC single-player (ver `technical-preferences.md`) |

### Arte y audio
| Agente | Rol |
|--------|-----|
| `art-director` | Identidad visual, guía de estilo, estándares de assets |
| `audio-director` | Dirección musical, filosofía de sonido |
| `technical-artist` | Puente arte/ingeniería — VFX, optimización visual (nota: sin pipeline de shaders en RGSS) |
| `sound-designer` | Especificaciones detalladas de efectos de sonido |

### QA y lanzamiento
| Agente | Rol |
|--------|-----|
| `qa-lead` | Estrategia de testing, triage de bugs, gates de calidad |
| `qa-tester` | Casos de prueba, reportes de bugs detallados |
| `release-manager` | Checklists de certificación, coordinación del día de lanzamiento |

### Producción y post-lanzamiento
| Agente | Rol |
|--------|-----|
| `prototyper` | Prototipos desechables — valida si una idea es divertida antes de diseñar a fondo |
| `live-ops-designer` | Contenido post-lanzamiento, eventos, retención |
| `community-manager` | Comunicación con jugadores, patch notes, redes |
| `localization-lead` | Traducción, gestión de strings |
| `analytics-engineer` | Telemetría, tracking de comportamiento del jugador |

---

## 4. Catálogo de skills (80 disponibles)

### Arranque y diagnóstico
| Skill | Qué hace |
|-------|----------|
| `/start` | Onboarding guiado — pregunta dónde estás y te dirige al flujo correcto |
| `/setup-essentials` | Configura el proyecto para La Base de Sky (ya ejecutado) |
| `/setup-engine` | Redirige a `/setup-essentials` en este proyecto |
| `/project-stage-detect` | Analiza el estado del proyecto y sugiere próximos pasos |
| `/help` | Analiza tu situación actual y aconseja qué hacer después |
| `/onboard` | Genera un documento de onboarding para un nuevo colaborador o agente |

### Diseño de concepto (fase Concept)
| Skill | Qué hace |
|-------|----------|
| `/brainstorm [hint\|open]` | Ideación guiada completa — 6 fases, pilares, gates de directores. Produce `game-concept.md` |
| `/art-bible` | Especificación de identidad visual — hazlo justo después del brainstorm, antes de los GDDs |
| `/prototype [mecánica]` | Prototipo desechable (1-3 días) para validar que la idea es divertida antes de diseñar a fondo |
| `/map-systems` | Descompone el concepto en sistemas individuales, mapea dependencias |
| `/design-system [sistema]` | Autoría guiada de un GDD por sistema — incluye plantilla "PBS Entry" |
| `/quick-design` | Spec ligera para cambios pequeños (no requiere GDD completo) |
| `/design-review [ruta]` | Valida completitud e implementabilidad de un GDD |
| `/review-all-gdds` | Revisión cruzada de consistencia entre todos los GDDs |
| `/gate-check` | Verifica si estás listo para avanzar de fase (PASS/CONCERNS/FAIL) |

### Arquitectura técnica
| Skill | Qué hace |
|-------|----------|
| `/create-architecture` | Blueprint maestro de arquitectura a partir de GDDs |
| `/architecture-decision` | Crea un ADR (Architecture Decision Record) |
| `/architecture-review` | Valida cobertura de arquitectura contra todos los GDDs |
| `/create-control-manifest` | Reglas accionables por sistema/capa para programadores |
| `/propagate-design-change` | Cuando cambia un GDD, identifica qué ADRs quedan obsoletos |

### Preproducción y UX
| Skill | Qué hace |
|-------|----------|
| `/ux-design` | Spec de pantalla/flujo/HUD guiada |
| `/ux-review` | Valida un spec de UX |
| `/vertical-slice` | Build de calidad de producción para validar el loop completo antes de Producción |
| `/playtest-report` | Plantilla o análisis de sesión de playtest |

### Planificación y sprints
| Skill | Qué hace |
|-------|----------|
| `/create-epics` | Traduce GDDs + arquitectura en epics |
| `/create-stories [epic]` | Descompone un epic en historias implementables |
| `/story-readiness` | Verifica si una historia está lista para implementar |
| `/sprint-plan` | Genera o actualiza el plan de sprint |
| `/sprint-status` | Chequeo rápido de progreso del sprint actual |
| `/estimate` | Estima esfuerzo de una tarea |
| `/scope-check` | Detecta scope creep comparando contra el plan original |
| `/retrospective` | Retrospectiva de sprint/hito |

### Implementación (específico de La Base de Sky)
| Skill | Qué hace |
|-------|----------|
| `/dev-story` | Lee una historia y la implementa — el skill central de implementación |
| `/extract-scripts` | Extrae `Scripts.rxdata` a archivos `.rb` individuales editables |
| `/combine-scripts` | Recombina los `.rb` editados de vuelta a `Scripts.rxdata` (¡borra la carpeta `Data/Scripts/` al terminar — siempre hace backup primero!) |
| `/validate-pbs [archivo\|all]` | Valida sintaxis PBS y referencias cruzadas con el script determinista `scripts/validate_pbs.rb` — **ejecútalo después de cualquier cambio a PBS** |
| `/story-done` | Revisión de fin de historia — verifica criterios de aceptación |
| `/code-review` | Revisión arquitectónica y de calidad para RGSS/PBS |

### QA y testing
| Skill | Qué hace |
|-------|----------|
| `/qa-plan` | Plan de pruebas para un sprint/feature |
| `/test-setup` | Scaffolding del framework de tests (una vez, al inicio) |
| `/test-helpers` | Genera librerías auxiliares de test |
| `/smoke-check` | Gate de smoke test antes de pasar a QA manual |
| `/test-evidence-review` | Revisión de calidad de evidencia de test |
| `/regression-suite` | Mapea cobertura de tests a rutas críticas del GDD |
| `/test-flakiness` | Detecta tests no deterministas |
| `/bug-report` | Reporte de bug estructurado |
| `/bug-triage` | Re-prioriza bugs abiertos |

### Contenido y balance
| Skill | Qué hace |
|-------|----------|
| `/balance-check` | Analiza datos de balance — outliers, progresiones rotas |
| `/content-audit` | Compara contenido planeado (GDD) vs. implementado |
| `/consistency-check` | Detecta inconsistencias entre GDDs y el registro de entidades |
| `/asset-audit` | Convenciones de nombres, presupuestos de tamaño de assets |
| `/asset-spec` | Especificaciones visuales por asset a partir de GDDs |

### Release y post-lanzamiento
| Skill | Qué hace |
|-------|----------|
| `/release-checklist` | Checklist de validación pre-lanzamiento |
| `/launch-checklist` | Validación completa de lanzamiento (todos los departamentos) |
| `/day-one-patch` | Prepara un patch de día uno |
| `/hotfix` | Flujo de emergencia con auditoría completa |
| `/changelog` / `/patch-notes` | Genera changelog interno / notas de parche para jugadores |
| `/milestone-review` | Progreso de hito, métricas de calidad, recomendación go/no-go |
| `/localize` | Pipeline completo de localización |
| `/security-audit` | Auditoría de vulnerabilidades antes de release |
| `/perf-profile` / `/soak-test` | Perfilado de rendimiento / protocolo de sesiones extendidas |
| `/tech-debt` | Registro y priorización de deuda técnica |

### Equipos orquestados (`/team-*`)
Coordinan varios agentes a la vez para un flujo completo:
`/team-audio`, `/team-combat`, `/team-level`, `/team-live-ops`, `/team-narrative`,
`/team-polish`, `/team-qa`, `/team-release`, `/team-ui`

### Meta (sobre el propio framework)
| Skill | Qué hace |
|-------|----------|
| `/adopt` | Auditoría de compatibilidad al unirte a un proyecto en marcha |
| `/skill-test` / `/skill-improve` | Valida o mejora un skill |
| `/writing-skills` | Metodología para escribir skills nuevos |
| `/systematic-debugging` | Depuración de causa raíz — úsalo ante cualquier bug antes de proponer arreglos |
| `/verification-before-completion` | Obliga a verificar antes de declarar algo "listo" |
| `/reverse-document` | Genera docs de diseño/arquitectura desde código ya existente |

---

## 5. Paso a paso recomendado para diseñar tu juego

Este es el pipeline profesional de preproducción, adaptado a La Base de Sky. Ya completaste el
paso 0.

### Fase 0 — Configuración (✅ completo)
- ~~`/setup-essentials`~~ — ya configurado, verificado en Fase 1-7

### Fase 1 — Concepto
1. **`/brainstorm open`** (o con una pista, p. ej. `/brainstorm cozy`) — el paso siguiente
   inmediato. Genera `design/gdd/game-concept.md` con pilares, fantasía central, y una
   "ancla de identidad visual".
2. **`/art-bible`** — identidad visual, antes de escribir ningún GDD
3. **`/prototype [mecánica-central]`** — si la mecánica core no está probada, valida que es
   divertida antes de invertir en diseño completo (para Essentials, esto puede ser tan simple
   como maquetar el encuentro/batalla en el editor con PBS mínimo)
4. **`/map-systems`** — descompone el concepto en sistemas (batalla, encuentros, progresión...)
5. **`/design-system [sistema]`** (uno por sistema, en orden de dependencia) — cada GDD incluye
   un bloque "PBS Entry" en formato real, usa las plantillas de `.claude/docs/templates/`
   (`pokemon-species.md`, `move-spec.md`, `trainer-spec.md`)
6. **`/review-all-gdds`** — consistencia cruzada
7. **`/gate-check`** — ¿listo para arquitectura?

### Fase 2 — Arquitectura
8. **`/create-architecture`** — blueprint técnico, lista de ADRs requeridos
9. **`/architecture-decision`** (una por decisión de la lista)
10. **`/architecture-review`** — bootstrapea la matriz de trazabilidad

### Fase 3 — Preproducción
11. **`/ux-design`** — pantallas clave (menú, HUD, Pokédex si es custom)
12. **`/vertical-slice`** — build completo del loop antes de comprometerte a producción
13. **`/create-epics`** → **`/create-stories [epic]`** → **`/sprint-plan`**

### Fase 4 — Producción (repetir por historia)
14. **`/story-readiness`** — ¿la historia está lista?
15. **`/dev-story`** — implementa (rutea automáticamente a `essentials-specialist`,
    `ruby-rgss-specialist`, `pbs-compiler-specialist`, `level-designer` o `ui-programmer` según
    el archivo)
16. Si tocaste PBS: **`/validate-pbs all`**
17. Si tocaste scripts: **`/extract-scripts`** (si no estaban ya extraídos) → edita → **`/combine-scripts`**
18. **`/code-review`** → **`/story-done`**
19. **`/sprint-status`** para ver el avance general

### Fase 5 — Polish y Release
20. **`/team-polish`**, `/perf-profile`, `/soak-test`
21. **`/qa-plan`** → **`/smoke-check`** → QA manual
22. **`/release-checklist`** → **`/launch-checklist`**

---

## 6. Notas prácticas

- **Rutas a los repos hermanos**: siempre `../la-base-de-sky/...` y `../wiki-la-base-de-sky/...`
  (con `../`) porque Claude Code corre desde `game-studio-agents/`.
- **La wiki es ley**: antes de que un agente proponga una implementación, debe consultar
  `../wiki-la-base-de-sky/wiki_markdown/` (índice rápido en `.claude/docs/wiki-reference.md`).
  Si la wiki y el código real no coinciden, **el código real gana** (ver el caso
  `Evolution`/`Evolutions` documentado en `.claude/rules/pbs-files.md`).
- **`Game.exe` necesita el argumento `debug`** la primera vez que lo lances (o mientras
  `Data/PluginScripts.rxdata` no exista) — si no, falla al cargar plugins. Ver
  `wiki_markdown/08-Herramientas/debug.md`.
- **Nunca inventes un tipo de entrenador**: los genéricos (Cazabichos, Pokéfan...) comparten
  un único tipo en `trainer_types.txt` — solo los entrenadores únicos (líderes, rival) tienen
  tipo propio. `/validate-pbs` ahora detecta esto.
- **Nadie comitea sin que tú lo pidas** — si quieres que se guarde el trabajo, dilo explícitamente.
- **Subagentes vs. skills**: los skills son flujos que tú invocas; los agentes son especialistas
  que los skills (o tú directamente, pidiéndomelo) invocan para una tarea puntual.

---

## Referencias
- `production/diagnostico-essentials.md` — hechos verificados del runtime (Ruby 3.1.3, mkxp-z, API de eventos)
- `production/verificacion-fase7.md` — batería completa de pruebas del framework
- `.claude/docs/wiki-reference.md` — índice de la wiki por dominio
- `.claude/docs/technical-preferences.md` — stack técnico y convenciones completas
- `design/PLAN-IMPLEMENTACION-CC.md` — el plan de adaptación completo (histórico)
