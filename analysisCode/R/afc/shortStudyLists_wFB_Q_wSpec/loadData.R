# load data for CFS, 2AFC, Short Study Lists, FB, Q

source("D:/Documents/R/fns.R")

setwd("D:/documents/uMass/firstYear/behavioralExpts/cfs_fg/analysisCode/R/afc/shortStudyLists_wFB_Q")
wd <- getwd()


require(dplyr)

dataFile <- paste(wd, "/cfs_afc_ss1_wFB_Q_noCheck.dat", sep="")
# find the data that was generated from the matlab files
data_test <- read.csv(dataFile)

dataFile <- paste(wd, "/cfs_afc_ss1_wFB_Q_noCheck_study.dat", sep="")
# find the data that was generated from the matlab files
data_study <- read.csv(dataFile)

# join by subject, and item
data <- inner_join(x=data_test,y=data_study, by=c('whichItem','subject')) %>%
  rename(., condition=condition.x) %>%
  mutate(., pas1 = plyr::mapvalues(studyResp, from=0:9, to=c(-1,3,2,1,0,0,1,2,3,NA))) %>%
  mutate(., pas2 = plyr::mapvalues(studyResp2, from=0:9, to=c(-1,3,2,1,0,0,1,2,3,NA))) %>%
  mutate(., condition = plyr::mapvalues(condition, from=1:4, to=c('a_foil','b_word','c_cfs','d_binocular')))



nS <- lapply(data, FUN = max, na.rm=TRUE)

# add 1 to study resp because participants were instructed to use 0-3
nS$pas1 <- nS$pas1+1
nS$nPerCond <- nS$nItems / nS$nConds 
nS$nStudy = nS$nTrials * nS$nPresent


data <- mutate(data, pas1 = plyr::mapvalues(pas1, from=c(-1,NA), c('NR','fNS'))) %>%
  mutate(., pas2 = plyr::mapvalues(pas2, from=c(-1,NA), c('NR','fNS')))


data[,c('subject','condition','whichItem','studyResp','studyResp2','pas1','pas2','list','whichSide','whichResp')] <- lapply(data[,c('subject','condition','whichItem','studyResp','studyResp2','pas1','pas2','list','whichSide','whichResp')], FUN=factor)



# don't want PAS as a factor, because there are 
# vastly different numbers of each kind of response
# Do I want condition as factor? if it were, that would
# seem to make stronger claims (justified) about higher levels
# leading to higher recall rates
studyConds <- c("foil","word","cfs","binoc")
cols <- c('black', 'cornflowerblue', 'darkgoldenrod1', 'red')
pasResps <- c("0","1","2","3")


cutoff = 3 # only look at CFS with PAS 2 or 1
nPresent = 3 # presented 3 times

pd <- position_dodge(width = 1)
detach(package:dplyr)


