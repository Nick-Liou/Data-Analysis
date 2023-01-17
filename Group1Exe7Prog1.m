
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


% To ingore the and 10th and 11th column (the FG TN)
independent_id = [2:9 12];
dependent_id = [10] ;

first = true ;

adj_r_squared_best = zeros(length(dependent_id),length(independent_id));

tic
for i=1:length(dependent_id)
    element_dependent = Names{dependent_id(i)};
    % Create a figure
    figure_name_text = sprintf("Group1Exe7_Least-squares model fitting for dependent %s" , element_dependent);
    figure('Name',figure_name_text);  
    % Give it a title
    title_text = sprintf("Least squares model fitting for dependent criteria %s" , element_dependent);
    sgtitle(title_text);
    
    id = 0 ;
    for j=1:length(independent_id)
        if (independent_id(j) == dependent_id(i) )
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
        
        temp = char(best_model_name);
        title_text = sprintf( "$Best \\: adjR^2=%1.5f \\:\\: %s$" , adj_r_squared_best(i,j), temp(2:end-1)  ) ;
        title(title_text,"Interpreter","latex");
        
        
        
    end
    
   
    % Find all the legends
    hLeg = findobj(gcf, 'Type', 'Legend');
    % Make most of them invisible
    set(hLeg(2:end),'visible','off')
    % Change the location and size of the one that isn't invisible
    set(hLeg(1),'Position',[0.7 0.13 .17 .17 ]);
    
   
    
    
end

toc

% None of the criteria can explain FG very well (have a very high adjR^2) 
% The one with the best adjR^2 is 0.349 for the criteria RA with a second degree polynomial model  y = ax^2 + bx + c

% Also note that for the criteria SN the adjR^2 is zero
% This means that the best model is the mean value 
% Also this means that all the other adjR^2 are negative in this case!
% which is normal since even though it is called adjR^2 is isn't strictly positive
% when the squared errors are greater than the the squared errors of the mean 
% this can happen or even if they are equal but k is greater than 0.







