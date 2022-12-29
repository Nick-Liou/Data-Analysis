function [p_normal , p_uniform] = Group1Exe1Fun1( X )

        % Liouliakis Nikolaos  AEM: 10058
        % Panagiotis Syskakis  AEM: 10045
        

        p_normal = -1 ;
        p_uniform = -1 ;
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
        
        [counts, groupnames] = groupcounts(X)
        
        if( length(groupnames) > 10  )
                %% a
                figure('Name','Group1Exe1_histogram');
                hist = histogram(X,'BinMethod','sqrt');
                %hist.BinEdges;
                
                Emin  = 0 ;                
                % Normal
                [~,p_normal,~] = chi2gof(X , 'Edges',hist.BinEdges ,'EMin',Emin )  ;                
                % Uniform
                [a,b] = unifit(X);
                [~, p_uniform ,~] = chi2gof(X, "CDF", {@unifcdf, a, b} ,'Edges',hist.BinEdges ,'EMin',Emin ) ;
                
                title_text = sprintf( "p-value for normal: %.3g p-value for uniform %.3g" , p_normal , p_uniform );
                title(title_text);
                
                
                
        else
                %% b
                
                figure('Name','Group1Exe1_bar_plot');
                
                bar(groupnames,counts);
                disp("lower than 10");
                
                % Binomial 
                % Days in a year
                n = 365 ; 
                p = mean(X,'omitnan')/ n ;
           
                y = binopdf(0:n, n,p);
                
%                 figure
%                 plot(0:n, y)
%                 disp("Polt");
                
                
                % Uniform
                %[a,b] = unifit(X);
                a = 0 ; 
                b = 365 ;
                [h, p_uniform ,stat] = chi2gof(X, "CDF", {@unifcdf, a, b} ,'NBins' , length(groupnames)  ,'EMin',0 ) 
                %[h, p_uniform ,stat] = chi2gof(X, "CDF", {@unifcdf, a, b} ,'EMin',0 ) 

                
                title_text = sprintf( "p-value for ~~~~~~~: %.3g p-value for ~~~~~~~ %.3g" , p_normal , p_uniform );
                title(title_text);
                
        end
        
        
        
        
        
end

