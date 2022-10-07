%Create file for dilatancy processing
% DRF 26/9/19 
% Edited by IRA 2/10/19
% Edited by IRA and LOB 17/3/20
% Values step and time_dep come from selecting data points in pf_select code

clear all
file = dlmread('filename','\t',3,0);
[displ,pf] = pf_func(file,3.49); %substitute finish (2nd value) for cut off displ value e.g. step 1: 2.49, step 2: 2.99

%data
data = pf; %Vol data
x = displ;    %Displ data

%make a 2 column matrix
data = [x,data];

%processing out the preceding velocity steps from the fitting curve using function pf_correct(data,x,step,time_dep,offset)
[data,x] = pf_correct(data,x,49666,300,0.75); %step 1, substitute step, time_dep and offset
[data,x] = pf_correct(data,x,51017,3000,-0.7); %step2
%[data,x] = pf_correct(data,x,46122,300,2.25); %step3
%[data,x] = pf_correct(data,x,47021,3000,-0.1); %step4
%[data,x] = pf_correct(data,x,56061,300,0.8); %step5
%[data,x] = pf_correct(data,x,56970,3000,0); %step6
%[data,x] = pf_correct(data,x,93837,340,0.95); %step7
%[data,x] = pf_correct(data,x,95181,3200,-0.15); %step8
%[data,x] = pf_correct(data,x,108564,340,0.3); %step9
%[data,x] = pf_correct(data,x,109912,3200,-0.65); %step10
%[data,x] = pf_correct(data,x,124591,340,0.6); %step11
%[data,x] = pf_correct(data,x,125926,3200,-0.3); %step12

%set datapoint at which target velocity step occurs (- ignored data points)
vel_step = 64618;

%split data into before (y) and after (z) vel_step
%NB time_dep = number of datapoints after the vel step to ignore - i.e. where
%there is transient behaviour still occurring
time_dep = 300;

y = data(1:vel_step,:); %matrix before velocity step
z = data(vel_step + time_dep:end,:); %matrix after velocity step and transient

%combine the two parts of the dataset ready for curve fitting
yz = cat(1,y,z); %vertical cat

%split into dependent and independent variables
ind_var = yz(:,1); %displ
dep_var = yz(:,2); %pf vol

%fit a polynomial curve to the data and output the Rsquared value
mdl = fitlm(ind_var,dep_var,'poly8');
r2 = mdl.Rsquared.Ordinary;

%plot data
figure
subplot(2,1,1), plot(ind_var,dep_var,'bo')
axis([2,3.5,-90,-65])
hold on
plot(mdl)


%shift the second half of the data up or down and see if this produces a
%better r2 value
r2_new = r2;
iteration = 0;
step = 0.05; %amount the data is shifted by, adjust +/- for up/down steps

while r2_new >= r2
    iteration = iteration + 1;
    r2 = r2_new;
    z = [z(:,1),(z(:,2)-step)];
    yz = cat(1,y,z);
    ind_var = yz(:,1);
    dep_var = yz(:,2);
    mdl = fitlm(ind_var,dep_var,'poly8');
    r2_new = mdl.Rsquared.Ordinary;
end

%since the loop goes one iteration past the optimum r2 value, then
%recalculate the set of values with the best r2 value
z = [z(:,1),(z(:,2)+step)];
yz = cat(1,y,z);
ind_var = yz(:,1);
dep_var = yz(:,2);

total_offset = (iteration - 1) * step;

%check the output looks sensible
subplot(2,1,2), plot(ind_var,dep_var,'bo')
axis([2,3.5,-90,-65]);
hold on
plot(mdl)

