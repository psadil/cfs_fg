This folder contains the necessary files to run a behavioral version of the
process dissociation procedure for visual recollection. During test, all items
will be aperture stimuli. However, there are three different study conditions. 
First, baseline in which the object isn't studied (foil). Binoc codintion =>
study with both eyes (should increase episodic recollection). CFS condition =>
study while masked under CFS (should increase only visual recollection). 

Analysis will be done based on state-trace style plot of Inclusion vs Exclusion
 -> will probably want to include classic vis recollection vs epi recollection, 
	but the main thrust will be simple, uncalculated rates during In and Ex

***************************************************************************
FOLDER STRUCTURE:

admin -> useful files for working with RAs (including consent forms)
analysisCode -> MATLAB and R files for working with subjectData
cfs_allExpts -> the actual experimental files


***************************************************************************

january 7, 2016
ps


afc_shortStudyLists -> in an effort to increase the strength of the cfs condition
   the study lists are now being presented in blocks of 16



***************************************************************************
september 20, 2015
ps

UPDATES:

1) Changed number of possible responses during study phase to 4, following PAS
scale (see Sandberg et al 2014).

2) non-dominant eye now receives image size white square during foil trials
2.1) final alpha of images now set to 90, not 100

TO FIX
1) apparently, only numpad responses work


***************************************************************************

August 17, 2015
ps

UPDATES MAJOR: no longer including CFS+binoc study condition, and all items are
only presented Once!
 -> This means that the number of items has been increased from 96 -> 120

-Out of fear that writing the names of the binoc
   items in the study phase forces a massively deeper depth of processing than
   the items that were successfully masked, the study response is now much simpler.
   Subjects now only respond with 0==nothing, 1 == something, 2==could name


***************************************************************************
August 6, 2015
ps

fixes:
->tweaked some of the instructions around
--->NOTE, still unsure how to tell people to not adopt unexpected strategies
->stimulus names now correct
->ALL stimuli are presented with transparent backgrounds




***************************************************************************
August 4, 2015
ps
Last week, CFS routine was altered to better mask the stimuli

Stimuli have been changed such that they are presented much smaller, and with no
background

NOTE: still need to make list of stimulus names

***************************************************************************
July 17, 2015
ps

Ran Tara last night, code worked well enough
NOTES: 
->need to make sure that subjects don't just never use the names of items
  that they studied when attempting to name apertures during the exclusion
  trials

FIXED:
-> p.testOrder and p.itemCondition_test are now 1x96 vectors instead of 2x48  


***************************************************************************
June 11, 2015
ps

wrote a bunch since last time. will need to test on acutal computers. 
TO WRITE: 
-> instruction
-> do mondrians even work?

***************************************************************************
June 8, 2015

ps

wrote createStimSequence
NOTE: make SURE that the balance of the stimuli is actually correct
     It would be so nice to get to use even the early test subjects...
     
As of the end of today, most ot the randomizing has been completed with createStimSequence (but, see NOTE). The next task will be to figure out how to generate all of the necessary textures before their use (see last section of createStimSequence). For help, use runPhobia_snake as template. It will be tricky to make sure that the necessary textures line up to the randomization defined earlier in the function.     