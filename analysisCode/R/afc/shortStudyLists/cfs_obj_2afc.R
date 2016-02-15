# R scripts for running analyses on data for CFS
# psychPhys means that these data are from the early participants,
# trying to get psychophysical curves
library(ggplot2)


error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}


# preliminary changing of folders
setwd("D:/googleDrive/uMass/firstYear/behavioralExpts/pSadil/processDissociation/CFS/analysisCode/R/afc/shortStudyLists")

wd <- getwd()

dataFile <- paste(wd, "/cfs_obj_2afc_ss1.dat", sep="")
# find the data that was generated from the matlab files
data <- read.csv(dataFile)

# add 1 to study resp because participants were instructed to use 0-3
data$studyResp = data$studyResp+1
data$studyResp2 = data$studyResp2+1
data$studyResp3 = data$studyResp3+1

nConds = max(data$condition,na.rm=TRUE)
nPAS = max(data[data$studyResp < 1000,]$studyResp,na.rm=TRUE)
nItems = max(data$whichItem,na.rm=TRUE)
nSubs = max(data$subject,na.rm=TRUE)
nTrials = max(data$trial,na.rm=TRUE)

# number of items in each condition, first presentation
nPerCond = nItems/nConds


data$trial = as.factor(data$trial)
data$whichItem = as.factor(data$whichItem)
data$subject = as.factor(data$subject)
data$condition = as.factor(data$condition)
#data$condition = as.numeric(data$condition)
# don't want PAS as a factor, because there are 
# vastly different numbers of each kind of response
# Do I want condition as factor? if it were, that would
# seem to make stronger claims (justified) about higher levels
# leading to higher recall rates
studyConds <- c("foil","word","cfs","binoc")
cols <- c('black', 'cornflowerblue', 'darkgoldenrod1', 'red')

# trim away missing values (there aren't, currently)
data_trim <- na.omit(data)

cutoff = 3
nPresent = 3
nStudy = nTrials * nPresent
#--------------------------------------------------------------
# look at some summaries
#--------------------------------------------------------------


# look at recal rates broken up by pas/cond, collapsed across subs

rRates.pasCond_mean = matrix(0,ncol=nConds,nrow=nPAS)
rRates.pasCond_sem = matrix(0,ncol=nConds,nrow=nPAS)
rRates.pasCond_n = matrix(0,ncol=nConds,nrow=nPAS)
for (cond in 1:nConds) {
  for (pas in 1:nPAS) {
    
    rRates.pasCond_mean[cond,pas] <- 
      mean(data_trim[data_trim$condition==cond &
                       data_trim$studyResp==pas,]$named,
           na.rm=TRUE)
    
    rRates.pasCond_n[cond,pas] <- 
      dim(data_trim[data_trim$condition==cond & 
                      data_trim$studyResp==pas,])[1]
    
    # var = n*p*(1-p)
    rRates.pasCond_sem[cond,pas] <-
      sqrt(rRates.pasCond_n[cond,pas] * rRates.pasCond_mean[cond,pas] * 
             (1- rRates.pasCond_mean[cond,pas])) / 
      sqrt(rRates.pasCond_n[cond,pas])
    
  }
}
# nas are being counted multiple times (total of 21 na trials)

# rRates.pasCond_mean
# rRates.pasCond_sem
# rRates.pasCond_n
# 
# 
# # do the study conditions contribute to PAS response, for first presentation?
# t.test(data[data$presentation==1 & data$condition==1,]$studyResp,
#        data[data$presentation==1 & data$condition==4,]$studyResp,
#        alternative="two.sided",
#        paired=FALSE,
#        na.rm=TRUE)


par(mfrow=c(1,1))
pasResps <- c("0","1","2","3")
pasCond.bp <- barplot(t(rRates.pasCond_mean),
                      beside=TRUE,
                      names.arg=studyConds,
                      ylim=c(0,1),
                      #col=presentCol,
                      legend.text=pasResps,
                      args.legend = list(x="topleft"),
                      xlab = "study length",
                      ylab = "proportion named"
                      
)
error.bar(pasCond.bp,t(rRates.pasCond_mean),
          t(rRates.pasCond_sem))


