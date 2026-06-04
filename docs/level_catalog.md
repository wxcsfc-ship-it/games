# 关卡体验矩阵

本文档是 `data/levels.json` 的人工可读版本，用来说明每个关卡在用户旅程中的作用。它不仅记录场景入口和能力配置，也记录教学目标、主解法、失败反馈和后续可观测指标，便于后续调试、扩关和难度调优。

当前状态：5 章 22 个活跃关卡已接入正式流程；15 个旧原型关卡仍保留为机制参考。

## 1. 产品流程

- 项目入口：`res://scenes/title_screen.tscn`
- 关卡选择：`res://scenes/level_select.tscn`
- 第一关：`res://levels/chapter_01_01.tscn`
- 活跃数据源：`data/levels.json`
- 章节规划：`docs/chapter_rebuild_plan.md`
- 进度记录：`scripts/progress.gd` 写入 `user://progress.cfg`

流程说明：

1. 标题页进入关卡选择。
2. 关卡选择读取 `data/levels.json`，按章节展示 22 个活跃关卡。
3. 玩家进入任意关卡后，通过 `next_level_scene` 串联到下一关。
4. 胜利时记录通关状态、最高救援数和最快时间。
5. 章节最后一关胜利后返回关卡选择。

## 2. 章节体验目标

| 章节 | 产品目标 | 用户应学会什么 | 关卡数 |
| --- | --- | --- | --- |
| Chapter 1：First Rescue | 新手 onboarding | 自动行走、出口、缺口预告、撞墙转向 | 4 |
| Chapter 2：Holding the Crowd | 第一次主动干预 | 用 Blocker 管理队伍方向和允许牺牲 | 4 |
| Chapter 3：Building and Digging | 路线建造 | 用 Builder 补路、用 Digger 打开弱墙 | 5 |
| Chapter 4：Vertical Space | 垂直空间 | 用 Parachute 处理长落差，用 Climber 到达高台 | 5 |
| Chapter 5：Combined Rescue | 复合 workflow | 按顺序组合两到三种能力完成主解法 | 4 |

## 3. 关卡体验矩阵

| 关卡 | 场景 | 教学目标 | 能力 | 胜利目标 | 主解法 | 失败反馈 |
| --- | --- | --- | --- | --- | --- | --- |
| C1-1 | `chapter_01_01.tscn` | 自动行走与出口 | 无 | 24 秒内救援 3/3 | 不操作，观察角色进入出口 | 理论上只因时间或出口配置错误失败 |
| C1-2 | `chapter_01_02.tscn` | 可见缺口预告 | 无 | 24 秒内救援 3/3 | 不操作，角色在缺口前进入出口 | 若路线配置错误，角色会走入可见危险 |
| C1-3 | `chapter_01_03.tscn` | 更长路线和队列观察 | 无 | 28 秒内救援 4/4 | 不操作，观察 4 个角色依次获救 | 时间过短会导致超时 |
| C1-4 | `chapter_01_04.tscn` | 撞墙转向规则 | 无 | 28 秒内救援 3/3 | 角色撞右墙后转向左侧出口 | 墙体或出口位置错误会困住角色 |
| C2-1 | `chapter_02_01.tscn` | 第一次 Blocker 牺牲 | Blocker x1 | 32 秒内救援 2/3 | 在右侧坑前阻挡领头角色，后续角色左转 | 不阻挡会掉坑，阻挡太晚会救援不足 |
| C2-2 | `chapter_02_02.tscn` | 下落后阻挡 | Blocker x1 | 45 秒内救援 3/4 | 等角色落到下层，再在右侧坑前阻挡 | 在上层阻挡会堵住路线，下层太晚会掉坑 |
| C2-3 | `chapter_02_03.tscn` | 双向风险控制 | Blocker x2 | 48 秒内救援 3/5 | 用 Blocker 让队伍在两侧危险之间稳定 | 两个 Blocker 用错位置会无法完成 |
| C2-4 | `chapter_02_04.tscn` | 队伍控制章节小结 | Blocker x1 | 48 秒内救援 4/5 | 下层右坑前阻挡，剩余 4 人左转进出口 | 额外死亡会导致救援目标不可达 |
| C3-1 | `chapter_03_01.tscn` | 第一次 Builder | Builder x1 | 30 秒内救援 3/3 | 在单个缺口前搭桥 | 不搭桥或搭桥太晚会掉入缺口 |
| C3-2 | `chapter_03_02.tscn` | 连续搭桥 | Builder x2 | 45 秒内救援 3/3 | 分别跨过两个缺口 | 漏掉任意一座桥都会失败 |
| C3-3 | `chapter_03_03.tscn` | 第一次 Digger | Digger x1 | 30 秒内救援 3/3 | 在出口前挖开弱墙 | 不挖会被墙体转向，距离太远会浪费能力 |
| C3-4 | `chapter_03_04.tscn` | 先挖再搭 | Digger x1, Builder x1 | 45 秒内救援 3/3 | 先挖弱墙，再为墙后缺口搭桥 | 顺序错误会把桥用在错误位置 |
| C3-5 | `chapter_03_05.tscn` | 三能力路线建造 | Blocker x1, Digger x1, Builder x1 | 55 秒内救援 2/3 | Blocker 暂存队伍，Digger 开墙，Builder 跨最终缺口 | 缺任意能力都会让路线不完整 |
| C4-1 | `chapter_04_01.tscn` | 第一次 Parachute | Parachute x1 | 25 秒内救援 1/1 | 长落差前开伞，安全落到下层出口 | 不开伞会因落差死亡 |
| C4-2 | `chapter_04_02.tscn` | 第一次 Climber | Climber x1 | 30 秒内救援 1/1 | 高墙前赋予 Climber，到达上层出口 | 不攀爬会转向或超时 |
| C4-3 | `chapter_04_03.tscn` | Parachute + Blocker | Parachute x1, Blocker x1 | 50 秒内救援 2/3 | 第一人开伞走右侧，第二人阻挡让第三人走左侧安全路线 | 单独使用任一能力都只能救 1 人 |
| C4-4 | `chapter_04_04.tscn` | Climber + Builder | Climber x1, Builder x1 | 40 秒内救援 1/1 | 先爬上层，再搭桥跨缺口 | 先搭桥会浪费在下层 |
| C4-5 | `chapter_04_05.tscn` | 高度分流 | Parachute x1, Climber x1 | 45 秒内救援 2/2 | 一个角色攀爬到上层出口，一个角色开伞到下层出口 | 两种能力给同一角色会导致另一个角色死亡 |
| C5-1 | `chapter_05_01.tscn` | 储存并释放 | Blocker x1, Digger x1 | 50 秒内救援 2/3 | 右坑前阻挡，再挖开左侧弱墙 | 无 Blocker 会掉坑，无 Digger 路线关闭 |
| C5-2 | `chapter_05_02.tscn` | 先攀爬再挖掘 | Climber x1, Digger x1 | 45 秒内救援 1/1 | 爬到上层后挖开出口前弱墙 | 无 Climber 到不了上层，无 Digger 出口被挡 |
| C5-3 | `chapter_05_03.tscn` | 先开伞再搭桥 | Parachute x1, Builder x1 | 45 秒内救援 1/1 | 长落差前开伞，落地后搭桥到出口 | 无 Parachute 会死亡，无 Builder 下层缺口不可过 |
| C5-4 | `chapter_05_04.tscn` | 三步复合路线 | Blocker x1, Digger x1, Builder x1 | 60 秒内救援 2/3 | 稳住队伍，挖开弱墙，搭桥跨最终缺口 | 能力顺序错误会浪费有限资源 |

