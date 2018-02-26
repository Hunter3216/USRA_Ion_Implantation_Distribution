function [Energy,Range,Straggle] = Data_Get(path)
    %Purpose: To read a SRIM text file (given it's path) and return the relevant
    %   info (Energy, Range, Straggle)
    %Pre-Conditions:
    %   path: The path to text file
    %Return:
    %   Energy: all of the ion energies of distributions
    %   Range: all of Energy's corresponding mean ranges
    %   Straggle: all of Energy's corresponding Longitudinal Straggling (or standard deviations)

    %reads in file
    fileID = fopen(path,'r');
    s = textscan(fileID, '%s', 'delimiter', '\n');
    %finds beginning and end points characterized by these strings
    idx1 = find(strcmp(s{1},'--------------  ---------- ---------- ----------  ----------  ----------'),1);
    idx2 = find(strcmp(s{1},'-----------------------------------------------------------'),1);
    fclose(fileID);
    %creates a new cell array of only the lines of interest
    C = cellstr(s{1}(idx1+1:idx2-1));
    
    %splits C into a 2D array of strings
    split = cell(length(C),11);
    for k = 1 : length(C)
        split(k,:) = strsplit(C{k});
    end
    
    %Extracts these data from the relevant columns
    Energy = str2double(split(:,1));
    Range = str2double(split(:,5));
    Straggle = str2double(split(:,7));
    
    %Corrects Energy by switching eV to keV
    k = 1;
    while Energy(k+1) > Energy(k)
        k = k+1;
    end
    Energy(1:k) = Energy(1:k)./1000;
end
