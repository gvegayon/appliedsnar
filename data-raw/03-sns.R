library(readstata13)
library(dplyr)
library(tidyr)

# Eversmk
# View(dat[, c("t1_j1", "t2_j1", "t3_j1", "t4_nj1")])
dat <- read.dta13("SNS datamerged081315edited.dta")

dat <- dat %>% rename(school = School)

# Eversmoke --------------------------------------------------------------------

# Renaming variables
dat <- dat %>%
  rename(
    eversmk1 = t1_j1,
    eversmk2 = t2_j1,
    eversmk3 = t3_j1,
    eversmk4 = t4_nj1
    )

# Criteria based-imputation
dat <- dat %>%
  mutate(
    eversmk1 = coalesce(eversmk1, 3L),
    eversmk2 = coalesce(eversmk2, 3L),
    eversmk3 = coalesce(eversmk3, 3L),
    eversmk4 = coalesce(eversmk4, 3L)
  ) %>%
  mutate(
    eversmk2 = if_else(eversmk2 == 3L, eversmk1, if_else(eversmk1 == 1L, 1L, 2L)),
    eversmk3 = if_else(eversmk3 == 3L, eversmk2, if_else(eversmk2 == 1L, 1L, 2L)),
    eversmk4 = if_else(eversmk4 == 3L, eversmk3, if_else(eversmk3 == 1L, 1L, 2L))
  ) %>%
  # Carrying back
  mutate(
    eversmk1 = if_else((eversmk1 == 3L) & (eversmk2 == 2L), 2L, eversmk1),
    eversmk2 = if_else((eversmk2 == 3L) & (eversmk3 == 2L), 2L, eversmk2),
    eversmk3 = if_else((eversmk3 == 3L) & (eversmk4 == 2L), 2L, eversmk3)
  ) %>%
  # Coercing into logicals
  mutate(
    eversmk1 = as.integer(na_if(eversmk1, 3L) == 1L),
    eversmk2 = as.integer(na_if(eversmk2, 3L) == 1L),
    eversmk3 = as.integer(na_if(eversmk3, 3L) == 1L), 
    eversmk4 = as.integer(na_if(eversmk4, 3L) == 1L)
  )


# select(dat, eversmk1, eversmk2, eversmk3, eversmk4) %>% View()

# Eversdrk --------------------------------------------------------------------

# Renaming variables
dat <- dat %>%
  rename(
    everdrk1 = t1_j10,
    everdrk2 = t2_j10,
    everdrk3 = t3_j10,
    everdrk4 = t4_nj10
  )

# Criteria based-imputation
dat <- dat %>%
  mutate(
    everdrk1 = coalesce(everdrk1, 9L),
    everdrk2 = coalesce(everdrk2, 9L),
    everdrk3 = coalesce(everdrk3, 9L),
    everdrk4 = coalesce(everdrk4, 9L)
  ) %>%
  mutate(
    everdrk2 = if_else(everdrk2 == 9L, everdrk1, if_else(everdrk1 != 9L, everdrk1, 1L)),
    everdrk3 = if_else(everdrk3 == 9L, everdrk2, if_else(everdrk2 != 9L, everdrk2, 1L)),
    everdrk4 = if_else(everdrk4 == 9L, everdrk3, if_else(everdrk3 != 9L, everdrk3, 1L))
  ) %>%
  # Carrying back
  mutate(
    everdrk1 = if_else((everdrk1 == 9L) & (everdrk2 == 1L), 1L, everdrk1),
    everdrk2 = if_else((everdrk2 == 9L) & (everdrk3 == 1L), 1L, everdrk2),
    everdrk3 = if_else((everdrk3 == 9L) & (everdrk4 == 1L), 1L, everdrk3)
  ) %>%
  # Coercing into logicals
  mutate(
    everdrk1 = as.integer(na_if(everdrk1, 3L) > 1L),
    everdrk2 = as.integer(na_if(everdrk2, 3L) > 1L),
    everdrk3 = as.integer(na_if(everdrk3, 3L) > 1L), 
    everdrk4 = as.integer(na_if(everdrk4, 3L) > 1L)
  )


