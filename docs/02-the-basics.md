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

## Prerequisits

To install R just follow the instructions available at http://cran.r-project.org

RStudio is the most popular Integrated Development Environment (IDE) for R that is developed by the company of the same name. While having RStudio is not a requirement for using netdiffuseR, it is highly recommended.

To get RStudio just visit https://www.rstudio.com/products/rstudio/download/.

## A ~~gentle~~ Quick n' Dirty Introduction to R

Some common tasks in R

0.  Getting help (and reading the manual) is *THE MOST IMPORTANT* thing you should know about. For example, if you want to read the manual (help file) of the `read.csv` function, you can type either of these:
    ```r
    ?read.csv
    ?"read.csv"
    help(read.csv)
    help("read.csv")
    ```
    If you are not fully aware of what is the name of the function, you can always use the *fuzzy search*
    ```r
    help.search("linear regression")
    ??"linear regression"
    ```
    
    

1.  In R you can create new objects by either using the assign operator (`<-`) or the equal sign `=`, for example, the following 2 are equivalent:
    ```r
    a <- 1
    a =  1
    ```
    Historically the assign operator is the most common used.

2.  R has several type of objects, the most basic structures in R are `vectors`, `matrix`, `list`, `data.frame`. Here is an example creating several of these (each line is enclosed with parenthesis so that R prints the resulting element):
    
    ```r
    (a_vector     <- 1:9)
    ```
    
    ```
    ## [1] 1 2 3 4 5 6 7 8 9
    ```
    
    ```r
    (another_vect <- c(1, 2, 3, 4, 5, 6, 7, 8, 9))
    ```
    
    ```
    ## [1] 1 2 3 4 5 6 7 8 9
    ```
    
    ```r
    (a_string_vec <- c("I", "like", "netdiffuseR"))
    ```
    
    ```
    ## [1] "I"           "like"        "netdiffuseR"
    ```
    
    ```r
    (a_matrix     <- matrix(a_vector, ncol = 3))
    ```
    
    ```
    ##      [,1] [,2] [,3]
    ## [1,]    1    4    7
    ## [2,]    2    5    8
    ## [3,]    3    6    9
    ```
    
    ```r
    (a_string_mat <- matrix(letters[1:9], ncol=3)) # Matrices can be of strings too
    ```
    
    ```
    ##      [,1] [,2] [,3]
    ## [1,] "a"  "d"  "g" 
    ## [2,] "b"  "e"  "h" 
    ## [3,] "c"  "f"  "i"
    ```
    
    ```r
    (another_mat  <- cbind(1:4, 11:14)) # The `cbind` operator does "column bind"
    ```
    
    ```
    ##      [,1] [,2]
    ## [1,]    1   11
    ## [2,]    2   12
    ## [3,]    3   13
    ## [4,]    4   14
    ```
    
    ```r
    (another_mat2 <- rbind(1:4, 11:14)) # The `rbind` operator does "row bind"
    ```
    
    ```
    ##      [,1] [,2] [,3] [,4]
    ## [1,]    1    2    3    4
    ## [2,]   11   12   13   14
    ```
    
    ```r
    (a_string_mat <- matrix(letters[1:9], ncol = 3))
    ```
    
    ```
    ##      [,1] [,2] [,3]
    ## [1,] "a"  "d"  "g" 
    ## [2,] "b"  "e"  "h" 
    ## [3,] "c"  "f"  "i"
    ```
    
    ```r
    (a_list       <- list(a_vector, a_matrix))
    ```
    
    ```
    ## [[1]]
    ## [1] 1 2 3 4 5 6 7 8 9
    ## 
    ## [[2]]
    ##      [,1] [,2] [,3]
    ## [1,]    1    4    7
    ## [2,]    2    5    8
    ## [3,]    3    6    9
    ```
    
    ```r
    (another_list <- list(my_vec = a_vector, my_mat = a_matrix)) # same but with names!
    ```
    
    ```
    ## $my_vec
    ## [1] 1 2 3 4 5 6 7 8 9
    ## 
    ## $my_mat
    ##      [,1] [,2] [,3]
    ## [1,]    1    4    7
    ## [2,]    2    5    8
    ## [3,]    3    6    9
    ```
    
    ```r
    # Data frames can have multiple types of elements, it is a collection of lists
    (a_data_frame <- data.frame(x = 1:10, y = letters[1:10]))
    ```
    
    ```
    ##     x y
    ## 1   1 a
    ## 2   2 b
    ## 3   3 c
    ## 4   4 d
    ## 5   5 e
    ## 6   6 f
    ## 7   7 g
    ## 8   8 h
    ## 9   9 i
    ## 10 10 j
    ```
    
3.  Depending on the type of object, we can access to its components using indexing:
    
    ```r
    a_vector[1:3] # First 3 elements
    ```
    
    ```
    ## [1] 1 2 3
    ```
    
    ```r
    a_string_vec[3] # Third element
    ```
    
    ```
    ## [1] "netdiffuseR"
    ```
    
    ```r
    a_matrix[1:2, 1:2] # A sub matrix
    ```
    
    ```
    ##      [,1] [,2]
    ## [1,]    1    4
    ## [2,]    2    5
    ```
    
    ```r
    a_matrix[,3] # Third column
    ```
    
    ```
    ## [1] 7 8 9
    ```
    
    ```r
    a_matrix[3,] # Third row
    ```
    
    ```
    ## [1] 3 6 9
    ```
    
    ```r
    a_string_mat[1:6] # First 6 elements of the matrix. R stores matrices by column.
    ```
    
    ```
    ## [1] "a" "b" "c" "d" "e" "f"
    ```
    
    ```r
    # These three are equivalent
    another_list[[1]]
    ```
    
    ```
    ## [1] 1 2 3 4 5 6 7 8 9
    ```
    
    ```r
    another_list$my_vec
    ```
    
    ```
    ## [1] 1 2 3 4 5 6 7 8 9
    ```
    
    ```r
    another_list[["my_vec"]]
    ```
    
    ```
    ## [1] 1 2 3 4 5 6 7 8 9
    ```
    
    ```r
    # Data frames are just like lists
    a_data_frame[[1]]
    ```
    
    ```
    ##  [1]  1  2  3  4  5  6  7  8  9 10
    ```
    
    ```r
    a_data_frame[,1]
    ```
    
    ```
    ##  [1]  1  2  3  4  5  6  7  8  9 10
    ```
    
    ```r
    a_data_frame[["x"]]
    ```
    
    ```
    ##  [1]  1  2  3  4  5  6  7  8  9 10
    ```
    
    ```r
    a_data_frame$x
    ```
    
    ```
    ##  [1]  1  2  3  4  5  6  7  8  9 10
    ```
    
