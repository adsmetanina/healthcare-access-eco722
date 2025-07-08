***** 3_npi_ahrf_hpsa.do
***** data from npi

cd "/Users/annasmetanina/Library/Mobile Documents/com~apple~CloudDocs/EconomicsMA_HunterCollege/ECO 722 Nonlinear Econometric Analysis/HPSA Project"
capture log close AS
log using 3_npi_ahrf_hpsa.log, name(AS) replace

* checking tabulation
use hpsa_county.dta, clear
tab hpsa_flag

* importing data
import delimited using "DAC_NationalDownloadableFile.csv", clear
tab pri_spec

* cleaning specialty fields
capture drop pri_spec_clean
gen pri_spec_clean=upper(trim(pri_spec))
keep if inlist(pri_spec_clean, "INTERNAL MEDICINE", "FAMILY PRACTICE", ///
                               "GENERAL PRACTICE", "PEDIATRIC MEDICINE") ///
    & inlist(cred, "MD", "DO")

* extracting zip codes
gen zip_str=substr(zipcode, 1, 5)

* merging zip to fips
merge m:1 zip_str using "ZIP to FIPS.dta", nogen

* merging ranked medical schools
merge m:1 med_sch using "ranked_list.dta", keepusing(ranked_school) nogen
gen ranked=(ranked_school==1)

* calculating experience and group
gen years_experience=2025-grd_yr
gen exp_group=.
replace exp_group=1 if years_experience<=5
replace exp_group=2 if inrange(years_experience, 6, 15)
replace exp_group=3 if years_experience>15
capture label drop expgrp
label define expgrp 1 "Early Career" 2 "Mid Career" 3 "Late Career"
label values exp_group expgrp

* creating provider indicators
gen early_provider = (exp_group==1)
gen later_provider = inlist(exp_group, 2, 3)
gen provider_count = 1
gen early_ranked   = (exp_group==1 & ranked==1)
gen early_unranked = (exp_group==1 & ranked==0)
gen later_ranked   = (inlist(exp_group, 2, 3) & ranked==1)
gen later_unranked = (inlist(exp_group, 2, 3) & ranked==0)

* collapsing to county level
collapse (sum) provider_count early_provider later_provider ///
                 early_ranked early_unranked later_ranked later_unranked ///
         (mean) avg_exp=years_experience, ///
         by(fips_st_cnty)

* saving data
save provider_npi.dta, replace

* merging w/ ahrf and hpsa
local years 2020 2021 2022 2023 2024
foreach yr of local years {
    di "Processing year `yr'..."
    use "hpsa_ahrf_`yr'.dta", clear
	replace hpsa_flag = 0 if missing(hpsa_flag)
    merge m:1 fips_st_cnty using "provider_npi.dta", nogen
    * filling in zeros for unmatched counties
    replace provider_count = 0 if missing(provider_count)
    replace early_provider = 0 if missing(early_provider)
    replace later_provider = 0 if missing(later_provider)
    replace early_ranked = 0 if missing(early_ranked)
    replace early_unranked = 0 if missing(early_unranked)
    replace later_ranked = 0 if missing(later_ranked)
    replace later_unranked = 0 if missing(later_unranked)
    replace avg_exp = . if provider_count == 0
    save "processed_hpsa_ahrf_`yr'.dta", replace
}

* adding rates and experience groups
capture label drop expgrp
label define expgrp 1 "Early Career" 2 "Mid Career" 3 "Late Career"
foreach yr of local years {
    use "processed_hpsa_ahrf_`yr'.dta", clear
    gen providers_pc = (provider_count / popn_est) * 100000
    capture drop exp_group
    gen exp_group = .
    replace exp_group = 1 if avg_exp <= 5
    replace exp_group = 2 if inrange(avg_exp, 6, 15)
    replace exp_group = 3 if avg_exp > 15
    label values exp_group expgrp
    save "final_hpsa_ahrf_`yr'.dta", replace
}

* stacking into panel
clear
local first=1
foreach yr of local years {
    use "final_hpsa_ahrf_`yr'.dta", clear
    capture drop year
    gen year=`yr'
    if `first'==1 {
        tempfile base
        save `base'
        local first=0
    }
    else {
        append using `base'
        save `base', replace
    }
}
use `base', clear

* cleaning panel data
gen fips_num=real(fips_st_cnty)
drop if missing(fips_num) | fips_num==0
duplicates drop fips_num year, force
xtset fips_num year

drop if fips_num==109 & missing(provider_count) & missing(popn_est)

* saving final panel dataset
save "panel_npi_ahrf_hpsa.dta", replace

log close AS
