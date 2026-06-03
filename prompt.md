# 阶段11 美术资源 AI 生成提示词

> 总体要求：像素风（pixel art）、简洁风格、小尺寸（适合 Godot 2D 游戏）、颜色区分度高、碰撞边界清晰可读。
> 所有资源生成后需验证：视觉边界不误导玩家对站立、通过、危险的判断。

---

## 一、角色资源（assets/sprites/）

### 1. mover_idle.png — 基础角色待机
> 一个像素风小角色，待机站立姿态，正面或侧面站立，小巧可爱，身体颜色为亮蓝或亮绿，头部有明显的眼睛（用于判断朝向），轮廓清晰，纯色或透明背景，16×16 到 32×32 像素范围。

**提示词：**
```
pixel art, tiny character standing idle, side view, small cute humanoid, bright blue bodysuit, big visible eyes on head showing direction, simple clean design, no complex details, solid outline, transparent background, 32x32 game sprite, minimalist
```

### 2. mover_walk_01.png — 行走动画帧 1
> 同上角色，行走动画第一帧，一条腿前迈，手臂微摆，保持眼睛方向和身体轮廓清晰。

**提示词：**
```
pixel art, tiny character walking frame 1, side view, left leg forward, arms slightly swinging, bright blue bodysuit, big visible eyes, simple walking pose, clean outline, transparent background, 32x32 game sprite, minimalist
```

### 3. mover_walk_02.png — 行走动画帧 2
> 同上角色，行走动画第二帧，另一条腿前迈，与帧1形成交替步态。

**提示词：**
```
pixel art, tiny character walking frame 2, side view, right leg forward, arms slightly swinging opposite to legs, bright blue bodysuit, big visible eyes, simple walking pose, clean outline, transparent background, 32x32 game sprite, minimalist
```

### 4. mover_blocker.png — 阻挡者状态
> 同一角色但变为阻挡者状态，身体颜色变为醒目的黄色/橙色，双臂张开呈阻挡姿态，表情坚定，要比普通状态更醒目。

**提示词：**
```
pixel art, tiny character standing firm, arms stretched out wide blocking pose, bright yellow bodysuit, orange warning color tone, determined expression, big visible eyes, solid stance like a wall, clean outline, transparent background, 32x32 game sprite, minimalist
```

### 5. mover_climb_ready.png — 攀爬准备状态
> 同一角色，已赋予攀爬能力但尚未开始攀爬的状态，身体带有蓝色描边或手套高亮，姿态略微向上看，准备攀爬的感觉。

**提示词：**
```
pixel art, tiny character ready to climb, looking upward, blue glowing outline around body, blue gloves or highlight on hands, anticipating pose, bright blue bodysuit, big visible eyes, clean outline, transparent background, 32x32 game sprite, minimalist
```

### 6. parachute_open.png — 降落伞打开状态
> 角色头顶打开一个圆形或半圆形降落伞，伞体颜色鲜艳（红白条纹或橙白条纹），伞不能遮住角色本体位置，整体轮廓清晰可点击。

**提示词：**
```
pixel art, tiny character with open parachute above head, round canopy with red and white stripes, character hanging below clearly visible, parachute not covering character body, bright blue character, clean outline, transparent background, 48x48 game sprite, minimalist pixel style
```

---

## 二、地形资源（assets/tiles/）

### 7. floor_top.png — 普通地面顶面
> 像素风地面瓦片顶面，低饱和绿灰色，顶部有轻微草地纹理，是可站立区域的视觉锚点。

**提示词：**
```
pixel art, ground tile top surface, low saturation greenish gray, subtle grass texture on top edge, flat walkable surface, clean horizontal line, stone and dirt pattern, seamless tileable, 32x32 pixel tile, minimalist, game terrain
```

### 8. floor_side.png — 普通地面侧面
> 同一地面瓦片的侧面/立面，颜色比顶面略深，有泥土或岩石分层纹理，用于提示玩家这是不可通过的墙体侧面。

