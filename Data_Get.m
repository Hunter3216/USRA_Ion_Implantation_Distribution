function [Energy,Range,StraggleLong, StraggleLat] = Data_Get(path)
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
    EnergyUnits = (split(:,2));
    Range = str2double(split(:,5));
    RangeUnits = (split(:,6));
    StraggleLong = str2double(split(:,7));
    StraggleLongUnits = (split(:,8));
    StraggleLat = str2double(split(:,9));
    StraggleLatUnits = (split(:,10));
    
    %Corrects Energy by switching to keV, Range all to A, Straggle all to A
    for k = 1 : length(Energy)
        switch EnergyUnits{k}
            case 'eV'
                Energy(k) = Energy(k)/1000;
            case 'keV'
            case 'MeV'
                Energy(k) = Energy(k)*1000;
            otherwise
                error('Data_Get:UnknownUnit',['Unknown unit type for energy:',EnergyUnits{k}])
        end
        switch RangeUnits{k}
            case 'A'
            case 'um'
                Range(k) = Range(k) * 10000;
            otherwise
                error('Data_Get:UnknownUnit',['Unknown unit type for range:',RangeUnits{k}])
        end
        switch StraggleLongUnits{k}
            case 'A'
            case 'um'
                StraggleLong(k) = StraggleLong(k) * 10000;
            otherwise
                error('Data_Get:UnknownUnit',['Unknown unit type for straggle:',StraggleLongUnits{k}])
        end
        switch StraggleLatUnits{k}
            case 'A'
            case 'um'
                StraggleLat(k) = StraggleLat(k) * 10000;
            otherwise
                error('Data_Get:UnknownUnit',['Unknown unit type for straggle:',StraggleLatUnits{k}])
        end
    end
end

