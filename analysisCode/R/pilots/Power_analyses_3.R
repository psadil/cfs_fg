#----------------------------------------#
# Power analysis for PDP replication     #
# Patrick Sadil                          #
# Updated                                #
#----------------------------------------#



# adapted from:
#----------------------------------------#
# Power analysis of Wimber et al. (2015) #
# original/replication                   #
# Kevin Potter                           #
# Updated 5/4/2015                       #
#----------------------------------------#




"
Purpose:

Requirements:
R
Forthcoming

### TO DO ###
- Add annotations
- Add fatigue variant model
- Add noisy data variant model
- Add index

### Index for code segments ###
Forthcoming
"

###
### Read in data; load useful functions ###
###
# 

# Clear the workspace
rm(list=ls())

# Load in Stan
library(rstan)

soft.max = function(x) {
  # Purpose:
  # A function to take a set of values and rescale them to
  # be positive and sum to 1
  # Arguments:
  # x - A vector of values that lie between -Inf and Inf
  # Output:
  # A vector of positive values that sum to 1
  
  exp(x)/sum( exp(x) )
}

reverse.soft.max = function(y,init=NULL,restrict=NULL) {
  # Purpose:
  # A function that determines a set of values to produce
  # the desired vector of probabilities using the softmax function.
  # Arguments:
  # y    - A vector of probabilities (positive, sum to 1)
  # init - The starting values for the optim function
  # Output:
  # The output from the optim function
  
  if (is.null(init)) init = rnorm(length(y));
  
  optim(init, function (x) { x[restrict] = 0; sum( ( y - soft.max(x) )^2 )} )
}

lin.con <- function(DV, group, subject, contrasts){
  # Purpose:
  # A function to calculate a linear contrast for a
  # repeated measures ANOVA
  # Arguments:
  # DV        - The dependent variable
  # group     - The group factor
  # subject   - The subject factor
  # contrasts - A vector of the weightings to use for the contrast
  # Output:
  # Returns a list with...
  #   F.value   - the calculated F statistic for the contrast test
  #   df        - the degrees of freedom
  #   p.value   - the p-value for the trend analysis
  #   Mean.sq   - The mean square error terms
  #   contrasts - Provides the original contrasts specified
  
  group = as.factor(group)
  subject = as.factor(subject)
  
  m <- tapply(DV, group, mean)
  n <- tapply(DV, group, length)
  
  fit=aov(DV ~ group + Error(subject/group))
  aov.res=summary(fit)
  
  tmp = as.numeric(unlist(aov.res[2]))
  mse=tmp[6]
  dfd=tmp[2]
  
  psi <- sum(contrasts*m)
  sscon <- sum(contrasts*contrasts/n)
  mspsi <- (psi*psi)/sscon
  conF <- mspsi/(mse)
  p.val <- 1 - pf(conF, 1, dfd)
  
  out = list( F.value = conF, df = dfd, p.value = p.val, 
              Mean.Sq = c(mse,mspsi), contrasts = contrasts )
  
  out
}

sigmoidal = function(x) {
  # Purpose:
  # Function to transform a variable bounded by -Infinity to 
  # +Infinity to now be bounded between 0 and 1
  # Arguments:
  # x - A continuous value or vector of values
  # Output:
  # A new value or vector of values bounded between 0 and 1
  
  1.0 / (1.0 + exp(-x) )
}

logit = function(p) {
  # Purpose:
  # A function to take the log of the odds
  # Arguments:
  # p - A probability or vector of probabilities
  # Output:
  # The log of the odds for the probability or probabilities p
  
  log( p/ (1.0-p) )
  
}

# Scripts for simulating data in Stan