**提示词：**
```
pixel art, ground tile side wall, darker earthy brown with rock layers, vertical surface not walkable, dirt and stone strata pattern, clean vertical lines, seamless tileable, 32x32 pixel tile, minimalist, game terrain
```

### 9. wall_solid.png — 实体墙体
> 不可破坏的实体墙瓦片，深灰色或深棕色，竖直厚重，表面有砖块或岩石纹理，和普通地面侧面有明显区别（更厚重）。

**提示词：**
```
pixel art, solid wall tile, dark gray stone brick pattern, heavy thick vertical wall, impassable barrier, brick lines visible, solid and sturdy look, seamless tileable, 32x32 pixel tile, minimalist, game terrain
```

### 10. wall_diggable.png — 可挖弱墙
> 可被挖掘者破坏的弱墙瓦片，棕橙色基调，表面有明显裂纹纹理，必须和普通墙体一眼区分开来。

**提示词：**
```
pixel art, weak diggable wall tile, brownish orange color, visible crack lines across surface, crumbling appearance, fragile looking bricks, distinct from solid wall, warm tone hinting it can be destroyed, seamless tileable, 32x32 pixel tile, minimalist, game terrain
```

### 11. bridge_plank.png — 桥梁木板
> 搭桥者生成的临时桥梁瓦片，木色/棕色木板纹理，水平方向，视觉是临时平台但不能和普通地面完全一样。

**提示词：**
```
pixel art, wooden bridge plank tile, warm brown wood grain texture, horizontal wooden boards, temporary platform look, lighter than ground tiles, visible wood lines, seamless tileable horizontally, 32x32 pixel tile, minimalist, game terrain
```

### 12. hazard_pit.png — 危险坑
> 危险坑标记瓦片，红色/深色坑底，有警示边缘，不能只靠空白表达危险，让玩家一眼知道掉进去会死。

**提示词：**
```
pixel art, deadly hazard pit, dark red void with sharp warning edge, danger zone, jagged red border spikes or triangles, black void center, clearly deadly, visible danger indicator, seamless tileable, 32x32 pixel tile, minimalist, game terrain
```

### 13. drop_deadly_marker.png — 致死落差标记
> 纵向红色警示标记，贴在会致死的高落差边缘，让玩家知道从这里掉下去会死。

**提示词：**
```
pixel art, deadly fall marker, vertical red warning stripe, skull or X danger icon, bright red and dark red alternating, death drop indicator, thin vertical strip, clear danger signal, transparent background, 8x32 pixel, minimalist
```

### 14. drop_safe_marker.png — 安全落差标记
> 纵向黄/橙色提示标记，贴在安全可掉落的落差边缘，让玩家知道这里可以掉但不会死。

**提示词：**
```
pixel art, safe fall marker, vertical yellow and orange warning stripe, caution but not deadly, exclamation mark or arrow down icon, thin vertical strip, clear but less alarming than red, transparent background, 8x32 pixel, minimalist
```

---

## 三、关卡功能物资源（assets/props/）

### 15. spawn_gate.png — 出生口
> 角色出生点入口，橙色或暖色调，带向外箭头或光芒提示，但不能像出口（绿色），一眼可辨认是"起点"。

**提示词：**
```
pixel art, spawn gate entrance, warm orange portal or doorway, subtle outward arrow or glow, starting point indicator, welcoming warm light, distinct from green exit, clean simple frame, transparent background, 32x32 pixel, minimalist
```

### 16. exit_frame.png — 出口门框
> 绿色出口门框（外框），保持当前"绿色出口"语义，门框形状清晰，让玩家在远处也能看到。

**提示词：**
```
pixel art, green exit doorframe, bright green rectangular frame, doorway outline, rescue zone indicator, glowing green border, welcoming safe zone, clean geometric shape, transparent background, 32x32 pixel, minimalist
```

