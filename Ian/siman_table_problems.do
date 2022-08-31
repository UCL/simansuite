// Illustration of some problems with siman table
// siman_table_problems.do
// IW 28feb2022

siman which 

// 3 methods: get table format 1
use http://www.homepages.ucl.ac.uk/~rmjwiww/stata/misc/MIsim, clear
rename dataset myrep
siman setup, rep(myrep) method(method) est(b) se(se)
siman analyse

// 3 methods and 1 DGM: get table format 1
use http://www.homepages.ucl.ac.uk/~rmjwiww/stata/misc/MIsim, clear
rename dataset myrep
gen dgm=1
siman setup, rep(myrep) method(method) est(b) se(se) dgm(dgm)
siman analyse

// 3 methods and 1 target: get table format 2 (preferable in my view)
// but shouldn't be different from above
use http://www.homepages.ucl.ac.uk/~rmjwiww/stata/misc/MIsim, clear
rename dataset myrep
gen target=1
siman setup, rep(myrep) method(method) est(b) se(se) target(target)
siman analyse

// example of a good output when the default is poor
use C:\ado\ian\siman\Ian\test3, clear
keep if !null
gen true = log(or)
gen method = "ologit"
siman setup, rep(rep) dgm(pc or) est(b) se(se) true(true) method(method)
siman analyse, notable // default output is nasty
siman table, col(or) // nice output here, but it's given me column(or method) which is not what I asked for
