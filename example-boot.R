library(netdiffuseR)
library(Matrix) # If you want to use sparse matrices

data("sampson", package="ergm")

samplike

# Random net
x <- as.matrix(samplike)

# Network boot1
ans <- bootnet(x, function(w, idx) {
  nedges(w)/(
    nvertices(w) * (1 - nvertices(w))
  )
  }, R=100)

hist(ans)

# Extracting the group (to include in permutation)
library(network)
grp <- samplike %v% "group"

# Multiple statistics
# Density, graph reciprocity, mean in/outdegree, triadic closure
mystats <- function(i, idx) {

  # To make it easier
  i <- as.matrix(i)

  # Density df n1(n1-1) + n2(n2-2) - 2
  n    <- nnodes(i)
  dens <- sum(i)/(n * (n-1))

  # Outdegree
  outd <- mean(rowSums(i)) # The df n1 + n2 - 2

  # Reciprocity
  rec <- igraph::reciprocity(igraph::graph_from_adjacency_matrix(i))

  # Rebuild the network object
  net <- network(
    i,
    vertex.attr = list(
      group = grp[idx] # Notice the idx, this puts the attribute grp in the right order
      )
    )

  triads <- ergm::summary_formula(net ~ ttriad + nodematch("group"))

  c(Density = dens, "Avg Outdegree" = outd, Reciprocity = rec, "Balance" = triads)

}

ans2 <- bootnet(x, mystats, R=100)

# Actual samples
ans2$boot$t
ans2$var_t



