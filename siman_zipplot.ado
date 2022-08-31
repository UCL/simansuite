*! version 1.6   14july2022
*  version 1.6   14july2022  EMZ fixed bug so name() allowed in call
*  version 1.5   30june2022  EMZ fixed bug where axis crosses
*  version 1.4   24mar2022   EMZ changes (suppress DGM=1 if no DGM/only 1 DGM)
*  version 1.3   02mar2022   EMZ changes from IW further testing
*  version 1.2   06jan2021   EMZ updates from IW testing (bug fixes)
*  version 1.1   25Jan2021   Ella Marley-Zagar, MRC Clinical Trials Unit at UCL. Based on Tim Morris' simulation tutorial do file.
* File to produce the zip plot
*******************************************************************************************************************************************************

capture program drop siman_zipplot
program define siman_zipplot, rclass
version 15

syntax [if][in] [,* BY(varlist) ///
                    NONCOVeroptions(string) COVeroptions(string) SCAtteroptions(string) TRUEGRaphoptions(string) BYGRaphoptions(string) ///
					SCHeme(string)]

foreach thing in `_dta[siman_allthings]' {
    local `thing' : char _dta[siman_`thing']
}

if "`simansetuprun'"!="1" {
	di as error "siman_setup needs to be run first."
	exit 498
	}

* if true is missing, produce an error message
if "`true'"=="" {
	di as error "The variable 'true' is missing so siman zipplot can not be created.  Please create a variable in your dataset called true containing the true value(s)."
	exit 498
	}


* If data is not in long-long format, then reshape
if `nformat'!=1 {
	qui siman reshape, longlong
		foreach thing in `_dta[siman_allthings]' {
		local `thing' : char _dta[siman_`thing']
	}
}


* if the user has not specified 'if' in the siman zipplot syntax, but there is one from siman setup then use that 'if'
if ("`if'"=="" & "`ifsetup'"!="") local ifzipplot = `"`ifsetup'"'
else local ifzipplot = `"`if'"'
qui tempvar touseif
qui generate `touseif' = 0
qui replace `touseif' = 1 `ifzipplot' 
preserve
qui sort `dgm' `target' `method' `touseif'
* The 'if' option will only apply to dgm, target and method.  The 'if' option is not allowed to be used on rep and an error message will be issued if the user tries to do so
capture by `dgm' `target' `method': assert `touseif'==`touseif'[_n-1] if _n>1
if _rc == 9 {
	di as error "The 'if' option can not be applied to 'rep' in siman_zipplot."  
	exit 498
	}
restore
qui keep if `touseif'

* if the user has not specified 'in' in the siman zipplot syntax, but there is one from siman setup then use that 'in'
if ("`in'"=="" & "`insetup'"!="") local inzipplot = `"`insetup'"'
else local inzipplot = `"`in'"'
qui tempvar tousein
qui generate `tousein' = 0
qui replace `tousein' = 1 `inzipplot' 
qui keep if `tousein'


preserve
* keep estimates data only
qui drop if `rep'<0

* take out underscores at the end of variable names if there are any
		foreach u of var * {
			if  substr("`u'",strlen("`u'"),1)=="_" {
				local U = substr("`u'", 1, index("`u'","_") - 1)
					if "`U'" != "" {
					capture rename `u' `U' 
					if _rc di as txt "problem with `u'"
				} 
			}
		}
		
if  substr("`estimate'",strlen("`estimate'"),1)=="_" local estimate = substr("`estimate'", 1, index("`estimate'","_") - 1)
if  substr("`se'",strlen("`se'"),1)=="_" local se = substr("`se'", 1, index("`se'","_") - 1)

* Zip plot of confidence intervals

capture confirm variable `lci'
if _rc {
		qui gen float lci = `estimate' + (`se'*invnorm(.025))
		local lci lci
		}
capture confirm variable `uci'
if _rc {
		qui gen float uci = `estimate' + (`se'*invnorm(.975))
		local uci uci
	}
	

