function [ p ] = loadStimTable( p )
%loadStimTable loads table of stims to be presented, which were generated
%by setUpBlocking.m


load([pwd, '\stimTabs\stimTab_sub', num2str(p.subNum)]);
p.stimTab = stims;
p.stimTab_prac = stims_prac;


p.nPerBlocking = 8;

p.nItems.unique = 16*8; % nItems must be in multiples of 16
p.nItems.practice = 16; % items seen in practice phase
p.nConds = 4; % number of item conditions
p.nItems.studyList = 16; % number of items seen in study list
p.nReps = 2; % number of times items repeated per study list


p.nStudyLists = p.nItems.unique/p.nItems.studyList;
p.nItems.list_total = p.nItems.studyList * p.nReps;
p.nTrials = p.nItems.unique*p.nReps;

p.nItems.studyCond = p.nItems.unique/p.nConds; % 1/4 of total items for each condition
p.nItems.testCond = p.nItems.studyCond/2; % number of items from each condition displayed during each In/Ex block


p.ind.study = repmat(repmat(1:p.nItems.studyList,[1,p.nReps]),[1,p.nStudyLists]) + ...
   repelem(0:p.nItems.studyList:p.nItems.unique-p.nItems.studyList,p.nItems.studyList*p.nReps);

p.ind.test = repmat(1:p.nItems.studyList,[1,p.nStudyLists]); %+ ...
 %   repelem(0:p.nItems.studyList:p.nItems.unique-p.nItems.studyList,p.nItems.studyList);

p.ind.studyList = 1:p.nItems.list_total:p.nTrials;

p.ind.testList = 1:p.nItems.studyList:p.nItems.unique;



end