% Liouliakis Nikolaos  AEM: 10058
% Panagiotis Syskakis  AEM: 10045

table = sortrows(readtable("Heathrow.xlsx"), "Year");

% Needed to split data later
idx_1973 = find(table.Year == 1973);

% For first 9 data columns
for i = 2:10

    % Get data starting at 1973
    X = table.(i)(idx_1973:end);
    X = X(~isnan(X));

    % Get confidence intervals
    [ci1, ci2] = get_ci(X);

    % Calculate the difference of the two ci, normalized to the 
    % width of the interval:
    ci_rel_diff = (ci2-ci1)./(ci1(2)-ci1(1));

     % Get mean before 1973
     X_past = table.(i)(1:idx_1973-1);
     X_past = X_past(~isnan(X_past));
     m = mean(X_past);

     % Check if the mean is inside the confidence intervals
     r1 = (m < ci1(1)) || (m > ci1(2));
     r2 = (m < ci2(1)) || (m > ci2(2));

     % Print results
     fprintf("\n%s\n", table.Properties.VariableNames{i})
     fprintf("Parametric ci: [%f, %f]\n", ci1(1), ci1(2));
     fprintf("Bootstrap ci: [%f, %f]\n", ci2(1), ci2(2));
     fprintf("Relative diff:: [%f%%, %f%%]\n", 100*ci_rel_diff(1), 100*ci_rel_diff(2));
     fprintf("Mean: %f\n", m);
     fprintf("Mean inside ci: %i, %i\n", r1, r2);

     % Print remarks about significant differences:
     % If mean was not in ci
     if (~r1 || ~r2)
        fprintf("!! Mean outside of confidence interval !!\n");
     end
     % If there is large deviation in the two ci
     if any(abs(ci_rel_diff) > 0.1)
        fprintf("!! More than 10%% difference in ci bounds !!\n");
     end

     

end


function [ci1, ci2] = get_ci(X)  
    [~,~,ci1] = ttest(X, mean(X));
    ci2 = bootci(1000, @(x)mean(x), X);
end