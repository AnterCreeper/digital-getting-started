# Chapter 2 Roadmap

## 章节名称

第 2 章：开发环境、EDA 工具与 FPGA 实践基础

## 章节 slug

`ch02-eda-tools-fpga`

## 章节定位

本章与第 1 章有根本差异。第 1 章在建图——全景地图、概念地图、产业链地图。第 2 章不再继续扩地图，而是开始训练读者进入真正的工程工作方式：**在 Linux / 命令行环境下组织文件、安装工具、执行脚本、观察输出，并借助一个最小 EDA 实验闭环获得第一次可验证的正反馈。**

因此，本章承担两个并列目标：

- **目标 A：Linux / 命令行工作能力入门。** 读者要第一次真正开始在终端中完成工程动作，而不是只把终端当成“黑窗口”。后续若干章节默认读者已经具备这套最小操作能力。
- **目标 B：EDA 工具链闭环初体验。** 读者要能亲手跑通一条 **写 RTL → 仿真 → 看波形 → 综合 → 查看门级结构** 的最小工程回路，建立“设计可被观察、可被验证”的直觉。

这两个目标之间不是并列摆放的两门课，而是前者为后者提供工作界面，后者为前者提供真实任务。换句话说：**不是为了学 Linux 而学 Linux，而是借一个真实的数字设计实验，把命令行工作方式变成身体经验。**

本章不是深讲工具原理的章，也不是教 Verilog 语法的章（那是第 4 章的事）。本章也不要求学生在第一次实验中吃透 RTL 内部实现。它的教学契约应该明确为：

- 学生需要先会“跑通、观察、比对”，而不是先会“设计、优化、解释全部内部细节”
- lab 的主要作用是提供工具链体验，而不是承载 HDL 语义教学
- `Makefile`、`Tcl`、更完整的自动化流程只做埋点，不在本章展开

类比：先学会进入车里、点火、挂挡、看仪表盘、把车开起来（Linux + 工具链闭环），再去学发动机怎么转、变速箱怎么设计（电路原理与更完整的工程自动化），而不是反过来。

本章围绕一个核心问题展开：

- **为什么工具环节必须先跑通？** 即时反馈是认知杠杆——写完几行 RTL 马上在波形里看到行为，比硬啃两章门级电路再碰工具更高效。
- **最小可验证回路的边界是什么？** Icarus 仿真 + GTKWave 波形 + Yosys 综合 + 理解仿真与综合的语义差异。
- **如何把这个回路交给读者？** 用同一个实验（呼吸灯 PWM 计数器）贯穿全部环节，而不是每节换一个例子。

## 参考教材取向

第 2 章没有单一教材模板。组织方式参考了：

- `DDCA (Harris & Harris)` 第 1 章讲完 `digital abstraction` 后，在后续章节逐步引入 HDL 和仿真——但 DDCA 把工具嵌入各章，本书选择单独一章集中交付。
- 开源工具链社区文档（Icarus Verilog Guide、Yosys Manual、GTKWave User Guide）作为命令参考。
- Basys3 参考手册作为 FPGA 端目标规格。

## 目标读者与写作风格

- 面向电子、计算机、自动化等相关专业本科生
- 假设读者有一台 Linux 机器（物理机 / VM / WSL），能 `apt install`
- 假设读者**从未**跑过任何 EDA 工具
- 可读性优先，命令必须给出完整可拷贝的行，不省略参数
- 每个工具的首次出现必须回答：它输入什么、输出什么、在整个流程的哪个位置
- 散文体为主；工具操作的步骤可以用编号列表，但步骤之间必须有"这一步在做什么"的短句连接

## 学习目标

学完本章后，读者应能够：

- 独立搭建开源数字电路开发环境（Icarus Verilog + GTKWave + Yosys）
- 创建规范的工程目录结构，理解每个目录的职责
- 用 Icarus Verilog 编译 RTL 和 testbench，用 GTKWave 打开并分析波形
- 读懂波形中的 time axis、signal value、X/Z 语义和 clock edge 行为
- 用 Yosys 对同一设计执行综合，打开并观察门级网表
- 区分仿真行为和综合产物之间的本质差异，识别至少一种"仿真通过但综合出问题"的场景
- 理解开源工具与商业工具的能力边界
- 建立 FPGA 的结构直觉（LUT + FF + 布线），知道它在教学和原型验证中的角色
- 完成一个从 RTL 到综合网表的完整实验：呼吸灯 PWM 计数器

