# HELLOOOOO

O modelo ZINB é uma escolha popular para modelar dados inflacionados por zeros, pois acomoda simultaneamente a inflação de zeros e a sobredispersão, característica de um dos parâmetros da distribuição binomial negativa, se mostrando como mais uma alternativa ao modelo Poisson. Considere a seguinte função de probabilidade aumentada:
\begin{align}
    f(\textbf{x}, z|\lambda, \phi) = \prod_{i=1}^{n} \left[ \frac{\Gamma(\phi + x_i)}{\Gamma(\phi) x_i!}\lambda^\phi(1-\lambda)^{x_i}(1-p) \right]^{1-z_i}\left[ pI(x_i = 0) \right]^{z_i}.
\end{align}

A distribuição condicional completa para Z será Bernoulli:
\begin{align}
    Z_i|\textbf{x},\lambda,\phi \sim Ber\left( \frac{pI(x_i = 0)}{pI(x_i = 0) + \frac{\Gamma(\phi + x_i)}{\Gamma(\phi)x_i!}\lambda^\phi(1-\lambda)^{x_i}(1-p)} \right).
\end{align}

Distribuição condicional completa para $p$:
\begin{align}
    p|\textbf{x},\lambda,\phi \sim \textit{Beta}\left(\sum_{i=1}^{n}z_i+1, n - \sum_{i=1}^{n}z_i + 1 \right).
\end{align}

Estabelecendo que a priori para $\lambda$ é $Beta (\alpha, \beta)$, segue a condicional completa:
\begin{align}
    \pi(\lambda|\mathbf{x},z,\phi) &\propto \prod_{i=1}^{n}\left[ \lambda^\phi(1-\lambda)^{x_i} \right]^{1-z_i} \lambda^{\alpha-1}(1-\lambda)^{\beta-1} \\
    &\propto \left( \lambda^{\phi\sum_{i=1}^{n}(1-z_i)}(1-\lambda)^{\sum_{i=1}^{n}x_i(1-z_i)} \right) \lambda^{\alpha-1}(1-\lambda)^{\beta-1} \notag \\
    &\propto \lambda^{\phi\sum_{i=1}^{n}(1-z_i) + \alpha -1}(1-\lambda)^{\sum_{i=1}^{n}x_i(1-z_i) + \beta -1}; \notag 
\end{align}

Portanto,
\begin{align}
     \lambda|\mathbf{x}, z, \phi &\sim \text{Beta}\left(\phi\sum_{i=1}^{n}(1-z_i) + \alpha, \sum_{i=1}^{n}x_i(1-z_i) + \beta \right).
\end{align}


Por último, dada a \textit{priori} \( \text{Gama}(\delta, \eta) \), a condicional completa para \( \phi \) é dada por:
\begin{align}
    \pi(\phi|\mathbf{x}, z, \lambda) &\propto \prod_{i=1}^{n}\left[ \frac{\Gamma(\phi + x_i)}{\Gamma(\phi)}\lambda^\phi \right] \phi^{\delta-1} e^{-\eta \phi}.
\end{align}

A simulação dos parâmetros do modelo ZINB ocorre de forma similar ao modelo binomial negativo, utilizando o Metropolis-Hastings para simular $\phi$ enquanto $\rho$, $\lambda$ e $z$ são simulados pelor amostrador de Gibbs.
