function [ p ] = loadStimTable( p )
%loadStimTable loads table of stims to be presented, which were generated
%by setUpBlocking.m


load([pwd, '\stimTabs\stimTab_sub', num2str(p.subNum)]);
p.stimTab = stims;
p.stimTab_prac = stims_prac;


end