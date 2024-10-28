*===========================================================================
* FALL 2024
* ECON 1960 Senior Thesis     
* This version: 10/26/2024           
* Author: Francesco Ferlenga, Alison Lodermeier and Jiayue Zhang
*===========================================================================


* Using "*" at the beginning of the line prevents the line from being run. This is one way to leave comments on the dofile.
*bla bla bla 

/* When your comment is very long, say bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla, you can use this alternative method. */

* If you use the method above, remember to begin the comment with "/*" and to close it with "*/", or your entire dofile will be commented out and prevented from running!



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
global  datadir     "$maindir/data/cleaned"
global	outdir 		"$maindir/output"

cd "$maindir"


* Openning new log file
global  log 		"$codedir/log"
global 	today 	: di %tdYND date(c(current_date), "DMY")
log using "$log/analysis_$today.log", replace


********************************************************************************
******************************** (1) MAIN **************************************
********************************************************************************

do "$codedir/analysis/chart1.do"

do "$codedir/analysis/table1.do"
do "$codedir/analysis/table2.do"
do "$codedir/analysis/table3.do"


log close
