# Simulating and visualizing networks

In this chapter, we will build and visualize artificial networks using Exponential
Random Graph Models [ERGMs.] Together with chapter 3, this will be an extended 
example of how to read network data and visualize it using some of the available
R packages out there.

For this chapter we will be using the following R packages: `ergm`, `sna`, `igraph`,
`intergraph`, `netplot`, `netdiffuseR`, and `rgexf`.

## Random Graph Models

While there are tons of social network data, we will use an artificial one for this chapter.
We do this as it is always helpful to have more examples simulating Random
networks. For this chapter, we will classify random graph models for sampling and
generating networks into three categories:

1. **Exogenous**: Graphs where the structure is determined by a macro rule, e.g., 
expected density, degree distribution, or degree-sequence. In these cases,
ties are assigned to comply with a macro-property.

2. **Endogenous**: This category includes all Random Graphs generated based
on endogenous information, e.g., small-world, scale-free, etc. Here, a tie 
creation rule gives origin to a macro property, for example, preferential attachment
in scale-free networks.

3. **Exponential Random Graph Models**: Overall, since ERGMs compose a family
of statistical models, we can always (or almost always) find a model specification
that matches the previous categories. Whereas we are thinking about degree sequence,
preferential attachment, or a mix of both, ERGMs can be the baseline for any of
those models.

The later, ERGMs, are a generalization that covers all classes. Because of that,
we will use ERGMs to generate our artificial network.

## Social Networks in Schools

A common type of network we analyze is friendship networks. In this case,
we will use ERGMs to simulate friendship networks within a school. In our 
simulated world, these networks will be dominated by the following phenomena

- Low density,
- Race homophily,
- Structural balance,
- And age homophily.

If you have been paying attention to the previous chapters, you will notice that,
out of these five properties, only one constitutes Markov graphs. Within a tie,
homophily and density only depend on ego and alter. In race homophily, only ego
and alter's race matter for the tie formation, but, in the case of Structural
balance, ego is more likely to befriend alter if a fried of ego is friends with alter,
i.e., "the friend of my friend is my friend."

The simulation steps are as follows:

1. Draw a population of $n$ students and randomly distribute race and age across them.

2. Create a `network` object.

2. Simulate the ties in the empty network.

Here is the code


```r
set.seed(712)
n <- 200

# Step 1: Students
race   <- sample(c("white", "non-white"), n, replace = TRUE)
age    <- sample(c(10, 14, 17), n, replace = TRUE)

# Step 2: Create an empty network
library(ergm)
library(network)
net <- network.initialize(n)

net %v% "race"   <- race
net %v% "age"    <- age

# Step 3: Simulate a graph
net_sim <- simulate(
    net ~ edges +
    nodematch("race") +
    triangle +
    absdiff("age"),
    coef = c(-4, .5, .5, -.5)
    )
```

What just happened? Here is a line-by-line breakout:

1. `set.seed(712)` Since this is a random simulation, we need to fix a seed so it is reproducible. Otherwise, results would change with every iteration.

2. `n <- 200` We are assigning the value `200` to the object `n`. This will make things easier as, if needed, changing the size of the networks can be done at the top of the code.

3. `race <- sample(c("white", "non-white"), n, replace = TRUE)` We are sampling 200, or actually, `n` values from the vector `c("white", "non-white")` with replacement.

4. `age <- sample(c(10, 14, 17), n, replace = TRUE)` Same as before, but with ages!

5. `library(ergm)` Loading the ergm R package, which we need to simulate the networks!

6. `library(network)` Loading the `network` R package, which we need to create the empty graph.

7. `net <- network.initialize(n)` Creating an empty graph of size `n`.

8. `net %v% "race" <- race` Using the `%v%` operator, we can access vertices features in the network object. Since race does not exist in the network yet, the operator just creates it. Notice that the number of vertices matches the length of the race vector.

9. `net %v% "age" <- age` Same as with race!

10. `net_sim <- simulate(` Simulating an ERGM!

Let's take a quick look at the resulting graph


```r
library(sna)
gplot(net_sim)
```

![](06-network-simulation-and-viz_files/figure-epub3/06-first-fig-1.png)<!-- -->

We can now start to see whether we got what we wanted! Before that, let's save the 
network as a plain-text file so we can practice reading networks back in R!


```r
write.csv(
  x         = as.edgelist(net_sim),
  file      = "06-edgelist.csv",
  row.names = FALSE
  )

write.csv(
  x         = as.data.frame(net_sim, unit = "vertices"),
  file      = "06-nodes.csv",
  row.names = FALSE
  )
```

## Reading a network

