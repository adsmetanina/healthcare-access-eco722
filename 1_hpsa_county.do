***** 1_hpsa_county.do
***** data from hrsa

cd "/Users/annasmetanina/Library/Mobile Documents/com~apple~CloudDocs/EconomicsMA_HunterCollege/ECO 722 Nonlinear Econometric Analysis/HPSA Project"
capture log close AS
log using 1_hpsa_county.log, name(AS) replace

* importing full county hpsa flags
import delimited "hpsa_county_fips.csv", clear

* ensure variable formatting
destring hpsa_flag, replace

* check for duplicates
duplicates drop fips_st_cnty, force

* setting as string
tostring fips_st_cnty, replace force
replace fips_st_cnty=substr("00000", 1, 5-length(fips_st_cnty))+fips_st_cnty if length(fips_st_cnty)<5

* saving clean data
save "hpsa_county.dta", replace

log close AS
