# Power calculation in network studies

In survey and study design, calculating the required sample size is key. Nowadays, tools and methods for calculating the required sample size abound; nonetheless, sample size calculation for studies involving social networks is still underdeveloped. In this chapter, we will illustrate how can we use computer simulations to estimate the required sample size. Chapter \@ref(part2-power) provides a general overview of power analysis.

## Example 1: Spillover effects in egocentric studies[^credit-ego-power]

Suppose that we want to run an intervention over a particular population and we are interested in the effects such intervention will have over the egos' alters. In economics, this problem, which they call the "spillover effect," is actively studied.

For the power calculation, we will assume that alters only get exposed if egos acquire the behavior. Furthermore, for this first run, we will assume that there is no social reinforcement or influence between alters. We will later relax this assumption. To calculate power we will do the following:

1. Simulate egos' behavior following a logit distribution.

2. Randomly drop some egos as a result of attrition.

3. Simulate alters' behavior using their egos as the treatment.

4. Fit a logistic regression based on the previous model.

5. Accept/reject the null and store the result.

The previous steps will be repeated 500 for each value of $n$ we analyze. We will finalize by plotting power against sample sizes. Let's first start by writing down the simulation parameters:


```r
# Design
n_sims    <- 500 # Number of simulations
n_a       <- 5   # Number of alters
sizes     <-     # Sizes to try
  seq(from = 100, to = 300, by = 25)

# Assumptions
odds_h_1  <- 1.5
attrition <- .3

# Parameters
alpha    <- .05
beta_pow <- 0.2
```

As we discuss in \@ref(part2-power), it is always a good idea to encapsule the simulation into a function:


```r
# The odds turned to a prob
theta_h_1 <- plogis(log(odds_h_1))

# Simulation function
sim_data <- function(n) {

  # Treatment assignment
  tr  <- c(rep(1, n/2), rep(0, n/2))

  # Step 1: Sampling population of egos
  y_ego <- runif(n) < c(
    rep(theta_h_1, n/2),
    rep(0.5, n/2)
  )

  # Step 2: Simulating attrition
  todrop <- order(runif(n))[1:(n * attrition)]
  y_ego  <- y_ego[-todrop]
  tr     <- tr[-todrop]
  n      <- n - length(todrop)

  # Step 3: Simulating alter's effect. We assume the same as in
  # ego
  tr_alter <- rep(y_ego * tr, n_a)
  y_alter  <- runif(n * n_a) < ifelse(tr_alter, theta_h_1, 0.5)

  # Step 4: Computing test statistic
  res_ego   <- tryCatch(glm(y_ego ~ tr, family = binomial("logit")), error = function(e) e)
  res_alter <- tryCatch(glm(y_alter ~ tr_alter, family = binomial("logit")), error = function(e) e)

  if (inherits(res_ego, "error") | inherits(res_alter, "error"))
    return(c(ego =  NA, alter = NA))
  
  # Step 5: Reject?
  c(
    ego   = summary(res_ego)$coefficients["tr", "Pr(>|z|)"] < alpha,
    alter = summary(res_alter)$coefficients["tr_alter", "Pr(>|z|)"] < alpha
  )
  

}
```

Now that we have the data generating function, we can run the simulations to approximate statistical power given the sample size. Since we are simulating data, it is important to set the seed so that we can reproduce the results. The results will be stored in the matrix `spower`.


```r
# We always set the seed
set.seed(88) 

# Making space, and running!
spower <- NULL
for (s in sizes) {

  # Run the simulation for size s
  simres <- rowMeans(replicate(n_sims, sim_data(s)), na.rm = TRUE)

  # And store the results
  spower <- rbind(spower, simres)

}
```

The following figure shows the approximate power for finding effects at both levels, ego and alter:


```r
library(ggplot2)

spower <- rbind(
  data.frame(size = sizes, power = spower[,"ego"], type =  "ego"),
  data.frame(size = sizes, power = spower[,"alter"], type =  "alter")
)

spower |>
  ggplot(aes(x = size, y = power, colour = type)) +
  geom_point() +
  geom_smooth(method = "loess", formula = y ~ x) +
  labs(x = "Number of Egos", y = "Approx. Power", colour = "Node type") +
  geom_hline(yintercept = 1 - beta_pow)
```

![](part-01-10-power_files/figure-epub3/part-01-power-plot1-1.png)<!-- -->

From the figure, it becomes apparent that, although there is not enough power to identify effects at the ego level, because each ego brings in five alters, the alter sample size is high enough that we can reach above 0.8 statistical power with relatively small sample size.

[^credit-ego-power]: The original problem was posed by [Dr. Shinduk Lee](https://faculty.utah.edu/u6037777-SHINDUK_LEE/hm/index.hml) from the School of Nursing at the University of Utah.