FR.sim.script = "
data {
  // Declarations for data
  int<lower=1> Ns; // Number of subjects
  int<lower=1,upper=4> Nc; // Number of conditions per subject
  int<lower=Nc> mxT; // The total number of observations to simulate
  int Nt[mxT]; // The number of trials per condition and subject
  int<lower=1> Np; // The number of predictors
  matrix[Nc,Np] X; // A design matrix for the treatment effects
  int indS[mxT]; // Index for subjects
  int indC[mxT]; // Index for condition
  real mu_B0; // The overall mean for the intercepts
  real<lower=0> sigma_B0; // The standard deviation for the intercepts
  vector[Np] beta_eff; // A set of coefficients for the main effects and interaction
  real<lower=0> sigma_B; // Homogeneity of variance
}
model {
  // N/A  
}
generated quantities {
  // Declarations for generated quantities
  vector[Nc] Shifts;
  real Mu[mxT];
  real beta0[Ns];
  real alpha[mxT];
  real<lower=0,upper=1> theta[mxT];
  int y[mxT]; // The number of correctly answered trials per subject and condition
  
  Shifts <- X*beta_eff; // Shifts in the intercept based
                        // on the main effects and interactions
  
  // Simulate the intercepts for each subject
  for (ns in 1:Ns) {
    beta0[ns] <- normal_rng(mu_B0,sigma_B0);
  }
  
  // Simulate the observed responses for each subject
  for (mx in 1:mxT) {
    Mu[mx] <- beta0[ indS[mx] ] + Shifts[ indC[mx] ];
    alpha[mx] <- normal_rng(Mu[mx],sigma_B);
    theta[mx] <- inv_logit(alpha[mx]); // Logit link
    y[mx] <- binomial_rng(Nt[mx],theta[mx]);
  }
  
}
"

# Example run of script
"
# Set values for the generating parameters
Ns = 45
Nc = 4
N.trials = c(54, 18, 54, 18)
X = cbind( c(-1,1,-1,1),c(-1,-1,1,1) )
X = cbind(X, X[,1]*X[,2] )
param = list(
  mu_B0 = logit(0.789),
  sigma_B0 = 0.6,
  beta_eff = c(0,0,-.2), # In logit units
  sigma_B = .1
)

gen.par = list(
  Ns = Ns,
  Nc = 4,
  mxT = Ns*Nc,
  Nt = rep(N.trials,Ns),
  Np = ncol(X),
  X = X,
  indS = rep(1:Ns,each=Nc),
  indC = rep(1:Nc,Ns),
  mu_B0 = param$mu_B0,
  sigma_B0 = param$sigma_B0,
  beta_eff = param$beta_eff,
  sigma_B = param$sigma_B
)

n.rep = 1000 # Number of simulation repetitions

# Simulate using Stan
st.time = Sys.time()
stan.fit <- stan(
  model_code = FR.sim.script,
  data = gen.par,
  warmup = 0,
  iter = n.rep,
  chains = 1,
  algorithm = 'Fixed_param'
)
sim.time = Sys.time() - st.time

# Extract the data once the simulation is over
sim.dat = extract(stan.fit)
"

prob.to.coef.eff.code = function(prob,X,init=NULL,lw=-.2,up=.2) {
  # Purpose:
  # A function to convert a set of probabilities into
  # a set of regression coefficients in logit units based
  # on an effect coding design matrix (i.e. deflections
  # from a grand mean)
  # Arguments:
  # prob - A vector of p probabilities
  # X    - A p x d design matrix using effects coding
  # init - The set of initial values for the optim function
  #        (defaults to NULL, values are then generated using 
  #         a uniform distribution)
  # lw   - The lower boundary for the uniform distribution above
  # up   - The upper boundary for the uniform distribution above
  # Output:
  # The results from the optim function
  
  if (is.null(init)) init = runif(ncol(X),lw,up);
  
  optim(init,
        function(B,prob) { est = sigmoidal( 
          logit(mean(prob)) + X %*% cbind(B) );
          sum((prob - est)^2);
          }, prob = prob )
}

FR.fat.script = "
data {
  // Declarations for data
  int<lower=1> Ns; // Number of subjects
  int mxT; // The total number of observations to simulate
  real trl[mxT]; // The current trial number for a subject
  int<lower=1> Np; // The number of predictors
  matrix[mxT,Np] X; // A design matrix for the treatment effects
  int indS[mxT]; // Index for subjects
  real mu_B0; // The overall mean for the intercepts
  real<lower=0> sigma_B0; // The standard deviation for the intercepts
  vector[Np] beta_eff; // A set of coefficients for the main effects and interaction
  real beta4; // A coefficient for a non-linear decay in performance
  real<lower=0> sigma_B; // Homogeneity of variance
}
model {
  // N/A  
}
generated quantities {
  // Declarations for generated quantities
  vector[mxT] Shifts;
  real Mu[mxT];
  real beta0[Ns];
  real alpha[mxT];
  real<lower=0,upper=1> theta[mxT];
  int y[mxT]; // 0 if incorrect, 1 if correct
  
  Shifts <- X*beta_eff; // Shifts in the intercept based
  // on the main effects and interactions
  
  // Simulate the intercepts for each subject
  for (ns in 1:Ns) {
    beta0[ns] <- normal_rng(mu_B0,sigma_B0);
  }
  
  // Simulate the observed responses for each subject
  for (mx in 1:mxT) {
    Mu[mx] <- beta0[ indS[mx] ] + Shifts[ mx ] + exp( beta4*trl[ mx ] );
    alpha[mx] <- normal_rng(Mu[mx],sigma_B);
    theta[mx] <- inv_logit(alpha[mx]); // Logit link
    y[mx] <- bernoulli_rng(theta[mx]);
  }
  
}
"

