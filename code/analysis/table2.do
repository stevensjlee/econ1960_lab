* Table 2: Regression results
use "$datadir/cps_cleaned.dta" , clear



eststo clear

eststo spec1: reghdfe inctot female, absorb(state) cluster(state)
	estadd local statefe "Yes": spec1
	estadd local agefe "No": spec1
	estadd local racefe "No": spec1
	estadd local indfe "No": spec1
	
eststo spec2: reghdfe inctot female, absorb(state age) cluster(state)
	estadd local statefe "Yes": spec2
	estadd local agefe "Yes": spec2
	estadd local racefe "No": spec2
	estadd local indfe "No": spec2
	
eststo spec3: reghdfe inctot female, absorb(state age race) cluster(state)
	estadd local statefe "Yes": spec3
	estadd local agefe "Yes": spec3
	estadd local racefe "Yes": spec3
	estadd local indfe "No": spec3

eststo spec4: reghdfe inctot female, absorb(state age race ind) cluster(state)
	estadd local statefe "Yes": spec4
	estadd local agefe "Yes": spec4
	estadd local racefe "Yes": spec4
	estadd local indfe "Yes": spec4
	
#delimit;
esttab using "$outdir/tables/table2.tex", replace booktabs
	se label nonotes r2
	coeflabel(female "Female")
	scalars("statefe State FE" "agefe Age FE" "racefe Race FE" "indfe Industry FE")
	star(* 0.1 ** 0.05 *** 0.01);
#delimit cr




