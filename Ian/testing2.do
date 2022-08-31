* Ian's testing
* 2nd data set
* to Ella by 26/6/2020
* data test2 is a copy of Ian's "N:\Home\Design\Sample size\artcat\sim\eval1_postfile.dta"
prog drop _all

use test2, clear
gen method = "Wald"
siman setup, rep(i) dgm(or n) est(b) se(se) meth(m)

* should I be able to add a true() value now?

cap noi siman analyse
* doesn't display the information that simsum does

cap noi simsum b, id(i) meth(method) by(or n)

cap noi siman analyse, dropbig
* discuss: what to do about outliers?

replace b = . if b>10
* my quick fix

cap noi siman analyse
* got there! 