rRates.pasCond_n.prop = matrix(0,nrow=4,ncol=4)
for (cond in 1:nConds) {
  for (pas in 1:nPAS){
    rRates.pasCond_n.prop[cond,pas] <- 
      rRates.pasCond_n[cond,pas] / 
      sum(rRates.pasCond_n[cond,])
    
  }
}


par(mfrow=c(1,1))
# looking at raw numbers of each PAS per condition
pasCond_n.bp <- barplot(t(rRates.pasCond_n.prop),
                        beside=TRUE,
                        names.arg=studyConds,
                        ylim=c(0,1),
                        #col=presentCol,
                        legend.text=pasResps,
                        args.legend = list(x="topleft"),
                        xlab = "study length",
                        ylab = "proportion of resposnes"
)


pasCond_n.aov<-aov(studyResp ~ condition + Error(subject/condition),data=data_trim)
summary(pasCond_n.aov)


# ---------------------------------------
# look at combined scatters, next
# --------------------------------------

# look at recal rates for pas < cutoff, collapsed across subs
rRates.cond_mean = matrix(0,nrow=nConds,ncol=2)
rRates.cond_sem = matrix(0,nrow=nConds,ncol=2)
rRates.cond_n = matrix(0,nrow=nConds,ncol=2)
for (cond in 1:nConds) {
  
  if (cond == 3){
    rRates.cond_mean[cond,1] <- 
      mean(data_trim[data_trim$condition==cond &
                       (data_trim$studyResp < cutoff),]$named,
           na.rm=TRUE)
    
    rRates.cond_n[cond,1] <- 
      dim(data_trim[data_trim$condition==cond & 
                      (data_trim$studyResp < cutoff ),])[1]
    
    rRates.cond_mean[cond,2] <- 
      mean(data_trim[data_trim$condition==cond &
                       (data_trim$studyResp2 < cutoff),]$named,
           na.rm=TRUE)
    
    rRates.cond_n[cond,2] <- 
      dim(data_trim[data_trim$condition==cond & 
                      (data_trim$studyResp2 < cutoff ),])[1]
    
  } else {
    rRates.cond_mean[cond,] <- 
      mean(data_trim[data_trim$condition==cond,]$named,
           na.rm=TRUE)
    
    rRates.cond_n[cond,] <- 
      dim(data_trim[data_trim$condition==cond,])[1]
  }
  
  # var = n*p*(1-p)
  rRates.cond_sem[cond,] <-
    sqrt(rRates.cond_n[cond,] * rRates.cond_mean[cond,] * 
           (1- rRates.cond_mean[cond,])) / 
    sqrt(rRates.cond_n[cond,])
  
}

# look at 2afc rates for pas < 3, collapsed across subs
afcRates.cond_mean = matrix(0,nrow=nConds,ncol=2)
afcRates.cond_sem = matrix(0,nrow=nConds,ncol=2)
afcRates.cond_n = matrix(0,nrow=nConds,ncol=2)
for (cond in 1:nConds) {
  
  if (cond == 3){
    afcRates.cond_mean[cond,1] <- 
      mean(data_trim[data_trim$condition==cond &
                       (data_trim$studyResp < cutoff),]$afc,
           na.rm=TRUE)
    
    afcRates.cond_n[cond,1] <- 
      dim(data_trim[data_trim$condition==cond & 
                      (data_trim$studyResp < cutoff ),])[1]
    
    # second presentation
    afcRates.cond_mean[cond,2] <- 
      mean(data_trim[data_trim$condition==cond &
                       (data_trim$studyResp2 < cutoff),]$afc,
           na.rm=TRUE)
    
    afcRates.cond_n[cond,2] <- 
      dim(data_trim[data_trim$condition==cond & 
                      (data_trim$studyResp2 < cutoff ),])[1]
    
  } else {
    afcRates.cond_mean[cond,] <- 
      mean(data_trim[data_trim$condition==cond,]$afc,
           na.rm=TRUE)
    
    afcRates.cond_n[cond,] <- 
      dim(data_trim[data_trim$condition==cond,])[1]
  }
  
  # var = n*p*(1-p)
  afcRates.cond_sem[cond,] <-
    sqrt(afcRates.cond_n[cond,] * afcRates.cond_mean[cond,] * 
           (1- rRates.cond_mean[cond,])) / 
    sqrt(afcRates.cond_n[cond,])
  
}

