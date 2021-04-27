
\cleardoublepage 

# (APPENDIX) Appendix {-}

# Datasets

## SNS data {#sns-data}

### About the data

*   This data is part of the NIH Challenge grant \# RC 1RC1AA019239 "Social
Networks and Networking That Puts Adolescents at High Risk".

*   In general terms, the SNS's goal was(is) "Understand the network effects on
risk behaviors such as smoking initiation and substance use".

### Variables

The data has a _wide_ structure, which means that there is one row per individual,
and that dynamic attributes are represented as one column per time. 

*  `photoid` Photo id at the school level (can be repeated across schools).

*  `school` School id.

*  `hispanic` Indicator variable that equals 1 if the indivual ever reported
himself as hispanic.

*  `female1`, ..., `female4` Indicator variable that equals 1 if the individual
reported to be female at the particular wave.

*  `grades1`,..., `grades4` Academic grades by wave. Values from 1 to 5, with 5
been the best.

*  `eversmk1`, ..., `eversmk4` Indicator variable of ever smoking by wave. A one
indicated that the individual had smoked at the time of the survey.

*  `everdrk1`, ..., `everdrk4` Indicator variable of ever drinking by wave.
A one indicated that the individual had drink at the time of the survey.

*  `home1`, ..., `home4` Factor variable for home status by wave. A one
indicates home ownership, a 2 rent, and a 3 a "I don't know".


During the survey, participants were asked to name up to 19 of their school
friends:


* `sch_friend11`, ..., `sch_friend119` School friends nominations (19 in total)
for wave 1. The codes are mapped to the variable `photoid`.

* `sch_friend21`, ..., `sch_friend219` School friends nominations (19 in total)
for wave 2. The codes are mapped to the variable `photoid`.

* `sch_friend31`, ..., `sch_friend319` School friends nominations (19 in total)
for wave 3. The codes are mapped to the variable `photoid`.

* `sch_friend41`, ..., `sch_friend419` School friends nominations (19 in total)
for wave 4. The codes are mapped to the variable `photoid`.

