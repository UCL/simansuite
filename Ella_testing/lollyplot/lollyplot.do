version 15

prog drop _all
clear all

*cd C:\simcourse\tutorialpaper\example
cd N:\My_files\siman\simexample
use toplot, clear

* I'm going to create separate plots then graph combine.
* Gulp. Wish me luck.
forval pm = 1/7 {
//local pm 1
	local if & pm==`pm'
	if !inlist(`pm',4,6) {
		local refline
		local rescale noxrescale
	}
	else {
		local refline (line method ref if pm==`pm', lc(gs8))
		local rescale xrescale
	}
	local scatters (scatter method theta if method==1 `if', mlab(thelab) mlabpos(1) mcol(black) mlabcol(black) msym(o)) (scatter method theta if method==2 `if', mlab(thelab) mlabpos(1) mcol(gs4) mlabcol(gs4) msym(o)) (scatter method theta if method==3 `if', mlab(thelab) mlabpos(1) mcol(gs8) mlabcol(gs8) msym(o))
	local spikes (rspike theta ref method if method==1 `if', lcol(black) hor) (rspike theta ref method if method==2 `if', lcol(gs4) hor) (rspike theta ref method if method==3 `if', lcol(gs8) hor)
	local bounds (scatter method lci if method==1 `if', msym(i) mlab(l) mlabpos(0) mlabcol(black)) (scatter method lci if method==2 `if', msym(i) mlab(l) mlabpos(0) mlabcol(gs4)) (scatter method lci if method==3 `if', msym(i) mlab(l) mlabpos(0) mlabcol(gs4)) (scatter method uci if method==1 `if', msym(i) mlab(r) mlabpos(0) mlabcol(black)) (scatter method uci if method==2 `if', msym(i) mlab(r) mlabpos(0) mlabcol(gs4)) (scatter method uci if method==3 `if', msym(i) mlab(r) mlabpos(0) mlabcol(gs8))
	if `pm'==1 {
		local ytit Bias
	}
	else if `pm'==2 {
		local ytit CI coverage
	}
	else if `pm'==3 {
		local ytit " "Bias-eliminated" "coverage" "
	}
	else if `pm'==4 {
		local ytit Empirical SE
	}
	else if `pm'==5 {
		local ytit " "Precision gain" "vs. Weibull (%)" "
	}
	else if `pm'==6 {
		local ytit Model SE
	}
	else if `pm'==7 {
		local ytit " "Relative error" "in model SE (%)" "
	}

	#delimit ;
	twoway
		`refline' `spikes' `bounds' `scatters'
		,
		by(dgm, `rescale' legend(off) note("") imargin(tiny)
			l1tit(`ytit', orientation(horizontal) width(21) justification(right))
		)
		subtitle("")
		ytit("")
		yla(0 4, val grid labc(white) labsize(*.1))
		xla(, grid)
		ysca(reverse)
		/*xline(`ref')
		*/name(g`pm', replace) nodraw
	;
	#delimit cr
}

#delimit ;
twoway (pci 1 -1 1 -.5, lcol(black))  (pci 2 -1 2 -.5, lcol(gs4)) (pci 3 -1 3 -.5, lcol(gs8)) ///
	(scatteri 1 -.5 (3) "Exponential", msym(o) mcol(black) mlabcol(black)) (scatteri 2 -.5 (3) "Weibull", msym(o) mcol(gs4) mlabcol(gs4)) (scatteri 3 -.5 (3) "Cox", msym(o) mcol(gs8) mlabcol(gs8))
	(scatteri 5 0 (0) "Data generation: γ=1", msym(i) mlabc(black)) (scatteri 5 2 (0) "Data generation: γ=1.5", msym(i) mlabc(black))
	,
	xla(none) yla(none)
	ysca(range(0 4) reverse)
	xsca(range(-1 3))
	l1tit(" ", orientation(horizontal) width(21))
	legend(off)
	scale(*1.2)
	name(g0, replace) nodraw
	;
#delimit cr

graph combine g0 g1 g2 g3 g4 g5 g6 g7, cols(1) xsize(3) imargin(zero) name(combined, replace)
graph export lollyplot.pdf, replace

/*
* This would be good but can't add pm-specific reference lines or make by() more sensible
#delimit ;
twoway
	(scatter method theta if method==1, pstyle(p1))
	(scatter method theta if method==2, pstyle(p2))
	(scatter method theta if method==3, pstyle(p3))
	(scatter method lci if method==1, pstyle(p1) msym(i) mlab(l) mlabpos(0))
	(scatter method lci if method==2, pstyle(p2) msym(i) mlab(l) mlabpos(0))
	(scatter method lci if method==3, pstyle(p3) msym(i) mlab(l) mlabpos(0))
	(scatter method uci if method==1, pstyle(p1) msym(i) mlab(r) mlabpos(0))
	(scatter method uci if method==2, pstyle(p2) msym(i) mlab(r) mlabpos(0))
	(scatter method uci if method==3, pstyle(p3) msym(i) mlab(r) mlabpos(0))
	,
	by(pm dgm , col(2) xrescale legend(pos(3)) note(""))
	legend(order(1 "Exponential" 2 "Weibull" 3 "Cox") cols(1))
	xtit("") ytit("")
	ylab(none)
	ysca(reverse)
	plotregion(lstyle(grid))
	xsize(3)
;
#delimit cr



/*
Taken the following code out of my siman_lollyplot.ado and run it in the same workspace as the
above.  Achieved exactly the same graphs as Tim.  Can't run siman_setup, analyse and
lollyplot on toplot.dta as already a performance measures dataset, and siman analyse changes
all the values.  So this is the only way I can compare siman lollyplot output with Tim's output.

bias
*****

graph twoway (rspike theta ref method if method==1 & pm==1 , lcol("scheme p1") hor) (rspike theta ref method if method==2 & pm==1 , lcol("scheme p2") hor) (rspike theta ref method if method==3 & pm==1 , lcol("scheme p3") hor) (scatter method lci if method==1 & pm==1 , msym(i) mlab(l) mlabpos(0) mcol("scheme p1") mlabcol("scheme p1")) (scatter method uci if method==1 & pm==1 , msym(i) mlab(r) mlabpos(0) mcol("scheme p1") mlabcol("scheme p1")) (scatter method lci if method==2 & pm==1 , msym(i) mlab(l) mlabpos(0) mcol("scheme p2") mlabcol("scheme p2")) (scatter method uci if method==2 & pm==1 , msym(i) mlab(r) mlabpos(0) mcol("scheme p2") mlabcol("scheme p2")) (scatter method lci if method==3 & pm==1 , msym(i) mlab(l) mlabpos(0) mcol("scheme p3") mlabcol("scheme p3")) (scatter method uci if method==3 & pm==1 , msym(i) mlab(r) mlabpos(0) mcol("scheme p3") mlabcol("scheme p3")) (scatter method theta if method==1 & pm==1 , mlab(thelab) mlabpos(1) mcol("scheme p1") mlabcol("scheme p1") msym(o)) (scatter method theta if method==2 & pm==1 , mlab(thelab) mlabpos(1) mcol("scheme p2") mlabcol("scheme p2") msym(o)) (scatter method theta if method==3 & pm==1 , mlab(thelab) mlabpos(1) mcol("scheme p3") mlabcol("scheme p3") msym(o)) , by(dgm, noxrescale legend(off) note("") imargin(tiny) l1tit("bias" "", orientation(horizontal) width(21) justification(right)) ) subtitle("") ytit("") yla(0 4, val grid labc(white) labsize(*.1)) xla(, grid) ysca(reverse) name(g1, replace) 

rmse
*****

graph twoway (rspike theta ref method if method==1 & pm==7 , lcol("scheme p1") hor) (rspike theta ref method if method==2 & pm==7 , lcol("scheme p2") hor) (rspike theta ref method if method==3 & pm==7 , lcol("scheme p3") hor) (scatter method lci if method==1 & pm==7 , msym(i) mlab(l) mlabpos(0) mcol("scheme p1") mlabcol("scheme p1")) (scatter method uci if method==1 & pm==7 , msym(i) mlab(r) mlabpos(0) mcol("scheme p1") mlabcol("scheme p1")) (scatter method lci if method==2 & pm==7 , msym(i) mlab(l) mlabpos(0) mcol("scheme p2") mlabcol("scheme p2")) (scatter method uci if method==2 & pm==7 , msym(i) mlab(r) mlabpos(0) mcol("scheme p2") mlabcol("scheme p2")) (scatter method lci if method==3 & pm==7 , msym(i) mlab(l) mlabpos(0) mcol("scheme p3") mlabcol("scheme p3")) (scatter method uci if method==3 & pm==7 , msym(i) mlab(r) mlabpos(0) mcol("scheme p3") mlabcol("scheme p3")) (scatter method theta if method==1 & pm==7 , mlab(thelab) mlabpos(1) mcol("scheme p1") mlabcol("scheme p1") msym(o)) (scatter method theta if method==2 & pm==7 , mlab(thelab) mlabpos(1) mcol("scheme p2") mlabcol("scheme p2") msym(o)) (scatter method theta if method==3 & pm==7 , mlab(thelab) mlabpos(1) mcol("scheme p3") mlabcol("scheme p3") msym(o)) , by(dgm, noxrescale legend(off) note("") imargin(tiny) l1tit("rmse" "", orientation(horizontal) width(21) justification(right)) ) subtitle("") ytit("") yla(0 4, val grid labc(white) labsize(*.1)) xla(, grid) ysca(reverse) name(g7, replace) 

empirical se
*************

graph twoway (rspike theta ref method if method==1 & pm==4 , lcol("scheme p1") hor) (rspike theta ref method if method==2 & pm==4 , lcol("scheme p2") hor) (rspike theta ref method if method==3 & pm==4 , lcol("scheme p3") hor) (scatter method lci if method==1 & pm==4 , msym(i) mlab(l) mlabpos(0) mcol("scheme p1") mlabcol("scheme p1")) (scatter method uci if method==1 & pm==4 , msym(i) mlab(r) mlabpos(0) mcol("scheme p1") mlabcol("scheme p1")) (scatter method lci if method==2 & pm==4 , msym(i) mlab(l) mlabpos(0) mcol("scheme p2") mlabcol("scheme p2")) (scatter method uci if method==2 & pm==4 , msym(i) mlab(r) mlabpos(0) mcol("scheme p2") mlabcol("scheme p2")) (scatter method lci if method==3 & pm==4 , msym(i) mlab(l) mlabpos(0) mcol("scheme p3") mlabcol("scheme p3")) (scatter method uci if method==3 & pm==4 , msym(i) mlab(r) mlabpos(0) mcol("scheme p3") mlabcol("scheme p3")) (scatter method theta if method==1 & pm==4 , mlab(thelab) mlabpos(1) mcol("scheme p1") mlabcol("scheme p1") msym(o)) (scatter method theta if method==2 & pm==4 , mlab(thelab) mlabpos(1) mcol("scheme p2") mlabcol("scheme p2") msym(o)) (scatter method theta if method==3 & pm==4 , mlab(thelab) mlabpos(1) mcol("scheme p3") mlabcol("scheme p3") msym(o)) , by(dgm, noxrescale legend(off) note("") imargin(tiny) l1tit("Empirical" "standard error" "", orientation(horizontal) width(21) justification(right)) ) subtitle("") ytit("") yla(0 4, val grid labc(white) labsize(*.1)) xla(, grid) ysca(reverse) name(g4, replace) 

*/
