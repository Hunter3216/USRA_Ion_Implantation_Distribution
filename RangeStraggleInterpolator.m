function [InterpRange, InterpStraggle] = RangeStraggleInterpolator(Energy, Range, Straggle)
    %Purpose: Create Range and Straggle function of Voltage using
    %   interpolation
    %Pre-Conditions: All inputs aquired from Data_Get.m
    %   Energy: Array of energies of ion distriubtions
    %   Range: All of the mean ranges of distribution corresponding to Energy
    %   Straggle: All of the standard-deviations of distributions corresponding to Energy.
    %Return:
    %   InterpRange: function of Range vs. Energy (i.e. Range(Energy))
    %   InterpStraggle: function of Straggle vs. Energy (i.e.Straggle(Energy))
    
    InterpRange = fit(Energy,Range,'pchip');
    InterpStraggle = fit(Energy,Straggle,'pchip');
    %pchip Piecewise Cubic Hermite Interpolating Polynomial (PCHIP)
end