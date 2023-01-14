function [ I_XY , p_value_boot , n  ] = Group1Exe5Fun1(X, Y)

    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    arguments
        % Make inputs a column vector
        X (:,1)	{mustBeNumeric}
        Y (:,1)	{mustBeNumeric} 
    end
    
    % Check inputs have the same size
    if( length(X) ~= length(Y) )
            % Crash
            error("In function Group1Exe4Fun1 input vectors do not have the same length");
    end
    
         
    % Delete NaN
    mask = ~( isnan(X)| isnan(Y) );
    X = X(mask) ;
    Y = Y(mask) ;
    
    n = length(X) ;
    
  
    X = double(X > median(X));
    Y = double(Y > median(Y));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     X = 100*rand(10,1)-50
%     
%      number_of_groups = 5 ;
%     X = X- min(X); 
%     X = round( X/max(X)*(number_of_groups-1)) 
%     
%     groups_length = 100/ (number_of_groups) ;
%     prctile(X,[0:groups_length:100])
%     
%     grouped_X =  round(X/max(X) * (number_of_groups-1))
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    I_XY =  Group1Exe5Fun2(X, Y) ;
    
    
    B = 1000;
    mutual_information_values_bootstrap = nan(B,1);
    
    for i=1:B
         
        indexes = randperm(length(X))';
        X_boot = X(indexes);
        Y_boot = Y;
        
        % This function must take tow column vectors        
        mutual_information_values_bootstrap(i) = Group1Exe5Fun2(X_boot, Y_boot) ;
        
    end
    
    
    [~, p_value_boot, ~] = Group1Exe3Fun2( mutual_information_values_bootstrap );
    
    
    
end