# (PART) Statistical Foundations {-}

# Bayes' Rule

Bayes' Rule is a fundamental equation in Bayesian statistics. With it, we can reformulate inferential problems by writing probabilities in terms of known quantities. Bayes' rule can be stated as follows:

\begin{equation}
\Pr{\left(X=x|Y=y\right)} = \frac{\Pr{\left(Y=y|X=y\right)}\Pr{\left(X=x\right)}}{\Pr{\left(Y=y\right)}}
\end{equation}

Here we say that the conditional probability of $X$ given $Y$ can be expressed in terms of the conditional probability of $Y$ given $X$. For example, let $X$ be an unknown vector of parameters $\theta\in\Theta$ and $Y$ a dataset $D \sim f(\theta)$ whose data generating process depends on the unobserved $\theta$. As the posterior distribution of model parameters is in general elusive, instead, we use Bayes' rule to rephrase the problem:

\begin{equation*}
\Pr{\left(\theta|D\right)} = \frac{\Pr{\left(\theta|D\right)}\Pr{\left(\theta\right)}}{\Pr{\left(D\right)}}
\end{equation*}

Since the denominator of the equation does not depend on $\theta$, we can, instead, write

\begin{equation*}
\Pr{\left(\theta|D\right)} \propto \Pr{\left(\theta|D\right)}\Pr{\left(\theta\right)}
\end{equation*}

In the Bayesian world, the unconditional distribution of the model parameters is assumed to come from a particular distribution, whereas in the frequentist world, no distributional assumptions are made about the model parameters. The latter is then equivalent to saying that $\theta\sim \mbox{Uniform}(-\infty, +\infty)$; therefore, even frequentists assume something about the model parameters![^frequentists]

[^frequentists]: The discussion about differences and similarities between frequentists and Bayesians has a long tradition. Bottom line, no one can say 100% that they are either-or. In rigor, frequentists say model parameters are not random but deterministic.

Bayes' rule can be derived using conditional probabilities. In particular, $\Pr{\left(x=x|Y=y\right)}$ is defined as $\Pr{\left(x=x, Y=y\right)}/Pr{\left(Y=y\right)}$. Likewise, $\Pr{\left(y=y|X=x\right)}$ is defined as $\Pr{\left(y=y, X=x\right)}/Pr{\left(X=x\right)}$, which can be re-written as $\Pr{\left(x=x, Y=y\right)} = \Pr{\left(y=y|X=x\right)}Pr{\left(X=x\right)}$. Replacing the last equality in the first equation we get

\begin{align*}
\Pr{\left(x=x|Y=y\right)} & = \frac{\Pr{\left(x=x, Y=y\right)}}{Pr{\left(Y=y\right)}} \\
& \frac{\Pr{\left(y=y|X=x\right)}Pr{\left(X=x\right)}}{Pr{\left(Y=y\right)}}
\end{align*}

# Markov Chain 

A Markov Chain is a sequence of random variables in which the conditional distribution of the $n$-th element only depends on $n-1$.

## Metropolis Algorithm

In the Metropolis Algorithm, or Metropolis MCMC, builds a Markov Chain that
under certain conditions converges to the target distribution. The key of the
Algorithm is in accepting a proposed move from $\theta$ to $\theta'$ with 
probability equal to:

\begin{equation}
r = \min\left(1, \frac{\Pr{\left(\theta'|D\right)}}{\Pr{\left(\theta|D\right)}}\right)
\end{equation}

The resulting sequence converges to the target distribution. We can prove
convergence by showing that (a) the sequence is ergodic, and (b) the posterior
distribution matches the target distribution. Ergodicity describes three
propoerties of a chain:

- Irreducibility: There is no zero probability of transitioning between any pair of states.

- Aperiodicity: As the term suggests, the chain has no repetitive periods/sequences.

- Non-transient: Transient refers to a chain having non-zero probability of
never returning to a starting state.

The three properties are reached by any random walk based on a well-defined
probability distribution, so we will focus on showing that the posterior matches
the target distribution.

<!--
 The following proof was adapted from "Bayesian Data
Analysis:" 
    \begin{align*}

\end{align*} -->

## Metropolis-Hastings

$$
\min\left(1, \frac{\Pr{\left(d|\theta'\right)}\Pr{\left(\theta'\right)}\Pr{\left(\theta'|\theta\right)}}{\Pr{\left(d|\theta\right)}\Pr{\left(\theta\right)}\Pr{\left(\theta|\theta'\right)}}\right)
$$

If the transittion probability is symmetric, then the previous equation reduces
to the Metropolis probability.

## Likelihood-free MCMC

1. Initialize the algorithm with $\theta_0$, $\theta^* =\theta_0$--the current accepted
state,--and observed summary statistic $s_0 = S(D_{observed})$:

2. For $t = 1$ to $T$ do:

    a. Draw $\theta_t$ from the proposal distribution $J(\theta_t|\theta^*)$

    b. Draw a simulated data $D_t$ from model $M(\theta_t)$

    c. Calculate the summary statistics $s_t = S(D_t)$

    d. Accept the proposed state with probability
    <!-- $$
    r = \min\left(1, \frac{\Pr{\left(s_0|s_t,\theta_t\right)}\Pr{\left(\theta_t\right)}\Pr{\left(\theta^*\to\theta_t\right)}}{\Pr{\left(s_0|s_{t-1\right)},\theta_{t-1}}\Pr{\left(\theta_{t-1\right)}}\Pr{\left(\theta_{t\right)}\to\theta^*}}\right)
    $$ -->

    If accepted, set $\theta^* = \theta_t$.

    e. Next $t$
