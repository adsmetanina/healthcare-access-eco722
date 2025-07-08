
***** 2_ahrf_hpsa.do
***** data from ahrf and hpsa

cd "/Users/annasmetanina/Library/Mobile Documents/com~apple~CloudDocs/EconomicsMA_HunterCollege/ECO 722 Nonlinear Econometric Analysis/HPSA Project"
capture log close AS
log using 2_ahrf_hpsa.log, name(AS) replace

* base year 2020
import delimited "ahrf2020_Feb2025.csv", clear
keep f00002 f1198418 f1322618 f1441914 f1492010 f1467518 f0886818 f0890918 f0679519
rename f00002 fips
rename f1198418 popn_est
rename f1322618 medn_hhi_acs
rename f1441914 pers_lt_fpl
rename f1492010 cens_rural_popn
rename f1467518 phys_nf_prim_care
rename f0886818 hosp
rename f0890918 hosp_adm
rename f0679519 unemply_rate

* converting fips state and county code to string variable
generate fips_st_cnty=string(fips, "%05.0f")

* merging hpsa data into ahrf data, flagging controls
merge m:1 fips_st_cnty using "hpsa_county.dta", generate(_merge)
capture drop hpsa_flag
gen hpsa_flag = (_merge == 3)
drop _merge
generate year = 2020
save "hpsa_ahrf_2020.dta", replace

* base year 2021
import delimited "ahrf2021_Feb2025.csv", clear
keep f00002 f1198419 f1322618 f1441915 f1492010 f1467519 f0886819 f0890919 f0679520 
rename f00002 fips
rename f1198419 popn_est
rename f1322618 medn_hhi_acs
rename f1441915 pers_lt_fpl
rename f1492010 cens_rural_popn
rename f1467519 phys_nf_prim_care
rename f0886819 hosp
rename f0890919 hosp_adm
rename f0679520 unemply_rate

* converting fips state and county code to string variable
generate fips_st_cnty=string(fips, "%05.0f")

* merging hpsa data into ahrf data, flagging controls
merge m:1 fips_st_cnty using "hpsa_county.dta", generate(_merge)
capture drop hpsa_flag
gen hpsa_flag = (_merge == 3)
drop _merge
generate year = 2021
save "hpsa_ahrf_2021.dta", replace

* base year 2022
import delimited "ahrf2022_Feb2025.csv", clear
keep f00002 f1198420 f1322618 f1441916 f1492010 f1467520 f0886820 f0890920 f1467720 f1467920 f0679521
rename f00002 fips
rename f1198420 popn_est
rename f1322618 medn_hhi_acs
rename f1441916 pers_lt_fpl
rename f1492010 cens_rural_popn
rename f1467520 phys_nf_prim_care
rename f0886820 hosp
rename f0890920 hosp_adm
rename f1467720 md_nf_prim_care_pc_excl_rsdnt
rename f1467920 do_nf_prim_care_pc_excl_rsdnt
rename f0679521 unemply_rate

* converting fips state and county code to string variable
generate fips_st_cnty=string(fips, "%05.0f")

* merging hpsa data into ahrf data, flagging controls
merge m:1 fips_st_cnty using "hpsa_county.dta", generate(_merge)
capture drop hpsa_flag
gen hpsa_flag = (_merge == 3)
drop _merge
generate year = 2022
save "hpsa_ahrf_2022.dta", replace

* base year 2023
import delimited "ahrf2023_Feb2025.csv", clear
keep fips_st_cnty popn_est_22 medn_hhi_acs_21 medn_hhi_saipe_21 pers_lt_fpl_21 phys_nf_prim_care_pc_exc_rsdt_21 cens_rural_popn_20 hosp_21 hosp_adm_21 unemply_rate_ge16_22
rename fips_st_cnty fips
rename popn_est_22 popn_est
rename cens_rural_popn_20 cens_rural_popn
rename medn_hhi_acs_21 medn_hhi_acs
rename medn_hhi_saipe_21 medn_hhi_saipe
rename pers_lt_fpl_21 pers_lt_fpl
rename phys_nf_prim_care_pc_exc_rsdt_21 phys_nf_prim_care
rename hosp_21 hosp
rename hosp_adm_21 hosp_adm
rename unemply_rate_ge16_22 unemply_rate

* converting fips state and county code to string variable
generate fips_st_cnty=string(fips, "%05.0f")

* merging hpsa data into ahrf data, flagging controls
merge m:1 fips_st_cnty using "hpsa_county.dta", generate(_merge)
capture drop hpsa_flag
gen hpsa_flag = (_merge == 3)
drop _merge
generate year = 2023
save "hpsa_ahrf_2023.dta", replace

* base year 2024
import delimited "ahrf2024_Feb2025.csv", clear
keep fips_st_cnty popn_est_23 medn_hhi_acs_22 medn_hhi_saipe_22 pers_lt_fpl_22 cens_rural_popn_20 phys_nf_prim_care_pc_exc_rsdt_22 hosp_22 hosp_adm_22 unemply_rate_ge16_23
rename fips_st_cnty fips
rename popn_est_23 popn_est
rename medn_hhi_acs_22 medn_hhi_acs
rename medn_hhi_saipe_22 medn_hhi_saipe
rename pers_lt_fpl_22 pers_lt_fpl
rename cens_rural_popn_20 cens_rural_popn
rename phys_nf_prim_care_pc_exc_rsdt_22 phys_nf_prim_care
rename hosp_22 hosp
rename hosp_adm_22 hosp_adm
rename unemply_rate_ge16_23 unemply_rate

* converting fips state and county code to string variable
generate fips_st_cnty=string(fips, "%05.0f")

* merging hpsa data into ahrf data, flagging controls
merge m:1 fips_st_cnty using "hpsa_county.dta", generate(_merge)
capture drop hpsa_flag
gen hpsa_flag = (_merge == 3)
drop _merge
generate year = 2024
save "hpsa_ahrf_2024.dta", replace

* looping to process ahrf hpsa
local years 2020 2021 2022 2023 2024
foreach yr of local years {
    di "Processing year `yr'..."
    * loading ahrf hpsa data for the year
    use "hpsa_ahrf_`yr'.dta", clear
    * saving the cleaned dataset
    save "processed_hpsa_ahrf_`yr'.dta", replace
}

log close AS