par(mfrow=c(1,1))
new <- plot(afcRates.cond_mean[,1],rRates.cond_mean[,1]
            , xlim = c(0,1)
            , ylim = c(0,1)
            , col = cols
            , xlab = 'prop 2afc correct'
            , ylab = 'recall rate'
            , main = 'PAS < 3 (firstPresent), subs > 50% respond'
)
legend("topleft", legend = studyConds,
       col=cols,pch = 1,bty="n")




par(mfrow=c(1,1))
new <- plot(afcRates.cond_mean[,2],rRates.cond_mean[,2]
            , xlim = c(0,1)
            , ylim = c(0,1)
            , col = cols
            , xlab = 'prop 2afc correct'
            , ylab = 'recall rate'
            , main = 'PAS < 3 (secondPresent), subs > 50% respond'
)
legend("topleft", legend = studyConds,
       col=cols,pch = 1,bty="n")
# error bars for recall
arrows(afcRates.cond_mean
       , afcRates.cond_mean-rRates.cond_sem
       , afcRates.cond_mean
       , afcRates.cond_mean+rRates.cond_sem
       , length=0.05
       , angle=90
       , code=3
)
# error bars for afc
arrows(afcRates.cond_mean-afcRates.cond_sem
       , rRates.cond_mean
       , afcRates.cond_mean+afcRates.cond_sem
       , rRates.cond_mean
       , length=0.05
       , angle=90
       , code=3
)




# ---------------------------------------------------
pasResps <- c("0","1","2","3")
pas.bp <- barplot(recalRates.mean_pas,
                  beside=TRUE,
                  names.arg=pasResps,
                  ylim=c(0,1)
                  #col=presentCol,
                  #legend.text=presentConds,
                  #args.legend = list(x="bottomright")
)

error.bar(pas.bp,recalRates.mean_pas,
          recalRates.sem_pas)

#--------------------------------------------------------------
# make individual subject graphs
#--------------------------------------------------------------

# ---------------------------------------
# look at combined scatters
# --------------------------------------

