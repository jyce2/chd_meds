%LET job=ADSA1;
%LET onyen=jyc85;
%LET outdir=/home/u63543840/BIOS669;

proc printto log="&outdir/Logs/&job._&onyen..log" new; run; 

*********************************************************************
*  Assignment:    ADSA                       
*                                                                    
*  Description:   Analysis Data Sets, Steps 1-3 (Program 1 of 2)
*
*  Name:          Joyce Choe
*
*  Date:          2/23/2024                                     
*------------------------------------------------------------------- 
*  Job name:      ADSA1_jyc85.sas   
*
*  Purpose:       1. Create two (indicator) variables
*			         and keep ID, diuretic, and lipid lowering medications
*					 in dataset
*			 	  2. Combine core, nutrition, measurements, 
*					 and medication data sets
*				  3. Subset final data set to manuscript specifications
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         CHD > medications_wide, core, nutrition, measurements
*
*  Output:        PDF file    
*                                                                    
********************************************************************;
OPTIONS nodate mergenoby=warn varinitchk=warn nofullstimer;
libname lib "~/BIOS669/Data";
ODS PDF FILE="&outdir/Output/&job._&onyen..PDF" STYLE=JOURNAL;


title 'Coronary Heart Disease Patient Medications Dataset';
proc contents data=lib.var_medications_wide;
run;
title;

/* Step 1 - Define Diuretic and LipidLowerMed indicator variables in medications_wide dataset */
**************************************************************************************************;
data meds;
	set lib.var_medications_wide; 
	Diuretic=0; 							 				/* initalize values */
	LipidLowerMed=0; 
	array drugcode{17} drugcode1-drugcode17; 				/* character array with 17 indices */
		do i=1 to 17;			
			if '370000' <= drugcode{i} <= '380000' then Diuretic = 1;
			if drugcode{i} IN ('390000', '391000', '240600') then LipidLowerMed = 1; 
		end;
	label Diuretic = 'Taking a diuretic medication'
		  LipidLowerMed = 'Taking a lipid-lowering medication';
	drop i;
run;

* 1.1 - Quality check;
title2 'Diuretic=1 (370000 - 380000 for any drugcode)';
proc print data=meds(obs=10);
    where diuretic=1;
run;

title2 'Diuretic=0 (not 370000 - 380000 for any drugcode)';
proc print data=meds(obs=10);
    where diuretic=0;
run;

title2 'LipidLowerMed=1 (390000, 391000, 240600 for any drugcode)';
proc print data=meds(obs=10);
    where lipidlowermed=1;
run;

title2 'LipidLowerMed=0 (not 390000, 391000, 240600 for any drugcode)';
proc print data=meds(obs=10);
    where lipidlowermed=0;
run;

/* Check counts */
title 'Check Diuretic & LipidLowerMed in meds dataset';
proc freq data=meds;
	table Diuretic / missing;
	table LipidLowerMed / missing;
	table Diuretic*LipidLowerMed / missing nocum norow nocol;
run;

/* Keep only necessary indicator variables and save in temporary dataset */ 
proc sort data=meds1(keep=id diuretic lipidlowermed) 
		  out=lib.meds(label="Step 1: Meds dataset made from medications_wide"); 
    by id; 
run;  

/* Step 2 - Combine data sets to form one record per person by patient ID */
**********************************************************************************************;
data lib.chd_record(label="Step 2: Combined data set before making exclusions");
    merge lib.chd_core(in=incore) 
          lib.chd_nutrition(rename=(Magnesium=DietMg))
          lib.chd_measurements(rename=(Magnesium=SerumMg))
          lib.meds(in=inmed);
    by id; 								/*primary key*/
    if incore;							/*keep IDs only in chd_core*/
    									
    if ^inmed then do; 					/*If a person has no record in meds dataset, then that person was taking no 
										medication at all -> set Diuretic & LipidLowerMed to 0 */			
        Diuretic = 0;
        LipidLowerMed = 0;
        
    end;
run;

* 2.1 - Quality check;
title2 'Check contents of data set (keep IDs in core data set)';
proc contents data=lib.chd_record;
run;

title2 'Check Diuretic and LipidLowerMed in combined data set';
proc freq data=lib.chd_record;
    tables diuretic lipidlowermed / missing;
run;
title;



/* Step 3 - Subset data set based on manuscript criteria. */
*******************************************************************************************;
data chd_subset;
	set chd_records;
	where ^missing(BMI) and ^missing(SerumMg) and ^missing(DietMg);
	if Race in ('B', 'W') AND
	(Gender = 'F' and 500 < TotCal < 3600) OR
	(Gender = 'M' and 600 < TotCal < 4200);	
run;

* 3.1 - Quality check;
title2 'Check contents of final subset';
proc contents data=chd_subset;
run;
title2;

title2 'Frequencies: race & gender in final subset';
proc freq data=chd_subset;
	table Race / missing;
	table Gender / missing;
run;
title2;

title2 'Descriptive statistics: totcal, bmi, dietmg, serummg';
proc means data=chd_subset nmiss mean min max maxdec=1;
    var totcal bmi dietmg serummg;
run;
title;

ODS PDF CLOSE;

proc printto; run; 