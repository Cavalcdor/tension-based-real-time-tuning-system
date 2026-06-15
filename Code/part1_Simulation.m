function u = part1_Simulation(T, L, u0, noise_std)
    % 振动仿真模块
    % 输入:
    % T - 当前张力 (N)
    % L - 弦长 (m)
    % u0 - 初始位移 (m)
    % 输出:
    % u - 离散振动位移数据 (m)

    % 参数设置
    rho = 0.01; % 线密度 (kg/m)
    t_max = 0.2; % 仿真时间长度 (s)
    dt = 0.001; % 时间步长 (s)
    num_steps = round(t_max / dt); % 时间步数
    u = zeros(1, num_steps); % 初始化位移数组

    % 初始条件
    u(1) = u0; % 初始位移
    v = 0; % 初始速度

    % 四阶龙格—库塔法求解
    for n = 1:num_steps - 1
        k1_u = v;
        k1_v = -(T / rho) * (pi / L)^2 * u(n);

        k2_u = v + 0.5 * dt * k1_v;
        k2_v = -(T / rho) * (pi / L)^2 * (u(n) + 0.5 * dt * k1_u);

        k3_u = v + 0.5 * dt * k2_v;
        k3_v = -(T / rho) * (pi / L)^2 * (u(n) + 0.5 * dt * k2_u);

        k4_u = v + dt * k3_v;
        k4_v = -(T / rho) * (pi / L)^2 * (u(n) + dt * k3_u);

        u(n + 1) = u(n) + (dt / 6) * (k1_u + 2 * k2_u + 2 * k3_u + k4_u);
        v = v + (dt / 6) * (k1_v + 2 * k2_v + 2 * k3_v + k4_v);
    end

    % 高斯噪声
    noise = normrnd(0, noise_std, size(u));
    u = u + noise;
end    