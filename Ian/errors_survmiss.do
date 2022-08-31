/*
Demonstrate errors using estimates data from survmiss study
The data are "wide-wide"
Data come from "N:\Home\MI\ICE\survmiss\sim\bvsim_all_out.dta" wth chars removed
errors_survmiss.do
IW 3mar2022
*/

local dgm n truebeta truegamma corr mdm 
use survmiss_bvsim_all_out, clear
rename (beta*) (estbeta*)
rename (gamma*) (estgamma*)
cap noi siman setup, rep(_dnum) dgm(`dgm') target(beta_ gamma_) method(1 2 3 4 5 6 7 8 9 10) estimate(est) se(se) true(true)
* strange error message
rename pmcar _pmcar
cap noi siman setup, rep(_dnum) dgm(`dgm') target(beta_ gamma_) method(1 2 3 4 5 6 7 8 9 10) estimate(est) se(se) true(true) order(target)
* above should be the syntax for true, but isn't
* command seems to have failed, but it's left stuff behind:
siman desc
cap noi siman analyse


* 2nd attempt, with true as current syntax requires
local dgm n truebeta truegamma corr mdm 
use survmiss_bvsim_all_out, clear
rename (beta*) (estbeta*)
rename (gamma*) (estgamma*)
rename pmcar _pmcar
forvalues i=1/10 {
	gen truebeta_`i'=truebeta
	gen truegamma_`i'=truegamma
}
cap noi siman setup, rep(_dnum) dgm(`dgm') target(beta_ gamma_) method(1 2 3 4 5 6 7 8 9 10) estimate(est) se(se) true(true) order(target)
siman des
