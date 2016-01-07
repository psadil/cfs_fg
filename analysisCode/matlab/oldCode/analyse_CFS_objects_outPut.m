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
    fName = [pwd '\Subject Data\Subject' num2str(subNum) 'PDP_CFS_objects_scored.mat'];
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
    binocCFS_pre = results.test.binocCFS;
    for item = 1:p.nItems
       out.foil(item) = foil_pre(item);
       out.binoc(item) = binoc_pre(item);
       out.CFS(item) = CFS_pre(item);
       out.binocCFS(item) = binocCFS_pre(item);
    end
    
    
    out.named = results.test.named;
    out.notNamed = results.test.notNamed;
    
    %% recall during INCLUSION
    recall_FoilIn = (out.named.*out.inclusion.*out.foil);
    notRecall_FoilIn = (out.notNamed.*out.inclusion.*out.foil);
    recall_binocIn = (out.named.*out.inclusion.*out.binoc);
    notRecall_binocIn = (out.notNamed.*out.inclusion.*out.binoc);
    recall_CFSIn = (out.named.*out.inclusion.*out.CFS);
    notRecall_CFSIn = (out.notNamed.*out.inclusion.*out.CFS);
    recall_binocCFSIn = (out.named.*out.inclusion.*out.binocCFS);
    notRecall_binocCFSIn = (out.notNamed.*out.inclusion.*out.binocCFS);
    
    prob.recall_FoilIn = sum(recall_FoilIn)/(sum(recall_FoilIn) + sum(notRecall_FoilIn));
    prob.notRecall_FoilIn = sum(notRecall_FoilIn)/(sum(recall_FoilIn) + sum(notRecall_FoilIn));
    prob.recall_binocIn = sum(recall_binocIn)/(sum(recall_binocIn) + sum(notRecall_binocIn));
    prob.notRecall_binocIn = sum(notRecall_binocIn)/(sum(recall_binocIn) + sum(notRecall_binocIn));
    prob.recall_CFSIn = sum(recall_CFSIn)/(sum(recall_CFSIn) + sum(notRecall_CFSIn));
    prob.notRecall_CFSIn = sum(notRecall_CFSIn)/(sum(recall_CFSIn) + sum(notRecall_CFSIn));
    prob.recall_binocCFSIn = sum(recall_binocCFSIn)/(sum(recall_binocCFSIn) + sum(notRecall_binocCFSIn));
    prob.notRecall_binocCFSIn = sum(notRecall_binocCFSIn)/(sum(recall_binocCFSIn) + sum(notRecall_binocCFSIn));
    
    resultsOverall.In.RecallGuess(subNum,:) = [ prob.recall_FoilIn,  prob.recall_binocIn, prob.recall_CFSIn, prob.recall_binocCFSIn];
    resultsOverall.In.RecallGuess_not(subNum,:) = [prob.notRecall_FoilIn,  prob.notRecall_binocIn, prob.notRecall_CFSIn, prob.notRecall_binocCFSIn];
    
    %% recall during EXCLUSION
    recall_FoilEx = (out.named.*out.exclusion.*out.foil);
    notRecall_FoilEx = (out.notNamed.*out.exclusion.*out.foil);
    recall_binocEx = (out.named.*out.exclusion.*out.binoc);
    notRecall_binocEx = (out.notNamed.*out.exclusion.*out.binoc);
    recall_CFSEx = (out.named.*out.exclusion.*out.CFS);
    notRecall_CFSEx = (out.notNamed.*out.exclusion.*out.CFS);
    recall_binocCFSEx = (out.named.*out.exclusion.*out.binocCFS);
    notRecall_binocCFSEx = (out.notNamed.*out.exclusion.*out.binocCFS);
    
    prob.recall_FoilEx = sum(recall_FoilEx)/(sum(recall_FoilEx) + sum(notRecall_FoilEx));
    prob.notRecall_FoilEx = sum(notRecall_FoilEx)/(sum(recall_FoilEx) + sum(notRecall_FoilEx));
    prob.recall_binocEx = sum(recall_binocEx)/(sum(recall_binocEx) + sum(notRecall_binocEx));
    prob.notRecall_binocEx = sum(notRecall_binocEx)/(sum(recall_binocEx) + sum(notRecall_binocEx));
    prob.recall_CFSEx = sum(recall_CFSEx)/(sum(recall_CFSEx) + sum(notRecall_CFSEx));
    prob.notRecall_CFSEx = sum(notRecall_CFSEx)/(sum(recall_CFSEx) + sum(notRecall_CFSEx));
    prob.recall_binocCFSEx = sum(recall_binocCFSEx)/(sum(recall_binocCFSEx) + sum(notRecall_binocCFSEx));
    prob.notRecall_binocCFSEx = sum(notRecall_binocCFSEx)/(sum(recall_binocCFSEx) + sum(notRecall_binocCFSEx));
    
    resultsOverall.Ex.RecallGuess(subNum,:) = [ prob.recall_FoilEx,  prob.recall_binocEx, prob.recall_CFSEx, prob.recall_binocCFSEx];
    resultsOverall.Ex.RecallGuess_not(subNum,:) = [prob.notRecall_FoilEx,  prob.notRecall_binocEx, prob.notRecall_CFSEx, prob.notRecall_binocCFSEx];
    
    
    %% Looking at dPrime scores
    
    zFoil_In = norminv(prob.recall_FoilIn);
    zbinoc_In = norminv(prob.recall_binocIn);
    zCFS_In = norminv(prob.recall_CFSIn);
    zbinocCFS_In = norminv(prob.recall_binocCFSIn);
    
    zFoil_Ex = norminv(prob.recall_FoilEx);
    zbinoc_Ex = norminv(prob.recall_binocEx);
    zCFS_Ex = norminv(prob.recall_CFSEx);
    zbinocCFS_Ex = norminv(prob.recall_binocCFSEx);
    
    dPrime_binoc_In = zbinoc_In - zFoil_In;
    dPrime_CFS_In = zCFS_In - zFoil_In;
    dPrime_binocCFS_In = zbinocCFS_In - zFoil_In;
    
    dPrime_binoc_Ex = zbinoc_Ex - zFoil_Ex;
    dPrime_CFS_Ex = zCFS_Ex - zFoil_Ex;
    dPrime_binocCFS_Ex = zbinocCFS_Ex - zFoil_Ex;
    
    dPrime_binoc_Diff = dPrime_binoc_In - dPrime_binoc_Ex;
    dPrime_CFS_Diff = dPrime_CFS_In - dPrime_CFS_Ex;
    dPrime_binocCFS_Diff = dPrime_binocCFS_In - dPrime_binocCFS_Ex;
    dPrime_Average_Diff = mean([dPrime_binoc_Diff, dPrime_CFS_Diff, dPrime_binocCFS_Diff]);
    
    
    resultsOverall.InEx.dPrime(subNum,:) = [dPrime_binoc_Diff, dPrime_CFS_Diff, dPrime_binocCFS_Diff, dPrime_Average_Diff];
    
