*! version 1.4   14july2022
*  version 1.4   14july2022   EMZ. Corrected bug where mean bars were displaced downwards. Changed graph title so uses dgm label (not value) if exists.
*							  Fixed bug so name() allowed if user specifies.
*  version 1.3   17mar2022    EMZ. Suppressed "DGM=1" from graph titles if only one dgm.
*  version 1.2   06dec2021    EMZ changes (bug fix)
*  version 1.1   18dec2021    Ella Marley-Zagar, MRC Clinical Trials Unit at UCL. Based on Tim Morris' simulation tutorial do file.
* File to produce the siman swarm plot
******************************************************************************************************************************************************


capture program drop siman_swarm
program define siman_swarm, rclass
version 16

syntax [anything] [if][in] [, * MEANOFF MEANGRaphoptions(string) BY(varlist) BYGRaphoptions(string) GRAPHOPtions(string) COMBINEgraphoptions(string)]

foreach thing in `_dta[siman_allthings]' {
    local `thing' : char _dta[siman_`thing']
}

if "`simansetuprun'"!="1" {
	di as error "siman_setup needs to be run first."
	exit 498
	}

if "`method'"=="" & "`simansetuprun'"=="1" {
	di as error "The variable 'method' is missing so siman swarm can not be created.  Please create a variable in your dataset called method containing the method value(s)."
	exit 498
	}
	

* If data is not in long-long format, then reshape to get method labels
if `nformat'!=1 {
	qui siman reshape, longlong
		foreach thing in `_dta[siman_allthings]' {
		local `thing' : char _dta[siman_`thing']
	}
}

* if statistics are not specified, run graphs for estimate only, otherwise run for all that are specified
if "`anything'"=="" local varlist `estimate'
else foreach thing of local anything {
	local varelement = "`thing'"
	local varlist `varlist' `varelement'
	}


* if the user has not specified 'if' in the siman swarm syntax, but there is one from siman setup then use that 'if'
if ("`if'"=="" & "`ifsetup'"!="") local ifswarm = `"`ifsetup'"'
else local ifswarm = `"`if'"'
tempvar touseif
qui generate `touseif' = 0
qui replace `touseif' = 1 `ifswarm' 
preserve
sort `dgm' `target' `method' `touseif'
* The 'if' option will only apply to dgm, target and method.  The 'if' option is not allowed to be used on rep and an error message will be issued if the user tries to do so
capture by `dgm' `target' `method': assert `touseif'==`touseif'[_n-1] if _n>1
if _rc == 9 {
	di as error "The 'if' option can not be applied to 'rep' in siman_swarm."  
	exit 498
	}
restore
qui keep if `touseif'

* if the user has not specified 'in' in the siman swarm syntax, but there is one from siman setup then use that 'in'
if ("`in'"=="" & "`insetup'"!="") local inswarm = `"`insetup'"'
else local inswarm = `"`in'"'
tempvar tousein
qui gen `tousein' = 0
qui replace `tousein' = 1 `inswarm' 
qui keep if `tousein'

* Need to know number of dgms for later on
local numberdgms: word count `dgm'
if `numberdgms'==1 {
	qui tab `dgm'
	local ndgm = `r(r)'
}
if `numberdgms'!=1 local ndgm = `numberdgms'


if `nummethod' < 2 {
	di as error "There are not enough methods to compare, siman swarm requires at least 2 methods."
	exit 498
	}
	

* Need to know what format method is in (string or numeric) for the below code
local methodstringindi = 0
capture confirm string variable `method'
if !_rc local methodstringindi = 1


* Need labelsof package installed to extract method labels
qui capture which labelsof
if _rc {
	di as smcl  "labelsof package required, please kindly install by clicking: "  `"{stata ssc install labelsof}"'
	exit
} 

qui labelsof `method'
qui ret list

if "`r(labels)'"!="" {
	local 0 = `"`r(labels)'"'

	forvalues i = 1/`nummethod' {  
		gettoken mlabel`i' 0 : 0, parse(": ")
		if `i'==1 local mgraphlabels `mlabel`i''
		else if `i'>1 local mgraphlabels `mgraphlabels' `mlabel`i''
	}
}
else {
qui levels `method', local(levels)
tokenize `"`levels'"'
	
	if `methodstringindi'==0 {
	
		forvalues i = 1/`nummethod' {  
			local mlabel`i' "Method `i'"
			if `i'==1 local mgraphlabels `mlabel`i''
			else if `i'>1 local mgraphlabels `mgraphlabels' `mlabel`i''
		}
	}
	else if `methodstringindi'==1 {
	
		forvalues i = 1/`nummethod' {  
			local mlabel`i' "Method ``i''"
			if `i'==1 local mgraphlabels `"`mlabel`i''"'
			else if `i'>1 local mgraphlabels `mgraphlabels' `"`mlabel`i''"'
		}
		
	}
}


preserve
* keeps estimates data only
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


