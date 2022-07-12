# Power calculation in network studies

Computing power and sample size are common tasks in study design. This chapter will walk you
through power analysis for network studies. First, we will start with some preliminaries
regarding error types and statistical power.

## Error types

One of the most important tables we'll see around is the contingency table of accept/reject the null hypothesis conditional on the true state:


|           |Accept H0      |Reject H0      |
|:----------|:--------------|:--------------|
|H0 is true |True positive  |False negative |
|H1 is true |False positive |True negative  |

A better way, more statistically accurate version of this table would be


|           |Accept H0         |Reject H0         |
|:----------|:-----------------|:-----------------|
|H0 is true |Correct inference |Type I error      |
|H1 is true |Type II error     |Correct Inference |

With $\Pr{(\mbox{Type I error})} = \alpha$ and $\Pr{(\mbox{Type II error})} = \beta$. This way, power can be defined as the
probability of rejecting the null given the alternative is true, $\Pr{(\mbox{Reject H0}|\mbox{H1 is true})} = 1-\beta$.

## Examples

### Sample size for a proportion

Let's imagine we are preparing a study in which we would like to estimate the proportion of individuals with a given status. Formally, we then say that the variable $Y\sim\mbox{Bernoulli}(p)$. To do so, we will need to survey $n$ individuals and estimate such a number by taking the sample average. Furthermore, we hypothesize that under the null the proportion is $H_0: p = p_0$.

The key here is to think about a simple rejection rule. Again, power is the probability of **rejecting the null** given that **the alternative is true**. So, to write down the equation, we need to think about acceptance and rejection regions. Let $\hat p$ be our estimate for the population parameter, furthermore, $\hat p = n^{-1}\sum_i y_i$. Our test statistic can be--and will be, most of the cases--standardized to leverage the law of large numbers; under the null, we write the following:

\begin{align*}
\mathbb{E}(\hat p) & = p_0 \\
\mathbf{Var}(\hat p) & = \sqrt{p_0(1-p_0)/n}
\end{align*}

Therefore, the statistic:

\begin{equation*}
\frac{\hat p - p_0}{\sqrt{p_0(1-p_0)/n}} = \frac{\sqrt{n}(\hat p - p_0)}{\sqrt{p_0(1-p_0)}} \sim \mbox{N}(0, 1)
\end{equation*}

Since the statistic is normally distributed, we can then say when we will reject the null. For this case, that depends on the critical value, which most of the time is defined in terms of the type I error rate. Formally, we reject the null if

\begin{equation*}
\frac{\sqrt{n}(\hat p - p_0)}{\sqrt{p_0(1-p_0)}} > Z_{1-\alpha/2}
\end{equation*}

This is equivalent to saying that the **test statistic fell into the rejection region**. With this in hand, we can now write out the equation that we will be using for calculating the sample size. Going back to the definition of power:

\begin{align*}
\Pr{(\mbox{Reject H0}|\mbox{H1 is true})} & = 1-\beta \\
\Pr{\left(\frac{\sqrt{n}(\hat p - p_0)}{\sqrt{p_0(1-p_0)}} > Z_{1-\alpha/2}\right.\left|\vphantom{\frac{1}{2}}p = p_1\right)} & = 1 - \beta
\end{align*}

Observe that we cannot compute the power for all $p\neq p_0$; instead, we look at a given parameter value. A good idea is to start from one previously known or identified in other studies. The key idea here is to be able to manipulate the argument of the probability to turn it into a known distribution, for example, the normal distribution:

For a given Type I of 0.05 and power of 0.8, the required sample size can be computed as follows:

\begin{align*}
1 - \beta & = \Pr{\left(\frac{\sqrt{n}(\hat p - p_0)}{\sqrt{p_0(1-p_0)}} > Z_{1-\alpha/2}\right.\left|\vphantom{\frac{1}{2}}p = p_1\right)} \\
& = \Pr{\left(\frac{\sqrt{n}(\hat p - p_0)}{\sqrt{p_0(1-p_0)}} < Z_{\alpha/2}\right.\left|\vphantom{\frac{1}{2}}p = p_1\right)} \\
& = \Pr{\left(\frac{\sqrt{n}(\hat p - p_0)}{\sqrt{p_1(1-p_1)}} < \frac{Z_{\alpha/2}\sqrt{p_0(1-p_0)}}{\sqrt{p_1(1-p_1)}}\right.\left|\vphantom{\frac{1}{2}}p = p_1\right)} \\
& = \Pr{\left(\frac{\sqrt{n}(\hat p - p_0 + p_0 - p_1)}{\sqrt{p_1(1-p_1)}} < \frac{Z_{\alpha/2}\sqrt{p_0(1-p_0)} + \sqrt{n}(p_0 - p_1)}{\sqrt{p_1(1-p_1)}}\right.\left|\vphantom{\frac{1}{2}}p = p_1\right)} \\
& = \Pr{\left(\frac{\sqrt{n}(\hat p - p_1)}{\sqrt{p_1(1-p_1)}} < \frac{Z_{\alpha/2}\sqrt{p_0(1-p_0)} + \sqrt{n}(p_0 - p_1)}{\sqrt{p_1(1-p_1)}}\right.\left|\vphantom{\frac{1}{2}}p = p_1\right)} \\
& = \Phi\left(\frac{Z_{\alpha/2}\sqrt{p_0(1-p_0)} + \sqrt{n}(p_0 - p_1)}{\sqrt{p_1(1-p_1)}}\right.\left|\vphantom{\frac{1}{2}}p = p_1\right) \\
\end{align*}

The last equality follows from the quantity $\frac{\sqrt{n}(\hat p - p_1)}{\sqrt{p_1(1-p_1)}}$ distributing standard normal. We can now take the inverse of the cumulative distribution function (cdf) to isolate the sample size $n$:

\begin{align*}
\Phi^{-1}(1 - \beta)& = \frac{Z_{\alpha/2}\sqrt{p_0(1-p_0)} + \sqrt{n}(p_0 - p_1)}{\sqrt{p_1(1-p_1)}} \\
Z_{1-\beta}\sqrt{p_1(1-p_1)}& = Z_{\alpha/2}\sqrt{p_0(1-p_0)} + \sqrt{n}(p_0 - p_1) \\
\frac{\left(Z_{1-\beta}\sqrt{p_1(1-p_1)} - Z_{\alpha/2}\sqrt{p_0(1-p_0)}\right)^2}{(p_0 - p_1)^2}& = n \\
\end{align*}

Therefore, for the parameters $(1-\beta, \alpha, p_0, p_1) = (0.8, 0.05, 0.5, 0.6)$, the required sample size is 193.8473 $\sim$ 194.
