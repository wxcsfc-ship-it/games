# Pathlings

[中文](README.zh-CN.md) | English

Pathlings is a 2D strategy puzzle game prototype built with Godot 4. The player does not directly steer the characters. Instead, each character walks automatically, and the player uses limited abilities to redirect the group, build routes, remove weak terrain, survive drops, and reach the exit before the level fails.

The current build contains 5 chapters and 22 active levels, with an emphasis on readable puzzle flow, gradual ability teaching, and lightweight progression tracking.

## Gameplay

- Watch the movers spawn, walk, fall, turn at walls, and react to the terrain.
- Select an available ability from the UI, then click a mover to apply it.
- Rescue enough movers before the timer runs out.
- Restart failed levels or continue to the next level after victory.
- Return to level select to replay completed levels and check chapter progress.

## Abilities

| Ability | Purpose |
| --- | --- |
| Blocker | Turns one mover into a standing obstacle that redirects later movers. |
| Builder | Creates a bridge in front of a mover to cross gaps. |
| Digger | Removes nearby weak terrain to open a route. |
| Parachute | Slows a long fall so the mover survives landing. |
| Climber | Lets a mover climb a tall wall to reach an upper path. |

## Content Structure

The active progression is organized into five chapters:

| Chapter | Focus | Levels |
| --- | --- | --- |
| First Rescue | Automatic movement, exits, pits, wall turns | 4 |
| Holding the Crowd | Blocker and crowd direction control | 4 |
| Building and Digging | Route construction with Builder and Digger | 5 |
| Vertical Space | Falls, parachutes, climbs, height-based routes | 5 |
| Combined Rescue | Multi-ability puzzle sequences | 4 |

Older prototype scenes are still kept under `levels/level_01.tscn` through `levels/level_15.tscn` as mechanic references. The active level flow is defined in `data/levels.json`.

## Running the Project

Requirements:

- Godot 4.6 or newer

Open the project in Godot:

1. Launch Godot.
2. Import or open this repository folder.
3. Run the project. The configured main scene is `res://scenes/title_screen.tscn`.

Command-line smoke check:

```powershell
godot --headless --path . --quit
```

## Project Layout

```text
assets/              Visual assets and Godot import metadata
data/levels.json     Chapter and level configuration
docs/                Design notes, level catalog, and development plans
levels/              Active chapter levels and archived prototype levels
scenes/              Shared UI and gameplay scenes
scripts/             Gameplay, UI, progress, and visual asset scripts
project.godot        Godot project configuration
```

## Key Implementation Notes

- `scripts/main.gd` manages spawning, ability application, rescue/death counts, win/loss checks, timer state, and level navigation.
- `scripts/auto_mover.gd` implements automatic movement, gravity, wall turns, fall damage, blocker state, parachute state, and climbing behavior.
- `scripts/progress.gd` stores completed levels, best rescued count, best time, and chapter progress in `user://progress.cfg`.
- `scripts/level_select.gd` reads level metadata and renders chapter progress and level entry buttons.
- `scripts/visual_assets.gd` centralizes runtime visual setup for characters, terrain, exits, buttons, bridges, and readable UI states.

## Documentation

- `docs/game_design.md`: product and system design overview
- `docs/level_catalog.md`: readable level matrix and intended solutions
- `docs/chapter_rebuild_plan.md`: chapter-level rebuild plan
- `docs/development_phases.md`: development milestone notes
- `docs/competitive_analysis.md`: reference analysis and design positioning

## Development Notes

When adding or changing a level, update the scene file, `data/levels.json`, and the relevant documentation together. This keeps the playable flow, level select screen, and design notes aligned.
