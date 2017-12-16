%%add easter to isHoliday flag

function train = addEaster(train)
easterDate = [(datenum('9-Apr-2010'));...
    datenum('29-Apr-2011');...
    datenum('13-Apr-2012'); ...
    datenum('5-Apr-2013')];


dateN = arrayfun(@datenum,train.Date);
easterIx = ismember(dateN,easterDate);
allHoliday = (easterIx + (train.IsHolidayBool>0)) == 1;

train.IsHoliday2 = allHoliday;

end