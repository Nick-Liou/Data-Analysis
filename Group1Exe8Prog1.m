
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
dependent_id    = [10] ; % FG


adj_r_squared       = zeros(length(dependent_id),length(independent_id));
p_values_r_squared  = zeros(length(dependent_id),length(independent_id));

for i=1:length(dependent_id)
    %element_dependent = Names{dependent_id(i)};
    
    for j=1:length(independent_id)
        if (independent_id(j) == dependent_id(i) )
            continue
        end
        % Find the independent criteria name (used for the label)
        %element_independent = Names{independent_id(j)};
       
        % Find the right data for the function 
        X = Table.(independent_id(j)); 	% independent
        Y = Table.(dependent_id(i));    % dependent
        
        % Find r^2 and make the plots
        [adj_r_squared(i,j) , p_values_r_squared(i,j) ] = Group1Exe8Fun1(X, Y);
        
    end
    %     [~, indexes] = maxk(adj_r_squared(i,:), 3 ) ;
    %     Names(independent_id(indexes))
end

how_many_maxk = 10 ;
[~, indexes] = mink(p_values_r_squared, how_many_maxk ,2) ;

knn_names = string( Names(independent_id(indexes)) );  % String ( Cell array )



fprintf("\nSelected model: y = ax^2 + bx + c "  ) ;
for i = 1:length(dependent_id)
%     knn_adjr(i,:) = adj_r_squared(i,indexes(i,:))   
%     knn_p_values(i,:) = p_values_r_squared(i,indexes(i,:))
    
    knn_adjr = adj_r_squared(i,indexes(i,:))   ;
    knn_p_values = p_values_r_squared(i,indexes(i,:));
    
    fprintf("\n\nDependent %s \n" , string(Names(dependent_id(i))) ) ;
    for j=1: min( how_many_maxk , length(knn_adjr))
        fprintf("\tCriteria %s\t  adjR^2: %1.5f \t| p-value:  %1.5f \n" , knn_names(i,j) ,knn_adjr(j) , knn_p_values(j) ) ;
    end
end

% For the selected model y = ax^2 + bx + c
% the criteria with statistical significant adjR^2 are  T RA TM Tm V (they have p-value less than 0.05)
% So for those we are confindent that the adjR^2 is correct but the adjR^2 is small
% the model does not fit very well the data.







% names_lenghts = arrayfun(@strlength,knn_names);
% temp = size(names_lenghts);
% B = repmat("  ", temp(1) ,temp(2) );
% 
% mask = names_lenghts == 1;
% B(~mask) = " ";
% 
% result = "Criteria: " + knn_names + B + " | adjR^2: " + knn_adjr + " | p-value: " + knn_p_values ;
% disp(result)





