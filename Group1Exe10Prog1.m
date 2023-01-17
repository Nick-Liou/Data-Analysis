
% Liouliakis Nikolaos  AEM: 10058
% Panagiotis Syskakis  AEM: 10045

clear;
close all; 

file = "Heathrow.xlsx";

% Make sure the file exists
if  exist( file , 'file') ~= 2        
        fprintf('\nThe file named : %s does not exist in the current directory' , file);
        fprintf('\nThe current directory is named : %s \n' , pwd);
        return        
end


Table = readtable(file);
Names = Table.Properties.VariableNames ;
fprintf('Loaded the file named : %s \n' , file);    



independent_id = (2:9);

dependent_id = [10 12 ] ;



for dependent_index = 1 : length(dependent_id)
    
    
    fprintf('\n');    
    independent_id_iter = setdiff(independent_id,dependent_id(dependent_index)) ;
    
    NamesX = {Names{ independent_id_iter}} ; 
    NameY = {Names{ dependent_id(dependent_index)}} ; 

    X = Table{:, independent_id_iter }    ;
    Y = Table.(dependent_id(dependent_index)) ;
    
    [ best_model ,   lambda_values_best_regress  ] = Group1Exe10Fun2(X, Y , NamesX , NameY);
    
    fprintf("Best model %s \nLabda values with the same model:\n",best_model ) ;
    disp(lambda_values_best_regress);
    
end


fprintf('\n');  

% Lasso always has worse adj R^2 compaired to the extensive regress 
% Lasso does not succeed in finding the best model in every case.

% Lasso succceeds for   Lamda values printed in the command window

























    
% for dependent_index = 1 : length(dependent_id)
% 
%    
%     % Find max adj R^2  for each of them 
%     % Keep the simplest model with the best adj R^2
%     
%     
%     best_adj_R_squared  = 0  ; % This is for the model y = a ; 
%     best_model_names	= { Names{dependent_id(dependent_index)}};
%     best_formula        = string(Names{dependent_id(dependent_index)}) +" ~ 1";
%     
%     
%     
%     independent_id_iter = setdiff(independent_id,dependent_id(dependent_index)) ;
%     
% %     
% %     all_adj_R_squared       = zeros(1, 2^length(independent_id_iter) );
% %     all_model_names         = cell(1, 2^length(independent_id_iter) ) ;
% %     all_model_formulas      = cell(1, 2^length(independent_id_iter) ) ;
% %     
% %     
% %     all_adj_R_squared(1,1)        = 0  ; % This is for the model y = a ; 
% %     all_model_names(1,1)          = {Names{dependent_id(dependent_index(dependent_index)}} ;
% %     all_model_formulas(1,1)       = string(Names{dependent_id(dependent_index)}) +" ~ 1";
% %     
%     
%     
% %     n_choose_k = arrayfun(@(row) nchoosek(length(independent_id_iter), row) , 0:length(independent_id_iter) ) ;
% %     indexes = cumsum(n_choose_k) ;
% %     
%     for i = 1 : length(independent_id)
% 
%         perm =  nchoosek(independent_id_iter,i) ;
% 
%         for j = 1: size( perm , 1 )  
% 
% 
% 
%             input_names = { Names{perm(j,:)}  Names{dependent_id(dependent_index)}};
% 
%             X = Table{:,perm(j,:)}    ;
%             Y = Table.(dependent_id(dependent_index)) ;
% 
%             [  adj_R_squared_temp , formula ] = Group1Exe10Fun1(X, Y , input_names);
%             
% %             temp = indexes(i)+j ;
% %             all_adj_R_squared   (1,temp ) = adj_R_squared_temp ; 
% %             all_model_names     (1,temp ) = input_names ;
% %             all_model_formulas  (1,temp ) = formula ;
% %             
%             if ( adj_R_squared_temp > best_adj_R_squared ) 
%                 best_adj_R_squared = adj_R_squared_temp ;
%                 best_model_names = input_names ;
%                 best_formula = formula ;
%             end
%             
%         end
%         
% %         if i == 2
% %             warning("delete break");
% %             break ;
% %         end
% 
%     end
%     
% 
%     X = Table{:,independent_id_iter}    ;
%     Y = Table.(dependent_id(dependent_index)) ;
%     input_names = { Names{independent_id_iter}  Names{dependent_id(dependent_index)}};
%     mask = sum( ( isnan(X)| isnan(Y) )  ,2) == 0 ;    
%     X = X( mask , : ) ;
%     Y = Y(mask) ;    
%     n = length(Y) ;
%     
%     [B,FitInfo] = lasso( X, Y ,'PredictorNames' ,input_names(1:end-1),'NumLambda',100,'Options',statset('UseParallel',false) );
%     
%     
%     adj_Rs_squerd = 1 - (n-1)./(n- FitInfo.DF -1) .*  n.*FitInfo.MSE / sum( (Y - mean(Y) ).^2) ;
%     
%     [max_lasso_adjR , ind_best_lasso ] = max(adj_Rs_squerd);
%     dof_lasso  = FitInfo.DF(ind_best_lasso);
%     coeff_lasso = B(:,ind_best_lasso);
%     
%     best_adj_R_squared;
%     %best_model_names
%     best_formula;
%     
%     
%     strNames = string(Names); 
% 
%     temp = arrayfun( @(temp) eq(temp ,string(best_model_names)) ,  strNames ,  'UniformOutput' ,  false) ;
% 
%     mask = cellfun( @any , temp) ;
%     b_mask = mask(independent_id_iter);
%     b_mask = b_mask';
%     
%     is_coeff_used_B = arrayfun(@any,B) ; 
%     
%     % sum(is_coeff_used_B==b_mask) == length(b_mask) ;
%     
%     are_they_the_same_model = ismember(is_coeff_used_B' , b_mask', "Rows") ; 
%     
%     
%     indexes_same_model  = find(are_they_the_same_model) 
%     if ( ~isempty(indexes_same_model) ) 
%         FitInfo.Lambda(indexes_same_model)
%     end
%     
%     
%     
%     
%     does_lasso_use_the_same_variables_as_best_regress =  any (any(B(:,ind_best_lasso),2) ~= b_mask )
% 
%     
%     fprintf("Lasso adjR^2 %1.5g  Extensive adjR^2 %1.5g  is lasso it better %d Best model %s  \n", max_lasso_adjR, best_adj_R_squared , max_lasso_adjR>best_adj_R_squared ,  best_formula ) ;
% %     lassoPlot(B,FitInfo) ;
% %     warning("delete break");
% %     break
%     
% end






