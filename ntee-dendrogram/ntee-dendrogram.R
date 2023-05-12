#### Making the Dendogram/Collapsable Tree for original NTEE Codes 

#devtools::install_github("AdeelK93/collapsibleTree")
library(collapsibleTree)
library(tidyverse)

#load in needed data 
data("ntee.crosswalk")
data("ntee.orig")

#maually fixing some problem cases
ntee.orig[ntee.orig$ntee  == "A53", "description"] <- "Folk Arts Museums"
#remove ones with letters in the ones place for the moment 
ntee.orig <- ntee.orig[!(substr(ntee.orig$ntee, 3,3) %in% LETTERS), ]


ntee.codes.normal <- 
  ntee.orig %>%
  filter(nchar(ntee) == 3) %>%
  select(ntee)

#list of unique divisions
dat.letter1 <- 
  ntee.orig%>%
  filter(substr(ntee, 3, 3) == 0) %>%
  mutate(letter1 = substr(ntee, 1, 2)) %>%
  select(-c(ntee, definition)) 


#list of unique subdivisions 
dat.letter2 <- 
  ntee.orig %>%
  filter(nchar(ntee) == 3) %>%
  select(-definition) %>%
  mutate(description = gsub("<*>*", "", description)) %>%
  rename(letter2 = ntee) 



# make data frame with all ntee code levels and descriptions 
NTEE <- ntee.crosswalk %>%
  #keep only the regular and normal specality codes
  filter(old.code %in%ntee.codes.normal$ntee ) %>%
  #add the ones description 
  left_join(ntee.orig, by = join_by(old.code == ntee)) %>%
  rename(description.ones = description) %>%
  #get needed values for merging division description
  mutate(division = substr(division.subdivision, 1, 1)) %>%
  mutate(subdivision = substr(division.subdivision, 2,2)) %>%
  mutate(letter1 = paste0(major.group, division)) %>%
  #merge with list of unique divisions and do some basic formatting to create 
  #unique specialty codes within each major group
  left_join(dat.letter1, by = "letter1") %>% 
  #add letter to the word specialty for identifiability
  mutate(description.tens = 
           ifelse(type.org != "RG", 
                  paste("Specality - ", major.group), 
                  description))%>%
  #do the same thing for the specality descriptions
  mutate(description.ones =
           ifelse(two.digit<20,
                  paste(description.ones, " - ", major.group),
                  description.ones))%>%
  #if is 99 code, ad in description tens to be "NEC"
  mutate(description.tens = 
           ifelse(two.digit == "99", 
                  description.ones, 
                  description.tens)) %>%
  # name broad category correctly 
  dplyr::mutate(broad.category = case_when(
    broad.category == "ART" ~ "Arts, Culture & Humanities",
    broad.category == "EDU" & univ == FALSE ~ "Education",
    broad.category == "ENV" ~ "Environment and Animals",
    broad.category == "HEL" & hosp == FALSE ~ "Health",
    broad.category == "HMS" ~ "Human Services",
    broad.category == "IFA" ~ "International, Foreign Affairs",
    broad.category == "PSB" ~ "Public, Societal Benefit",
    broad.category == "REL" ~ "Religion Related",
    broad.category == "MMB" ~ "Mutual/Membership Benefit",
    broad.category == "UNU" ~ "Unknown/Unclassified",
    univ == TRUE ~ "University",
    hosp == TRUE ~ "Hospital"
    )) %>%
  #name major groups correctly
  dplyr::mutate(major.group = case_when(
    major.group == "A" ~ "Arts, Culture & Humanities",
    major.group == "B" ~ "Education", 
    major.group == "C" ~ "Environment",
    major.group == "D" ~ "Animal-Related",
    major.group == "E" ~ "Health Care",
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
    major.group == "Z" ~ "Unknown ")) %>%
  #only keep the important stuff
  dplyr::select(broad.category, major.group, description.tens, description.ones, old.code, definition)
