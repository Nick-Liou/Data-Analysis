
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


Table = readtable(file);
Names = Table.Properties.VariableNames ;
fprintf('Loaded the file named : %s \n' , file);    


% To ingore the 11th column (the TN)
valid = [2:10 12];

r_squared_all = zeros(length(valid));

for i=1:length(valid)
    element_dependent = Names{valid(i)};
    % Create a figure
    figure_name_text = sprintf("Group1Exe6_Least-squares-lines for dependent %s" , element_dependent);
    figure('Name',figure_name_text);  
    % Give it a title
    title_text = sprintf("Least-squares-lines for dependent %s" , element_dependent);
    sgtitle(title_text);
    
    id = 0 ;
    for j=1:length(valid)
        if (j == i )
            continue
        end
        id = id + 1 ;
        % Find the independent criteria name (used for the label)
        element_independent = Names{valid(j)};
        
        % Find which subplot the function will do the scatter plot (and the line)
        subplot(3,3,id);
        
        % Find the right data for the function 
        X = Table.(valid(j));   % independent
        Y = Table.(valid(i));   % dependent
        
        % Find r^2 and make the plots
        r_squared_all(i,j) = Group1Exe6Fun1(X, Y);
        
        % Add labes to the axis
        xlabel(element_independent);
        ylabel(element_dependent);
    end
    
end


% Find the best r^2
[B,I] = maxk(r_squared_all,2);
% Find the best criteria for the best r^2
criteriaID = valid(I);
% Find the names of the criteria
valid_names = Names(valid);
% Find the names of the best criteria
best_r_names = Names(criteriaID);


% Table/Cell/array magic, pain and suffering to print them in a more beautiful way 
test = [string(best_r_names) ; B];
test2 = [ test(1,:) ; test(3,:); test(2,:); test(4,:)];
result_table2 = cell2table(num2cell(test2),"VariableNames",valid_names);
% Transpose the table
result_table2 = rows2vars(result_table2);
% Change the names of each column 
result_table2.Properties.VariableNames = ["Dependent" "Independent Best" " r^2 " " Independent second best" "r^2" ];
disp(result_table2)

% Results:

% The T can be explained by TM best and TM can be explained by T best
% which is expected since they are the same pair

% The second best is the TS with the GR (and as above the GR with the TS



