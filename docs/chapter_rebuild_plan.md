# Chapter Rebuild Plan

This document starts phase 9: rebuilding the level structure into chapters that feel like a real game. Existing code and prototype levels can be referenced for mechanics, timing, and scene patterns, but the chapter levels below should be redesigned as new content rather than copied directly from levels 01-15.

## Goals

- Replace the loose prototype sequence with chapters that teach, vary, and summarize mechanics.
- Keep the Lemmings-style focus on route reading, limited resources, acceptable sacrifice, and visible failure.
- Build each chapter around 4-5 levels: introduction, standard use, variation, and chapter summary.
- Keep debug startup pointed at the newest implemented chapter level during development.
- Preserve the current prototype levels as reference material until the chapter set is playable.

## Rebuild Rules

- New chapter levels should use new scene names, for example `chapter_01_01.tscn`, not overwrite old prototype levels.
- Each level must have a one-sentence design goal before implementation.
- Each chapter should introduce only one major new idea.
- Each level must list ability counts, rescue target, main solution, and intended failure modes.
- Do not depend on pixel-perfect clicks; if timing is too strict, adjust terrain spacing first.
- Use the existing `main.gd`, `auto_mover.gd`, `ability_ui.tscn`, and `exit.gd` as the starting technical base unless a chapter requirement clearly exposes a missing system.
- When a chapter level is implemented, add it to `data/levels.json` and `docs/level_catalog.md`.

## Chapter 1: First Rescue

Purpose: teach automatic movement, exits, pits, and the idea that not every visible danger requires an ability.

Tone: low pressure, wide spaces, no ability switching.

Status: prototype implemented as `chapter_01_01.tscn` through `chapter_01_04.tscn`.

| Level | Working Title | Abilities | Target | Main Idea | Failure Point |
| --- | --- | --- | --- | --- | --- |
| C1-1 | Walk Home | None | Rescue 3/3 | Movers walk right into the exit. | Only time expiry should fail. |
| C1-2 | Mind the Edge | None | Rescue 3/3 | Exit appears before a visible pit, teaching danger preview. | Missing the exit route in layout would send movers into the pit. |
| C1-3 | The Long Floor | None | Rescue 4/4 | Longer spawn spacing and time pressure, still no abilities. | Time limit if route is too slow. |
| C1-4 | First Turn | None | Rescue 3/3 | A wall turns movers back toward an exit, teaching automatic wall-turn behavior. | Bad wall placement can trap the group. |

Implementation notes:

- This chapter should feel almost like a tutorial without popups.
- Do not introduce ability buttons yet.
- Use clear green exits and red pit markers.

## Chapter 2: Holding the Crowd

Purpose: teach Blocker as the first real player-controlled ability.

Tone: one sacrifice is acceptable; timing is readable, not frantic.

Status: prototype implemented as `chapter_02_01.tscn` through `chapter_02_05.tscn`.

| Level | Working Title | Abilities | Target | Main Idea | Failure Point |
| --- | --- | --- | --- | --- | --- |
| C2-1 | Stand Here | Blocker x1 | Rescue 2/3 | First mover blocks before a pit; later movers turn to exit. | No blocker means right-side deaths. |
| C2-2 | Late Turn | Blocker x1 | Rescue 3/4 | Longer approach and later spawn spacing; block at the last safe platform segment. | Blocking too late loses too many movers. |
| C2-3 | Lower Shelf | Blocker x1 | Rescue 3/4 | Movers fall to a lower platform, then need a blocker to turn left. | Blocking on the wrong layer traps the route. |
| C2-4 | Two-Way Lesson | Blocker x2 | Rescue 4/5 | Use one blocker to protect from a pit and another to redirect near exit. | Spending both blockers early prevents finish. |
| C2-5 | Crowd Control | Blocker x1 | Rescue 4/5 | Chapter summary with wider terrain and one deliberate blocker sacrifice. | The crowd walks into danger without a stable blocker point. |

Implementation notes:

- The blocker body should be visually obvious.
- Keep exits on both left and right across the chapter so players learn direction is a route property, not a fixed goal.

## Chapter 3: Building and Digging

Purpose: introduce route construction: Builder creates temporary floor, Digger removes weak terrain.

Tone: route planning replaces pure timing.

| Level | Working Title | Abilities | Target | Main Idea | Failure Point |
| --- | --- | --- | --- | --- | --- |
| C3-1 | One Bridge | Builder x1 | Rescue 3/3 | Bridge a single gap on a straight route. | No bridge means pit deaths. |
| C3-2 | Bridge Twice | Builder x2 | Rescue 3/3 | Bridge two separated gaps with time between them. | Missing either bridge fails. |
| C3-3 | Weak Wall | Digger x1 | Rescue 3/3 | Dig one visible weak wall before the exit. | No dig means movers turn away. |
| C3-4 | Dig, Then Bridge | Digger x1, Builder x1 | Rescue 3/3 | Open a wall, then bridge the gap behind it. | Using builder before digging wastes the route. |
| C3-5 | Build the Exit Route | Blocker x1, Builder x1, Digger x1 | Rescue 2/3 | First chapter summary: hold group, dig path, bridge final gap. | Wrong order wastes limited abilities. |