# Creating hispanic variable: Why not including cenral american, south american?
# 5 Chicano or Chicana
# 8 Hispanic
# 13 Latino or Latina
# 14 Mexican
# 15 Mexican-American
latino_codes <- c(5, 8, 13, 14, 15)

call_yourself <- list(
  paste0("t1_i4_", latino_codes),
  paste0("t2_i4_", latino_codes),
  paste0("t3_i4_", latino_codes),
  paste0("t4_ni5_", latino_codes)
)



for (i in 1:4) {
  
  # Creating a variable "hispanic0i" (goes from i = 1 to 4)
  dat[[sprintf("hispanic%02i", i)]] <- 
    
    # Applying a function by row for columns defined in "call_yourself"
    apply(dat[,call_yourself[[i]]], 1, function(x) {
      
      # If all of them are NA, then NA
      if (all(is.na(x))) return(NA)
      
      # Otherwise, if at least 1 has a '1' (yes), then 1
      # otherwise is simply a 0 (no hispanic in time i)
      if (1 %in% x) {
        return(1L)
      } else return(0L)
    })
}

# If at least once they called themselves hispanic...
dat[["hispanic"]] <- apply(dat[,paste("hispanic0",1:4, sep="")], 1, function(x) {
  if (all(is.na(x))) NA
  else if (1L %in% x) 1L
  else 0
})

# Own home ---------------------------------------------------------------------

home <- c("t1.h5", "t2.h5", "t3.h5", "t4.h5")

dat <- dat %>%
  rename(
    home1 = t1_h5,
    home2 = t2_h5,
    home3 = t3_h5,
    home4 = t4_h5
  ) %>%
  mutate(
    home2 = na_if(home2, 4L)
  )


# Gender -----------------------------------------------------------------------
female <- c("t1.i2", "t2.i2", "t3.i2", "t4.ni3")

dat <- dat %>% 
  rename(
    female1 = t1_i2,
    female2 = t2_i2,
    female3 = t3_i2,
    female4 = t4_ni3
  ) %>%
  mutate(
    female1 = as.integer(female1 == 1L),
    female2 = as.integer(female2 == 1L),
    female3 = as.integer(female3 == 1L),
    female4 = as.integer(female4 == 1L)
  )


# Grades -----------------------------------------------------------------------

#Academic Gradesc
grades0 <- c("t1_i11", "t2_i11", "t3_i11", "t4_ni11")

# We want to code them as follows:
# A = 5
# B = 4
# C = 3
# D = 2
# F = 1
# If the responder said "As and Bs", then 1/2 each
grades_codes <- structure(5:1, names=LETTERS[1:5])

# calc_scale: This function will convert the
# grades into numbers following the -grades_code-
# 
# The grades question codes goes as:
# 1. Mostly A's
# 2. A's and B's
# 3. ...
# 8. D's and F's
# 9. Mostly F's
# 10. Wasn't in school last year
calc_grade <- function(x, grade_codes=grades_codes) {
  ifelse(is.na(x), NA,  # NA is NA
         ifelse(x == 10, NA, # 10 is NA
                
                rowMeans(cbind(   
                  grades_codes[(x + 1) %/% 2], # Upper grade
                  grades_codes[(x + 2) %/% 2]  # Lower grade
                ))
         ))
}

# Coded grades variable
for (i in 1L:length(grades0)) {
  dat[[sprintf("grades%i", i)]] <- calc_grade(dat[[grades0[i]]])
}

dat <- dat %>%
  select(
    photoid,
    school,
    hispanic,
    female1, female2, female3, female4,
    grades1, grades2, grades3, grades4,
    eversmk1, eversmk2, eversmk3, eversmk4,
    everdrk1, everdrk2, everdrk3, everdrk4,
    home1, home2, home3, home4,
    matches("^sch_friend1.+"),
    matches("^sch_friend2.+"),
    matches("^sch_friend3.+"),
    matches("^sch_friend4.+")
  ) %>% as_tibble

readr::write_csv(dat, path = "data-raw/03-sns.csv")
foreign::write.dta(dat, file =  "03-sns.dta")
