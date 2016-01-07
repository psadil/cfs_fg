function [ filt ] = divideTestResps( toFilt, filter , recallOrNo)
%divideTestResps filters IN and EX responses by study response

%   Detailed explanation goes here

% 0 => 0/x
% Inf => x/0
% NaN => 0/0

%% recall during INCLUSION
recall_Foil_filtered = (toFilt{:,1}.*filter);
recall_binoc_filtered = (toFilt{:,2}.*filter);
recall_CFS_filtered = (toFilt{:,3}.*filter);
notRecall_Foil_filtered = (toFilt{:,4}.*filter);
notRecall_binoc_filtered = (toFilt{:,5}.*filter);
notRecall_CFS_filtered = (toFilt{:,6}.*filter);

% calculate the conditional probabilities (rates of event given a particular study response)
if recallOrNo
    filted.Foil = sum(recall_Foil_filtered)/(sum(recall_Foil_filtered) + sum(notRecall_Foil_filtered));
    filted.binoc = sum(recall_binoc_filtered)/(sum(recall_binoc_filtered) + sum(notRecall_binoc_filtered));
    filted.CFS = sum(recall_CFS_filtered)/(sum(recall_CFS_filtered) + sum(notRecall_CFS_filtered));
    
else
    filted.Foil = sum(notRecall_Foil_filtered)/(sum(recall_Foil_filtered) + sum(notRecall_Foil_filtered));
    filted.binoc = sum(notRecall_binoc_filtered)/(sum(recall_binoc_filtered) + sum(notRecall_binoc_filtered));
    filted.CFS = sum(notRecall_CFS_filtered)/(sum(recall_CFS_filtered) + sum(notRecall_CFS_filtered));
    
end
filt =  [filted.Foil, filted.binoc, filted.CFS ];


end

