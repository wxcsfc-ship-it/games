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
res://levels/chapter_02_01.tscn
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

运行当前项目后，应直接进入 `chapter_02_01.tscn`，用于调试最新 Chapter 2 内容。C2-1 到 C2-5 都只开启 Blocker：先选择左下角 Blocker 按钮，再点击合适的角色让它停下并变黄，后续角色碰到阻挡者后转向。每关胜利后点击 `Next` 进入下一关；C2-5 胜利后没有下一关按钮。

Chapter 2 试玩重点：

- C2-1：在第一个角色走向右侧红色坑前放置 Blocker，救 2/3。
- C2-2：等待角色更接近右侧坑再放置 Blocker，救 3/4。
- C2-3：等角色落到下层平台后再放置 Blocker，救 3/4。
- C2-4：当前为两次 Blocker 的宽平台练习，救 3/5，重点检查是否真的需要或值得使用第二个 Blocker。
- C2-5：用 1 个 Blocker 牺牲首个角色，救后续 4/5。

如果需要完整测试重建流程，可以临时把 `project.godot` 的 `run/main_scene` 改回 `res://levels/chapter_01_01.tscn`，从 Chapter 1 开始一路点击 `Next` 到 Chapter 2。
