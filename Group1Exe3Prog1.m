
[p1, p2] = func([1,2,3,4, 6, 7, 8, 10], [1,2,3,4, -1, 3, 3, 5]);


function [p1, p2] = func(X_Year, X)
  
    % Find first discontinuity in first vector
    discont = find(diff(X_Year)~=1, 1);
    if(isempty(discont))
        error("No discontinuity found in 'Year' data");
    end

    % Split data of 2nd vector
    X1 = X(1:discont);
    X2 = X(discont+1:end);

    % Do parametric method
    [h1, p1, ci1] = ttest2(X1, X2);

    % Do permutation method (with replacement)
    n_boot = 1000;
    means1 = bootstrp(n_boot, @mean, X1);
    means2 = bootstrp(n_boot, @mean, X2);
    stat = means2-means1;
    ci2 = prctile(stat, [2.5, 97.5]);
    h2 = (ci2(1) > 0) || (ci2(2) < 0);

    % Check how large we can make the interval until it accepts 0
    % In other words, measure how extreme the 0-value seems in our
    % bootstrap statistic
    % p value is the probability that, for 0 being the true
    % value of the statistic, we rejected it
    dist_of_0_from_center = abs( length(stat)/2 - sum(stat<0) );
    p2 = 1 - (2*dist_of_0_from_center / length(stat));


    
end