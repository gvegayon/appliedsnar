--- 
title: "Applied SNA with R"
author: "George G. Vega Yon"
date: "2018-03-09"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: gvegayon/appliedsnar
description: "An improvised book on applied Social Network Analysis with R, this is(will be) a compilation of the materials presented in this series of workshop hosted by USC's Center for Applied Network Analysis (CANA)"
---

\renewcommand{\Pr}[1]{\mbox{Pr}\left(#1\right)}
\renewcommand{\exp}[1]{\mbox{exp}\left\{#1\right\}}

# About this book 

This book will be build as part of a workshop on Applied Social Network Analysis with R. Its contents will be populated as the sessions take place, and for now there is particular program that we will follow, instead, we have the following workflow:

1.  Participants will share their data and what they need to do with it.

2.  Based on their data, I'll be preparing the sessions trying to show attendees how would I approach the problem, and at the same time, teach by example about the R language.

3.  Materials will be published on this website and, hopefully, video recordings of the sessions.

At least in the first version, the book will be organized by session, this is, one chapter per session.

All the book materials can be downloaded from https://github.com/gvegayon/appliedsnar

In general, we will besides of R itself, we will be using R studio and the following R packages: dplyr for data management, stringr for data cleaning, and of course igraph, netdiffuseR (a bit of a bias here), and statnet for our neat network analysis.^[Some of you may be wondering "what about ggplot2 and friends? What about [`tidyverse`](https://www.tidyverse.org/)", well, my short answer is I jumped into R before all of that was that popular. When I started plots were all about [`lattice`](https://CRAN.R-project.org/package=lattice), and after a couple of years on that, about base R graphics. What I'm saying is that so far I have not find a compelling reason to leave my "old-practices" and embrace all the `tidyverse` movement (religion?).]

