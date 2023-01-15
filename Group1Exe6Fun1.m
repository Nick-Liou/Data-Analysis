function [ r_squared  ] = Group1Exe6Fun1(X, Y)

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
    
    
    
    r_squared = corr(X,Y)^2 ;
    
    % y = ax+b ;
    
    p = polyfit(X,Y,1);
    
    % Y = p(1)*X + p(2)
    
    
    
    scatter(X,Y);
    hold on 
    range = [min(X) max(X)];
    plot(range,  p(1)*range + p(2));
    
    %legend("Data points" , "Least-squares line" , "Location","Best");
    text = sprintf("r^2 = %5g" ,r_squared );
    title(text);
    
    
end