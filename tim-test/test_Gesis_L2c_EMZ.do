clear all
prog drop _all

use C:\git\siman\tim-test\estimates_L2c_built, clear
drop omega sigma

rename alpha estalpha
rename beta estbeta
rename alpha_se sealpha
rename beta_se sebeta

gen dgmnew = .
replace dgmnew = 0 if dgm=="DGM:common"
replace dgmnew = 1 if dgm=="DGM:fixed"
replace dgmnew = 2 if dgm=="DGM:random"
label define dgml 0 "common" 1 "fixed" 2 "random" 
label values dgmnew dgml  
*br dgm dgmnew
drop dgm
rename dgmnew dgm

siman setup , rep(id_rep) dgm(dgm) method(method) target(alpha beta) estimate(est) se(se)
siman reshape, longlong

* before Tim had:
* siman setup , rep(id_rep) dgm(dgm) method(method) estimate(alpha beta) se(alpha_se beta_se)

siman scatter
siman scatter, by(method)
siman scatter, by(target)
siman comparemethodsscatter
siman blandaltman
siman swarm
*siman zipplot: no true variable
siman analyse
siman lollyplot
*siman trellis: no true variable
* siman nestloop: not in nestloop format

clear all