## 建议章节结构

### §1 导读：为什么先把工具跑通

本节任务：

- 交代本章为什么存在，以及为什么放在第 2 章而不是第 3 章之后
- 建立"即时反馈 → 认知杠杆 → 持续激励"的论点
- 画出全章路线图：安装 → 仿真 → 波形 → 综合 → 对比 → 工具地图 → FPGA → 实验

建议回答的问题：

- 为什么不先学完电路再学工具？
- 为什么用开源工具而不是商业工具？（答案：零成本、零 license、可复现）
- 本章结束时我能做出什么？（答案：一个在 Basys3 板上能跑的呼吸灯）

### §2 工程目录与 Linux 基础

本节任务：

- 给芯片设计环境的"最小 Linux 子集"
- 建立工程目录约定
- 让读者第一次开始用命令行完成真实工程动作

本节的教学边界必须非常明确：

- **这不是一门完整的 Linux 课程**
- **这也不是一张敷衍的命令速查表**
- 本节的目标是让读者具备后续章节可持续使用的最小命令行工作能力

建议把内容分为三个层级：

#### L0：本章必须掌握，且会立即用到

这部分是本节主线，slides 与 handout 都要覆盖，并且 lab 中必须反复出现。

**1. 文件系统最小直觉**

- `/`：根目录，整个文件系统的起点
- `~`：用户主目录，你的个人文件都放这里（等价于 `/home/username`）
- `.`：当前目录，`..`：上级目录
- 绝对路径 vs 相对路径：以 `/` 或 `~` 开头的是绝对路径，否则是相对路径

要求读者能回答：为什么 `bash sim/run.sh` 能跑，为什么站在别的目录里这条命令可能就不对。

**2. 终端与 Shell 的角色**

如果你习惯了 Windows 图形界面，可能会问：为什么不直接双击图标、拖动文件、点击按钮？

答案是：**可以，但在工程工作中不够稳定，也不够可复现。**

- **终端（Terminal）**：你输入文字命令、查看文字输出的窗口
- **Shell**：解释并执行这些命令的程序，bash 是最常见的一种

应该明确告诉读者：数字设计流程天然包含大量重复动作，命令行的价值不是“更高级”，而是**可复现、可记录、可脚本化**。

**3. 第一批必须会用的命令**

| 命令 | 作用 | 常用例子 |
|------|------|----------|
| `ls` | 列出当前目录下的文件和文件夹 | `ls`, `ls -l` |
| `cd` | 切换目录 | `cd ~`, `cd ..`, `cd sim/` |
| `mkdir` | 创建新目录 | `mkdir my_project` |
| `which` | 查找程序的安装路径 | `which iverilog` |
| `bash` | 执行一个 shell 脚本 | `bash sim/run.sh` |
| `chmod +x` | 给文件添加可执行权限 | `chmod +x run.sh` |
| `cat` 或 `less` | 查看小文件 / 分页查看较长文件 | `cat README.md`, `less synth.log` |
| `apt update` | 更新本地软件包索引 | `sudo apt update` |
| `apt install` | 安装软件 | `sudo apt install iverilog gtkwave yosys` |

这里的原则是：**只教读者当前实验立刻会用到的动作。**

**4. 两个高频坑必须显式讲**

- **终端里 `Ctrl+C` 不是复制，而是终止当前命令**
- 终端里的复制粘贴通常是 `Ctrl+Shift+C` / `Ctrl+Shift+V`

这不是细节，而是第一天最容易踩的坑。

**5. 环境入口**

- 没有 Linux 机器时，推荐 WSL 或 VirtualBox + Ubuntu
- 安装工具前先 `sudo apt update`
- 装完后用 `which iverilog && which gtkwave && which yosys` 检查是否真正可用

#### L1：本章见过即可，不作为主线考核

这部分应主要放在 handout 的 `tipbox` / `warnbox` 中，slides 不展开，只点名其存在价值。

- `find`：按文件名搜索
- `grep`：在文件内容中搜索关键词
- `source`：在当前 shell 中加载环境设置
- `tar`：解压压缩包
- `cp` / `mv` / `rm`：复制、移动、删除
- 重定向 `>` 与管道 `|`
- `.bash_history`：查看过去执行过的命令
- `nano`：作为最简编辑器的存在说明

