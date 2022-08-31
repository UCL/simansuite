# siman comments, IW 22dec2021

## help files: what I've done

I've changed the tables in h siman and h siman table to do line wrapping better. Can you make similar changes for the others please. (I found a careful find-replace worked nicely e.g. "{col 26} {bf:" to "{synopt:{opt " and " {col 36}" to "}".)


## help files: to do

You may not want to promise "You can get the latest version of this and my other Stata software using net from http://github.com/emarleyzagar/". At present it doesn't work.

h siman lollyplot says that bias etc. are options, but they seeem to need to go in "anything".

Shall we just have the list of performance measures in one place, cross-referenced by each of the other help files?


## programs: what I've done

Fixed siman.ado so that it works for -siman scatter-


## programs: to do

See ian/testing1.do, lines marked "// ERROR"

siman table: it would be nice to suppress dgm from the output when there is onlyone dgm

siman comparemethodsscatter: graph looks really strange, needs clear labels

siman scatter doesn't name graph by default but siman comparemethodsscatter does - let's be consistent - i prefer the latter if poss


## overall

I suggest never capitalising siman
