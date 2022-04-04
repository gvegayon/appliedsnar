--- 
title: "Applied Network Science with R"
author: "George G. Vega Yon"
date: "2022-04-04"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: gvegayon/appliedsnar
description: "An improvised book on applied Social Network Analysis with R, this is(will be) a compilation of the materials presented in this series of workshop hosted by USC's Center for Applied Network Analysis (CANA)"
---

# About

\renewcommand{\Pr}[1]{\mbox{Pr}\left(#1\right)}
\renewcommand{\exp}[1]{\mbox{exp}\left\{#1\right\}}

### The Book

Statistical methods for networked systems are present in most disciplines.
Nonetheless, the language differences between disciplines, many methods
developed to study specific types of problems can be helpful outside of their original context.

This project began as a part of a workshop that took place at USC's
[Center for Applied Network Analysis](https://cana.usc.edu). Now, it is a personal
project that I use to gather and study statistical methods to analyze networks, emphasizing social and biological systems.
Moreover, the book will use statistical computing methods as a core component
when developing these topics.

In general, we will, besides R itself, we will be using R studio and the following
R packages: dplyr for data management, stringr for data cleaning, and of course
igraph, netdiffuseR (a bit of a bias here), and statnet for our neat network
analysis.^[Some of you may be wondering "what about ggplot2 and friends? What about [`tidyverse`](https://www.tidyverse.org/)", well, my short answer is I jumped into R before all of that was that popular. When I started, plots were all about [`lattice`](https://CRAN.R-project.org/package=lattice), and after a couple of years on that, about base R graphics. What I'm saying is that so far, I have not found a compelling reason to leave my "old practices" and embrace all the `tidyverse` movement (religion?).]

You can access the book's source code at https://github.com/gvegayon/appliedsnar.

### The author

I am a Research Assistant Professor at the University of Utah's Division of
Epidemiology, where I work on studying Complex Systems using Statistical Computing.
I have over ten years of experience developing scientific software focusing on
high-performance computing, data visualization, and social network analysis.
My training is in Public Policy (M.A. UAI, 2011), Economics (M.Sc. Caltech,
2015), and Biostatistics (Ph.D. USC, 2020).

I obtained my Ph.D. in Biostatistics under the supervision of
[Prof. Paul Marjoram](https://scholar.google.com/citations?user=Zj5ky5gAAAAJ&hl=en) and
[Prof. Kayla de la Haye](https://kayladelahaye.net/), with my dissertation titled "Essays on
Bioinformatics and Social Network Analysis: Statistical and Computational Methods
for Complex Systems."

If you'd like to learn more about me, please visit my website at https://ggvy.cl.