# look at recal rates for pas < 3, collapsed across subs
rRates_sub.cond_mean = array(0,dim=c(nConds,nSubs,2))
rRates_sub.cond_sem = array(0,dim=c(nConds,nSubs,2))
rRates_sub.cond_n = array(0,dim=c(nConds,nSubs,2))
for (cond in 1:nConds) {
  for (sub in 1:nSubs){
    
    if (cond == 3){
      rRates_sub.cond_mean[cond,sub,1] <- 
        mean(data_trim[data_trim$condition==cond &
                         (data_trim$studyResp < cutoff)
                       & data_trim$subject==sub,]$named,
             na.rm=TRUE)
      
      rRates_sub.cond_n[cond,sub,1] <- 
        dim(data_trim[data_trim$condition==cond & 
                        (data_trim$studyResp < cutoff)
                      & data_trim$subject==sub,])[1]
      
      # second presentation
      rRates_sub.cond_mean[cond,sub,2] <- 
        mean(data_trim[data_trim$condition==cond &
                         (data_trim$studyResp2 < cutoff)
                       & data_trim$subject==sub,]$named,
             na.rm=TRUE)
      
      rRates_sub.cond_n[cond,sub,2] <- 
        dim(data_trim[data_trim$condition==cond & 
                        (data_trim$studyResp2 < cutoff)
                      & data_trim$subject==sub,])[1]
      
    } else {
      rRates_sub.cond_mean[cond,sub,] <- 
        mean(data_trim[data_trim$condition==cond
                       & data_trim$subject==sub,]$named,
             na.rm=TRUE)
      
      rRates_sub.cond_n[cond,sub,] <- 
        dim(data_trim[data_trim$condition==cond
                      & data_trim$subject==sub,])[1]
    }
    
    # var = n*p*(1-p)
    rRates_sub.cond_sem[cond,sub,1] <-
      sqrt(rRates_sub.cond_n[cond,sub,1] * rRates_sub.cond_mean[cond,sub,1] * 
             (1- rRates_sub.cond_mean[cond,sub,1])) / 
      sqrt(rRates_sub.cond_n[cond,sub,1])
    
    # second present
    rRates_sub.cond_sem[cond,sub,2] <-
      sqrt(rRates_sub.cond_n[cond,sub,2] * rRates_sub.cond_mean[cond,sub,2] * 
             (1- rRates_sub.cond_mean[cond,sub,2])) / 
      sqrt(rRates_sub.cond_n[cond,sub,2])
  }
}

# look at 2afc rates for pas < 3, collapsed across subs
afcRates_sub.cond_mean = array(0,dim=c(nConds,nSubs,2))
afcRates_sub.cond_sem = array(0,dim=c(nConds,nSubs,2))
afcRates_sub.cond_n = array(0,dim=c(nConds,nSubs,2))
for (cond in 1:nConds) {
  for(sub in 1:nSubs){
    if (cond == 3){
      afcRates_sub.cond_mean[cond,sub,1] <- 
        mean(data_trim[data_trim$condition==cond &
                         (data_trim$studyResp < cutoff)
                       & data_trim$subject==sub,]$afc,
             na.rm=TRUE)
      
      afcRates_sub.cond_n[cond,sub,1] <- 
        dim(data_trim[data_trim$condition==cond & 
                        (data_trim$studyResp < cutoff )
                      & data_trim$subject==sub,])[1]
      
      # second present
      afcRates_sub.cond_mean[cond,sub,2] <- 
        mean(data_trim[data_trim$condition==cond &
                         (data_trim$studyResp2 < cutoff)
                       & data_trim$subject==sub,]$afc,
             na.rm=TRUE)
      
      afcRates_sub.cond_n[cond,sub,2] <- 
        dim(data_trim[data_trim$condition==cond & 
                        (data_trim$studyResp2 < cutoff )
                      & data_trim$subject==sub,])[1]
      
    } else {
      afcRates_sub.cond_mean[cond,sub,] <- 
        mean(data_trim[data_trim$condition==cond
                       & data_trim$subject==sub,]$afc,
             na.rm=TRUE)
      
      afcRates_sub.cond_n[cond,sub,] <- 
        dim(data_trim[data_trim$condition==cond
                      & data_trim$subject==sub,])[1]
    }
    
    # var = n*p*(1-p)
    afcRates_sub.cond_sem[cond,sub,1] <-
      sqrt(afcRates_sub.cond_n[cond,sub,1] * afcRates_sub.cond_mean[cond,sub,1] * 
             (1- rRates_sub.cond_mean[cond,sub,1])) / 
      sqrt(afcRates_sub.cond_n[cond,sub,1])
    
    # second present
    afcRates_sub.cond_sem[cond,sub,2] <-
      sqrt(afcRates_sub.cond_n[cond,sub,2] * afcRates_sub.cond_mean[cond,sub,2] * 
             (1- rRates_sub.cond_mean[cond,sub,2])) / 
      sqrt(afcRates_sub.cond_n[cond,sub,2])
  }
}

