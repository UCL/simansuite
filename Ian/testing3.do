* Ian's testing
* 3rd data set
* to Ella by 26/6/2020
prog drop _all
/* making the test3 file:
cd "N:\Home\Design\Sample size\artcat\sim"
myadopath simrun
simcombine, settings(simsettings) program(eval2mysim) genid(rep)
keep if rep<=1000
label data "artcat sim eval2 (1% sample) to test siman"
save C:\ado\ian\siman\Ian\test3, replace
*/
use C:\ado\ian\siman\Ian\test3, clear
* this is a sim to evaluate power 
* b, se imply Wald test; also p_lr for LRT

* let's first look at estimation
gen true = log(cond(null,1,or))
gen method = "ologit"
siman setup, rep(rep) dgm(pc null or) est(b) se(se) true(true) method(method)
* output "The number of dgms is: 3" is wrong
* 	actually 28 dgms
siman ana, notable
* need to drop unwanted output
siman table if null, col(or)
siman table if !null, col(or)

* now playing with reshape
siman reshape, longlong
siman analyse, replace notable
siman reshape, longwide
siman analyse, replace notable
* discuss: do we want the reshape output (a) on reshape (b) on analyse?


* now compare powers of methods
use C:\ado\ian\siman\Ian\test3, clear
* can I get wald test automatically instead of the following?
gen p_wald = chi2tail(1,(b/se)^2)

siman setup, rep(rep) dgm(pc null or) method(wald lr) p(p)
* p(p) and p(p_) both seem to work - why?

cap noi siman ana
* seems to be wrongly picking up an N/A 


use C:\ado\ian\siman\Ian\test3, clear
* now doing a really silly thing
gen p_wald = chi2tail(1,(b/se)^2)
cap noi siman setup, rep(rep) dgm(pc null or) method(wald lr) p(p) est(b) se(se)
* p and b weren't balanced - can this be picked up?
