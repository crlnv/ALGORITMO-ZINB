# OIIIIIIIII

Um dos modelos abordados no meu trabalho de conclusão de curso, que tratou de modelos de contagem no contexto da Inferência Bayesiana, foi o Zero-Inflated Negative Binomial (ZINB). Abaixo, apresento um trecho da seção dedicada ao ZINB, assim como também o arquivo em R com a implementação do algoritmo utilizando um dos conjuntos de dados analisados.

## ZINB

O modelo ZINB é uma escolha popular para modelar dados inflacionados por zeros, pois acomoda simultaneamente a inflação de zeros e a sobredispersão, característica de um dos parâmetros da distribuição binomial negativa, se mostrando como alternativa ao modelo Poisson.

Considere a seguinte função de probabilidade aumentada:

![Função de probabilidade aumentada](https://latex.codecogs.com/png.image?\dpi{150}f(\mathbf{x},\;z\mid\lambda,\phi)%20=%20\prod_{i=1}^{n}%20\left[%20\frac{\Gamma(\phi&space;+&space;x_i)}{\Gamma(\phi)x_i!}&space;\lambda^{\phi}(1-\lambda)^{x_i}(1-p)\right]^{1-z_i}%20\left[p\,I(x_i%20=%200)\right]^{z_i})

A distribuição condicional completa para \(Z\) será Bernoulli:

![Condicional completa Z](https://latex.codecogs.com/png.image?\dpi{150}Z_i\mid\mathbf{x},\lambda,\phi%20\sim\mathrm{Bernoulli}\left(\frac{pI(x_i=0)}{pI(x_i=0)%20+%20\frac{\Gamma(\phi&space;+&space;x_i)}{\Gamma(\phi)x_i!}\lambda^{\phi}(1-\lambda)^{x_i}(1-p)}\right))

Distribuição condicional completa para \(p\):

![Condicional completa p](https://latex.codecogs.com/png.image?\dpi{150}p\mid\mathbf{x},\lambda,\phi%20\sim%20\mathrm{Beta}\left(\sum_{i=1}^nz_i+1,\;n-\sum_{i=1}^nz_i+1\right))

Assumindo a priori \(\lambda \sim \mathrm{Beta}(\alpha,\beta)\), temos:

![Condicional completa λ](https://latex.codecogs.com/png.image?\dpi{150}\lambda\mid\mathbf{x},z,\phi%20\sim%20\mathrm{Beta}\left(\phi\sum_{i=1}^n(1-z_i)&plus;\alpha,\;\sum_{i=1}^n&space;x_i(1-z_i)&plus;\beta\right))

Por fim, assumindo a priori \(\phi \sim \mathrm{Gamma}(\delta,\eta)\), a condicional completa para \(\phi\) é proporcional a:

![Condicional completa φ](https://latex.codecogs.com/png.image?\dpi{150}\pi(\phi\mid\mathbf{x},z,\lambda)%20\propto%20\prod_{i=1}^{n}%20\frac{\Gamma(\phi+x_i)}{\Gamma(\phi)}\lambda^{\phi}%20\cdot\phi^{\delta-1}%20e^{-\eta\phi})

A simulação dos parâmetros do modelo ZINB ocorre de forma similar ao modelo binomial negativo:
- \(\phi\): por **Metropolis–Hastings**,
- \(p\), \(\lambda\) e \(z\): por **amostrador de Gibbs**.
