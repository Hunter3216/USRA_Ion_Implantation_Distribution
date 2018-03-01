function [C] = Constants4Distributions(Energy,Range,Straggle,UserFunction,ReNorm, Domain, NormalizedWeight)
    %Purpose: Creates constants for each distribution using a least sum of
    %   squares method
    %
    %Pre-Conditions:
    %   Energy: Array of energies from SRIM Collected in Data_Get
    %   Range: Array of average ranges from SRIM Collected in Data_Get
    %   Straggle: Array of longitudinal straggles from SRIM Collected in Data_Get
    %   UserFunction: User defined function handle describing ion distribution
    %   ReNorm: re-normalization constants for distributions that stray
    %       outside of the domain aquired from ReNormDistributions
    %   Domain: Domain of the UserFunction
    %   NormalizedWeight: The normalized user-defined leastSquared
    %       weighting function made in WeightedDifferenceFunctionNormalizer
    %
    %Return:
    %   C: an array of constants describing the ions to be implanted for
    %       each energy
    
    x = linspace(Domain(1),Domain(2),501);
    ETerms = length(Energy);
    XTerms = length(x);
    
    UserFunctionData = UserFunction(x);
    
    %Constants solved as (ColumnB4Square*ColumnB4Square')\ProductColumn = C
    %Where each term is in the Matrices on LHS is the sum of their
    %function's terms.
    ColumnB4Square = zeros(ETerms,XTerms);
    ProductColumn = zeros(ETerms,1);
    Square = zeros(ETerms,ETerms);

    %Creates the first diagonal of the SquareMatrix and the ProductColumn
    %and the column matrix (really just an array) which is used to find the
    %whole square.
    for sumId = 1 : ETerms
            ColumnB4Square(sumId,:) = ((1/(sqrt(2*pi)*ReNorm(sumId)*Straggle(sumId))) * exp((-1/2)*((x-Range(sumId))/(Straggle(sumId))).^2));
            Square(sumId,sumId) = sum( NormalizedWeight .* ColumnB4Square(sumId,:) .* ColumnB4Square(sumId,:) );
            ProductColumn(sumId) = sum (  NormalizedWeight .* UserFunctionData .* ColumnB4Square(sumId,:) );
    end
    
    %Computes the entire part of the square matrix below the top-left to
    %bottom-right diagonal
    for sumId1 = 1 : ETerms
        for sumId2 = 1 + sumId1 : ETerms
            Square(sumId1,sumId2) = sum( NormalizedWeight .* ColumnB4Square(sumId1,:) .* ColumnB4Square(sumId2,:) );
        end
    end
    
    %Adds the transpose of Square to Square to complete the matrix and then
    %halves the diagonal to correct it.
    Square = Square' + Square;
    Square(1:ETerms+1:end)= (1/2)*diag(Square);
    
    %Uses lsqlin to find constants using this custom option.
    options = optimoptions('lsqlin','MaxIter',10000);
    C = lsqlin(Square,ProductColumn,[],[],[],[],zeros(1,ETerms),[],[],options);
end