par(mfrow=c(3,3))
for (sub in 1:nSubs){
  
  plot(afcRates_sub.cond_mean[,sub,1],rRates_sub.cond_mean[,sub,1]
       , xlim = c(0,1)
       , ylim = c(0,1)
       , col = cols
       , xlab = 'prop 2afc correct'
       , ylab = 'recall rate'
       , main = c('sub', as.character(sub))
  )
  #legend("topleft", legend = studyConds,
  #      col=cols,pch = 1,bty="n")
  
}











par(mfrow=c(5,4))

# look at recal rates broken up by pas/presentation, across all conditions,
recalRates.mean_pas.sub = matrix(0,nrow=nPAS,ncol=nSubs)
recalRates.sem_pas.sub = matrix(0,nrow=nPAS,ncol=nSubs)
recalRates.n_pas.sub = matrix(0,nrow=nPAS,ncol=nSubs)
for (pas in 1:nPAS) {
  for (sub in 1:nSubs) {
    recalRates.mean_pas.sub[pas,sub] <- 
      mean(data[data$studyResp==pas & data$subject==sub,]$named,
           na.rm=TRUE)
    
    recalRates.n_pas.sub[pas,sub] <- 
      dim(data[data$studyResp==pas & data$subject==sub,])[1]
    
    # var = n*p*(1-p)
    recalRates.sem_pas.sub[pas,sub] <-
      sqrt(recalRates.n_pas.sub[pas,sub] * 
             recalRates.mean_pas.sub[pas,sub] * 
             (1- recalRates.mean_pas.sub[pas,sub])) / 
      sqrt(recalRates.n_pas.sub[pas,sub])
    
  }
}
recalRates.mean_pas.sub
recalRates.n_pas.sub



error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=0, length=length, ...)
}

par(mfrow=c(3,3))
for (sub in 1:nSubs){
  
  bp<-barplot(recalRates.mean_pas.sub[,sub]
              , beside=TRUE
              , names.arg=pasResps
              , ylim=c(0,1)
              , ylab = "proportion of resposnes"
              #col=presentCol,
              #legend.text=presentConds,
              #args.legend = list(x="bottomright")
  )
  
  error.bar(bp,recalRates.mean_pas.sub[,sub],
            recalRates.sem_pas.sub[,sub])
  
}

#---------------------------------------------------------------

# look at recal rates broken up by pas/presentation, across all conditions,
recalRates.mean_cond.sub = matrix(0,nrow=nConds,ncol=nSubs)
recalRates.sem_cond.sub = matrix(0,nrow=nConds,ncol=nSubs)
for (cond in 1:nConds) {
  for (sub in 1:nSubs) {
    recalRates.mean_cond.sub[cond,sub] <- 
      mean(data[data$studyResp==cond & data$subject==sub,]$named,
           na.rm=TRUE)
    
    howMany = dim(data[data$studyResp==cond & data$subject==sub,])[1]
    
    # var = n*p*(1-p)
    recalRates.sem_cond.sub[cond,sub] <-
      sqrt(howMany * recalRates.mean_cond.sub[cond,sub] * 
             (1- recalRates.mean_cond.sub[cond,sub])) / 
      sqrt(howMany)
    
  }
}



# back to proportion of PAS responses by condition

rRates.mean_pasCond.sub = array(0,dim=c(nConds,nPAS,nSubs))
rRates.sem_pasCond.sub = array(0,dim=c(nConds,nPAS,nSubs))
rRates.n_pasCond.sub = array(0,dim=c(nConds,nPAS,nSubs))
for (cond in 1:nConds) {
  for (pas in 1:nPAS) {
    for (sub in 1:nSubs) {
      
      rRates.mean_pasCond.sub[cond,pas,sub] <- 
        mean(data_trim[data_trim$condition==cond &
                         data_trim$studyResp==pas &
                         data_trim$subject == sub 
                       ,]$named,
             na.rm=TRUE)
      
      rRates.n_pasCond.sub[cond,pas,sub] <- 
        dim(data_trim[data_trim$condition==cond & 
                        data_trim$studyResp==pas &
                        data_trim$subject == sub 
                      ,])[1]
      
      # var = n*p*(1-p)
      rRates.sem_pasCond.sub[cond,pas,sub] <-
        sqrt(rRates.n_pasCond.sub[cond,pas,sub] * 
               rRates.mean_pasCond.sub[cond,pas,sub] * 
               (1- rRates.mean_pasCond.sub[cond,pas,sub])) / 
        sqrt(rRates.n_pasCond.sub[cond,pas,sub])  
    }
  }
}

