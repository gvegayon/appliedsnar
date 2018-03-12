rm(list = ls())

pkgs <- c("igraph", "statnet", "sns", "network", "dplyr", "stringr",
          "tidyr", "tidyselect", "ergm", "netdiffuseR", "lattice", "RSiena",
          "magrittr")
pkgs <- paste0("package:", pkgs)

for (pkg in pkgs)
  tryCatch(
    detach(pkg, unload = TRUE, character.only = TRUE, force = TRUE),
    error = function(e) e)