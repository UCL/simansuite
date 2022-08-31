/*
Ian's testing: 1st data set
Updated 17/2/2022
Updated 22/12/2021
In due course, remove all the "cap noi"s and make this a test file
*/

prog drop _all

use http://www.homepages.ucl.ac.uk/~rmjwiww/stata/misc/MIsim, clear
cap noi siman setup, rep(dataset) method(method) 
rename dataset myrep
siman setup, rep(myrep) method(method) 
cap noi siman analyse // WANT BETTER ERROR MESSAGE

use http://www.homepages.ucl.ac.uk/~rmjwiww/stata/misc/MIsim, clear
rename dataset myrep
siman setup, rep(myrep) method(method) est(b) se(se)
siman analyse
* check
assert b==float(94.6) if perfmeascode=="power" & method=="CC"

use http://www.homepages.ucl.ac.uk/~rmjwiww/stata/misc/MIsim, clear
rename dataset rep
gen mydgm=1
siman setup, rep(rep) method(method) dgm(mydgm) est(b) se(se) true(0.5)
siman analyse
* check
assert b==float(94.6) if perfmeascode=="power" & method=="CC"

cap noi siman table if pe=="power" 
siman table power
siman table if mydgm==1
cap noi siman table if mydgm==2
assert _rc==2000

// START GRAPHICS

siman scatter, bygr(row(1) title(My graph)) ytitle(Point estimate)

siman comparemethodsscatter // graph looks really strange

siman swarm, xtitle(Point est) title(My simulation)

siman blandaltman
siman table power // i keep doing this to check the data haven't been changed

siman zipplot, bygr(row(1) title(My sim))

* lollyplot rquires dgm named dgm
use http://www.homepages.ucl.ac.uk/~rmjwiww/stata/misc/MIsim, clear
rename dataset rep
gen dgm=1
siman setup, rep(rep) method(method) dgm(dgm) est(b) se(se) true(0.5)
siman analyse
siman lollyplot bias 

siman nestloop power

siman trellis power

siman table power
assert b==float(94.6) if perfmeascode=="power" & method=="CC"

*** END OF TESTING1.DO ***
