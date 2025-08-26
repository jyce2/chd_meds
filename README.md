# Coronary Heart Disease Study: Analysis Data Set Preparation


*Goal:* We are preparing an analysis data set for a manuscript looking at whether the
mineral magnesium – both in the diet and in the blood – affects coronary heart disease (CHD)
and some conditions possibly associated with CHD, such as hypertension, diabetes, and carotid
artery wall thickness.<br>

*Study background information:* The data sets for this assignment come from the initial
participant visit in a longitudinal study that was designed to try to understand factors that affect
occurrence of heart disease. This study, involving 16,000 people at four clinical sites, has been
the basis for hundreds of papers that contribute to our scientific knowledge. The study began
in the mid-1980’s and is still going strong today.<br> 

In each participant’s initial visit to the clinic (which we call Visit 1), blood was drawn, many
measurements were taken, and several forms were filled out in an interview. The data sets
provided to you for this assignment contain only a fraction of the data collected at the visit, but
still this exercise will be realistic and provide you with a good perspective on what it takes to
create an analysis data set.<br>

*Data sets:* Unless otherwise specified, all data sets in the CHD collection contain variable ID,
which is a participant’s unique study ID across all visits, and they contain only one record per ID
(the medications_long data set is an exception). Variables ID, Gender, Race, and Age have no
missing values, but all other variables might have missing values for some participants.<br>

**Core**<br>
The Core data set contains a collection of demographic and miscellaneous variables that
you will supplement with variables from the other data sets. Besides ID, variables
include:<br>
| Variable | Definition | 
| --------| -----------|
| Age | Age at visit |
|BMI  | body mass index |
|Gender | Sex of participant (F, M) |
|HOM10D Was stroke ever diagnosed? | from the Home Interview Form (Y, N, U for Unknown) |
|HOM55 | Current occupational status from the Home Interview Form |
|DTIA90 | Do you presently drink alcoholic beverages? from the Dietary Intake Form (Y, N) |
|DTIA91 | Have you ever consumed alcoholic beverages? (Y, N) |
|DTIA96 | # glasses of wine per week |
|DTIA97 | # beers per week |
|DTIA98 | # drinks of liquor per week |
|Fast8  |Fasted 8 hours or more before visit (1=yes, 0=no) |
|GlucoseIU | Blood glucose level in International Units |
|InsulinIU | Insulin level in International Units |
|LDL | Serum LDL cholesterol level |
|PrevalentCHD | Prevalent coronary heart disease (1=yes, 0=no) |
|Race | B for Black, W for White, A for Asian, I for American Indian |
|RoseIC | Intermittent claudication by Rose criteria (1=yes, 0=no) |
|TotCal | Total calorie intake in kcal/day |
|VisitDate | Date of visit |


The other four datasets are nutrition, measurements, medications_wide, and medications_long; variables from the remaining datasets are not listed here. 
The assignment was created by UNC BIOS Course - Working with Data in a Public Health Research Setting.