### 17. exit_inner.png — 出口内部
> 出口门框内部填充，比门框颜色更深或更亮，形成对比，让门框和内部区域明显分层。

**提示词：**
```
pixel art, exit door inner fill, dark green or bright white interior, glowing inner portal, safe rescue zone center, contrasts with green frame border, simple filled rectangle or soft glow, transparent background, 24x24 pixel, minimalist
```

### 18. rescue_flash.png — 救援闪光
> 角色进入出口时的短闪光粒子效果，白色或金色，小而明亮，不遮挡后续角色。

**提示词：**
```
pixel art, small sparkle flash effect, white and gold starburst, short rescue confirmation glow, tiny particle burst, 4-point star shape, bright but small, transparent background, 16x16 pixel, minimalist
```

### 19. diggable_cracks.png — 弱墙裂纹叠加纹理
> 可挖弱墙的裂纹叠加层，用于提示玩家这里可以用 Digger，裂纹清晰但不遮盖墙体本体颜色。

**提示词：**
```
pixel art, crack overlay texture, dark jagged crack lines, broken surface pattern, damage indicator for diggable walls, transparent with only crack lines visible, subtle but visible, 32x32 tile overlay, minimalist
```

---

## 四、UI 资源（assets/ui/）

> UI 图标统一尺寸建议 32×32 或 48×48 像素。

### 20. icon_blocker.png — 阻挡者能力图标
> 阻挡者能力图标：一个张开手臂站立的小人，或一面盾牌/停止符号，黄色主题。

**提示词：**
```
pixel art, blocker ability icon, tiny figure with arms stretched out stopping pose, or a hand stop sign, yellow theme, simple geometric icon, recognizable silhouette, 48x48 pixel, minimalist UI icon, transparent background
```

### 21. icon_builder.png — 搭桥者能力图标
> 搭桥者能力图标：一座桥或木板/扳手，棕色/木色主题。

**提示词：**
```
pixel art, builder ability icon, simple bridge shape or wooden plank with hammer, brown wood theme, construction symbol, simple geometric icon, recognizable silhouette, 48x48 pixel, minimalist UI icon, transparent background
```

### 22. icon_digger.png — 挖掘者能力图标
> 挖掘者能力图标：一把镐或铲子，或正在碎裂的方块，棕橙色主题。

**提示词：**
```
pixel art, digger ability icon, pickaxe or shovel tool, or cracking block, brownish orange theme, mining symbol, simple geometric icon, recognizable silhouette, 48x48 pixel, minimalist UI icon, transparent background
```

### 23. icon_parachute.png — 降落者能力图标
> 降落者能力图标：一个降落伞形状，红白或橙白条纹。

**提示词：**
```
pixel art, parachute ability icon, round parachute canopy with stripes, red and white, floating down symbol, simple geometric icon, recognizable silhouette, 48x48 pixel, minimalist UI icon, transparent background
```

### 24. icon_climber.png — 攀爬者能力图标
> 攀爬者能力图标：一个向上箭头或正在攀爬的人物剪影，蓝色主题。

**提示词：**
```
pixel art, climber ability icon, upward climbing figure silhouette or up arrow on wall, blue theme, climbing symbol, simple geometric icon, recognizable silhouette, 48x48 pixel, minimalist UI icon, transparent background
```

### 25. button_selected.png — 选中态按钮背景
> 能力按钮被选中时的背景：亮边框或高亮底色，与未选中态形成明显对比。

**提示词：**
```
pixel art, selected button background, bright glowing border, highlighted rectangular frame, golden or white bright edge, slightly lighter inner fill, clearly distinguishable from normal state, 200x72 pixel, minimalist UI, transparent background
```

### 26. button_disabled.png — 禁用态按钮背景
> 能力按钮被禁用时（次数为0）的背景：低饱和度、低透明度，灰暗色调。

**提示词：**
```
pixel art, disabled button background, grayed out low saturation, dimmed rectangular frame, dark gray border, faded inner fill, clearly inactive and unclickable look, 200x72 pixel, minimalist UI, transparent background
```

