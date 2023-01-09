10 MAJOR NTEE CATEGORIES (ntmaj10*)
Groups 26 main NTEE categories A-Z (1stcharacter of 3-character NTEE) into 10 major categories.
NTEE    Code    Description
A   AR  Arts, culture, and humanities
B   ED  Education
C,D EN  Environment
E,F,G,H HE  Health
I,J,K,L,M,N,O,P HU  Human services
Q   IN  International
R,S,T,U,V,W PU  Public and societal benefit
X   RE  Religion
Y   MU  Mutual benefit
Z   UN  Unknown
* ntmaj10 is the basis for ntmaj5 and ntmaj12
 
12 MAJOR NTEE CATEGORIES (ntmaj12)
Expands 10 Major NTEE categories into 12 categories, with Higher Education (B4 & B5) separate from other education organizations (B), and Hospitals (E2) separate from other health organizations (E).
NTEE    Code    Description
A   AR  Arts, culture, and humanities
B4,B5   BH  Higher education
B (other than B4,B5)    ED  Education (other)
C,D EN  Environment
E2  EH  Hospitals
E (other than E2),F,G,H HE  Health (other)
I,J,K,L,M,N,O,P HU  Human services
Q   IN  International
R,S,T,U,V,W PU  Public and societal benefit
X   RE  Religion
Y   MU  Mutual benefit
Z   UN  Unknown
 
5 MAJOR NTEE CATEGORIES (ntmaj5)
Groups 10 Major NTEE categories into 5 categories.
NTEE    Code    Description
A   AR  Arts, culture, and humanities
B   ED  Education
E,F,G,H HE  Health
I,J,K,L,M,N,O,P HU  Human services
C,D,Q,R,S,T,U,V,W,X,Y,Z OT  Other


```r
# NTEE1 and NTEE2 

d$NTEE1   <- substr( d$NTEEFINAL, 0, 1 )
d$HEALTH  <- grepl( "E", d$NTEE1 )
d$EDU     <- grepl( "B", d$NTEE1 )

d$NTEE2 <- substr( d$NTEEFINAL, 0, 2 )
d$HOSP <- grepl( "E2", d$NTEE2 )
d$UNIV <- grepl( "B4", d$NTEE2 ) | grepl( "B5", d$NTEE2 )

# MAJOR 12 GROUPS 

d$NTMAJ12 <- rep( "", nrow(d) )
d$NTMAJ12[ d$NTEE1 == "A" ]                                   <- "ARTS"
d$NTMAJ12[ d$NTEE1 == "B" & (! d$UNIV) ]                     <- "EDUCATION"
d$NTMAJ12[ d$NTEE1 %in% c("C","D") ]                          <- "ENVIRONMENT"
d$NTMAJ12[ d$NTEE1 %in% c("E","F","G","H") & (! d$HOSP) ]    <- "HEALTH"
d$NTMAJ12[ d$NTEE1 %in% c("I","J","K","L","M","N","O","P") ]  <- "HUM SERV"
d$NTMAJ12[ d$NTEE1 == "Q" ]                                   <- "INTERNATIONAL"
d$NTMAJ12[ d$NTEE1 %in% c("R","S","T","U","V","W") ]          <- "PUB GOOD"
d$NTMAJ12[ d$NTEE1 == "X" ]                                   <- "RELIGION"
d$NTMAJ12[ d$NTEE1 == "Y" ]                                   <- "MUTUAL"
d$NTMAJ12[ d$NTEE1 == "Z" ]                                   <- "UNKNOWN"
d$NTMAJ12[ d$HOSP ]                                           <- "HOSPITAL"
d$NTMAJ12[ d$UNIV ]                                           <- "HIGHER ED"
```
