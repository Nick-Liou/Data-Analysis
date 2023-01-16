function [  mdl ,mdl2 , mdl3 ] = Group1Exe9Fun1(X, Y , names)

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
    
    X = X(  mask , : ) ;
    Y = Y(mask) ;
    
    n = length(Y) ;
  
    %[p,~,r,~,stats] =  regress( Y , [ones(n,1) X] )
   
    
    mdl = fitlm(X,Y ,  'VarNames',names);
    mdl1 = mdl ;
    p = mdl.Coefficients.Estimate ; % Model Coefficients
    R_squared = mdl.Rsquared.Ordinary  ; 
    adj_R_squared = mdl.Rsquared.Adjusted ; 

    r = mdl.Residuals.Raw ;  % (Y- y_tilde  ) == r
    Error_var = var(r) ; 

   
%     y_tilde = [ones(n,1) X] * p  ;
    % (Y- y_tilde  ) == r
    
%     k = length(p)-1 ;    
    
%     R_squared = 1 -  sum( (Y- y_tilde  ).^2  ) / sum( (Y- mean(Y)  ).^2  )
%     adj_R_squared = 1 - (n-1)./(n-k-1) .* sum( (Y- y_tilde  ).^2  ) / sum( (Y- mean(Y)  ).^2  )
    
    
    CoefficientName = string( mdl.CoefficientNames' );
    CoefficientValue = p ;
    p_value =  mdl.Coefficients.pValue;
    Is_significant = p_value < 0.05 ;
    
    fprintf("\n");
    fprintf("\n");
    fprintf("\n");
    
    
    fprintf("R squared: %1.8f | Adjusted R squared: %1.8f | Error variance  %6f \n\n" ,R_squared ,adj_R_squared ,Error_var );
    
    fprintf("Linear regression model: %s \n\n" ,mdl.Formula );
    
    
    disp(table( CoefficientName,CoefficientValue , p_value , Is_significant  ))
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mdl = stepwiselm(X,Y ,  'VarNames',names);
    mdl2 = mdl ;
    
    p = mdl.Coefficients.Estimate ; % Model Coefficients
    R_squared = mdl.Rsquared.Ordinary  ; 
    adj_R_squared = mdl.Rsquared.Adjusted ; 

    r = mdl.Residuals.Raw ;  % (Y- y_tilde  ) == r
    Error_var = var(r) ; 

    
    CoefficientName = string( mdl.CoefficientNames' );
    CoefficientValue = p ;
    p_value =  mdl.Coefficients.pValue;
    Is_significant = p_value < 0.05 ;
    
    fprintf("\n");
    fprintf("\n");
    fprintf("\n");
    
    
    fprintf("R squared: %1.8f | Adjusted R squared: %1.8f | Error variance  %6f \n\n" ,R_squared ,adj_R_squared ,Error_var );
    
    fprintf("Linear regression model: %s \n\n" ,mdl.Formula );
    disp(table( CoefficientName,CoefficientValue , p_value , Is_significant  ))
    
    
    %     stepwise(X,Y );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    [coeff,score,latent,tsquared,explained,mu] = pca(X);
    
    % explained == 100* latent / sum(latent) 
    % X*coeff == score 
    
    
    % Choose k based on percentage of variance explained
    threshold = 0.95; % Set the threshold for explained variance
    explained_variance = cumsum(explained);
    k = find(explained_variance>100*threshold,1);
    
    d_reduced_X = score(:,1:k);
  
    
    mdl = fitlm(d_reduced_X,Y);
    mdl3 = mdl ;
    p = mdl.Coefficients.Estimate ; % Model Coefficients
    R_squared = mdl.Rsquared.Ordinary  ; 
    adj_R_squared = mdl.Rsquared.Adjusted ; 

    r = mdl.Residuals.Raw ;  % (Y- y_tilde  ) == r
    Error_var = var(r) ; 

     
    
    CoefficientName = string( mdl.CoefficientNames' );
    CoefficientValue = p ;
    p_value =  mdl.Coefficients.pValue;
    Is_significant = p_value < 0.05 ;
    
    fprintf("\n");
    fprintf("\n");
    fprintf("\n");
    
    
    fprintf("R squared: %1.8f | Adjusted R squared: %1.8f | Error variance  %6f \n\n" ,R_squared ,adj_R_squared ,Error_var );
    
    fprintf("Linear regression model: %s \n\n" ,mdl.Formula );
    
    
    disp(table( CoefficientName,CoefficientValue , p_value , Is_significant  ))
    
    
    
end