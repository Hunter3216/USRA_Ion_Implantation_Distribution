function [NormalizedWeight] = WeightedDifferenceFunctionNormalizer(UserWeightFunction,Domain)
    %Purpose: To Normalize the weighting function of Ion Distribution for 
    %   proper use
    %Pre-Conditions:
    %   UserWeightFunction: The user defined function that weighs the
    %       difference of squared in Constants4Distributions
    %   Domain: The domain of the user function
    %Return:
    %   NormalizedWeight: the user defined weight normalized so that it's
    %       definite integral is equal to the length of domain * 1
    
    x = linspace(Domain(1),Domain(2),501);
    UserWeightFunctionData = UserWeightFunction(x);
    
    NormalizedWeight = (Domain(2) - Domain(1)) * UserWeightFunctionData / integral(UserWeightFunction,Domain(1),Domain(2));
end