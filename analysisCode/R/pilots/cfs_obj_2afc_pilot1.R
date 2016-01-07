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
setwd("D:/googleDrive/uMass/firstYear/behavioralExpts/pSadil/processDissociation/CFS/analysisCode/R")

wd <- getwd()

dataFile <- paste(wd, "/cfs_obj_2afc_pilot1.dat", sep="")
# find the data that was generated from the matlab files
data <- read.csv(dataFile)

# add 1 to study resp because participants were instructed to use 0-3
data$studyResp = data$studyResp+1


nConds = max(data$condition,na.rm=TRUE)
nPAS = max(data$studyResp,na.rm=TRUE)
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
studyConds <- c(".5","1","1.5","2")

# trim away missing values (there aren't, currently)
data_trim <- na.omit(data)

#--------------------------------------------------------------
# look at some summaries
#--------------------------------------------------------------


# proportion recalled by study condition (first presentation)


#sum(data[data$condition==0 & data$trial<=120,]$named) /
#  length(data[data$condition==0 & data$trial<=120,]$named)

par(mfrow=c(1,1))

# collect mean recal rate for each condition, across all pas
recalRates.mean_cond = rep(0,times=nConds)
recalRates.sem_cond = rep(0,times=nConds)
recalRates.n_cond = rep(0,times=nConds)
  for (cond in 1:nConds) {
    recalRates.mean_cond[cond] <- 
      mean(data_trim[data_trim$condition==cond,]$named,
           na.rm=TRUE)
    
    recalRates.n_cond[cond] <-
      dim(data_trim[data_trim$condition==cond,])[1]
    
    # var = n*p*(1-p)
    recalRates.sem_cond[cond] <-
      sqrt(recalRates.n_cond[cond] * recalRates.mean_cond[cond] * 
             (1- recalRates.mean_cond[cond])) / 
      sqrt(recalRates.n_cond[cond])
    
    
  }
# filled with 330, because it is 11*30
recalRates.n_cond




presentCol=c('red','green','blue')
cond.bp<-barplot(recalRates.mean_cond,
                 beside=TRUE,
                 names.arg=studyConds,
                 ylim=c(0,1),
                 #col=presentCol,
                 #legend.text=presentConds,
                 #args.legend = list(x="bottomright")
)

error.bar(cond.bp,recalRates.mean_cond,
          recalRates.sem_cond)



# look at recal rates broken up by pas/presentation, across all conditions,
recalRates.mean_pas = rep(0,timpes=nPAS)
recalRates.sem_pas = rep(0,times=nPAS)
recalRates.n_pas = rep(0,times=nPAS)
  for (pas in 1:nPAS) {
    recalRates.mean_pas[pas] <- 
      mean(data_trim[data_trim$studyResp==pas,]$named,
           na.rm=TRUE)
    
    recalRates.n_pas[pas] <- 
      dim(data_trim[data_trim$studyResp==pas,])[1]
    
    # var = n*p*(1-p)
    recalRates.sem_pas[pas] <-
      sqrt(recalRates.n_pas[pas] * recalRates.mean_pas[pas] * 
             (1- recalRates.mean_pas[pas])) / 
      sqrt(recalRates.n_pas[pas])
    
  }
recalRates.mean_pas
recalRates.sem_pas
recalRates.n_pas

# (note that the sum of n_pas should be equal to nSubs*nTrials - missing trials)
# ----------------------------------------------------------------

# look at recal rates broken up by pas/cond, first presentation only
rRates.mean_pasCond = matrix(0,ncol=nConds,nrow=nPAS)
rRates.sem_pasCond = matrix(0,ncol=nConds,nrow=nPAS)
rRates.n_pasCond = matrix(0,ncol=nConds,nrow=nPAS)
for (cond in 1:nConds) {
  for (pas in 1:nPAS) {
    
    rRates.mean_pasCond[cond,pas] <- 
      mean(data_trim[data_trim$condition==cond &
                       data_trim$studyResp==pas,]$named,
           na.rm=TRUE)
    
    rRates.n_pasCond[cond,pas] <- 
      dim(data_trim[data_trim$condition==cond & 
                      data_trim$studyResp==pas,])[1]
    
    # var = n*p*(1-p)
    rRates.sem_pasCond[cond,pas] <-
      sqrt(rRates.n_pasCond[cond,pas] * rRates.mean_pasCond[cond,pas] * 
             (1- rRates.mean_pasCond[cond,pas])) / 
      sqrt(rRates.n_pasCond[cond,pas])
    
  }
}
# nas are being counted multiple times (total of 21 na trials)

