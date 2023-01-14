function [ci_1, p_1, ci_2, p_2 , n] = Group1Exe4Fun1(X, Y)


    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    
    arguments
        % Make inputs a column vector
        X (:,1)	{mustBeNumeric}
        Y (:,1)	{mustBeNumeric} 
    end
    
    
    ci_1 = NaN;
    ci_2 = NaN;
    p_1  = NaN;
    p_2  = NaN;
    n    = NaN;
    

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
    
    % find r
    %corr_val = cov(X,Y) ;
    %r = corr_val(1,2) / sqrt( corr_val(1,1) * corr_val(2,2) ) ;
    % This is the same as the above (and is used in to find the boot_ci)
    r = corr(X,Y);
    
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
    
    
    % parallel version , faster for big values of B
    %[ci_r_boot] = bootci(B,{@corr,X,Y},'type','per', 'Options',statset('UseParallel',true));
    [ci_r_boot] = bootci(B,{@corr,X,Y},'type','per');
    
    
    t = r * sqrt((n-2)/(1-r^2)) ;
    
    dof = n - 2 ;
    
    % Those are the same but the second is more accurate   
        
    %p = 2 * (1 -  tcdf(t,dof)) ;
    p_parametric = 2 * tcdf(abs(t),dof,'upper');
    
    
    % p > a => r == 0 
    
    % find p using random permutation or randomization test
    
    r_values_bootstrap = NaN (B,1);
    same_sample = [X Y] ;
    for i=1:B
        
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        % The transpose is used to return a column vector so that X_boot and Y_boot are also column vectors
        indexes = randperm(2*length(X))';
        X_boot = same_sample(indexes(1:n));
        Y_boot = same_sample(indexes(n+1:end));
        
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
        % Which is the correct ? ?????????????????????????????????????
        
        % The transpose is used to return a column vector so that X_boot and Y_boot are also column vectors
        indexes = randperm(length(X))';
        X_boot = X(indexes);
        Y_boot = Y;
        
        % This function must take tow column vectors        
        r_values_bootstrap(i) = corr(X_boot,Y_boot) ;
        
    end
    
       
    % Returns the p-value for the boostrap values (for 0 to be inside)
    [~, p_bootstrap, ~] = Group1Exe3Fun2( r_values_bootstrap );
    
    
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Not used start ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %     figure; 
    %     histogram(r_values_bootstrap);
    
    r_values_bootstrap = sort([r_values_bootstrap ; 0 ] ); 
    %     
    %     figure; 
    %     plot(1:B+1,r_values_bootstrap);
    
    index_first = find( r_values_bootstrap == 0 , 1 , "first");
    index_last  = find( r_values_bootstrap == 0 , 1 , "last");
    
    final = (mean([index_first index_last]) );
    final2 = abs(length(r_values_bootstrap)/2 - final );
    final3 = round( abs(length(r_values_bootstrap)/2 - final ));
    p_boot_new_way = 1 -  final3 * 2 / length(r_values_bootstrap) ;
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Not used end ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    ci_1 = ci_r_parametric;
    ci_2 = ci_r_boot;
    p_1  = p_parametric;
    p_2  = p_bootstrap;
    
end

