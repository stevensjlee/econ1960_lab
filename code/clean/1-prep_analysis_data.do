*===========================================================================
* FALL 2024
* ECON 1960 Senior Thesis     
* This version: 10/26/2024           
* Author: Francesco Ferlenga, Alison Lodermeier and Jiayue Zhang
*===========================================================================

***** Data Cleaning and Preparation

********************************************************************************
******************************** (0) ENVIRONMENT *******************************
********************************************************************************
* Clear pre-existing work
clear all

* Prevent long code from stopping during execution
set more off


* Set your directory here
// global 	root 		"/Users/macbookair/Dropbox"
// global 	root 		"/Users/alilodermeier/Dropbox (Personal)"
global 	root 		"/Users/Jac/Dropbox (Personal)"

global	maindir		"$root/Brown/2024Fall/ECON 1960/template" // this is the way you comment a line of dofile
global 	codedir 	"$maindir/code"
global 	rawdir 		"$maindir/data/raw"
global 	intdir 		"$maindir/data/interim"
global  datadir     "$maindir/data/cleaned"
global	outdir 		"$maindir/output"

cd "$maindir"

* Openning new log file
global  log 		"$codedir/log"
global 	today 	: di %tdYND date(c(current_date), "DMY")
log using "$log/prep_data_$today.log", replace


********************************************************************************
******************************** (1) Ways to import dataset ********************
********************************************************************************



****** (A) Simulated dataset
   set obs 100

****** (B) STATA example datasets

   * List example Stata datasets installed with Stata
     sysuse dir

   * Use example dataset installed with Stata
	 sysuse dir
     sysuse census, clear // You need to add "clear" as an option to remove previous data from memory before importing new data.

	 
****** (C) Files in excel or delimited

   * Depending on raw file, "import delim" (.csv) or "import excel" (.xls/.xlsx)
     import excel using "$rawdir/cps.xls", firstrow clear
     import delim using "$rawdir/cps.csv", clear
  
   * Save file in .dta format
     save "$intdir/cps.dta", replace // option replace needed to overwrite an existing file.
     *Note: never overwrite raw data! If you work with raw data and make changes to the dataset, save it with a different name!


****** (C) Files with .dta format
     
   * Import dataset
     use "$intdir/cps.dta", clear



********************************************************************************
******************************** (2) Locals and globals ********************
********************************************************************************


* Create global with a string
	global 	stata "I LOVE STATA"
	display "$stata"

	global varlist age sex race
	di "$varlist"


* Create local with a string
	local 	stata1 = "I LOVE STATA"
	display "`stata1'"

	local varlist2 age sex race
	di "`varlist2''"


* Create local with a value
	local num_poly = 3

	forvalues i = 1/`num_poly' {
		gen age_power_`i' = age^`i'
	}


********************************************************************************
******************************** (3) Visualizing the data **********************
********************************************************************************


* Count the number of observations
  count

* Browse data
  browse

* Describe data
  describe

* Summarize data
  su

* Summarize a numeric variable
  su age
  su age, d // detail option for more statistics

