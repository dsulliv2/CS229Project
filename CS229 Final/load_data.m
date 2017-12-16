function [ stores, train, test ] = load_data( ~ )
%Load csv data for stores

store_format = '%d%s%d';
stores = readtable('/Users/James/Desktop/CS229 Final Project/Walmart/stores.csv',...
    'Delimiter', ',', 'Format', store_format);

train_format = '%d%d%{yyyy-MM-dd}D%d%s';
train = readtable('/Users/James/Desktop/CS229 Final Project/Walmart/train.csv',...
    'Delimiter', ',', 'Format', train_format);

test_format = '%d%d%{yyyy-MM-dd}D%s';
test = readtable('/Users/James/Desktop/CS229 Final Project/Walmart/test.csv',...
    'Delimiter', ',', 'Format', test_format);


end

