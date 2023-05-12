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
  relocate(old.code, new.code, type.org, broad.category, major.group, 
           univ, hosp, two.digit, further.category, division.subdivision)

### Adding descriptions ----------------------------------------------------------
### needed values 

ntee.keywords <- read_csv("NTEE/ntee.csv")

#make keywords one column
ntee.keywords$keep.keywords <- 0
for(i in 1:nrow(ntee.keywords)){
  temp.words <- ntee.keywords[i, grepl("^keywords", colnames(ntee.keywords))]
  keep.words <- !is.na(temp.words)
  ntee.keywords$keep.keywords[i] <- paste(temp.words[keep.words], collapse = ", ")
}

ntee.keywords <- ntee.keywords[ , c("ntee", "title", "description", "keep.keywords")]


### Adding descriptions to data set 
ntee.crosswalk<- 
  ntee.crosswalk %>%
  ## add broad category description
  dplyr::mutate(
    broad.category.description = case_when(
     broad.category == "ART" ~ "Arts, Culture & Humanities",
     broad.category == "EDU" ~ "Education, Non-University",
     broad.category == "ENV" ~ "Environment and Animals",
     broad.category == "HEL" ~ "Health, Non-Hospital",
     broad.category == "HMS" ~ "Human Services",
     broad.category == "IFA" ~ "International, Foreign Affairs",
     broad.category == "PSB" ~ "Public, Societal Benefit",
     broad.category == "REL" ~ "Religion Related",
     broad.category == "MMB" ~ "Mutual/Membership Benefit",
     broad.category == "UNU" ~ "Unknown/Unclassified",
     broad.category == "HOS" ~ "Hosptial",
     broad.category == "UNI" ~ "University")) %>%
  ## add major group description
  dplyr::mutate(major.group.description = case_when(
    major.group == "A" ~ "Arts, Culture & Humanities",
    major.group == "B" ~ "Education, Non-Univeristy", 
    major.group == "C" ~ "Environment",
    major.group == "D" ~ "Animal-Related",
    major.group == "E" ~ "Health Care, Non-Hospital",
    major.group == "F" ~ "Mental Health & Crisis Intervention",
    major.group == "G" ~ "Voluntary Health Associations & Medical Disciplines",
    major.group == "H" ~ "Medical Research",
    major.group == "I" ~ "Crime & Legal-Related",
    major.group == "J" ~ "Employment",
    major.group == "K" ~ "Food, Agriculture & Nutrition",
    major.group == "L" ~ "Housing & Shelter",
    major.group == "M" ~ "Public Safety, Disaster Preparedness & Relief",
    major.group == "N" ~ "Recreation & Sports",
    major.group == "O" ~ "Youth Development",
    major.group == "P" ~ "Human Services",
    major.group == "Q" ~ "International, Foreign Affairs & National Security",
    major.group == "R" ~ "Civil Rights, Social Action & Advocacy",
    major.group == "S" ~ "Community Improvement & Capacity Building",
    major.group == "T" ~ "Philanthropy, Voluntarism & Grantmaking Foundations",
    major.group == "U" ~ "Science & Technology",
    major.group == "V" ~ "Social Science",
    major.group == "W" ~ "Public & Societal Benefit",
    major.group == "X" ~ "Religion-Related",
    major.group == "Y" ~ "Mutual & Membership Benefit",
    major.group == "Z" ~ "Unknown",
    major.group == "UNI" ~ "University",
    major.group == "HOS" ~ "Hospital")) %>%
  # division.subdivision.description
  dplyr::left_join(ntee.keywords, 
                   by = join_by(old.code ==ntee)) %>%
  dplyr::rename(division.subdivision.description = description) %>%
  # rename key words
  dplyr::rename(keywords = keep.keywords) %>%
  # rename code title
  dplyr::rename(code.name = title) %>%
  # override specialty codes to two.digit in division.subdivision.description
  dplyr::mutate(division.subdivision.description = case_when(
    two.digit == "01" ~ "Alliance/Advocacy Organizations", 
    two.digit == "02" ~ "Management and Technical Assistance", 
    two.digit == "03" ~ "Professional Societies/Associations", 
    two.digit == "05" ~ "Research Institutes and/or Public Policy Analysis", 
    two.digit == "11" ~ "Monetary Support - Single Organization", 
    two.digit == "12" ~ "Monetary Support - Multiple Organizations", 
    two.digit == "19" ~ "Nonmonetary Support Not Elsewhere Classified (N.E.C.)",
    TRUE ~ division.subdivision.description
  )) 

## Add further category descriptions in a for loop, I can't figure out how to do it in dplyr
ntee.crosswalk$further.category.desciption <- " "
for(i in 1:nrow(ntee.crosswalk)){
  #only do something if it is a specality org
  if(nchar(ntee.crosswalk$further.category[i]) > 1){
    
    #get code of further description
    temp.code <- paste0(ntee.crosswalk$major.group[i], ntee.crosswalk$further.category[i])
    
    #get the correct further description
    temp.description <- ntee.keywords$description[ntee.keywords$ntee == temp.code]
    
    #format and save
    ntee.crosswalk$further.category.desciption[i] <-
      paste0("Providing support to ", 
            tolower(substr(temp.description, 1, 1)), #make the first character lower case
            substr(temp.description, 2, nchar(temp.description)))
            
  }
}



## Save 
save(ntee.crosswalk, file = "NTEE-disaggregated/ntee-disaggregated.rda")
write.csv(ntee.crosswalk, file = "NTEE-disaggregated/ntee-disaggregated.csv", row.names = F)