* If method is a string variable, need to encode it to numeric format for graphs 
if `methodstringindi'==1 {
	encode `method', generate(numericmethod)	
	drop `method'
	rename numericmethod method
	local method = "method"
	}

di as text "working....."

* For a nicer presentation and better better use of space
local nummethodminus1 = `nummethod'-1
local nummethodplus1 = `nummethod'+1


local maxrep = _N
forvalues g = 1/`nummethod' {
	local step = `maxrep'/`nummethodplus1'
	if `g'==1 qui gen newidrep = `rep' if `method' == `g'
	else qui replace newidrep = (`rep'-1)+ ceil((`g'-1)*`step') + 1 if `method' == `g'
	qui tabstat newidrep if `method' == `g', s(p50) save
	qui matrix list r(StatTotal) 
	local median`g' = r(StatTotal)[1,1]
	local ygraphvalue`g' = ceil(`median`g'')
	local labelvalues `labelvalues' `ygraphvalue`g'' "`mlabel`g''"
	if `g'==`nummethod' label define newidreplab `labelvalues'
}


* For the purposes of the graphs below, if dgm is missing in the dataset then set
* the number of dgms to be 1.
if "`dgm'"=="" local ndgm=1 

local dgmlabelindi=0
qui labelsof `dgm'
qui ret list
if !mi("`r(labels)'") local dgmlabelindi=1	

*create a variable with DGM = 'dgm' for use in the graphs if more than one dgm
* dgm has to be numerical as defined in siman setup
if `ndgm' != 1 { 
		tempvar dgmlabel
		if `dgmlabelindi'== 1 qui decode `dgm', gen(`dgmlabel')
		else qui gen `dgmlabel' = `dgm'
		tempvar dgmequals
		qui gen `dgmequals' = "DGM: "
		tempvar dgmtitle
		qui egen `dgmtitle' = concat(`dgmequals' `dgmlabel')
		if "`by'"=="" local by = "`dgmtitle'"


	foreach el in `varlist' {
		qui gen float mean`el' = .
			forvalues d = 1/`ndgm' {
				forval i = 1/`nummethod' {
				qui summ `el' if `method'==`i' & `dgm'==`d', meanonly
				qui replace mean`el' = r(mean) if `dgm'==`d' & newidrep== `ygraphvalue`i'' 
					}
				}

	if "`meanoff'"=="" {
		local graphname `graphname' `el'i
		local cmd twoway (scatter newidrep `el', ///
		msymbol(o) msize(small) mcolor(%30) mlc(white%1) mlwidth(vvvthin) `options')	///
		(scatter newidrep mean`el', msym(|) msize(huge) mcol(orange) `meangraphoptions')	///
		, ///
		by(`by', title("") cols(1) note("") xrescale legend(off) `bygraphoptions')	///
		ytitle("") ylabel(`labelvalues', nogrid labsize(medium) angle(horizontal)) `graphoptions'	///
		name(`el'i, replace) nodraw	
	}
	else {
	local graphname `graphname' `el'i
		local cmd twoway (scatter newidrep `el', ///
		msymbol(o) msize(small) mcolor(%30) mlc(white%1) mlwidth(vvvthin) `options')	///
		, ///
		by(`by', title("") cols(1) note("") xrescale legend(off) `bygraphoptions')	///
		ytitle("") ylabel(`labelvalues', nogrid labsize(medium) angle(horizontal)) `graphoptions'	///
		name(`el'i, replace) nodraw
		}
	}
}
* else create graphs without 'by' option as 'by' is for dgm only
else {
	foreach el in `varlist' {
		qui gen float mean`el' = .
				forval i = 1/`nummethod' {
				qui summ `el' if `method'==`i', meanonly
				qui replace mean`el' = r(mean) if newidrep== `ygraphvalue`i''
				}

	if "`meanoff'"=="" {
		local graphname `graphname' `el'i
		local cmd twoway (scatter newidrep `el', ///
		msymbol(o) msize(small) mcolor(%30) mlc(white%1) mlwidth(vvvthin) `options')	///
		(scatter newidrep mean`el', msym(|) msize(huge) mcol(orange) `meangraphoptions')	///
		, ///
		ytitle("") ylabel(`labelvalues', nogrid labsize(medium) angle(horizontal)) `graphoptions'	///
		name(`el'i, replace) nodraw	
	}
	else {
	local graphname `graphname' `el'i
		local cmd twoway (scatter newidrep `el', ///
		msymbol(o) msize(small) mcolor(%30) mlc(white%1) mlwidth(vvvthin) `options')	///
		, ///
		ytitle("") ylabel(`labelvalues', nogrid labsize(medium) angle(horizontal)) `graphoptions'	///
		name(`el'i, replace) nodraw
		}
	}
}

qui `cmd'
* global F9 `cmd'

local name = "name(simanswarm, replace)"

if !mi(`"`maingraphoptions'"') {
	* Can't tokenize/substr as many "" in the string
	tempvar _namestring
	qui gen `_namestring' = `"`maingraphoptions'"'
	qui split `_namestring',  parse(`"name"')
	local options = `_namestring'1
	local namestring = `_namestring'2
	local name = `"name`namestring'"'
}

graph combine `graphname', xsize(7) iscale(*1.5) `combinegraphoptions'

restore

end


