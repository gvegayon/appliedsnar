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
	readstata13 \
	gridExtra \
	rgexf \
	microbenchmark

# Installing the R package spatialreg
RUN apt update && apt install --no-install-recommends \
	-y libudunits2-dev libproj-dev libgdal-dev
RUN install2.r spatialreg

# Missing libraries
RUN apt install --no-install-recommends -y libglpk-dev

# Installing quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.554/quarto-1.4.554-linux-amd64.deb && \
	apt install ./quarto-1.4.554-linux-amd64.deb && \
	quarto install tool tinytex --log-level warning

CMD ["bash"]
