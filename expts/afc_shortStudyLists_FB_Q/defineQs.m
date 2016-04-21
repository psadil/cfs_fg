function [ text_Qs, text_As, studyInstr ] = defineQs( ~ )
%defineQs -- defines which questions are asked after a study trial

% study instructions correspond to item conditions. Foil and cfs condition
% receive same instructions (though, only 1/4 of total foil trials are used)
studyInstr(1) = {'please press Enter if you think an object appears'};
studyInstr(2) = {'please repeat the following word to yourself'};
studyInstr(3) = {'please press Enter if you think an object appears'};
studyInstr(4) = {'please study the details of the following object'};

% questions to ask when an object is presented
text_Qs(1) = {'Was the object symmetric across its horizontal axis?'};
text_Qs(2) = {'Did the object fill more than 1/4 of the flashing squares?'};
text_Qs(3) = {'Was the object reflective?'};
text_Qs(4) = {'Did the object contain multiple parts?'};

% questions to ask during an object trial
text_Qs(5) = {'Did the word begin with letter in the first half of the alphabet?'};
text_Qs(6) = {'Did the word contain a repeating letter?'};
text_Qs(7) = {'Did the word describe a natural or man-made object?'};
text_Qs(8) = {'Did the word describe an object that you could hold in your hand?'};

% answer string to display
text_As = 'y3, y2, y1, y0,   n0, n1, n2, n3';


end

