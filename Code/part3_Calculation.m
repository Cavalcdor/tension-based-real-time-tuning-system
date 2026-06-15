function [f, delta_f] = part3_Calculation(smooth_u, t, f_std)
    % 频率计算模块
    % 输入:
    % smooth_u - 平滑后的振动数据
    % t - 时间序列
    % f_std - 标准频率
    % 输出:
    % f - 拟合频率
    % delta_f - 频率偏差

    % 最小二乘法拟合正弦波
    ft = fittype('a*sin(2*pi*f*t + phi)', 'independent', 't', 'coefficients', {'a', 'f', 'phi'});
    [fit_result, ~] = fit(t', smooth_u', ft, 'StartPoint', [0.002, f_std, 0]);

    % 提取拟合参数
    f = fit_result.f;
    delta_f = f - f_std;
end