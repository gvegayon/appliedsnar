# input Stata file
library(statnet)
library(foreign)
#library(RSiena)

# This program reads a  node list data of who knew whom in PM 542 and
# calculates simple network data 
# Authors: Tom Valente


#setwd("c:/misc/tv/nets/") 
#dyad2  <- read.dta("know16_dyadic.dta")


setwd("c:/misc/tv/nets/") 
net_data <- read.dta("know14.dta")
head(net_data)
dyad3 <-reshape(net_data, direction="long",  varying = 2:8, sep="",
                idvar = "net_data$id", timevar="alter")
dyad2  <- dyad3[!is.na(dyad3$nom),]  

dyad1  <- as.data.frame(dyad2)
vars   <- c("id", "nom")
dyad   <- dyad1[vars]
#dyad1  <- dyad2[which(dyad1[,2] != 0), ]
dyad   <- dyad[which(dyad[,1] != dyad[,2]), ]  # Delete reflexive links
#id <- know12$id 
#id_max <- max(id)
#dummy_link <- c(id_max, id_max)            #So all nets are same size
#dyad <- rbind(dyad, dummy_link)
know_net   <- as.network(dyad, loops=FALSE)

# Attach attribute to vertices
know_net %v% "id"      <- net_data$id
know_net %v% "sex"     <- net_data$sex
know_net %v% "dept"    <- net_data$dept

# Graph the data
gplot(know_net, mode="kamadakawai", 
      label=network.vertex.names(know_net),label.pos=5,
      label.cex=.6, gmode="digraph", 
      vertex.col=7, vertex.sides=32)

# Calculate individual measures (centrality)
in_deg <- (degree(know_net, cmode="indegree"))
out_deg <- (degree(know_net, cmode="outdegree"))
close   <- closeness(know_net, cmode="suminvdir")
between <- (betweenness(know_net, ))
id      <- seq(1,NROW(out_deg), 1)
degree_scores <- cbind(id, out_deg, in_deg, close, between)
degree_scores <- round(degree_scores, digits=3)
write.table(degree_scores, file="know_inds_new.txt", append=TRUE, quote=FALSE, sep=" ", row.names=FALSE, col.names=FALSE)

library(igraph)
exnet_graph  <- graph.adjacency(as.sociomatrix(know_net))
exnet_graphs <- graph.adjacency(symmetrize(as.sociomatrix(know_net), rule="weak"))
eb   <- edge.betweenness(exnet_graph)
# eb_scores <- as.numeric(cbind((get.edgelist(exnet_graph)), eb))
oc <- optimal.community(exnet_graphs)
member <- oc$membership

# fg <- fastgreedy.community(exnet_graphs)  #Fast greedy works only with symmetric graphs
# group_memb <- fg$membership

know_net %v% "group"   <- member
#tkplot(exnet_graph)
detach(package:igraph)

clique.census(know_net)
component.dist(know_net)

#Postions
dept <- net_data$dept
blockmodel(know_net, dept)
block_mat <- blockmodel(know_net, dept)
semat <- (sedist(as.sociomatrix(know_net), method="euclidean"))

# Calculate network level metrics
net_size     <-(network.size(know_net))
net_dense    <-network.density(know_net)
net_recip1d  <-grecip(know_net, measure=c("dyadic"))
net_recip1dnn  <-grecip(know_net, measure=c("dyadic.nonnull"))
net_central    <-(centralization(know_net, degree, cmode="indegree"))
net_components <-(components(know_net))
triad_num <- c(9, 12, 13, 16)
triad_den <- c(6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
net_triads      <-triad.census(know_net, mode = c("digraph"))
trans_pct2      <- ((sum(net_triads[triad_num])) / (sum(net_triads[triad_den])))
net_level      <- cbind(net_size, net_dense, net_recip1d, net_recip1dnn, net_central,
                     trans_pct2, net_components)
net_level      <- round(net_level, digits=3)
write.table(net_level, file="net_level_new.txt", append=TRUE, quote=FALSE, sep=" ", row.names=FALSE, col.names=FALSE)


# Plot with attributes
gplot(know_net, displaylabels=TRUE, displayisolates = TRUE, mode="kamadakawai", 
      label.pos=5, label.cex=.8, vertex.cex=2.5, vertex.col=7,
      label=network.vertex.names(know_net), 
      )
# To plot nodes with dept. colored use the following:
dept  <- net_data$dept
dept1 <- (dept + 1)      # add 1  becuase 1=black
gplot(know_net, displaylabels=TRUE, displayisolates = TRUE, mode="kamadakawai", 
      label.pos=5, label.cex=.8, vertex.cex=2.5, vertex.col=dept1,
      label=network.vertex.names(know_net))

member=(member+1)
# To plot nodes with community detection use the following:
gplot(know_net, displaylabels=TRUE, displayisolates = TRUE, mode="kamadakawai", 
      label.pos=5, label.cex=.8, vertex.cex=2.5, vertex.col=member, vertex.sides=dept1,
      label=network.vertex.names(know_net))

#ERGM Estimation 

fit <- ergm(know_net ~ edges + mutual + triangle + nodecov("dept") + nodematch("dept"), 
           constraints=~bd(maxout=7), seed=200)
test <- simulate(fit)
test %v% "dept" <- net_data$dept
plot(test, vertex.col="dept")
summary(fit)
plot(simulate(fit))

know_params <- fit$coef
know_params <- round(know_params, digits=3)
write.table(t(know_params), file = "c:/misc/tv/nets/params_know.txt", append = T, sep = " ", 
            row.names = F, col.names = F)


#############################################################
##                          The End                        ##
#############################################################