The first step to analyzing network data is to read it in. Many times you'll find
data in the form of an adjacency matrix. Other times, data will come in the form
of an edgelist. Another common format is the adjacency list, which is a compressed
version of an edgelist. Let's see how the formats look like for the following
network:


```r
example_graph <- matrix(0L, 4, 4, dimnames = list(letters[1:4], letters[1:4]))
example_graph[c(2, 7)] <- 1L
example_graph["c", "d"] <- 1L
example_graph["d", "c"] <- 1L
example_graph <- as.network(example_graph)
set.seed(1231)
gplot(example_graph, label = letters[1:4])
```

![](06-network-simulation-and-viz_files/figure-epub3/06-fake-graph-read-1.png)<!-- -->

- **Adjacency matrix** a matrix of size $n$ by $n$ where the $ij$-th entry represents
the tie between $i$ and $j$. In a directed network, we say $i$ connects to $j$,
so the $i$-th row shows the ties $i$ sends to the rest of the network. Likewise,
in a directed graph, the $j$-th column shows the ties sent to $j$. For undirected
graphs, the adjacency matrix is usually upper or lower diagonal. The adjacency
matrix of an undirected graph is symmetric, so we don't need to report the same
information twice. For example:


```r
as.matrix(example_graph)
```

```
##   a b c d
## a 0 0 0 0
## b 1 0 0 0
## c 0 1 0 1
## d 0 0 1 0
```

- **Edge list** a matrix of size $|E|$ by $2$, where $|E|$ is the number of edges.
Each entry represents a tie in the graph. 


```r
as.edgelist(example_graph)
```

```
##      [,1] [,2]
## [1,]    2    1
## [2,]    3    2
## [3,]    3    4
## [4,]    4    3
## attr(,"n")
## [1] 4
## attr(,"vnames")
## [1] "a" "b" "c" "d"
## attr(,"directed")
## [1] TRUE
## attr(,"bipartite")
## [1] FALSE
## attr(,"loops")
## [1] FALSE
## attr(,"class")
## [1] "matrix_edgelist" "edgelist"        "matrix"          "array"
```
  
  The command turns the `network` object into a matrix with a set of attributes
  (which are also printed.)

- **Adjacency list** This data format uses less space than edgelists as ties are
  grouped by ego (source.)


```r
igraph::as_adj_list(intergraph::asIgraph(example_graph)) 
```

```
## [[1]]
## + 1/4 vertex, from c8f0a74:
## [1] 2
## 
## [[2]]
## + 2/4 vertices, from c8f0a74:
## [1] 1 3
## 
## [[3]]
## + 3/4 vertices, from c8f0a74:
## [1] 2 4 4
## 
## [[4]]
## + 2/4 vertices, from c8f0a74:
## [1] 3 3
```

  The function `igraph::as_adj_list` turns the igraph object into a list of
  type adjacency list. In plain text it would look something like this:

  ```
  2 
  1 3 
  2 4 4 
  3 3 
  ```

Here we will deal with an edgelist that includes node information.
In my opinion, this is one of the best ways to share network data. Let's read
the data into R using the function `read.csv`:


```r
edges <- read.csv("06-edgelist.csv")
nodes <- read.csv("06-nodes.csv")
```

We now have two objects of class `data.frame`, edges and nodes. Let's inspect
them using the `head` function:


```r
head(edges)
```

```
##   V1  V2
## 1  1  64
## 2  2  41
## 3  2 106
## 4  3  61
## 5  4  85
## 6  4 138
```

```r
head(nodes)
```

```
##   vertex.names      race age
## 1            1 non-white  10
## 2            2     white  10
## 3            3     white  17
## 4            4 non-white  14
## 5            5 non-white  17
## 6            6 non-white  14
```

It is always important to look at the data before creating the network. Most common
errors happen before reading the data in and could go undetected in many cases.
A few examples:

- Headers in the file could be treated as data, or the files may not
have headers.

- Ego/alter columns may show in the wrong order. Both the `igraph` and `network`
packages take the first and second columns of edgelists as ego and alter.

- Isolates, which wouldn't show in the edgelist, may be missing from the node
information set. This is one of the most common errors.

- Nodes showing in the edgelist may be missing from the nodelist.


Both `igraph` and network have functions to read edgelist with a corresponding
nodelist; the functions `graph_from_data_frame` and `as.nework`, respectively. Although
, for both cases, you can avoid using a nodelist, it is highly recommended as then
you will (a) make sure that isolates are included and (b) become aware of possible
problems in the data. A frequent error in `graph_from_data_frame` is nodes present
in the edgelist but not in the set of nodes. 


```r
net_ig <- igraph::graph_from_data_frame(
  d        = edges,
  directed = TRUE,
  vertices = nodes
)
```

Using `as.network` from the `network` package:


