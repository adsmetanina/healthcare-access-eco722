***** analytic_sample_matched.do
***** data from ahrf and hpsa

cd "/Users/annasmetanina/Library/Mobile Documents/com~apple~CloudDocs/EconomicsMA_HunterCollege/ECO 722 Nonlinear Econometric Analysis/HPSA Project"
capture log close AS
log using 4_analytic_sample_matched.log, name(AS) replace

* loading final panel
use "panel_npi_ahrf_hpsa.dta", clear

* keeping only hpsa and control counties
keep if inlist(hpsa_flag, 0, 1)

* dropping incomplete rows
drop if missing(fips_num, year, popn_est)
replace provider_count=0 if missing(provider_count)

* converting provider rate to per 10,000
gen providers_per_10k=providers_pc/10

* creating poverty rate
gen poverty_rate=(pers_lt_fpl/popn_est)*100

* collapsing provider groups
collapse (sum) early_provider later_provider provider_count ///
               early_ranked early_unranked later_ranked later_unranked ///
         (mean) providers_per_10k avg_exp poverty_rate ///
               medn_hhi_acs medn_hhi_saipe unemply_rate popn_est, ///
         by(fips_num hpsa_flag)

* computing rates
gen early_per_10k=(early_provider/popn_est)*10000
gen later_per_10k=(later_provider/popn_est)*10000
gen early_ranked_per_10k=(early_ranked/popn_est)*10000
gen early_unranked_per_10k=(early_unranked/popn_est)*10000
gen later_ranked_per_10k=(later_ranked/popn_est)*10000
gen later_unranked_per_10k=(later_unranked/popn_est)*10000

* winsorize providers_per_10k at the 95th percentile
summarize providers_per_10k, detail
scalar p90=r(p90)
gen providers_per_10k_w=providers_per_10k
replace providers_per_10k_w=p90 if providers_per_10k>p90

* saving final analytic sample
save "analytic_sample_matched.dta", replace

log close AS