### 27. badge_count.png — 剩余次数徽标
> 能力剩余次数角标/小圆标，内部显示数字空间，圆形，颜色醒目（如橙色或红色小圆点）。

**提示词：**
```
pixel art, small circular badge for count display, orange or red circle, small dot with number area inside, corner badge style, simple round shape, clean edges, 16x16 pixel, minimalist UI, transparent background
```

### 28. icon_restart.png — 重开按钮图标
> 重开/重新开始图标：一个循环箭头或回转符号。

**提示词：**
```
pixel art, restart icon, circular arrow looping back, refresh symbol, simple curved arrow forming a circle, clean geometric lines, 32x32 pixel, minimalist UI icon, transparent background
```

### 29. icon_next.png — 下一关按钮图标
> 下一关图标：一个向右的双箭头或快进符号。

**提示词：**
```
pixel art, next level icon, right-pointing double arrow or fast forward symbol, two arrows pointing right, simple geometric lines, clean and directional, 32x32 pixel, minimalist UI icon, transparent background
```

### 30. icon_levels.png — 关卡选择按钮图标
> 关卡选择图标：一个列表或网格符号，代表关卡列表。

**提示词：**
```
pixel art, level select icon, grid of small squares or list with bullet points, levels menu symbol, simple geometric pattern, clean lines, 32x32 pixel, minimalist UI icon, transparent background
```

### 31. icon_completed.png — 关卡完成标记
> 关卡完成勾选标记：绿色对勾，放在已完成关卡旁。

**提示词：**
```
pixel art, completed checkmark icon, green check mark, simple tick shape, bright green, clean bold lines, 24x24 pixel, minimalist UI icon, transparent background
```

---

## 五、音效资源（assets/audio/）

> 音效不适合用图片生成模型，此处仅列出参考描述供音效制作/采集时使用。

| 文件名 | 描述 | 时长 |
|--------|------|------|
| rescue.wav | 明亮短促的叮咚声，救援确认 | < 0.5s |
| death.wav | 低沉短促的砰声，角色死亡 | < 0.5s |
| ability_select.wav | 轻点击声，能力选中反馈 | < 0.3s |
| build_bridge.wav | 木板搭建/放置声 | < 0.5s |
| dig_wall.wav | 碎裂/挖掘声 | < 0.5s |
| parachute_open.wav | 轻布料展开/噗声 | < 0.5s |
| climb_start.wav | 上行动作提示音 | < 0.3s |
| victory.wav | 明亮上升的胜利短乐句 | 1-2s |
| failure.wav | 低沉下降的失败短乐句 | ~1s |

---

## 生成参数建议

- **尺寸**：角色/道具 32×32，UI 图标 48×48，瓦片 32×32，徽标 16×16
- **背景**：全部透明（transparent background）
- **风格**：pixel art, minimalist, clean edges
- **调色板**：每张图不超过 8-12 种颜色，保持统一色调
- **缩放模式**：生成后使用 nearest-neighbor 缩放，不模糊

## 色彩规范速查

| 元素 | 主色 | 辅色 |
|------|------|------|
| 角色（普通） | 亮蓝 #4488CC | 白 |
| 角色（阻挡者） | 黄/橙 #FFAA00 | 橙 |
| 角色（攀爬准备） | 蓝描边 #4488FF | 亮蓝 |
| 普通地面顶面 | 低饱和绿灰 #7A8A6A | 深绿灰 |
| 实体墙 | 深灰 #555555 | 深棕 |
| 弱墙 | 棕橙 #B8782A | 浅棕 |
| 桥梁 | 木色 #C4945A | 深木色 |
| 危险坑 | 红 #CC3333 | 黑 |
| 出口 | 绿 #44BB44 | 亮绿 |
| 出生口 | 暖橙 #FF8833 | 黄 |
| 降落伞 | 红白条纹 #DD3333 / #FFFFFF | — |