end
nValidSubjects = nValidSubjects-confusedSubjects;


fName = 'Results_objects_binocCFSs.csv';
fileToWrite = fopen(fName,'w');

fprintf(fileToWrite,'Overall Object_binocCFSs Results');
fprintf(fileToWrite,'\n\n,Inclusion_Recall,,,,,,,,,,Exclusion_Recall,,,,,,,,,,Recall_dPrime');
% fprintf(fileToWrite, '\n,studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied,,,Studied,,notStudied');
fprintf(fileToWrite, '\nSUBJECT,recall_Foil_In,recall_binoc_In,recall_CFS_In,recall_binocCFS_In,,notRecall_Foil_In,notRecall_binoc_In,notRecall_CFS_In,notRecall_binocCFS_In,,recall_Foil_Ex,recall_binoc_Ex,recall_CFS_Ex,recall_binocCFS_Ex,,notRecall_Foil_Ex,notRecall_binoc_Ex,notRecall_CFS_Ex,notRecall_binocCFS_Ex');
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
            fprintf(fileToWrite, ',%3.2g, %3.2g, %3.2g, %3.2g,', resultsOverall.(firstNames{first}).(secondNames{second})(sub,:));
        end
    end
    fprintf(fileToWrite, '\n');
end

averages = zeros(1,4);
varience = zeros(1,4);
STDev = zeros(1,4);
SEM = zeros(1,4);
% column = 0;
set = 0;   % variable to help place elements of presentResults.averages

resultsOverallResults.averages = zeros(1, length(secondNames)*length(firstNames)*4);

fprintf(fileToWrite, '\nAVERAGES');
firstNames = fieldnames(resultsOverall);
for first = 1:length(firstNames),
    secondNames = fieldnames(resultsOverall.(firstNames{first}));
    for second = 1:length(secondNames)
        for avg = 1:4
            averages(avg) = sum(resultsOverall.(firstNames{first}).(secondNames{second})(:,avg))/nValidSubjects;
            resultsOverallResults.averages(avg+set) = averages(avg);
        end
        fprintf(fileToWrite, ',%3.2g, %3.2g, %3.2g, %3.2g,', averages);
        set = set+length(averages);
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
        for avg = 1:4
            averages(avg) = sum(resultsOverall.(firstNames{first}).(secondNames{second})(:,avg))/nValidSubjects;
            varience(avg) = sum(((resultsOverall.(firstNames{first}).(secondNames{second})(:,avg)) - averages(avg)).^2)/(nValidSubjects-1);
            STDev(avg) = sqrt(varience(avg));
            SEM(avg) = STDev(avg)/sqrt(nValidSubjects);
        end
        fprintf(fileToWrite, ',%3.2g, %3.2g, %3.2g, %3.2g,', SEM);
    end
end

fclose('all');

fileName = [pwd '\Subject Data\Results_objects_binocCFSs.mat'];
save(fileName, 'resultsOverall');


end

