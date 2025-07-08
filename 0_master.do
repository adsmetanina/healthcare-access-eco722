***** 0_master.do
***** master code for hpsa project

cd "/Users/annasmetanina/Library/Mobile Documents/com~apple~CloudDocs/EconomicsMA_HunterCollege/ECO 722 Nonlinear Econometric Analysis/HPSA Project"
capture log close AS
log using master.log, name(AS) replace

* running each step
do 1_hpsa_county.do
do 2_ahrf_hpsa.do
do 3_npi_ahrf_hpsa.do
do 4_analytic_sample_matched.do
do 5_analysis.do

log close AS
