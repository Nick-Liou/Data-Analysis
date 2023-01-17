function [ best_formula,   lambda_values_best_regress  ] = Group1Exe10Fun2(X, Y , NamesX , NameY)

    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    arguments
        % Make inputs a column vector
        X (:,:)	{mustBeNumeric}
        Y (:,1)	{mustBeNumeric} 
        NamesX (:,1) cell 
        NameY (1,1) cell 
    end
    
     x_sizes = size(X) ;
    
    % Check inputs have the same size
    if( x_sizes(1) ~= length(Y) &&  x_sizes(2) ~= length(Y) )
        % Crash
        error("In function Group1Exe10Fun2 input vectors do not have the same length");
    end
    
    
    
    % Check inputs have the same size
    if( x_sizes(2) == length(Y) && x_sizes(1) ~= length(Y) )
        %flip the matrix
        X = X';
    end
    
    if ( length(NamesX) ~= size(X,2) )
        % Crash
        error("In function Group1Exe9Fun1 input names do not have the same length as [X Y]");
    end
    
    
    % Delete NaN    (This is also done inside the regress function )
    %mask = ~( isnan(X)| isnan(Y) ); % This does not work because X is a matrix
    mask = sum( ( isnan(X)| isnan(Y) )  ,2) == 0 ;
    
    X = X( mask , : ) ;
    Y = Y(mask) ;
    
    
    
    
    % Find max adj R^2  for each of them 
    % Keep the simplest model with the best adj R^2
    
    
    best_adj_R_squared  = 0  ; % This is for the model y = a ; 
    best_model_names	= { NameY };
    best_formula        = string(NameY) +" ~ 1";
    
    
    
    %independent_id_iter = setdiff(independent_id,dependent_id(dependent_index)) ;
    
%     
%     all_adj_R_squared       = zeros(1, 2^length(independent_id_iter) );
%     all_model_names         = cell(1, 2^length(independent_id_iter) ) ;
%     all_model_formulas      = cell(1, 2^length(independent_id_iter) ) ;
%     
%     
%     all_adj_R_squared(1,1)        = 0  ; % This is for the model y = a ; 
%     all_model_names(1,1)          = {Names{dependent_id(dependent_index(dependent_index)}} ;
%     all_model_formulas(1,1)       = string(Names{dependent_id(dependent_index)}) +" ~ 1";
%     
    
    
%     n_choose_k = arrayfun(@(row) nchoosek(length(independent_id_iter), row) , 0:length(independent_id_iter) ) ;
%     indexes = cumsum(n_choose_k) ;
%     


    number_of_independed = length(NamesX) ;
    for i = 1 : number_of_independed

        perm =  nchoosek(1:number_of_independed ,i) ;

        for j = 1: size( perm , 1 )  



            input_names = { NamesX{perm(j,:)}  char(NameY) };

            X_iter = X( :,perm(j,:) );
%             Y = Table.(dependent_id(dependent_index)) ;

            [  adj_R_squared_temp , formula ] = Group1Exe10Fun1(X_iter, Y , input_names);
            
%             temp = indexes(i)+j ;
%             all_adj_R_squared   (1,temp ) = adj_R_squared_temp ; 
%             all_model_names     (1,temp ) = input_names ;
%             all_model_formulas  (1,temp ) = formula ;

%             
            if ( adj_R_squared_temp > best_adj_R_squared ) 
                best_adj_R_squared = adj_R_squared_temp ;
                best_model_names = input_names ;
                best_formula = formula ;
            end
            
        end
        
%         if i == 2
%             warning("delete break");
%             break ;
%         end

    end
    

    
    [B,FitInfo] = lasso( X, Y ,'PredictorNames' ,NamesX,'NumLambda',100,'Options',statset('UseParallel',false) );    
    
    n = length(Y) ;
    adj_Rs_squared = 1 - (n-1)./(n- FitInfo.DF -1) .*  n.*FitInfo.MSE / sum( (Y - mean(Y) ).^2) ;

    
     [max_lasso_adjR , ind_best_lasso ] = max(adj_Rs_squared);
%     dof_lasso  = FitInfo.DF(ind_best_lasso);
%     coeff_lasso = B(:,ind_best_lasso);
    
    
    
    
    
    best_adj_R_squared;
    %best_model_names
    best_formula;
    
    
    % find which parameters the best extrensive regress uses
    strNames = string(NamesX); 

    temp = arrayfun( @(temp) eq(temp ,string(best_model_names)) ,  strNames ,  'UniformOutput' ,  false) ;

    mask = cellfun( @any , temp) ;
    %b_mask = mask(independent_id_iter);
    b_mask = mask;
    
    is_coeff_used_B = arrayfun(@any,B) ;     
    % sum(is_coeff_used_B==b_mask) == length(b_mask) ;    
    are_they_the_same_model = ismember(is_coeff_used_B' , b_mask', "Rows") ; 
    
    
    lambda_values_best_regress  = FitInfo.Lambda(are_they_the_same_model);
%     
%     indexes_same_model  = find(are_they_the_same_model) ;
%     lambda_values_best_regress  = FitInfo.Lambda(indexes_same_model);
    
%     if ( ~isempty(indexes_same_model) ) 
%         lambda_values_best_regress  = FitInfo.Lambda(indexes_same_model);
%     end
    
    
    
    
    % does_best_lasso_use_the_same_variables_as_best_regress =  any (any(B(:,ind_best_lasso),2) ~= b_mask ) ; 

    
    fprintf("Lasso adjR^2 %1.5g  Extensive adjR^2 %1.5g.\n", max_lasso_adjR, best_adj_R_squared   ) ;
 
    
    
    
end






