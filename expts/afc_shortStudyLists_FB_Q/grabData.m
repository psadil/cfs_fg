%run this script to copy data files for processDissociation onto computer
%in room 201n


% name of folder within expt where data is stored
subDataFolder = '\subjectData';

% data dir file name
data = '\Subject*';

% % demographics name
% demog = '\Demographics*.txt';

% demogFolder = [subDataFolder, '\demog'];

% note, computer 1 refers to comp in 201n, and so doesn't need to be
% checked
for comp = 5:7,
    otherComp = ['\\CC' num2str(comp) '\Users\lab\Documents\MATLAB\psadilTesting\CFS_objects\afc_shortStudyLists_wFB_Q'];
    
      
    copyfile([otherComp, subDataFolder, data],[ pwd, subDataFolder ] );
    
%     copyfile([otherComp, subDataFolder, demog],[ pwd, demogFolder ] );
 
    
end