这些内容对后续工程非常有用，但在本章里不应挤占主线。它们的定位是：**让学生知道有这些工具，遇到问题时能回到 handout 查，而不是要求第一次就全熟练。**

#### L2：只做埋点，不展开

这部分只需在 handout 中一句话埋钩子，为后续章节铺路。

- `tmux`：远程长任务管理
- 更系统的软件源配置与镜像源切换
- 更详细的权限位与所有权模型
- `chown` 等系统管理命令
- TCL：EDA 工具中的事实标准脚本语言

这里的原则是：**本章先让读者会走路，不急着教他背完整的工具箱。**

必须覆盖：

**工程目录模板：**

```
lab1-breathing-led/
├── rtl/          # RTL 源文件
├── tb/           # 仿真 testbench
├── sim/          # 仿真脚本与产物
├── synth/        # 综合脚本与结果
├── fpga/         # FPGA 上板文件（XDC 约束等）
└── README.md     # 实验说明
```

**写作要求：slides 与 handout 的职责分离必须清楚**

- **slides**：只负责建立“Linux 长什么样、终端怎么工作、为什么工程师必须依赖它”的画面感。用少量命令、对比图、终端截图、目录树示意图建立第一印象。
- **handout**：承担完整细节，解释命令含义、常见报错、路径直觉、安装步骤、tipbox/warnbox 和扩展说明。
- **lab**：让读者反复实际执行 `ls`、`cd`、`bash sim/run.sh`、`bash synth/run.sh` 这类动作，把抽象说明变成肌肉记忆。

建议 slides 只保留以下几类画面：

- 一张“图形界面 vs 命令行”的直观对照图
- 一张“Terminal + Shell + command + output”的关系图
- 一张工程目录树图
- 一个真实终端截图：`apt install`、`which`、`bash sim/run.sh`
- 一个高频坑警示框：`Ctrl+C`、路径写错、命令找不到

建议 handout 明确增加以下辅助元素：

- `warnbox`：`Ctrl+C`、`sudo`、`rm` 等风险动作
- `tipbox`：`Tab` 自动补全、`less`、`.bash_history`
- “如果报错该先看哪里”的最小排障清单
- “本节结束后你应该真的会做什么”的自检列表

