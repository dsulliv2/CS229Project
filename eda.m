addpath('/Users/sullivan42/Documents/MATLAB/MMDS/cs229/project/data')
%% import data
%store, type, size
stores = readtable('stores.csv');
%store, dept, date,sales, IsHoliday
train = readtable('train.csv');
%
features = readtable('features.csv');
features.IsHoliday = [];
train = join(train,stores);
allData = join(train,features);
% Super Bowl: 12-Feb-10, 11-Feb-11, 10-Feb-12, 8-Feb-13
% Labor Day: 10-Sep-10, 9-Sep-11, 7-Sep-12, 6-Sep-13
% Thanksgiving: 26-Nov-10, 25-Nov-11, 23-Nov-12, 29-Nov-13
% Christmas: 31-Dec-10, 30-Dec-11, 28-Dec-12, 27-Dec-13
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
easter = [(datetime('9-Apr-2010'));...
    datetime('29-Apr-2011');...
    datetime('13-Apr-2012'); ...
    datetime('5-Apr-2013')];
easterDate = [(datenum('9-Apr-2010'));...
    datenum('29-Apr-2011');...
    datenum('13-Apr-2012'); ...
    datenum('5-Apr-2013')];

%% 
%DateNumber = datenum(DateString);
storeNum = length(unique(train.Store));
sales = train.Weekly_Sales;
storeLabel = train.Store;
date = train.Date;
dateDay = arrayfun(@datenum,date);%number of days from January 0, 0000

%%plot sales by store color
labeledPlot(date,sales,storeLabel)
xlim([min(date) max(date)])
ylim([min(sales)-100 max(sales)+100] )
dateFormat = 2;
set(gca,'Xtick',linspace(min(date),max(date),5), 'FontSize', 20)
set(gca,'Ytick',linspace(min(sales),max(sales),10), 'FontSize', 15)

datetick('x',dateFormat,'keeplimits', 'keepticks')
title('Weekly Sales By Store' ,'FontSize',22)


%% combine data based on day
sizes = cell2mat(train.Type);
cats = double(cell2mat(train.Type));
classes = unique(cats);
dateSales = [dateDay, sales,train.Size];
[sizes, ix] = sort(train.Size);
dateSales = [sizes, sales(ix)];
x1 = dateSales(1:length(dateSales)/3, 2);
x2 = dateSales(floor(length(dateSales)/3):ceil(2*length(dateSales)/3),2);
x3 = dateSales(ceil(2*length(dateSales)/3):length(dateSales),2);
figure
h2 = boxplot([x1(1:140523)';x2(1:140523)';x3(1:140523)']','Notch','on',...
    'Labels',{'Store Size < 114533','Store Size < 196321','Store Size < 219622'},'Whisker',2)
xlabel('Store Square Footage')
ylabel('Weekly Sales')
set(gca, 'FontSize', 20)
set(h2,{'linew'},{2})
h=findobj(gca,'tag','Outliers'); 
title('Sales Statistics Binned by Store Size' ,'FontSize',22)
delete(h) 



idx = [length(classes)/3,2*length(classes)/3,3]
figure
for i = 1:length(classes)
    figure
    hold on 
   x = sales(cats==classes(i)); 
   boxplot(x)
end
dateSales = [dateDay, sales];


%[dateSales] = sortrows(dateSales,1,'descend');
%meanDailySales = accumarray(1, dateSales, [], @mean)

[uDays, ~, daysIdx] = unique( dateSales(:,1) );
meanSales = [uDays(:), accumarray( daysIdx, dateSales(:,2), [], @mean ) ];
figure
hold on 
for i=1:2
rectangle('Position',[ superBowl(i),10000,7,max(meanSales(:,2))-9000],'FaceColor',[0 .5 .5 .5])
rectangle('Position',[ christmas(i),10000,7,max(meanSales(:,2))-9000],'FaceColor',[.8 0 0 .5])
rectangle('Position',[ thanksgiving(i),10000,7,max(meanSales(:,2))-9000],'FaceColor',[0.9100    0.4100    0.1700 .5])
rectangle('Position',[ laborDay(i),10000,7,max(meanSales(:,2))-9000],'FaceColor',[ .1 .8 .2 .5])
end
hold on
title('Mean Weekly Sales' ,'FontSize',22)
plot(meanSales(:,1),meanSales(:,2),'linewidth',5);
xlim([min(meanSales(:,1)) max(meanSales(:,1))])
ylim([min(meanSales(:,2))-100 max(meanSales(:,2))+100])
hold on 

set(gca,'Xtick',linspace(meanSales(1,1),meanSales(end,1),5))
dateFormat = 2;
datetick('x',dateFormat,'keeplimits', 'keepticks')
set(gca, 'FontSize', 20)

figure
plot(auto_corr(meanSales(:,2)),'linewidth',5);
title('Autocorrelation of Mean Weekly Sales' ,'FontSize',22)
xlabel('Time Shift Number of Weeks')
ylabel('Autocorrelation Result')
set(gca, 'FontSize', 20)
figure
%%color holiday periods
%Variance of 
%% break down sales by department 
deptNum = unique(train.Dept); %they skip some numbers when counting dept #
deptLabel = train.Dept;
labeledPlot(date,sales,deptLabel)
xlim([min(date) max(date)])
ylim([min(sales)-100 max(sales)+100] )
dateFormat = 2;
set(gca,'Xtick',linspace(min(date),max(date),5), 'FontSize', 20)
set(gca,'Ytick',linspace(min(sales),max(sales),10), 'FontSize', 20)

datetick('x',dateFormat,'keeplimits', 'keepticks')
title('Weekly Sales Grouped by Department' ,'FontSize',22)
%% which features have a correlation with sales?
dateDayT = cell2table(arrayfun(@datestr,meanSales(:,1),'UniformOutput' ,false));%number of days from January 0, 0000
dateDayT.Properties.VariableNames = {'Date'};

dateDay = arrayfun(@datenum,features.Date);%number of days from January 0, 0000
dateDayT = array2table(dateDay);
dateDayT.Properties.VariableNames = {'DateNum'};
features = [features,dateDayT];
meanSalesT = array2table(meanSales,...
    'VariableNames',{'DateNum','meanSales'});
%csv created from sql tables generated from importing orginal data 
sqlData = readtable('test_sql.csv');


rFuel = corrcoef(sqlData.Fuel_Price,sqlData.sum_Weekly_Sales_) %returns coefficients between two random variables A and B.
rTemp = corrcoef(sqlData.Temperature,sqlData.sum_Weekly_Sales_)
rCPI = corrcoef(sqlData.CPI,sqlData.sum_Weekly_Sales_)

%% check for linear trends
plot(detrend(meanSales))

