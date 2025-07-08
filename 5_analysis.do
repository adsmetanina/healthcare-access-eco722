***** 5_analysis.do
***** data from ahrf and hpsa

cd "/Users/annasmetanina/Library/Mobile Documents/com~apple~CloudDocs/EconomicsMA_HunterCollege/ECO 722 Nonlinear Econometric Analysis/HPSA Project"
capture log close AS
log using 5_analysis.log, name(AS) replace

* using data
use "analytic_sample_matched.dta", clear
drop medn_hhi_saipe

* assigning labels
label variable providers_per_10k		"Providers per 10,000"
label variable providers_per_10k_w      "Providers per 10,000 (Winsorized)"
label variable early_per_10k            "Early-career providers per 10,000"
label variable later_per_10k            "Late-career providers per 10,000"
label variable early_ranked_per_10k     "Early-career (Ranked) per 10,000"
label variable early_unranked_per_10k   "Early-career (Unranked) per 10,000"
label variable later_ranked_per_10k     "Late-career (Ranked) per 10,000"
label variable later_unranked_per_10k   "Late-career (Unranked) per 10,000"
label variable medn_hhi_acs             "Median household income (ACS)"
label variable poverty_rate             "Poverty rate (%)"
label variable unemply_rate             "Unemployment rate (%)"
label variable popn_est                 "Population estimate"

* creating summary statistics
estpost tabstat ///
    providers_per_10k early_per_10k later_per_10k ///
    early_ranked_per_10k early_unranked_per_10k ///
    later_ranked_per_10k later_unranked_per_10k ///
    medn_hhi_acs poverty_rate unemply_rate popn_est, ///
    stats(mean sd min max count) columns(statistics)

esttab using "summary_statistics.tex", ///
    label cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count") ///
    collabels("Mean" "SD" "Min" "Max" "N") ///
    title("Summary Statistics (Pooled Sample)") ///
    replace

esttab using "summary_statistics.rtf", ///
    label cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count") ///
    collabels("Mean" "SD" "Min" "Max" "N") ///
    title("Summary Statistics (Pooled Sample)") ///
    replace

* creating summary statistics by hpsa status
estpost tabstat ///
    providers_per_10k early_per_10k later_per_10k ///
    early_ranked_per_10k early_unranked_per_10k ///
    later_ranked_per_10k later_unranked_per_10k ///
    medn_hhi_acs poverty_rate unemply_rate popn_est, ///
    by(hpsa_flag) stats(mean sd min max count) columns(statistics)

esttab using "grouped_summary_statistics.tex", ///
    label ///
    cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count") ///
    collabels("Mean" "SD" "Min" "Max" "N") ///
    title("Summary Statistics by HPSA Status") ///
    booktabs nonumber alignment(D{.}{.}{-1}) replace

esttab using "grouped_summary_statistics.rtf", ///
    label cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count") ///
    collabels("Mean" "SD" "Min" "Max" "N") ///
    title("Summary Statistics by HPSA Status") ///
    replace

* plotting density
twoway (kdensity providers_per_10k, ///
    lcolor(navy) lwidth(medium) ///
    kernel(epanechnikov)), ///
    title("Density of Providers per 10,000 Residents", size(medium)) ///
    xtitle("Providers per 10,000 Residents", size(medsmall)) ///
    ytitle("Density", size(medsmall)) ///
    graphregion(color(white)) ///
    bgcolor(white) ///
    legend(off) ///
    scheme(s1color)
graph export "provider_kernel_density.png", replace width(1600) height(1200)

* rescaling for regressions
gen medn_hhi_thou=medn_hhi_acs/1000
label variable medn_hhi_thou "Median household income (Thousands USD)"

* Population estimate in 100,000s
gen popn_100k=popn_est/100000
label variable popn_100k "Population (per 100,000)"

* running ols regressions
eststo clear
eststo m1: reg providers_per_10k_w hpsa_flag, nocons robust
eststo m2: reg providers_per_10k_w hpsa_flag medn_hhi_thou poverty_rate unemply_rate popn_100k, nocons robust
eststo m3: reg providers_per_10k_w hpsa_flag ///
    early_ranked_per_10k early_unranked_per_10k ///
    later_ranked_per_10k later_unranked_per_10k ///
    medn_hhi_thou poverty_rate unemply_rate popn_100k, nocons robust

* exporting results
esttab m1 m2 m3 using "linear_regressions.tex", ///
    label replace stats(N, fmt(0) labels("Observations")) ///
    cells(b(fmt(3)) p(par fmt(3))) ///
    nocons noomitted ///
    title("OLS Regressions (Winsorized Outcome)") ///
    collabels(none) eqlabels("Model 1" "Model 2" "Model 3") ///
    booktabs alignment(D{.}{.}{-1}) noobs nomtitles

esttab m1 m2 m3 using "linear_regressions.rtf", ///
    label replace stats(N, fmt(0) labels("Observations")) ///
    cells(b(fmt(3)) p(par fmt(3))) ///
    nocons noomitted ///
    title("OLS Regressions (Winsorized Outcome)") ///
    collabels(none) eqlabels("Model 1" "Model 2" "Model 3") ///
    noobs nomtitles

* storing glm models
eststo clear

* regressing unadjusted model
eststo glm1: glm providers_per_10k hpsa_flag, link(log) family(gamma) robust

* regressing model w/ socioeconomic controls
eststo glm2: glm providers_per_10k hpsa_flag medn_hhi_thou poverty_rate unemply_rate popn_100k, ///
    link(log) family(gamma) robust

* evaluating marginal effects
margins, at(hpsa_flag=(0 1)) expression(predict())

* regressing early career only
eststo glm4: glm early_per_10k hpsa_flag medn_hhi_thou poverty_rate unemply_rate popn_100k, ///
    link(log) family(gamma) robust

* evaluating marginal effects
margins, at(hpsa_flag=(0 1)) expression(predict())

* regressing late career only
eststo glm5: glm later_per_10k hpsa_flag medn_hhi_thou poverty_rate unemply_rate popn_100k, ///
    link(log) family(gamma) robust
	
* evaluating marginal effects
margins, at(hpsa_flag=(0 1)) expression(predict())

* regressing model w/ provider breakdowns
eststo glm3: glm providers_per_10k hpsa_flag ///
    early_ranked_per_10k early_unranked_per_10k ///
    later_ranked_per_10k later_unranked_per_10k ///
    medn_hhi_thou poverty_rate unemply_rate popn_100k, ///
    link(log) family(gamma) robust

* exporting to latex
esttab glm1 glm2 glm4 glm5 glm3 using "glm_regressions.tex", ///
    label replace ///
    nocons noomitted ///
    cells(b(fmt(3)) p(par fmt(3))) ///
    stats(N, fmt(0) labels("Observations")) ///
    eqlabels("Full" "Socioeconomic" "Early-career" "Late-career" "Provider Mix") ///
    title("Gamma Log-Link Regressions of Provider Rates") ///
    collabels(none) booktabs alignment(D{.}{.}{-1}) noobs nomtitles

* exporting to rtf
esttab glm1 glm2 glm4 glm5 glm3 using "glm_regressions.rtf", ///
    label replace ///
    nocons noomitted ///
    cells(b(fmt(3)) p(par fmt(3))) ///
    stats(N, fmt(0) labels("Observations")) ///
    eqlabels("Full" "Socioeconomic" "Early-career" "Late-career" "Provider Mix") ///
    title("Gamma Log-Link Regressions of Provider Rates") ///
    collabels(none) noobs nomtitles
	
log close AS
