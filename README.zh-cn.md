# GRun

可配置的 Garmin 手表 数据字段

阅读此文档的其他语言版本: [English](./README.md)

![GRun Cover Image](/doc/i18n/zh-cn/GRunCover.png)

## 翻译对照

- datafield - 数据字段
- ETA - 预计完成时间

## 应用汉化作者以及此文档翻译者

[Likenttt](https://github.com/Likenttt)

## 如何使用

1. 按下开始键查看活动列表
2. 选择一项活动
3. 设置活动
4. 选择数据屏幕
5. 根据你的手表型号执行以下操作：

vivoactive3/4
  
- 选择布局, 选择 1
- 选择屏幕 1 > 编辑数据字段，选择Connect IQ > GRun

fenix5
  
- 选择一个数据屏幕用于自定义.
- 选择布局，选择 1
- 选择字段1, 选择Connect IQ > GRun

## 描述

这是一个高度可配置的数据字段，你可以选择展示有多达10个字段。如果配置的字段较少，每一行的字段区域将会自动扩大。第二行和第三行会展示带有标题的值。标题字段有以下三种放置方式：顶部/顶部，顶部/底部，底部/顶部。第一行、第四行、第五行展示的值是没有标题的。

当前支持以下字段：

- 空白
- 时间
- 计时器
- 距离
- 当前心率
- 平均心率
- 心率区间
- 当前配速
- 平均配速
- 当前速度
- 平均速度
- 当前步频
- 平均步频
- 当前功率(仅限部分支持的设备)
- 平均功率(仅限部分支持的设备)
- 卡路里
- 海拔
- 总共上升
- 总共下降
- 5K 预计完成时间
- 10K 预计完成时间
- 半马(21.0975 km)预计完成时间
- 全马(42.195 km)预计完成时间
- 50K 预计完成时间
- 100K 预计完成时间
- 5K 所需配速
- 10K 所需配速
- 半马(21.0975 km)所需配速
- 全马(42.195 km)所需配速
- 50K 所需配速
- 100K 所需配速
- 圈预计完成时间
- 圈数
- 上一圈时间
- 单圈时间
- 单圈距离
- 单圈配速
- 时间提前/落后
- 训练效果 (仅限部分支持的设备)
- 电池图标
- GPS 图标
- GPS 图标和电池图标

大内存设备还支持以下字段：

- 平均配速 (最近 X 秒)
- 平均速度 (最近 X 秒)
- 平均垂直速度 (m/min 米/分钟) (最近 X 秒)
- 平均垂直速度 (m/hour 米/小时) (最近 X 秒)
- 最大功率 (仅限部分支持的设备)
- 5K 所需速度
- 10K 所需速度
- 半马(21.0975 km)所需速度
- 全马(42.195 km)所需速度
- 100K 所需速度
- 圈距所需配速
- 圈距所需速度

以下设备支持训练效果：

- Descent Mk1
- Edge 1030
- Edge 1030 Bontrager
- Edge 520 Plus
- Edge 530
- Edge 830
- Fenix 5
- Fenix 5S
- Fenix 5X
- Fenix 5X Plus
- Fenix 6
- Fenix 6 Pro
- Fenix 6S
- Fenix 6S Pro
- Fenix 6X Pro
- Fenix Chronos
- Forerunner 245
- Forerunner 245 Music
- Forerunner 645
- Forerunner 645 Music
- Forerunner 935
- Forerunner 945
- MARQ Adventurer
- MARQ Athlete
- MARQ Aviator
- MARQ Captain
- MARQ Commander
- MARQ Driver
- MARQ Expedition

以下设备支持功率：

- D2 Charlie
- D2 Delta
- D2 Delta PX
- D2 Delta S
- Descent Mk1
- Edge 130
- Edge 1030
- Edge 1030 Bontrager
- Edge 520 Plus
- Edge 530
- Edge 820
- Edge 830
- Fenix 5
- Fenix 5s
- Fenix 5 Plus
- Fenix 5S Plus
- Fenix 5X
- Fenix 5X Plus
- Fenix 6
- Fenix 6s
- Fenix 6 Pro
- Fenix 6S Pro
- Fenix 6X Pro
- Fenix Chronos
- Forerunner 935
- Forerunner 945
- MARQ Adventurer
- MARQ Athlete
- MARQ Aviator
- MARQ Captain
- MARQ Commander
- MARQ Driver
- MARQ Expedition

大内存设备列表：

- Approach S62
- D2 Charlie
- D2 Delta
- D2 Delta PX
- D2 Delta S
- Descent Mk1
- Edge 1030
- Edge 1030 Bontrager
- Edge 520 Plus
- Edge 530
- Edge 820
- Edge 830
- Edge Explore
- fenix 5 Plus
- fenix 5S Plus
- fenix 5X
- fenix 5X Plus
- fenix 6 Pro
- fenix 6S Pro
- fenix 6X Pro
- Forerunner 645 Music
- Forerunner 945
- MARQ Adventurer
- MARQ Athlete
- MARQ Aviator
- MARQ Captain
- MARQ Commander
- MARQ Driver
- MARQ Expedition
- Oregon 7xx
- Rino 7xx

## 备注

- 有关距离的字段以千米还是英里显示，取决于用户配置文件。
- 与速度相关的字段以公里/小时或英里/小时显示，取决于用户配置文件。
- 与配速相关的字段以分钟/公里或分钟/英里显示，取决于用户配置文件。
- 心率根据用户个人资料设置的心率区间以颜色显示。
  - 区间 1 : 黑色
  - 区间 2 : 蓝色
  - 区间 3 : 绿色
  - 区间 4 : 橙色
  - 区间 5 : 红色
- 当前配速/速度、平均配速/速度、单圈配速和“提前/落后时间”根据应用程序参数以颜色显示
  - 蓝色表示过快，绿色表示目标配速范围内，红色表示过慢

## 配置

### 目标配速

“目标配速”指的是你在一次跑步的理想配速。该值以每公里秒数或每英里秒数为单位进行配置。公里或英里是根据手表设置自动选择的。
例如，如果手表配置了指标值并且你的目标是在 1 小时内跑完 10k，请将“目标配速”配置为 360（360 秒 = 6:00 分钟/公里）。

### 配速范围

配速范围用于确定你的配速/速度是太慢还是太快。例如，如果你将“目标配速”配置为 5:30 分钟/公里（330 秒），并且你可以将“配速范围”配置为 15 秒，这意味着好的配速将在 5:15 分钟/公里到 5:45 分钟/公里之间。如果你的配速/速度太慢，配速/速度显示为红色，如果太快，则显示为蓝色，如果在范围内，则显示为绿色。

![GRun PaceColor](/doc/GRunWatch5.png)

### 单圈距离（单位：米）

单圈距离对于参加竞速跑的人很有用。它允许重新调整距离。例如，如果你将该值设置为 1000（米），它允许你在每公里按下圈数按钮。如果 Garmin 在公里 #1 处计算出的值为 1.01 公里，则在你按下圈数按钮时它将重新调整为 1.00 公里。平均速度、配速、预计完成时间等将使用更新的距离重新调整。为了确定新的距离应该是多少，该距离除以“圈距”并调整为最接近的值。例如，如果“圈数距离”设置为 400 米，并且你在 1195 米处按下圈数按钮，则距离将被修正为 1200 米。如果距离是 1225 米，它也会被修正为 1200 米。重要的是要注意，你不必在每一圈都按下圈按钮，因为该值始终使用最近的圈距进行校正。

__*** Note__ : 无论手表设置如何，圈距必须始终以米为单位进行设置。如果你想将“单圈距离”设置为 1 英里，则必须将其配置为 1609（1609 米 = 1 英里）。

### Header Position

标题可以有三种位置。

#### 1) 顶部 / 顶部

![GRun TopTop](/doc/GRunWatch2.png)

#### 2) 顶部 / 底部

![GRun TopBottom](/doc/GRunWatch3.png)

#### 3) 底部 / 顶部

![GRun BottomTop](/doc/GRunWatch4.png)

### 标题高度

在第 2 行和第 3 行，可以使用区域的百分比来配置标题高度。
你可以通过将值设置为 0 来隐藏标题：

![GRun Hide Headers](/doc/GRunHeaders0.png)

值为 100 将隐藏实际数值（然并卵）：

![GRun Hide Headers](/doc/GRunHeaders100.png)

默认值30看起来像这样：

![GRun Hide Headers](/doc/GRunHeaders30.png)

### 行高比

“行高比”用于配置每行的高度。你只需提供用逗号分隔的 5 个数字。每个数字代表行相对于另一个的高度。默认值为 4,7,7,3,3，第 1 行将使用屏幕的 4 / (4+7+7+3+3)，即屏幕的 16.67%。在高度为 240 像素的设备上，第 1 行将使用 40 像素，第 2 行和第 3 行将使用 70 像素，第 4 行和第 5 行将使用 30 像素。如果一行中的所有参数都设置为“空白”，则其高度将自动设置为0。

使用四列的例子: 4,7,7,0,3

![GRun MiddleColumn100](/doc/GRunWatch15.png)

使用三列的例子: 5,7,0,0,2

![GRun MiddleColumn100](/doc/GRunWatch16.png)

### 列宽比

“列宽比”用于配置第 2 行和第 3 行每个字段的宽度。你只需提供以逗号分隔的 3 个数字。默认值为 2,1,2 意味着列 #1 和 #3 比列号 #2 大 2 倍。对于那些更喜欢百分比的人，使用 "40,20,40" 可以实现类似的结果：列 #1 和 #3 占用可用宽度的 40%，而列 #2 占用 20%。如果一个参数设置为“空白”，它的百分比将设置为0。如果我们保持“2,1,2”的例子，参数#2设置为空，值将自动变为“2,0,2” .在这种情况下，这意味着列 #1 和 #3 将占据屏幕的 50%。

默认值：“2,1,2”，第一行中间参数设置为空白
**注意**：使用 "1,1,1" 且中间参数设置为 空白 的配置会产生相同的结果

![GRun MiddleColumn100](/doc/GRunWatch6.png)

#### Less fields
如果某些字段配置了选项**空白**，则同一行的其他字段将自动展开。例如，以下屏幕配置为 **字段 2B = 空白**。

![GRun Expand](/doc/GRunWatch1.png)

### 统一的背景颜色

默认情况下，第 4 行和第 5 行具有不同的背景颜色。

![GRun BottomTop](/doc/GRunWatch10.png)

要获得统一的背景颜色，只需启用此设置。

![GRun BottomTop](/doc/GRunWatch11.png)

### 动态标题背景颜色

如果启用，标题背景颜色将根据你的配速/速度而改变。

![GRun BottomTop](/doc/GRunWatch12.png)

### 动态数据背景色

如果启用，数据背景颜色将根据你的配速/速度而改变。

![GRun BottomTop](/doc/GRunWatch13.png)

### 动态数据前景色

如果启用，数据前景色将根据你的配速/速度而改变。

![GRun BottomTop](/doc/GRunWatch14.png)

### 字段

使用应用程序参数最多可以设置显示 10 个字段。

![GRun GarminConnectParams](/doc/GarminConnectParams.png)
![GRun Fields](/doc/GRunWatchFields.png)

#### 字段说明

大多数字段不言自明，但其他字段可能需要说明下......

##### ETA 预计完成时间（5K、10K、半程马拉松、马拉松、50K、100K、单圈距离）

ETA（预计完成时间） 字段有助于根据你的平均速度/配速确定你的完成时间。它可以帮助确定 5 公里、10 公里、半程马拉松（21.0975 公里）、马拉松（42.195）、50 公里、100 公里的完成时间或“单圈距离”参数中配置的“单圈距离”。
除了“ETA 单圈距离”，一旦达到距离，每个 ETA 字段都会自动更改。例如，如果你使用“ETA 5K”，则在你跑完 5 公里后，该字段将自动更改为“ETA 10K”。

##### 所需配速/速度（5K、10K、半程马拉松、马拉松、50K、100K、单圈距离）

此字段有助于确定以“目标配速”完成比赛所需的配速/速度。例如，如果你的“目标配速”配置为 360（6:00 分钟/公里）并且你在 15 分钟内跑了 3 公里，“所需配速 5K”将显示“7:30”，因为你还有 15 分钟的时间跑2公里。
除了“所需配速/速度单圈距离”外，一旦达到距离，每个所需配速/速度字段都会自动更改。例如，如果你使用“5K所需配速”，则在你跑完 5 公里后，该字段将自动更改为“10K所需配速”。

##### 提前/落后时间

使用此字段来确定你离“目标配速”有多远。例如，如果你的“目标配速”配置为 360（6:00 分钟/公里）并且你在 28 分 30 秒内跑了 3 公里，则该字段将显示“-1:30”，因为你比计划快了 1 分钟 30 秒。

##### 训练效果

你可以阅读更多关于训练效果的信息@ https://www.garmin.com.my/minisite/runningscience/#training-effect

##### 平均速度/配速（最后 X 秒）

如果你想更好地控制计算出的速度，可以使用此指标。此字段通过计算最后几秒内的跑步距离来计算最后 X 秒的速度/配速。你可以使用字段“速度/配速（最后 X 秒）”配置你想要使用的秒数。

##### 平均垂直速度（/分钟）

根据手表设置，以米/分钟或英尺/分钟为单位计算垂直速度。该字段通过计算现在和前 X 秒之间的高度差来计算最后 X 秒的垂直速度。你可以使用字段“垂直速度（最后 X 秒）”配置要使用的秒数。

## 更新日志

### Version 1.27

- Added option to control row height
- Added "Required Pace to meet Target Pace" 50K on all devices.
- Added ETA 50K on all devices
- Current Time now use standard format hh:mm (Example: 13:00) instead of 13h00¸
- Code modification to maximize font size

Memory Usage on va3    (Current | Peak) : 
   * At startup:           25.5 kB | 27.2 kB
   * 10 sec running:       25.5 kB | 27.6 kB
   * After setting change: 25.5 kB | 28.5 kB

Memory Usage on fenix5 (Current | Peak) : 
   * At startup:           25.4 kB | 27.3 kB
   * 10 sec running:       25.4 kB | 27.7 kB
   * After setting change: 25.4 kB | 28.4 kB

Memory Usage on fr945  (Current | Peak) : 
   * At startup:           29.6 kB | 31.6 kB
   * 10 sec running:       29.6 kB | 32.0 kB
   * After setting change: 29.6 kB | 32.6 kB

### Version 1.26
 - Updated background/foreground colors for better readability
 - Added grey color for HR 区间 1
 - Added the Current Power and Average Power and supported low memory devices (Fenix 5/5s/6/6s/Chronos, Forerunner 935 and Edge 130)

Memory Usage on va3    (Current | Peak) : 
   * At startup:           24.9 kB | 26.4 kB
   * 10 sec running:       24.9 kB | 26.8 kB
   * After setting change: 24.9 kB | 27.8 kB

Memory Usage on fenix5 (Current | Peak) : 
   * At startup:           25.0 kB | 26.7 kB
   * 10 sec running:       25.0 kB | 27.1 kB
   * After setting change: 25.0 kB | 27.8 kB

Memory Usage on fr945  (Current | Peak) : 
   * At startup:           29.1 kB | 30.9 kB
   * 10 sec running:       29.1 kB | 31.3 kB
   * After setting change: 29.1 kB | 32.1 kB

### Version 1.25
 - Added "Required Pace to meet Target Pace" for 5K, 10K, Half Marathon, Marathon distance and 100K on all devices.
 - Added ETA 100K on all devices
 - Added Heart Rate 区间 on all devices
 - Replaced option for "Dynamic Data Color". Data Color can now be more customized
 - Replaced blue/green color code on white background
 - Code improvement to optimize memory utilization
 - Added support for new watches (Approach S62, MARQ Adventurer, MARQ Commander, Darth Vader, Rey)

Memory Usage on va3   (Current | Peak) : 
   * At startup:           24.6 kB | 26.2 kB
   * 10 sec running:       24.6 kB | 26.6 kB
   * After setting change: 24.6 kB | 27.5 kB

Memory Usage on fr945 (Current | Peak) : 
   * At startup:           28.9 kB | 30.8 kB
   * 10 sec running:       28.9 kB | 31.2 kB
   * After setting change: 28.9 kB | 32.0 kB

### Version 1.24
 - Bugfix on Garmin Venue to properly display fields

Memory Usage on va3   (Current | Peak) : 
   * At startup:           25.6 kB | 27.0 kB
   * 10 sec running:       25.6 kB | 27.4 kB
   * After setting change: 25.6 kB | 28.4 kB

Memory Usage on fr945 (Current | Peak) : 
   * At startup:           31.5 kB | 33.4 kB
   * 10 sec running:       31.5 kB | 33.7 kB
   * After setting change: 31.5 kB | 34.5 kB

### Version 1.23
 - Replaced "Min Pace", "Max Pace" settings with "Target Pace" and "Pace Range"
 - Reorder settings
 - Added color for speed metrics (current, average)
 - Removed the following fields on all supported devices:
   + Total Corrected Distance
 - Added the following fields on all supported devices:
   + Time Ahead/Behind
   + Average Cadence
 - Added the following fields on high-memory devices:
   + Current Power
   + Average Power
   + Max Power
   + Average Speed/Pace over a defined period of time
   + Average Vertical Speed over a defined period of time (in meter or feet per minute)
   + Average Vertical Speed over a defined period of time (in meter or feet per hour)
   + HR 区间 Number
   + Target Pace/Speed (5K, 10K, Half Marathon, Marathon, Lap Distance)

Memory Usage on va3   (Current | Peak) : 
   * At startup:           25.5 kB | 27.0 kB
   * 10 sec running:       25.5 kB | 27.4 kB
   * After setting change: 25.5 kB | 28.4 kB

Memory Usage on fr945 (Current | Peak) : 
   * At startup:           31.5 kB | 33.4 kB
   * 10 sec running:       31.5 kB | 33.7 kB
   * After setting change: 31.5 kB | 34.5 kB
   
### Version 1.22
 - BugFix : It it now possible to use "Lap Time" if "Lap Distance" is set to 0
 - Compiled using Connect IQ SDK Release 3.1.6

### Version 1.21
 - Removed "Average Pace (Calculated manually using timer/distance)" field
 - Replaced field "Time spend on current km/mile" by "ETA Lap"
 - Replaced field "Time spend on previous km/mile" by "Previous Lap Time"
 - Added field "Lap Count" 
 - Increased line width between fields from 1 pixel to 2 pixels


 - Memory Usage on va3 (Current | Peak) : 
   * At startup:           25.6 kB | 27.0 kB
   * 10 sec running:       25.6 kB | 27.4 kB
   * After setting change: 25.6 kB | 28.4 kB
 
 - Compiled using Connect IQ SDK Release 3.1.5
 
### Version 1.20
 - Added a parameter to have a uniform background color. By default rows 4 and 5 have a different background color.
 - Added support for new watches (Descent Mk1, Edge 530, Edge 820, Edge 830, Fenix 6, Fenix 6 Pro, Fenix 6S, Fenix 6S Pro, Fenix 6x Pro, Forerunner 245, Forerunner 245m, Forerunner 945, Captain Marvel, First Avenger, MARQ Athlete, MARQ Aviator, MARQ Captain, MARQ Driver, MARQ Expedition, Oregon 7xx, Rino 7xx, Venu, Vivoactive 3d, Vivoactive 3m LTE, Vivoactive 4, Vivoactive 4S)

### Version 1.19
 - Redesign settings to adjust column width (Less user friend, but more customizable).
   + Default value is "2,1,2" which means first column will have a width of 2/5, second column will have a width of 1/5 and third column will have a width of 2/5. If a parameter is set to Empty, the value is ignored. For example, if column2 is empty, that the ratio become 2/4 for column #1 and 2/4, 0/4 for column #2 and 2/4 for column #3.
 - Add a parameter to set "Header Height" in percentage. This allow to completely hide headers to maximize space.
 - Header Font tried to used the maximum space possible
 - Changed default parameters

### Version 1.18
 - Added Training Effect on supported devices (Fenix 5, Fenix 5s, Fenix 5x, Fenix 5x Plus, Fenix Chronos, Forerunner 645, Forerunner 645 Music, Forerunner 935, Edge 1030, Edge 520 Plus)
 - Add a parameter to correct distance on lap. Distance is rounded to the nearest "Lap Distance".
 - Code improvement to optimize memory
 - Code Framework using Jungles to implement features for specific devices (Example: Training Effect)

### Version 1.17
 - Added options to display Header background or data foreground in color
 - Area 4a/4b and 5 can be shrinked together if one of them is empty
 - Improve code to use less memory

![GRun Version 1.16](/doc/GRunWatch9.png)

### Version 1.15
 - Added color for Lap Pace

### Version 1.14
 - Added the following fields: Lap Time, Lap Distance, Lap Pace
 
### Version 1.13
 - Adjust font vertical position for fenix 5s and fenix chronos

### Version 1.11
 - Area 4 and 6 expand vertically: If values 4A/4B or 5 are missing, area 4A/4B or 5 will expand vertically
 - ETA Auto-Switch: If one area is configured with "ETA 5K" and you reach 5 km during your run. the value will automatically change to "ETA 10K", then "ETA 21K", then "ETA 42K". Same apply to "ETA 10K" and "ETA 21K".
 - "Time spend on current km/mile" displays a background color indicating progress on the current km/mile.
 - Float fields are displayed with 2 digits if lower than 10 (Example: 9.92). Values greather than 10 display a single digit (Example: 10.1)
 - Bug Fix: Area "Battery Icon" now display the battery icon instead of the GPS icon
 - Code Optimization to minimize memory usage
 
 ![GRun Version 1.10](/doc/GRunWatch8.png)
