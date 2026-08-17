classdef classECG

    properties
        segments
    end

    methods
        function obj = classECG(seg)
            obj.segments = seg;
        end

        function y_f = calculateFourier(obj, t, y, T)
            omega = 2 * pi / T;
            N = 1000;
            a0 = (2/T) * trapz(t, y);

            an = zeros(1, N); bn = zeros(1, N);
            for n = 1:N
                an(n) = (2/T) * trapz(t, y .* cos(n * omega * t));
                bn(n) = (2/T) * trapz(t, y .* sin(n * omega * t));
            end
            y_f = a0 / 2;
            for n = 1:N
                y_f = y_f + an(n)*cos(n*omega*t) + bn(n)*sin(n*omega*t);
            end
        end

        function drawRunningGraph(obj, x, y, graphTittle)
            f = figure('Name', 'Syntetic ECG');
            
            hAnim = animatedline('LineWidth', 1.5, 'Color', 'b');
            title(graphTittle);
            xlabel('Time [ms]'); ylabel('Voltage [mV]');
            grid on;
            
            ylim([min(y) - 0.1, max(y) + 0.1]);

            windowWidth = 2000; 
            stp = 15;
            
            gifFilename = 'ekg_animation.gif'; % Název souboru

            for k = 1:stp:length(x)
                idx = k:min(k+stp-1, length(x));
                addpoints(hAnim, x(idx), y(idx));
                
                currentTime = x(idx(end));
                
                if currentTime <= windowWidth
                    xlim([0, windowWidth]);
                else
                    xlim([currentTime - windowWidth, currentTime]);
                end
                
                drawnow;
                
                frame = getframe(f);
                im = frame2im(frame);
                [imind, cm] = rgb2ind(im, 256);
                
                if k == 1
                    imwrite(imind, cm, gifFilename, 'gif', 'Loopcount', inf, 'DelayTime', 0.03);
                else
                    imwrite(imind, cm, gifFilename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.03);
                end
            end
        end

        function [y_parts, t_local, t_total, ekg_total] = synteticECG(obj)
            T_heart_cycle = 1000;
            t_total = 1:T_heart_cycle;

            ekg_total = zeros(size(t_total));

            for i = 1:size(obj.segments, 1)                
                t_start = obj.segments{i, 1};
                T_seg   = obj.segments{i, 2}; 
                math_f  = obj.segments{i, 3};                                             

                t_local = linspace(0, T_seg, T_seg);                
                y_orig = math_f(t_local, T_seg);
                y_four = obj.calculateFourier(t_local, y_orig, T_seg);
                y_parts{i} = y_four;
                
                t_end = t_start + T_seg;
                ekg_total(t_total >= t_start & t_total < t_end) = y_four;
             end
        end
    end
end