par(mfrow=c(3,3))
for (sub in 1:nSubs) { 
  pasCond.sub.bp <- barplot(t(rRates.mean_pasCond.sub[,,sub]),
                            beside=TRUE,
                            names.arg=studyConds,
                            ylim=c(0,1),
                            #col=presentCol,
                            #legend.text=pasResps,
                            #args.legend = list(x="bottomright"),
                            main = c('Subject',sub),
                            xlab = "study duration",
                            ylab = "mean named"
  )
}





# dividing those n up in to proportion of resposnes
rRates.n_pasCond.prop.sub = array(0,dim=c(nConds,nPAS,nSubs))
for (cond in 1:nConds) {
  for (pas in 1:nPAS){
    for (sub in 1:nSubs) {
      rRates.n_pasCond.prop.sub[cond,pas,sub] <- 
        rRates.n_pasCond.sub[cond,pas,sub] / 
        sum(rRates.n_pasCond.sub[cond,,sub])
    }
  }
}


# looking at raw numbers of each PAS per condition, by subject
par(mfrow=c(3,3))
for (sub in 1:nSubs) { 
  pasCond_prop.sub.bp <- barplot(t(rRates.n_pasCond.prop.sub[,,sub]),
                                 beside=TRUE,
                                 names.arg=studyConds,
                                 ylim=c(0,1),
                                 #col=presentCol,
                                 #legend.text=pasResps,
                                 #args.legend = list(x="bottomright"),
                                 main = c('Subject',sub),
                                 xlab = "study duration",
                                 ylab = "proportion of responses"
  )
}







for (sub in 1:nSubs){
  
  bp<-barplot(recalRates.mean_cond.sub[,,sub],
              beside=TRUE,
              names.arg=studyConds,
              ylim=c(0,1)
              #col=presentCol,
              #legend.text=presentConds,
              #args.legend = list(x="bottomright")
  )
  
  error.bar(bp,recalRates.mean_pas.sub[,,sub],
            recalRates.sem_pas.sub[,,sub])
  
}


rRates.n_pasCond.prop = matrix(0,nrow=4,ncol=4)
for (cond in 1:nConds) {
  for (pas in 1:nPAS){
    rRates.n_pasCond.prop[cond,pas] <- 
      rRates.n_pasCond[cond,pas] / 
      sum(rRates.n_pasCond[cond,])
    
  }
}





#--------------------------------------------------------------
# look at PAS responses by item
#--------------------------------------------------------------

# fully broken down
rRates.mean_cond.item = array(0,dim=c(nConds,nPAS,nItems))
rRates.sem_cond.item = array(0,dim=c(nConds,nPAS,nItems))
rRates.n_cond.item = array(0,dim=c(nConds,nPAS,nItems))
for (cond in 1:nConds){
  for (pas in 1:nPAS) {
    for (item in 1:nItems) {
      
      rRates.mean_cond.item[cond,pas,item] <- 
        mean(data[data$condition==cond
                  & data$studyResp==pas
                  & data$whichItem==item,]$named,
             na.rm=TRUE)
      
      rRates.n_cond.item[cond,pas,item] <- 
        dim(data[data$condition==cond
                 & data$studyResp==pas
                 & data$whichItem==item,])[1]
      
      # var = n*p*(1-p)
      rRates.sem_cond.item[cond,pas,item] <-
        sqrt(rRates.n_cond.item[cond,pas,item] * 
               rRates.mean_cond.item[cond,pas,item] * 
               (1- rRates.mean_cond.item[cond,pas,item])) / 
        sqrt(rRates.n_cond.item[cond,pas,item])
      
    }
  }
}
rRates.n_cond.item



