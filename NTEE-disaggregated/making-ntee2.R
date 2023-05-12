## Level 1 - broad category 
## Level 2 - major group
## Level 3 - division.s
## Level 4 - subdivision.s
## Level 5 - org.type

### Crosswalk 
library(dplyr)
library(readr)


## Read in data ---------------------------------------------------------------
#Regular codes 
codes.orig <- read_csv("NTEE/ntee-levels.csv", col_select = 1)
colnames(codes.orig) <- "NTEE"

#Known used specialty letter+4digit codes 
codes.special <- read_csv("NTEE-disaggregated/known-speciality-codes.csv")
colnames(codes.special) <- "NTEE"

#code descriptions
ntee.descriptions <- read_csv("ntee-levels.csv")

#key words 
ntee.keywords <- read_csv("NTEE/ntee.csv")

#extract ntee codes (letter + 2digits)
ntee.codes <- codes.orig[ which(nchar(codes.orig$`NTEE`) == 3), ]



### Making tables for merging later --------------------------------------------


#if there is not a 90, use the 99 for the 90 division
#make a data set to merge into the ntee.descriptions

which.have.90 <- 
  ntee.descriptions %>%
  select(ntee, MajorGroup, tens, ones) %>%
  filter(tens == 9 , ones == 0) %>% 
  pull(MajorGroup)

which.no.90 <- LETTERS[ !(LETTERS %in% which.have.90) ]


additions <- data.frame(MajorGroup = which.no.90,
                        description = NA,
                        definition = NA)

additions$ntee <- paste0(additions$MajorGroup, 90)

#Add definitions
for(i in 1:nrow(additions)){
  #get the 99 code for that major group
  dat.temp <-
    ntee.descriptions %>%
    filter(MajorGroup == additions$MajorGroup[i],
           tens == 9,
           ones == 9)
    
  #add it to a 90 code
  additions$description[i] <- dat.temp$description
  additions$definition[i] <- dat.temp$definition
  
}
  
# merge with ntee.description
ntee.descriptions <-
  ntee.descriptions %>%
  dplyr::select(ntee, description, definition) %>%
  rbind(additions %>%
          dplyr::select(ntee, description, definition)) %>% 
  dplyr::arrange(ntee)

## adding a few definitions to problem cases (K6A - K6F, K2A, K2A, K2B, K2C, E6A, L4A, L4B, N2A, N2B, P7A)

ntee.descriptions$definition[ntee.descriptions$definition == "NULL" ] <-
  ntee.descriptions$description[ntee.descriptions$definition == "NULL"]

# Add K60 to ntee.descriptions for merging and labeling purposes
# will not be in final table as K60 is not a real NTEE code
ntee.descriptions <-
  ntee.descriptions %>%
  dplyr::add_row(ntee = "K60", description = "Food/Beverage Sales", definition = "Food/Beverage Sales")


## table for level 3 label merge 
merge.level3 <- 
  ntee.descriptions %>%
  #only keep division level descriptions
  dplyr::filter(substr(ntee, 3, 3) == 0 ) %>%
  #extract major group and division
  dplyr::mutate(merge.col3 = substr(ntee, 1, 2)) %>%
  #only keep merge column and division name 
  dplyr::select(description, merge.col3) %>% 
  #name for final table
  dplyr::rename(level3.label = description)

## table for level 3 label merge 
merge.level4 <- 
  ntee.descriptions %>%
  #only keep division level descriptions
  dplyr::filter(nchar(ntee) == 3) %>%
  #extract major group and division
  dplyr::rename(merge.col4 = ntee) %>%
  #name for final table
  dplyr::rename(level4.label = definition)%>%
  #only keep merge column and division name 
  dplyr::select(level4.label, merge.col4) 


## Table for keywords
#not every code as key words

#make keywords one column
ntee.keywords$keep.keywords <- 0
for(i in 1:nrow(ntee.keywords)){
  temp.words <- ntee.keywords[i, grepl("^keywords", colnames(ntee.keywords))]
  keep.words <- !is.na(temp.words)
  ntee.keywords$keep.keywords[i] <- paste(temp.words[keep.words], collapse = ", ")
}

ntee.keywords <- ntee.keywords %>% 
  dplyr::select(ntee, keep.keywords) %>%
  dplyr::rename(NTEE = ntee, 
                keywords = keep.keywords)

 

