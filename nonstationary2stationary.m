%attempting to make data stationary
train = readtable('train.csv');
%close all
superBowl = [datenum('12-Feb-10');...
    datenum('11-Feb-11');...
    datenum('10-Feb-12');...
    datenum('8-Feb-13')];
laborDay = [datenum('10-Sep-10');...
    datenum('9-Sep-11'); ...
    datenum('7-Sep-12'); ...
    datenum('6-Sep-13')];
thanksgiving = [datenum('26-Nov-10'); ...
    datenum('25-Nov-11');...
    datenum('23-Nov-12'); ...
    datenum('29-Nov-13')];
christmas = [datenum('31-Dec-10');...
    datenum('30-Dec-11');...
    datenum('28-Dec-12'); ...
    datenum('27-Dec-13')];
easter = [(datenum('4-Apr-10'));...
    datenum('24-Apr-11');...
    datenum('8-Apr-12'); ...
    datenum('31-March-13')];
%First I will take a look at sales data from store 1, department 1
store = train.Store;
dept = train.Dept;
date = train.Date;
sales = train.Weekly_Sales;
dateDay = arrayfun(@datenum,train.Date);
s = 1
d = 1

ix = intersect(find(store == s), find(dept == d));

%timeseries(sales,dateDay(ix));
mySales  = sales(ix)
sales = sales(ix)
% figure
% plot(mySales)
% title(sprintf('pla in department %d store %d',d,s))
t =arrayfun(@datenum,date(ix));

%%
figure
for i=1:3
rectangle('Position',[ superBowl(i),min(mySales),7,...
    max(mySales)-min(mySales)],'FaceColor',[0 .5 .5 .5])
rectangle('Position',[ christmas(i),min(mySales),7,...
    max(mySales)-min(mySales)],'FaceColor',[.8 0 0 .5])
rectangle('Position',[ thanksgiving(i),min(mySales),7,....
    max(mySales)-min(mySales)],'FaceColor',[0.9100   ...
    0.4100    0.1700 .5])
rectangle('Position',[ laborDay(i),min(mySales),7,...
    max(mySales)-min(mySales)],'FaceColor',[ .1 .8 .2 .5])
rectangle('Position',[ easter(i),min(mySales),7....
    ,max(mySales)-min(mySales)],'FaceColor','m')

end
hold on 
plot(t,mySales,'LineWidth',3)

xlim([datenum(min(date(ix))) datenum(max(date(ix)))])
title(sprintf('department %d store %d',d,s))
dateFormat = 2;
set(gca,'Xtick',linspace(datenum(min(date(ix))), ...
    datenum(max(date(ix))),20), 'FontSize', 15)
datetick('x',dateFormat,'keeplimits', 'keepticks')

%%

[y,m,~] = ymd(train.Date(ix))
sales = sales(ix)
[trend, seasonal, error] = decompose(train.Date(ix),...
    date(ix),sales,y,m,true);%52 weeks in year

time =arrayfun(@weeknum,date(ix));

plot(time,sales,'bo')


dateNum = arrayfun(@datenum,date(ix));
figure
plot(dateNum,sales);
hold on 
plot(dateNum,seasonal)
hold on 
plot(dateNum,sales-seasonal)
legend('sales','seasonal','SA sales')

xlim([datenum(min(date(ix))) datenum(max(date(ix)))])
dateFormat = 2;
set(gca,'Xtick',linspace(datenum(min(date(ix))), ...
    datenum(max(date(ix))),20), 'FontSize', 15)
datetick('x',dateFormat,'keeplimits', 'keepticks')
title(' asd' ,'FontSize',22)



%% jus deseasonal 
deseasonal = sales - seasonal;
figure
subplot(2,1,1)
autocorr(deseasonal,142)%max lags?
subplot(2,1,2)
parcorr(deseasonal,142)
[pacf,lags,bounds] = parcorr(deseasonal,51)




figure
subplot(2,1,1)
autocorr(sales,142)%max lags?
subplot(2,1,2)
parcorr(sales,142)