par(mfrow=c(2,2))
# searching for correlations between .5 and 2 sec presentation
hist(rRates.n_cond.item[1,,]
     #xlim=c(0,1),
     #ylim=c(0,1),
     #main="proportion of item named, counfounded"
     #, ylab = "PAS 0"
     #, xlab = "PAS 3"
)




pas.mean_cfs.item = array(999,c(nPresent,nSubs,nItems))
pas.sem_cfs.item = array(999,c(nPresent,nSubs,nItems))
pas.n_cfs.item = array(999,c(nPresent,nSubs,nItems))
for (sub in 1:nSubs){
  for (item in 1:nItems) {
    
    # first present
    pas.mean_cfs.item[1,sub,item] <- 
      mean(data[data$condition==3
                & data$subject==sub
                & data$whichItem==item,]$studyResp-1,
           na.rm=TRUE)
    
    pas.n_cfs.item[1,sub,item] <- 
      dim(data[data$condition==3
               & data$subject==sub
               & data$whichItem==item,])[1]
    
    # var = n*p*(1-p)
    pas.sem_cfs.item[1,sub,item] <-
      sqrt(pas.n_cfs.item[1,sub,item] * 
             pas.mean_cfs.item[1,sub,item] * 
             (1- pas.mean_cfs.item[1,sub,item])) / 
      sqrt(pas.n_cfs.item[1,sub,item])
    
    # second present
    pas.mean_cfs.item[2,sub,item] <- 
      mean(data[data$condition==3
                & data$subject==sub
                & data$whichItem==item,]$studyResp2-1,
           na.rm=TRUE)
    
    pas.n_cfs.item[2,sub,item] <- 
      dim(data[data$condition==3
               & data$subject==sub
               & data$whichItem==item,])[1]
    
    pas.sem_cfs.item[2,sub,item] <-
      sqrt(pas.n_cfs.item[2,sub,item] * 
             pas.mean_cfs.item[2,sub,item] * 
             (1- pas.mean_cfs.item[2,sub,item])) / 
      sqrt(pas.n_cfs.item[2,sub,item])
  }
  
}
pas.mean_cfs.item
pas.sem_cfs.item
pas.n_cfs.item

pas_item_plot = matrix(0,nrow=nPresent,ncol=nItems)
for (trl in 1:nTrials){
  if(!is.na(pas.mean_cfs.item[,trl])){
    pas_item_plot[,trl] <- pas.mean_cfs.item[,trl]
  }
}


par(mfrow=c(1,1))
df <- data.frame(first = na.omit(pas.mean_cfs.item[1,]),second = na.omit(pas.mean_cfs.item[2,]))
numPlot <- ggplot(data = df,aes(x = first,y = second)) + stat_sum()
numPlot + ggtitle("mean PAS, items under cfs")

numPlot<-ggplot(data = df,aes(x = first,y = second)) + stat_sum(aes(size = ..n..))
numPlot + ggtitle("mean PAS, items under cfs")


plot(pas_item_plot[1,],pas_item_plot[2,],
     xlim=c(0,4),
     ylim=c(0,4),
     main="mean PAS, for each item"
     , ylab = "first present"
     , xlab = "second present"
)




