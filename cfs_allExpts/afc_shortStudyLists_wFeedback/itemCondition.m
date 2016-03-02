conditionOrder_study = p.itemCondition_study(p.studyOrder);

conditionOrder_test=zeros(1,p.nItems);
for testTrial = 1:p.nItems
    item = p.testOrder(testTrial);
    conditionOrder_test(testTrial) = conditionOrder_study(find(p.studyOrder==item));
end