if "`method'"!="" {

* for value labels of method
	qui tab `method'
	local nmethodlabels = `r(r)'
	
	qui levels `method', local(levels)
	tokenize `"`levels'"'
		}
		
		
if "`target'"!="" {

* for value labels of target
	qui tab `target'
	local ntargetlabels = `r(r)'
	
	qui levels `target', local(levels)
	tokenize `"`levels'"'
		forvalues k = 1/`ntargetlabels' { 
		    local targetlabel`k' "``k''"
		}
}

capture confirm number `true'
if _rc {
	if "`true'"!="" {
		qui tab `true'
		local ntrue = `r(r)'
			if `r(r)'==1 {
				qui levelsof `true', local(levels)   
				local truevalue = `r(levels)'
			}
			else if `r(r)'>1 {
				forvalues k = 1/`ntargetlabels' { 
					qui levelsof `true' if `target' == "``k''", local(levels)
					local truevalue`k' = `r(levels)'
				
				}
			}
	}
}
else {
	local ntrue = 1
	local truevalue = `true'
}

local numberdgms: word count `dgm'
if `numberdgms'==1 {
	qui tab `dgm'
	local ndgmlabels = `r(r)'
}
if `numberdgms'!=1 local ndgmlabels = `numberdgms'

* set default nesting using 'by' if user has not specified
if "`by'"=="" & `ntrue'==1 & `ndgmlabels' > 1 local by `dgm' `method'
if "`by'"=="" & `ntrue'==1 & `ndgmlabels' == 1 & !mi("`method'") local by `method'
if "`by'"=="" & `ntrue'==1 & `ndgmlabels' == 1 & mi("`method'") local by `dgm'
if "`by'"=="" & `ntrue'>1 & `ndgmlabels' > 1 local by `dgm' `target' `method'
if "`by'"=="" & `ntrue'>1 & `ndgmlabels' == 1 local by `target' `method'

 
* For coverage (or type I error), use true θ for null value
* so p<=.05 is a non-covering interval
capture confirm variable p`estimate'
	if _rc {
		qui gen float p`estimate' = 1-normal(abs(`estimate'-`true')/`se') // if sim outputs df, use ttail and remove '1-'
		}
capture confirm variable covers 
	if _rc {
		qui gen byte covers = p`estimate' > .025  // binary indicator of whether ci covers true estimate
		}		
sort `by' p`estimate'
capture confirm variable p`estimate'rank
	if _rc {
			qui by `by': gen double p`estimate'rank = 100 - (_n/(_N/100)) // scale from 0-100. This will be vertical axis.
		}

* Create MC conf. int. for coverage
capture confirm variable covlb
	if _rc {
		qui gen float covlb = .
		}
capture confirm variable covub
	if _rc {
		qui gen float covub = .
		}
		

* Need to know what format method is in (string or numeric) for the below code
local methodstringindi = 0
capture confirm string variable `method'
if !_rc local methodstringindi = 1

if `ntrue'==1 {		
	forvalues d = 1/`ndgm' {   
		if "`nmethodlabels'"! = "" forvalues j = 1/`nmethodlabels' {                                               
*			di as text "DGM = " as result `d' as text ", method = " as result "``j''"
			if `methodstringindi'==0 {
				qui ci proportions covers if `dgm'==`d' & `method'==`j'
				qui replace covlb = 100*(r(lb)) if `dgm'==`d' & `method'==`j'
				qui replace covub = 100*(r(ub)) if `dgm'==`d' & `method'==`j'
			} 
			else if `methodstringindi'==1 {
				qui ci proportions covers if `dgm'==`d' & `method'=="`j'"
				qui replace covlb = 100*(r(lb)) if `dgm'==`d' & `method'=="`j'"
				qui replace covub = 100*(r(ub)) if `dgm'==`d' & `method'=="`j'"
			} 
		}
	}
}
else if `ntrue'>1 {
		forvalues d = 1/`ndgm' {   
		if "`nmethodlabels'"! = "" forvalues j = 1/`nmethodlabels' {  
			forvalues k = 1/`ntargetlabels' { 
				if `methodstringindi'==0 {
					qui ci proportions covers if `dgm'==`d' & `method'==`j' & `target'=="`k'"
					qui replace covlb = 100*(r(lb)) if `dgm'==`d' & `method'==`j' & `target'=="`k'"
					qui replace covub = 100*(r(ub)) if `dgm'==`d' & `method'==`j' & `target'=="`k'"
				} 
				else if `methodstringindi'==1 {
					qui ci proportions covers if `dgm'==`d' & `method'=="`j'" & `target'=="`k'"
					qui replace covlb = 100*(r(lb)) if `dgm'==`d' & `method'=="`j'" & `target'=="`k'"
					qui replace covub = 100*(r(ub)) if `dgm'==`d' & `method'=="`j'" & `target'=="`k'"
				} 
			}
		}
	}
}


