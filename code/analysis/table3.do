* Table 3: Regression results using outreg
use "$datadir/cps_cleaned.dta" , clear

* ssc install outreg2 // do this only once

*outreg
reghdfe inctot female married, absorb(state) cluster(state)
outreg2 using "$outdir/tables/table3.tex", dec(2) replace label keep(female) addtext(State FE, YES, Age FE, NO, Race FE, NO, Ind FE, NO)
reghdfe inctot female married, absorb(state age) cluster(state)
outreg2 using "$outdir/tables/table3.tex", dec(2) append label keep(female) addtext(State FE, YES, Age FE, YES, Race FE, NO, Ind FE, NO)
reghdfe inctot female married, absorb(state age race) cluster(state)
outreg2 using "$outdir/tables/table3.tex", dec(2) append label keep(female) addtext(State FE, YES, Age FE, YES, Race FE, YES, Ind FE, NO)
reghdfe inctot female married, absorb(state age race ind) cluster(state)
outreg2 using "$outdir/tables/table3.tex", dec(2) append label keep(female) addtext(State FE, YES, Age FE, YES, Race FE, YES, Ind FE, YES)
