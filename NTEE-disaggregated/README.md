# National Taxonomy of Exempt Entities


## Overview 

From: https://nccs.urban.org/project/national-taxonomy-exempt-entities-ntee-codes

The National Taxonomy of Exempt Entities (NTEE) system is used by the IRS and NCCS to classify nonprofit organizations. It is also used by the Foundation Center to classify both grants and grant recipients (typically nonprofits or governments).  NCCS and the IRS use the NTEE-CC system, described below, while the Foundation Center uses a slightly different version with more codes, as well as "population/beneficiary" codes to indicate the type of population served and "auspice" codes to indicate religious or governmental affiliation.


### Structure of the NTEE-CC

**Major Groups:**

* I. Arts, Culture, and Humanities - A
* II. Education - B
* III. Environment and Animals - C, D
* IV. Health - E, F, G, H
* V. Human Services - I, J, K, L, M, N, O, P
* VI. International, Foreign Affairs - Q
* VII. Public, Societal Benefit - R, S, T, U, V, W
* VIII. Religion Related - X
* IX. Mutual/Membership Benefit - Y
* X. Unknown, Unclassified - Z

**Common Codes:** 

Common codes represent activities of organizations, such as research, fundraising, and technical assistance, which are common to all major groups. The seven common codes used are:

* 01 Alliance/Advocacy Organizations  
* 02 Management and Technical Assistance  
* 03 Professional Societies/Associations  
* 05 Research Institutes and/or Public Policy Analysis 
* 11 Monetary Support - Single Organization  
* 12 Monetary Support - Multiple Organizations  
* 19 Nonmonetary Support Not Elsewhere Classified (N.E.C.)  

## Codes

A useful two-page summary of codes: 

[download](https://github.com/Nonprofit-Open-Data-Collective/machine_learning_mission_codes/raw/master/docs/assets/NTEE_Two_Page_2005.pdf)

A table of the NTEE codes is available at the National Center for Charitable Statistics: 

https://nccs.urban.org/publication/irs-activity-codes

For a more friendly format, [dhenderson has created a JSON version](https://github.com/dhenderson/ntee): 

[ntee.json](https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/mission-taxonomies/main/NTEE/ntee.json)

Or you can download the table as a CSV:

[ntee.csv](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/blob/main/NTEE/ntee.csv)


## New NTEE Format

Crosswalk table that includes high-level codes (major groups, minor groups) and the new disaggregated codes. 

Definition of disaggregated codes 


| Variable Name | Calculation depend on... | Description | 
|---------------|-------------|----------------|
|`NTEE`         |             |  Original NTEE Code |
|`BroadCategroy` |`MajorGroup`, `hosp`, `univ` | 1 - 12 value based on "Major Groups" groupings above with the addition of hospitals and universities: <br/>* 1: Arts, Culture, and Humanities - A <br/> * 2: Education - B <br/> * 3: Environment and Animals - C, D <br/> * 4: Health - E, F, G, H <br/> * 5: Human Services - I, J, K, L, M, N, O, P <br/> * 6: International, Foreign Affairs - Q <br/> * 7: Public, Societal Benefit - R, S, T, U, V, W <br/> * 8: Religion Related - X <br/> * 9: Mutual/Membership Benefit - Y <br/> * 10: Unknown, Unclassified - Z <br/> * 11: Hospital: If MajorGroup is E and tens place is 2 <br/> * 12: University: If MajorGroup is B and tens place is 4 or 5| 
|`MajorGroup  ` | letter of `NTEE` | A-Z value of "Major Groups" | 
|`two.digit`| `NTEE` | First two digits of NTEE codes. <br/> Example 1: If `NTEE` is A32 then `two.digit` is 32. <br/> Example 2: If `NTEE` is A02, then `two.digit` is 02. <br/> Example 2: if `NTEE` is A1132 then `two.digit` is 11.  |
|`type.org` | `two.digit` | Type.org is "R" for regular if `two.digit` $>=20$. Type.org is "S" for specialty if `two.digit` $<20$. Note all common codes are less than 20, so 20 is the cut off between "regular" and "specialty" organizations.  | 
|`two.digit.s` | `two.digit` | `two.digit.s` stands for two-digit-specialty. This is used only for specialty organizations that have a further categorization by adding a 3rd and 4th digit onto their original NTEE code. If the organization has `type.org` = R, then `two.digit.s` is just `two.digit`. If the organization has `type.org` and only two digits in their `NTEE` code, then  then `two.digit.s` is just `two.digit`.  If the organization has `type.org` and has four digits in their `NTEE` code, this value is the 3rd and 4th digits of the `NTEE` code. <br/> Example 1: If `NTEE` is A32 then `two.digit.s` is 32. <br/> Example 2: If `NTEE` is A02, then `two.digit.s` is 02. <br/> Example 3: if `NTEE` is A1132 then `two.digit.s` is 32.  |
`tens` |`two.digit.s` | If `two.digit.s`<20, `tens` is 0 (i.e. all specialty organizations with no further categorization have a have of 0). If `two.digit.s`$>=$ 20 `tens` is the "tens" places of this values. <br/> Example 1: If `NTEE` is A32 then `tens` is 3. <br/> Example 2: If `NTEE` is A02, then `tens` is 0. <br/> Example 3: If `NTEE` is A12, then `tens` is 0. Example 4: if `NTEE` is A1132 then `tens` is 3. |
`ones` | `two.digit.s` | This is the "ones" place of `two.digit.s`. Note that this value is NOT useful for specialty organizations that DO NOT have a further categorization (since 01 and 12 common codes are not related in any way even though they both have a 2 in the "ones" place). <br/> Example 1: If `NTEE` is A32 then `ones` is 2. <br/> Example 2: If `NTEE` is A02, then `ones` is 2. <br/> Example 3: If `NTEE` is A12, then `ones` is 2. Example 4: if `NTEE` is A1132 then `tens` is 2. |
`hosp` | `MajorGroup`, `tens` | `TRUE` if `MajorGroup` = E and `tens` = 2. `FALSE` otherwise. | 
`univ` | `MajorGroup`, `tens` | `TRUE` if `MajorGroup` = B and (`tens` = 4 or `tens` = 5). `FALSE` otherwise. | 