> **延伸阅读**：如果你希望更系统地学习 Linux 和 Shell，推荐阅读《Getting Started Handout》中的[终端 101](https://github.com/ZangXuanyi/getting-started-handout/blob/main/book3/01-shell-101.tex)和[开始使用 Linux](https://github.com/ZangXuanyi/getting-started-handout/blob/main/book3/02-linux.tex)两章。这两份材料覆盖了文件系统、权限、进程、包管理等更完整的 Linux 知识体系。

### §3 仿真三件套：Icarus Verilog + GTKWave + VVP

本节任务：

- 讲清仿真流水线：`iverilog`（编译）→ `vvp`（运行）→ `GTKWave`（查看）
- 用 lab1 的代码作为贯穿示例

必须覆盖：

- 安装：`sudo apt install iverilog gtkwave`（Ubuntu/Debian）、WSL 补充说明
- Icarus 做了什么：编译 `.v` → 生成可执行文件 `a.out`（`-o` 指定输出名）
- VVP 做了什么：运行 a.out，执行 `$dumpfile` / `$dumpvars`，产生 `.vcd` 波形文件
- GTKWave 做了什么：打开 `.vcd`，显示信号时间轴
- `$dumpfile`, `$dumpvars`, `#10`, `$finish` 的最基本用法
- 三步即得波形：

```bash
iverilog -o sim/tb.vvp rtl/breathing_led.v tb/tb_breathing_led.v
vvp sim/tb.vvp
gtkwave sim/tb.vcd
```

写作提醒：

- 不要在这一节讲仿真模型差异、event region、delta cycle
- 重点：让读者跑通第一条命令链

图需求：仿真三件套的数据流图（`.v` → `iverilog` → `a.out` → `vvp` → `.vcd` → `GTKWave` → 屏幕上的波形）

### §4 读懂波形

本节任务：

- 教读者从 GTKWave 的波形中提取信息
- 建立 time axis、signal value、edge 的基本直觉

必须覆盖：

- 时间轴：`#0` 初始状态、时钟周期、分辨率
- 信号的四种值：`0`、`1`、`X`（未知）、`Z`（高阻）——在波形里分别怎么显示
- 组合逻辑的延迟：输入变化后输出不是立刻变
- 时序逻辑的边沿行为：寄存器在 `posedge clk` 采样，输出在下一个沿之前稳定
- 把 lab1 的波形展开：`duty` 信号先升后降（三角波），`pwm_out` 的 duty cycle 由窄变宽再变窄——在波形上一眼看出来（注：testbench 中使用缩微版参数，波形数值范围与板上真实运行不同，但形状关系一致）

图需求：GTKWave 截图，标注 time axis、signal、clock edge、X region、duty cycle 变化（用 lab1 的实际波形）

### §5 综合：RTL 到门级网表

本节任务：

- 讲清综合是怎么把 RTL 变成门级逻辑的
- 用 Yosys 对 lab1 跑一次综合

必须覆盖：

- 安装：`sudo apt install yosys`（或通过 oss-cad-suite）
- Yosys 做了什么：读 RTL → 逻辑优化 → 映射到工艺无关的门级单元 → 输出网表
- 综合中的关键概念（只讲概念，不深入）：
  - 逻辑综合不是把 RTL 解释成软件指令
  - 综合是将 HDL 语句映射到电路结构的过程，例如将 `always @(posedge clk)` 识别为寄存器，把 `assign` 识别为组合逻辑
  - 综合器会做优化，但更深入的优化策略不在本章展开
- 三步得网表：

```bash
yosys -p "read_verilog rtl/breathing_led.v; synth -top breathing_led; write_verilog synth/breathing_led_synth.v"
```

- 打开门级网表，看它长什么样——读者应该被惊到：原来 `.v` 是这么被翻译成 `$_AND_`、`$_DFF_P_` 这类通用门单元的

写作提醒：

- 不要求读者理解网表里的每一条连接，只要他能认出"原来的 counter[9:0] 变成了几十个 DFF"就够了
- 不教优化策略、不教约束编写（第 8 章的事）

对比说明：观察综合前后的文件差异——RTL 文件是人写的可读代码，网表文件是工具生成的门级连接（可通过对比文件内容建立直观认知，无需额外绘图）

### §6 仿真 vs 综合：行为一致性的裂隙

本节任务：

- 这是第 2 章在认知上最深的一节
- 让读者第一次面对"仿真不等于综合"这一事实
- 用 lab1 的代码制造一个可控的裂隙 + 教会读者识别它

必须覆盖：

- 仿真验证的是**行为**（behavior），综合指向的是**结构**（structure）
- **仿真通过 ≠ 综合后正确**——综合器有自己的一套语义规则
- 用 lab1 的 breathing_led.v 做一次对比：
  - 仿真波形：counter 正常翻转，duty cycle 正确扫变
  - 综合网表：counter 被映射为 N 个 DFF + 加法器逻辑，pwm_out 被映射为比较器的组合逻辑
  - 重点对比的不是"哪个错了"，而是"同一个 .v 在仿真和综合里被不同工具按不同规则解释——你需要确认两种解释的结果一致"
- 举一个具体警例（**纯教学示例，不在 lab1 代码中**）：在 RTL 里写了一个不完整的 `if (condition) out = 1;`（没有 else），仿真里 out 保持旧值，综合器推断出一个锁存器——两种行为在你不知情时已经不一致了
- warnbox：**没有任何验证手段能证明一个设计"绝对正确"——正确永远是条件性的。** 仿真只能证明"在给出的这组激励下，输出没有出错"；综合只能证明"RTL 被映射成了这样一组逻辑门"。两者都不保证激励覆盖了所有场景，也不保证物理芯片在真实条件下仍然正确。验证是一个逐层收敛的过程。

对比说明：仿真结果是时序波形（展示"做了什么"），综合结果是门级网表（展示"怎么实现"）——两者解释同一个 RTL 的方式不同，需分别确认（可通过实际运行工具观察，无需额外绘图）

### §7 开源工具 vs 商业工具版图

本节任务：

- 给一张工具地图，让读者知道自己在哪
- 防止"只会开源工具但不知道商业工具在干什么"的视角盲区

必须覆盖：

- 一图：横轴是功能（仿真 / 综合 / lint / 形式验证 / 布局布线），纵轴是等级（开源 / 商业 / FPGA 厂商自带），每个格子里标注工具名
- 开源工具：
  - Icarus Verilog：入门仿真，速度一般，不支持 SystemVerilog 完整语法
  - GTKWave：波形查看，开源波形工具的事实标准
  - Yosys：综合，被学术界和轻度工业界广泛采用，支持多种工艺库
  - Verilator：高速仿真 + lint，速度快但不支持 4 态（X/Z）——仅提一句，不作为教学内容
- 商业工具：Synopsys VCS / Cadence Xcelium / Siemens Questa（仿真）、Synopsys Design Compiler / Cadence Genus（综合）、Mentor / Cadence（lint/CDC）、Synopsys IC Compiler II / Cadence Innovus（后端）
- FPGA 厂商工具：Xilinx Vivado / Intel Quartus——自带完整的仿真、综合、实现和上板流程
- 为什么不在这里用商业工具：license 成本、安装复杂度、入门门槛

写作提醒：

- 这一节不是工具百科，是"地图"
- 每类工具说清三个问题：它干什么、为什么工业界选择它、我们现在为什么选开源替代

图需求：开源 vs 商业 vs FPGA 厂商工具地图（表格或矩阵图）

### §8 FPGA 基础：教学沙盘与原型验证器

本节任务：

- 建立 FPGA 最基本的结构直觉
- 解释为什么数字电路教学离不开 FPGA
- 为后续上板实验打底

必须覆盖：

- FPGA 是什么——一句话：一块可以反复重新编程的硬件芯片
- 为什么叫"现场可编程门阵列"：F = Field, P = Programmable, G = Gate, A = Array
- 基本结构直觉（三要素）：
  - **LUT（查找表）**：实现任意 N 输入组合逻辑
  - **FF（触发器）**：实现时序逻辑
  - **可编程互连**：连接 LUT 和 FF
- 一张简化 FPGA tile 图：LUT + FF + 布线资源如何组合
- ASIC 和 FPGA 的核心差异：制造方式、速度、功耗、成本、灵活性
- FPGA 在教学中的角色：
  - 你需要物理反馈来确认设计在真实硬件上工作
  - FPGA 是你的物理沙盘——你不需要流片但可以获得近真的硬件行为
  - 基本流程：RTL → 综合 → 布局布线 → 下载到 FPGA → 观察板上的实际行为
- Basys3 简介：
  - 开发板载体：Xilinx Artix-7 FPGA，型号 **xc7a35t-1cpg236c**
    - `xc7a`：Xilinx 7 系列 Artix 家族
    - `35`：约 35K 逻辑单元（Logic Cells）
    - `t`：集成高速串行收发器（transceiver）。Artix-7 全系器件均带 `t`，表示该家族具备 GTP 收发器能力
    - `-1`：速度等级（-1 为标准，-2 较快，-3 最快）
    - `cpg236`：封装形式，236 个引脚
    - `c`：温度等级（Commercial，0°C ~ +85°C）。另有 `i`（Industrial，-40°C ~ +100°C）、`e`（Extended）等
  - 板上外设：16 个用户 LED、4 位 7 段数码管、5 个按键、16 个拨码开关、USB-UART、VGA、PMOD 接口
  - **参考资料**：Digilent Basys3 官方参考手册与引脚约束文件（XDC）——本章 fpga/ 目录提供精简版 XDC，完整版见 Digilent 官网

- Vivado IO Planner：后续使用 Vivado 完成上板流程时，你会用到这个可视化工具。它把 FPGA 芯片的物理引脚以图形方式展示出来，你可以把 RTL 中的端口（如 `pwm_out`）拖拽到具体的引脚位置（如 LED0）。对于 Basys3，IO Planner 会显示 `cpg236` 封装的 236 个引脚中哪些已经连接到板上的 LED、按键等外设

写作提醒：

- 不讲 FPGA 架构细节（LUT 内部电路、carry chain、BRAM……那是另一门课的事）
- 重点建立"FPGA 是一个可重配置的硬件"这一直觉

图需求：
- 简化 FPGA tile 结构图（LUT + FF + 互连）
- Basys3 板卡实物照片 + 标注 LED/开关/按键位置
- Vivado IO Planner 截图（展示 Basys3 的引脚分配界面）

### §9 回收主线 + Makefile / 上板补充 + 本章小结

本节任务：

- 回收本章前面已经分散讲过的主线：安装、仿真、波形、综合、对比、FPGA 直觉
- 不再重复铺开完整 walkthrough，而是把这些环节重新串成一条可复述的工程闭环
- 补充两个实际工程入口：`Makefile` 的统一命令入口，以及 Basys3 上板验证入口
- 明确过渡到第 3 章的出口

写作要求：

- 从 RTL 到综合网表的主流程，已经在前面各节分段讲解；本节应做“回收”和“补充”，而不是再次完整重讲一遍
- `handout` 在这一节主要承担两类内容：
  1. 用简短文字把前面各节串起来，让读者能复述整条闭环
  2. 补充 `make sim` / `make synth` / `make fpga` / `make program` / `make clean` 这类统一入口，以及上板所需的前提条件
- `slides` 仍以流程图和总结为主，不在最后一节堆命令细节

回收判断（handout 需显式写出）：

- 到这里，读者不一定会设计芯片，但已经拥有了一条可验证、可复现、可继续复用的设计回路
- 从第 3 章开始，每一个学到的概念（逻辑门、状态机、加法器）都可以用这个回路立刻"看到"
- 从第 4 章开始学 Verilog 语法时，你已经不需要再同时操心"iverilog 怎么装、GTKWave 怎么看"

### §10 术语表与练习题

术语表（handout）：

| 术语 | 简要说明 |
|------|----------|
| RTL | Register Transfer Level，寄存器传输级。用寄存器 + 组合逻辑描述硬件行为。 |
| Testbench | 仿真用的验证代码，为 DUT（被测设计）提供激励并检查输出。 |
| Icarus Verilog | 开源 Verilog 仿真器。 |
| GTKWave | 开源波形查看器，读取 VCD 等波形格式。 |
| Yosys | 开源 RTL 综合工具，将 RTL 转换为门级网表。 |
| VCD | Value Change Dump，波形文件格式，记录仿真过程中信号的每次变化。 |
| VVP | Icarus Verilog 的运行时引擎。 |
| Netlist | 网表——描述逻辑门及其连接关系的文件。 |
| LUT | Look-Up Table，FPGA 中实现组合逻辑的基本单元。 |
| FF | Flip-Flop，触发器，FPGA 中实现时序逻辑的基本单元。 |
| PWM | Pulse Width Modulation，脉冲宽度调制。通过调节高电平占比来控制平均功率。 |
| Duty Cycle | 占空比，PWM 波形中高电平时间占总周期的比例。 |

练习题（7 题）：

1. 在你的 Linux 环境中安装 Icarus Verilog、GTKWave、Yosys。截图证明 `which iverilog`, `which gtkwave`, `which yosys` 都能找到对应路径。
2. 把 lab1-breathing-led 跑通（仿真 + 综合）。贴出仿真波形截图，说明你看到了什么——请指出 PWM 计数器的值和 pwm_out 信号之间的关系。
3. 打开综合后的门级网表 `breathing_led_synth.v`，找到和原始 RTL 中 `counter` 对应的寄存器单元。它们是用什么单元名表示的？（提示：搜索 `$_DFF`）
4. 修改三角波计数器位宽（从 15 位改成 13 位），重新仿真。波形中 duty cycle 的变化周期发生了什么变化？为什么？（提示：思考三角波步数和呼吸周期的关系）
5. 从"为什么需要综合器"（Why）、"综合器做什么"（What）、"怎么用 Yosys"（How）三个维度分析 Yosys，并对比仿真器和综合器的区别。
6. 修改 breathing_led.v 中比较器的逻辑，让 LED 在计数器低位时亮（而不是高位）。仿真确认波形变化。这在板上意味着什么？
7. 选做一个开源 EDA 工具调研：在 Icarus Verilog、GTKWave、Yosys 之外，搜索至少一个你之前没听过的开源数字设计工具（提示：OpenROAD、F4PGA（原 SymbiFlow）、Verilator、Cocotb 等方向）。用一段话说明它做什么、和本章学过的哪个工具功能对应、它比对应工具强在哪或弱在哪。

## 单讲组织原则

本项目按"一章 = 一讲"执行，因此第 2 章不拆成多讲。上面的 §1–§10 是单讲内部的内容组织顺序。

单讲实现建议：

- `slides.tex`：约 17–20 帧，负责建立画面感、顺序感和主线认知。Linux 部分只讲最小骨架、典型画面和常见误区，**不在 slides 上堆命令清单，也不逐行贴代码。**
- `handout.tex`：约 15–18 页正文，负责承担细节密度。Linux 部分在这里展开，EDA 工具命令、参数解释、排障提示、术语表和主线流程的分段讲解也主要落在这里；最后一节负责回收主线并补充 Makefile / 上板入口。
- `examples/lab1-breathing-led/`：完整可运行的 lab，包含 RTL、testbench、运行脚本。其主要职责是让读者获得工具链体验，而不是在本章承担 RTL 设计教学。
- slides 建立结构和直觉，handout 提供手册式细节，lab 提供动手关节。三者分工必须清楚，避免 handout 写成 slide 注释稿，也避免 slide 写成命令手册。

建议节奏：

- 前 1/3（§1–§3）：建立"为什么要工具"和"仿真回路"的信心
- 中 1/3（§4–§6）：波形和综合——从看到理解
- 后 1/3（§7–§9）：工具地图 + FPGA + 实验——把回路合龙

## 实验 Lab：呼吸灯 PWM 计数器（lab1-breathing-led）

### 实验目录结构

```
examples/lab1-breathing-led/
├── README.md                  # 实验说明（中文）
├── rtl/
│   ├── breathing_led.v        # PWM 计数器 + 三角波比较
│   └── top.v                  # 顶层例化（为后续上板预留封装）
├── tb/
│   └── tb_breathing_led.v     # testbench
├── sim/
│   └── run.sh                 # Icarus 编译 + VVP 运行 + GTKWave 打开
├── synth/
│   └── run.sh                 # Yosys 综合 → 门级网表
└── fpga/
    └── basys3.xdc             # Basys3 引脚约束文件（标注：后续章节完成上板）
```

### 实验设计：呼吸灯

**核心电路：**

- **三角波生成器**：15 位三角波计数器（32768 步），输出 13 位占空比基准（0 → 8191）。周期 = 32768 × 8192 / 100MHz ≈ **2.68 秒**（一次完整的暗→亮→暗循环）
- **PWM 载波**：13 位计数器，0 → 8191 循环。频率 = 100MHz / 8192 ≈ **12.2kHz**，远高于人眼闪烁融合频率（~60Hz），LED 亮度看起来连续变化
- **比较器**：pwm_cnt < duty_cycle 时 pwm_out = 1。duty_cycle 由三角波实时给出，因此占空比从 0% 平滑上升到 100% 再下降到 0%，形成"呼吸"效果
- 输出 pwm_out 直接驱动板上 LED

**为什么选呼吸灯而不是纯计数器或按键：**

1. 仿真波形足够丰富——duty 信号递增、递减（三角波）、PWM 载波、比较输出，四个信号可同时观察
2. 综合产物有质地——不是"一个 reg 加一根线"，而是计数器 + 比较器 + 方向状态机，综合后会看到不同层次的逻辑结构
3. 上板效果直观——LED 从暗变亮再变暗，肉眼可见
4. 零外部输入——不需要按键、不需要消抖、不需要串口，最纯粹的教学设计

**为什么保留以按键为基础的其他方案（TODO）：**

- 按键计数器 + 7 段数码管是更接近真实数字系统交互的练手题
- 适合在后续章节（如第 4 章 HDL 基础、第 7 章系统级 RTL）作为扩展实验
- 第 2 章暂不采用，以降低认知负担

**为什么选 Basys3：**

- 大学教学实验室最常见、最便宜的入门 FPGA 开发板之一
- 有 16 个用户 LED，呼吸灯实验可以直接映射到板上
- Xilinx Vivado 支持完善，社区资料丰富

**Basys3 参考资料：**

- Digilent Basys3 官方页面：https://digilent.com/reference/programmable-logic/basys-3/start
- Basys3 参考手册（PDF）：含完整引脚约束（XDC）、外设说明、电源和时钟规格
- Basys3 Github 仓库（XDC 文件与示例项目）：https://github.com/Digilent/Basys3

### 实验 Walkthrough（handout 用）

实验说明目前约 600 字，后续写 handout 时可以同步展开：

1. 安装工具：`sudo apt install iverilog gtkwave yosys`
2. 进入目录：`cd examples/lab1-breathing-led`
3. 仿真：`bash sim/run.sh`
4. 观察波形：GTKWave 自动打开 `tb.vcd`，展开 `duty` 和 `pwm_out` 信号，看到三角波调制的 duty cycle 变化
5. 综合：`bash synth/run.sh`
6. 观察网表：打开 `synth/breathing_led_synth.v`，找到三角波计数器（`tri_cnt`）和 PWM 比较器被映射成了什么单元

### 测试验证标准（自检用，README.md 里写）

- `bash sim/run.sh` 无报错退出，生成 `tb.vcd` 文件
- GTKWave 中可以观察到 `duty` 信号呈现三角波：从 0 递增到 8191 再递减回 0
- `pwm_out` 的占空比随 `duty` 值变化：`duty` 小时脉宽窄，`duty` 大时脉宽宽
- `bash synth/run.sh` 无报错退出，生成 `breathing_led_synth.v`
- 综合后网表中可以找到 `$_DFF_` 开头的触发器单元（如 `$_DFF_PN0_`）

## 建议插图清单

| # | 图 | 用途 | 来源 |
|---|-----|------|------|
| 1 | 仿真三件套数据流图 | §3，Icarus→VVP→GTKWave 的管线示意 | 自绘（Mermaid / draw.io 转 SVG） |
| 2 | GTKWave 波形截图 | §4，标注 time/signal/edge/X/duty cycle | 实际仿真截图 |
| 3 | Yosys 综合输入/输出对比 | §5，breathing_led.v vs 综合后网表 | 自绘对比表或截图 |
| 4 | 仿真 vs 综合双栏对比示意 | §6，时序波形 vs 门级连接结构 | 自绘 |
| 5 | 开源/商业/FPGA 工具矩阵图 | §7，横轴功能纵轴等级 | 自绘表格或矩阵 |
| 6 | 简化 FPGA tile 结构图 | §8，LUT + FF + 互连 | 参考 FPGA 教材重绘 |
| 7 | Basys3 开发板实物照片 + 外设标注 | §8，展示 LED/按键/开关/数码管位置 | Basys3 官方图 / 实际拍摄 |
| 8 | Vivado IO Planner 截图 | §8，展示 xc7a35t-1cpg236 引脚分配界面 | Vivado 软件截图（Basys3 引脚约束示例） |

## 讲义与教科书写法建议

建议每节固定使用以下结构：

1. 本节要回答的问题
2. 核心概念
3. 一张关键图
4. 可复制的命令或代码片段
5. 一个容易产生的误解（tipbox 或 warnbox 纠正）
6. 本节小结（一句话：你现在能做什么）

建议增加的教学元素：

- `tipbox`：工具使用技巧、常见错误提示
- `warnbox`：指出工具语义差异、"仿真不等于综合"等关键误判
- 术语对照表（§10）
- 节末不要做纯记忆题——所有习题都要求"在自己环境里复现并截图为证"

## 本章应避免的问题

- 写成工具 manual 的翻译——只讲基础用法，不讲完整参数列表
- 写成 Verilog 语法教材——那是第 4 章的事；这里遇到未解释的语法只标注"后续章节详述"
- 把 Yosys 的命令行参数逐项展开——给最小可用版本，其余留给读者查阅官方文档
- 在 FPGA 部分陷入架构细节（LUT 内部电路、carry chain、BRAM、DSP slice）
- 在工具安装部分假设读者已经有一套完整的 Linux 环境——需要给 VM / WSL 的额外提示
- 用多套不同实验让读者跳跃——一个实验（lab1）贯穿全部，保持认知连贯

## 后续落地建议

本 ROADMAP.md 完成后，后续工作建议按以下顺序推进：

1. 先写 `metadata.json`
2. 创建 lab1-breathing-led 完整实验（README.md + RTL + testbench + 脚本）
3. 在本地验证：`bash sim/run.sh && bash synth/run.sh`，确保实验可复现
4. 写 `slides.tex` 的页面骨架（17–20 帧，先贴章节标题和要点）
5. 写 `handout.tex` 的节结构（先建空节，填概念）
6. 补图（手工绘制 + 仿真截图）
7. 验证：`make check-style && make all && make site`
