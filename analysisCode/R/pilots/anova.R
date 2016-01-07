# R scripts for running analyses on data for CFS


# preliminary changing of folders
setwd("D:/googleDrive/uMass/firstYear/behavioralExpts/pSadil/processDissociation/CFS/analysisCode/R")


wd <- getwd()

# find the data that was generated from the matlab files
objects_cfs <- read.csv("D:/googleDrive/uMass/firstYear/behavioralExpts/pSadil/processDissociation/CFS/analysisCode/matlab/Subject Data/currentVersion/pilotData/collected/objects_cfs.dat")


#--------------------------------------------------------------
# run repeated measure anova
#--------------------------------------------------------------

# NOTE: subject four of pilot data is from running PATRICK
     # and so is wonky in every way possible

# first, set data so that we're only looking at either the inclusion
# or exclusion trials

data.inclusion <- objects_cfs[objects_cfs$inclusion==1 & objects_cfs$subject<3,]
data.exclusion <- objects_cfs[objects_cfs$inclusion==0 & objects_cfs$subject<3,]

# cfs studied, different study responses, whether named or not
ex_cfs_zero <- data.exclusion[data.exclusion$condition==2 & data.exclusion$studyResp==0,]
ex_cfs_zero_named <- ex_cfs_zero[ex_cfs_zero$named==1,]
ex_cfs_zero_notNamed <- ex_cfs_zero[ex_cfs_zero$named==0,]
dim(ex_cfs_zero_named)[1]
dim(ex_cfs_zero_notNamed)[1]

dim(ex_cfs_zero_named)[1]/(dim(ex_cfs_zero_named)[1]+dim(ex_cfs_zero_notNamed)[1])

ex_cfs_one <- data.exclusion[data.exclusion$condition==2 & data.exclusion$studyResp==1,]
ex_cfs_one_named <- ex_cfs_one[ex_cfs_one$named==1,]
ex_cfs_one_notNamed <- ex_cfs_one[ex_cfs_one$named==0,]
dim(ex_cfs_one_named)[1]
dim(ex_cfs_one_notNamed)[1]

ex_cfs_two <- data.exclusion[data.exclusion$condition==2 & data.exclusion$studyResp==2,]
ex_cfs_two_named <- ex_cfs_two[ex_cfs_two$named==1,]
ex_cfs_two_notNamed <- ex_cfs_two[ex_cfs_two$named==0,]
dim(ex_cfs_two_named)[1]
dim(ex_cfs_two_notNamed)[1]

ex_cfs_three <- data.exclusion[data.exclusion$condition==2 & data.exclusion$studyResp==3,]
ex_cfs_three_named <- ex_cfs_three[ex_cfs_three$named==1,]
ex_cfs_three_notNamed <- ex_cfs_three[ex_cfs_three$named==0,]
dim(ex_cfs_three_named)[1]
dim(ex_cfs_three_notNamed)[1]


# binoc studied, different study responses, whether named or not
ex_binoc_zero <- data.exclusion[data.exclusion$condition==1 & data.exclusion$studyResp==0,]
ex_binoc_zero_named <- ex_binoc_zero[ex_binoc_zero$named==1,]
ex_binoc_zero_notNamed <- ex_binoc_zero[ex_binoc_zero$named==0,]
dim(ex_binoc_zero_named)[1]
dim(ex_binoc_zero_notNamed)[1]

dim(ex_binoc_zero_named)[1] / (dim(ex_binoc_zero_named)[1] + dim(ex_binoc_zero_notNamed)[1])


ex_binoc_one <- data.exclusion[data.exclusion$condition==1 & data.exclusion$studyResp==1,]
ex_binoc_one_named <- ex_binoc_one[ex_binoc_one$named==1,]
ex_binoc_one_notNamed <- ex_binoc_one[ex_binoc_one$named==0,]
dim(ex_binoc_one_named)[1]
dim(ex_binoc_one_notNamed)[1]

