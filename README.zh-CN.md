[English](README.md) | 简体中文

# Tension-Based Real-Time Tuning System for Guitar String Vibration Analysis

![Language: MATLAB](https://img.shields.io/badge/Language-MATLAB-E16737?style=flat-square) ![Topic: Numerical Methods](https://img.shields.io/badge/Topic-Numerical%20Methods-4B5563?style=flat-square) ![Type: Course Project](https://img.shields.io/badge/Type-Course%20Project-64748B?style=flat-square)

*Numerical Computation Methods Course Project*

## 1. 项目概述

本项目通过MATLAB实现基于张力的吉他弦振动实时调弦系统，包含振动仿真、数据平滑、频率计算三大核心模块。系统采用四阶龙格—库塔法模拟弦振动过程，结合三次样条插值进行数据平滑处理，最终通过最小二乘法拟合正弦波获取振动频率，实现吉他弦音准的智能判断与调弦建议。

## 2. 项目结构

```
Tension-Based_Real-Time_Tuning_System/
├── Code/                  # MATLAB代码
│   ├── main_program.m     # 主程序
│   ├── part1_Simulation.m # 振动仿真模块（RK4算法）
│   ├── part2_Smoothing.m  # 数据平滑模块（三次样条插值）
│   └── part3_Calculation.m# 频率计算模块（最小二乘法拟合）
├── Documentation/         # 文档资料
│   └── Final_Report.pdf   # 项目报告
├── Results/               # 输出结果
│   ├── frequency_results.txt # 频率计算结果
│   └── waveforms/         # 振动波形图
└── README.md              # 项目说明文档
```

## 3. 代码模块说明

### 3.1 main_program.m

- **功能**：系统主程序，整合各模块功能
- **参数设置**：

  ```matlab
  T_current = 110;  % 当前弦张力(N)
  L = 0.65;         % 有效弦长(m)
  u0 = 0.005;       % 初始位移激励(m)
  f_std = 82.4;     % 标准频率(Hz)
  ```

- **执行流程**：
  1. 调用振动仿真模块生成离散位移数据
  2. 对数据进行三次样条平滑处理
  3. 计算振动频率并输出调弦建议

### 3.2 part1_Simulation.m

- **算法**：四阶龙格—库塔法求解弦振动方程
- **关键参数**：

  ```matlab
  rho = 0.01;    % 弦线密度(kg/m)
  t_max = 0.2;   % 仿真时长(s)
  dt = 0.001;    % 时间步长(s)
  ```

- **输出**：长度为201的离散位移序列 `u`

### 3.3 part2_Smoothing.m

- **算法**：三次样条插值（含自然边界条件）
- **实现细节**：
  - 使用稀疏矩阵求解二阶导数
  - 插值公式：

    ```matlab
    y = (1-t)y_i + ty_{i+1} + [(1-t)^3-(1-t)]*(h²/6)M_i + [t³-t]*(h²/6)M_{i+1}
    ```

### 3.4 part3_Calculation.m

- **算法**：非线性最小二乘法拟合正弦曲线
- **拟合模型**：

  ```matlab
  fittype('a*sin(2*pi*f*t + phi)', 'independent', 't')
  ```

- **输出**：
  - 拟合频率 `f` (Hz)
  - 频率偏差 `delta_f = f - f_std`

## 4. 运行指南

### 4.1 环境要求

- MATLAB R2022b 或更高版本
- 必须安装：
  - Curve Fitting Toolbox（用于最小二乘拟合）
  - Spline Toolbox（用于三次样条插值）
  - Statistics and Machine Learning Toolbox（用于生成高斯噪声）

### 4.2 执行步骤

1. 修改 `main_program.m` 中的初始参数（根据实际情况，建议不要与标准E弦值113.2偏差太大，在100-130范围即可）
2. 直接运行主程序，控制台将显示：

   ```matlab
   正在进行振动仿真...
   正在进行数据平滑...
   正在进行频率计算...
   建议拧紧
   当前频率:80.02Hz
   频率偏差:-2.38Hz
   ```

3. 结果文件自动保存至 `Results/` 目录

## 5. 算法特性

### 5.1 振动仿真模块

- 采用RK4方法保证二阶微分方程求解精度
- 步长设置为1ms，满足实时性需求

### 5.2 数据平滑模块

- 自然三次样条插值保持曲线光滑性
- 消除高频噪声对频率计算的影响

### 5.3 频率计算模块

- 非线性拟合直接求解频率参数
- 初始值设定为标准频率保证收敛性

## 6. 扩展说明

### 6.1 参数敏感性分析

- 弦张力T与频率f的关系：`f ∝ sqrt(T)`
- 弦长L与频率f的关系：`f ∝ 1/L`

### 6.2 误差来源

1. 龙格-库塔法截断误差
2. 三次样条插值误差
3. 非线性拟合局部最优解

## 原创性声明

本项目《Tension-Based Real-Time Tuning System for Guitar String Vibration Analysis》的所有代码、文档及实验设计均为个人独立完成，未直接复制或抄袭第三方成果。核心算法基于课程知识与公开文献实现，若涉及外部资源引用，均已在代码注释或文档中明确标注。

**声明人**：Charles Weng
**日期**：2025-04-05
