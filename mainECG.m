clc; clear all; close all;

ecg = classECG({ ...
    200, 160, @(t, T) piecewisePT(t, T, -0.001/15, 0.1);
    440, 160, @(t, T) piecewiseQRS(t);
    700, 160, @(t, T) piecewisePT(t, T, -0.002/15, 0.2);
    });

[y_parts, t_local, t_total, ekg_total] = ecg.synteticECG();

long_ekg = repmat(ekg_total, 1, 8);
T_heart_cycle2 = 1000*8;
t_total2 = 1:T_heart_cycle2;

toDraw = {
    t_total2, long_ekg, "ECG signal"
    };

for i = 1:size(toDraw, 1)
    ecg.drawRunningGraph(toDraw{i, 1}, toDraw{i, 2}, toDraw{i, 3})
end

function p = piecewisePT(t, T, a, b)
    p = zeros(size(t));
    p(t >= 0 & t < 160) = a * (0.5 * (t(t >= 0 & t < 160) - T/2)).^2 + b;
    p = p * 0.2;
end


function q = piecewiseQRS(t)
     q = zeros(size(t));
     q(t >= 0 & t < 20) = (-0.3 * (t(t >= 0 & t < 20) + 440) + 132)/20;
     q(t >= 20 & t < 60) = 0.6 * ((t(t >= 20 & t < 60) + 440) - 470)/20;
     q(t >= 60 & t < 120) = -0.5 * ((t(t >= 60 & t < 120) + 440) - 540)/20;
      q(t >= 120 & t < 140) = 0.5 * ((t(t >= 120 & t < 140) + 440) - 580)/20;
     q = q * 0.2;
end 

