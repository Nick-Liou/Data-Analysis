
% Liouliakis Nikolaos  AEM: 10058
% Panagiotis Syskakis  AEM: 10045

clear;
close all; 

file = "Heathrow.xlsx";

if  exist( file , 'file') == 2 
        %This means the file exists :).
        T = readtable(file);
        Names = T.Properties.VariableNames ;
        %load(file);
        fprintf('Loaded the file named : %s \n' , file);    
        %dataLoaded = true ;

else
        fprintf('\nThe file named : %s does not exist in the current directory' , file);
        fprintf('\nThe current directory is named : %s ' , pwd);
        
end

% Iterate over the elements of the cell array
for i = 1:numel(Names)
    % Access the element at the current index
    element = Names{i};
    % Do something with the element
    disp(element);
    V = T.Variables ;
    
    Group1Exe1Fun1( V(:,i) );
    %(:,i)
    %break
    %T{element}
end
