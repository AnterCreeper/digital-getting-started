# Reading Map

这份文档用于把经典论文、教材和工程资料映射到本项目的大纲章节，供后续编写 `slides.tex`、`handout.tex`、插图说明和补充阅读时直接引用。

原则：

- 只保留真正支撑主线的经典资料
- 优先记录“为什么读这篇”，而不是堆文献名
- 以章节组织，避免后续重复检索
- 当前主线以 Verilog / RTL / 处理器系统 / 综合实现为主，不把验证方法学和 SystemVerilog 语言扩展作为主线展开

## Chapter 3: Digital Circuit Fundamentals

### Primary references

- `Kang-2015-CMOS-Digital-Integrated-Circuits-Analysis-and-Design`
- `1993-Passive Devices.pdf`
- `clock skew.pdf`
- `Issues on Timing and Clocking.pdf`

### Why these matter

- 用于支撑 MOS、CMOS、反相器、负载、延迟、扇出、时钟等底层物理直觉
- 支撑从门电路到时序系统边界的过渡
- 为后续 setup/hold/skew/uncertainty 提供更扎实的前置理解

### Use in this project

- 讲义中用于“概念解释 + 插图说明”
- PPT 中用于建立反相器、门级结构、时序边界的图像化直觉

## Chapter 4: HDL and Synthesizable RTL

### Primary references

- `1997-Verilog Coding Styles For Improved Simulation Efficiency.pdf`
- `2000-Nonblocking Assignments in Verilog Synthesis, Coding Styles That Kill.pdf`
- `2000-RTL Coding Styles That Yield Simulation and Synthesis Mismatches.pdf`
- `2000-full_case parallel_case-the Evil Twins of Verilog Synthesis.pdf`
- `2006-SystemVerilog Event Regions,Race Avoidance & Guidelines.pdf`
- `The Ten Commandments of RTL Coding.pdf`
- `2001-Verilog-2001 Behavioral and Synthesis Enhancements.pdf`
- `2002-New Verilog-2001 Techniques for Creating Parameterized Models.pdf`

### Why these matter

- 确立 RTL 不是“会写语法”，而是“写出仿真、综合、维护都可靠的硬件描述”
- 支撑阻塞/非阻塞、组合/时序建模、默认分支、竞态、综合不一致等核心教学点
- 参数化与层次化设计部分可借鉴 Verilog-2001 时代的工程表达方式

### Use in this project

- 讲义中形成“坏味道 -> 原因 -> 后果 -> 修正方法”的写法
- PPT 中适合用小反例和波形对比来呈现

## X Semantics Thread: Chapters 4 and 8

### Primary references

- `SUTHERLAND_HDL_01 I?m Still In Love With My X!.pdf`
- `2004-SystemVerilog 2-State Simulation Performance and Verification Advantages.pdf`
- `2000-RTL Coding Styles That Yield Simulation and Synthesis Mismatches.pdf`
- `2006-SystemVerilog Event Regions,Race Avoidance & Guidelines.pdf`

### Why these matter

- 支撑 `X` 的双重角色：验证中的不确定性显影与综合中的 `don't care` 自由度
- 支撑 `X-optimism`、`X-pessimism`、2-state / 4-state 等关键概念
- 支撑“为什么不是所有寄存器都需要异步复位”的更专业表述

### Use in this project

- Chapter 4: 讲 `X` 的设计语义与编码纪律
- Chapter 8: 讲 `X` 在门级网表、初始化、时序违例、库模型中的放大效应

## FSM Thread: Chapters 4 and 7

### Primary references

- `1998-State Machine Coding Styles for Synthesis.pdf`
- `2002-Coding And Scripting Techniques For FSM Designs With Synthesis-Optimized, Glitch-Free Outputs.pdf`
- `2002-The Fundamentals of Efficient Synthesizable Finite State Machine Design using NC-Verilog and BuildGates.pdf`
- `2003-Synthesizable Finite State Machine Design Techniques Using the New SystemVerilog 3.0 Enhancements.pdf`
- `Fizzim An Open-Source fsm Design Environment.pdf`

### Why these matter

- 支撑 FSM 编码风格、状态组织、输出逻辑与毛刺控制
- 帮助把 Moore / Mealy 从教科书分类提升为工程分析视角
- 为后续控制器、流水线控制、外设状态机组织方式打基础