%% differenced deseasonal 
salesm = movmean(sales,3)

D1 = LagOp({1,-1},'Lags',[0 1]);
Dy = filter(D1,deseasonal)
figure
plot(Dy)
[h,pValue,stat,cValue,reg] = adftest(Dy)
% interpreting correlogram
% https://www.youtube.com/watch?v=O6slZ5QLl8M
figure
subplot(2,1,1)
autocorr(Dy,52)%max lags?
subplot(2,1,2)
parcorr(Dy,52)

title('Non Stationary Sales Data - Store 1,  Dept 1')
D1 = LagOp({1,-1},'Lags',[0 1]);
D12 = LagOp({1,-1},'Lags',[0 52]);

Dy = filter(D1,deseasonal)
figure
plot(Dy)
title('D1 attempt Stationary Sales Data - Store 1,  Dept 1')

% augmented dickey fuller tells if you 
% data is stationary
adftest(Dy);% 0 = stationary, 1 = nonstationary

Dy = filter(D1*D12,sales)
figure
plot(Dy)
title('D1 attempt Stationary Sales Data - Store 1,  Dept 1')





%% experimenting in log of the data 
log_sales = log(sales)

%D1 = LagOp({1,-1},'Lags',[0 1]);
%D52 = LagOp({1,-1},'Lags',[0 52]);
%Dy = filter(D52,log_sales)
%figure
%plot(Dy)
[trend, seasonal, error] = decompose(train.Date(ix),date(ix)...
    ,log_sales,y,m,true);%52 weeks in year
log_sa = log_sales - seasonal;

figure
subplot(2,1,1)
plot(dateNum,log_sales,'LineWidth',2)
dateFormat = 2;
set(gca,'Xtick',linspace(datenum(min(date(ix))), ...
    datenum(max(date(ix))),20), 'FontSize', 15)
datetick('x',dateFormat,'keeplimits', 'keepticks')
title('log sales')
hold on 


for i=1:3
rectangle('Position',[ superBowl(i),min(log_sales),7,1],'FaceColor',...
    [0 .5 .5 .5])
rectangle('Position',[ christmas(i),min(log_sales),7,1],'FaceColor',...
    [.8 0 0 .5])
rectangle('Position',[ thanksgiving(i),min(log_sales),7,1],'FaceColor',...
    [0.9100    0.4100    0.1700 .5])
rectangle('Position',[ laborDay(i),min(log_sales),7,1],'FaceColor',...
    [ .1 .8 .2 .5])
rectangle('Position',[ easter(i),min(log_sales),7,1],'FaceColor','m')

end
xlim([datenum(min(date(ix))) datenum(max(date(ix)))])

subplot(2,1,2)
plot(dateNum,log_sa,'LineWidth',2)
title('SA log sales')
dateFormat = 2;
set(gca,'Xtick',linspace(datenum(min(date(ix))), ...
    datenum(max(date(ix))),20), 'FontSize', 15)
datetick('x',dateFormat,'keeplimits', 'keepticks')
hold on 


for i=1:3
rectangle('Position',[ superBowl(i),-.5,7,1],'FaceColor',[0 .5 .5 .5])
rectangle('Position',[ christmas(i),-.5,7,1],'FaceColor',[.8 0 0 .5])
rectangle('Position',[ thanksgiving(i),-.5,7,1],'FaceColor',[0.9100   ...
    0.4100    0.1700 .5])
rectangle('Position',[ laborDay(i),-.5,7,1],'FaceColor',[ .1 .8 .2 .5])
rectangle('Position',[ easter(i),-.5,7,1],'FaceColor','m')

end
xlim([datenum(min(date(ix))) datenum(max(date(ix)))])

figure
subplot(3,1,1)
plot(dateNum,log_sales,'r');
title 'log sales'
set(gca,'Xtick',linspace(datenum(min(date(ix))),...
    datenum(max(date(ix))),20), 'FontSize', 15)
datetick('x',dateFormat,'keeplimits', 'keepticks')
xlim([datenum(min(date(ix))) datenum(max(date(ix)))])

