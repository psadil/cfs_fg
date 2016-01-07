function analyse_CFS_objects_outPut( firstSub, lastSub )
% Call this function second

confusedSubjects = 0;
missingData = [];

nValidSubjects = 0;
subIndex=0;
dPrimeOdd = [];
for subNum = firstSub:lastSub
    
    subIndex=subIndex+1;
    nValidSubjects = nValidSubjects+1;
    
    if any(subNum==missingData) %|| any(subNum==dPrimeOdd),
        subIndex = subIndex-1;
        confusedSubjects = confusedSubjects+1;
        continue;
    end
    
    %----------------------------------------------------------------------
    % load the data
    fName = [pwd '\Subject Data\currentVersion\pilotData\scored\Subject' num2str(subNum) 'PDP_CFS_objects_scored.mat'];
    fprintf('\nanalyzing SUBJECT %d\n', subNum);
    load(fName)
    
    
    %% Useful variables to be used as filters for the data
    
    out.inclusion = results.test.inclusion;
    out.exclusion = results.test.exclusion;
    
    out.studied = results.test.studied;
    out.notStudied = results.test.notStudied;
    
    
    foil_pre = results.test.foil;
    binoc_pre = results.test.binoc;
    CFS_pre = results.test.CFS;
    for item = 1:p.nItems
       out.foil(item) = foil_pre(item);
       out.binoc(item) = binoc_pre(item);
       out.CFS(item) = CFS_pre(item);
    end
    
    
    out.named = results.test.named;
    out.notNamed = results.test.notNamed;
    
    %----------------------------------------------------------------------
    % variables to divide the data by study response
    % 0 => no experience
    % 1 => brief glimpse
    % 2 => almost clear
    % 3 => clear experience
    
    out.zero = results.test.studyResp==0;
    out.one = results.test.studyResp==1;
    out.two = results.test.studyResp==2;
    out.three = results.test.studyResp==3;
    out.noStudyResp = isnan(results.test.studyResp);
    % those should sum to 120 for each participant
    
    %% recall during INCLUSION
    recall_FoilIn = (out.named.*out.inclusion.*out.foil);
    notRecall_FoilIn = (out.notNamed.*out.inclusion.*out.foil);
    recall_binocIn = (out.named.*out.inclusion.*out.binoc);
    notRecall_binocIn = (out.notNamed.*out.inclusion.*out.binoc);
    recall_CFSIn = (out.named.*out.inclusion.*out.CFS);
    notRecall_CFSIn = (out.notNamed.*out.inclusion.*out.CFS);
    
    prob.recall_FoilIn = sum(recall_FoilIn)/(sum(recall_FoilIn) + sum(notRecall_FoilIn));
    prob.notRecall_FoilIn = sum(notRecall_FoilIn)/(sum(recall_FoilIn) + sum(notRecall_FoilIn));
    prob.recall_binocIn = sum(recall_binocIn)/(sum(recall_binocIn) + sum(notRecall_binocIn));
    prob.notRecall_binocIn = sum(notRecall_binocIn)/(sum(recall_binocIn) + sum(notRecall_binocIn));
    prob.recall_CFSIn = sum(recall_CFSIn)/(sum(recall_CFSIn) + sum(notRecall_CFSIn));
    prob.notRecall_CFSIn = sum(notRecall_CFSIn)/(sum(recall_CFSIn) + sum(notRecall_CFSIn));
    
    resultsOverall.In.RecallGuess(subNum,:) = [ prob.recall_FoilIn,  prob.recall_binocIn, prob.recall_CFSIn];
    resultsOverall.In.RecallGuess_not(subNum,:) = [prob.notRecall_FoilIn,  prob.notRecall_binocIn, prob.notRecall_CFSIn];
    
    toFilter_In = table(recall_FoilIn,recall_binocIn,recall_CFSIn, notRecall_FoilIn,notRecall_binocIn,notRecall_CFSIn);
    
    %% recall during EXCLUSION
    recall_FoilEx = (out.named.*out.exclusion.*out.foil);
    notRecall_FoilEx = (out.notNamed.*out.exclusion.*out.foil);
    recall_binocEx = (out.named.*out.exclusion.*out.binoc);
    notRecall_binocEx = (out.notNamed.*out.exclusion.*out.binoc);
    recall_CFSEx = (out.named.*out.exclusion.*out.CFS);
    notRecall_CFSEx = (out.notNamed.*out.exclusion.*out.CFS);
    
    prob.recall_FoilEx = sum(recall_FoilEx)/(sum(recall_FoilEx) + sum(notRecall_FoilEx));
    prob.notRecall_FoilEx = sum(notRecall_FoilEx)/(sum(recall_FoilEx) + sum(notRecall_FoilEx));
    prob.recall_binocEx = sum(recall_binocEx)/(sum(recall_binocEx) + sum(notRecall_binocEx));
    prob.notRecall_binocEx = sum(notRecall_binocEx)/(sum(recall_binocEx) + sum(notRecall_binocEx));
    prob.recall_CFSEx = sum(recall_CFSEx)/(sum(recall_CFSEx) + sum(notRecall_CFSEx));
    prob.notRecall_CFSEx = sum(notRecall_CFSEx)/(sum(recall_CFSEx) + sum(notRecall_CFSEx));
    
    resultsOverall.Ex.RecallGuess(subNum,:) = [ prob.recall_FoilEx,  prob.recall_binocEx, prob.recall_CFSEx];
    resultsOverall.Ex.RecallGuess_not(subNum,:) = [prob.notRecall_FoilEx,  prob.notRecall_binocEx, prob.notRecall_CFSEx];
    
    toFilter_Ex = table(recall_FoilEx,recall_binocEx,recall_CFSEx, notRecall_FoilEx,notRecall_binocEx,notRecall_CFSEx);
    
    
    %% Looking at dPrime scores
    
    zFoil_In = norminv(prob.recall_FoilIn);
    zBinoc_In = norminv(prob.recall_binocIn);
    zCFS_In = norminv(prob.recall_CFSIn);
    
    zFoil_Ex = norminv(prob.recall_FoilEx);
    zBinoc_Ex = norminv(prob.recall_binocEx);
    zCFS_Ex = norminv(prob.recall_CFSEx);
    
    dPrime_binoc_In = zBinoc_In - zFoil_In;
    dPrime_CFS_In = zCFS_In - zFoil_In;
    
    dPrime_binoc_Ex = zBinoc_Ex - zFoil_Ex;
    dPrime_CFS_Ex = zCFS_Ex - zFoil_Ex;
    
    dPrime_binoc_Diff = dPrime_binoc_In - dPrime_binoc_Ex;
    dPrime_CFS_Diff = dPrime_CFS_In - dPrime_CFS_Ex;

    dPrime_Average_Diff = mean([dPrime_binoc_Diff, dPrime_CFS_Diff]);
    
    resultsOverall.InEx.dPrime(subNum,:) = [dPrime_binoc_Diff, dPrime_CFS_Diff, dPrime_Average_Diff];
    
    
    %% now, run IN and EX by study responses, looking at recall
    
    resultsOverall.In.zeroRecall(subNum,:) = divideTestResps(toFilter_In,out.zero, 1);
    resultsOverall.In.oneRecall(subNum,:) = divideTestResps(toFilter_In,out.one, 1);
    resultsOverall.In.twoRecall(subNum,:) = divideTestResps(toFilter_In,out.two, 1);
    resultsOverall.In.threeRecall(subNum,:) = divideTestResps(toFilter_In,out.three, 1);
    
    resultsOverall.Ex.zeroRecall(subNum,:) = divideTestResps(toFilter_Ex,out.zero, 1);
    resultsOverall.Ex.oneRecall(subNum,:) = divideTestResps(toFilter_Ex,out.one, 1);
    resultsOverall.Ex.twoRecall(subNum,:) = divideTestResps(toFilter_Ex,out.two, 1);
    resultsOverall.Ex.threeRecall(subNum,:) = divideTestResps(toFilter_Ex,out.three, 1);
    
    %% now, run IN and EX by study responses, looking at not recall
    
    resultsOverall.In.zeroNoRecall(subNum,:) = divideTestResps(toFilter_In,out.zero, 0);
    resultsOverall.In.oneNoRecall(subNum,:) = divideTestResps(toFilter_In,out.one, 0);
    resultsOverall.In.twoNoRecall(subNum,:) = divideTestResps(toFilter_In,out.two, 0);
    resultsOverall.In.threeNoRecall(subNum,:) = divideTestResps(toFilter_In,out.three, 0);
    
    resultsOverall.Ex.zeroNoRecall(subNum,:) = divideTestResps(toFilter_Ex,out.zero, 0);
    resultsOverall.Ex.oneNoRecall(subNum,:) = divideTestResps(toFilter_Ex,out.one, 0);
    resultsOverall.Ex.twoNoRecall(subNum,:) = divideTestResps(toFilter_Ex,out.two, 0);
    resultsOverall.Ex.threeNoRecall(subNum,:) = divideTestResps(toFilter_Ex,out.three, 0);
    
