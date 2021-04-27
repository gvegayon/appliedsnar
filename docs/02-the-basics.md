# R Basics

## What is R

A good reference book for both new and advanced user is ["The Art of R programming"](https://nostarch.com/artofr.htm) [@Matloff2011]^[[Here](http://heather.cs.ucdavis.edu/~matloff/145/PLN/RMaterials/NSPpart.pdf) a free pdf version distributed by the author.]

## How to install packages

Nowadays there are two ways of installing R packages (that I'm aware of), either using `install.packages`, which is a function shipped with R, or use the devtools R package to install a package from some remote repository other than CRAN, here is a couple of examples:

```r
# This will install the igraph package from CRAN
> install.packages("netdiffuseR")

# This will install the bleeding-edge version from the project's github repo!
> devtools::install_github("USCCANA/netdiffuseR")
```

The first one, using `install.packages`, installs the CRAN version of `netdiffuseR`, whereas the second installs whatever version is plublished on https://github.com/USCCANA/netdiffuseR, which is usually called the development version.

In some cases users may want/need to install packages from command line as some packages need extra configuration to be installed. But we won't need to look at it now.


