#--------------------------------------------#
# Example of hierarchical SDT model for 2AFC #
#--------------------------------------------#

# Clear workspace
rm(list = ls())

# Load useful packages
# install.packages(mvtnorm)
library(mvtnorm) # For the multivariate normal distribution
# install.packages(rstan)
# For more installation notes -> http://mc-stan.org/interfaces/rstan
library(rstan)

###
### Define useful functions
###
# Lookup - 01

normal_cdf = function(x,m,s) {
  # Purpose:
  # Calculates cdf for normal distributions, renamed for 
  # greater ease of transferring to Stan
  # Arguments:
  # x - data
  # m - mean
  # s - standard deviation
  
  pnorm(x,m,s)
}

SDTlikelihood = function( resp, correct, kappa, dprime, prob = F) {
  # Purpose:
  # Likelihood function for SDT model reparameterized for 2AFC
  # Arguments:
  # resp    - A response (or vector of responses), 0 for left,
  #           1 for right
  # correct - The correct choice, 0 for left, 1 for right
  # kappa   - A subject's criterion for choosing left or right, 
  #           where positive values indicate a bias towards left,
  #           and negative values indicate a bias towards right
  # dprime  - The degree of separation between the distributions for 
  #           the left and right distributions (larger values 
  #           indicate greater discriminability)
  # prob    - If true, returns the probabilties for picking right 
  #           when the correct choice was either on the right or left
  # Returns:
  # A vector of probabilities or the likelihood for a response
  
  # theta = P(Y|kappa,dprime)
  # Subscript gives choice vs. correct
  theta_RL <- 1.0 - normal_cdf( kappa, -dprime*.5, 1.0 );
  theta_RR <- 1.0 - normal_cdf( kappa, dprime*.5, 1.0 );
  
  if (prob) {
    out = cbind( theta_RR, theta_RL )
  } else {
    out = dbinom( resp, 1, correct*theta_RR + (1-correct)*theta_RL )
  }
  
  out
}

###
###
###

plotYes = F
if (plotYes) {
  # Example parameters
  dprime = 1.5
  kappa = 0.25
  
  val = seq( -6, 6, length = 1000 )
  x11()
  plot( c(-6,6), c(0,.6), type = "n", bty = "l", 
        xlab = "Information", ylab = "Density" )
  
  lines( val, dnorm( val, -dprime*.5, 1.0 ), lty = 2 )
  lines( val, dnorm( val, dprime*.5, 1.0 ) )
  
  abline(v=kappa)
  cat("P(Pick left):","\n")
  cat( round( 1.0 - normal_cdf( kappa, -dprime*.5, 1.0 ), 2 ), "\n" )
  cat("P(Pick right):","\n")
  cat( round( 1.0 - normal_cdf( kappa, dprime*.5, 1.0 ), 2 ), "\n" )
}

###
### Simulating data
###

# dprime = X_dp*Beta_dp + eta[s,1] + zeta[i]
# kappa  = X_k*Beta_k + eta[s,2]
# eta[s]  ~ MVN( [ 0, 0 ], Sigma )
# zeta[i] ~ N( 0, sigma_i )

Ns = 30 # Number of subjects
Ni = 128 # Number of items

# Parameters for subject effects
rho = 0.25 # Correlation
sigma_s = c( 0.25, 0.25 ) # Variance of effects
Omega = diag(2)
Omega[1,2] = rho; Omega[2,1] = rho;
Sigma = diag(2);
diag(Sigma) = sigma_s
Sigma = Sigma^2
Sigma = Sigma %*% Omega %*% Sigma

# Generate subject effects
eta = rmvnorm( Ns, c( 0, 0 ), Sigma )

# Parameters for item effects
sigma_i = .25
zeta = rnorm( Ni, 0, sigma_i )

# Population parameters for d'
Beta_dp = rbind(1.5,-.2,.1,0.05)

# Population parameters for kappa
Beta_k = rbind(0.0,.25)

# Create covariates
intercept = rep(1,Ns*Ni)
factor_A = rep( rep( c(-1,1), each = Ni/2 ), Ns )
factor_B = rep( rep( rep( c(-1,1), each = Ni/4 ), 2 ), Ns )
# Design matrices
X_dp = cbind( intercept, factor_A, factor_B, factor_A*factor_B )
X_k = cbind( intercept, factor_B )
# Indices for subject and items
index_i = matrix( 1:Ni, Ni, Ns )
index_i = as.matrix( apply( index_i, 2, sample ) )
index_i = as.vector( index_i )
index_s = rep( 1:Ns, each = Ni )
# Position of correct choice (0 = left, 1 = right)
Correct = matrix( rep( c(0,1), each = Ni/2 ), Ni, Ns )
Correct = as.matrix( apply( Correct, 2, sample ) )
Correct = as.vector( Correct )

# Calculate SDT parameters
dprime = X_dp %*% Beta_dp + eta[ index_s, 1 ] + zeta[ index_i ]
kappa = X_k %*% Beta_k + eta[ index_s, 2 ]

Theta = SDTlikelihood( 1, 1, kappa, dprime, prob = T )

Y = rbinom( nrow(Theta), 1, Correct*Theta[,1] + (1-Correct)*Theta[,2] )

# Clean up workspace
rm( Omega, Sigma )

###
### Fitting data using Stan
###

# To run chains in parallel
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Define priors
Priors = rbind(
  c(0,1), # beta_dp
  c(0,1), 
  c(0,1), 
  c(0,1), 
  c(0,1), # beta_k
  c(0,1), 
  c(2,0), # Omega (Correlation matrix)
  c(1,1), # tau (Scale parameters)
  c(1,1), 
  c(1,1) # sigma_i
)

# Create list of data as input to Stan
stan_dat = list(
  Ns = Ns,
  Ni = Ni,
  K_dp = 4,
  K_k = 2,
  Y = Y,
  index_s = index_s,
  index_i = index_i,
  Correct = Correct,
  X_dp = X_dp,
  X_k = X_k,
  Priors = Priors
)

burn = 500 # Burn-in
niter = 1000 # Number of samples to approximate posterior

startTime = Sys.time() # To assess run time

# It is good practice to define your stan script in a 
# separate file with the extension '.stan'.
fit = stan(file = 'Hierarchical_SDT_for_2AFC.stan', data = stan_dat, 
           warmup = burn, iter = burn+niter, 
           chains = 4)
post = extract(fit) # Extract posterior samples

# Total run time of code
runTime = Sys.time() - startTime
print( runTime); rm( startTime )
