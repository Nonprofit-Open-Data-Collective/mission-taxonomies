## Getting used letter+4digit NTEE Codes 
library(aws.s3)
library(dplyr)

# import data from NCCS bmf
bmf.url <- "https://nccsdata.s3.us-east-1.amazonaws.com/current/bmf/bmf-master.rds"
bmf <- readRDS(url(bmf.url))


known.specality.codes <- 
  bmf %>%
  select(NTEECC) %>%
  filter(nchar(NTEECC) == 5) %>% # 1 letter + 4 digits 
  arrange(NTEECC) %>%
  distinct() %>%
  as.data.frame

write.csv(known.specality.codes,  
          file = "NTEE-disaggregated/known-speciality-codes-bmf.csv",
          row.names = FALSE)
