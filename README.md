# Career Stage, Medical School Prestige, and Physician Allocation: Evidence from Health Professional Shortage Areas

Final project code for ECO 722: Econometric Analysis II at Hunter College. Replication of Khoury, Leganza, and Masucci "Health Professional Shortage Areas and Physician Location Decisions" (2025) using generalized linear models in Stata. This repository contains a set of Stata codes used to prepare, merge, and analyze health policy data. It specifically investigates how physician practice location decisions vary by career stage and medical school prestige, using Health Professional Shortage Area (HPSA) designations. The project constructs an analytic sample using HPSA, AHRF, and NPI datasets, and performs a final analysis on matched counties.

## Files

| File                           | Description                                                        |
|--------------------------------|--------------------------------------------------------------------|
| `0_master.do`                  | Master code that runs all analysis files in sequence               |
| `1_hpsa_county.do`             | Prepares HPSA county-level data                                    |
| `2_ahrf_hpsa.do`               | Merges AHRF data w/ HPSA flags for 2020–2024                       |
| `3_npi_ahrf_hpsa.do`           | Integrates provider-level NPI data w/ county-year dataset          |
| `4_analytic_sample_matched.do` | Creates the matched analytic sample and computes rates             |
| `5_analysis.do`                | Runs OLS and GLM regressions and generates summary tables          |
| `ranked_list.do`               | Loads and formats ranked medical school list                       |


## Project Overview

The final paper submitted on May 26, 2025 summarizes the research findings and methodology. It includes regression results, policy implications, and literature references.

## Data Sources

- [HRSA Area Health Resources Files (AHRF)](https://data.hrsa.gov/data/download)
- [Health Professional Shortage Areas (HPSA)](https://data.hrsa.gov/topics/health-workforce/shortage-areas)
- [NPPES NPI Registry](https://download.cms.gov/nppes/NPI_Files.html)

## Methodology

- Panel data construction and county-year aggregation (2020–2024).
- Gamma GLM w/ log link to handle skewed count data.
- OLS regressions w/ winsorization at the 90th percentile.
- Categorization of physicians by experience and medical school prestige.

## Results

- HPSA designation effects diminish after controlling for socioeconomic and physician-level characteristics.
- Designated areas are disproportionately staffed by late-career, unranked medical school graduates.
- Early-career physicians from ranked schools are underrepresented in underserved regions.

## Reference

- Khoury, A., Leganza, T., & Masucci, T. (2023). *Health Professional Shortage Areas and Physician Location Decisions*. Working paper.

## License

This repository is for academic use only.
