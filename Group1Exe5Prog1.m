
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

fancy_scatter_plots = [ 6     8    15    17    19    20    21    23    26    30    33 ] ;

tic
for i = 1 : length(pairs) % length(fancy_scatter_plots) 
    
    %index_in_pairs = fancy_scatter_plots(i);
    index_in_pairs = i ; % delete this ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Access the element at the current index
    temp = pairs(index_in_pairs,:);
    index1 = temp(1);
    index2 = temp(2);
    name1 = Names{index1};
    name2 = Names{index2};
    
    
    % Do something with the pair    
    fprintf('\nCalculating for the Pair %s %s \n' , name1 , name2 );    
    
    X = V(:,index1) ; 
    Y = V(:,index2) ;
    
    %error("delete this");
    
%     X = (1:100)' ;
%     Y = X.^2;
    % Delete NaN
    mask = ~( isnan(X)| isnan(Y) );
    X = X(mask) ;
    Y = Y(mask) ;
    
    n = length(X) ;
    
    % find r
    r = corr(X,Y) ;
    t = r * sqrt((n-2)/(1-r^2)) ;
    dof = n - 2 ;
    p_pearson = 2 * tcdf(abs(t),dof,'upper');
    
    
    [ I_XY , p_mutual_information , ~  ] = Group1Exe5Fun1(X, Y);
    
    
    fprintf('Pearson corr value %5g p-value %5g \n', r , p_pearson);
    fprintf('Mutual Information %5g p-value %5g \n' , I_XY , p_mutual_information ); 

    
    
    %     figure;
%     plot(X,Y,"s");
    
%     text = sprintf( "Pair %s %s \n" , name1 , name2 );
%     title(text);


    %break
    
end
toc