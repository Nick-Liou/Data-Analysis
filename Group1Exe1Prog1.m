
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



T = readtable(file);
Names = T.Properties.VariableNames ;
fprintf('Loaded the file named : %s \n' , file);    



% Iterate over the elements of the cell array
for i = 1:numel(Names)
    % Access the element at the current index
    element = Names{i};
    % Do something with the element
    disp(element);
    V = T.Variables ;
    
    V_temp = V(~isnan(V(:,i)),i) ;
    % V(:,i)
    Group1Exe1Fun1(V_temp );
    %(:,i)
    %break
    %T{element}
end
