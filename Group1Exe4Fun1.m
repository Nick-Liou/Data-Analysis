function [ci_1, p_1, ci_2, p_2 , n] = Group1Exe4Fun1(X, Y , options)


    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    
    arguments
        % Make inputs a column vector
        X (:,1)	{mustBeNumeric}
        Y (:,1)	{mustBeNumeric} 
        options.Alpha  	(1,1)   double  {mustBeNumeric,mustBeGreaterThan(options.Alpha,0),mustBeLessThan(options.Alpha,1)} = 0.05
    end
    
    % Check inputs have the same size
    if( length(X) ~= length(Y) )
            % Crash
            error("In function Group1Exe4Fun1 input vectors do not have the same length");
    end
    
  
    a = options.Alpha;
    
    
    % Delete NaN
    mask = ~( isnan(X)| isnan(Y) );
    X = X(mask) ;
    Y = Y(mask) ;
    
    n = length(X) ;
    
    % find r
    %corr_val = cov(X,Y) ;
    %r = corr_val(1,2) / sqrt( corr_val(1,1) * corr_val(2,2) ) ;
    % This is the same as the above (and is used in to find the boot_ci)
    r = corr(X,Y);
    
    z = atanh(r);
    var_z = 1 / (n-3) ;
    

    ci_z = norminv([a/2 ; 1-a/2], z, sqrt(var_z));
    % This is the same as the ones below :
    % ci_z_high = z + norminv( 1-a/2) * sqrt(var_z) 
    % ci_z_low  = z - norminv( 1-a/2) * sqrt(var_z) 
    
    ci_r_parametric = tanh(ci_z);
    
    % Bootstrap 
    B = 1000 ;
    
    
    % parallel version , faster for big values of B
    %[ci_r_boot] = bootci(B,{@corr,X,Y},'type','per', 'Options',statset('UseParallel',true) , "Alpha", a);
    [ci_r_boot] = bootci(B,{@corr,X,Y},'type','per' , "Alpha", a);
    
    
    t = r * sqrt((n-2)/(1-r^2)) ;
    
    dof = n - 2 ;
    
    % Those are the same but the second is more accurate   
        
    %p = 2 * (1 -  tcdf(t,dof)) ;
    p_parametric = 2 * tcdf(abs(t),dof,'upper');
    
    
    % p > a => r == 0 
    
    % find p using random permutation or randomization test
    
    r_values_bootstrap = NaN (B,1);
    
    for i=1:B
        % The transpose is used to return a column vector so that X_boot and Y_boot are also column vectors
        indexes = randperm(length(X))';
        X_boot = X(indexes);
        Y_boot = Y;
        
        % This function must take tow column vectors        
        r_values_bootstrap(i) = corr(X_boot,Y_boot) ;
        
    end
    
       
    % Returns the p-value for the boostrap values (for 0 to be inside)
    [~, p_bootstrap, ~] = Group1Exe3Fun2( r_values_bootstrap , r);
    
    
    ci_1 = ci_r_parametric;
    ci_2 = ci_r_boot;
    p_1  = p_parametric;
    p_2  = p_bootstrap;
    
end

