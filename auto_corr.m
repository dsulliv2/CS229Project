function [ SUMS ] = auto_corr(h0)
time_length = length(h0)
h_0 = h0;
%create summs vector for each binary combo
for t = 0:time_length;
    %phaseshifted h0 by t
    h_0 = circshift(h0, [t 0 ]);
    
    %to make -1 and 1
    %h_0 = h_0.*2;
    %neg1 = -1*ones( length( h_0 ),1);
    %h_0 = h_0 + neg1;
    
    %sum of result from multiplication
    %of orignal sequence and shifted version
    SUMS(1, t+1) = sum(h0.*h_0);
end


% %mins and maxes of each autocorr for each bit-sequence
% max_sums = max(SUMS);
% min_sums = min(SUMS);
% %maxes(bin_combo+1) = max_sums;
% %mins(bin_combo+1) = min_sums;
% 
% for time = 1:time_length
%     %if the auto-correlation is not 2-valued, do not save result
%     if min_sums &lt; SUMS(time) &amp;&amp; SUMS(time) &lt; max_sums
%         break
%     elseif mod((time-1),spf) ~= 0 &amp;&amp; SUMS(time)== max_sums
%         break
%     end
% end
% 
% if time == time_length
%     PRBS = 1;
% else
%     PRBS = 0;
% end