function [h, p_value, ci] = Group1Exe3Fun2( boostrap_values , alpha , test_value )
%Group1Exe3Fun2 [h, p_value, ci] = Group1Exe3Fun2( boostrap_values , alpha , test_value )
% Test the null hypothesis that the test_value comes from the same distrobution as boostrap_values.
% If h = 1, this indicates the rejection of the null hypothesis at the Alpha significance level.
% If h = 0, this indicates a failure to reject the null hypothesis at the Alpha significance level.
% Returns the p-value for the boostrap values (for test_value to be inside)
% Returns the confidence interval for the mean of the boostrap values 
    % By:
    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    arguments
        boostrap_values (1,:)   {mustBeNumeric}
        alpha           (1,1)	{mustBeNumeric,mustBeGreaterThan(alpha,0),mustBeLessThan(alpha,1)} = 0.05
        test_value      (1,1)   {mustBeNumeric}     = 0 
    end
    
    
    B = length(boostrap_values);
    % How small alpha/2 can be to include zero in the ci of stats    
    min_alpha_half = min( sum(boostrap_values<test_value) ,  sum(boostrap_values>test_value) ) ;
    % make sure to take care the case there are zeros in stat (tho very inprobable)    
    zeros_in_boostrap_values = sum(boostrap_values==test_value);
    min_alpha_half = min( min_alpha_half + zeros_in_boostrap_values/2 , B/2) ;
    % Find the p value
    p_value = min_alpha_half * 2 / B;
    
    ci = prctile(boostrap_values,100*sort([alpha/2 1-alpha/2]));
    
    
    h = ci(1) > test_value || ci(2) < test_value ;
    
    
    
end

