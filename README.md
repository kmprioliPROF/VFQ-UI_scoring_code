---
title: "README"
author: "https://github.com/kmprioliPROF/"
date: "September 13, 2019"
output: html_document
---

## Purpose

This code generates vision-derived health utility index scores from the 25-item National Eye Institute Visual Function Questionnaire (NEI-VFQ-25), given a .csv file containing the raw NEI-VFQ-25 data, date of birth, and date of survey administration.  Output is sent to .csv.

## Setup

To use this code, modify the included `rawVFQdata.csv` file to reflect the raw NEI-VFQ-25 data, including date of birth (column name `dob`) and date of data collection (column name `neivfq_date`).

Note that only nine columns are needed to run this code:

| Column Name   | Description                                                                                     |
|---------------|-------------------------------------------------------------------------------------------------|
| `record_id`   | Unique identifier; not needed for scoring but recommended to keep for subject tracking purposes |
| `neivfq_date` | Date of data collection                                                                         |
| `dob`         | Date of birth                                                                                   |
| `vfq25_q6`    | NEI-VFQ-25 subitem 6                                                                            |
| `vfq25_q11`   | NEI-VFQ-25 subitem 11                                                                           |
| `vfq25_q14`   | NEI-VFQ-25 subitem 14                                                                           |
| `vfq25_q18`   | NEI-VFQ-25 subitem 18                                                                           |
| `vfq25_q20`   | NEI-VFQ-25 subitem 20                                                                           |
| `vfq25_q25`   | NEI-VFQ-25 subitem 25                                                                           |

To streamline scoring, you may omit all other columns if desired.

## Running the Code

Running the code is straightforward.  The packages needed must be installed on your system to run this code.  If you don't already have these packages, you can install them via:

`install.packages(c("here", "tidyverse", "lubridate"))`

These packages are used for the following:

* `here`:  for nonstatic filepaths
* `tidyverse`:  for data import/export and wrangling
* `lubridate`:  for date manipulation

The code selects the nine columns of interest, assesses whether each row is scorable (i.e., whether the data is complete), retains those that are scorable, recodes the VFQ subitems, computes theta scores, and calculates utility scores.  The mechanics of recoding and the computations are derived from the Rentz et al supplement (see **[References](#refs)** below)

## Output

The program outputs the retained columns, recoded columns, calculated columns (including age and theta scores), and utilities (`VFQ_UI`) to .csv.  An example output file is included as `VFQ-UI_scored.csv`.  The underlying dataframe remains in your global environment if you want to use it in subsequent calculations.

## Disclaimer

For HIPAA and human subjects protection reasons, the data provided in the example `rawVFQdata.csv` file is dummy data and does **not** represent real subject responses.

## <a id = "refs">References</a>

The scoring code presented herein is derived from the Rentz et al supplemental online content, Appendix C.

* Main paper:  Rentz AM, Kowalski JW, Walt JG, et al. Development of a Preference-Based Index From the National Eye Institute Visual Function Questionnaire–25. JAMA Ophthalmol. Published online January 16, 2014. doi:10.1001/jamaophthalmol.2013.7639.
* Direct link to supplemental online content:  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4357476/bin/NIHMS666969-supplement-Appendicies.docx
