## Getting used letter+4digit NTEE Codes 
library(readr)
library(dplyr)
# import data from compensator raw-data 
# https://github.com/Nonprofit-Open-Data-Collective/compensator/tree/main/data-raw
# all_dat_cleaned <- read_csv(".../compensator/data-raw/all-dat-cleaned.csv")

known.specality.codes <- 
  all_dat_cleaned %>%
  select(NTEE.CC) %>%
  filter(nchar(NTEE.CC) == 5) %>% # 1 letter + 4 digits 
  arrange(NTEE.CC) %>%
  distinct() %>%
  as.data.frame
  
write.csv(known.specality.codes,  
          file = "NTEE-disaggregated/known-speciality-codes.csv",
          row.names = FALSE)