pas.mean_cfs.item = array(999,c(nPresent,nSubs,nItems))
pas.n_cfs.item = array(999,c(nPresent,nSubs,nItems))
for (sub in 1:nSubs){
  for (item in 1:nItems) {
    
    if (data[data$whichItem==item
             & data$subject==sub
             ,]$condition==3){
      
      # first present
      pas.mean_cfs.item[1,sub,item] <- 
        data[data$condition==3
             & data$subject==sub
             & data$whichItem==item,]$studyResp-1
      
      pas.n_cfs.item[1,sub,item] <- 
        dim(data[data$condition==3
                 & data$subject==sub
                 & data$whichItem==item,])[1]
      
      
      # second present
      pas.mean_cfs.item[2,sub,item] <- 
        data[data$condition==3
             & data$subject==sub
             & data$whichItem==item,]$studyResp2-1
      
      pas.n_cfs.item[2,sub,item] <- 
        dim(data[data$condition==3
                 & data$subject==sub
                 & data$whichItem==item,])[1]
    }
  }
  
}

pas_sub_item_plot = array(999,c(nPresent,50*nSubs))
item = 0
for (sub in 1:nSubs){
  for (trl in 1:nItems){
    
    if((pas.mean_cfs.item[,sub,trl])!=999){
      item = item+1
      pas_sub_item_plot[,item] <- pas.mean_cfs.item[,sub,trl]
    }
  }
}


par(mfrow=c(1,1))
df <- data.frame(first = pas_sub_item_plot[1,]
                 ,second = pas_sub_item_plot[2,]
                 ,sub=rep(1:6,each=50))

numPlot<-ggplot(data = df,aes(x = first,y = second)) + stat_sum(aes(size = ..n..))
numPlot + ggtitle("mean PAS, items under cfs")




# conditional probability

pasCondi.mean.item = array(999,c(nSubs,nPAS,nItems))
pasCondi.n.item = array(999,c(nSubs,nPAS,nItems))
for (sub in 1:nSubs){
  for (pas in 1:nConds){
    for (item in 1:nItems) {
      
      if (length(data[data$whichItem==item
                      & data$subject==sub
                      & data$condition==3
                      ,]$studyResp==pas)!=0 
          && data[data$whichItem==item
                 & data$subject==sub
                 & data$condition==3
                 ,]$studyResp==pas) {
        
        
        # given first resp of pas, what was second?
        pasCondi.mean.item[sub,pas,item] <- 
          data[data$studyResp==pas
               & data$condition==3
               & data$subject==sub
               & data$whichItem==item,]$studyResp2-1
        
        pasCondi.n.item[sub,pas,item] <- 
          dim(data[data$studyResp==pas
                   & data$condition==3
                   & data$subject==sub
                   & data$whichItem==item,])[1]
        
      }
    }
  }
}

pas_condi_plot = array(999,c(50*nSubs,nPAS))
item = 0
for (sub in 1:nSubs){
  for (pas in 1:nPAS){
    for (trl in 1:nItems){
      
      if(!is.na(pasCondi.mean.item[sub,pas,trl])){
        if((pasCondi.mean.item[sub,pas,trl])!=999){
          item = item+1
          pas_condi_plot[item,pas] <- pasCondi.mean.item[sub,pas,trl]
        }
      }
    }
  }
}

# final form?
tally <- array(0,c(nPAS,nPAS))
sum(pas_condi_plot[,1]==3)

for (pas in 1:nPAS){
  for(sec in 1:nPAS){
  tally[pas,sec] <- sum(pas_condi_plot[,pas]==sec-1)
  }
}


barplot(t(tally)
        , beside = TRUE
        , main = "num(PAS_2 | PAS_1)"
        , legend.text = c('to 0', 'to 1', 'to 2', 'to 3')
        , args.legend = list(x="topleft")
        , names.arg = c('0', '1', '2', '3')
)

tally_prop <- tally/rowSums(tally)

barplot(t(tally_prop)
        , beside = TRUE
        , main = "p(PAS_2 | PAS_1)"
        , ylim = c(0,1)
        , legend.text = c('to 0', 'to 1', 'to 2', 'to 3')
        , args.legend = list(x="topleft")
        , names.arg = c('0', '1', '2', '3')
)

