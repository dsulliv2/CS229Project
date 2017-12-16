%CS229 Final Project
%Walmart Sales Forecasting

%Load basic data for stores and training
%Store department, store size, dates, holidays, weekly sales
[stores, train, test] = load_data();
week_train = array2table(arrayfun(@week,train.Date));
week_test = array2table(arrayfun(@week, test.Date));
train = join(train,stores);
test = join(test,stores);

%% Gather Hold-out Data for Local Testing
total_train_samples = height(train);
num_ho_samples = 3e4;
num_train_samples = total_train_samples - num_ho_samples;

hold_out = train(total_train_samples - num_ho_samples:end, :);
train_in = train(1:total_train_samples - num_ho_samples, :);

week_train_in = array2table(arrayfun(@week,train_in.Date));
week_ho = array2table(arrayfun(@week,hold_out.Date));

%% Create table for trees

% store_sz = zeros(length(train), 2);
% store_sz = train.Store;

%train with the whole training set
y_tree = double(train.Weekly_Sales);
tree_tbl = table(week_train.Var1, train.Dept, train.IsHoliday, train.Size);
vd_tbl = table(week_ho.Var1, hold_out.Dept, hold_out.IsHoliday, hold_out.Size);

%% Baseline Method: Decision Tree
%train with a hold_out set
% y_tree = double(train_in.Weekly_Sales);
% tree_tbl = table(week_train_in.Var1, train_in.Dept, train_in.IsHoliday, train_in.Size);

tree = fitrtree(tree_tbl, y_tree);

quick_test_tbl = table(week_test.Var1, test.Dept, test.IsHoliday, test.Size);
quick_test_out = predict(tree, quick_test_tbl);


vd_test_out = predict(tree, vd_tbl);


%% Baseline Method: Bag of Trees
treebag = TreeBagger(20,tree_tbl,y_tree,'Method','regression');
vd_test_bag_out = predict(treebag, vd_tbl);

%% Calculate the mean absolute error for the hold out set
y_hold_out = double(hold_out.Weekly_Sales);
MAE_tree = sum(abs(y_hold_out - vd_test_out))/num_ho_samples;
MAE_treebag = sum(abs(y_hold_out - vd_test_bag_out))/num_ho_samples;

bag_test_out = predict(treebag, quick_test_tbl);

%% Plot predicted versus ground-truth
plot(linspace(1,30001, 30001), y_hold_out)
hold on
plot(linspace(1,30001, 30001), vd_test_out)
hold on
legend('Ground-truth', 'Predicted')
% plot(linspace(1,30001, 30001), vd_test_bag_out)
% legend('hold-out ground truth', 'decision tree', 'bag of trees (20)');