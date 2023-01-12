
% Liouliakis Nikolaos  AEM: 10058
% Panagiotis Syskakis  AEM: 10045

clear;
close all; 

file = "Heathrow.xlsx";

% Make sure the file exists
if  exist( file , 'file') ~= 2        
        fprintf('\nThe file named : %s does not exist in the current directory' , file);
        fprintf('\nThe current directory is named : %s \n' , pwd);
        return        
end


table = sortrows(readtable(file), "Year");

% Needed to split data later
idx_1973 = find(table.Year == 1973);

% For first 9 data columns
for i = 2:10

    % Get data starting at 1973
    X = table.(i)(idx_1973:end);
    X = X(~isnan(X));

    % Get confidence intervals
    [ci1, ci2] = Group1Exe2Fun1(X);

    
    interval1 = ci1;
    interval2 = ci2;

    % Find the span of the overlap
    overlap = min(interval1(2), interval2(2)) - max(interval1(1), interval2(1));
    overlap = max(overlap, 0);
    % Find the span of each interval
    len_interval1 = interval1(2) - interval1(1) ;
    len_interval2 = interval2(2) - interval2(1) ;        
    % Find the total span of the two intervals combined
    total_span = len_interval1 + len_interval2 - overlap ;         
    % Calculate the precentage of overlap
    ovelap_percentage = overlap / total_span ;        
    
        

    % Get mean before 1973
    X_past = table.(i)(1:idx_1973-1);
    X_past = X_past(~isnan(X_past));
    m = mean(X_past);

    % Check if the mean is inside the confidence intervals
    r1 = (m < ci1(1)) || (m > ci1(2));
    r2 = (m < ci2(1)) || (m > ci2(2));

    bool = [ ""  "not " ];
    
    % Print results
    fprintf("\n%s\n", table.Properties.VariableNames{i})
    fprintf("Parametric ci: [%f, %f]\n", ci1(1), ci1(2));
    fprintf("Bootstrap  ci: [%f, %f]\n", ci2(1), ci2(2));
    fprintf("Mean: %f\n", m);
    fprintf("Mean for the first period is %sinside the parametric ci.\n" , bool(r1+1));
    fprintf("Mean for the first period is %sinside the bootrstrap ci.\n" , bool(r2+1));

    % Print remarks about significant differences:
    % If mean was not in ci
    if (r1 || r2)
        fprintf("!! Mean outside of confidence interval !!\n");
    end
    
    
    % If there is large deviation in the two ci
    threshhold = 0.9 ;
    if (ovelap_percentage < threshhold)
        fprintf("!! There is less than %2.2f%% overlap in ci bounds (the overlap is %2.2f%%) !!\n" ,threshhold*100, ovelap_percentage*100);
    else
        fprintf("!! There is more than %2.2f%% overlap in ci bounds (the overlap is %2.2f%%) !!\n" ,threshhold*100, ovelap_percentage*100);
    end

     

end



