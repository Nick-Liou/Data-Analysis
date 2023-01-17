
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



%find(Table.Year == 1973 ) 
last_years = Table(Table.Year >= 1973 ,:)  ;


independent_id = (2:12);
dependent_id = [10 12] ;

for i=1:length(dependent_id)
    
    
    independent_id_iter = setdiff(independent_id,dependent_id(i)) ;
     
    input_names = { Names{independent_id_iter}  Names{dependent_id(i)}};
    
    X = last_years{:,independent_id_iter}    ;
    Y = last_years.(dependent_id(i)) ;
    [  ~ ,~ , ~ ] = Group1Exe9Fun1(X, Y , input_names) ;
    
    
end

% The first model (regression) uses all the variables.
% So it has the best R squared, but it has a lot unecessary complexity
% and is probably not ideal because some variables are not correlated with the dependend variable

% The Adjusted R squared of the second model (stepwise) is the best which is expected
% since it uses less variables so k is smaller.

% The last model (pcr) has only one variable, and has the worst Adjusted R squared (and R squared)
% even though we chose the number of principal components that account
% for more than 95% of the total variance.
% Perhaps we should had chosen a bigger number instead of 95% but it should had been 99.99% to see improvement
% because the first (and only) variable we add to the model explaines at least 95% of the total variance.

% This could mean that Y is probably not better explained by the principal components
% with the highest variance.

% NOTE:
% Using stepwise after the PCA we can get better results
















