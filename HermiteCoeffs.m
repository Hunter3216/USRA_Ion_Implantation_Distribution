function [Hermites] = HermiteCoeffs(n)
    %Purpose: create a list of probabilists' Hermite polynomials
    %   for taking moments of normal distributions (here the first Hermite
    %   polynomial = 1) using the relation Hn+1 = x*Hn - n*Hn-1
    %
    %Pre-Conditions:
    %   n: number of Hermite polynomial coefficients to return
    %
    %Return:
    %   Hermites: a cell array of list that contain the coefficients for
    %   each polynomial i.e. Hermites{1} is [1]
    %                        Hermites{2} is [0 , 1]
    %                        Hermites{3] is [-1, 0, 1]
    %                        Hermites{4} is [0 ,-3, 0, 1] etc
    
    Hermites = cell(n,1);
    Hermites{1} = [1];
    Hermites{2} = [0, 1];
    
    for k = 2 : n-1
        Hermites{k+1} = [0, Hermites{k}] - (k-1) * [Hermites{k-1}, 0, 0];
    end
end
