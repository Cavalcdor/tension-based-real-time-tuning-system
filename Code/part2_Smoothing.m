function smooth_u = part2_Smoothing(u, t)
    % 数据平滑模块
    % 输入:
    % u - 原始振动数据
    % t - 时间序列
    % 输出:
    % smooth_u - 平滑后的连续振动曲线

    % 三次样条插值
    smooth_u = zeros(size(u));
    for i = 1:length(t)
        smooth_u(i) = spline_inter_3(t, u, t(i));
    end
end

%% 三次样条插值函数
function y = spline_inter_3(x, y_nodes, xi)
    n = length(x);
    h = diff(x); % 计算相邻点间距
    mu = h(1:end - 1) ./ (h(1:end - 1) + h(2:end));
    lambda = 1 - mu;
    d = 6 * diff((diff(y_nodes) ./ h)) ./ (h(1:end - 1) + h(2:end));
    n_minus_2 = n - 2;
    A = spdiags([mu(:), 2 * ones(n_minus_2, 1), lambda(:)], [-1, 0, 1], n_minus_2, n_minus_2);
    M = A \ d'; % 求解二阶导数
    M = [0; M; 0];
    for i = 1:(n - 1)
        if xi >= x(i) && xi <= x(i + 1)
            t = (xi - x(i)) / h(i);
            % 三次样条插值公式
            y = (1 - t) * y_nodes(i) + t * y_nodes(i + 1) + ((1 - t)^3 - (1 - t)) * (h(i)^2 / 6) * M(i) + (t^3 - t) * (h(i)^2 / 6) * M(i + 1);
            return;
        end
    end
end