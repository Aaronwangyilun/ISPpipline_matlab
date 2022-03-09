function pixel_centre=cnc(center,j,i,gain_r,gain_b,avgC1,avgG,avgC2);

signalGap=center-max(avgG,avgC2);
if (~mod(i,2) && ~mod(j,2))%B
    if gain_b <= 1.0
       dampFactor = 1.0;
    end
    if (gain_b > 1.0 && gain_b <= 1.2)
       dampFactor = 0.5;
    end
    if gain_b > 1.2
       dampFactor = 0.3;
    end
    signalMeter = 0.299 * avgC2 + 0.587 * avgG + 0.114 * avgC1;
end
%%-------------------------------------------------------------------------
if (mod(i,2) && mod(j,2))%R
    if gain_r <= 1.0
       dampFactor = 1.0;
    end
    if (gain_r > 1.0 && gain_r <= 1.2)
       dampFactor = 0.5;
    end
    if gain_r > 1.2
       dampFactor = 0.3;
    end
    signalMeter = 0.299 * avgC1 + 0.587 * avgG + 0.114 * avgC2;
end
%%-------------------------------------------------------------------------
    fadeTot=fada_cul(avgC1,signalMeter);
    chromaCorrected = max(avgG, avgC2) + dampFactor * signalGap;

    pixel_centre = (1 - fadeTot) * center + fadeTot * chromaCorrected;
