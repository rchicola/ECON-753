***


use "\\files\users\aainas\Desktop\Econ 758\HW 1\ps1.dta", clear 

*Question 1c

eststo WithChildren: estpost summarize nonwhite age ed work earn if children>0

eststo WithoutChildren: estpost summarize nonwhite age ed work earn if children==0

esttab WithChildren WithoutChildren using Table1.rtf, rtf main(mean %6.2f) title("Summary Statistics") mtitle("With Children" "WithoutChildren") replace
esttab WithChildren WithoutChildren using Table1.tex, tex main(mean %6.2f) title("Summary Statistics") mtitle("With Children" "WithoutChildren") replace


*Question 1d
eststo WithOneChild: estpost summarize nonwhite age ed work earn if children==1

eststo WithTwoMoreChildren: estpost summarize nonwhite age ed work earn if children>=2

esttab WithoutChildren WithChildren WithOneChild WithTwoMoreChildren using Table2.rtf, rtf main(mean %6.2f) title("Summary Statistics") mtitle("Without Children" "With Children" "With One Child" "With Two or More Children") replace
esttab WithoutChildren WithChildren WithOneChild WithTwoMoreChildren using Table2.tex, tex main(mean %6.2f) title("Summary Statistics") mtitle("Without Children" "With Children" "With One Child" "With Two or More Children") replace



*Question 2a
**Generate Single Women with Children
gen child=1 if children>0
replace child=0 if children==0


**Generate Post-Treatment Group
gen post1993=1 if year>1993
replace post1993=0 if year<=1993



gen EmployedRate=100-urate

bysort year: egen YearmeanNoChildren = mean(work) if child==0
bysort year: egen YearmeanChildren = mean(work) if child==1 

gen EmpRateWithChildren = YearmeanChildren
replace EmpRateWithChildren = YearmeanNoChildren if EmpRateWithChildren==.

gen EmpRateWithNoChildren = YearmeanChildren
replace EmpRateWithNoChildren = YearmeanNoChildren if EmpRateWithNoChildren==.


twoway (connected EmpRateWithNoChildren year if child==0, lcolor(blue) lwidth(medium) cmissing(n)) (connected EmpRateWithChildren year if child==1, lcolor(mint) lwidth(medium) cmissing(n)), ytitle(Annual Mean Labor Market Participation Rate) ytitle(, size(medsmall)) xtitle(Years) title(Figure 1, size(medium)) legend(on)

*****
*Question 2b
gen NormalWithChildren = EmpRateWithChildren/.46005327
gen NormalWithNoChildren = EmpRateWithNoChildren/.58303249

twoway (connected NormalWithNoChildren year if child==0, lcolor(blue) lwidth(medium) cmissing(n)) (connected NormalWithChildren year if child==1, lcolor(mint) lwidth(medium) cmissing(n)), ytitle(Normalized Annual Mean Labor Market Participation Rate) ytitle(, size(medsmall)) xtitle(Years) title(Figure 2, size(medium)) legend(on)


************
*Question 2d

eststo WithChildren1993: estpost summarize work if child==1 & post1993==0
eststo WithChildrenPost1993: estpost summarize work if child==1 & post1993==1
eststo WithoutChildren1993: estpost summarize work if child==0 & post1993==0
eststo WithoutChildrenPost1993: estpost summarize work if child==0 & post1993==1


***************
eststo WithOneChild1993: estpost summarize work if children==1 & post1993==0
eststo WithOneChildPost1993: estpost summarize work if children==1 & post1993==1
eststo TwoChild1993: estpost summarize work if children>=2 & post1993==0
eststo TwoChildPost1993: estpost summarize work if children>=2 & post1993==1


*****
*Question 2g
gen KidPost=child*post1993

reg work KidPost child post1993
eststo Unconditional

reg work KidPost child post1993 urate nonwhite age ed
eststo Conditional

esttab Unconditional Conditional using Table4.rtf, rtf se star(* 0.10 ** 0.05 *** 0.01) title("Children Versus NoChildren EITC Expansion") mtitle(Unconditional Conditional) scalars(N r2 F) replace	
esttab Unconditional Conditional using Table4.tex, tex se star(* 0.10 ** 0.05 *** 0.01) title("Children Versus NoChildren EITC Expansion") mtitle(Unconditional Conditional) scalars(N r2 F) replace	


******
*Question 2h

gen postplacebo=0 if year==1991|year==1993
replace postplacebo=1 if year==1992

gen postplacebo_child=postplacebo*child

reg work postplacebo child postplacebo_child urate nonwhite age ed if post1993==0
eststo Placebo

esttab Placebo using Table5.rtf, rtf se star(* 0.10 ** 0.05 *** 0.01) title("Conditional Placebo Estimate") mtitle(Conditional) scalars(N r2 F) replace
esttab Placebo using Table5.tex, tex se star(* 0.10 ** 0.05 *** 0.01) title("Conditional Placebo Estimate") mtitle(Conditional) scalars(N r2 F) replace
