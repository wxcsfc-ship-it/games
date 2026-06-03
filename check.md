# Godot 调试检查记录

## 1. 验证 Godot 命令

当前 Godot 放在：

```text
D:\godot
```

命令入口是：

```text
D:\godot\godot.cmd
```

验证命令：

```powershell
godot --version
```

期望输出类似：

```text
4.6.3.stable.official.7d41c59c4
```

注意：Godot 的小型 console wrapper 不能随便改名成 `godot.exe`，否则可能报错：

```text
Invalid wrapper executable name.
```

解决方式是保留原始主程序和 console wrapper 名称，再用 `godot.cmd` 做命令入口。

## 2. 验证项目能启动

在项目目录运行：

```powershell
cd C:\Users\stark\Desktop\gmesdev
godot --headless --path . --quit
```

如果在受限环境里失败并提示无法写入 `user://logs`，说明 Godot 需要写入用户日志目录。用正常终端或允许写入权限后再试。

## 3. 验证脚本是否加载

项目入口在：

```text
project.godot
```

当前运行入口是：

```text
res://scenes/title_screen.tscn
```

角色脚本是：

```text
res://scripts/auto_mover.gd
```

确认 `main.tscn` 里的 `AutoMover` 是 `CharacterBody2D`，并且挂载了 `auto_mover.gd`。

当前角色由 `Main` 从以下独立场景生成：

```text
res://scenes/auto_mover.tscn
```

关卡主要逻辑索引保存在：

```text
data/levels.json
docs/level_catalog.md
```

后续新增或修改关卡时，这两个文件必须同步更新。

## 4. 验证行为逻辑

当前脚本应满足：

- 初始自动向右移动
- 受到重力影响下落
- 碰到墙或阻挡者后转向；第 1 关和第 2 关不放置墙
- 从 `SpawnPoint` 生成
- 按固定间隔生成多个角色
- 通过 `total_to_spawn` 限制总生成数量
- 通过 `generated_count` 统计已生成数量
- 左上角 `Blocker` 按钮用于选择阻挡者能力
- 左上角 `Builder` 按钮用于选择搭桥者能力
- 点击角色后调用 `become_blocker()`，该角色停止并变黄
- 阻挡者会创建 `BlockerObstacle`，后续角色碰到后转向
- 通过 `blocker_uses` 限制阻挡者能力次数
- 点击角色后，搭桥者会在角色前方创建棕色 `Bridge`
- 通过 `builder_uses` 限制搭桥者能力次数
- 第 1 关和第 2 关通过 `blocker_enabled = false` 关闭阻挡者能力
- 第 3 关通过 `blocker_enabled = true` 开启阻挡者能力，且 `blocker_uses = 1`
- 第 4 关包含上下两层平台，角色会从上层落到下层
- 第 5 关通过 `builder_enabled = true` 开启搭桥者能力，且 `builder_uses = 1`
- 第 6 关通过 `builder_enabled = true` 开启搭桥者能力，且 `builder_uses = 2`
- C3-1 通过 `builder_enabled = true` 开启搭桥者能力，且 `builder_uses = 1`
- C3-2 通过 `builder_enabled = true` 开启搭桥者能力，且 `builder_uses = 2`
- C3-3 通过 `digger_enabled = true` 开启挖掘者能力，且 `digger_uses = 1`，弱墙使用 `diggable` 分组
- C3-4 同时开启 Builder 和 Digger 各 1 次
- C3-5 同时开启 Blocker、Builder、Digger 各 1 次，中心出生，右侧陷阱 + 左侧出口被弱墙和缺口阻挡
- C4-1 通过 `parachuter_enabled = true` 开启降落者能力，且 `parachuter_uses = 1`，高层平台 → 长距下落 → 出口
- C4-2 通过 `climber_enabled = true` 开启攀爬者能力，且 `climber_uses = 1`，高墙阻挡 → 攀爬 → 上层出口
- C4-3 同时开启 Parachute 和 Blocker 各 1 次，三层结构（上层出生、中层安全左落、底层出口），右落致命左落安全
- C4-4 同时开启 Climber 和 Builder 各 1 次，先爬墙后搭桥
- C4-5 同时开启 Parachute 和 Climber 各 1 次，双出口（上层和下层），两个角色各用一种能力
- C5-1 同时开启 Blocker 和 Digger 各 1 次，先阻挡转向，再挖开弱墙通向出口
- C5-2 同时开启 Climber 和 Digger 各 1 次，先爬上高台，再挖开上层弱墙
- C5-3 同时开启 Parachute 和 Builder 各 1 次，先安全落到下层平台，再搭桥到出口平台
- C5-4 同时开启 Blocker、Digger、Builder 各 1 次，按阻挡、挖墙、搭桥顺序完成路线
- 进入 `Exit` 后调用 `rescue()`，计入 `rescued_count`
- 掉出地图后调用 `die()`，计入 `dead_count`，并 `queue_free()` 删除
- 通过 `rescue_goal` 设置救援目标
- 通过 `time_limit_seconds` 设置关卡时间限制
- 达到目标后显示 `Victory`
- 剩余可救援数量不足时显示 `Failure`
- 时间耗尽前未胜利时显示 `Failure`
- `Restart` 按钮会重新加载当前场景

如果要自动验证，可以临时创建测试场景，运行若干物理帧后检查同时存在的角色数量、`generated_count`、`rescued_count`、`dead_count`、`blocker_uses`、`builder_uses`、阻挡者状态、桥是否生成、`elapsed_time`、`game_over`、胜负文本和节点是否被删除。验证完成后删除临时测试文件，避免给项目添加额外功能。

## 5. 运行时看到效果

当前项目已经给角色、地面和墙添加了简单几何图形，不打开碰撞形状调试也能看到基础效果。

编辑器方式：

```text
Debug -> Visible Collision Shapes
```

命令行方式：

```powershell
godot --path . --debug-collisions
```

如果还想同时检查碰撞范围，可以打开碰撞形状显示。

运行当前项目后，应进入 `title_screen.tscn`。点击 `Levels` 或按 Enter 进入 `level_select.tscn`，从关卡选择进入任意章节关卡。关卡选择显示每章完成数，以及已通关关卡的最高救援数和最快时间。关卡胜利会记录到 `user://progress.cfg`；普通关卡胜利后 `Next` 进入下一关，章节末尾胜利后 `Next` 返回关卡选择。关卡内右上角 `Levels` 按钮可随时返回关卡选择。胜利/失败后屏幕中部会显示结果细节。

Chapter 5 试玩重点：

- C5-1：三角色向右走向坑，使用 Blocker 转向，再用 Digger 打开左侧弱墙，救 2/3。
- C5-2：单角色先 Climber 爬到上层，再 Digger 挖开弱墙到达出口，救 1/1。
- C5-3：单角色先 Parachute 安全落下，再 Builder 跨过下层缺口到达出口，救 1/1。
- C5-4：三角色按 Blocker、Digger、Builder 顺序完成路线，救 2/3。

如果需要完整测试重建流程，可以临时把 `project.godot` 的 `run/main_scene` 改回 `res://levels/chapter_01_01.tscn`，从 Chapter 1 开始一路点击 `Next` 到 Chapter 4。