qui bysort `by': replace covlb = . if _n>1
qui bysort `by' : replace covub = . if _n>1

capture confirm variable lpoint
	if _rc {
		qui gen float lpoint = -1.5 if !missing(covlb)
		}
capture confirm variable rpoint
	if _rc {
		qui gen float rpoint =  1.5 if !missing(covlb)
		}	
	

* Create column data that has "DGM=..." and "Method=..." to use in the graphs 
* so that graph titles look tidy.
if "`dgm'"!="" & `ndgmlabels'>1 & (substr("`dgm'",1,strlen("`dgm'"))!="dgm" | substr("`dgm'",1,strlen("`dgm'"))!="DGM") {
	qui gen `dgm'graph = "DGM= "
	capture confirm string variable `dgm'
		if _rc {
			qui tostring(`dgm'), gen(`dgm'string)
			qui gen `dgm'graphtitle = `dgm'graph + `dgm'string
			qui drop `dgm'string
			}
		else gen `dgm'graphtitle = `dgm'graph + `dgm'
	qui drop `dgm'graph
 }
 
 if "`target'"!="" & (substr("`target'",1,strlen("`target'"))!="target" | substr("`target'",1,strlen("`target'"))!="TARGET") {
	qui gen `target'graph = "TARGET= "
	capture confirm string variable `target'
		if _rc {
			qui tostring(`target'), gen(`target'string)
			qui gen `target'graphtitle = `target'graph + `target'string
			qui drop `target'string
			}
		else gen `target'graphtitle = `target'graph + `target'
	qui drop `target'graph
 }
 
 if "`method'"!="" & (substr("`method'",1,strlen("`method'"))!="method" | substr("`method'",1,strlen("`method'"))!="METHOD") {
	qui gen `method'graph = "Method= "
	if `methodstringindi'==0 {
			qui tostring(`method'), gen(`method'string)
			qui gen `method'graphtitle = `method'graph + `method'string
			qui drop `method'string
			}
		else gen `method'graphtitle = `method'graph + `method'
	qui drop `method'graph
 }
 

 foreach b in `by' {
 	local `b'graphtitle = "`b'graphtitle"
    local bygraphtitlelist `bygraphtitlelist' `b'graphtitle
	}

local name = "simanzipplot"

* Can't tokenize/substr as many "" in the string
if !mi(`"`options'"') {
	tempvar _namestring
	qui gen `_namestring' = `"`options'"'
	qui split `_namestring',  parse(`"name"')
	local options = `_namestring'1
	cap confirm var `_namestring'2
	if !_rc {
		local namestring = `_namestring'2
		local name = `namestring'
	}
}
		
* Plot of confidence interval coverage:
* First two rspike plots: Monte Carlo confidence interval for percent coverage
* second two rspike plots: confidence intervals for individual reps
* blue intervals cover, purple do not
* scatter plot (white dots) are point estimates - probably unnecessary

if "`by'" == "dgm" & `ndgmlabels' == 1 {
	#delimit ;
	twoway (rspike lpoint rpoint covlb, hor lw(thin) pstyle(p5)) // MC 
		(rspike lpoint rpoint covub, hor lw(thin) pstyle(p5))
		(rspike `lci' `uci' p`estimate'rank if !covers, hor lw(medium) pstyle(p2) lcol(%30) `noncoveroptions')
		(rspike `lci' `uci' p`estimate'rank if covers, hor lw(medium) pstyle(p1) lcol(%30) `coveroptions')
		(scatter p`estimate'rank `estimate', msym(p) mcol(white%30) `scatteroptions') // plots point estimates in white
		(pci 0 `truevalue' 100 `truevalue', pstyle(p5) lw(thin) `truegraphoptions')
		,
		name(`name', replace)
		xtit("95% confidence intervals")
		ytit("Centile of ranked p-values for null: θ=`truevalue'")  
		ylab(5 50 95)
		scale(.8)
		legend(order(4 "Coverers" 3 "Non-coverers") rows(1))
		xsize(4) `scheme'
		`options'
		;
	#delimit cr
	
}	
	
else if `ntrue'==1 {
	#delimit ;
	twoway (rspike lpoint rpoint covlb, hor lw(thin) pstyle(p5)) // MC 
		(rspike lpoint rpoint covub, hor lw(thin) pstyle(p5))
		(rspike `lci' `uci' p`estimate'rank if !covers, hor lw(medium) pstyle(p2) lcol(%30) `noncoveroptions')	
		(rspike `lci' `uci' p`estimate'rank if covers, hor lw(medium) pstyle(p1) lcol(%30) `coveroptions')
		(scatter p`estimate'rank `estimate', msym(p) mcol(white%30) `scatteroptions') // plots point estimates in white
		(pci 0 `truevalue' 100 `truevalue', pstyle(p5) lw(thin) `truegraphoptions')
		,
		name(`name', replace)
		xtit("95% confidence intervals")
		ytit("Centile of ranked p-values for null: θ=`truevalue'")  
		ylab(5 50 95)
		by(`bygraphtitlelist', note("") noxrescale iscale(*.8) `bygraphoptions') scale(.8)
		legend(order(4 "Coverers" 3 "Non-coverers") rows(1))
		xsize(4) `scheme'
		`options'
		;
	#delimit cr
}
else if `ntrue'>1 {                            
	local except "`target'graphtitle"
	local bygraphtitlelist: list bygraphtitlelist - except
	forvalues k = 1/`ntargetlabels' { 
		#delimit ;
		twoway (rspike lpoint rpoint covlb, hor lw(thin) pstyle(p5)) // MC 
			(rspike lpoint rpoint covub, hor lw(thin) pstyle(p5))
			(rspike `lci' `uci' p`estimate'rank if !covers, hor lw(medium) pstyle(p2) lcol(%30) `noncoveroptions')
			(rspike `lci' `uci' p`estimate'rank if covers, hor lw(medium) pstyle(p1) lcol(%30) `coveroptions')
			(scatter p`estimate'rank `estimate', msym(p) mcol(white%30) `scatteroptions') // plots point estimates in white
			(pci 0 `truevalue`k'' 100 `truevalue`k'', pstyle(p5) lw(thin) `truegraphoptions')
			,
			name(`name'_target_`targetlabel`k'', replace)
			xtit("95% confidence intervals")
			ytit("Centile of ranked p-values for null: θ=`truevalue`k''")  
			ylab(5 50 95)
			by(`bygraphtitlelist', note("") noxrescale iscale(*.8) `bygraphoptions') scale(.8)
			legend(order(4 "Coverers" 3 "Non-coverers") rows(1))
			xsize(4) `scheme'
			`options'
			;
		#delimit cr
	}
}	
	
	


restore

end

*graph export zipplot.pdf, replace