rRates.mean_pasCond
rRates.sem_pasCond
rRates.n_pasCond


# do the study conditions contribute to PAS response, for first presentation?
t.test(data[data$presentation==1 & data$condition==1,]$studyResp,
       data[data$presentation==1 & data$condition==4,]$studyResp,
       alternative="two.sided",
       paired=FALSE,
       na.rm=TRUE)


par(mfrow=c(1,1))
pasResps <- c("0","1","2","3")
pasCond.bp <- barplot(t(rRates.mean_pasCond),
                  beside=TRUE,
                  names.arg=studyConds,
                  ylim=c(0,1),
                  #col=presentCol,
                  legend.text=pasResps,
                  args.legend = list(x="bottomright"),
                  xlab = "study length",
                  ylab = "proportion named"
                  
)
error.bar(pasCond.bp,t(rRates.mean_pasCond),
          t(rRates.sem_pasCond))

rRates.n_pasCond.prop = matrix(0,nrow=4,ncol=4)
for (cond in 1:nConds) {
  for (pas in 1:nPAS){
    rRates.n_pasCond.prop[cond,pas] <- 
      rRates.n_pasCond[cond,pas] / 
      sum(rRates.n_pasCond[cond,])
        
  }
}


par(mfrow=c(1,1))
# looking at raw numbers of each PAS per condition
pasCond_n.bp <- barplot(t(rRates.n_pasCond.prop),
                        beside=TRUE,
                        names.arg=studyConds,
                        ylim=c(0,1),
                        #col=presentCol,
                        legend.text=pasResps,
                        args.legend = list(x="topright"),
                        xlab = "study length",
                        ylab = "proportion of resposnes"
)


pasCond_n.aov<-aov(studyResp ~ condition + Error(subject/condition),data=data_trim)
summary(pasCond_n.aov)



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


par(mfrow=c(3,3))

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

# fully broken down (not yet enough subjects)
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




rRates.mean_cond.item = matrix(0,nrow=nConds,ncol=nItems)
rRates.sem_cond.item = matrix(0,nrow=nConds,ncol=nItems)
rRates.n_cond.item = matrix(0,nrow=nConds,ncol=nItems)
for (cond in 1:nConds){
  for (item in 1:nItems) {
    
    rRates.mean_cond.item[cond,item] <- 
      mean(data[data$condition==cond
                & data$whichItem==item,]$named,
           na.rm=TRUE)
    
    rRates.n_cond.item[cond,item] <- 
      dim(data[data$condition==cond
               & data$whichItem==item,])[1]
    
    # var = n*p*(1-p)
    rRates.sem_cond.item[cond,item] <-
      sqrt(rRates.n_cond.item[cond,item] * 
             rRates.mean_cond.item[cond,item] * 
             (1- rRates.mean_cond.item[cond,item])) / 
      sqrt(rRates.n_cond.item[cond,item])
    
  }
}




rRates.mean_cond.item
rRates.sem_cond.item
rRates.n_cond.item


par(mfrow=c(1,1))
# searching for correlations between .5 and 2 sec presentation
plot(rRates.mean_cond.item[1,],rRates.mean_cond.item[4,],
     xlim=c(0,1),
     ylim=c(0,1),
     main="proportion of item named, counfounded"
     , ylab = ".5 seconds"
     , xlab = "2 seconds"
)
















# looking at difference between 1.5 and 5 sec presentation
t.test(rRates.mean_cond.item[1,1,],rRates.mean_cond.item[1,4,],
       alternative="two.sided",
       paired=TRUE,
       na.rm=TRUE)








#--------------------------------------------------------------
# run repeated measure anova
#--------------------------------------------------------------
