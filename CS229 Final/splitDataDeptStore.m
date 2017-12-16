%load your training data
%then make a feature per array
store = train.Store;
dept = train.Dept;
date = train.Date;
sales = train.Weekly_Sales;
dateDay = arrayfun(@datenum,train.Date);

storeNums = unique(train.Store);
storeDepts = unique(train.Dept)
for six  = 1:numel(storeNums)
    s = storeNums(six)
    for dix = 1:numel(storeDepts)
        d = storeDepts(dix)
        % get the indices where store num = s and dept = d
        ix = intersect(find(store == s), find(dept == d));
        
        %do your work per dept per store here
    end
end