## Make data set ----------------------------------------------------------------
ntee.crosswalk <- 
  rbind(ntee.codes, codes.special) %>%
  arrange(NTEE) %>%
  ## Get Hospital and Univ indicators
  dplyr::mutate(hosp = NTEE %in% c("E20", "E21", "E22", "E24")) %>%
  dplyr::mutate(univ = NTEE %in% c("B40", "B41", "B42", "B43", "B50")) %>%
  # Level 2
  dplyr::mutate(level2 = substr(NTEE, 1, 1)) %>%
  # Level 1
  dplyr::mutate(level1 = case_when(level2 == "A" ~ "ART", 
                                   level2 == "B"  ~ "EDU", 
                                   level2 %in% c("C", "D") ~ "ENV",
                                   level2 %in% c("E", "F", "G", "H")~ "HEL",
                                   level2 %in% c("I", "J", "K", "L", "M", "N", "O", "P") ~ "HMS",
                                   level2 == "Q" ~ "IFA", 
                                   level2 %in% c("R", "S", "T", "U", "V", "W") ~ "PSB",
                                   level2 == "X" ~ "REL", 
                                   level2 == "Y" ~ "MMB", 
                                   level2 == "Z" ~ "UNU")) %>%
  # Level 5
  dplyr::mutate(two.digit = substr(NTEE, 2, 3))%>%
  dplyr::mutate(level5 = 
                  case_when(
                    two.digit == "01" ~ "AA", 
                    two.digit == "02" ~ "MT",
                    two.digit == "03" ~ "PA",
                    two.digit == "05" ~ "RP",
                    two.digit == "11" ~ "MS", 
                    two.digit == "12" ~ "MM",
                    two.digit == "19" ~ "NS", 
                    TRUE ~ "RG"))  %>%
  # dissect NTEE to get levels 3 and 4
  dplyr::mutate(specality.support = substr(NTEE, 4, 5)) %>%
  dplyr::mutate(level.three.four = 
                  case_when(
                    #regular organizations never have specialty support
                    level5 == "RG" ~ two.digit, 
                    #if specialty or, if no specific support category, write 00
                    level5 != "RG" & nchar(specality.support) == 0 ~ "00",
                    #otherwise write specialty support category
                    level5 != "RG" & nchar(specality.support) == 2 ~ specality.support)) %>%
  #Get levels 3 and 4
  dplyr::mutate(level3 = substr(level.three.four, 1, 1)) %>%
  dplyr::mutate(level4 = substr(level.three.four, 2, 2)) %>%
  # Get NTEE 2 
  dplyr::mutate(NTEE2 = paste0(level1, "-", level2, level3, level4, "-", level5)) %>% 
  # Add wildcard characters to levels 2, 3, 4
  dplyr::mutate(level4 = paste0(level2, level3, level4),
                level3 = paste0(level2, level3, "x"),
                level2 = paste0(level2, "xx")) %>%
  #sort columns and remove intermediary steps
  dplyr::select(NTEE, NTEE2, level1, level2, level3, level4, level5, univ, hosp)



### Adding labels