```r
net_net <- network::as.network(
  x        = edges,
  directed = TRUE,
  vertices = nodes
)
```

As you can see, both syntaxes are very similar. The main point here is that the
more explicit we are, the better. Nevertheless, R can be brilliant; being
*shy*, i.e., not throwing warnings or errors, is not uncommon. In the next
section, we will finally start visualizing the data.


## Visualizing the network

We will focus on three different attributes that we can use for this visualization:
Node size, node shape, and node color. While there are no particular rules, some
ideas you can follow are:

- **Node size** Use it to describe a continuous measurement. This feature is often
used to highlight important nodes, e.g., using one of the many available degree measurements.

- **Node shape** Shapes can be used to represent categorical values. A good figure
will not feature too many of them; less than four would make sense.

- **Node color** Like shapes, colors can be used to represent categorical values, so the
same idea applies. Furthermore, it is not crazy to use both shape and color to 
represent the same feature.

Notice that we have not talked about layout algorithms. The R packages to build
graphs usually have internal rules to decide what algorithm to use. We will discuss that
later on. Let's start by size.

### Vertex size

Finding the right scale can be somewhat difficult. We 
will draw the graph four times to see what size would be the best:


```r
# Sized by indegree
net_sim %v% "indeg" <- degree(net_sim, gmode = "digraph")

# Preparing the graphical device to hold four nets.
# This line sets a 2 x 2 viz device and stores the 
# original value. We will use the `op` object to reset
# the configugarion
op <- par(mfrow = c(2, 2), mai = c(.1, .1, .1, .1))
glayout <- gplot(net_sim, vertex.cex = (net_sim %v% "indeg") * 2)
gplot(net_sim, vertex.cex = net_sim %v% "indeg", coord = glayout)
gplot(net_sim, vertex.cex = (net_sim %v% "indeg")/2, coord = glayout)
gplot(net_sim, vertex.cex = (net_sim %v% "indeg")/10, coord = glayout)
```

![](06-network-simulation-and-viz_files/figure-epub3/06-size-1.png)<!-- -->

```r
par(op)
```

If we were using igraph, setting the size can be easier thanks to the netdiffuseR
R package. Let's start by converting our network to an igraph object with the
R package `intergraph`


```r
library(intergraph)
library(igraph)

# Converting the network object to an igraph object
net_sim_i <- asIgraph(net_sim)

# Plotting with igraph
plot(
  net_sim_i,
  vertex.size = netdiffuseR::rescale_vertex_igraph(
    vertex.size = V(net_sim_i)$indeg,
    minmax.relative.size = c(.01, .1)
  ), 
  layout       = glayout,
  vertex.label = NA
)
```

![](06-network-simulation-and-viz_files/figure-epub3/06-size-netdiffuseR-1.png)<!-- -->

We could also have tried netplot, which should make things easier and make a better use of the space:


```r
library(netplot)
nplot(
  net_sim, layout = glayout,
  vertex.color = "tomato",
  vertex.frame.color = "darkred"
  )
```

![](06-network-simulation-and-viz_files/figure-epub3/06-netplot1-1.png)<!-- -->

With a good idea for size, we can now start looking into vertex color.

### Vertex color

For the color, we will use vertex age. Although age is, by definition, continuous,
we only have three values for age. Because of this, we can treat age as categorical.


```r
vcolors <- c("10" = "gray", "14" = "tomato", "17" = "steelblue")
net_sim %v% "color" <- vcolors[as.character(net_sim %v% "age")]
nplot_base(
  net_ig,
  layout = glayout,
  vertex.color = net_sim %v% "color",
  )

legend(
  "bottomright",
  legend = names(vcolors),
  fill   = vcolors, 
  bty    = "n",
  title  = "Age"
  )
```

![](06-network-simulation-and-viz_files/figure-epub3/06-network-color-1.png)<!-- -->

### Vertex shape

For the color, we will use vertex age. Although age is, by definition, continuous,
we only have three values for age. Because of this, we can treat age as categorical.


```r
vshape <- c("white" = 15, "non-white" = 3)
net_sim %v% "shape" <- vshape[as.character(net_sim %v% "race")]
nplot_base(
  net_ig,
  layout = glayout,
  vertex.color = net_sim %v% "color",
  vertex.nsides = net_sim %v% "shape"
  )
  
legend(
  "bottomright",
  legend = names(vcolors),
  fill   = vcolors, 
  bty    = "n",
  title  = "Age"
  )

legend(
  "bottomleft",
  legend = names(vshape),
  pch    = c(1, 2), 
  bty    = "n",
  title  = "Race"
  )
```

![](06-network-simulation-and-viz_files/figure-epub3/06-network-shape-1.png)<!-- -->