end
nValidSubjects = nValidSubjects-confusedSubjects;


%% preamble for data files

fName = [pwd,'\Subject Data\currentVersion\pilotData\collected\Results_objects_CFSs.csv'];
fileToWrite = fopen(fName,'w');

fprintf(fileToWrite,'Overall Object_CFSs Results');
fprintf(fileToWrite,'\n\n,Inclusion_Recall,,,,,,,,In_zero_recall,,,,In_one_recall,,,,In_two_recall,,,,In_three_recall,,,,In_zero_noRecall,,,,In_one_noRecall,,,,In_two_noRecall,,,,In_three_noRecall,,,,Exclusion_Recall,,,,,,,,Ex_zero,,,,Ex_one,,,,Ex_two,,,,Ex_three,,,,Ex_zero_noRecall,,,,Ex_one_noRecall,,,,Ex_two_noRecall,,,,Ex_three_noRecall,,,,Recall_dPrime');
% fprintf(fileToWrite, '\n,studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied');
fprintf(fileToWrite, '\nSUBJECT,recall_Foil_In,recall_binoc_In,recall_CFS_In,,notRecall_Foil_In,notRecall_binoc_In,notRecall_CFS_In,,recall_Foil_In,recall_binoc_In,recall_CFS_In,,recall_Foil_In,recall_binoc_In,recall_CFS_In,,recall_Foil_In,recall_binoc_In,recall_CFS_In,,recall_Foil_In,recall_binoc_In,recall_CFS_In,,recall_Foil_Ex,recall_binoc_Ex,recall_CFS_Ex,,notRecall_Foil_Ex,notRecall_binoc_Ex,notRecall_CFS_Ex,,recall_Foil_Ex,recall_binoc_Ex,recall_CFS_Ex,,recall_Foil_Ex,recall_binoc_Ex,recall_CFS_Ex,,recall_Foil_Ex,recall_binoc_Ex,recall_CFS_Ex,,recall_Foil_Ex,recall_binoc_Ex,recall_CFS_Ex,,dPrime_binoc_Diff, dPrime_CFS_Diff, dPrime_Average_Diff');
fprintf(fileToWrite, '\n');

