# Pathlings

中文 | [English](README.md)

Pathlings 是一款使用 Godot 4 开发的 2D 策略解谜游戏原型。玩家不直接操控角色移动，而是观察角色自动行走、下落、转向和与地形互动，再用有限次数的能力改变队伍路线，帮助足够数量的角色在时间限制内抵达出口。

当前版本包含 5 个章节、22 个主流程关卡，重点验证循序渐进的能力教学、清晰的失败反馈、可读的关卡结构和轻量级进度记录。

## 玩法

- 观察角色从出生点生成，并自动行走、下落、撞墙转向或进入出口。
- 从界面选择可用能力，再点击角色进行分配。
- 在时间耗尽前救援足够数量的角色。
- 失败后可重新开始，胜利后可进入下一关。
- 在关卡选择页查看章节进度，并重玩已完成关卡。

## 能力系统

| 能力 | 作用 |
| --- | --- |
| Blocker | 将一个角色变成阻挡者，让后续角色碰到后转向。 |
| Builder | 在角色前方生成桥梁，用于跨越缺口。 |
| Digger | 移除附近的弱墙或弱地形，打开新路线。 |
| Parachute | 降低长距离下落速度，让角色安全落地。 |
| Climber | 让角色在遇到高墙时攀爬到上层路线。 |

## 内容结构

主流程分为五个章节：

| 章节 | 重点 | 关卡数 |
| --- | --- | --- |
| First Rescue | 自动行走、出口、陷阱预告、撞墙转向 | 4 |
| Holding the Crowd | Blocker 与队伍方向控制 | 4 |
| Building and Digging | Builder / Digger 与路线构建 | 5 |
| Vertical Space | 长距离下落、降落伞、攀爬和高度路线 | 5 |
| Combined Rescue | 多能力组合解谜 | 4 |

`levels/level_01.tscn` 到 `levels/level_15.tscn` 保留为早期机制参考场景。当前主流程由 `data/levels.json` 定义。

## 运行项目

环境要求：

- Godot 4.6 或更新版本

使用 Godot 运行：

1. 启动 Godot。
2. 导入或打开本仓库目录。
3. 运行项目。当前主场景为 `res://scenes/title_screen.tscn`。

命令行快速检查：

```powershell
godot --headless --path . --quit
```

## 项目目录

```text
assets/              视觉资源与 Godot 导入元数据
data/levels.json     章节与关卡配置
docs/                设计文档、关卡目录和开发计划
levels/              主流程章节关卡与历史原型关卡
scenes/              通用 UI 和玩法场景
scripts/             玩法、UI、进度和视觉资源脚本
project.godot        Godot 项目配置
```

## 核心实现

- `scripts/main.gd`：管理角色生成、能力应用、救援/死亡计数、胜负判定、计时和关卡跳转。
- `scripts/auto_mover.gd`：实现自动移动、重力、撞墙转向、坠落伤害、阻挡者、降落伞和攀爬状态。
- `scripts/progress.gd`：将通关状态、最高救援数、最快时间和章节进度写入 `user://progress.cfg`。
- `scripts/level_select.gd`：读取关卡元数据，渲染章节进度和关卡入口。
- `scripts/visual_assets.gd`：统一管理角色、地形、出口、按钮、桥梁和 UI 状态的视觉呈现。

## 文档

- `docs/game_design.md`：产品和系统设计概览
- `docs/level_catalog.md`：关卡矩阵、主解法和失败反馈
- `docs/chapter_rebuild_plan.md`：章节重建计划
- `docs/development_phases.md`：阶段开发记录
- `docs/competitive_analysis.md`：参考产品分析与设计定位

## 开发说明

新增或修改关卡时，需要同步更新场景文件、`data/levels.json` 和相关文档，确保可玩流程、关卡选择页和设计说明保持一致。