# Example run of script
"
# Set values for the generating parameters
Ns = 24
N.trials = c(54, 18, 54, 18)
subject = rep(1:Ns,each=sum(N.trials))
trl = rep( 1:sum(N.trials),Ns)

# Design matrix
tmp = cbind( rep(c(-1,1,-1,1),N.trials), rep(c(-1,-1,1,1),N.trials) )
tmp = cbind(tmp,tmp[,1]*tmp[,2])
tmp = cbind(tmp,rep(1:4,N.trials))
X.f = c()
for (ns in 1:Ns) {
  X.f = rbind(X.f,tmp[sample(1:nrow(tmp)),]) # Shuffle order
}
X.f = cbind(subject,X.f)
colnames(X.f) = c('Subject','ItemType','Associate','Interaction','Cond')
rm(tmp)

param = list(
  mu_B0 = logit(0.789)-.9,
  sigma_B0 = 0.6,
  beta_eff = c(0.12,-0.009,-.09), # In logit units
  beta4 = -.0005,
  sigma_B = .1
)

gen.par = list(
  Ns = Ns,
  mxT = nrow(X.f),
  trl = trl,
  Np = ncol(X.f[,2:4]),
  X = X.f[,2:4],
  indS = subject,
  mu_B0 = param$mu_B0,
  sigma_B0 = param$sigma_B0,
  beta_eff = param$beta_eff,
  beta4 = param$beta4,
  sigma_B = param$sigma_B
)

n.rep = 1000 # Number of simulation repetitions

# Simulate using Stan
st.time = Sys.time()
stan.fit <- stan(
  model_code = FR.fat.script,
  data = gen.par,
  warmup = 0,
  iter = n.rep,
  chains = 1,
  algorithm = 'Fixed_param'
)
sim.time = Sys.time() - st.time

# Extract the data once the simulation is over
sim.dat = extract(stan.fit)
"

