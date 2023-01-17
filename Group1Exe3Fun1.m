function [p_parametric, p_bootstrap] = Group1Exe3Fun1(X_Year, X)

    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045
    
    arguments
        % Make inputs a row vector
        X_Year  (1,:)	{mustBeNumeric}
        X       (1,:)	{mustBeNumeric} 
    end
    
    % Check inputs have the same size
    if( length(X) ~= length(X_Year) )
            % Crash
            error("In function Group1Exe3Fun1 input vectors do not have the same length");
    end

    % Find first discontinuity in first vector
    discont = find(diff(X_Year)~=1, 1);
    if(isempty(discont))
        error("No discontinuity found in 'Year' data");
    end

    % Split data of 2nd vector
    X1 = X(1:discont);
    X2 = X(discont+1:end);
    

    % Remove NaN from input
    X1 = X1(~isnan(X1));
    X2 = X2(~isnan(X2));
    % If all of them are NaN RIP and return NaN
    if( isempty(X1) || isempty(X2))
        p_parametric = NaN;
        p_bootstrap  = NaN;        
        warning("One of the vectors after the split is empty (or has only Nan). (Return values are NaN)");
        return
    end
    
    % Do parametric method to find p-value
    [~, p_parametric, ~] = ttest2(X1, X2);
    
    % Do permutation method (with replacement)
    B = 1000;
    means1 = bootstrp(B, @mean, X1,'Options',statset('UseParallel',true));
    means2 = bootstrp(B, @mean, X2,'Options',statset('UseParallel',true));
    stat = means2-means1;
    
    
    % Returns the p-value for the boostrap values (for 0 to be inside)
    [~ ,p_bootstrap , ~] = Group1Exe3Fun2( stat );
    
   
    
end