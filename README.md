[English](README.md) | [简体中文](README.zh-CN.md)

# Tension-Based Real-Time Tuning System for Guitar String Vibration Analysis

[![License](https://img.shields.io/badge/License-MIT-64748B?style=flat-square)](LICENSE)

![Language: MATLAB](https://img.shields.io/badge/Language-MATLAB-E16737?style=flat-square) ![Topic: Numerical Methods](https://img.shields.io/badge/Topic-Numerical%20Methods-4B5563?style=flat-square) ![Type: Course Project](https://img.shields.io/badge/Type-Course%20Project-64748B?style=flat-square)

*Numerical Computation Methods course project.*

A MATLAB workflow for simulating a guitar string under tension, smoothing its displacement data and estimating frequency to provide tuning advice. The three numerical stages are fourth-order Runge–Kutta integration, natural cubic-spline interpolation and nonlinear least-squares sinusoidal fitting.

## Project structure

```text
Code/
  main_program.m
  part1_Simulation.m
  part2_Smoothing.m
  part3_Calculation.m
Documentation/
  Final_Report.pdf
Results/
  frequency_results.txt
  waveforms/
```

## Modules

### Main program

`Code/main_program.m` coordinates simulation, smoothing and frequency estimation. Its initial parameters are:

```matlab
T_current = 110;  % String tension in N
L = 0.65;         % Effective length in m
u0 = 0.005;       % Initial displacement in m
f_std = 82.4;     % Reference frequency in Hz
```

### Vibration simulation

`part1_Simulation.m` solves the string-vibration equation with RK4:

```matlab
rho = 0.01;    % Linear density in kg/m
t_max = 0.2;   % Duration in s
dt = 0.001;    % Time step in s
```

It produces 201 discrete displacement samples in `u`.

### Smoothing

`part2_Smoothing.m` uses a natural cubic spline and a sparse system for second derivatives. On an interval of length `h`, the interpolation is:

```text
y = (1-t)y_i + t*y_(i+1)
    + ((1-t)^3-(1-t))*(h^2/6)*M_i
    + (t^3-t)*(h^2/6)*M_(i+1)
```

### Frequency estimation

`part3_Calculation.m` fits:

```matlab
fittype('a*sin(2*pi*f*t + phi)', 'independent', 't')
```

It returns `f` in Hz and `delta_f = f - f_std`. The reference frequency initializes the fit.

## Running

Use MATLAB R2022b or later with Curve Fitting Toolbox, Spline Toolbox, and Statistics and Machine Learning Toolbox for Gaussian noise generation.

1. Open `Code/main_program.m` and adjust the initial parameters. The original experiments recommend tension around 100–130 N, near the reference E-string tension of 113.2 N.
2. Run the main program. It reports each processing stage, estimated frequency, deviation and whether the string should be tightened or loosened. One recorded example reports 80.02 Hz, a −2.38 Hz deviation and advice to tighten.
3. Inspect the outputs under `Results/`.

## Numerical considerations

The RK4 simulation uses 1 ms steps. Spline smoothing reduces high-frequency noise before fitting. Frequency is proportional to `sqrt(T)` and inversely proportional to string length `L`. Error sources include RK4 truncation, interpolation error and local minima in nonlinear fitting.

## Originality statement

The original author states that the code, documentation and experiment design were independently completed using course material and published literature, with external references acknowledged in code or documentation.

**Author:** Charles Weng. **Date:** 2025-04-05.

## License and rights

Original project code and documentation are provided under the [MIT License](LICENSE), retaining the original author attribution to Charles Weng. Third-party publications and other externally sourced materials under `References/` or elsewhere are not relicensed by this notice and remain subject to their original terms.