FR.power.analysis = function(Ns,N.Trials,X,param,n.rep,type='FR.sim.script',
                             newPlot=T) {
  # Purpose:
  # A function to simulate data for the final recognition memory task
  # in Wimber et al. (2015).
  # Arguments:
  # Ns       - The number of subjects for each dataset
  # N.Trials - A vector of four values, the number of trials for the
  #            target-cued, target-baseline, comp-cued, and comp-baseline
  #            conditions respectively.
  # X        - A 4 x 3 design matrix
  # param    - A list of named parameter values, where...
  #              mu_B0    = The overall mean for the subject intercepts 
  #                         (in logit units)
  #              sigma_B0 = The standard deviation for the subject intercepts 
  #                         (in logit units)
  #              beta_eff = The 3 coefficients for the...
  #                         1) Main effect by item type (baseline vs cued)
  #                         1) Main effect by associate (competitor vs target)
  #                         1) Interaction effect
  #              sigma_B  = The standard deviation (in logit units) for each probability
  # n.rep    - The number of replicates to run for the monte carlo simulations.
  # type     - The type of simulation script to use...
  #              Forthcoming
  # new.plot - Indicates whether a plot of the example simulated data should be shown
  # Output:
  # A list consisting of...
  #   gen.par       - The generating parameters fed into Stan
  #   stan.output   - A list with the output from Stan, the simulated data.
  #   all.sim.dat   - An array of the simulated data, converted into proportions
  #   aov.results   - The F and p values for the two main effects and interaction
  #                   for each replicate
  #   sim.time      - How long Stan took to run
  #   run.time      - The overall length of the simulation
  
  # Determine how long the entire simulation process takes
  st.run.time = Sys.time()
  
  if (type=='FR.fat.script') {
    gen.par = list(
      Ns = Ns,
      mxT = nrow(X),
      trl = rep(1:sum(N.trials),Ns),
      Np = ncol(X[,2:4]),
      X = X[,2:4],
      indS = rep(1:Ns,each=sum(N.trials)),
      mu_B0 = param$mu_B0,
      sigma_B0 = param$sigma_B0,
      beta_eff = param$beta_eff,
      beta4 = param$beta4,
      sigma_B = param$sigma_B
    )
    
    st.time = Sys.time()
    stan.fit <- stan(
      model_code = FR.fat.script,
      data = gen.par,
      warmup = 0,
      iter = n.rep,
      chains = 1,
      algorithm = 'Fixed_param'
    )
    sim.time = Sys.time() - st.time
    
    # Extract the data once the simulation is over
    sim.dat = extract(stan.fit)
    
    cnt = rep(1,gen.par$mxT)
    Nt = aggregate(cnt,list(X[,2],X[,3],X[,1]),sum)$x
    P = numeric(length(Nt)*n.rep)
    
    # Keep track of progress
    inc = 1
    progress = seq(.1,1,.1);
    
    cat(c('Rearrange data','\n'))
    
    for (nr in 1:n.rep) {
      
      if (progress[inc] <= nr/n.rep) {
        cat( c(100*progress[inc],'% done','\n') )
        inc = inc+1
      }
      
      sta = 1 + length(Nt)*(nr-1) 
      sto = length(Nt) + length(Nt)*(nr-1)
      tmp = aggregate(sim.dat$y[nr,],
                      list(X[,2],X[,3],X[,1]),sum)
      P[sta:sto] = tmp$x/Nt
    }
    
    # Analysis of the simulated data
    S = rep( tmp$Group.3, n.rep)
    I = rep( tmp$Group.1, n.rep ); I[I==-1]=0
    A = rep( tmp$Group.2, n.rep ); A[A==1]=2; A[A==-1]=1;
    nR = rep( 1:n.rep,each=nrow(tmp))
  }
  
  if (type=='FR.sim.script') {
    
    # Set the generating parameters for the simulation in Stan
    Nc = 4
    gen.par = list(
      Ns = Ns,
      Nc = Nc,
      mxT = Ns*Nc,
      Nt = rep(N.trials,Ns),
      Np = ncol(X),
      X = X,
      indS = rep(1:Ns,each=Nc),
      indC = rep(1:Nc,Ns),
      mu_B0 = param$mu_B0,
      sigma_B0 = param$sigma_B0,
      beta_eff = param$beta_eff,
      sigma_B = param$sigma_B
    )
    
    # Simulate using Stan
    st.time = Sys.time()
    stan.fit <- stan(
      model_code = FR.sim.script,
      data = gen.par,
      warmup = 0,
      iter = n.rep,
      chains = 1,
      algorithm = 'Fixed_param'
    )
    sim.time = Sys.time() - st.time
    
    # Extract the data once the simulation is over
    sim.dat = extract(stan.fit)
    
    # Analysis of the simulated data
    S = rep( gen.par$indS, n.rep)
    I = rep( rep( X[,1], Ns ), n.rep ); I[I==-1]=0
    A = rep( rep( X[,2], Ns ), n.rep ); A[A==1]=2; A[A==-1]=1;
    nR = rep( 1:n.rep,each=gen.par$mxT)
    P = as.vector( t(sim.dat$y) )/rep( gen.par$Nt, n.rep)
    
  }
  
  # Meaningful labels
  labels = cbind( c(0,1,0,1), c(1,1,2,2) )
  colnames(labels) = c('I','A')
  labels = as.data.frame(labels)
  labels$ILab = c('Cued','Baseline','Cued','Baseline')
  labels$ALab = c('Target','Target','Competitor','Competitor')
  labels$IntLab = c('target-cued','target-baseline','comp-cued','comp-baseline')
  
  # Check simulation results
  n.r = 1
  ME.I = aggregate(P[nR==n.r],list(I[nR==n.r]),mean)
  ME.A = aggregate(P[nR==n.r],list(A[nR==n.r]),mean)
  Int = aggregate(P[nR==n.r],list(I[nR==n.r],A[nR==n.r]),mean)
  
  cnd = rep(1:4,Ns)
  if (type=='FR.sim.script') shft = runif(gen.par$mxT,-.1,.1)
  else shft = runif(nrow(tmp),-.1,.1)
  if (newPlot) x11()
  plot( c(.5,4.5), c(0,1), type='n',xlab='Condition',ylab='Proportion correct',
        main = 'Example simulated data',xaxt='n')
  axis(1,1:4,labels[,'IntLab'])
  points(cnd+shft,
         P[nR==n.r],pch=15,col=rgb(.4,.4,.4,.2),fg=NULL)
  
  
  segments(c(1.5,2.5),ME.I$x,c(2.5,3.5),ME.I$x,lwd=2,col=c('red','pink'))
  segments(c(1.5,2.5),ME.I$x,c(2.5,3.5),ME.I$x,lwd=2,lty=2)
  segments(c(1.5,2.5),ME.A$x,c(2.5,3.5),ME.A$x,lwd=2,col=c('blue','green'))
  segments(c(1.5,2.5),ME.A$x,c(2.5,3.5),ME.A$x,lwd=2,lty=3)
  
  bxplt = as.matrix( aggregate(P[nR==n.r],list(I[nR==n.r],A[nR==n.r]),
                               function(x) c(mean(x)-2*(sd(x)/sqrt(length(x))),
                                             mean(x),
                                             mean(x)+2*(sd(x)/sqrt(length(x)))
                               ) ) )[,-(1:2)]
  for (i in 1:4) {
    polygon( rep(i,4) + c(-.3,-.3,.3,.3), bxplt[i,c(1,3,3,1)])
  }
  segments(1:4-.3,bxplt[,2],1:4+.3,bxplt[,2],lwd=3)
  
  legend(.5,.2,c('Cued','Base','Tar','Com'),col=c('red','pink','blue','green'),
         lty=c(2,2,3,3),bty='n',xjust=0)
  
  
  # Save all the data
  if (type=='FR.sim.script') all.dat.sim = array(0,dim=c(n.rep,gen.par$mxT,4))
  if (type=='FR.fat.script') all.dat.sim = array(0,dim=c(n.rep,nrow(tmp),4))
  all.dat.sim[n.r,,1] = S[nR==n.r]
  all.dat.sim[n.r,,2] = I[nR==n.r]
  all.dat.sim[n.r,,3] = A[nR==n.r]
  all.dat.sim[n.r,,4] = P[nR==n.r]
  
  # Matrix for test statistics
  results.2 = matrix(0,n.rep,6)
  
  # Keep track of progress
  inc = 1
  progress = seq(.1,1,.1);
  
  for (n.r in 1:n.rep) {
    # n.r=1
    
    # Track progress
    if (progress[inc] <= n.r/n.rep) {
      cat( c(100*progress[inc],'% done','\n') )
      inc = inc+1
    }
    
    # ANOVA
    
    Ps = P[nR==n.r]
    Is = as.factor(I[nR==n.r])
    As = as.factor(A[nR==n.r])
    Ss = as.factor(S[nR==n.r])
    
    fit=aov( Ps ~ Is*As + Error(Ss/(Is*As)) )
    # Error(Subject/(Baseline*ImageType)) tells R to remove the effects of
    # subject for both main effects and the interaction.
    aov.res = summary(fit)
    
    results.2[n.r,] = c(
      unlist( aov.res[2] )[7],
      unlist( aov.res[2] )[9],
      unlist( aov.res[3] )[7],
      unlist( aov.res[3] )[9],
      unlist( aov.res[4] )[7],
      unlist( aov.res[4] )[9] )  
  }
  
  run.time = Sys.time() - st.run.time
  
  return( list(
    gen.par = gen.par,
    stan.output = sim.dat,
    all.dat.sim = all.dat.sim,
    aov.results = results.2,
    labels = labels,
    sim.time = sim.time,
    run.time = run.time
  ) )
}

