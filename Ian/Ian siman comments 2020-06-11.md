# Comments on siman suite

## thoughts on siman.sthlp

some {p} directives missing

put -siman table- below -siman analyse-

## siman

as currently written uses three-letter abbreviations of subcommands, 
so having both scattercomparemethods and scatter is a problem.
Rename the latter as comparemethodscatter? (easy)
edit siman.ado to force disambiguation? (hard)

## siman setup

help: which options are required?

dgm() seems to be required?

should we allow siman setup without any estimates?

## siman table

allow format() option?

allow performance measures

discuss: how can we get sensible formatting when different rows need different formats?

hide changes printed before table - done

show all dgm factors - done

I've implemented column() to put one factor in column (actually supercolumn)

should factors with only 1 level be dropped?


## harder DGMs

I have one sim study where I recorded b se and the LRT p-value p_lr. 
I can create Wald by
gen p_wald = chi2tail(1,(b/se)^2)
