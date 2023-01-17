function [h, p_value, ci] = Group1Exe3Fun2( boostrap_values , test_value , options )
%Group1Exe3Fun2 [h, p_value, ci] = Group1Exe3Fun2( boostrap_values , test_value , options )
% Test the null hypothesis that the test_value comes from the same distrobution as boostrap_values.
% If h = 1, this indicates the rejection of the null hypothesis at the Alpha significance level.
% If h = 0, this indicates a failure to reject the null hypothesis at the Alpha significance level.
% Returns the p-value for the boostrap values (for test_value to be inside)
% Returns the confidence interval for the mean of the boostrap values 
% options:
%   "Alpha" , 0.05
%   "Tail" , "both"           valailable ["both","right","left",]
    % By:
    % Liouliakis Nikolaos  AEM: 10058
    % Panagiotis Syskakis  AEM: 10045

    arguments
        boostrap_values (1,:)           {mustBeNumeric}        
        test_value      (1,1)           {mustBeNumeric} = 0 
        options.Alpha  	(1,1)   double  {mustBeNumeric,mustBeGreaterThan(options.Alpha,0),mustBeLessThan(options.Alpha,1)} = 0.05
        options.Tail    (1,1)   string  {mustBeMember(options.Tail,["both","right","left",])} = "both" 
        
%         two_sided       (1,1)   logical = true
%         tail            (1,1)   logical = true % true => right , false => right
    end
    
    alpha = options.Alpha ;
    
    B = length(boostrap_values);
    
    if ( options.Tail == "both" )
        % disp("two");
        % How small alpha/2 can be to include zero in the ci of stats    
        min_alpha_half = min( sum(boostrap_values<test_value) ,  sum(boostrap_values>test_value) ) ;
        % make sure to take care the case there are test_value in stat (tho very inprobable)    
        test_val_offset = randi( sum(boostrap_values==test_value) + 1) - 1;
        min_alpha_half = min( min_alpha_half + test_val_offset , B/2) ;
        % Find the p value
        p_value = min_alpha_half * 2 / B;

        ci = prctile(boostrap_values,100*sort([alpha/2 1-alpha/2]));

        h = ci(1) > test_value || ci(2) < test_value ;
    else
        
        if  ( options.Tail == "right" )
            % disp("right");
            c =  sum(boostrap_values>test_value) + randi(sum(boostrap_values==test_value)+1)-1 ;
            p_value = c / B ; 
            ci = prctile(boostrap_values,100*[0 1-alpha]);
            h = ci(1) > test_value || ci(2) < test_value ;
        elseif  ( options.Tail == "left" )
            % left tail 
            % disp("left");
            c =  sum(boostrap_values<test_value) + randi(sum(boostrap_values==test_value)+1)-1 ;
            p_value = c / B ; 
            ci = prctile(boostrap_values,100*[alpha 1]);
            h = ci(1) > test_value || ci(2) < test_value ;
                
        end
        
        
        
    end
    
    
end

