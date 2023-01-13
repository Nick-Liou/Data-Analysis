function [ci_1, p_1, ci_2, p_2 , n] = Group1Exe4Fun1(X, Y)


    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    ci_1 = NaN;
    ci_2 = NaN;
    p_1  = NaN;
    p_2  = NaN;
    n    = NaN;
    
    
    
    % Check input is a vector
    if( ~isvector(X) || ~isvector(Y) )
            % Crash
            error("In function Group1Exe4Fun1 input was not a vector");
    end
    
    % Check inputs have the same size
    if( length(X) ~= length(Y) )
            % Crash
            error("In function Group1Exe4Fun1 input vectors do not have the same length");
    end
    
    % Make sure it is a row vector         
    if( ~iscolumn(X) )
            X = X';
    end
    % Make sure it is a row vector         
    if( ~iscolumn(Y) )
            Y = Y';
    end
    
    
    % Delete NaN
    mask = ~( isnan(X)| isnan(Y) );
    X = X(mask) ;
    Y = Y(mask) ;
    
    n = length(X) ;
    
    % find r
    corr_val = cov(X,Y) ;
    r = corr_val(1,2) / sqrt( corr_val(1,1) * corr_val(2,2) ) ;
    % This is the same as the above (and is used in to find the boot_ci
    r_2 = corr(X,Y);
    
    z = atanh(r);
    var_z = 1 / (n-3) ;
    a = 0.05;
    

    ci_z = norminv([a/2 ; 1-a/2], z, sqrt(var_z));
    % This is the same as the ones below :
    % ci_z_high = z + norminv( 1-a/2) * sqrt(var_z) 
    % ci_z_low  = z - norminv( 1-a/2) * sqrt(var_z) 
    
    ci_r_parametric = tanh(ci_z);
    
    % Bootstrap 
    B = 1000 ;
    
    
    [ci_r_boot] = bootci(B,{@corr,X,Y},'type','per');
    
    t = r * sqrt((n-2)/(1-r^2)) ;
    
    dof = n - 2 ;
    
    % Those are the same but the second is more accurate
    %p = 2 * (1 -  tcdf(t,dof)) ;
    p_parametric = 2 * tcdf(t,dof,'upper');
    
    % find p using random permutation or randomization test
    
    r_values_bootstrap = NaN (B,1);
    same_sample = [X Y] ;
    for i=1:B
        % The transpose is used to return a column vector so that X_boot and Y_boot are also column vectors
        indexes = randperm(2*length(X))';
        X_boot = same_sample(indexes(1:n));
        Y_boot = same_sample(indexes(n+1:end));
        
        % This function must take tow column vectors        
        r_values_bootstrap(i) = corr(X_boot,Y_boot) ;
        
    end
    
    
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % Is this right ? ??????????????????????????
    % How small alpha/2 can be to include zero in the ci of r_values_bootstrap    
    min_alpha_half = min( sum(r_values_bootstrap<0) ,  sum(r_values_bootstrap>0) ) ;
    % make sure to take care the case there are zeros in stat (tho very inprobable)    
    zeros_in_r_values_bootstrap = sum(r_values_bootstrap==0);
    min_alpha_half = min( min_alpha_half + zeros_in_r_values_bootstrap/2 , B/2) ;
    % Find the p value
    p_bootstrap = 1 - min_alpha_half * 2 / B;
    
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % Is this right ? ??????????????????????????
    
    
    ci_1 = ci_r_parametric;
    ci_2 = ci_r_boot;
    p_1  = p_parametric;
    p_2  = p_bootstrap;
    
end