ntee.crosswalk <- 
  ntee.crosswalk %>%
  ## Level 1 label
  dplyr::mutate(
    level1.label = case_when(
      level1 == "ART" ~ "Arts, Culture & Humanities",
      level1 == "EDU" ~ "Education",
      level1 == "ENV" ~ "Environment and Animals",
      level1 == "HEL" ~ "Health",
      level1 == "HMS" ~ "Human Services",
      level1 == "IFA" ~ "International, Foreign Affairs",
      level1 == "PSB" ~ "Public, Societal Benefit",
      level1 == "REL" ~ "Religion Related",
      level1 == "MMB" ~ "Mutual/Membership Benefit",
      level1 == "UNU" ~ "Unknown/Unclassified")) %>%
  ## Level 2 label
  dplyr::mutate(level2.label = case_when(
    substr(level2, 1, 1) == "A" ~ "Arts, Culture & Humanities",
    substr(level2, 1, 1) == "B" ~ "Education", 
    substr(level2, 1, 1) == "C" ~ "Environment",
    substr(level2, 1, 1) == "D" ~ "Animal-Related",
    substr(level2, 1, 1) == "E" ~ "Health Care",
    substr(level2, 1, 1) == "F" ~ "Mental Health & Crisis Intervention",
    substr(level2, 1, 1) == "G" ~ "Voluntary Health Associations & Medical Disciplines",
    substr(level2, 1, 1) == "H" ~ "Medical Research",
    substr(level2, 1, 1) == "I" ~ "Crime & Legal-Related",
    substr(level2, 1, 1) == "J" ~ "Employment",
    substr(level2, 1, 1) == "K" ~ "Food, Agriculture & Nutrition",
    substr(level2, 1, 1) == "L" ~ "Housing & Shelter",
    substr(level2, 1, 1) == "M" ~ "Public Safety, Disaster Preparedness & Relief",
    substr(level2, 1, 1) == "N" ~ "Recreation & Sports",
    substr(level2, 1, 1) == "O" ~ "Youth Development",
    substr(level2, 1, 1) == "P" ~ "Human Services",
    substr(level2, 1, 1) == "Q" ~ "International, Foreign Affairs & National Security",
    substr(level2, 1, 1) == "R" ~ "Civil Rights, Social Action & Advocacy",
    substr(level2, 1, 1) == "S" ~ "Community Improvement & Capacity Building",
    substr(level2, 1, 1) == "T" ~ "Philanthropy, Voluntarism & Grantmaking Foundations",
    substr(level2, 1, 1) == "U" ~ "Science & Technology",
    substr(level2, 1, 1) == "V" ~ "Social Science",
    substr(level2, 1, 1) == "W" ~ "Public & Societal Benefit",
    substr(level2, 1, 1) == "X" ~ "Religion-Related",
    substr(level2, 1, 1) == "Y" ~ "Mutual & Membership Benefit",
    substr(level2, 1, 1) == "Z" ~ "Unknown")) %>%
  ## Level 5 Label (needed for level 3 and 4 labels)
  dplyr::mutate(level5.label = case_when(
    level5 == "AA" ~ "Alliance/Advocacy Organization", 
    level5 == "MT" ~ "Management and Technical Assistance", 
    level5 == "PA" ~ "Professional Society/Association", 
    level5 == "RP" ~ "Research Institute and/or Public Policy Analysis", 
    level5 == "MS" ~ "Monetary Support - Single Organization", 
    level5 == "MM" ~ "Monetary Support - Multiple Organizations", 
    level5 == "NS" ~ "Nonmonetary Support Not Elsewhere Classified (N.E.C.)",
    level5 == "RG" ~ "Regular Nonprofit"
  )) %>%
  ## level 3 labels 
  # make column to merge on
  dplyr::mutate(merge.col3 = substr(level3, 1, 2)) %>%
  # merge with level 3 labels
  dplyr::left_join(merge.level3) %>% 
  # Add labels for specality organizations  
  dplyr::mutate(
    level3.label = case_when(
      level5 == "RG" ~ level3.label,
      level5 == "AA" ~ paste0(level5.label, " for a nonprofit in ", tolower(level2.label), "."),
      level5 == "MT" ~ paste0("Organization providing ", tolower(level5.label), 
                             " for a nonprofit in ", tolower(level2.label), "."),
      level5 %in% c("PA", "RP") ~ paste0(level5.label, " in ", tolower(level2.label), "." ),
      level5 == "MS" ~ paste0("Providing monetary support to a sinlge organization in ",
                              tolower(level2.label), "."),
      level5 == "MM" ~ paste0("Providing monetary support to multiple organizations in ",
                               tolower(level2.label), "."),
      level5 == "NS" ~ paste0("Providing" , tolower(level5.label), " to a nonprofit in",
                              tolower(level2.label), "."),
    ))%>%
  ## level 4 label 
  # make column to merge on
  dplyr::mutate(merge.col4 = level4) %>%
  # merge 
  dplyr::left_join(merge.level4)%>%
  # if NA, set to level 3 label
  # its the letter + 00 organzations that have a NA for level4 label at this point
  dplyr::mutate(
    level4.label = ifelse(is.na(level4.label), level3.label, level4.label)) %>% 
  #merge with keywords 
  dplyr::left_join(ntee.keywords) %>%
  ## keep only necessary columns 
  dplyr::select(NTEE, NTEE2, level1, level2, level3, level4, level5, 
                level1.label, level2.label, level3.label, level4.label,
                level5.label, keywords)

## Save table
save(ntee.crosswalk, file = "NTEE-disaggregated/ntee-crosswalk.rda")
write.csv(ntee.crosswalk, file = "NTEE-disaggregated/ntee-crosswalk.csv", row.names = F)


  



