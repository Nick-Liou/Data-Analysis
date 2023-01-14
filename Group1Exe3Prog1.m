
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


alpha = 0.05 ;


min_p_parametric = 1 ;
index_parametric = 2 ;
min_p_bootstrap  = 1 ;
index_bootstrap = 2 ;

% Iterate over the elements of the cell array
for i = 2:10
    % Access the element at the current index
    element = Names{i};
    
    % Do something with the element
    
    fprintf("\nMetric %s \n" ,element);
    
    
    [p_param , p_boot] = Group1Exe3Fun1( Table.("Year") , Table.(element)  );
    
    fprintf("The p-value for parametric : %5g \n" , p_param);
    fprintf("The p-value for bootstrap  : %5g \n" , p_boot);
    
    if ( min_p_parametric >= p_param )
       min_p_parametric = p_param ;  
       index_parametric = i ;
    end
    if ( min_p_bootstrap >= p_boot )
       min_p_bootstrap = p_boot ;  
       index_bootstrap = i ;
    end
    
    if ( p_param < alpha || p_boot < alpha )
       % Then there is a difference of mean values
       fprintf("!! There is a significant difference of mean values for the metric %s  !! \n", element);
    end
    
    break
end


fprintf("\n\nThe metrics with the highest difference of mean in the two time periods are:\n");
fprintf("For the parametric %s with a p-value: %5g \n", Names{index_parametric},min_p_parametric);
fprintf("For the bootstrap  %s with a p-value: %5g \n", Names{index_bootstrap} ,min_p_bootstrap );

% The results of the two methods (parametric and boostrap) do not fully agree
% There are two reason why this hapends the first is because tha parametric test 
% assumes that both samples have the same distrobution 

% The second reason why there are a lot of zeros in the bootstrap p-values is because 
% we chose B=1000 , so lowest non-zero value it could have is 2/1000. When we expect the value 
% to be much lower than that then it is expected the p_bootstrap to be zero 

% In order to have a non-zero value for p_boostrap we should increase B such that  B > 1/p_parametric 
% or even better B >> 1/p_parametric (assuming the parametric is the correct order of magnitude)