###
### Power analyses ###
###
# Lookup - 02

### Useful information when constructing generating parameters ###
# Lookup - 02a

# The cell means from Wimber et al. (2015) are...

# target-cued = 0.786
# target-baseline = 0.797
# competitor-cued = 0.752
# competitor-baseline = 0.821

# baseline (0.809) vs cued (0.769)
# target (0.7915) vs competitor (0.7865)

# Grand mean (0.789)

# Examination of parameter for standard deviation
sigma.ex = round(seq(.05,.7,.05),2)
clr1 = seq(.3,1,length=length(sigma.ex))
lnwd = rep(1,length(sigma.ex))
lnwd[ c(which(sigma.ex==.2),which(sigma.ex==.6)) ] = 3

val = seq(-5,5,length=1000)
x11()
plot(c(.6,1),c(0,9),type='n',ylab='Density',xlab='Probability correct')
for (i in 1:length(sigma.ex)) {
  lines(sigmoidal(val),dnorm(val,1.3,sigma.ex[i]),
        col=rgb(clr1[i],0,0,1),lwd=lnwd[i])
}

legend(.6,9, c( expression( paste(sigma,' = 0.05') ),
                paste('   = ',sigma.ex[-1],sep='') ),
       fill = rgb(clr1,0,0,1),bty='n')

