FROM rocker/tidyverse:4.4.0

RUN install2.r -n 4 \
	igraph \
	netplot \
	netdiffuseR \
	Matrix \
	sna \
	network \
	ergm \
	intergraph \
	texreg \
	readstata13

# Installing the R package spatialreg
RUN apt update && apt install --no-install-recommends \
	-y libudunits2-dev libproj-dev libgdal-dev
RUN install2.r spatialreg



CMD ["bash"]
