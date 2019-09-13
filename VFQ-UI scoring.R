# https://github.com/kmprioliPROF
# Code to score VFQ-UI from NEI-VFQ-25
# Fri Sep 13 06:45:02 2019 ------------------------------


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

library(here)         # For nonstatic file paths
library(tidyverse)    # For importing and tidying data
library(lubridate)    # For date manipulation


#### Import dataset ----

VFQraw <- read_csv(here::here("rawVFQdata.csv")) # Modify path here if desired


#### Subset columns, calculate age, and select scorable records ----

VFQdata <- VFQraw %>% 
  select(record_id, neivfq_date, dob, vfq25_q6, vfq25_q11, vfq25_q14, vfq25_q18, vfq25_q20, vfq25_q25) %>% 
  mutate(neivfq_date = mdy(neivfq_date),
         dob = mdy(dob),
         age = round(as.numeric((neivfq_date - dob) / 365.25), 2),
         VFQ_scorable = age + as.numeric(vfq25_q6) + as.numeric(vfq25_q11) + as.numeric(vfq25_q14) + 
           as.numeric(vfq25_q18) + as.numeric(vfq25_q20) + as.numeric(vfq25_q25))
VFQdata$VFQ_scorable <- with(VFQdata, ifelse(!is.na(VFQ_scorable), 1, 0))
VFQdata <- filter(VFQdata, VFQ_scorable == 1)


#### Scoring Step 1:  Recoding the VFQ subitems that are used to calculate VFQ-UI ----

VFQdata <- VFQdata %>% 
  mutate(
    VFQ6_recode = case_when(
      vfq25_q6 == 6 ~ 5,
      TRUE ~ vfq25_q6),
    VFQ11_recode = case_when(
      vfq25_q11 == 6 ~ 5,
      TRUE ~ vfq25_q11),
    VFQ14_recode = case_when(
      vfq25_q14 == 6 ~ 5,
      TRUE ~ vfq25_q14),
    VFQ18_recode = case_when(
      vfq25_q18 == 1 ~ 5,
      vfq25_q18 == 2 ~ 4,
      vfq25_q18 == 3 ~ 3,
      vfq25_q18 == 4 ~ 2,
      vfq25_q18 == 5 ~ 1),
    VFQ20_recode = case_when(
      vfq25_q20 == 1 ~ 5,
      vfq25_q20 == 2 ~ 4,
      vfq25_q20 == 3 ~ 3,
      vfq25_q20 == 4 ~ 2,
      vfq25_q20 == 5 ~ 1),
    VFQ25_recode = case_when(
      vfq25_q25 == 1 ~ 5,
      vfq25_q25 == 2 ~ 4,
      vfq25_q25 == 3 ~ 3,
      vfq25_q25 == 4 ~ 2,
      vfq25_q25 == 5 ~ 1))


#### Scoring Step 2:  Computing theta scores ----

VFQdata <- VFQdata %>% 
  mutate(
    theta6 = case_when(
      VFQ6_recode == 1 ~ -0.8296,
      VFQ6_recode == 2 ~ -0.3246,
      VFQ6_recode == 3 ~ -0.1918,
      VFQ6_recode == 4 ~ -0.1226,
      VFQ6_recode == 5 ~ 0),
    theta11 = case_when(
      VFQ11_recode == 1 ~ -0.5809,
      VFQ11_recode == 2 ~ -0.3172,
      VFQ11_recode == 3 ~ -0.2629,
      VFQ11_recode == 4 ~ -0.1275,
      VFQ11_recode == 5 ~ 0),
    theta14 = case_when(
      VFQ14_recode == 1 ~ -0.6473,
      VFQ14_recode == 2 ~ -0.3067,
      VFQ14_recode == 3 ~ -0.2671,
      VFQ14_recode == 4 ~ -0.1742,
      VFQ14_recode == 5 ~ 0),
    theta18 = case_when(
      VFQ18_recode == 1 ~ -0.5067,
      VFQ18_recode == 2 ~ -0.1751,
      VFQ18_recode == 3 ~ -0.1382,
      VFQ18_recode == 4 ~ -0.0996,
      VFQ18_recode == 5 ~ 0),
    theta20 = case_when(
      VFQ20_recode == 1 ~ -0.4555,
      VFQ20_recode == 2 ~ -0.2172,
      VFQ20_recode == 3 ~ -0.1932,
      VFQ20_recode == 4 ~ -0.1447,
      VFQ20_recode == 5 ~ 0),
    theta25 = case_when(
      VFQ25_recode == 1 ~ -0.3692,
      VFQ25_recode == 2 ~ -0.1485,
      VFQ25_recode == 3 ~ -0.1561,
      VFQ25_recode == 4 ~ -0.0924,
      VFQ25_recode == 5 ~ 0),
    thetascore = 2.6387 + theta6 + theta11 + theta14 + theta18 + theta20 + theta25)


#### Scoring Step 3:  Calculating utility scores ----

VFQdata <- VFQdata %>% 
  mutate(VFQ_UI = 0.87397 + (0.0009 * age) + (-0.10619 * thetascore) + (-0.11218 * thetascore^2) + (0.02779 * thetascore^3))


#### Writing results to .csv ----

write_csv(VFQdata, here::here("VFQ-UI_scored.csv")) # Modify path here if desired