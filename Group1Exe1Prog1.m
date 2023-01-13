
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

final_p_values = zeros(5,numel(Names)) ;

% Iterate over the elements of the cell array
for i = 2:numel(Names)
    % Access the element at the current index
    element = Names{i};
    % Do something with the element
    disp(element);
    V = Table.Variables ;
    
    V_temp = V(~isnan(V(:,i)),i) ;
    [p_1 , p_2 , discrete ,h_1 , h_2 ] = Group1Exe1Fun1(V_temp );
    
    final_p_values(:,i) = [p_1  p_2  discrete h_1  h_2 ] ;

    type = [ "continuous" "discrete" ] ;
    distrobution_names = [ "Normal" "Uniform" ; "Binomial"  "Uniform" ] ; 
    h_result_string = [ "accepted" "rejected" ] ;

    fprintf("The data were interperted as %s \n" , type(discrete+1) );
    fprintf("The p-value for %s is %f and for %s is %f \n" , distrobution_names(discrete+1 , 1 ) , p_1  ,distrobution_names(discrete+1 , 2 ) , p_2 );
    fprintf("The %s distribution is %s and the %s distribution is %s \n" , distrobution_names(discrete+1 , 1 ) , h_result_string(h_1+1)  ,distrobution_names(discrete+1 , 2 ) , h_result_string(h_2+1)  );
    
    [~, index] = max([p_1 p_2]);
    if ( ~h_1 || ~h_2 ) 
        fprintf("The %s distribution is chosen because it has the bigger p-value \n" , distrobution_names(discrete+1 , index ) );
    else
        fprintf("None of the distributions fit the data \n" )
    end
    
    fprintf("\n");
end

final_p_values;


