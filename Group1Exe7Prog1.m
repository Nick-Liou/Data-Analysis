
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


% To ingore the and 9th and 11th column (the FG TN)
independent_id = [2:8 10 12];
dependent_id = [9 ] ;



adj_r_squared_best = zeros(length(dependent_id),length(independent_id));

for i=1:length(dependent_id)
    element_dependent = Names{dependent_id(i)};
    % Create a figure
    figure_name_text = sprintf("Group1Exe6_Least-squares-lines for dependent %s" , element_dependent);
    figure('Name',figure_name_text);  
    % Give it a title
    title_text = sprintf("Least-squares-line ===== ? ====  for dependent %s" , element_dependent);
    sgtitle(title_text);
    
    id = 0 ;
    for j=1:length(independent_id)
        if (j == i )
            continue
        end
        id = id + 1 ;
        % Find the independent criteria name (used for the label)
        element_independent = Names{independent_id(j)};
        
        % Find which subplot the function will do the scatter plot (and the line)
        subplot(3,3,id);
        
        % Find the right data for the function 
        X = Table.(independent_id(j));   % independent
        Y = Table.(dependent_id(i));   % dependent
        
        % Find r^2 and make the plots
        [adj_r_squared_best(i,j) , best_model_name ] = Group1Exe7Fun1(X, Y);
        
        % Add labes to the axis
        xlabel(element_independent);
        ylabel(element_dependent);
    end
    
    legend("test1", "test2");
    
    
end