* Obtain the list of stored results and work with them
  return list

  display r(mean)

  local mean r(mean)
  display `mean'

* Tabulate one variable
  tab race

* Tabulate two variables
  tab sex marst

* Checking for missing values
  count if age==.  // missing values for numeric variables 
  count if sex=="" // missing values for string variables

* Visualize data (kdensity should only be used with continuous variables)
  kdensity incwage

* A histogram is a "discretized" version of the kernel density plot
  hist age, discrete
  
  
  

********************************************************************************
******************************** (4) Data cleaning *****************************
********************************************************************************

* Order variables
  browse
  order state, first
  order educ, after(state)
  
* Sort observations by one/more variable(s)
  sort state 
  sort state age
  
  
* Set numerical values for categorical variable state
	encode state, gen(state_num)

* Generate an indicator variable 	
	gen in_labforce = 0 if labforce == "No, not in the labor force"
	replace in_labforce = 1 if labforce == "Yes, in the labor force"

	gen female=0 if sex=="Male"
	replace female=1 if sex=="Female"
	drop if female==.
	
	gen married = 0 if inlist(marst, "Divorced", "Never married/single", "Separated", "Widowed")
	replace married = 1 if strpos(marst, "Married")
	
	gen white=(race=="White")
	gen black=(race=="Black/Negro")
	gen labforce1=(labforce=="Yes, in the labor force")

  
* Generate an indicator variable for New England (option #1)
  gen     new_england=0 
  replace new_england=1 if inlist(state, "Rhode Island", "Maine", "New Hampshire", "Massachussets", "Connecticut", "Vermont")

* Generate an indicator variable for New England (option #2)
  gen byte new_england2=(inlist(state, "Rhode Island", "Maine", "New Hampshire", "Massachussets", "Connecticut", "Vermont"))
  tab      new_england new_england2

* Generate an indicator variable for New England (option #3)
  gen new_england3=0 

  * Long line of code
    replace new_england3=1 if state=="Rhode Island" | state== "Maine" | state== "New Hampshire" | state== "Massachussets" | state=="Connecticut" | state=="Vermont" 

   * Break long line of code (option #1)
     replace new_england3=1 if state=="Rhode Island" | state== "Maine" | state== "New Hampshire" ///
                            | state== "Massachussets" | state=="Connecticut" | state=="Vermont" 

   * Break long line of code (option #2)
     replace new_england3=1 if state=="Rhode Island" | state== "Maine" | state== "New Hampshire" /*
                         */ | state== "Massachussets" | state=="Connecticut" | state=="Vermont" 

   * Break long line of code (option #3)
    # delimit ;
	replace new_england3=1  if state=="Rhode Island" | state== "Maine" | state== "New Hampshire" 
                             | state== "Massachussets" | state=="Connecticut" | state=="Vermont" ;
    # delimit cr

* Rename a variable
  rename new_england3 new_england4

* Label values of a variable
  label define lnew_england 0 "Rest of US" 1 "New England" // define label
  label values new_england lnew_england                    // attach label to variable values
  tab   new_england
  br    new_england // variables with labels are displayed in blue

* Drop values label
  label drop lnew_england // drop label
  tab        new_england

* Drop a variable
  drop new_england new_england2 new_england4
  
 
* Replace a variable with something different
* Let's say we wish to change the unit of measurement to $K
  replace incwage = incwage/1000
  
* Change variable between numerical and string format
  tostring age, replace
  destring age, replace

* Drop/keep observations with specific characteristics 
  * Drop individuals NILF or not classified in terms of labor force status. "|" is the OR operator. 
    tab labforce
    drop if labforce=="NIU" | labforce=="No, not in the labor force"

   * Drop individuals with age less than 18 and greater than 64
     drop if age<18 | age>64
	 
   * Drop unemployed individuals
     tab     empstat
     drop if inlist(empstat,"Unemployed, experienced worker","Unemployed, new worker")

   * Keep individuals who do not work in manufacturing (industry codes 2000-3999)
     keep if !inrange(ind,2000,3999)

* Compute mean wage income by state
  egen avgincwage = mean(incwage), by(state_num)
  help egen

* Alternatively, collapse observations at the state level (average income)

 preserve

    collapse (mean) incwage, by(state_num)
	list
	graph bar incwage, over(state_num, label(angle(90) labsize(small))) title(Average Income by State) ytitle("Thousand $")

restore
  
* Label variables
	label variable age "Age"
	label variable incwage "Wage income (\$K)"
	label variable inctot "Total income"
	label variable marst "Marital status"
	label variable educ "Education"
	label variable in_labforce "In labor force"

* Export cleaned dataset
save "$datadir/cps_cleaned.dta", replace 


log close