Implementation notes:

- Weak walls should always use the same brown/orange visual language.
- Bridge placement should have forgiving platform alignment.
- This chapter can reference prototype levels 05, 06, 07, 11, and 15, but should use new layouts.

## Chapter 4: Vertical Space

Purpose: teach long falls, parachutes, high walls, and routes split by height.

Tone: slower reading, more vertical screen space, fewer movers.

| Level | Working Title | Abilities | Target | Main Idea | Failure Point |
| --- | --- | --- | --- | --- | --- |
| C4-1 | Soft Landing | Parachute x1 | Rescue 1/1 | Use parachute before a long fall. | Landing without parachute kills the mover. |
| C4-2 | High Step | Climber x1 | Rescue 1/1 | Climb a wall to a higher platform. | No climb means wall turn and timeout. |
| C4-3 | Hold the Landing | Parachute x1, Blocker x1 | Rescue 2/3 | Save one mover below, then prevent the crowd from repeating the deadly drop. | The current prototype has a blocker-only bypass; redesign to make parachute required by route or target. |
| C4-4 | Climb to Build | Climber x1, Builder x1 | Rescue 1/1 | Climb to upper route, then bridge an upper gap. | Builder before climb is useless. |
| C4-5 | Split Heights | Parachute x1, Climber x1 | Rescue 2/2 | One route descends safely, another uses climb to reach exit level. | Assigning the wrong ability to the wrong moment fails. |

Implementation notes:

- Redesign C4-3 from scratch so Blocker alone cannot satisfy the rescue goal.
- Keep vertical gaps visibly different from ordinary pits.
- Use fewer movers to reduce chaos while teaching vertical abilities.

## Chapter 5: Combined Rescue

Purpose: use two to three abilities per level in full puzzle form.

Tone: real game levels, still readable and fair.

| Level | Working Title | Abilities | Target | Main Idea | Failure Point |
| --- | --- | --- | --- | --- | --- |
| C5-1 | Store and Release | Blocker x1, Digger x1 | Rescue 2/3 | Store the group with Blocker, dig open the intended route. | Digging without turning the group is too late or useless. |
| C5-2 | Over and Under | Climber x1, Digger x1 | Rescue 1/1 | Climb to a high route, dig through the obstacle near the exit. | Wrong order returns mover to low route. |
| C5-3 | Bridge the Drop | Parachute x1, Builder x1 | Rescue 1/1 | Survive a fall, then build out of the landing platform. | Bridge before landing is wasted. |
| C5-4 | Three-Step Route | Blocker x1, Digger x1, Builder x1 | Rescue 2/3 | Turn group, open weak wall, bridge final gap. | Wrong ability order fails. |
| C5-5 | Final Prototype Set | Blocker x1, Builder x1, Digger x1, Parachute x1, Climber x1 | Rescue 3/5 | A readable capstone using all five abilities with generous spacing. | Spending any ability on the wrong branch makes rescue target impossible. |

Implementation notes:

- C5-5 should be a capstone, not a precision challenge.
- Use visual staging: each ability point should be visible before the player reaches it.
- Avoid simultaneous crises until the game has pause or speed controls.

## Naming and File Plan

Use this scene naming scheme:

| Chapter | Scene Prefix | Example |
| --- | --- | --- |
| Chapter 1 | `chapter_01_` | `res://levels/chapter_01_01.tscn` |
| Chapter 2 | `chapter_02_` | `res://levels/chapter_02_01.tscn` |
| Chapter 3 | `chapter_03_` | `res://levels/chapter_03_01.tscn` |
| Chapter 4 | `chapter_04_` | `res://levels/chapter_04_01.tscn` |
| Chapter 5 | `chapter_05_` | `res://levels/chapter_05_01.tscn` |

Prototype levels 01-15 remain reference scenes. New chapter scenes should not overwrite them.

## Data Plan

When implementation begins:

- Keep `data/levels.json` for the active playable sequence.
- Add chapter metadata fields only if needed later, such as `chapter_id`, `chapter_title`, and `chapter_order`.
- During early phase 9 implementation, point `current_entry_scene` and `project.godot` at the newest chapter level.
- After a full chapter is playable, set `first_level_scene` or the title screen target to the first level of that chapter for full-run testing.

## Immediate Next Step

Playtest Chapter 2 from the current debug entry:

- `res://levels/chapter_02_01.tscn`
- `res://levels/chapter_02_02.tscn`
- `res://levels/chapter_02_03.tscn`
- `res://levels/chapter_02_04.tscn`
- `res://levels/chapter_02_05.tscn`

Focus the next pass on tuning Blocker placement windows, especially C2-4. If Chapter 2 is accepted, begin Chapter 3 with Builder and Digger route construction.
