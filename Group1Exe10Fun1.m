function [  adj_R_squared , formula ] = Group1Exe10Fun1(X, Y , names)

    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    arguments
        % Make inputs a column vector
        X (:,:)	{mustBeNumeric}
        Y (:,1)	{mustBeNumeric} 
        names (:,1) cell 
    end
    
    x_sizes = size(X) ;
    
    % Check inputs have the same size
    if( x_sizes(1) ~= length(Y) &&  x_sizes(2) ~= length(Y) )
        % Crash
        error("In function Group1Exe9Fun1 input vectors do not have the same length");
    end
    
    
    
    % Check inputs have the same size
    if( x_sizes(2) == length(Y) && x_sizes(1) ~= length(Y) )
        %flip the matrix
        X = X';
    end
    
    if ( length(names) ~= size(X,2)+1 )
        % Crash
        error("In function Group1Exe9Fun1 input names do not have the same length as [X Y]");
    end
    
    
    % Delete NaN    (This is also done inside the regress function )
    %mask = ~( isnan(X)| isnan(Y) ); % This does not work because X is a matrix
    mask = sum( ( isnan(X)| isnan(Y) )  ,2) == 0 ;
    
    X = X( mask , : ) ;
    Y = Y(mask) ;
    
    n = length(Y) ;
    
    
    
    mdl = fitlm(X,Y ,  'VarNames',names);
    mdl1 = mdl ;
    p = mdl.Coefficients.Estimate ; % Model Coefficients
    R_squared = mdl.Rsquared.Ordinary  ; 
    adj_R_squared = mdl.Rsquared.Adjusted ; 
    
    formula = mdl.Formula ;
%     fprintf("Linear regression model: %s \n" ,mdl.Formula );

    
    
    
    
  
    
    
end




