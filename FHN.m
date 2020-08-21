clear all
close all
clc

%%
a = 0.1;
b = 1.5;
c = 1.6;
v0 = 0.2;
x0 = -1.1; 
y0 = -.65;
tInt = [0 500];

%%
figure; 

g1 = subplot(1, 2, 1);
f1 = plot(0, 0, 'r', 'linewidth', 2); 
hold on;
f2 = plot(0, 0, '--b', 'linewidth', 2);
hold off;
legend({'v(t)', 'w(t)'});
axis square
ylim([-2 2]);
xlim([0 500]);
xlabel('Time'); 
ylabel('Response functions');
set(gca, 'fontsize', 20);

subplot(1, 2, 2);
f3 = plot(0, 0, 'g', 'linewidth', 1); 
hold on; 
f4 = plot(0, 0, 'm', 'linewidth', 1);
f5 = scatter(0, 0, 50, 'k', 'filled');
f6 = plot(0, 0, 'k', 'linewidth', 2);
hold off;
axis([-2 2 -2 2]);
axis square
xlabel('v(t)'); 
ylabel('w(t)');
set(gca, 'fontsize', 20);

h1 = uicontrol('style', 'slider', 'value', a, 'min', -10, 'max', 10, 'sliderstep', [.01 .1]/20, 'position', [10, 800, 100 , 50], 'callback', @CallbackFcn);
h2 = uicontrol('style', 'slider', 'value', b, 'min', -10, 'max', 10, 'sliderstep', [.01 .1]/20, 'position', [10, 700, 100 , 50], 'callback', @CallbackFcn);
h3 = uicontrol('style', 'slider', 'value', c, 'min', -100, 'max', 100, 'sliderstep', [.01 .1]/20, 'position', [10, 600, 100 , 50], 'callback', @CallbackFcn);
h4 = uicontrol('style', 'slider', 'value', v0, 'min', -10, 'max', 10, 'sliderstep', [.01 .1]/20, 'position', [10, 500, 100 , 50], 'callback', @CallbackFcn);
h5 = uicontrol('style', 'slider', 'value', x0, 'min', -2, 'max', 2, 'sliderstep', [.01 .1]/20, 'position', [10, 400, 100 , 50], 'callback', @CallbackFcn);
h6 = uicontrol('style', 'slider', 'value', y0, 'min', -2, 'max', 2, 'sliderstep', [.01 .1]/20, 'position', [10, 300, 100 , 50], 'callback', @CallbackFcn);

%% Start updating
while 1
    %% Integrate DEs
    a1 = get(h1, 'value');
    b1 = get(h2, 'value');
    c1 = get(h3, 'value');
    v1 = get(h4, 'value');
    x1 = get(h5, 'value');
    y1 = get(h6, 'value');
    
    ode = @(t, v) fhn(t, v, a1, b1, c1, v1);
    [t, v] = ode45(ode, tInt, [x1; y1]);

    %% Update plots
    set(f1, 'XData', 1:size(v, 1), 'YData', v(:, 1));
    set(f2, 'XData', 1:size(v, 1), 'YData', v(:, 2));
    t = max(2, max(abs(v(:))));
    g1.YLim = [-t t];
    
    vInt = -5:0.01:5;
    set(f3, 'XData', vInt, 'YData', vInt - vInt.^3/3 + v1);
    set(f4, 'XData', vInt, 'YData', (vInt + a1)/b1);
    set(f5, 'XData', x1, 'YData', y1);
    set(f6, 'XData', v(:, 1), 'YData', v(:, 2));
    
    disp([a1, b1, c1, v1, x1, y1]);
    drawnow; 
    
    %% Wait
    uiwait;

% subplot(1, 2, 2);
% vInt = -5:0.01:5;
% % [vInt, wInt] = meshgrid(-5:0.01:5, -5:0.01:5);
% plot(vInt, vInt - vInt.^3 + v0, '--b');
% hold on; 
% plot(vInt, (vInt + a)/b, '--r');
% scatter(0, 0, 30, 'k', 'filled');
% plot(v(:, 1), v(:, 2), 'k', 'linewidth', 2);
% axis([-2 2 -2 2]);
% hold off;
end

%%
function dv = fhn(t, v, a, b, c, v0)
    dv = [nan; nan];
    dv(1) = v(1) - v(1)^3/3 - v(2) + v0;
    dv(2) = (1/c)*(v(1) + a - b*v(2));
end

function CallbackFcn(~, ~)
    uiresume;
end