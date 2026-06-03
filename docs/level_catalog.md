# Level Catalog

This document mirrors `data/levels.json` in a human-readable form. Keep both files updated whenever a level's scene, objective, abilities, intended solution, or failure logic changes.

Phase 9 chapter rebuilding is active. Prototype levels `level_01.tscn` through `level_15.tscn` remain reference scenes, but the active progression now uses new chapter scenes.

## Current Entry

- Current scene: `res://scenes/title_screen.tscn`
- First level: `res://levels/chapter_01_01.tscn`
- Data source: `data/levels.json`
- Planning source: `docs/chapter_rebuild_plan.md`

## Progression

The project currently starts at `title_screen.tscn`. The title screen enters `level_select.tscn`, which reads `data/levels.json` and can launch any active chapter level. Levels are still wired linearly via the `next_level_scene` export on `main.gd`; after a Victory, the AbilityUI shows a **Next** button. On the last level in a chain, **Next** returns to the level select screen.

| From | To |
| --- | --- |
| `chapter_01_01.tscn` | `chapter_01_02.tscn` |
| `chapter_01_02.tscn` | `chapter_01_03.tscn` |
| `chapter_01_03.tscn` | `chapter_01_04.tscn` |
| `chapter_01_04.tscn` | `chapter_02_01.tscn` |
| `chapter_02_01.tscn` | `chapter_02_02.tscn` |
| `chapter_02_02.tscn` | `chapter_02_03.tscn` |
| `chapter_02_03.tscn` | `chapter_02_04.tscn` |
| `chapter_02_04.tscn` | `chapter_03_01.tscn` |
| `chapter_03_01.tscn` | `chapter_03_02.tscn` |
| `chapter_03_02.tscn` | `chapter_03_03.tscn` |
| `chapter_03_03.tscn` | `chapter_03_04.tscn` |
| `chapter_03_04.tscn` | `chapter_03_05.tscn` |
| `chapter_03_05.tscn` | `chapter_04_01.tscn` |
| `chapter_04_01.tscn` | `chapter_04_02.tscn` |
| `chapter_04_02.tscn` | `chapter_04_03.tscn` |
| `chapter_04_03.tscn` | `chapter_04_04.tscn` |
| `chapter_04_04.tscn` | `chapter_04_05.tscn` |
| `chapter_04_05.tscn` | `chapter_05_01.tscn` |
| `chapter_05_01.tscn` | `chapter_05_02.tscn` |
| `chapter_05_02.tscn` | `chapter_05_03.tscn` |
| `chapter_05_03.tscn` | `chapter_05_04.tscn` |
| `chapter_05_04.tscn` | (end) |

## Chapters

| Chapter | Title | Purpose | Status |
| --- | --- | --- | --- |
| 01 | First Rescue | Teach automatic movement, exits, pit preview, and wall-turn behavior before abilities appear. | Prototype |
| 02 | Holding the Crowd | Teach Blocker as the first player-controlled direction and crowd-control ability. | Prototype |
| 03 | Building and Digging | Teach route construction: Builder creates temporary floor, Digger removes weak terrain. | Prototype |
| 04 | Vertical Space | Teach long falls, parachutes, high walls, and routes split by height. | Prototype |
| 05 | Combined Rescue | Use two to three abilities per level in full puzzle form, ending with a readable all-abilities prototype. | Prototype |

## Active Levels

