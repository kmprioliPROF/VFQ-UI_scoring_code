# https://github.com/kmprioliPROF
# Code to score VFQ-UI from NEI-VFQ-25
# Last updated Tue Aug 14 11:28:13 2018 ------------------------------


###########################################################################################################
#                                                                                                         #
#  REFERENCE FOR THIS SCORING CODE IS RENTZ ET AL, SUPPLEMENTARY ONLINE CONTENT, APPENDIX C (LINK BELOW)  #
#                                                                                                         #
#  Rentz AM, Kowalski JW, Walt JG, et al. Development of a Preference-Based Index From the National Eye   #
#  Institute Visual Function Questionnaire–25. JAMA Ophthalmol. Published online January 16, 2014.        #
#  doi:10.1001/jamaophthalmol.2013.7639.                                                                  #
#                                                                                                         #
#  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4357476/bin/NIHMS666969-supplement-Appendicies.docx       #
#                                                                                                         #
###########################################################################################################


#### Load libraries ----

library(here)
library(tidyverse)


#### Import dataset ----

VFQdata <- read_csv(here::here("rawVFQdata.csv")) # Modify path here if desired


#### Subset columns, calculate age, and select scorable records ----

VFQdata <- select(VFQdata, record_id, neivfq_date, dob, vfq25_q6, vfq25_q11, vfq25_q14, vfq25_q18, vfq25_q20, vfq25_q25)
VFQdata$neivfq_date <- lubridate::mdy(VFQdata$neivfq_date)
VFQdata$dob <- lubridate::mdy(VFQdata$dob)
VFQdata <- mutate(VFQdata, age = round(as.numeric((neivfq_date - dob) / 365.25), 2))
VFQdata <- mutate(VFQdata, VFQ_scorable = age + as.numeric(vfq25_q6) + as.numeric(vfq25_q11) + 
                    as.numeric(vfq25_q14) + as.numeric(vfq25_q18) + as.numeric(vfq25_q20) + 
                    as.numeric(vfq25_q25))
VFQdata$VFQ_scorable <- with(VFQdata, ifelse(!is.na(VFQ_scorable), 1, 0))
VFQdata <- filter(VFQdata, VFQ_scorable == 1)


#### Scoring Step 1:  Recode ----

VFQdata <- mutate(VFQdata, VFQ6_recode = vfq25_q6)
VFQdata$VFQ6_recode[VFQdata$VFQ6_recode == 6] <- 5

VFQdata <- mutate(VFQdata, VFQ11_recode = vfq25_q11)
VFQdata$VFQ11_recode[VFQdata$VFQ11_recode == 6] <- 5

VFQdata <- mutate(VFQdata, VFQ14_recode = vfq25_q14)
VFQdata$VFQ14_recode[VFQdata$VFQ14_recode == 6] <- 5

VFQdata <- mutate(VFQdata, VFQ18_recode = vfq25_q18)
VFQdata <- VFQdata %>% mutate(
  VFQ18_recode = 
    case_when(
      VFQ18_recode == 1 ~ 5,
      VFQ18_recode == 2 ~ 4,
      VFQ18_recode == 3 ~ 3,
      VFQ18_recode == 4 ~ 2,
      VFQ18_recode == 5 ~ 1
    )
)

VFQdata <- mutate(VFQdata, VFQ20_recode = vfq25_q20)
VFQdata <- VFQdata %>% mutate(
  VFQ20_recode = 
    case_when(
      VFQ20_recode == 1 ~ 5,
      VFQ20_recode == 2 ~ 4,
      VFQ20_recode == 3 ~ 3,
      VFQ20_recode == 4 ~ 2,
      VFQ20_recode == 5 ~ 1
    )
)

VFQdata <- mutate(VFQdata, VFQ25_recode = vfq25_q25)
VFQdata <- VFQdata %>% mutate(
  VFQ25_recode = 
    case_when(
      VFQ25_recode == 1 ~ 5,
      VFQ25_recode == 2 ~ 4,
      VFQ25_recode == 3 ~ 3,
      VFQ25_recode == 4 ~ 2,
      VFQ25_recode == 5 ~ 1
    )
)


#### Scoring Step 2:  Compute theta scores ----

VFQdata <- mutate(VFQdata, theta6 = VFQ6_recode)
VFQdata <- VFQdata %>% 
  mutate(
    theta6 =
      case_when(
         theta6 == 1 ~ -0.8296,
         theta6 == 2 ~ -0.3246,
         theta6 == 3 ~ -0.1918,
         theta6 == 4 ~ -0.1226,
         theta6 == 5 ~ 0
      )
  )

VFQdata <- mutate(VFQdata, theta11 = VFQ11_recode)
VFQdata <- VFQdata %>% 
  mutate(
    theta11 = 
      case_when(
        theta11 == 1 ~ -0.5809,
        theta11 == 2 ~ -0.3172,
        theta11 == 3 ~ -0.2629,
        theta11 == 4 ~ -0.1275,
        theta11 == 5 ~ 0
      )
  )

VFQdata <- mutate(VFQdata, theta14 = VFQ14_recode)
VFQdata <- VFQdata %>% 
  mutate(
    theta14 = 
      case_when(
        theta14 == 1 ~ -0.6473,
        theta14 == 2 ~ -0.3067,
        theta14 == 3 ~ -0.2671,
        theta14 == 4 ~ -0.1742,
        theta14 == 5 ~ 0
      )
  )

VFQdata <- mutate(VFQdata, theta18 = VFQ18_recode)
VFQdata <- VFQdata %>% 
  mutate(
    theta18 = 
      case_when(
        theta18 == 1 ~ -0.5067,
        theta18 == 2 ~ -0.1751,
        theta18 == 3 ~ -0.1382,
        theta18 == 4 ~ -0.0996,
        theta18 == 5 ~ 0
      )
  )

VFQdata <- mutate(VFQdata, theta20 = VFQ20_recode)
VFQdata <- VFQdata %>% 
  mutate(
    theta20 = 
      case_when(
        theta20 == 1 ~ -0.4555,
        theta20 == 2 ~ -0.2172,
        theta20 == 3 ~ -0.1932,
        theta20 == 4 ~ -0.1447,
        theta20 == 5 ~ 0
      )
  )

VFQdata <- mutate(VFQdata, theta25 = VFQ25_recode)
VFQdata <- VFQdata %>% 
  mutate(
    theta25 = 
      case_when(
        theta25 == 1 ~ -0.3692,
        theta25 == 2 ~ -0.1485,
        theta25 == 3 ~ -0.1561,
        theta25 == 4 ~ -0.0924,
        theta25 == 5 ~ 0
      )
  )

VFQdata %>%
  add_column(thetascore = 0)
VFQdata <- mutate(VFQdata, thetascore = 2.6387 + theta6 + theta11 + theta14 + theta18 + theta20 + theta25)


#### Scoring Step 3:  Calculate utility scores ----

VFQdata <- mutate(VFQdata, VFQ_UI = 0.87397 + (0.0009 * age) + (-0.10619 * thetascore) + 
                    (-0.11218 * thetascore^2) + (0.02779 * thetascore^3))


#### Write results to .csv ----

write.csv(VFQdata, here::here("VFQ-UI_scored.csv")) # Modify path here if desired