ex_binoc_two <- data.exclusion[data.exclusion$condition==1 & data.exclusion$studyResp==2,]
ex_binoc_two_named <- ex_binoc_two[ex_binoc_two$named==1,]
ex_binoc_two_notNamed <- ex_binoc_two[ex_binoc_two$named==0,]
dim(ex_binoc_two_named)[1]
dim(ex_binoc_two_notNamed)[1]

ex_binoc_three <- data.exclusion[data.exclusion$condition==1 & data.exclusion$studyResp==3,]
ex_binoc_three_named <- ex_binoc_three[ex_binoc_three$named==1,]
ex_binoc_three_notNamed <- ex_binoc_three[ex_binoc_three$named==0,]
dim(ex_binoc_three_named)[1]
dim(ex_binoc_three_notNamed)[1]


# foil studied, different study responses, whether named or not
ex_foil_zero <- data.exclusion[data.exclusion$condition==0 & data.exclusion$studyResp==0,]
ex_foil_zero_named <- ex_foil_zero[ex_foil_zero$named==1,]
ex_foil_zero_notNamed <- ex_foil_zero[ex_foil_zero$named==0,]
dim(ex_foil_zero_named)[1]
dim(ex_foil_zero_notNamed)[1]

dim(ex_foil_zero_named)[1] / (dim(ex_foil_zero_named)[1] + dim(ex_foil_zero_notNamed)[1])


ex_foil_one <- data.exclusion[data.exclusion$condition==0 & data.exclusion$studyResp==1,]
ex_foil_one_named <- ex_foil_one[ex_foil_one$named==1,]
ex_foil_one_notNamed <- ex_foil_one[ex_foil_one$named==0,]
dim(ex_foil_one_named)[1]
dim(ex_foil_one_notNamed)[1]

ex_foil_two <- data.exclusion[data.exclusion$condition==0 & data.exclusion$studyResp==2,]
ex_foil_two_named <- ex_foil_two[ex_foil_two$named==1,]
ex_foil_two_notNamed <- ex_foil_two[ex_foil_two$named==0,]
dim(ex_foil_two_named)[1]
dim(ex_foil_two_notNamed)[1]

ex_foil_three <- data.exclusion[data.exclusion$condition==0 & data.exclusion$studyResp==3,]
ex_foil_three_named <- ex_foil_three[ex_foil_three$named==1,]
ex_foil_three_notNamed <- ex_foil_three[ex_foil_three$named==0,]
dim(ex_foil_three_named)[1]
dim(ex_foil_three_notNamed)[1]



# ---------------------------------------
# inclusion!!!
# ----------------------------------------

# cfs studied, different study responses, whether named or not
in_cfs_zero <- data.inclusion[data.inclusion$condition==2 & data.inclusion$studyResp==0,]
in_cfs_zero_named <- in_cfs_zero[in_cfs_zero$named==1,]
in_cfs_zero_notNamed <- in_cfs_zero[in_cfs_zero$named==0,]
dim(in_cfs_zero_named)[1]
dim(in_cfs_zero_notNamed)[1]

dim(in_cfs_zero_named)[1]/(dim(in_cfs_zero_named)[1]+dim(in_cfs_zero_notNamed)[1])

in_cfs_one <- data.inclusion[data.inclusion$condition==2 & data.inclusion$studyResp==1,]
in_cfs_one_named <- in_cfs_one[in_cfs_one$named==1,]
in_cfs_one_notNamed <- in_cfs_one[in_cfs_one$named==0,]
dim(in_cfs_one_named)[1]
dim(in_cfs_one_notNamed)[1]

in_cfs_two <- data.inclusion[data.inclusion$condition==2 & data.inclusion$studyResp==2,]
in_cfs_two_named <- in_cfs_two[in_cfs_two$named==1,]
in_cfs_two_notNamed <- in_cfs_two[in_cfs_two$named==0,]
dim(in_cfs_two_named)[1]
dim(in_cfs_two_notNamed)[1]

in_cfs_three <- data.inclusion[data.inclusion$condition==2 & data.inclusion$studyResp==3,]
in_cfs_three_named <- in_cfs_three[in_cfs_three$named==1,]
in_cfs_three_notNamed <- in_cfs_three[in_cfs_three$named==0,]
dim(in_cfs_three_named)[1]
dim(in_cfs_three_notNamed)[1]














