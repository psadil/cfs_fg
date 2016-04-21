function [ ] = checkStudyOrder( p )
%checkStudyOrder Summary of this function goes here
%   Detailed explanation goes here

nWrong = 0;
for trial = 1:p.nItems
   
    item_test = p.testOrder(trial);
    item_study = p.studyOrder(trial);
    trial_study = p.studyOrder==item_test;
    itemCondition_study = p.itemCondition_study(trial_study);
    itemCondition_test = p.itemCondition_test(trial);
    
    if itemCondition_study ~= itemCondition_test
       nWrong=nWrong+1; 
    end
    
end

fprintf('n w/ misMatching conditions: %d\n', nWrong)

end

