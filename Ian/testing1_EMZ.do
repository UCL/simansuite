/*
Ian's testing: 1st data set
Updated 22/12/2021
In due course, remove all the "cap noi"s and make this a test file
* Ella updated 06/01/2021 after chanages made from IW testing
*/


prog drop _all
clear all


use http://www.homepages.ucl.ac.uk/~rmjwiww/stata/misc/MIsim, clear
*use "\\ad.ucl.ac.uk\home1\rmjlem1\DesktopSettings\Desktop\misim.dta", clear
rename dataset rep

cd C:\git\siman

siman setup, rep(rep) method(method) est(b) se(se) true(0.5)

siman analyse
* clarify 2nd entry is MC error
* clarify cover power relerror relprec are %s (just add "%" in the value label)

siman table power

siman scatter // ok

siman comparemethodsscatter // ok now

siman swarm // ok now
siman table power 


cap noi siman blandaltman // ok now
siman table power 

cap noi siman zipplot // ok now
siman table power 


cap noi siman lollyplot bias // ok now, used colours
siman table power 

cap noi siman nestloop  // makes graphs ok, but looks strange because of data.

cap noi siman trellis // makes graphs ok, but looks strange as only 1 true value.


cap noi siman table power

*** END OF TESTING1.DO ***
