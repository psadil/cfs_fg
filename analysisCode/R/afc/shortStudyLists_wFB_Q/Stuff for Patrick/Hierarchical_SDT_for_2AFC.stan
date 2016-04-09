data {
  int<lower=1> Ns; // The number of subjects
  int<lower=1> Ni; // The number of items
  int<lower=1> K_dp; // The number of covariates for d'
  int<lower=1> K_k; // The number of covariates for kappa
  int Y[ Ns*Ni ]; // Array for the binary data (0 = left, 1 = right)
  int index_s[ Ns*Ni ]; // Index indicating the subject for a current trial
  int index_i[ Ns*Ni ]; // Index indicating the item for a current trial
  real Correct[ Ns*Ni ]; // The correct choice for a trial
  matrix[ Ns*Ni, K_dp ] X_dp; // Design matrix for d'
  matrix[ Ns*Ni, K_k ] X_k; // Design matrix for kappa
  matrix[ K_dp + K_k + 4, 2 ] Priors; // Matrix of parameters for priors
}
parameters {
  vector[K_dp] Beta_dp; // Group-level effects for d'
  vector[K_k] Beta_k; // Group-level effects for kappa
  vector[2] eta[Ns]; // Subject-level effects for d' and kappa
  corr_matrix[2] Omega; // Correlation between subject-level d' and kappa
  vector<lower=0.0>[2] tau; // Scale parameters for subject-level d' and kappa
  vector[Ni] zeta; // Item-level effects for d'
  real<lower=0.0> sigma_i; // Variance for item-level effects
}
transformed parameters {
  real theta[ Ns*Ni ]; // Probability of picking right
  
  {
    // Locak variables
    vector[ Ns*Ni] dprime;
    vector[ Ns*Ni] kappa;
    dprime <- X_dp*Beta_dp + to_vector( eta[ index_s, 1 ] ) + zeta[ index_i ];
    kappa <- X_k*Beta_k + to_vector( eta[ index_s, 2 ] );    
    for (no in 1:(Ns*Ni)) {
      theta[no] <- (1.0 - Correct[no])*(1.0 - normal_cdf( kappa[no], -dprime[no]*.5, 1.0 )) + 
        Correct[no]*(1.0 - normal_cdf( kappa[no], dprime[no]*.5, 1.0 ));
    }
  }  
}
model {
  // Local variable declaration
  vector[2] Mu_s;
  int inc;
  
  // Priors
  inc <- 1;
  for (i in 1:K_dp) {
    Beta_dp ~ normal( Priors[inc,1], Priors[inc,2] );
    inc <- inc + 1;
  }
  for (i in 1:K_k) {
    Beta_k ~ normal( Priors[inc,1], Priors[inc,2] );
    inc <- inc + 1;
  }
  Omega ~ lkj_corr( Priors[inc,1] );
  inc <- inc + 1;
  for (i in 1:2) {
    tau[i] ~ gamma( Priors[inc,1], Priors[inc,2] );
    inc <- inc + 1;
  }
  sigma_i ~ gamma( Priors[inc,1], Priors[inc,2] );
  
  // Hierarchy
  Mu_s <- rep_vector( 0.0, 2 );
  eta ~ multi_normal( Mu_s, quad_form_diag(Omega, tau) );
  zeta ~ normal( 0.0, sigma_i );
    
  // Likelihood
  Y ~ bernoulli(theta);
}