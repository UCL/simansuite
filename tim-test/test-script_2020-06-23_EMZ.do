* Test of siman on estimates data from mi of ratios paper 
* Tim Morris 23jun2020
clear all
prog drop _all
use C:\git\siman\tim-test\ratios_estimates , clear

gen float se = sqrt(var)

*simsum b, id(repno) true(btrue) se(se) df(df) method(method) by(cva2 r2 missmech) mcse 

* renaming method labels as have special characters in
gen methodnew = ""
replace methodnew = "completedata" if method==1
replace methodnew = "completecases" if method==2
replace methodnew = "x" if method==3
replace methodnew = "xasub1" if method==4
replace methodnew = "xasub2" if method==5
replace methodnew = "JAV" if method==6
replace methodnew = "asuv1asub2" if method==7
replace methodnew = "lnasuv1asub2" if method==8
br method methodnew
drop method
rename methodnew method

* need to drop var otherwise reshape will not work (as extra variable outside of siman setup)
drop var

* siman setup - worked first time!
siman setup , r(repno) dgm(cva2 r2 missmech) method(method) estimate(b) se(se) df(df) true(btrue)
* Echo result of siman setup
siman describe

siman scatter
* don't work with dgm defined as dgm(dgm1 dgm2 dgm3), would require separate coding
* siman swarm
* siman blandaltman
* siman comparemethodsscatter
* siman zipplot

* Analyse simulated data
siman analyse
* Echo result of siman analyse
siman table

clear all
