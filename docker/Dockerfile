FROM rocker/r-base:latest

RUN apt update && \
	apt install -y --no-install-recommends r-cran-tinytex

RUN Rscript --vanilla -e 'tinytex::install_tinytex()'

RUN echo 'PATH=$PATH:/root/bin' >> ~/.profile && source ~/.profile

CMD ["/bin/bash"]
