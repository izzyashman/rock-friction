function [data,x] = pf_correct(data,x,step,time_dep,offset)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%split x and data into before (a,c) and after (b,d) the preceding velocity step
a = x(1:step,:);
b = x(step + time_dep:end,:);
c = data(1:step,:);
d = data(step + time_dep:end,:);

%remove dilation (-) or compaction (+) 
d = [d(:,1),(d(:,2)-offset)];

%recombine the dataset
x = cat(1,a,b);
data = cat(1,c,d);
end

