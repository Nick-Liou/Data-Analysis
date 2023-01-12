function [ci1, ci2] = Group1Exe2Fun1(X)

    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    % Parametric
    [~,~,ci1] = ttest(X, mean(X));
    % Bootstrap 
    ci2 = bootci(1000, @(x)mean(x), X);

end

