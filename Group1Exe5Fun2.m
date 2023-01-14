function [ I_X_comma_Y  ] = Group1Exe5Fun2(X, Y)
%Group1Exe5Fun2 Returns the Mutual information of X,Y. The inputs must be already discrete 
    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    
    arguments
        % Make inputs a column vector
        X (:,1)	{mustBeNumeric}
        Y (:,1)	{mustBeNumeric} 
    end
    
    prob_X = groupcounts(X) / length(X)  ;
    % [1-sum(X)/length(X) sum(X)/length(X)]         
    H_X = - sum( prob_X.*log2( prob_X ) );
    
    prob_Y = groupcounts(Y) / length(Y)  ;
    % [1-sum(Y)/length(Y) sum(Y)/length(Y)]         
    H_Y = - sum( prob_Y.*log2( prob_Y ) );
    
    
    XY = [X Y];
 
    prob_XY = groupcounts(XY) / length(XY) ;
    % Since X and Y only have one or zero
    %XY = [2*X+Y]    
    %prob_XY = [ length(find(XY == 0)) length(find(XY == 1)) length(find(XY == 2))  length(find(XY == 3)) ] / length(XY) ;
            
    H_XY = - sum( prob_XY.*log2( prob_XY ) );
    
    I_X_comma_Y = H_X + H_Y - H_XY ;
    


end

