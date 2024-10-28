* Table 1: Summary stats


use "$datadir/cps_cleaned.dta" , clear

	
	lab var incwage "Wage income"
	lab var inctot "Total income"
	lab var age "Age"
	lab var female "Female"
	lab var white "White"
	lab var black "Black"
	lab var married "Married"
	lab var labforce1 "In labor force"

	eststo clear
	eststo: estpost tabstat incwage inctot age female white black married labforce1, stat(mean sd min max N) col(stat)

	#delimit;
	esttab using "$outdir/tables/table1.tex", replace booktabs label nogaps noobs nonum nomtitles 
		cells("Mean(fmt(3)) SD(fmt(3)) Min(fmt(0)) Max(fmt(0)) count(fmt(0) label(N))");	
	#delimit cr