4.  Control-flow statements
    
    ```r
    # The oldfashion forloop
    for (i in 1:10) {
      print(paste("I'm step", i, "/", 10))
    }
    ```
    
    ```
    ## [1] "I'm step 1 / 10"
    ## [1] "I'm step 2 / 10"
    ## [1] "I'm step 3 / 10"
    ## [1] "I'm step 4 / 10"
    ## [1] "I'm step 5 / 10"
    ## [1] "I'm step 6 / 10"
    ## [1] "I'm step 7 / 10"
    ## [1] "I'm step 8 / 10"
    ## [1] "I'm step 9 / 10"
    ## [1] "I'm step 10 / 10"
    ```
    
    ```r
    # A nice ifelse
    
    for (i in 1:10) {
      
      if (i %% 2) # Modulus operand
        print(paste("I'm step", i, "/", 10, "(and I'm odd)"))
      else
        print(paste("I'm step", i, "/", 10, "(and I'm even)"))
      
    }
    ```
    
    ```
    ## [1] "I'm step 1 / 10 (and I'm odd)"
    ## [1] "I'm step 2 / 10 (and I'm even)"
    ## [1] "I'm step 3 / 10 (and I'm odd)"
    ## [1] "I'm step 4 / 10 (and I'm even)"
    ## [1] "I'm step 5 / 10 (and I'm odd)"
    ## [1] "I'm step 6 / 10 (and I'm even)"
    ## [1] "I'm step 7 / 10 (and I'm odd)"
    ## [1] "I'm step 8 / 10 (and I'm even)"
    ## [1] "I'm step 9 / 10 (and I'm odd)"
    ## [1] "I'm step 10 / 10 (and I'm even)"
    ```
    
    ```r
    # A while
    i <- 10
    while (i > 0) {
      print(paste("I'm step", i, "/", 10))
      i <- i - 1
    }
    ```
    
    ```
    ## [1] "I'm step 10 / 10"
    ## [1] "I'm step 9 / 10"
    ## [1] "I'm step 8 / 10"
    ## [1] "I'm step 7 / 10"
    ## [1] "I'm step 6 / 10"
    ## [1] "I'm step 5 / 10"
    ## [1] "I'm step 4 / 10"
    ## [1] "I'm step 3 / 10"
    ## [1] "I'm step 2 / 10"
    ## [1] "I'm step 1 / 10"
    ```

5.  R has a very nice set of pseudo random number generation functions. In general, distribution functions have the following name structure:
    a.  Random Number Generation: `r[name-of-the-distribution]`, e.g. `rnorm` for normal, `runif` for uniform.
    b.  Density function: `d[name-of-the-distribution]`, e.g. `dnorm` for normal, `dunif` for uniform.
    c.  Cumulative Distribution Function (CDF): `p[name-of-the-distribution]`, e.g. `pnorm` for normal, `punif` for uniform.
    d.  Inverse (quantile) function: `q[name-of-the-distribution]`, e.g. `qnorm` for the normal, `qunif` for the uniform.
    
    Here are some examples:
     
    
    ```r
    # To ensure reproducibility
    set.seed(1231)
    
    # 100,000 Unif(0,1) numbers
    x <- runif(1e5)
    hist(x)
    ```
    
    ![](02-the-basics_files/figure-epub3/random-numbers-1.png)<!-- -->
    
    ```r
    # 100,000 N(0,1) numbers
    x <- rnorm(1e5)
    hist(x)
    ```
    
    ![](02-the-basics_files/figure-epub3/random-numbers-2.png)<!-- -->
    
    ```r
    # 100,000 N(10,25) numbers
    x <- rnorm(1e5, mean = 10, sd = 5)
    hist(x)
    ```
    
    ![](02-the-basics_files/figure-epub3/random-numbers-3.png)<!-- -->
    
    ```r
    # 100,000 Poisson(5) numbers
    x <- rpois(1e5, lambda = 5)
    hist(x)
    ```
    
    ![](02-the-basics_files/figure-epub3/random-numbers-4.png)<!-- -->
    
    ```r
    # 100,000 rexp(5) numbers
    x <- rexp(1e5, 5)
    hist(x)
    ```
    
    ![](02-the-basics_files/figure-epub3/random-numbers-5.png)<!-- -->
    
    More distributions available at `??Distributions`.

For a nice intro to R, take a look at ["The Art of R Programming" by Norman Matloff](https://nostarch.com/artofr.htm). For more advanced users, take a look at ["Advanced R" by Hadley Wickham](http://adv-r.had.co.nz/).
    


For this book, we need the following

@R

1.  Install R  from CRAN: https://www.r-project.org/

2.  (optional) Install Rstudio: https://rstudio.org

While I find RStudio extremely useful, it is not necessary to use it with R.


