close all; clear; clc;

%% 参数调整
T_current = 110;  % 当前张力(N)👈可更改
L = 0.65;         % 弦长(m)
u0 = 0.005;       % 初始位移(m)
f_std = 82.4;     % 标准频率(Hz)
noise = 0.001;    % 高斯噪声标准差👈可更改

% 张力确认
if T_current < 90
    disp('张力过小，弦可能过于松弛！');
    return;
elseif T_current > 130
    disp('张力过大，可能导致弦断裂或损伤乐器！');
    return;
end

%% 振动仿真模块
disp('正在进行振动仿真...');
u = part1_Simulation(T_current, L, u0, noise);

%% 数据平滑模块
disp('正在进行数据平滑...');
t = linspace(0, 0.2, length(u)); % 时间序列
smooth_u = part2_Smoothing(u, t);

%% 频率计算模块
disp('正在进行频率计算...');
[f, delta_f] = part3_Calculation(smooth_u, t, f_std);

%% 结果输出模块
% 输出调弦建议
if abs(delta_f) < 0.1
    disp('音准正确');
elseif delta_f > 0
    disp('建议拧松');
else
    disp('建议拧紧');
end

% 输出结果
fprintf('当前频率:%.2fHz\n', f);
fprintf('频率偏差:%.2fHz\n', delta_f);

%% 结果保存模块
disp('正在保存结果...');

try
    timestamp = datestr(now, 'yyyy_mm_dd_HH_MM_SS');
    % 创建结果主目录
    main_result_dir = fullfile('../Results', timestamp);
    if ~exist(main_result_dir, 'dir')
        mkdir(main_result_dir);
    end
    
    % 保存数据到.mat文件
    mat_file_path = fullfile(main_result_dir, 'vibration_data.mat');
    save(mat_file_path, 'u', 'smooth_u', 't', 'f', 'delta_f');

    % 保存文本结果
    txt_file_path = fullfile(main_result_dir, 'frequency_report.txt');
    fileID = fopen(txt_file_path, 'w');
    if fileID == -1
        error('无法打开文件 %s 进行写入操作。', txt_file_path);
    end
    fprintf(fileID, '=== 频率分析结果 ===\n');
    fprintf(fileID, '当前频率: %.2f Hz\n', f);
    fprintf(fileID, '频率偏差: %.2f Hz\n', delta_f);

    if abs(delta_f) < 0.1
        advice = '音准正确';
    elseif delta_f > 0
        advice = '建议拧松';
    else
        advice = '建议拧紧';
    end
    fprintf(fileID, '调弦建议: %s\n', advice);
    fclose(fileID);

    % 保存波形图
    figure('Color', 'white');
    subplot(2,1,1);
    plot(t, u, 'b-', 'LineWidth', 1.5);
    title('原始振动波形');
    xlabel('时间 (s)');
    ylabel('位移 (m)');
    grid on;

    subplot(2,1,2);
    plot(t, smooth_u, 'r--', 'LineWidth', 2);
    title('平滑后振动波形');
    xlabel('时间 (s)');
    ylabel('位移 (m)');
    grid on;

    % 创建波形目录
    waveform_dir = fullfile(main_result_dir, 'waveforms');
    if ~exist(waveform_dir, 'dir')
        mkdir(waveform_dir);
    end

    % 保存为PNG格式
    waveform_png_path = fullfile(waveform_dir, 'vibration_waveforms.png');
    set(gcf, 'PaperUnits', 'inches', 'PaperSize', [8 6], 'PaperPosition', [0 0 8 6]);
    saveas(gcf, waveform_png_path);

    % 保存频率偏差图
    figure('Color', 'white');
    bar(delta_f);
    title('频率偏差分析');
    xlabel('分析指标');
    ylabel('频率偏差 (Hz)');
    text(1, delta_f, sprintf('%.2f Hz', delta_f), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
    grid on;

    % 创建频率图目录
    frequency_plot_dir = fullfile(main_result_dir, 'frequency_plots');
    if ~exist(frequency_plot_dir, 'dir')
        mkdir(frequency_plot_dir);
    end

    % 保存为PDF和PNG格式
    frequency_pdf_path = fullfile(frequency_plot_dir, 'frequency_delta.pdf');
    frequency_png_path = fullfile(frequency_plot_dir, 'frequency_delta.png');
    saveas(gcf, frequency_pdf_path);
    saveas(gcf, frequency_png_path);
    close(gcf);

    % 校验
    if exist(mat_file_path, 'file') && ...
            exist(txt_file_path, 'file') && ...
            exist(waveform_png_path, 'file') && ...
            exist(frequency_png_path, 'file')
        disp('结果保存成功！');
    else
        error('部分结果文件未成功保存！');
    end
catch ME
    disp(['保存结果时出现错误: ', ME.message]);
end
    