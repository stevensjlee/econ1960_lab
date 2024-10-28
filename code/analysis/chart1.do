* Chart: Average Income by Age

clear
use "$datadir/cps_cleaned.dta" 


* Collapse observations at the age level
  collapse (mean) incwage, by(age)

* Graph Options
  global graphconfig 	"graphregion(color(white)) bgcolor(white)"
  global options 		"msymbol(none) lwidth(medthick)"

* Graphs: a nice situation in which breaking lines is essential
  #delimit ;
  twoway connected incwage age, 
       $options lcolor(ebblue)
	   xtitle("Age (Years)") ytitle("Average Wage Income (K$)")
	   ylabel(0(20)140, angle(0)) xlabel(20(5)65, angle(0))
	   $graphconfig;
	   graph export "$outdir/figures/avgwageincome_wage.jpg", replace;
  #delimit cr
  
 