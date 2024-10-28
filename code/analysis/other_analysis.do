
*Common regression commands;

reg inctot age
reg inctot age, robust
reg inctot age, cluster(state)
reg inctot age if state=="Rhode Island", robust

gen wt=runiform()
reg inctot age [pweight=wt], robust

*fixed effects
reg inctot i.age, robust
reg inctot i.female##i.age, robust

predict yhat
predict res, residual

*can also use areg command instead of reghdfe. reghdfe is much faster than i. method
reghdfe inctot female, absorb(state race age marst) vce(robust)

reghdfe inctot i.age if age>=25 & age<=34, absorb(state race sex marst) vce(robust)
coefplot, vert drop(_cons)
*can also store estimates and CIs and plot event study using twoway;

*IV
gen instrument=runiform(0,100)
ivreg2 inctot female (married=instrument), robust
ivreghdfe inctot female (married=instrument), absorb(state)

*iv decomposed
ivreg2 inctot (married=instrument), robust first
reg married  instrument , r
predict double xhat
reg inctot xhat , r




*RDD
gen runningvar=runiform(0,100)
local threshold 30
rdrobust married runningvar, c(`threshold') h(20 20) 
rdplot married runningvar, c(30) h(20 20) plot

