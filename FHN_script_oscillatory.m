clear all
close all
clc

%%
% vid = VideoWriter('Oscillatory', 'MPEG-4');
% vid.FrameRate = 25;
% open(vid);
numFrames = 200;

%%
% a = 0.1;
% b = 1.5;
c = 10;
v0 = 0.5;
x0 = 0; 
y0 = 0;
tInt = [0 500];

%%
figure('position', [1 1 1000 500], 'color', 'white');

g1 = subplot(1, 2, 1);
f1 = plot(0, 0, 'r', 'linewidth', 2); 
hold on;
f2 = plot(0, 0, '--b', 'linewidth', 1);
hold off;
legend({'v(t)', 'w(t)'});
axis square
ylim([-2 2]);
xlim([0 500]);
xlabel('Time'); 
ylabel('Output strength');
set(gca, 'fontsize', 20);
title('Response functions');

subplot(1, 2, 2);
f4 = plot(0, 0, 'm', 'linewidth', 1);
hold on; 
f3 = plot(0, 0, 'g', 'linewidth', 1); 
f5 = scatter(0, 0, 50, 'k', 'filled');
f6 = plot(0, 0, 'k', 'linewidth', 2);
hold off;
axis([-2 2 -2 2]);
axis square
xlabel('v(t)'); 
ylabel('w(t)');
set(gca, 'fontsize', 20);
legend({'Linear nullcline', 'Cubic nullcline'}, 'Location', 'northwest');
title('Phase space');
f7 = text(.5, -1, {['a = ', num2str(1)], ['b = ', num2str(1)]}, 'fontsize', 16);

%% Start updating
for i = 0:numFrames
    %% Integrate DEs
    a1 = .2 + (i/numFrames)*.04;
    b1 = 1.05 + (i/numFrames)*(-.02);
    c1 = c;
    v1 = v0;
    x1 = x0;%fsolve(@(x) b1*x^3/3 + (1 - b1)*x + (a1 - b1*v1), -2);
    y1 = y0;%(x1 + a1)/b1;
    
    ode = @(t, v) fhn(t, v, a1, b1, c1, v1);
    [t, v] = ode45(ode, tInt, [x1; y1]);

    %% Update plots
    vInt = -5:0.01:5;
    
    if i == 0 || i == numFrames/4 || i == 2*numFrames/4 || i == 3*numFrames/4
        subplot(1, 2, 1);
        hold on;
        plot3(1:size(v, 1), v(:, 1), -numFrames + i + zeros(size(v, 1), 1), 'color', [1 1 1]/2, 'linewidth', 1); 
%         plot(0, 0, '--', 'color', [1 1 1]/2, 'linewidth', 1);
        hold off;
        legend({'v(t)', 'w(t)'});
        
        subplot(1, 2, 2);
        hold on; 
        plot3(vInt, (vInt + a1)/b1, -numFrames + i + zeros(size(vInt)), 'color', [1 1 1]/2, 'linewidth', 0.5);
        scatter3(x1, y1, -numFrames + i, 25, [1 1 1]/2, 'filled');
        plot3(v(:, 1), v(:, 2), -numFrames + i + zeros(size(v, 1), 1), 'color', [1 1 1]/2, 'linewidth', 1);
        hold off;
        legend({'Linear nullcline', 'Cubic nullcline'});
        
    end
    
    set(f1, 'XData', 1:size(v, 1), 'YData', v(:, 1));
    set(f2, 'XData', 1:size(v, 1), 'YData', v(:, 2));
    t = max(2, max(abs(v(:))));
    g1.YLim = [-t t];
    
    set(f3, 'XData', vInt, 'YData', vInt - vInt.^3/3 + v1);
    set(f4, 'XData', vInt, 'YData', (vInt + a1)/b1);
    set(f5, 'XData', x1, 'YData', y1);
    set(f6, 'XData', v(:, 1), 'YData', v(:, 2));
    
    set(f7, 'string', {['a = ', num2str(a1, '%.4f')], ['b = ', num2str(b1, '%.4f')]}, 'fontsize', 16);
    
    disp([a1, b1, c1, v1, x1, y1]);
    
    drawnow; 
    
%     print('temp', '-dpng', '-r350');
%     f = imread('temp.png');
%     writeVideo(vid, f);
    
    

end
close(vid);

%%
function dv = fhn(t, v, a, b, c, v0)
    dv = [nan; nan];
    dv(1) = v(1) - v(1)^3/3 - v(2) + v0;
    dv(2) = (1/c)*(v(1) + a - b*v(2));
end