# Level Catalog

This document mirrors `data/levels.json` in a human-readable form. Keep both files updated whenever a level's scene, objective, abilities, intended solution, or failure logic changes.

Phase 9 chapter rebuilding is active. Prototype levels `level_01.tscn` through `level_15.tscn` remain reference scenes, but the active progression now uses new chapter scenes.

## Current Entry

- Current scene: `res://levels/chapter_02_01.tscn`
- First level: `res://levels/chapter_01_01.tscn`
- Data source: `data/levels.json`
- Planning source: `docs/chapter_rebuild_plan.md`

## Progression

The project currently starts at `chapter_02_01.tscn` so development testing jumps directly to the newest implemented chapter. Levels are wired linearly via the `next_level_scene` export on `main.gd`. After a Victory, the AbilityUI shows a **Next** button which calls `get_tree().change_scene_to_packed(next_level_scene)`. The last Chapter 2 level has `next_level_scene` unset, so the Next button stays hidden after the final Victory.

| From | To |
| --- | --- |
| `chapter_01_01.tscn` | `chapter_01_02.tscn` |
| `chapter_01_02.tscn` | `chapter_01_03.tscn` |
| `chapter_01_03.tscn` | `chapter_01_04.tscn` |
| `chapter_01_04.tscn` | `chapter_02_01.tscn` |
| `chapter_02_01.tscn` | `chapter_02_02.tscn` |
| `chapter_02_02.tscn` | `chapter_02_03.tscn` |
| `chapter_02_03.tscn` | `chapter_02_04.tscn` |
| `chapter_02_04.tscn` | `chapter_02_05.tscn` |
| `chapter_02_05.tscn` | (end) |

## Chapters

| Chapter | Title | Purpose | Status |
| --- | --- | --- | --- |
| 01 | First Rescue | Teach automatic movement, exits, pit preview, and wall-turn behavior before abilities appear. | Prototype |
| 02 | Holding the Crowd | Teach Blocker as the first player-controlled direction and crowd-control ability. | Prototype |

## Active Levels

| Level | Scene | Teaching Goal | Abilities | Win Target | Main Solution |
| --- | --- | --- | --- | --- | --- |
| C1-1 | `res://levels/chapter_01_01.tscn` | Automatic walking and the exit | None | Rescue 3/3 in 24s | Do nothing; movers walk into the exit. |
| C1-2 | `res://levels/chapter_01_02.tscn` | Visible pit preview | None | Rescue 3/3 in 24s | Do nothing; movers enter the exit before the visible pit. |
| C1-3 | `res://levels/chapter_01_03.tscn` | Longer route and four-mover queue | None | Rescue 4/4 in 28s | Do nothing; watch all movers reach the far exit. |
| C1-4 | `res://levels/chapter_01_04.tscn` | Wall-turn behavior | None | Rescue 3/3 in 28s | Do nothing; movers hit the right wall, turn left, and enter the left exit. |
| C2-1 | `res://levels/chapter_02_01.tscn` | First blocker sacrifice | Blocker x1 | Rescue 2/3 in 32s | Block the lead mover before the right pit; later movers turn left to the exit. |
| C2-2 | `res://levels/chapter_02_02.tscn` | Later blocker timing | Blocker x1 | Rescue 3/4 in 38s | Wait longer, then block before the right pit so the following movers reach the left exit. |
| C2-3 | `res://levels/chapter_02_03.tscn` | Block after a drop | Blocker x1 | Rescue 3/4 in 45s | Let movers fall to the lower shelf, then block before the lower right pit. |
| C2-4 | `res://levels/chapter_02_04.tscn` | Two blockers on a wide floor | Blocker x2 | Rescue 3/5 in 48s | Use blockers to stabilize the crowd around visible danger on both sides. |
| C2-5 | `res://levels/chapter_02_05.tscn` | Chapter 2 blocker summary | Blocker x1 | Rescue 4/5 in 48s | Sacrifice one blocker before the right pit and rescue the remaining four. |

## Prototype Reference

The old prototype sequence remains useful for implementation reference:

- `level_01.tscn` to `level_04.tscn`: basic movement, pit preview, blocker timing.
- `level_05.tscn` to `level_07.tscn`: builder and digger basics.
- `level_08.tscn` to `level_09.tscn`: parachute and climber basics.
- `level_10.tscn` to `level_15.tscn`: early compound puzzles.

Do not add prototype levels back into `data/levels.json` unless intentionally switching the active progression for testing.

## Future Planning

Next implementation batch from `docs/chapter_rebuild_plan.md` after Chapter 2 playtest:

| Planned Level | Working Title | Ability Mix | Design Purpose |
| --- | --- | --- | --- |
| C3-1 | One Bridge | Builder x1 | Bridge a single gap on a straight route. |
| C3-2 | Bridge Twice | Builder x2 | Bridge two separated gaps with time between them. |
| C3-3 | Weak Wall | Digger x1 | Dig one visible weak wall before the exit. |
| C3-4 | Dig, Then Bridge | Digger x1, Builder x1 | Open a wall, then bridge the gap behind it. |
| C3-5 | Build the Exit Route | Blocker x1, Builder x1, Digger x1 | Hold group, dig path, bridge final gap. |

## Update Rule

When adding or changing a level:

- Update the `.tscn` scene.
- Update `data/levels.json`.
- Update this catalog.
- Update `docs/chapter_rebuild_plan.md` if the chapter plan changes.
- Update `docs/development_phases.md` if the milestone status changes.