%% record averages
for sub = firstSub:lastSub
    fprintf(fileToWrite, '%d', sub);
    firstNames = fieldnames(resultsOverall);
    for first = 1:length(firstNames),    %These are conditions: Inclusion and Exclusion
        secondNames = fieldnames(resultsOverall.(firstNames{first}));  %Whether we're looking at recognition or recall data
        for second = 1:length(secondNames)
            %             titleNames = prob.(probNames{second});
            %             fprintf('\n%s, %s, %s, %s\n', present.(firstNames{first}).(secondNames{second}).(thirdNames{:}));
            %             thirdNames = fieldnames(present.(firstNames{first}).(secondNames{second}));
            %             for third = 1:length(thirdNames)
            
            for toPrint = 1:length(resultsOverall.(firstNames{first}).(secondNames{second}))
                printing = resultsOverall.(firstNames{first}).(secondNames{second})(sub,toPrint);
                fprintf(fileToWrite,',%3.2g',printing);
            end
            fprintf(fileToWrite,',');
%             fprintf(fileToWrite, ',%3.2g, %3.2g, %3.2g,', resultsOverall.(firstNames{first}).(secondNames{second})(sub,:));
        end
    end
    fprintf(fileToWrite, '\n');
end

average = zeros(1,3);
varience = zeros(1,3);
STDev = zeros(1,3);
SEM = zeros(1,3);
% column = 0;
% set = 0;   % variable to help place elements of presentResults.averages

