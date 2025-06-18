#------MORTE POR RAIO--------------------

# Bibliotecas

library(readr)

# Descritiva

morteraios <- read_csv("MORTES POR RAIO - Number of lightning fatalities by category per year 1995 through 2012.csv")


###-------ZINB--------------------------------------------------


# ALGORITMO ZIBN (Zero Inflated Binomial Negative)

# Hiperparâmetros para rho
alpha_rho = beta_rho <- 1

# Hiperparâmetros para lambda
alpha_lambda = beta_lambda <- 1

# Tamanho da amostra
n <- length(morteraios$MORTES)

# Valores iniciais da cadeia
lambda <- mean(morteraios$MORTES > 0)
rho <- mean(morteraios$MORTES == 0, na.rm = TRUE)
phi <- 1  # valor inicial para phi 

# Amostrador de Gibbs
B <- 50000
k <- 0  # Contador de aceites para phi

# Vetores para armazenar amostras
lambda_samples <- numeric(B)
rho_samples <- numeric(B)
phi_samples <- numeric(B)

set.seed(122)

for (i in 1:B) {
  # Simulando z
  z <- numeric(n)
  
  for (j in 1:n) {
    # Calculando a probabilidade de z_i 
    if (morteraios$MORTES[j] != 0) {
      z[j] <- 0  # 
    } else {
      denom <- rho + dnbinom(morteraios$MORTES[j], size = phi, prob = lambda)*(1-rho)
      
      prob_z_1 <- rho/denom
      z[j] <- rbinom(1, 1, prob_z_1)  
    }
    
    # Verifique se prob_z_1 é um valor válido
    if (is.na(prob_z_1) || prob_z_1 < 0 || prob_z_1 > 1) {
      print(paste("Prob_z_1 inválido em j:", j, "com EVENTOS[j]:", morteraios$MORTES[j],
                  "rho:", rho, "lambda:", lambda, "phi:", phi))
      prob_z_1 <- 0  
    }
    
    
  }
  
  # Simulando rho
  rho <- rbeta(1, alpha_rho + sum(z), n - sum(z) + beta_rho)
  
  rho_samples[i] <- rho
  
  # Simulando lambda
  lambda <- rbeta(1, phi*sum(1 - z) + alpha_lambda, sum(morteraios$MORTES* (1-z)) + beta_lambda)
  
  lambda_samples[i] <- lambda
  
  # Simulando phi com Metropolis-Hastings
  tau <- 1  # Parâmetro de afinação
  phi_star <- rgamma(1, shape = tau * phi, rate = tau)  # Proposta
  
  # Cálculo da probabilidade de aceitação
  
  log_likelihood <- sum(lgamma(phi_star + morteraios$MORTES)) - n * lgamma(phi_star) #verossimilhança
  
  log_prior <- dgamma(phi_star, shape = 2, rate = 1, log = TRUE) #priori
  
  l_prob_num <- (log_likelihood + log_prior + n*phi_star*log(lambda))  # pi(phi* | x)
  log_likelihood <- sum(lgamma(phi + morteraios$MORTES)) - n * lgamma(phi) #verossimilhança
  log_prior <- dgamma(phi, shape = 2, rate = 1, log = TRUE) #priori
  
  l_prob_den <- (log_likelihood + log_prior + n*phi*log(lambda))
  
  
  g_num <- dgamma(phi, shape = tau * phi_star, rate = tau)  # g(phi^(j-1) | tau * phi*, tau)
  g_den <- dgamma(phi_star, shape = tau * phi, rate = tau)  # g(phi* | tau * phi^(j-1), tau)
  
  prob_accept <- exp(l_prob_num - l_prob_den) * (g_num / g_den)
  
  # Simular u ~ Uniforme(0, 1)
  u <- runif(1)
  
  # Verificar se a proposta é aceita
  if (u < prob_accept) {
    phi <- phi_star
    k <- k + 1  # Incrementar contador de aceites
  }
  phi_samples[i] <- phi
}

# Amostras pós-burn-in
phi_sim <- phi_samples[seq(B/2, B, 15)]
lambda_sim <- lambda_samples[seq(B/2, B, 15)]
rho_sim <- rho_samples[seq(B/2, B, 15)]

# trace plots e acf
par(mfrow=c(3,3))
ts.plot(phi_sim, lwd = 2, main = "Trace plot de phi")
ts.plot(lambda_sim, lwd = 2, main = "Trace plot de lambda")
ts.plot(rho_sim, lwd = 2, main = "Trace plot de rho")
acf(phi_sim, main = "ACF de phi")
acf(lambda_sim, main = "ACF de lambda")
acf(rho_sim, main = "ACF de rho")

# Tamanho do vetor simulado
Bs <- length(phi_sim)

x_til <- array(NA_real_, c(Bs, n))

set.seed(20)

for (j in 1:Bs) {
  z <- rbinom(n, 1, rho_sim[j])
  x_til[j,] <- (1 - z) * rnbinom(n, size = phi_sim[j], prob = lambda_sim[j])
}

# Probabilidades estimadas via ZIBN
p_zibn <- prop.table(table(factor(x_til, levels = 0:2)))

# Esperança a posteriori e desvio padrão para phi
E_phi_post_zinb_INCENDIOS <- mean(phi_sim)
SD_phi_post_zinb_INCENDIOS <- sd(phi_sim)

# Esperança a posteriori e desvio padrão para lambda
E_lambda_post_zinb_INCENDIOS <- mean(lambda_sim)
SD_lambda_post_zinb_INCENDIOS <- sd(lambda_sim)

# Esperança a posteriori e desvio padrão para rho
E_rho_post_zinb_INCENDIOS <- mean(rho_sim)
SD_rho_post_zinb_INCENDIOS <- sd(rho_sim)