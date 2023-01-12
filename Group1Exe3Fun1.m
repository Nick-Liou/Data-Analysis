function [p_parametric, p_bootstrap] = Group1Exe3Fun1(X_Year, X)
  
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
        return
    end
    
    % Do parametric method to find p-value
    [~, p_parametric, ~] = ttest2(X1, X2);
    
    % Do permutation method (with replacement)
    B = 1000;
    means1 = bootstrp(B, @mean, X1);
    means2 = bootstrp(B, @mean, X2);
    stat = means2-means1;
    
    
    % How small alpha/2 can be to include zero in the ci of stats    
    min_alpha_half = min( sum(stat<0) ,  sum(stat>0) ) ;
    % make sure to take care the case there are zeros in stat (tho very inprobable)    
    zeros_in_stat = sum(stat==0);
    min_alpha_half = min( min_alpha_half + zeros_in_stat/2 , B/2) ;
    % Find the p value
    p_bootstrap = min_alpha_half * 2 / B;

    
end