resultsOverallResults.averages = zeros(1, length(secondNames)*length(firstNames)*4);

fprintf(fileToWrite, '\nAVERAGES');
firstNames = fieldnames(resultsOverall);
for first = 1:length(firstNames),
    secondNames = fieldnames(resultsOverall.(firstNames{first}));
    for second = 1:length(secondNames)
        for avg = 1:length(resultsOverall.(firstNames{first}).(secondNames{second}))
            average(avg) = sum(resultsOverall.(firstNames{first}).(secondNames{second})(:,avg))/nValidSubjects;
            resultsOverallResults.averages(avg) = average(avg);
            
            fprintf(fileToWrite, ',%3.2g', average(avg));
        end
        fprintf(fileToWrite,',');
%         fprintf(fileToWrite, ',%3.2g, %3.2g, %3.2g,', average);
%         set = set+length(averages);
    end
end

%
% fprintf(fileToWrite, '\nSTDEV');
% for column = 1:length(secondNames)
%     for first = 1:length(firstNames),
%         for second = 1:length(secondNames)
%             for avg = 1:4
%                 averages(avg) = sum(resultsOverall.(firstNames{first}).(secondNames{second})(:,avg))/nValidSubjects;
%                 varience(avg) = sum(((resultsOverall.(firstNames{first}).(secondNames{second})(:,avg)) - averages(avg)).^2)/(nValidSubjects-1);
%                 stdev(avg) = sqrt(varience(avg));
%             end
%         fprintf(fileToWrite, ',%g, %g, %g, %g,', stdev);
%         end
%     end
% end

fprintf(fileToWrite, '\nSEM');
firstNames = fieldnames(resultsOverall);
for first = 1:length(firstNames),
    secondNames = fieldnames(resultsOverall.(firstNames{first}));
    for second = 1:length(secondNames)
        for avg = 1:length(resultsOverall.(firstNames{first}).(secondNames{second}))
            
            average(avg) = sum(resultsOverall.(firstNames{first}).(secondNames{second})(:,avg))/nValidSubjects;
            varience(avg) = sum(((resultsOverall.(firstNames{first}).(secondNames{second})(:,avg)) - average(avg)).^2)/(nValidSubjects-1);
            STDev(avg) = sqrt(varience(avg));
            SEM(avg) = STDev(avg)/sqrt(nValidSubjects);
        
            fprintf(fileToWrite, ',%3.2g', SEM(avg));
        end
        fprintf(fileToWrite,',');
%         fprintf(fileToWrite, ',%3.2g, %3.2g, %3.2g,', SEM);
    end
end

fclose('all');

% % don't really need to generate a .mat file (since all of the
% % analyses on the data in this structure is easier done in R, but here's
% % the code for a mat file, just in case
% fileName = [pwd '\Subject Data\currentVersion\collected\Results_objects_CFSs.mat'];
% save(fileName, 'resultsOverall', 'results', 'p');

end

