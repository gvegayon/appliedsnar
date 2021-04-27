# Hypothesis testing in networks

Overall, there are many ways in which we can see hypothesis testing within
the networks context:

1. **Comparing two or more networks**, e.g., we want to see if the density of
two networks are *equal*.

2. **Prevalence of a motif/pattern**, e.g., check whether the observed number
of transitive triads is different from that expected as of by chance.

3. **Multivariate using ERGMs**, e.g., jointly test whether homophily and 
two stars are the motifs that drive network structure.

The latter we already review in the ERGM chapter. In this part, we will look
at types one and two; both using non-parametric methods.

## Comparing networks

Imagine that we have two graphs, $(G_1,G_2) \in \mathcal{G}$, and we would like
to assess whether a given statistic $s(\cdot)$, e.g., density, is equal in both of them.
Formally, we would like to asses whether $H_0: s(G_1) - s(G_2) = k$ vs
$H_a: s(G_1) - s(G_2) \neq k$. 

As usual, the true distribution of $s(\cdot)$ is unknown, thus, one approach that
we could use is a non-parametric bootstrap test.

### Network bootstrap

The non parametric bootstrap and jackknife methods for social networks were
introduced by [@Snijders1999]. The method itself is used to generate standard
errors for network level statistics. Both methods are implemented in the R
package [`netdiffuseR`](https://cran.r-project.org/package=netdiffuseR).

### When the statistic is normal

When the we deal with things that are normally distributed, e.g., sample means
like density[^density-sample-mean],
we can make use of the Student's distribution for making inference. In particular,
we can use Bootstrap/Jackknife to approximate the standard errors of the statistic
for each network:

[^density-sample-mean]: Density is indeed a sample mean as we are, in principle
computing the average of a sequence of Bernoulli variables. Formally:
$\mbox{density}(G) = \frac{1}{n(n-1)}\sum_{ij}A_{ij}$.

1. Since $s(G_i)\sim \mbox{N}(\mu_i,\sigma_i^2/m_i)$ for $i\in\{1,2\}$, in the case
   of the density, $m_i = n_i * (n_i - 1)$. The statistic is then:

   $$
   s(G_1) - s(G_0)\sim \mbox{N}(\mu_1-\mu_0, \sigma_1^2/m_1 + \sigma_1^2/m_2)
   $$
   
   Thus
   
   $$
   \frac{s(G_1) - s(G_0) - \mu_1 + \mu_2}{\sqrt{\sigma_1^2/{m_1} + \sigma_1^2/{m_2}}} \sim t_{m_1 + m_2 - 2}
   $$
   But, if we are testing $H_0: \mu_1 - \mu_2 = k$, then, under the null
   
   $$
   \frac{s(G_1) - s(G_0) - k}{\sqrt{\sigma_1^2/{m_1} + \sigma_1^2/{m_2}}} \sim t_{m_1 + m_2 - 2}
   $$
   Where We now proceede to approximate the variances.
   
2. Using the *plugin principle* [@Efron1994], we can approximate the variances
   using Bootstrap/Jackknife, i.e., compute $\hat\sigma_1^2\approx\sigma_1^2/m_1$ and
   $\hat\sigma_2^2\approx\sigma_2^2/m_2$. Using netdiffuseR
   
   ```r
   library(netdiffuseR)
   
   # Obtain a 100 replicates
   sg1 <- bootnet(g1, function(i) sum(i)/(nnodes(i) * (nnodes(i) - 1)), R = 100)
   sg2 <- bootnet(g2, function(i) sum(i)/(nnodes(i) * (nnodes(i) - 1)), R = 100)
   
   # Retrieving the variances
   hat_sigma1 <- sg1$var_t
   hat_sigma2 <- sg2$var_t
   
   # And the actual values
   sg1 <- sg1$t0
   sg2 <- sg2$t0
   ```
   
3. With the approximates in hand, we can then use the the "t-test table" to
   retrieve the corresponding value, in R:
   
   ```r
   # Building the statistic
   tstat <- (sg1 - sg2 - k)/(sqrt(hat_sigma1 + hat_sigma2))
   
   # Computing the pvalue
   m1 <- nnodes(g1)*(nnodes(g1) - 1)
   m2 <- nnodes(g2)*(nnodes(g2) - 1)
   pt(tstat, df = m1 + m2 - 2)
   ```

### When the statistic is NOT normal

In the case that the statistic is not normally distributed, we cannot use the
t-statistic any longer. Nevertheless, the Bootstrap can come to help. While
in general it is better to use distributions of pivot statistics (see [@Efron1994]),
we can still leverage the power of this method to make inferences. For this
example, $s(\cdot)$ will be the range of the threshold in a diffusion graph.

As before, imagine that we are dealing with an statistic $s(\cdot)$ for two
different networks, and we would like to asses whether we can reject $H_0$ 
or [fail to reject](https://www.thoughtco.com/fail-to-reject-in-a-hypothesis-test-3126424) it.
The procedure is very similar:

1. One approach that we can test is whether $k \in \mbox{ConfInt}(s(G_1) - s(G_2))$.
   Building confidence intervals with bootstrap could be more intuitive.
   
2. Like before, we use bootstrap to generate a distribution of $s(G_1)$ and
   $s(G_2)$, in R:
   
   ```r
   # Obtain a 1000 replicates
   sg1 <- bootnet(g1, function(i) range(threshold(i)), R = 1000)
   sg2 <- bootnet(g2, function(i) range(threshold(i)), R = 1000)
   
   # Retrieving the distributions
   sg1 <- sg1$boot$t
   sg2 <- sg2$boot$t
   
   # Define the statistic
   sdiff <- sg1 - sg2
   ```
   
3. Once we have `sdiff`, we can proceed and compute the, for example, 95\%
   confidence interval, and evaluate whether $k$ falls within. In R:
   
   ```r
   diff_ci <- quantile(sdiff, probs = c(0.025, .975))
   ```
   
This corresponds to what Efron and Tibshirani call "percentile interval."
This is easy to compute, but a better approach is using the "BCa" method,
"Bias Corrected and Accelerated." (TBD)

## Examples

### Average of node-level stats

Supposed that we would like to compare something like average indegree. 
In particular, for both networks, $G_1$ and $G_2$, we compute the average
indegree per node:

$$
s(G_1) = \mbox{AvgIndeg}(G_1) = \frac{1}{n}\sum_{i}\sum_{j\neq i}A^1_{ji}
$$

\noindent where $A^1_{ji}$ equals one if vertex $j$ sends a tie to $i$. In this
case, since we are looking at an average, we have that 
$\mbox{AvgIndeg}(G_1) \sim N(\mu_1, \sigma^2_1/n)$. Thus, taking advantage of
the normality of the statistic, we can build a test statistic as follows:

$$
\frac{s(G_1) - s(G_2) - k}{\sqrt{\hat\sigma_{1}^2 + \hat\sigma_{2}^2}} \sim t_{n_1 + n_2 - 2}
$$
Where $\hat\sigma_i$ is the bootstrap standard error, and $k = 0$ when we are testing
equality. This distributes $t$ with
$n_1+n_2-2$ degrees of freedom. As a difference from the previous example using
density, the degrees of freedom for this test are less as, instead of having an
average across all entries of the adjacency matrix, we have an average across all
vertices.