### Simulate data (normal ANOVA assumptions) ###

# Order of conditions
# target-cued, target-baseline, comp-cued, comp-baseline

# Wimber et al. (2015) design
Ns = 24
N.trials = c(54, 18, 54, 18)

# Huber and Potter design
"
Ns = 45
N.trials = c(18, 18, 18, 18)
"

# Effects coding
X = cbind( c(-1,1,-1,1),c(-1,-1,1,1) )
X = cbind(X, X[,1]*X[,2] )

# Calculate generating coefficients based on
# proportions from Wimber et al. (2015)
prb = c(0.786,0.797,0.752,0.821)
res = prob.to.coef.eff.code(prb,X)
round( sigmoidal( logit(mean(prb)) + X %*% cbind(res$par) ), 3)
gm = logit( mean(prb) )
B = res$par

# Alternate specifications
"
prb = c(0.83,0.8,0.77,0.8)
res = prob.to.coef.eff.code(prb,X)
round( sigmoidal( logit(mean(prb)) + X %*% cbind(res$par) ), 3)
gm = logit( mean(prb) )
B = res$par
"

# Dummy coding
# X = cbind( c(0,1,0,1),c(0,0,1,1) )
# X = cbind(X, X[,1]*X[,2] )

# Create list of parameters in logit units
param = list(
  mu_B0 = gm,
  sigma_B0 = 0.6, # Variability (sd units) between subjects
  beta_eff = B,
  sigma_B = .2 # Variability in overall effects
)

# Number of repetitions
n.rep = 1000

# x11()
test = FR.power.analysis(Ns,N.trials,X,param,n.rep,newPlot=F)
test$run.time
aov.results = test$aov.results

x11()
plot(c(0,1),c(0,15),type='n')
tmp = density(aov.results[,2])
lines(tmp$x,tmp$y,lty=2)
tmp = density(aov.results[,4])
lines(tmp$x,tmp$y,lty=3)
tmp = density(aov.results[,6])
lines(tmp$x,tmp$y,lty=1)
abline(h=1,col='blue')

100*sum(aov.results[,2]<0.05)/n.rep # Main effect for associate (target vs. comp)
100*sum(aov.results[,4]<0.05)/n.rep # Main effect for item type (baseline vs. cued)
100*sum(aov.results[,6]<0.05)/n.rep # Interaction effect

### Simulate data (fatigue effect) ###

# Set values for the generating parameters
Ns = 24
N.trials = c(54, 18, 54, 18)
subject = rep(1:Ns,each=sum(N.trials))

# item type -1 Cue 1 Base
# associate -1 Target 1 Comp
# interaction Product of two previous columns

# Design matrix
tmp = cbind( rep(c(-1,1,-1,1),N.trials), rep(c(-1,-1,1,1),N.trials) )
tmp = cbind(tmp,tmp[,1]*tmp[,2])
tmp = cbind(tmp,rep(1:4,N.trials))
X.f = c()
for (ns in 1:Ns) {
  X.f = rbind(X.f,tmp[sample(1:nrow(tmp)),]) # Shuffle order
}
X.f = cbind(subject,X.f)
colnames(X.f) = c('Subject','ItemType','Associate','Interaction','Cond')
rm(tmp)

# Main effect of item type and associate, no interaction


prb = c(0.82,0.79,0.78,0.76)
res = prob.to.coef.eff.code(prb,X)
round( sigmoidal( logit(mean(prb)) + X %*% cbind(res$par) ), 3)
gm = logit( mean(prb) )
B = res$par

param = list(
  mu_B0 = 1.3 - .9,
  sigma_B0 = 0.6,
  beta_eff = c(-.1,-.1,0), # In logit units
  beta4 = -.0005,
  sigma_B = .1
)

n.rep=1000

test2 = FR.power.analysis(Ns,N.trials,X.f,param,n.rep,newPlot=T,type='FR.fat.script')
test2$run.time
aov.results2 = test2$aov.results

100*sum(aov.results2[,2]<0.05)/n.rep # Main effect for associate (target vs. comp)
100*sum(aov.results2[,4]<0.05)/n.rep # Main effect for item type (baseline vs. cued)
100*sum(aov.results2[,6]<0.05)/n.rep # Interaction effect