| Level | Scene | Teaching Goal | Abilities | Win Target | Main Solution |
| --- | --- | --- | --- | --- | --- |
| C1-1 | `res://levels/chapter_01_01.tscn` | Automatic walking and the exit | None | Rescue 3/3 in 24s | Do nothing; movers walk into the exit. |
| C1-2 | `res://levels/chapter_01_02.tscn` | Visible pit preview | None | Rescue 3/3 in 24s | Do nothing; movers enter the exit before the visible pit. |
| C1-3 | `res://levels/chapter_01_03.tscn` | Longer route and four-mover queue | None | Rescue 4/4 in 28s | Do nothing; watch all movers reach the far exit. |
| C1-4 | `res://levels/chapter_01_04.tscn` | Wall-turn behavior | None | Rescue 3/3 in 28s | Do nothing; movers hit the right wall, turn left, and enter the left exit. |
| C2-1 | `res://levels/chapter_02_01.tscn` | First blocker sacrifice | Blocker x1 | Rescue 2/3 in 32s | Block the lead mover before the right pit; later movers turn left to the exit. |
| C2-2 | `res://levels/chapter_02_02.tscn` | Block after a drop | Blocker x1 | Rescue 3/4 in 45s | Let movers fall to the lower shelf, then block before the lower right pit. |
| C2-3 | `res://levels/chapter_02_03.tscn` | Two blockers on a wide floor | Blocker x2 | Rescue 3/5 in 48s | Use blockers to stabilize the crowd around visible danger on both sides. |
| C2-4 | `res://levels/chapter_02_04.tscn` | 双层地板章节收尾 | Blocker x1 | Rescue 4/5 in 48s | 等小人落到下层平台，在右侧陷阱前阻挡，剩余四人左转进出口。 |
| C3-1 | `res://levels/chapter_03_01.tscn` | First Builder use | Builder x1 | Rescue 3/3 in 30s | Bridge a single gap on a straight route. |
| C3-2 | `res://levels/chapter_03_02.tscn` | Two bridges | Builder x2 | Rescue 3/3 in 45s | Bridge two separated gaps with time between them. |
| C3-3 | `res://levels/chapter_03_03.tscn` | First Digger use | Digger x1 | Rescue 3/3 in 30s | Dig one visible weak wall before the exit. |
| C3-4 | `res://levels/chapter_03_04.tscn` | Dig then bridge | Digger x1, Builder x1 | Rescue 3/3 in 45s | Open a wall, then bridge the gap behind it. |
| C3-5 | `res://levels/chapter_03_05.tscn` | Chapter 3 summary | Blocker x1, Builder x1, Digger x1 | Rescue 2/3 in 55s | Block group at left pit, dig wall, bridge gap to right-side exit. |
| C4-1 | `res://levels/chapter_04_01.tscn` | First Parachute use | Parachute x1 | Rescue 1/1 in 25s | Parachute before a long deadly fall to reach the exit below. |
| C4-2 | `res://levels/chapter_04_02.tscn` | First Climber use | Climber x1 | Rescue 1/1 in 30s | Climb a tall wall to reach the exit on a higher platform. |
| C4-3 | `res://levels/chapter_04_03.tscn` | Parachute + Blocker | Parachute x1, Blocker x1 | Rescue 2/3 in 50s | Parachute right, block to redirect one mover through the safe left route. |
| C4-4 | `res://levels/chapter_04_04.tscn` | Climb then bridge | Climber x1, Builder x1 | Rescue 1/1 in 40s | Climb a wall to an upper route, then bridge a gap to the exit. |
| C4-5 | `res://levels/chapter_04_05.tscn` | Chapter 4 summary | Parachute x1, Climber x1 | Rescue 2/2 in 45s | Two movers: one climbs to upper exit, one parachutes 270px drop to lower exit. |
| C5-1 | `res://levels/chapter_05_01.tscn` | Store and release route control | Blocker x1, Digger x1 | Rescue 2/3 in 50s | Block before the right pit, then dig the left weak wall so two movers reach the exit. |
| C5-2 | `res://levels/chapter_05_02.tscn` | Climb then dig | Climber x1, Digger x1 | Rescue 1/1 in 45s | Climb to the upper route, then dig the weak wall before the exit. |
| C5-3 | `res://levels/chapter_05_03.tscn` | Parachute then build | Parachute x1, Builder x1 | Rescue 1/1 in 45s | Open parachute before the long fall, then build across the lower gap. |
| C5-4 | `res://levels/chapter_05_04.tscn` | Three-step route | Blocker x1, Digger x1, Builder x1 | Rescue 2/3 in 60s | Hold the group, dig the wall, then bridge the final gap. |

## Prototype Reference

The old prototype sequence remains useful for implementation reference:

- `level_01.tscn` to `level_04.tscn`: basic movement, pit preview, blocker timing.
- `level_05.tscn` to `level_07.tscn`: builder and digger basics.
- `level_08.tscn` to `level_09.tscn`: parachute and climber basics.
- `level_10.tscn` to `level_15.tscn`: early compound puzzles.

Do not add prototype levels back into `data/levels.json` unless intentionally switching the active progression for testing.

## Future Planning

Chapter 5 is now implemented as a prototype batch. Next work is playtesting and tuning:

| Level | Working Title | Ability Mix | Tuning Focus |
| --- | --- | --- | --- |
| C5-1 | Store and Release | Blocker x1, Digger x1 | Blocker timing and weak wall reach. |
| C5-2 | Over and Under | Climber x1, Digger x1 | Climb landing alignment and dig distance. |
| C5-3 | Bridge the Drop | Parachute x1, Builder x1 | Safe landing position and lower bridge alignment. |
| C5-4 | Three-Step Route | Blocker x1, Digger x1, Builder x1 | Ability order readability and bridge gap width. |

## Update Rule

When adding or changing a level:

- Update the `.tscn` scene.
- Update `data/levels.json`.
- Update this catalog.
- Update `docs/chapter_rebuild_plan.md` if the chapter plan changes.
- Update `docs/development_phases.md` if the milestone status changes.
