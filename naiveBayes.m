%train =readtable('train_w_store.csv');
nBins = 5;
sales = train.Weekly_Sales;
nTrain = length(sales);
min_sales = min(sales);
max_sales = max(sales);
sortedSales = sort(sales);
idx = floor(nTrain/nBins):floor(nTrain/nBins):nTrain;
sales_bins = sortedSales(idx); 
classes = [];
for i = 1:length(sales)
    this_sale = sales(i);
    this_class = -1;
    for j = 1:length(sales_bins)
       if( this_sale <=sales_bins(j) ) 
           this_class = j;
           break;
       end
    end
    classes = [classes;this_class];
end 
dateWeek = array2table(arrayfun(@week,train.Date));
classT = array2table(classes);
trainClass = [train,classT,dateWeek];
cpi = cellfun(@str2num,allData.CPI);
unemp = cellfun(@str2num,allData.CPI);

meas = [allData.Size';allData.IsHoliday';allData.Fuel_Price';cpi';unemp']';
%train.Dept'
%measT = array2table(meas,...
%    'VariableNames',{'StoreSize','Dept','IsHoliday'});
%% isholiday, store size, department 
% make a classifier for is is not holiday, per department
% meas = []
O1 = fitcnb(meas(1:300000,:),classes(1:300000));%, 'Distribution', 'mn');
C1 = O1.predict(meas(300000:end,:));
cMat1 = confusionmat(classes(300000:end),C1) 
%cMat1 = cMat1*(1/nTrain);
figure
imshow(cMat1, [],'InitialMagnification', 1600,'Colormap',jet(255));
colorbar;
axis on;
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

%% knn

%train =readtable('train_w_store.csv');
nBins = 5;
sales = train.Weekly_Sales;
nTrain = length(sales);
min_sales = min(sales);
max_sales = max(sales);
sales_bins = min_sales+(max_sales-min_sales)/nBins: (max_sales-min_sales)/nBins : max_sales; 
classes = [];
for i = 1:length(sales)
    this_sale = sales(i);
    this_class = -1;
    for j = 1:length(sales_bins)
       if( this_sale <=sales_bins(j) ) 
           this_class = j;
           break;
       end
    end
    classes = [classes;this_class];
end 

mdl = fitcknn(meas(1:5000,:),classes(1:5000),'NumNeighbors',nBins,'Standardize',1)
C1 = mdl.predict( meas(5001:10000,:) );
cMat1 = confusionmat(classes(5001:10000),C1) 



