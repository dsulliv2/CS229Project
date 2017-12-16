%% pick departments

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
for s=( 1:1)
    figure
    for d = (31:40)

ix = intersect(find(store == s), find(dept == d));
if(ix>0)
%timeseries(sales,dateDay(ix));
mySales  = sales(ix)
% figure
% plot(mySales)
% title(sprintf('pla in department %d store %d',d,s))
t =arrayfun(@datenum,date(ix));

%%
subplot(10,1,d-30)

for i=1:3
rectangle('Position',[ superBowl(i),min(mySales),7,max(mySales)-min(mySales)],'FaceColor',[0 .5 .5 .5])
rectangle('Position',[ christmas(i),min(mySales),7,max(mySales)-min(mySales)],'FaceColor',[.8 0 0 .5])
rectangle('Position',[ thanksgiving(i),min(mySales),7,max(mySales)-min(mySales)],'FaceColor',[0.9100    0.4100    0.1700 .5])
rectangle('Position',[ laborDay(i),min(mySales),7,max(mySales)-min(mySales)],'FaceColor',[ .1 .8 .2 .5])
rectangle('Position',[ easter(i),min(mySales),7,max(mySales)-min(mySales)],'FaceColor','m')

end
hold on 
plot(t,mySales,'LineWidth',3)

xlim([datenum(min(date(ix))) datenum(max(date(ix)))])
title(sprintf('department %d store %d',d,s))
dateFormat = 2;
set(gca,'Xtick',linspace(datenum(min(date(ix))), datenum(max(date(ix))),20), 'FontSize', 15)
datetick('x',dateFormat,'keeplimits', 'keepticks')
end
    end
end