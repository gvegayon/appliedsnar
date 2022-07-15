# Network diffussion with `netdiffuseR`


This chapter mainly was based on the 2018 and 2019 tutorials of netdiffuseR
at the Sunbelt conference. The source code of the tutorials, taught by [Thomas W. Valente](https://keck.usc.edu/faculty-search/thomas-william-valente/)
and [George G. Vega Yon](https://ggvy.cl) (author of this book), is available [here](https://github.com/USCCANA/netdiffuser-sunbelt2018/tree/sunbelt2019).


## Network diffusion of innovation

### Diffusion networks



<img source="https://github.com/USCCANA/netdiffuser-sunbelt2018/blob/sunbelt2019/valente_1995.jpg?raw=true" style="with: 200px"></img>

*   Explains how new ideas and practices (innovations) spread within and between
  communities.

*   While a lot of factors have been shown to influence diffusion (Spatial,
    Economic, Cultural, Biological, etc.), Social Networks is a prominent one.

*   There are many components in the diffusion network model including network exposures, thresholds, infectiousness, susceptibility, hazard rates, diffusion rates (bass model), clustering (Moran's I), and so on.


### Thresholds

*   One of the canonical concepts is the network threshold. Network thresholds (Valente, 1995; 1996), $\tau$, are defined as the required proportion or number of neighbors that lead you to adopt a particular behavior (innovation), $a=1$. In (very) general terms
    
    $$
    a_i = \left\{\begin{array}{ll}
    1 &\mbox{if } \tau_i\leq E_i \\
    0 & \mbox{Otherwise}
    \end{array}\right. \qquad
    E_i \equiv \frac{\sum_{j\neq i}\mathbf{X}_{ij}a_j}{\sum_{j\neq i}\mathbf{X}_{ij}}
    $$
    
    Where $E_i$ is i's exposure to the innovation and $\mathbf{X}$ is the adjacency matrix (the network).

*   This can be generalized and extended to include covariates and other network weighting schemes (that's what __netdiffuseR__ is all about).


## The netdiffuseR R package

### Overview

__netdiffuseR__ is an R package that:

*   Is designed for Visualizing, Analyzing, and Simulating network diffusion data (in general).

*   Depends on some pretty popular packages:

    *   _RcppArmadillo_: So it's fast,
    *   _Matrix_: So it's big,
    *   _statnet_ and _igraph_: So it's not from scratch

*   Can handle big graphs, e.g., an adjacency matrix with more than 4 billion elements (PR for RcppArmadillo)

*   Already on CRAN  with ~6,000 downloads since its first version, Feb 2016,

*   A lot of features to make it easy to read network (dynamic) data, making it a companion of other net packages.


### Datasets

- __netdiffuseR__ has the three classic Diffusion Network Datasets:
    
    - `medInnovationsDiffNet` Doctors and the innovation of Tetracycline (1955).
    - `brfarmersDiffNet` Brazilian farmers and the innovation of Hybrid Corn Seed (1966).
    - `kfamilyDiffNet` Korean women and Family Planning methods (1973).
    
    
    ```r
    brfarmersDiffNet
    ```
    
    ```
    ## Dynamic network of class -diffnet-
    ##  Name               : Brazilian Farmers
    ##  Behavior           : Adoption of Hybrid Corn Seeds
    ##  # of nodes         : 692 (1001, 1002, 1004, 1005, 1007, 1009, 1010, 1020, ...)
    ##  # of time periods  : 21 (1946 - 1966)
    ##  Type               : directed
    ##  Final prevalence   : 1.00
    ##  Static attributes  : village, idold, age, liveout, visits, contact, coo... (146)
    ##  Dynamic attributes : -
    ```
    
    ```r
    medInnovationsDiffNet
    ```
    
    ```
    ## Dynamic network of class -diffnet-
    ##  Name               : Medical Innovation
    ##  Behavior           : Adoption of Tetracycline
    ##  # of nodes         : 125 (1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, ...)
    ##  # of time periods  : 18 (1 - 18)
    ##  Type               : directed
    ##  Final prevalence   : 1.00
    ##  Static attributes  : city, detail, meet, coll, attend, proage, length, ... (58)
    ##  Dynamic attributes : -
    ```
    
    ```r
    kfamilyDiffNet
    ```
    
    ```
    ## Dynamic network of class -diffnet-
    ##  Name               : Korean Family Planning
    ##  Behavior           : Family Planning Methods
    ##  # of nodes         : 1047 (10002, 10003, 10005, 10007, 10010, 10011, 10012, 10014, ...)
    ##  # of time periods  : 11 (1 - 11)
    ##  Type               : directed
    ##  Final prevalence   : 1.00
    ##  Static attributes  : village, recno1, studno1, area1, id1, nmage1, nmag... (430)
    ##  Dynamic attributes : -
    ```

### Visualization methods


```r
set.seed(12315)
x <- rdiffnet(
  400, t = 6, rgraph.args = list(k=6, p=.3),
  seed.graph = "small-world",
  seed.nodes = "central", rewire = FALSE, threshold.dist = 1/4
  )
plot(x)
```

![](part-01-08-netdiffuser_files/figure-epub3/viz-1.png)<!-- -->

```r
plot_diffnet(x)
```

![](part-01-08-netdiffuser_files/figure-epub3/viz-2.png)<!-- -->

```r
plot_diffnet2(x)
```

![](part-01-08-netdiffuser_files/figure-epub3/viz-3.png)<!-- -->

```r
plot_adopters(x)
```

![](part-01-08-netdiffuser_files/figure-epub3/viz-4.png)<!-- -->

```r
plot_threshold(x)
```

![](part-01-08-netdiffuser_files/figure-epub3/viz-5.png)<!-- -->

```r
plot_infectsuscep(x, K=2)
```

```
## Warning in plot_infectsuscep.list(graph$graph, graph$toa, t0, normalize, : When
## applying logscale some observations are missing.
```

![](part-01-08-netdiffuser_files/figure-epub3/viz-6.png)<!-- -->

```r
plot_hazard(x)
```

![](part-01-08-netdiffuser_files/figure-epub3/viz-7.png)<!-- -->


### Problems

1. Using the diffnet object in [`intro.rda`](intro.rda), use the function `plot_threshold` specifying
    shapes and colors according to the variables ItrustMyFriends and Age. Do you see any pattern?

## Simulation of diffusion processes




Before we start, a review of the concepts we will be using here

1. Exposure: Proportion/number of neighbors that have adopted an innovation at each point in time.
2. Threshold: The proportion/number of your neighbors who had adopted at or one time period before ego (the focal individual) adopted.
3. Infectiousness: How much $i$'s adoption affects her alters.
4. Susceptibility: How much $i$'s alters' adoption affects her.
5. Structural equivalence: How similar is $i$ to $j$ in terms of position in the network.

### Simulating diffusion networks

We will simulate a diffusion network with the following parameters:

1. Will have 1,000 vertices,
2. Will span 20 time periods,
3. The initial adopters (seeds) will be selected at random,
4. Seeds will be a 10\% of the network,
5. The graph (network) will be small-world,
6. Will use the WS algorithm with $p=.2$ (probability of rewiring).
7. Threshold levels will be uniformly distributed between [0.3, 0.7\]

To generate this diffusion network, we can use the `rdiffnet` function included in the package:



```r
# Setting the seed for the RNG
set.seed(1213)

# Generating a random diffusion network
net <- rdiffnet(
  n              = 1e3,                         # 1.
  t              = 20,                          # 2.
  seed.nodes     = "random",                    # 3.
  seed.p.adopt   = .1,                          # 4.
  seed.graph     = "small-world",               # 5.
  rgraph.args    = list(p=.2),                  # 6.
  threshold.dist = function(x) runif(1, .3, .7) # 7.
  )
```


*   The function `rdiffnet` generates random diffusion networks. Main features:
    
    1. Simulating random graph or using your own,
    
    2. Setting threshold levels per node,
    
    3. Network rewiring throughout the simulation, and
    
    4. Setting the seed nodes.
    
    
*   The simulation algorithm is as follows:
    
    1. If required, a baseline graph is created,
    
    2. Set of initial adopters and threshold distribution are established,
    
    3. The set of t networks is created (if required), and
    
    4. Simulation starts at t=2, assigning adopters based on exposures and thresholds:
    
        a.  For each $i \in N$, if its exposure at $t-1$ is greater than its threshold, then 
            adopts, otherwise, continue without change.
            
        b.  next $i$
    
### Rumor spreading


```r
library(netdiffuseR)

set.seed(09)
diffnet_rumor <- rdiffnet(
  n = 5e2,
  t = 5, 
  seed.graph = "small-world",
  rgraph.args = list(k = 4, p = .3),
  seed.nodes = "random",
  seed.p.adopt = .05,
  rewire = TRUE,
  threshold.dist = function(i) 1L,
  exposure.args = list(normalized = FALSE)
  )
```


```r
summary(diffnet_rumor)
```

```
## Diffusion network summary statistics
## Name     : A diffusion network
## Behavior : Random contagion
## -----------------------------------------------------------------------------
##  Period   Adopters   Cum Adopt. (%)   Hazard Rate   Density   Moran's I (sd)  
## -------- ---------- ---------------- ------------- --------- ---------------- 
##        1         25        25 (0.05)             -      0.01 -0.00 (0.00)     
##        2         78       103 (0.21)          0.16      0.01  0.01 (0.00) *** 
##        3        187       290 (0.58)          0.47      0.01  0.01 (0.00) *** 
##        4        183       473 (0.95)          0.87      0.01  0.01 (0.00) *** 
##        5         27       500 (1.00)          1.00      0.01               -  
## -----------------------------------------------------------------------------
##  Left censoring  : 0.05 (25)
##  Right centoring : 0.00 (0)
##  # of nodes      : 500
## 
##  Moran's I was computed on contemporaneous autocorrelation using 1/geodesic
##  values. Significane levels  *** <= .01, ** <= .05, * <= .1.
```



```r
plot_diffnet(diffnet_rumor, slices = c(1, 3, 5))
```

<img src="part-01-08-netdiffuser_files/figure-epub3/plot-rumor-1.png" style="display: block; margin: auto;" />

```r
# We want to use igraph to compute layout
igdf <- diffnet_to_igraph(diffnet_rumor, slices=c(1,2))[[1]]
pos <- igraph::layout_with_drl(igdf)

plot_diffnet2(diffnet_rumor, vertex.size = dgr(diffnet_rumor)[,1], layout=pos)
```

<img src="part-01-08-netdiffuser_files/figure-epub3/plot-rumor-2.png" style="display: block; margin: auto;" />

### Difussion


```r
set.seed(09)
diffnet_complex <- rdiffnet(
  seed.graph = diffnet_rumor$graph,
  seed.nodes = which(diffnet_rumor$toa == 1),
  rewire = FALSE,
  threshold.dist = function(i) rbeta(1, 3, 10),
  name = "Diffusion",
  behavior = "Some social behavior"
)
```


```r
plot_adopters(diffnet_rumor, what = "cumadopt", include.legend = FALSE)
plot_adopters(diffnet_complex, bg="tomato", add=TRUE, what = "cumadopt")
legend("topleft", legend = c("Disease", "Complex"), col = c("lightblue", "tomato"),
       bty = "n", pch=19)
```

![](part-01-08-netdiffuser_files/figure-epub3/plot-complex-and-disease-1.png)<!-- -->


### Mentor Matching


```r
# Finding mentors
mentors <- mentor_matching(diffnet_rumor, 25, lead.ties.method = "random")

# Simulating diffusion with these mentors
set.seed(09)
diffnet_mentored <- rdiffnet(
  seed.graph = diffnet_complex,
  seed.nodes = which(mentors$`1`$isleader),
  rewire = FALSE,
  threshold.dist = diffnet_complex[["real_threshold"]],
  name = "Diffusion using Mentors"
)

summary(diffnet_mentored)
```

```
## Diffusion network summary statistics
## Name     : Diffusion using Mentors
## Behavior : Random contagion
## -----------------------------------------------------------------------------
##  Period   Adopters   Cum Adopt. (%)   Hazard Rate   Density   Moran's I (sd)  
## -------- ---------- ---------------- ------------- --------- ---------------- 
##        1         25        25 (0.05)             -      0.01 -0.00 (0.00)     
##        2         92       117 (0.23)          0.19      0.01  0.01 (0.00) *** 
##        3        152       269 (0.54)          0.40      0.01  0.01 (0.00) *** 
##        4        150       419 (0.84)          0.65      0.01  0.01 (0.00) *** 
##        5         73       492 (0.98)          0.90      0.01 -0.00 (0.00) **  
## -----------------------------------------------------------------------------
##  Left censoring  : 0.05 (25)
##  Right centoring : 0.02 (8)
##  # of nodes      : 500
## 
##  Moran's I was computed on contemporaneous autocorrelation using 1/geodesic
##  values. Significane levels  *** <= .01, ** <= .05, * <= .1.
```


```r
cumulative_adopt_count(diffnet_complex)
```

```
##          1     2        3           4           5
## num  25.00 80.00 183.0000 338.0000000 470.0000000
## prop  0.05  0.16   0.3660   0.6760000   0.9400000
## rate  0.00  2.20   1.2875   0.8469945   0.3905325
```

```r
cumulative_adopt_count(diffnet_mentored)
```

```
##          1       2          3           4           5
## num  25.00 117.000 269.000000 419.0000000 492.0000000
## prop  0.05   0.234   0.538000   0.8380000   0.9840000
## rate  0.00   3.680   1.299145   0.5576208   0.1742243
```


### Example by changing threshold


```r

# Simulating a scale-free homophilic network
set.seed(1231)
X <- rep(c(1,1,1,1,1,0,0,0,0,0), 50)
net <- rgraph_ba(t = 499, m=4, eta = X)

# Taking a look in igraph
ig  <- igraph::graph_from_adjacency_matrix(net)
plot(ig, vertex.color = c("azure", "tomato")[X+1], vertex.label = NA,
     vertex.size = sqrt(dgr(net)))
```

![](part-01-08-netdiffuser_files/figure-epub3/sim-sim-1.png)<!-- -->

```r

# Now, simulating a bunch of diffusion processes
nsim <- 500L
ans_1and2 <- vector("list", nsim)
set.seed(223)
for (i in 1:nsim) {
  # We just want the cum adopt count
  ans_1and2[[i]] <- 
    cumulative_adopt_count(
      rdiffnet(
        seed.graph = net,
        t = 10,
        threshold.dist = sample(1:2, 500L, TRUE),
        seed.nodes = "random",
        seed.p.adopt = .10,
        exposure.args = list(outgoing = FALSE, normalized = FALSE),
        rewire = FALSE
        )
      )
  
  # Are we there yet?
  if (!(i %% 50))
    message("Simulation ", i," of ", nsim, " done.")
}
## Simulation 50 of 500 done.
## Simulation 100 of 500 done.
## Simulation 150 of 500 done.
## Simulation 200 of 500 done.
## Simulation 250 of 500 done.
## Simulation 300 of 500 done.
## Simulation 350 of 500 done.
## Simulation 400 of 500 done.
## Simulation 450 of 500 done.
## Simulation 500 of 500 done.

# Extracting prop
ans_1and2 <- do.call(rbind, lapply(ans_1and2, "[", i="prop", j=))

ans_2and3 <- vector("list", nsim)
set.seed(223)
for (i in 1:nsim) {
  # We just want the cum adopt count
  ans_2and3[[i]] <- 
    cumulative_adopt_count(
      rdiffnet(
        seed.graph = net,
        t = 10,
        threshold.dist = sample(2:3, 500L, TRUE),
        seed.nodes = "random",
        seed.p.adopt = .10,
        exposure.args = list(outgoing = FALSE, normalized = FALSE),
        rewire = FALSE
        )
      )
  
  # Are we there yet?
  if (!(i %% 50))
    message("Simulation ", i," of ", nsim, " done.")
}
## Simulation 50 of 500 done.
## Simulation 100 of 500 done.
## Simulation 150 of 500 done.
## Simulation 200 of 500 done.
## Simulation 250 of 500 done.
## Simulation 300 of 500 done.
## Simulation 350 of 500 done.
## Simulation 400 of 500 done.
## Simulation 450 of 500 done.
## Simulation 500 of 500 done.

ans_2and3 <- do.call(rbind, lapply(ans_2and3, "[", i="prop", j=))
```

We can simplify by using the function `rdiffnet_multiple`. The following lines of code accomplish the same as the previous code avoiding the for-loop (from the user's perspective). Besides of the usual parameters passed to `rdiffnet`, the `rdiffnet_multiple` function requires `R` (number of repetitions/simulations), and `statistic` (a function that returns the statistic of interest). Optionally, the user may choose to specify the number of clusters to run it in parallel (multiple CPUs):


```r
ans_1and3 <- rdiffnet_multiple(
  # Num of sim
  R              = nsim,
  # Statistic
  statistic      = function(d) cumulative_adopt_count(d)["prop",], 
  seed.graph     = net,
  t              = 10,
  threshold.dist = sample(1:3, 500, TRUE),
  seed.nodes     = "random",
  seed.p.adopt   = .1,
  rewire         = FALSE,
  exposure.args  = list(outgoing=FALSE, normalized=FALSE),
  # Running on 4 cores
  ncpus          = 4L
  )
```


```r
boxplot(ans_1and2, col="ivory", xlab = "Time", ylab = "Threshold")
boxplot(ans_2and3, col="tomato", add=TRUE)
boxplot(t(ans_1and3), col = "steelblue", add=TRUE)
legend(
  "topleft",
  fill = c("ivory", "tomato", "steelblue"),
  legend = c("1/2", "2/3", "1/3"),
  title = "Threshold range",
  bty ="n"
)
```

![](part-01-08-netdiffuser_files/figure-epub3/sim-sim-results-1.png)<!-- -->


<!-- *   Example simulating a thousand networks by changing threshold levels.
    The final prevalence, or hazard as a function of threshold levels. -->

### Problems

1.  Given the following types of networks: Small-world, Scale-free, Bernoulli,
    what set of $n$ initiators maximizes diffusion?
    <!-- (<a href="sim-solutions.r" target="_blank">solution script</a> and <a href="sim-solutions.png" target="_blank">solution plot</a>) -->
    
## Statistical inference

### Moran's I

*   Moran's I tests for spatial autocorrelation.
    
*   __netdiffuseR__ implements the test in `moran`, which is suited for sparse matrices.

*   We can use Moran's I as a first look to whether there is something happening:
    let that be influence or homophily.

### Using geodesics

*   One approach is to use the geodesic (shortest path length) matrix to account for indirect
    influence.
    
*   In the case of sparse matrices, and furthermore, in the presence of structural holes
    it is more convenient to calculate the distance matrix taking this into account.
    
*   __netdiffuseR__ has a function to do so, the `approx_geodesic` function, which,
    using graph powers, computes the shortest path up to `n` steps. This could be
    faster (if you only care up to `n` steps) than `igraph` or `sns`:

    
    ```r
    # Extracting the large adjacency matrix (stacked)
    dgc <- diag_expand(medInnovationsDiffNet$graph)
    ig  <- igraph::graph_from_adjacency_matrix(dgc)
    mat <- network::as.network(as.matrix(dgc))
    
    # Measuring times
    times <- microbenchmark::microbenchmark(
      netdiffuseR = netdiffuseR::approx_geodesic(dgc),
      igraph = igraph::distances(ig),
      sna = sna::geodist(mat),
      times = 50, unit="ms"
    )
    ```
    
    ![](part-01-08-netdiffuser_files/figure-epub3/geodesic_speed-box-1.png)<!-- -->

*   The `summary.diffnet` method already runs Moran's for you. What happens under the hood is:
    
    
    ```r
    # For each time point we compute the geodesic distances matrix
    W <- approx_geodesic(medInnovationsDiffNet$graph[[1]])
    
    # We get the element-wise inverse
    W@x <- 1/W@x
    
    # And then compute moran
    moran(medInnovationsDiffNet$cumadopt[,1], W)
    ```
    
    ```
    ## $observed
    ## [1] 0.06624028
    ## 
    ## $expected
    ## [1] -0.008064516
    ## 
    ## $sd
    ## [1] 0.03265066
    ## 
    ## $p.value
    ## [1] 0.02286087
    ## 
    ## attr(,"class")
    ## [1] "diffnet_moran"
    ```



### Structural dependence and permutation tests


- A novel statistical method (work-in-progress) that allows conducting inference.
- Included in the package, tests whether a particular network statistic depends on network structure
- Suitable to be applied to network thresholds (you can't use thresholds in regression-like models!)

### Idea

-   Let $\mathcal{G} = (V,E)$ be a graph, $\gamma$ a vertex attribute, and $\beta = f(\gamma,\mathcal{G})$, then

    $$\gamma \perp \mathcal{G} \implies \mathbb{E}\left[\beta(\gamma,\mathcal{G})|\mathcal{G}\right] = \mathbb{E}\left[\beta(\gamma,\mathcal{G})\right]$$

- This is, if for example time of adoption is independent on the structure of the network, then the average threshold level will be independent from the network structure as well.

- Another way of looking at this is that the test will allow us to see how probable is to have this combination of network structure and network threshold (if it is uncommon then we say that the diffusion model is highly likely)


#### Example Not random TOA

-     To use this test, __netdiffuseR__ has the `struct_test` function.
-     It simulates networks with the same density, and computes a particular statistic every time, generating an EDF (Empirical Distribution Function) under the Null hypothesis (p-values).
    
    
    ```r
    # Simulating network
    set.seed(1123)
    net <- rdiffnet(n=500, t=10, seed.graph = "small-world")
    
    # Running the test
    test <- struct_test(
      graph     = net, 
      statistic = function(x) mean(threshold(x), na.rm = TRUE),
      R         = 1e3,
      ncpus=4, parallel="multicore"
      )
    
    # See the output
    test
    ```
    
    ```
    ## 
    ## Structure dependence test
    ## # Simulations     : 1,000
    ## # nodes           : 500
    ## # of time periods : 10
    ## --------------------------------------------------------------------------------
    ##  H0: E[beta(Y,G)|G] - E[beta(Y,G)] = 0 (no structure dependency)
    ##     observed    expected       p.val
    ##       0.5513      0.2513      0.0000
    ```

![](part-01-08-netdiffuser_files/figure-epub3/unnamed-chunk-2-1.png)<!-- -->

-   Now we shuffle times of adoption, so that is random
    
    
    ```r
    # Resetting TOAs (now will be completely random)
    diffnet.toa(net) <- sample(diffnet.toa(net), nnodes(net), TRUE)
    
    # Running the test
    test <- struct_test(
      graph     = net, 
      statistic = function(x) mean(threshold(x), na.rm = TRUE),
      R         = 1e3,
      ncpus=4, parallel="multicore"
      )
    
    # See the output
    test
    ```
    
    ```
    ## 
    ## Structure dependence test
    ## # Simulations     : 1,000
    ## # nodes           : 500
    ## # of time periods : 10
    ## --------------------------------------------------------------------------------
    ##  H0: E[beta(Y,G)|G] - E[beta(Y,G)] = 0 (no structure dependency)
    ##     observed    expected       p.val
    ##       0.2714      0.2590      0.4580
    ```
    
    ![](part-01-08-netdiffuser_files/figure-epub3/unnamed-chunk-3-1.png)<!-- -->

### Regression analysis

*   In regression analysis, we want to see if exposure, once we control for other
    covariates had any effect on the adoption of a behavior.

*   In general, the big problem here is when we have a latent variable that 
    co-determines both network and behavior.
    
*   Unless we can control for such variable, regression analysis will be
    generically biased.
    
*   On the other hand, if you can claim that either such variable doesn't exist
    or you actually can control for it, then we have two options: lagged exposure
    models or contemporaneous exposure models. We will focus on the former.


#### Lagged exposure models

*   In this type of model, we usually have the following

    $$
    y_t = f(W_{t-1}, y_{t-1}, X_i) + \varepsilon
    $$
    
    Furthermore, in the case of adoption, we have
    
    $$
    y_{it} = \left\{
    \begin{array}{ll}
    1 & \mbox{if}\quad \rho\sum_{j\neq i}\frac{W_{ijt-1}y_{it-1}}{\sum_{j\neq i}W_{ijt-1}} + X_{it}\beta > 0\\
    0 & \mbox{otherwise}
    \end{array}
    \right.
    $$
    
*   In netdiffuseR is as easy as doing the following:
    
    
    ```r
    # fakedata
    set.seed(121)
    
    W   <- rgraph_ws(1e3, 8, .2)
    X   <- cbind(var1 = rnorm(1e3))
    toa <- sample(c(NA,1:5), 1e3, TRUE)
    
    dn  <- new_diffnet(W, toa=toa, vertex.static.attrs = X)
    ```
    
    ```
    ## Warning in new_diffnet(W, toa = toa, vertex.static.attrs = X): -graph- is static
    ## and will be recycled (see ?new_diffnet).
    ```
    
    ```r
    # Computing exposure and adoption for regression
    dn[["cohesive_expo"]] <- cbind(NA, exposure(dn)[,-nslices(dn)])
    dn[["adopt"]]         <- dn$cumadopt
    
    # Generating the data and running the model
    dat <- as.data.frame(dn)
    ans <- glm(adopt ~ cohesive_expo + var1 + factor(per),
               data = dat,
               family = binomial(link="probit"),
               subset = is.na(toa) | (per <= toa))
    summary(ans)
    ```
    
    ```
    ## 
    ## Call:
    ## glm(formula = adopt ~ cohesive_expo + var1 + factor(per), family = binomial(link = "probit"), 
    ##     data = dat, subset = is.na(toa) | (per <= toa))
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.1754  -0.8462  -0.6645   1.2878   1.9523  
    ## 
    ## Coefficients:
    ##               Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)   -0.92777    0.05840 -15.888  < 2e-16 ***
    ## cohesive_expo  0.23839    0.17514   1.361 0.173452    
    ## var1          -0.04623    0.02704  -1.710 0.087334 .  
    ## factor(per)3   0.29313    0.07715   3.799 0.000145 ***
    ## factor(per)4   0.33902    0.09897   3.425 0.000614 ***
    ## factor(per)5   0.59851    0.12193   4.909 9.18e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 2745.1  on 2317  degrees of freedom
    ## Residual deviance: 2663.5  on 2312  degrees of freedom
    ##   (1000 observations deleted due to missingness)
    ## AIC: 2675.5
    ## 
    ## Number of Fisher Scoring iterations: 4
    ```
    
    Alternatively, we could have used the new function `diffreg`
    
    
    ```r
    ans <- diffreg(dn ~ exposure + var1 + factor(per), type = "probit")
    summary(ans)
    ```
    
    ```
    ## 
    ## Call:
    ## glm(formula = Adopt ~ exposure + var1 + factor(per), family = binomial(link = "probit"), 
    ##     data = dat, subset = ifelse(is.na(toa), TRUE, toa >= per))
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.1754  -0.8462  -0.6645   1.2878   1.9523  
    ## 
    ## Coefficients:
    ##              Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)  -0.92777    0.05840 -15.888  < 2e-16 ***
    ## exposure      0.23839    0.17514   1.361 0.173452    
    ## var1         -0.04623    0.02704  -1.710 0.087334 .  
    ## factor(per)3  0.29313    0.07715   3.799 0.000145 ***
    ## factor(per)4  0.33902    0.09897   3.425 0.000614 ***
    ## factor(per)5  0.59851    0.12193   4.909 9.18e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 2745.1  on 2317  degrees of freedom
    ## Residual deviance: 2663.5  on 2312  degrees of freedom
    ##   (1000 observations deleted due to missingness)
    ## AIC: 2675.5
    ## 
    ## Number of Fisher Scoring iterations: 4
    ```
    

#### Contemporaneous exposure models

*   Similar to the lagged exposure models, we usually have the following

    $$
    y_t = f(W_t, y_t, X_t) + \varepsilon
    $$
    
    Furthermore, in the case of adoption, we have
    
    $$
    y_{it} = \left\{
    \begin{array}{ll}
    1 & \mbox{if}\quad \rho\sum_{j\neq i}\frac{W_{ijt}y_{it}}{\sum_{j\neq i}W_{ijt}} + X_{it}\beta > 0\\
    0 & \mbox{otherwise}
    \end{array}
    \right.
    $$
    
*   Unfortunately, since $y_t$ is in both sides of the equation, this models cannot
    be fitted using a standard probit or logit regression.
    
*   Two alternatives to solve this:
    
    a.  Using Instrumental Variables Probit (ivprobit in both R and Stata)
    
    b.  Use a Spatial Autoregressive (SAR) Probit (SpatialProbit and ProbitSpatial in R).
    
*   We won't cover these here.

### Problems

Using the dataset [stats.rda](stats.rda):

1.  Compute Moran's I as the function `summary.diffnet` does. For this you'll need
to use the function `toa_mat` (which calculates the cumulative adoption matrix),
and `approx_geodesic` (which computes the geodesic matrix). (see `?summary.diffnet`
for more details).

2.  Read the data as diffnet object, and fit the following logit model $adopt = Exposure*\gamma + Measure*\beta + \varepsilon$.
    What happens if you exclude the time-fixed effects?
    
<!-- (<a href="stats-solutions.r" target="_blank">solution script</a>) -->

<!-- ```{r datagen, echo=FALSE, cache=TRUE}
set.seed(1)
n <- 500
nper <- 5
X <- cbind(Measure=rnorm(n))
y <- cbind(sample(c(0, 1), n, TRUE, prob = c(.9, .1)))
# Baseline network
W <- (rgraph_ws(n, k=8, p = .2))
sim_space <- function(W, y, X, pers = 4, lag = FALSE, rho = .2, beta=.5) {
  W <- as.matrix(W)
  W <- W/(rowSums(W) + 1e-20)
  n <- nrow(W)
  for (i in 1:pers) {
    if (!lag)
      ynew <- (solve(diag(n) - rho*W) %*% (X*beta) + rnorm(n)) > 0
    else
      ynew <- (rho * (W %*% y[,i - as.integer(i != 1),drop=FALSE]) + beta*X + rnorm(n)) > 0
    
    y <- cbind(y, ifelse(
      y[,i - as.integer(i != 1),drop=FALSE] == 1,
      y[,i - as.integer(i != 1),drop=FALSE], 
      ynew)
      )
  }
  
  y
}
ans <- sim_space(W, y, X, pers = nper, lag=TRUE)
toa <- ncol(ans) - apply(ans, 1, sum)
X <- cbind(X, toa=ifelse(toa == 0, NA, toa))
save(X, W, file="stats.rda")
``` -->
