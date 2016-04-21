function [ ] = checkStudyOrder( p )
%checkStudyOrder Summary of this function goes here
%   Detailed explanation goes here

delItems = [5,9,10,12,17,21,22,24,27,35,38,36,41,42,46,48,49,51,54,55,63,65,67,70,75,77,82,83,84,87,91,92,93,94,101,106,105,108,109,114,116,120,127,130,132,134,136,138,142,148,149,152,158,160,164,168,169,171,173,175,178,180,182,190];


nWrong = 0;
for trial = 1:p.nItems.unique

    if any(trial==delItems)
       continue 
    end
    
    cond = p.stimTab.itemConds(trial);
    item_test = p.stimTab.testOrder(trial);
%     item_study = p.stimTab.studyOrder(trial);

    
    trial_study = p.stimTab.studyOrder==item_test;
    itemCondition_study = p.stimTab.itemCond_study(trial_study);
    itemCondition_test = p.stimTab.itemCond_test(trial);
    
    if itemCondition_study ~= itemCondition_test
       nWrong=nWrong+1; 
    elseif cond ~= p.stimTab.itemCond_study(p.stimTab.studyOrder == p.stimTab.pairs(trial,1))
        nWrong = nWrong+1;
    end
    
end

fprintf('n w/ misMatching conditions: %d\n', nWrong)

end

