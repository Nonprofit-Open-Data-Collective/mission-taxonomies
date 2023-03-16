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
  dplyr::mutate(MajorGroup = substr(NTEE, 1, 1)) %>%
  #dissect NTEE to get mission levels
  dplyr::mutate(two.digit = substr(NTEE, 2, 3))%>%
  #Regular or specialty org
  dplyr::mutate(type.org = ifelse(two.digit < 20, "speciality", "regular")) %>%
  # not needed for cross walk, only needed for actual organizations. 
  # explanation in RMD
  #get further two digit if available for specialty or just two.digit if not available 
  dplyr::mutate(two.digit.s = dplyr::case_when(type.org == "speciality" & nchar(NTEE) == 4 ~ paste(substr(NTEE, 4, 4), 0),
                                               type.org == "speciality" & nchar(NTEE) == 5 ~ paste(substr(NTEE, 4, 5)),
                                               TRUE ~ two.digit)) %>%
  #get decile values
  dplyr::mutate(tens = substr(two.digit.s, 1, 1)) %>%
  dplyr::mutate(tens = ifelse(tens < 2, 0, tens)) %>% #all specialty orgs get 0 in the tens place
  # get centile values
  dplyr::mutate(ones = substr(two.digit.s, 2, 2)) %>%
  #get Hosp
  dplyr::mutate(hosp = ifelse(MajorGroup == "E" & substr(two.digit, 1, 1) == 2, TRUE, FALSE)) %>% # from two.digit., not two.digit.s
  #get Univ 
  dplyr::mutate(univ = ifelse(MajorGroup == "B" & (substr(two.digit, 1, 1) == 4 | substr(two.digit, 1, 1) == 5), TRUE, FALSE))  %>% # from two.digit., not two.digit.s
  #Broad Category
  dplyr::mutate(BroadCategory = case_when(MajorGroup == "A" ~ 1, 
                                        MajorGroup == "B" & !univ ~ 2, 
                                        MajorGroup %in% c("C", "D") ~ 3,
                                        MajorGroup %in% c("E", "F", "G", "H") & !hosp ~ 4,
                                        MajorGroup %in% c("I", "J", "K", "L", "M", "N", "O", "P") ~ 5,
                                        MajorGroup == "Q" ~ 6, 
                                        MajorGroup %in% c("R", "S", "T", "U", "V", "W") ~ 7,
                                        MajorGroup == "X" ~ 8, 
                                        MajorGroup == "Y" ~ 9, 
                                        MajorGroup == "Z" ~ 10,
                                        MajorGroup == "B" & univ ~ 11, 
                                        MajorGroup == "E" & hosp ~ 12))%>%
  dplyr::relocate(BroadCategory, .before = MajorGroup)





## Save 
save(ntee.crosswalk, file = "NTEE-disaggregated/ntee-crosswalk.rda")
write.csv(ntee.crosswalk, file = "NTEE-disaggregated/ntee-crosswalk.csv", row.names = F)