### Use in this project

- Chapter 4: 用于介绍可综合 FSM 编写习惯
- Chapter 7: 用于处理器控制通路、UART 控制与系统状态组织

## Reset / CDC / FIFO Thread: Chapter 7

### Primary references

- `2001-Synthesis and Scripting Techniques for Designing Multi-Asynchronous Clock Designs.pdf`
- `2002-Synchronous Resets, Asynchronous Resets,I am so confused,How will I ever know which to use.pdf`
- `2003-Asynchronous & Synchronous Reset Design Techniques.pdf`
- `2008-Clock Domain Crossing (CDC) Design & Verification Techniques Using SystemVerilog.pdf`
- `Simulation and Synthesis Techniques for Asynchronous FIFO Design.pdf`
- `Simulation and Synthesis Techniques for Asynchronous FIFO Design with Asynchronous Pointer Comparisons.pdf`
- `Clock Management Tips on a Multi-Clock Design.pdf`
- `clock skew.pdf`
- `Issues on Timing and Clocking.pdf`

### Why these matter

- 支撑 reset 选择不是语法问题，而是系统可靠性与时序边界问题
- 支撑 CDC 基础、同步器边界、异步 FIFO 正确结构
- 支撑系统级 RTL 中“哪些状态必须定义、哪些数据可以在协议保护下不定义”的工程判断

### Use in this project

- Chapter 7 是这条线的主承载章
- 应配套插图：同步器、Gray code pointer、FIFO empty/full 判定、复位释放边界

## Chapter 8: Front-End Flow, Netlist, and STA

### Primary references

- `RTL Coding Styles That Yield Simulation and Synthesis Mismatches.pdf`
- `ASIC Flow Engine for Timing Closure(AFETC) a Makefile Generator to Automate Design Budgeter Methodology.pdf`
- `Complex Clocking Situations using PrimeTime.pdf`
- `How and Why To Use PrimeTime Distributed Multi-Scenario Analysisl.pdf`
- `using multiclock propagation in pt.pdf`
- `Where have all the phases gone Using multiclock propagation in PrimeTime.pdf`
- `JupiterXT Timing Budgeting.pdf`

### Why these matter

- 支撑从 RTL 功能正确到综合网表、时序约束、STA、PnR 报告读取的过渡
- 让学生理解“实现可行性”是一套独立于 RTL 功能仿真的工程判据
- 用于解释 timing budget、clock propagation、多场景分析等概念

### Use in this project

- 不主讲工具命令
- 主讲流程、报告、约束、问题定位逻辑

## Chapter 9: Backend and SoC Optimization Methodology

### Primary references

- `Floorplanning Principles.pdf`
- `Low Power Implementation.pdf`
- `Design for Power Gating - And What UPF Can, and Cannot, Do for You.pdf`
- `How To Successfully Use Gated Clocking in an ASIC Design.pdf`
- `how to successfully use gated clocking in an asic design.pdf`
- `Complex Clocking Situations using PrimeTime.pdf`
- `Clock Management Tips on a Multi-Clock Design.pdf`

### Secondary references

- `Design of Very Deep Pipelined Multipliers for FPGAs.pdf`
- `ASIC Flow Engine for Timing Closure(AFETC) a Makefile Generator to Automate Design Budgeter Methodology.pdf`

### Why these matter

- 支撑低功耗、时序收敛、CTS、clock gating、physical consequences 等方法学内容
- 让前端视角真正理解后端不是“自动完成的最后一步”
- 可为后续加入 DFT / SI / PI / manufacturability 内容提供稳定参考框架

### Use in this project

- 讲义中适合做“问题驱动式”表述：为什么这个设计到后端会痛苦
- PPT 中适合用流程图、对比例子、术语解释和后果链条组织

## Not Mainline for Now

以下资料当前不作为主线展开，但值得保留为后续扩展或附录候选：

- 大量 UVM / OVM / SVA / VIP 相关论文
- SystemVerilog 标准演进与语言增强资料
- DPI / PLI / verification architecture 相关内容

这些资料的价值主要在：

- 后续若单独扩展“验证基础”章节可直接启用
- 后续若把项目扩展为更完整的芯片前端课程，可作为第二阶段阅读材料
