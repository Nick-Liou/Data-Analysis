
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





V = Table.Variables ;
% n choose k all combinations 
pairs = nchoosek(2:10, 2);

for i = 1 : length(pairs) 
    
    % Access the element at the current index
    index1 = pairs(i,1);
    index2 = pairs(i,2);
    name1 = Names{index1};
    name2 = Names{index2};
    
    
    % Do something with the pair    
    fprintf('Pair %s %s \n' , name1 , name2 );    
    
    X = V(:,index1) ; 
    Y = V(:,index2) ;
    
    
    [ci_1, p_1, ci_2, p_2 , n] = Group1Exe4Fun1(X,Y);
    
%     break 
    
    
    
end