function [Voltages,Ranges,Straggle] = Data_Get(path)
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
    Voltages = str2double(split(:,1));
    Ranges = str2double(split(:,5));
    Straggle = str2double(split(:,7));
    
    %Corrects Voltages for when eV switches to keV
    for k = 2 : length(C)
       if Voltages(k) < Voltages(k-1) 
           Voltages(k) = 1000*Voltages(k);
       end
    end
end
