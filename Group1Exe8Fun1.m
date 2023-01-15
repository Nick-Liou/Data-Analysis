function [ adj_R_squared , p_value  ] = Group1Exe8Fun1(X, Y)

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
    
    
    % Delete NaN    (This is also done inside the regress function )
    mask = ~( isnan(X)| isnan(Y) );
    X = X(mask) ;
    Y = Y(mask) ;
    
    n = length(X) ;
    
    
    %y = ax^2 + bx + c ;
    p = polyfit(X,Y,2);
    
    y_tilde = p(1)*X.^2 + p(2)*X + p(3);
    k = 2 ;
    adj_R_squared = 1 - (n-1)./(n-k-1) .* sum( (Y- y_tilde  ).^2  ) / sum( (Y- mean(Y)  ).^2  );
    
   
    
    
end