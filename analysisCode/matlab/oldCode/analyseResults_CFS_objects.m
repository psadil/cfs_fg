function analyseResults_CFS_objects(start,numSubjects)
% call first to analyse recall data of CFS objects

[num,stimNames] = xlsread('objectNames.csv');
% load objectNames.mat

confusedSubjects = 0;
missingData = [];

for subNum = start:numSubjects,
    
    %don't try to load data files that don't exist
    if any(missingData==subNum)
        confusedSubjects = confusedSubjects+1;
        continue;
    end
    
    %----------------------------------------------------------------------
    % load the data
    fName = [pwd '\Subject Data\Subject' num2str(subNum) 'PDP_CFS_objects1.mat'];
    fprintf('\nSUBJECT %d:', subNum);
    load(fName)
    
    
    %----------------------------------------------------------------------
    % store data in 'test space,' where each element refers to the item
    % that was seen
    % ---------------------------------------------------------------------
    
    results.test.foil = p.itemCondition_test == 0;
    
    results.test.binoc = p.itemCondition_test == 1;
    
    results.test.CFS = p.itemCondition_test == 2;
    
    results.test.binocCFS = p.itemCondition_test == 3;
    results.test.binocCFS = results.test.binocCFS + (p.itemCondition_test == 4);
    
    results.test.studied = p.itemCondition_test > 0;
    
    % NOTE: notStudied == foil
    results.test.notStudied = p.itemCondition_test == 0;
        
        
    %% score recall data
    
    %make testAnswers matrix
    testResponses = p.responses.recall(1:p.nItems,:);
    results.test.recallCorrect = zeros(1,p.nItems);
    %check whether the test answer diverges considerably from study answers given
    trial=0;
    for block = 1:2
        
        if p.blockInEx(block) == 1   % Testing for inclusion trials
            fprintf('\n*****These are INCLUSION trials*****\n')
        elseif p.blockInEx(block) == 2
            fprintf('\n*****These are EXCLUSION trials*****\n')
        end
        
        for t = 1:p.nItems/2,
            trial = trial+1;
            % need to make in correct space (either item or trail)
            item = p.testOrder(trial);
            results.test.InOrEx(trial) = p.blockInEx(block);
            if trial == 27 || trial == 16
                9;
            end
            
            response = testResponses(trial,:);
            responseLength = sum(response~=0); % returns a 1 where a letter exists, zero elsewhere, sums over 1's
            response = response(1:responseLength);  %created a string, will be a problem when spaces exist...
            studyTrial = find(p.studyOrder==item);
            if results.test.studied(trial) %if this item was studied
                respToCompare = p.responses.study(studyTrial,:);
                studyResp_length = sum(respToCompare~=0);
                respToCompare = {respToCompare(1:studyResp_length)};
            elseif ~results.test.studied(trial) %if item wasn't studied
                %find answer from official matrix
                respToCompare = stimNames(p.testOrder(trial),:);
            end
            
            
            levDist = zeros(1,length(respToCompare));
            for respToCompare_index = 1:length(respToCompare)
                if length(respToCompare{respToCompare_index}) < 2
                    levDist(respToCompare_index:end) = [];
                    break
                end
                levDist(respToCompare_index) = strdist(response,respToCompare{respToCompare_index},1,1);
            end
            if isempty(levDist)
                fprintf('\nTrial #%d (Scene%d). studied, but no answer given', trial, p.testOrder(trial));
                results.test.recallCorrect(trial) = 0;
                continue
            elseif length(response) < 2;
                fprintf('\nTrial #%d (Scene%d). no response given', trial, p.testOrder(trial));
                results.test.recallCorrect(trial) = 0;
                continue
            else
                levDist_min = min(levDist);
                closestName_index = find(levDist==levDist_min);
                closestName = respToCompare{closestName_index};
            end
            
            if levDist_min<=2 && length(response)>1,
                fprintf('\n%s CORRECTLY LABLED as %s \n', closestName, response);
                results.test.recallCorrect(trial)=1;
                continue; %don't search the rest of the study or possible correct answers - we have a correct one
            end
            
            if results.test.studied(trial)
                fprintf('\nTrial #%d (Scene%d). Studied: %d.', trial, p.testOrder(trial),results.test.studied(trial));
                fprintf('\nSTUDY RESPONSE: %s \nTEST: %s \n', closestName, response);
            else
                fprintf('\nTrial #%d (Scene%d). Studied: %d.', trial, p.testOrder(trial),results.test.studied(trial));
                fprintf('\nPOSSIBLE RESPONSE: %s \nTEST: %s \n', closestName, response);
            end
            
            overRide = input('Enter whether correct/incorrect (1/0): ');
            results.test.recallCorrect(trial)=overRide;
            
        end % end of trial
        
    end % end of test block (inclusion first)
    
    
    %% Useful variables to be used as filters for the data
    results.test.inclusion = results.test.InOrEx==1;
    results.test.exclusion = results.test.InOrEx==2;
    
    results.test.named = results.test.recallCorrect==1;
    results.test.notNamed = results.test.recallCorrect==0;
    
    
    %% Save the results
    fileName = [pwd '\Subject Data\Subject' num2str(subNum) 'PDP_CFS_objects_scored.mat'];
    save(fileName, 'results', 'p');
    
end


end