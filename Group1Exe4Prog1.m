
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





V = Table.Variables ;
% n choose k all combinations 
pairs = nchoosek(2:10, 2);

a = 0.05 ;
are_they_correlated = NaN(length(pairs) , 6) ;

tic
for i = 1 : length(pairs) 
    
    % Access the element at the current index
    temp = pairs(i,:);
    index1 = temp(1);
    index2 = temp(2);
    name1 = Names{index1};
    name2 = Names{index2};
    
    
    % Do something with the pair    
    fprintf('Calculating for the Pair %s %s \n' , name1 , name2 );    
    
    X = V(:,index1) ; 
    Y = V(:,index2) ;
    
    
    [ci_1, p_1, ci_2, p_2 , n] = Group1Exe4Fun1(X,Y);
    
    
    % p > a     =>  r == 0 => oxi sysxetisi 
    % 0 in ci   =>  r == 0 => oxi sysxetisi 

    t1 = 0 < ci_1(1) || ci_1(2) < 0 ;
    t2 = p_1 < a ;
    t3 = 0 < ci_2(1) || ci_2(2) < 0 ;
    t4 = p_2 < a ;
    
    
    are_they_correlated( i , :) = [t1 t2 t3 t4 p_1 p_2]' ;
    
    
    
    
end
toc

result =  [pairs  are_they_correlated];

% Do the 4 differend ways agree ? 

% Most of the times yes, but not always. (what about the last one ????????????????????????????????????)

% This is usefull to see that more easily 
% sum(are_they_correlated(:,1:4)')



% 3 Pairs most significant correlation for p_1 and p_2



k = 3 ; 
% We find the indexes for the k smaller p_values 
[~,indexes_mink_p1] = mink(result(:,7),k);
[~,indexes_mink_p2] = mink(result(:,8),k);


result(indexes_mink_p1,:);
result(indexes_mink_p2,:);


fprintf('\nThe below are the %d pairs with the lower p-values (which means most significant correlation). \n' , k );  

fprintf('\nParametric \n' );  
for i=1:k 
    index1 = result(indexes_mink_p1(i),1);
    index2 = result(indexes_mink_p1(i),2);
    name1 = Names{index1};
    name2 = Names{index2};
    
    % Do something with the pair    
    fprintf('Pair %s\t %s\t has a p-value of : %5g \n' , name1 , name2 , result(indexes_mink_p1(i),7) );  
   
end

fprintf('\nRandom permutation or randomization test \n' );  
   
for i=1:k 
    index1 = result(indexes_mink_p2(i),1);
    index2 = result(indexes_mink_p2(i),2);
    name1 = Names{index1};
    name2 = Names{index2};    
    % Do something with the pair    
    fprintf('Pair %s\t %s\t has a p-value of : %5g \n' , name1 , name2 , result(indexes_mink_p1(i),8) );  
   
end


% Do the Random permutation or randomization test agree ? 

% NO ? ??? ???????????????????????????????????









