function [p_1 , p_2 , discrete ,h_1 , h_2 ] = Group1Exe1Fun1( X )

    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    p_1 = NaN ;
    p_2 = NaN ; %#ok<NASGU>
    discrete = NaN ;
    h_1 = NaN ;
    h_2 = NaN ; 
    % Check input is a vector
    if( ~isvector(X) )
            % Crash
            error("In function Group1Exe1Fun1 input was not a vector");
    end

    % Make sure it is a row vector         
    if( ~iscolumn(X) )
            X = X';
    end

    %[C,ia,ic] = unique(X) ;

    [counts, groupnames] = groupcounts(X);

    if( length(groupnames) > 10  )
        % a
        figure('Name','Group1Exe1_histogram');
        hist = histogram(X,'BinMethod','sqrt');
        %hist.BinEdges;

        Emin  = 0 ;                
        % Normal
        [h_normal,p_normal,~] = chi2gof(X , 'Edges',hist.BinEdges ,'EMin',Emin )  ;                
        % Uniform
        [a,b] = unifit(X);
        [h_uniform, p_uniform ,~] = chi2gof(X, "CDF", {@unifcdf, a, b} ,'Edges',hist.BinEdges ,'EMin',Emin ) ;

        title_text = sprintf( "p-value for normal: %.3g p-value for uniform %.3g" , p_normal , p_uniform );
        title(title_text);
        
        p_1 = p_normal  ;
        p_2 = p_uniform ;
        
        discrete = false ;
        h_1 = h_normal ;
        h_2 = h_uniform ; 
                
    else
        % b

        figure('Name','Group1Exe1_bar_plot');

        bar(groupnames,counts);
        
        c = 1 ;
        K = length(counts) ;        
        dof = K - c ; 
        
        bound_for_statistic  = chi2inv( 0.95 , dof); 
        
        %x = chi2inv(0.95,10)
        %x = 18.3070
        %If you generate random numbers from this chi-square distribution, you would observe numbers greater than 18.3 only 5% of the time
        

        % Binomial 
        % Days in a year
        n = 365 ;  %#ok<NASGU>
        % Use the seemingly WRONG value for n 
        n = max(X);
        p = mean(X,'omitnan')/ n ;

        y = binopdf(0:n, n,p);

        X_squared_stat_binomial = sum( ((counts - length(X)* binopdf(groupnames, n,p) ).^2 ) ./ (length(X)* binopdf(groupnames, n,p) )  ) ;
        
       
        % h_binomial = 1 when we reject the hypothesys 
        h_binomial = X_squared_stat_binomial > bound_for_statistic ; 
        p_binomial = chi2cdf(X_squared_stat_binomial,dof,'upper');
        
        
        X_squared_stat_uniform = sum( ((counts - length(X) ./ length(counts)  ).^2 ) ./ ( length(X)  ./ length(counts)  )  ) ;
        

        % h_uniform = 1 when we reject the hypothesys 
        h_uniform = X_squared_stat_uniform > bound_for_statistic ; 
        p_uniform = chi2cdf(X_squared_stat_uniform,dof,'upper');
        

        title_text = sprintf( "p-value for Binomial %.3g p-value for Uniform %.3g" , p_binomial , p_uniform );
        title(title_text);
        
        p_1 = p_binomial ;
        p_2 = p_uniform  ;
        
        discrete = true ;
        h_1 = h_binomial ;
        h_2 = h_uniform ; 

    end
        
        
        
        
        
end

