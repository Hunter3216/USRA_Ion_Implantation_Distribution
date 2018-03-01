%Runs the function avaliable all at once to test usig Test_Data.txt

UserFunction = @(x)x/100 + 10;
UserWeightFunction = @(x)x.^4 + 100;
Domain = [0 2000];

[Energy,Range,Straggle] = Data_Get('Test_Data.txt');
[ReNorm] = ReNormDistributions(Energy,Range,Straggle);
[NormalizedWeight] = WeightedDifferenceFunctionNormalizer(UserWeightFunction,Domain);

[CNoWeight] = Constants4Distributions(Energy,Range,Straggle,UserFunction,ReNorm, Domain, repmat(1,1,501));

[C] = Constants4Distributions(Energy,Range,Straggle,UserFunction,ReNorm, Domain, NormalizedWeight);
