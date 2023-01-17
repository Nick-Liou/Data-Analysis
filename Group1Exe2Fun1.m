function [ci1, ci2] = Group1Exe2Fun1(X)

    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045
    
    arguments
       X (:,1) {mustBeNumeric} 
    end

    % Parametric
    [~,~,ci1] = ttest(X, mean(X));
    % Bootstrap 
    ci2 = bootci(1000,{@mean, X},   'Options', statset('UseParallel',true)  );

end

