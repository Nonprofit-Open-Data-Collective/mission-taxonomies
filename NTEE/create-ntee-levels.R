### Crosswalk 
library(tidyverse)
library(rvest)

ntee_list <- 
  "https://nccs.urban.org/publication/irs-activity-codes" %>%
  xml2::read_html() %>%
  rvest::html_nodes(css = "table") %>%
  rvest::html_table(fill = TRUE)

ntee.list <- ntee_list[[1]]
names( ntee.list ) <- c("ntee","description","definition")

# write.csv( ntee.list, "ntee2.csv", row.names=F )

#extract major groups (letters)
ntee.major.group <- ntee.list[ which( nchar( ntee.list$ntee ) < 3 ), ]

#extract ntee codes (letter + 2digits)
ntee.codes <- ntee.list[ which( nchar( ntee.list$ntee ) == 3 ), ]


## get broad categories 
ntee.levels <- 
  ntee.codes %>%
  dplyr::mutate (MajorGroup = substr( ntee, 1, 1) ) %>%
  #dissect NTEE to get mission levels
  dplyr::mutate( two.digit = substr( ntee, 2, 3 ) )%>%
  #Regular or specialty org
  dplyr::mutate( type.org = ifelse( two.digit < 20, "S", "R" ) ) %>%
  # not needed for cross walk, only needed for actual organizations. 
  # explanation in RMD
  #get further two digit if available for specialty or just two.digit if not available 
  dplyr::mutate( two.digit.s = dplyr::case_when( type.org == "S" & nchar(ntee) == 4 ~ paste(substr(ntee, 4, 4), 0),
                                                 type.org == "S" & nchar(ntee) == 5 ~ paste(substr(ntee, 4, 5)),
                                                 TRUE ~ two.digit )) %>%
  #get decile values
  dplyr::mutate( tens = substr( two.digit.s, 1, 1 ) ) %>%
  dplyr::mutate( tens = ifelse( tens < 2, 0, tens ) ) %>% #all specialty orgs get 0 in the tens place
  # get centile values
  dplyr::mutate( ones = substr( two.digit.s, 2, 2) ) %>%
  #get Hosp
  dplyr::mutate( hosp = ifelse( MajorGroup == "E" & tens == 2, TRUE, FALSE) ) %>%
  #get Univ 
  dplyr::mutate( univ = ifelse( MajorGroup == "B" & (tens == 4 | tens == 5), TRUE, FALSE ) )  %>%
  #Broad Category
  dplyr::mutate( BroadCategory = case_when( MajorGroup == "A" ~ 1, 
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
                                        MajorGroup == "E" & hosp ~ 12) ) %>%
  dplyr::relocate( BroadCategory, .before = MajorGroup )





## Save 
save( ntee.levels, file = "ntee-levels.rda" )
write.csv( ntee.levels, "ntee-levels.csv", row.names=F )
