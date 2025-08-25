%LET job=ADSB;
%LET onyen=jyc85;
%LET outdir=/home/u63543840/BIOS669;

proc printto log="&outdir/Logs/&job._&onyen..log" new; run; 

*********************************************************************
*  Assignment:    ADSB                    
*                                                                    
*  Description:   Analysis Data Sets Part II
*
*  Name:          Joyce Choe
*
*  Date:          2/27/2024                                   
*------------------------------------------------------------------- 
*  Job name:      ADSB_jyc85.sas   
*
*  Purpose:       Check derived variables according to specifications  
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         ADSB data set 
*
*  Output:        PDF file    
*                                                                    
********************************************************************;
OPTIONS nodate mergenoby=warn varinitchk=warn nofullstimer;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";

libname lib "~/BIOS669/Data";

ODS PDF FILE="&outdir/Output/&job._&onyen..PDF" STYLE=JOURNAL;


/* 1 - EmpStatus (character) */
title '"EmpStatus" check';
proc freq data=lib.ADSB;
	ods noproctitle;
	table HOM55*EmpStatus / missing list;
run;

/* 2 - DietMg_Group (numeric) */
title '"DietMg_Group" check';
proc means data=lib.ADSB n nmiss mean min max;
	class DietMg_Group / missing;
	var DietMg;
run;


/* 3 - AdjGlucose (numeric) */
* AdjGlucose = CHMX07; 
title2 'These are records from after July 15, 1988 or missing(BLOODDRAWDATE) when AdjGlucose should equal CHMX07';
proc print data=lib.ADSB(obs=10);
    where blooddrawdate>'15JUL1988'd or missing(BLOODDRAWDATE);
    var blooddrawdate chmx07 adjglucose;
    format blooddrawdate date9.;
run;

* AdjGlucose = CHMX07*0.963; 
title2 'These are records from on or before July 15, 1988, when AdjGlucose should equal CHMX07*0.963';
proc print data=lib.ADSB(obs=10);
    where blooddrawdate<='15JUL1988'd and ^missing(BLOODDRAWDATE);
    var blooddrawdate chmx07 adjglucose;
    format blooddrawdate date9.;
run;


* 4 - CHD (numeric);
* Continous variable based on ordinal variables;
title '"CHD"=0 if PrevalentCHD=0 and RoseIC=0 and HOM10D=N';
title2 '"CHD"=1 if PrevalentCHD=1, RoseIC=1, or HOM10D=Y'; 
title3 '"CHD"=missing(.) otherwise';
proc freq data=lib.ADSB;
		table CHD*PrevalentCHD*RoseIC*HOM10D / missing list nocum nopercent; 
run;

title;
title2;
title3;

/* 5 - Ethanol (numeric) */

title '#5. Check Ethanol';

* step 1-- check DRINKER ^=1; 
title2 'Ethanol should be missing if Drinker is not 1 2 or 3, 0 if Drinker is 2 or 3, a calculated value if Drinker is 1';
proc means data=lib.ADSB n nmiss mean min max maxdec=1;
    class drinker / missing;
    var ethanol;
run;

* step 2 -- ethanol derivation where DRINKER=1 is a linear model;
title2 'PROC REG check of Ethanol where Drinker = 1';
title3 'Model: Y = DTIA96*10.8 + DTIA97*13.2 + DTIA98*15.1';
proc reg data=lib.ADSB;
    where drinker=1;
    model ethanol = dtia96 dtia97 dtia98 / noint;
run; quit;

* step 2 cont'd. -- check DRINKER=1 where not missing DTIA96-98;
title2 'Ethanol mean = (DTIA96 mean*10.8) + (DTIA97 mean*13.2) + (DTIA98 mean*15.1)';
proc means data=lib.ADSB (where=(drinker=1 AND 
                                    dtia96 IS NOT MISSING AND
                                    dtia97 IS NOT MISSING AND
                                    dtia98 IS NOT MISSING)) mean;
    		var ethanol dtia96 dtia97 dtia98;
run;

* step 3 -- check DRINKER=1 where missing DTIA96-98;
title3 'Ethanol should be missing if any of DTIA96-98 are missing when Drinker=1';
proc mi data=lib.ADSB nimpute=0;
    where drinker=1;
    class drinker;
    var drinker dtia96 dtia97 dtia98 ethanol;
    fcs;
run;
title; 


/* 6 - LowBP (numeric) */
* Indicator for continous variable;

* format for indicator;
proc format;
    value age  
    	  low-60='<=60' 
    	  60<-high='>60';
run;

options nolabel;
title 'Check LowBP by Age';
proc means data=lib.ADSB N nmiss min max maxdec=0;
    class gender age lowbp / missing;
    var dbp;
    format age age.;
run;
title;
options label;


ODS PDF CLOSE;

proc printto; run; 