

********************************************************************************
**# ***************** (5) IF QUALIFIER **************************
********************************************************************************

// IF QUALIFIERS 
su incwage if sex=="Female"
su incwage if sex=="Male"

drop if (vetstat=="Yes" | vetstat=="NIU") & state=="Rhode Island" 



********************************************************************************
**# ***************************** (6) LOOPS ************************************
********************************************************************************

* Loop #1
foreach i in "A" "B" "C" "D" {
	display 	 "My favorite letter is `i'"
}

* Loop #2
forval i = 1/10 {
	local text 	= "My favorite number is `i'"
	display 	"`text'"
}

* Loop #3
forval i = 1/10 {
	local j  	= 2*`i'-7
	display 	`j'
}

* Loop #4
forval i = 1(1.5)10 {
	display `i'
}


* Loop #5
forval n = 1(10)101 {
	if `n'==1 display "start from `n'"
	else display "adding 10 gives... `n'"
}

* Loop #6
local sum = 4*10
local n = 0
foreach obj in "A" 1 `sum' {
	local ++n 						// short for " local n = `n'+1 "
	display	" object number `n' is: `obj'" 
}
*

     
 
   ****************************STRING*******************
  gen new_state=subinstr(state, "as", "_anythnig_", .)
  br if strpos(new_state, "anythnig")>0
  gen state_upper=upper(state)
  
  *help string functions for more info

  ***************************MERGE and APPEND ***************************
  gen id =_n
  duplicates tag state id, gen(dup)
  tab dup
  
  merge 1:1 state id using "$datadir/cps_mer.dta"
    
  append using "$datadir/cps_mer.dta"
  
  ****************GROUPING 
  egen fe_st_age= group(state sex)

  
  ***************************RESHAPE LONG and WIDE************************
  gen female=0 if sex=="Male"
  replace female=1 if sex=="Female"
  drop if female==.
  
  *figure out avg wages and income within state-sex-age-race-education-industry groups
  collapse (mean) incwage inctot, by(state female age race educ ind)
  
  *reshape wide to have male wage and female wage columns
  reshape wide incwage inctot, i(state age race educ ind) j(female)
  
  *go back to original data structure
  reshape long incwage inctot, i(state age race educ ind) j(female)
  
***********LAGGING
  use "$datadir/panel.dta", clear
  sort state year
  bysort state: gen lag_valuex=valuex[_n-1]
