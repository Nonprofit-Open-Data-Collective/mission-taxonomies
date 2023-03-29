### Crosswalk 
library(dplyr)
library(readr)


## Read in data 
#Regular codes 
codes.orig <- read_csv("NTEE/ntee-levels.csv", col_select = 1)
colnames(codes.orig) <- "NTEE"

#Known used specialty letter+4digit codes 
codes.special <- read_csv("NTEE-disaggregated/known-speciality-codes.csv")
colnames(codes.special) <- "NTEE"

#extract major groups (letters)
ntee.major.group <- codes.orig[ which(nchar(codes.orig$`NTEE`) < 3), ]

#extract ntee codes (letter + 2digits)
ntee.codes <- codes.orig[ which(nchar(codes.orig$`NTEE`) == 3), ]


## get broad categories 
ntee.crosswalk <- 
  rbind(ntee.codes, codes.special) %>%
  arrange(NTEE) %>%
  ## Get Hospital and Univ indicators
  dplyr::mutate(hosp = NTEE %in% c("E20", "E21", "E22", "E24")) %>%
  dplyr::mutate(univ = NTEE %in% c("B40", "B41", "B42", "B43", "B50")) %>%
  #Major Group
  dplyr::mutate(major.group = substr(NTEE, 1, 1)) %>%
  #Broad Category 
  dplyr::mutate(broad.category = case_when(major.group == "A" ~ "ART", 
                                          major.group == "B" & !univ ~ "EDU", 
                                          major.group %in% c("C", "D") ~ "ENV",
                                          major.group %in% c("E", "F", "G", "H") & !hosp ~ "HEL",
                                          major.group %in% c("I", "J", "K", "L", "M", "N", "O", "P") ~ "HMS",
                                          major.group == "Q" ~ "IFA", 
                                          major.group %in% c("R", "S", "T", "U", "V", "W") ~ "PSB",
                                          major.group == "X" ~ "REL", 
                                          major.group == "Y" ~ "MMB", 
                                          major.group == "Z" ~ "UNU",
                                          major.group == "B" & univ ~ "UNI", 
                                          major.group == "E" & hosp ~ "HOS"))%>%
  #dissect NTEE to get organization type
  dplyr::mutate(two.digit = substr(NTEE, 2, 3))%>%
  dplyr::mutate(type.org = 
                  case_when(
                    two.digit == "01" ~ "AA", 
                    two.digit == "02" ~ "MT",
                    two.digit == "03" ~ "PA",
                    two.digit == "05" ~ "RP",
                    two.digit == "11" ~ "MS", 
                    two.digit == "12" ~ "MM",
                    two.digit == "19" ~ "NS", 
                    TRUE ~ "RG")) %>%
  # dissect NTEE to get division
  dplyr::mutate(further.category = substr(NTEE, 4, 5)) %>%
  dplyr::mutate(division.subdivision = 
                  case_when(
                    type.org == "RG" ~ two.digit,
                    type.org != "RG" & nchar(further.category) == 0 ~ "00",
                    type.org != "RG" & nchar(further.category) == 2 ~ further.category)) %>%
  #New NTEE code
  dplyr::mutate(new.code = paste0(type.org, "-", broad.category, "-", major.group, division.subdivision)) %>%
  #Format Table
  rename(old.code = NTEE) %>%
  select(-univ, -hosp) %>%
  relocate(old.code, new.code, type.org, broad.category, major.group, 
           univ, hosp, two.digit, further.category, division.subdivision)


## Save 
save(ntee.crosswalk, file = "NTEE-disaggregated/ntee-crosswalk.rda")
write.csv(ntee.crosswalk, file = "NTEE-disaggregated/ntee-crosswalk.csv", row.names = F)