hold on 
subplot(3,1,2)
plot(dateNum,seasonal,'b')
title 'log seasonal'
set(gca,'Xtick',linspace(datenum(min(date(ix))), ...
    datenum(max(date(ix))),20), 'FontSize', 15)
datetick('x',dateFormat,'keeplimits', 'keepticks')
xlim([datenum(min(date(ix))) datenum(max(date(ix)))])
hold on 
subplot(3,1,3)
plot(dateNum,log_sales-seasonal,'g')

title 'log sa'

figure
subplot(3,1,1)
plot(log_sa)
subplot(3,1,2)
autocorr(log_sa,52)%max lags?
subplot(3,1,3)
parcorr(log_sa,52)




%%
x_train = sales(1:120)
x_holdout = sales(121:143)
figure
subplot(3,1,1)
plot(sales)
subplot(3,1,2)
autocorr(sales)%max lags?
subplot(3,1,3)
parcorr(sales)


%% diference
D1 = LagOp({1,-1},'Lags',[0 1]);
D12 = LagOp({1,-1},'Lags',[0 53]);

ix1 = 1:length(sales);
ix52 = ix1+53;
ix52(ix52>length(sales)) = ix52(ix52>length(sales)) - length(sales);

Dy = log((sales(ix52))) - log((sales(ix1)));




Dy = filter(D12,log(sales))
%figure
%plot(Dy)
figure
subplot(3,1,1)
plot(Dy)
subplot(3,1,2)
autocorr(Dy)%max lags?
subplot(3,1,3)
parcorr(Dy)

%%
LOGL = zeros (5,5)
PQ = zeros(5,5)
for p = 1:5
    for q = 1:5
     mod = arima(p,0,q);
     [fit,~,logL] = estimate(mod,Dy(1:120),'print',false);
     LOGL(p,q) = logL;
     PQ(p,q) = p+q;
        
    end
end


LOGL = reshape(LOGL,25,1);
PQ = reshape(PQ,25,1);
[~,bic] = aicbic(LOGL,PQ+1,100)
vals = reshape(bic,5,5)
ix = find(vals == min(min(vals)))
%%
figure
plot(x_train)
figure;plot(log(x_train))
x_train = sales(1:120)
x_holdout = sales(121:143)
Dy_train = Dy(1:120)
Dy_holdout = Dy(121:143)


mdl_sales = arima(2,0,1);
fit_sales = estimate(mdl_sales,Dy_train);
residuals = infer(fit_sales,Dy_train);
est_data = Dy_train - residuals;

[YF, YMSE] = forecast(fit_sales, 23,'Y0',Dy_train);


%[YF,YMSE] = forecast(fit_sales,50,'Y0',x_train);
figure
plot(Dy_train)
hold on 
plot(length(x_train):length(x_train)+22,Dy_holdout)
hold on
plot(length(x_train):length(x_train)+22,YF+ 1.96*sqrt(YMSE),'r:')
hold on
plot(length(x_train):length(x_train)+22,YF- 1.96*sqrt(YMSE),'r:')
hold on 
plot(length(x_train):length(x_train)+22,YF,'k')


y = forecast(fit_sales,20,'Y0',Dy_train)
figure
plot(x_train)
hold on
plot(length(x_train):length(x_train)+19,y)
hold on
plot(length(x_train):length(x_train)+22,x_holdout)
hold on
plot(length(x_train):length(x_train)+22,est_data)

model1 = armax(data, [na nc], 'IntegrateNoise',[false; true]);
% Forecast the time series 100 steps into future
residuals = infer(fit_sales,x_holdout);
hold on
plot(length(x_train):length(x_train)+22,x_holdout-residuals)

plot(data(1:100),yf)

yf = forecast(model1,data(1:100), 100);
plot(data(1:100),yf)

%%acf of residuals
residuals = readtable('residuals_store1_dept5.csv');
figure
subplot(2,1,1)
plot(residuals.Var2)
subplot(2,1,2)
autocorr(residuals.Var2)%max lags?





