
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

last_years.Variables

independent_id = [2:12];
dependent_id = [10 12] ;

for i=1:length(dependent_id)
    
    
    independent_id_iter = setdiff(independent_id,dependent_id(i)) ;
     
    input_names = { Names{independent_id_iter}  Names{dependent_id(i)}};
    
    X = last_years{:,independent_id_iter}    ;
    Y = last_years.(dependent_id(i)) ;
    [  ~ ,~ , ~ ] = Group1Exe9Fun1(X, Y , input_names) ;
    
    
end

%%% sxolia !!!!! 


