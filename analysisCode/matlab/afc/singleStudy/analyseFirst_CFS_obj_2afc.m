function analyseFirst_CFS_obj_2afc(start,numSubjects)
% call first to analyse recall data of CFS objects

[num,stimNames] = xlsread('objectNames_2afc.xlsx');
% load objectNames.mat

confusedSubjects = 0;

% subjects 1 - 7 in pilot data were checking their phones
% subject 20 writes "drum i can see things now i think it was my glasses i
% turned them on and sat up straight"
missingData = [5, 25, 29, 31, 35,37, 41, 43, 46, 48];
% subject 14: didn't respond often
% 18: many without a response

for subNum = start:numSubjects,
    
    %don't try to load data files that don't exist
    if any(missingData==subNum)
        confusedSubjects = confusedSubjects+1;
        continue;
    end
    
    %----------------------------------------------------------------------
    % load the data
    % NOTE: file may say 'pilot' but this is the real deal
    fName = [pwd '\subjectData\raw\Subject' num2str(subNum) 'CFS_obj_2AFC_pilot1.mat'];
    fprintf('\nSUBJECT %d:', subNum);
    load(fName)
    
    
    %----------------------------------------------------------------------
    % store data in 'test space,' where each element refers to the item
    % that was seen
    % ---------------------------------------------------------------------
    
    results.test.foil = p.itemCondition_test == 1;
    results.test.word = p.itemCondition_test == 2;
    results.test.CFS = p.itemCondition_test == 3;
    results.test.word = p.itemCondition_test == 4;
    
    results.test.studied = p.itemCondition_test > 1;
    % NOTE: notStudied == foil
    results.test.notStudied = p.itemCondition_test == 1;
    
    %----------------------------------------------------------------------
    % collect afc responses
    % ---------------------------------------------------------------------
    
    afcResp = KbName(p.responses.afc);
    results.afcResp = cell2mat(cellfun(@(x) str2double(x(1)), afcResp, 'UniformOutput', 0));
    
    results.afc_correct = p.test_leftRight==results.afcResp';
    
    %% score data
    
    %make testAnswers matrix
    recallResponses = p.responses.recall(1:length(p.responses.recall),:);
    results.study.pas = p.responses.study;
    %check whether the test answer diverges considerably from study answers given
    
    trial = 0;
    while trial  < length(p.responses.recall),
        trial = trial+1;
        
        item = p.testOrder(trial);
        
        response = recallResponses(trial,:);
        responseLength = sum(response~=0); % returns a 1 where a letter exists, zero elsewhere, sums over 1's
        response = response(1:responseLength);  %created a string, will be a problem when spaces exist...
        
        %find answer from official matrix
        respToCompare = stimNames(item,:);
        
        
        levDist = zeros(1,length(respToCompare));
        for respToCompare_index = 1:length(respToCompare)
            if length(respToCompare{respToCompare_index}) < 2
                levDist(respToCompare_index:end) = [];
                break
            end
            levDist(respToCompare_index) = strdist(response,respToCompare{respToCompare_index},1,1);
        end
        if isempty(levDist)
            fprintf('\nTrial #%d (Object%d). studied, but no answer given', trial, item);
            results.study.named(trial) = 0;
            continue
        elseif length(response) < 2;
            fprintf('\nTrial #%d (Object%d). no response given', trial, item);
            results.study.named(trial) = 0;
            continue
        else
            levDist_min = min(levDist);
            closestName_index = find(levDist==levDist_min);
            closestName = respToCompare{closestName_index};
        end
        
        if levDist_min<=2 && length(response)>1,
            fprintf('\n%s CORRECTLY LABLED as %s \n', closestName, response);
            results.study.named(trial)=1;
            %             continue; %don't search the rest of the study or possible correct answers - we have a correct one
        else
            fprintf('\nTrial #%d (Object%d)', trial, item);
            fprintf('\nPOSSIBLE RESPONSE: %s \nTEST: %s \n', closestName, response);
            
            overRide = input('Enter whether correct/incorrect (1/0): ');
            if isempty(overRide) || overRide > 3
                overRide = input('Enter whether correct/incorrect (1/0): ');
            elseif overRide == 3
                trial = trial - 2;
                continue
            else
                results.study.named(trial)=overRide;
            end
            
            
        end
        
    end % end of trial
    
    
    %% Useful variables to be used as filters for the data
    
    % whether named or not (note, already have results.study.named
    %     results.test.named = results.test.recallCorrect==1;
    results.study.notNamed = results.study.named==0;
    
    
    
    
    
    
    %     results.study.foil = p.cond.foil;
    %     results.study.word = p.cond.word;
    %     results.study.cfs = p.cond.cfs;
    %     results.study.binoc = p.cond.binoc;
    
    
    %% Save the results
    fileName = [pwd '\subjectData\scored\Subject' num2str(subNum) 'CFS_obj_2AFC_scored.mat'];
    save(fileName, 'results', 'p');
    
end


end