## 4. 成功指标与后续埋点

当前已记录：

- 是否完成关卡。
- 最高救援数。
- 最快通关时间。
- 章节完成进度。

建议补充：

- 每关失败次数。
- 每关重开次数。
- 每次能力使用的顺序和时间点。
- 失败原因分类：掉坑、超时、救援不足、能力用错、顺序错误。
- 首次通关耗时和总尝试次数。

数据使用方式：

- 如果某关失败次数高但失败原因集中，说明教学或视觉提示需要调整。
- 如果某关通关时间远高于章节均值，说明路线阅读或能力顺序可能不清楚。
- 如果能力使用顺序高度分散，说明关卡没有给出足够明确的主解法提示。

## 5. 可读性验收重点

阶段 11 抽测关卡：

| 关卡 | 验收重点 |
| --- | --- |
| C1-1 | 基础角色、出生口、出口、自动行走是否清楚 |
| C2-1 | Blocker 状态是否像障碍物，牺牲逻辑是否可见 |
| C3-1 | Builder 桥梁是否清楚表示可站立，桥面是否对齐 |
| C3-3 | 弱墙是否和普通墙体明显不同 |
| C4-1 | 长落差风险和 Parachute 状态是否清楚 |
| C4-2 | 高墙和 Climber 准备状态是否清楚 |
| C5-4 | 多能力按钮、选中态、剩余次数和三步路线是否可读 |

验收标准：

- 不打开碰撞调试也能判断可走地形、空缺口、弱墙、高墙、桥梁、出生口、出口。
- 颜色不是唯一信息来源，关键对象还要有形状、纹理或图标差异。
- 视觉边界不能明显偏离碰撞边界。
- 结果文案不能遮挡 Restart、Next、Levels 等下一步操作。

## 6. 原型参考

历史原型仍保留为机制参考，不再作为活跃流程：

- `level_01.tscn` 到 `level_04.tscn`：基础移动、缺口预告、Blocker 时机。
- `level_05.tscn` 到 `level_07.tscn`：Builder 和 Digger 基础。
- `level_08.tscn` 到 `level_09.tscn`：Parachute 和 Climber 基础。
- `level_10.tscn` 到 `level_15.tscn`：早期复合谜题。

除非为测试而有意切换流程，不要把旧原型重新加入 `data/levels.json`。

## 7. 更新规则

新增或修改关卡时必须同步：

- `.tscn` 场景。
- `data/levels.json`。
- 本文档。
- 如果章节目标变化，同步 `docs/chapter_rebuild_plan.md`。
- 如果阶段状态变化，同步 `docs/development_phases.md`。
