function	fadeTot=fada_cul(avgC1,signalMeter)
fade1=0.01;
fade2=0.01;
if signalMeter <= 30
	fade1 = 1.0;
end
if signalMeter > 30 && signalMeter <= 50
    fade1 = 0.9;
end
if signalMeter > 50 && signalMeter <= 70
    fade1 = 0.8;
end
if signalMeter > 70 && signalMeter <= 100
    fade1 = 0.7;
end
if signalMeter > 100 && signalMeter <= 150
    fade1 = 0.6;
end
if signalMeter > 150 && signalMeter <= 200
    fade1 = 0.3;
end
if signalMeter > 200 && signalMeter <= 250
    fade1 = 0.1;
end

if avgC1 <= 30
    fade2 = 1.0;
end
if avgC1 > 30 && avgC1 <= 50
    fade2 = 0.9;
end
if avgC1 > 50 && avgC1 <= 70
    fade2 = 0.8;
end
if avgC1 > 70 && avgC1 <= 100
    fade2 = 0.6;
end
if avgC1 > 100 && avgC1 <= 150
    fade2 = 0.5;
end
if avgC1 > 150 && avgC1 <= 200
    fade2 = 0.3;
end
if avgC1 > 200
    fade2 = 0.01;
end

fadeTot = fade1*fade2;
