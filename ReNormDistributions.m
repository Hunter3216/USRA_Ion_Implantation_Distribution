function [ReNorm] = ReNormDistributions(Energy,Range,Straggle)
    %Purpose: create renormalization constants for the distributions that
    %   exceed the domain
    %
    %Pre-Conditions:
    %   Energy: Array of energies from SRIM Collected in Data_Get
    %   Range: Array of average ranges from SRIM Collected in Data_Get
    %   Straggle: Array of longitudinal straggles from SRIM Collected in Data_Get
    %
    %Return:
    %   ReNorm: An array of constants which renormalize the distributions
    %       when they go into x<0 (which is physically impossible
    
    N = length(Energy);
    ReNorm = zeros(1,N);
    
    for DistNum = 1 : N
        Distribution = @(x)(1/(sqrt(2*pi)*Straggle(DistNum)))*exp((-1/2)*((x-Range(DistNum))/(Straggle(DistNum))).^2);
        ReNorm(DistNum) = 1 - integral(Distribution,-(5*Straggle(DistNum)),0,'RelTol',1e-10,'AbsTol',1e-15);
    end
    
end