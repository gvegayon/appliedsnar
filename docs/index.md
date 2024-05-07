--- 
title: "Applied Network Science with R"
author: "George G. Vega Yon, Ph.D."
date: "2024-01-07"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: gvegayon/appliedsnar
description: "An improvised book on applied Network Science with R."
---

# Preface

\renewcommand{\Pr}[1]{\mbox{Pr}\left(#1\right)}
\renewcommand{\exp}[1]{\mbox{exp}\left\{#1\right\}}


Statistical methods for networked systems are present in most disciplines. Nonetheless, despite the language differences between disciplines, many methods developed to study specific types of problems can be helpful outside of their original context.

This project began as a part of a workshop that took place at USC's <a href="https://cana.usc.edu" target="_blank">**Center for Applied Network Analysis**</a>. Now, it is a personal project that I use to gather and study statistical methods to analyze networks, emphasizing social and biological systems. Moreover, the book will use statistical computing methods as a core component when developing these topics.

In general, we will, besides R itself, we will be using <a href="https://posit.co" target="_blank">RStudio</a>. For data management, we will use <a href="https://cran.r-project.org/package=dplyr" target="_blank">`dplyr`</a> and <a href="https://cran.r-project.org/package=data.table" target="_blank">`data.table`</a>. The network data management and visualization packages we will use are  <a href="https://cran.r-project.org/package=igraph" target="_blank">`igraph`</a>, <a href="https://cran.r-project.org/package=netdiffuseR" target="_blank">netdiffuseR</a>, the <a href="https://statnet.org" target="_blank">statnet</a> suite, and <a href="https://cran.r-project.org/package=netplot" target="_blank">`netplot`</a>. Some of you may be wondering "what about ggplot2 and friends? What about <a href="https://www.tidyverse.org/" target="_blank">`tidyverse`</a>", well, my short answer is I jumped into R before all of that was that popular. 

You can access the book's source code at <a href="https://github.com/gvegayon/appliedsnar" target="_blank">https://github.com/gvegayon/appliedsnar</a>.

# About the Author

I am a Research Assistant Professor at the <a href="https://medicine.utah.edu/internal-medicine/epidemiology" target="_blank">**University of Utah's Division of Epidemiology**</a>, where I work on studying Complex Systems using Statistical Computing. I was born and raised in Chile. I have over ten years of experience <a href="https://github.com/gvegayon" target="_blank">developing scientific software</a> focusing on high-performance computing, data visualization, and social network analysis. My training is in Public Policy (M.A. <a href="https://uai.cl" target="_blank">UAI</a>, 2011), Economics (M.Sc. <a href="https://caltech.edu" target="_blank">Caltech</a>, 2015), and Biostatistics (Ph.D. <a href="https://usc.edu" target="_blank">USC</a>, 2020).

I obtained my Ph.D. in Biostatistics under the supervision of <a href="https://scholar.google.com/citations?user=Zj5ky5gAAAAJ&hl=en" target="_blank">**Prof. Paul Marjoram**</a> and<a href="https://kayladelahaye.net/" target="_blank">**Prof. Kayla de la Haye**</a>, with my dissertation titled "*Essays on Bioinformatics and Social Network Analysis: Statistical and Computational Methods for Complex Systems.*"

If you'd like to learn more about me, please visit my website at <a href="https://ggvy.cl" target="_blank">https://ggvy.cl</a>.

