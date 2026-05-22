# 实验 1：呼吸灯 —— PWM 计数器

## 目标

使用 Icarus Verilog 仿真 + Yosys 综合完成完整的 RTL-to-netlist 工作流，并理解仿真行为与综合结构之间的差异。

## 电路概述

PWM 计数器控制 LED 亮度，产生"呼吸"效果：

1. **三角波发生器**：15 位计数器（32768 步），输出 13 位占空比参考值（0 到 8191，周期约 2.68 秒）
2. **PWM 载波**：13 位计数器（100MHz / 8192 ≈ 12.2kHz），与三角波值进行比较
3. **PWM 比较器**：当载波值 < 占空比值时，pwm_out = 1。占空比从 0% 到 100% 来回扫描，产生呼吸效果。

## 前置条件

- Linux 环境（物理机 / 虚拟机 / WSL）
- 安装 Icarus Verilog、GTKWave、Yosys：
  ```bash
  sudo apt install iverilog gtkwave yosys
  ```
- 验证安装：
  ```bash
  which iverilog && which gtkwave && which yosys
  ```
  三者均应输出对应路径。

## 目录结构

```
lab1-breathing-led/
├── README.md            # 本文件
├── rtl/
│   ├── breathing_led.v  # PWM 呼吸灯核心模块
│   └── top.v            # Basys3 顶层封装模块
├── tb/
│   └── tb_breathing_led.v  # 仿真测试平台
├── sim/
│   └── run.sh           # 仿真脚本
├── synth/
│   └── run.sh           # 综合脚本
└── fpga/
    └── basys3.xdc       # Basys3 引脚约束文件
```

## 使用方法

### 1. 仿真

```bash
cd sim
bash run.sh
```

若已安装 GTKWave，将自动打开 `tb.vcd`。

### 2. 综合（RTL -> 门级网表）

```bash
cd ../synth
bash run.sh
```

网表输出至 `breathing_led_synth.v`。打开该文件可查看 RTL 如何映射为通用门电路。

## 验收标准（自检）

- [ ] `bash sim/run.sh` 正常退出，生成 `tb.vcd`
- [ ] GTKWave 中 `duty` 显示为三角波：0 上升至 8191 后回到 0
- [ ] `pwm_out` 占空比随 `duty` 变化：低时窄，高时宽
- [ ] `bash synth/run.sh` 正常退出，生成 `breathing_led_synth.v`
- [ ] 网表包含 `$_DFF_*` 单元（如 `$_DFF_PN0_`）

## 开发板信息（可选）

目标：**Digilent Basys3**

- **FPGA**：`xc7a35t-1cpg236C`（Xilinx Artix-7）
  - `xc7a`：Xilinx 7 系列 Artix 家族
  - `35`：约 35K 逻辑单元
  - `t`：集成高速收发器
  - `-1`：标准速度等级
  - `cpg236`：236 引脚封装
  - `C`：商业温度范围（0°C ~ +85°C）
- **外设**：16 个 LED（LD0–LD15）、4 位 7 段数码管、5 个按键、16 个拨码开关
- **参考资料**：
  - Basys3 主页：https://digilent.com/reference/programmable-logic/basys-3/start
  - Basys3 参考手册（完整 XDC 约束）
  - Basys3 GitHub：https://github.com/Digilent/Basys3

`fpga/basys3.xdc` 包含时钟、复位和 LED 的引脚约束。使用 Vivado 进行综合、实现和下载。

### Vivado 路径配置

Makefile 和 TCL 脚本假设 Vivado 安装在：
```
/opt/Xilinx/Vivado/2019.2/bin/vivado
```

若安装路径不同，在运行 `make fpga` 或 `make program` 前，更新以下两处：

1. **Makefile** 第 19 和 24 行：修改硬编码的 Vivado 路径
2. **fpga/run.tcl** 和 **fpga/program.tcl**：无需修改（由 Makefile 调用）

或者，将 Vivado 加入 shell 环境：
```bash
source /opt/Xilinx/Vivado/2019.2/settings64.sh
# 然后编辑 Makefile，将完整路径改为直接使用 'vivado'
```

## 故障排除

| 问题 | 原因 | 解决方法 |
|------|------|----------|
| `iverilog: command not found` | 未安装 | `sudo apt install iverilog` |
| `gtkwave: command not found` | 未安装 | `sudo apt install gtkwave` |
| `yosys: command not found` | 未安装 | `sudo apt install yosys` |
| GTKWave 空白 | VCD 未生成 | 检查 testbench 中的 `$dumpfile` 和 `$dumpvars` |
| 网表中无 `$_DFF_` | Yosys 版本差异 | 搜索 `DFF`，不同版本名称可能不同 |