# -----------------------------------------------------------------------
# looking at Patrick's data, to make sure test worked
# -----------------------------------------------------------------------

data.patrick <- objects_cfs[objects_cfs$subject==3,]
dim(data.patrick)

patrick.in <- data.patrick[data.patrick$inclusion==1,]
patrick.ex <- data.patrick[data.patrick$inclusion==0,]


patrick.ex.named <- patrick.ex[patrick.ex$named==1,]

# this is equal to 49, which means it correctly recorded all of the ones
# that I named!
dim(patrick.ex.named)[1]


# cfs studied, different study responses, whether named or not
patrick.ex_cfs_zero <- patrick.ex[data.exclusion$condition==2 & data.exclusion$studyResp==0,]
patrick.ex_cfs_zero_named <- patrick.ex_cfs_three[ex_cfs_zero$named==1,]
patrick.ex_cfs_zero_notNamed <- patrick.ex_cfs_three[ex_cfs_zero$named==0,]
dim(patrick.ex_cfs_zero_named)[1]
dim(patrick.ex_cfs_zero_notNamed)[1]

ex_cfs_one <- data.exclusion[data.exclusion$condition==2 & data.exclusion$studyResp==1,]
ex_cfs_one_named <- ex_cfs_one[ex_cfs_one$named==1,]
ex_cfs_one_notNamed <- ex_cfs_one[ex_cfs_one$named==0,]
dim(ex_cfs_one_named)[1]
dim(ex_cfs_one_notNamed)[1]

ex_cfs_two <- data.exclusion[data.exclusion$condition==2 & data.exclusion$studyResp==2,]
ex_cfs_two_named <- ex_cfs_two[ex_cfs_two$named==1,]
ex_cfs_two_notNamed <- ex_cfs_two[ex_cfs_two$named==0,]
dim(ex_cfs_two_named)[1]
dim(ex_cfs_two_notNamed)[1]

ex_cfs_three <- data.exclusion[data.exclusion$condition==2 & data.exclusion$studyResp==3,]
ex_cfs_three_named <- ex_cfs_three[ex_cfs_three$named==1,]
ex_cfs_three_notNamed <- ex_cfs_three[ex_cfs_three$named==0,]
dim(ex_cfs_three_named)[1]
dim(ex_cfs_three_notNamed)[1]


# binoc studied, different study responses, whether named or not
ex_binoc_zero <- data.exclusion[data.exclusion$condition==1 & data.exclusion$studyResp==0,]
ex_binoc_zero_named <- ex_binoc_three[ex_binoc_zero$named==1,]
ex_binoc_zero_notNamed <- ex_binoc_three[ex_binoc_zero$named==0,]
dim(ex_binoc_zero_named)[1]
dim(ex_binoc_zero_notNamed)[1]

ex_binoc_one <- data.exclusion[data.exclusion$condition==1 & data.exclusion$studyResp==1,]
ex_binoc_one_named <- ex_binoc_one[ex_binoc_one$named==1,]
ex_binoc_one_notNamed <- ex_binoc_one[ex_binoc_one$named==0,]
dim(ex_binoc_one_named)[1]
dim(ex_binoc_one_notNamed)[1]

ex_binoc_two <- data.exclusion[data.exclusion$condition==1 & data.exclusion$studyResp==2,]
ex_binoc_two_named <- ex_binoc_two[ex_binoc_two$named==1,]
ex_binoc_two_notNamed <- ex_binoc_two[ex_binoc_two$named==0,]
dim(ex_binoc_two_named)[1]
dim(ex_binoc_two_notNamed)[1]

ex_binoc_three <- data.exclusion[data.exclusion$condition==1 & data.exclusion$studyResp==3,]
ex_binoc_three_named <- ex_binoc_three[ex_binoc_three$named==1,]
ex_binoc_three_notNamed <- ex_binoc_three[ex_binoc_three$named==0,]
dim(ex_binoc_three_named)[1]
dim(ex_binoc_three_notNamed)[1]












cfs.objects.aov <- aov(named ~ data='objects_cfs')
