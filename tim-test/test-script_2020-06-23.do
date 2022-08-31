* Test of siman on estimates data from mi of ratios paper 
* Tim Morris 23jun2020

use ratios_estimates , clear
cd ..

gen float se = sqrt(var)

simsum b, id(repno) true(btrue) se(se) df(df) method(method) by(cva2 r2 missmech) mcse saving(tim-test/simsumresult, replace)

* siman setup - worked first time!
siman setup , r(repno) dgm(cva2 r2 missmech) method(method) estimate(b) se(se) df(df) true(btrue)
* Echo result of siman setup
siman describe

* Analyse simulated data
siman analyse
* Echo result of siman analyse
siman table

save tim-test/siman-dataset, replace
