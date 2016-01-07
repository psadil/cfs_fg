function analyseResults_CFS_objects_pilot(start,numSubjects)
% call first to analyse recall data of CFS objects

[num,stimNames] = xlsread('objectNames_2afc.xlsx');
% load objectNames.mat

confusedSubjects = 0;

% subjects 1 - 7 in pilot data were checking their phones
% subject 20 writes "drum i can see things now i think it was my glasses i
% turned them on and sat up straight"
missingData = [1:7,20];

for subNum = start:numSubjects,
    
    %don't try to load data files that don't exist
    if any(missingData==subNum)
        confusedSubjects = confusedSubjects+1;
        continue;
    end
    
    %----------------------------------------------------------------------
    % load the data
    fName = [pwd '\Subject Data\currentVersion\Subject Data_2afc_pilot\raw\Subject' num2str(subNum) 'CFS_obj_2AFC_pilot1.mat'];
    fprintf('\nSUBJECT %d:', subNum);
    load(fName)
    
    
    %----------------------------------------------------------------------
    % for this pilot data, there is no test space
    % ---------------------------------------------------------------------
    
    
    %% score data
    
    %make testAnswers matrix
    studyResponses = p.responses.study_name(1:length(p.responses.study_name),:);
    results.study.pas = p.responses.study;
    %check whether the test answer diverges considerably from study answers given
    
    for trial = 1:length(p.responses.study_name),
        
        item = p.studyOrder(trial);
        
        response = studyResponses(trial,:);
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
            results.study.named(trial)=overRide;
        end
        
    end % end of trial
    
    
    %% Useful variables to be used as filters for the data
    
    % whether named or not (note, already have results.study.named
    %     results.test.named = results.test.recallCorrect==1;
    results.study.notNamed = results.study.named==0;
    
    results.study.onePfive = p.onePfive;
    results.study.two = p.two;
    results.study.twoPfive = p.twoPfive;
    results.study.three = p.three;
    
    
    %% Save the results
    fileName = [pwd '\Subject Data\currentVersion\Subject Data_2afc_pilot\scored\Subject' num2str(subNum) 'CFS_obj_2AFC_pilot1_scored.mat'];
    save(fileName, 'results', 'p');
    
end


end