#change all "/" to "-" ("/" is a special character for trees)
NTEE <- as.data.frame(lapply(NTEE, function(y) gsub("/", "-", y)))

#add tool tip option for all
NTEE$tooltip = "YES"

#simple collapisable Tree
collapsibleTree(
  NTEE,
  hierarchy = c("broad.category", "major.group", "description.tens", "description.ones", "old.code"),
  width = 3000,
  fill = "red",
  fillByLevel = TRUE,
  tooltipHtml = "Yes"
) 


#### NTEE TREE _----------------------------------------

## Spaces Structure to differentiate levels for the TreeNetwork
## broad category = 0 spaces at end
## major group = 1 spaces at end 
## letter + 1 digit = 2 spaces at end (description tens)
## letter + 2 digit = 3 spaces at end (description ones)

#adding spaces in structure s othe computer can differential the levels
NTEE <- NTEE %>%
  dplyr::mutate(major.group = paste0(major.group, " ")) %>%
  dplyr::mutate(description.tens = paste0(description.tens, "  ")) %>%
  dplyr::mutate(description.ones = paste0(description.ones, "   ")) %>%
  mutate(pathString =
           paste0("NTEE:", 
                  broad.category, ":", 
                  major.group, ":",
                  description.tens, ":", 
                  description.ones, ":",
                  old.code))

# definitions table needed for joining later
ntee.join <- 
  ntee.orig %>%
  filter(nchar(ntee) != 1 ) %>%
  select(ntee, definition)%>%
  rename(to = ntee)

#make the data frame a tree structure 
ntee.tree <-  data.tree::as.Node(NTEE, pathDelimiter = ":")

#covert tree back to data frame using "to -> from" format
NTEE2 <-
  data.tree::ToDataFrameNetwork(
    ntee.tree, 
    "level", "count", # add level for tooltip later
    direction = "climb", 
    format = TRUE, 
    inheritFromAncestors = TRUE)%>% #forces "to -> from" format
  #count number of levels under the current level
  mutate(times = lengths(regmatches(to, gregexpr("/", to))))%>%
  #extracting the lowest level listed in each cell
  mutate(from = stringr::str_split_i(from, "/", -1)) %>%
  mutate(to =   stringr::str_split_i(to, "/", -1)) %>%
  #adding major groups specialty code names for identifiability 
  mutate(to = ifelse(
    grepl( "Specality*", to),
    gsub("[[:space:]]*$","",to),
    to)) %>%
  mutate(from = ifelse(
    grepl( "Specality*", from),
    gsub("[[:space:]]*$","",from),
    from)) %>%
  #remove any duplicates - just for safety 
  mutate(remove = to == from) %>%
  filter(!remove)  %>%
  #adding definitions
  left_join(ntee.join) %>%
  #formatting for pretty tooltips
  mutate(tooltip = 
           case_when(
             level == 0 ~ " ",
             level == 1 ~ " ",
             level == 2 ~ paste("Broad Category:", to, 
                                "<br>Contains", count, "Major Groups"),
             level == 3 ~ paste("Major Group:", to,
                                "<br>Contains", count, "Divisions"),
             level == 4 ~ paste("Division:", to,
                                "<br>Contains", count, "Subdivisions"),
             level == 5 ~ paste("Subdivision:", to,
                                "<br>Contains", count, "NTEE Codes"),
             level == 6 ~ paste("NTEE Code:", to,
                                "<br>Definition:", gsub('(.{1,50})(\\s|$)', '\\1<br>',definition )))) %>%
  #add level 0 - needed for building the tree
  add_row(from = NA, to = "NTEE", level = 0, count = 0, remove = FALSE, definition = "") %>%
  #keep only the things we need
  select(from, to, tooltip)

#save this graph as an html document for ntee tab on dashboard 
#save in images/ntee-dendrogram.html
# This takes 10-15 minutes to fully render
collapsibleTreeNetwork(NTEE2,
                       width = 3000,
                       height = 500,
                       linkLength = 110,
                       fill = "#0082ea",
                       tooltipHtml = "tooltip")




