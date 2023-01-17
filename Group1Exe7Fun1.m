function [ R_max , best_model_name  ] = Group1Exe7Fun1(X, Y)

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
    
        
    % Those models are implemented :
    % model 1 : y = ax + b
    % model 2 : y = ax^2 +bx + c
    % model 3 : y = ax^3 + bx^2 +cx + d
    % model 4 : y = ae^(bx)
    % model 5 : y = ax^b 
    % model 6 : y = a + blog(x)
    % model 7 : y = a + b/x
    
    number_of_models = 8 ;
    f_models = cell(3,number_of_models) ;    
    
    % f_models{1,i} = transform X,Y to correct input for regress
    % f_models{2,i} = evaluate the model with the output of regress and x values at which to evaluate
    % f_models{3,i} = The model type that the regress will use (in Latex format for the legend)
    
    % Polynomial models
    
    
    % y = ax + b
    f_models{1,1} = @(X,Y) [Y X ones(length(X),1)];
    f_models{2,1} = @(p,X) p(1)*X+p(2) ;  
    f_models{3,1} = "$y = ax + b$" ;
    
    % y = ax^2 +bx + c
    f_models{1,2} = @(X,Y) [Y X.^2 X ones(length(X),1)];
    f_models{2,2} = @(p,X) p(1)*X.^2 + p(2)*X + p(3);  
    f_models{3,2} = "$y = ax^2 +bx + c$" ;  
    
    % y = ax^3 + bx^2 +cx + d
    f_models{1,3} = @(X,Y) [Y X.^3 X.^2 X ones(length(X),1)];
    f_models{2,3} = @(p,X) p(1)*X.^3 + p(2)*X.^2 + p(3)*X + p(4);
    f_models{3,3} = "$y = ax^3 + bx^2 +cx + d$" ;
    
    
    % non-linear models (but linear)
    
    % y = ae^(bx)
    f_models{1,4} = @(X,Y) [log(Y) X ones(length(X),1)];
    f_models{2,4} = @(p,X) exp(p(2) + p(1) * X) ;
    f_models{3,4} = "$y = ae^{bx}$" ;
    
    % y = ax^b 
    f_models{1,5} = @(X,Y) [log(Y) log(X) ones(length(X),1)];
    f_models{2,5} = @(p,X) exp(p(2)) * X.^p(1) ;
    f_models{3,5} = "$y = ax^b $" ;
    
    % y = a + blog(x)
    f_models{1,6} = @(X,Y) [Y log(X) ones(length(X),1)];
    f_models{2,6} = @(p,X) p(1)*log(X)+p(2) ;
    f_models{3,6} = "$y = a + b\cdot ln(x)$" ;
    
    % y = a + b/x
    f_models{1,7} = @(X,Y) [Y 1./X ones(length(X),1)];
    f_models{2,7} = @(p,X) p(1)./X+p(2) ;
    f_models{3,7} = "$y = a + \frac{b}{x}$" ;
    
    % Extra the mean 
    % y = a
    f_models{1,8} = @(X,Y) [Y ones(length(X),1)];
    f_models{2,8} = @(p,X) p(1)*ones(length(X),1) ;  
    f_models{3,8} = "$y = a$" ;
    
    
    p_cell_coefficients = cell(1,number_of_models) ;
    
    % Fit the models to X,Y using 
    for i = 1:number_of_models        
        Y_X_input = f_models{1,i}( X , Y ) ;
        %Y_X_input = Y_X_input( isfinite(Y_X_input) );  %%%%%%%%%%%%%%
        Y_X_input(any(isinf(Y_X_input), 2), :) = [];
        Y_input = Y_X_input(:,1);
        X_input = Y_X_input(:,2:end);
        p_cell_coefficients{i} = regress( Y_input, X_input	) ;
        
        
    end
    
    %adjusted_R_squared = 1 ; 
    
    k = cellfun(@length,p_cell_coefficients) - 1 ;
    
    
    y_tilde =  cellfun(@(fh,args)fh(args,X), f_models(2,:), p_cell_coefficients  , 'UniformOutput', false) ;
    
    y_tilde = cell2mat( y_tilde  );
    adjusted_R_squared = 1 - (n-1)./(n-k-1) .* sum( (Y - y_tilde  ).^2  ) / sum( (Y - mean(Y)  ).^2  );
    
    % Find the best model
    [R_max, Index] = max(adjusted_R_squared) ;
    % Find the name of the best model 
    best_model_name = f_models{3,Index} ;
    
    
    plot_points_X = linspace( min(X), max(X));
    
    % Plot Original Data Points
    scatter(X,Y,'DisplayName',"Original Data Points");
    % Set the range of the axis to fit the Original Data Points
    axis manual
    
    
    hold on
    for i = 1:number_of_models               
        % Calculate based on the model the expected y values
        plot_points_Y = f_models{2,i}(p_cell_coefficients{i}, plot_points_X ) ;
        
        % Get the proper model name
        legend_text = char(f_models{3,i});   
        
        % Plot some x values with the expected y values (with the right legend)
        plot( plot_points_X, plot_points_Y ,'DisplayName',legend_text) ;                 
    end    
    legend("Location","best","Interpreter","latex");
    
    
end




