# CALE — Cross-national disparities in mobility independence during aging

Analysis code for the study **"Cross-national disparities in mobility independence during aging."**
The project harmonizes longitudinal health-and-aging cohorts covering **193,731 individuals across 36 countries** (up to 40 countries / 13 datasets in selected analyses) to quantify global variation in age-related decline of outdoor walking capacity, and introduces **Community Ambulation Life Expectancy (CALE)** — the expected duration of independent outdoor mobility.

> **Status:** This repository is provided to accompany the manuscript and to let reviewers inspect the analysis pipeline. The notebooks document how each figure and result was produced. They are **not** a turnkey, one-click reproduction package: paths are resolved relative to the repository root, but the underlying analysis depends on access-restricted cohort and mobility data that are not redistributed here (see [Data](#data)).

---

## What the analysis does

- **Mobility measures.** Three walking-difficulty indicators are harmonized across surveys: walking several blocks (`ws`), walking one block / community ambulation (`wo`, the principal indicator), and basic ambulation (`wa`).
- **National trajectories.** Age-dependent hazard and difficulty-free survival of mobility decline are modeled with a parametric **Gompertz** framework (baseline hazard λ, growth rate γ) for 36 countries, with population-weighted and equal-weight global aggregates and Kaplan–Meier comparison.
- **CALE.** A population-level life-expectancy-style metric for independent outdoor mobility, compared against UN life expectancy to define a country "mobility gap," and broken down by sex and urban/rural residence.
- **Disease burden.** Time-varying survival models estimate the hazard of incident mobility limitation and CALE loss for six conditions (Alzheimer's, stroke, lung disease, cancer, arthritis, heart disease) and for single- vs. multi-morbidity.
- **Structural correlates.** OLS regressions relate CALE to UN **Sustainable Development Goal 3** indicators, controlling for population size, share of older adults, and continent.

---

## Repository layout

```
CALE/
├─ code/            # Analysis notebooks (Python) + Stata cleaning scripts (.do)
├─ data/            # Input / intermediate data 
├─ requirements.txt # Python dependencies
├─ LICENSE          # MIT
└─ README.md
```

---

## Code map

Data pre-processing is done in **Stata** (`.do`); modeling, analysis, and visualization in **Python** (Jupyter notebooks). Notebook names are keyed to the manuscript figures (`f1`–`f4`); `s`-prefixed notebooks correspond to Supplementary Information.

### Data preparation
| File | Purpose |
|------|---------|
| `code/data_prep.do` | Stata harmonization and cleaning of the pooled cohort data into the analysis file (`data/global40.dta`). |
| `code/ACS_download.ipynb` | Download 2020 ACS Census Block Group population age 65+ share (`data/census2020_cbg.csv`), used by Fig. 1a. |
| `code/SDG_download.ipynb` | Download UN SDG global-indicator history for the study countries via the UN SDG API (`data/iso40.csv`). |
| `code/WorldBank_download.ipynb` | Download World Bank indicators matched to each country's last survey year. |
| `code/s1_basic_chara.ipynb` | Export the analysis sample and build the dataset-level basic-characteristics table (Supplementary). |

### Figure 1 — Mobility decline and onset
| File | Produces |
|------|----------|
| `code/f1a_near.ipynb` | Fig. 1a — walkable-range / proximity analysis from location data (SafeGraph + ACS). |
| `code/f1b_scatter.ipynb` | Fig. 1b — age-specific retention of walking ability across the three measures (HRS). |
| `code/f1c_donut.ipynb` | Fig. 1c — country-level prevalence of mobility limitation among adults 65+ (donut chart with ISO3 labels). |
| `code/f1d_aoo_prep.ipynb` | Fig. 1d — age-of-onset density curves for the three walking measures. |

### Figure 2 — National Gompertz trajectories
| File | Produces |
|------|----------|
| `code/f2_gompertz_fit.ipynb` | Country-specific and aggregate Gompertz hazard / survival fits (Fig. 2a–c). |
| `code/s2_gompertz_decade.ipynb` | Gompertz fits summarized by age decade. (Supplementary Information) |
| `code/Worldmap_download.ipynb` | World map of mobility aging, colored by continent (Fig. 2 / world map). |

### Figure 3 — CALE and the global burden of mobility loss
| File | Produces |
|------|----------|
| `code/f3_CALE.ipynb` | CALE vs. UN life expectancy by country and the mobility gap (Fig. 3a–b). |
| `code/f3_sub.ipynb` | CALE by subgroup — Global North & Global South, urban/rural residence, and sex difference (Fig. 3 c-e). |

### Figure 4 — Disease and multimorbidity
| File | Produces |
|------|----------|
| `code/f4_disease_timevary.ipynb` | Time-varying onset and post-onset mobility risk and CALE loss for individual diseases and multimorbidity (Fig. 4). |

### SI 5 — Population health correlates
| File | Produces |
|------|----------|
| `code/s5_reg3var.ipynb` | OLS of CALE on each SDG Goal 3 indicator, controlling for log population, share aged 65+, and continent (Supplementary). |

> Other exploratory notebooks and intermediate outputs may appear under `code/`; the table above lists the notebooks corresponding to the reported figures.

---

## Environment

- Python 3.10+ and Stata (for the `.do` pre-processing).
- Install Python dependencies:

```bash
pip install -r requirements.txt
```

Core Python packages: `numpy`, `pandas`, `matplotlib`, `scipy`, `lifelines`. Mapping notebooks additionally use `geopandas` with Natural Earth boundaries (1:110 m).

`code/ACS_download.ipynb` calls the Census Bureau API; set a `CENSUS_API_KEY` environment variable (free at https://api.census.gov/data/key_signup.html) before running it.

> **Paths.** Each notebook computes `PROJECT_ROOT` from its own working directory (one level up from `code/`) and resolves `data/`, `results/`, and `figures/` paths from it. Run notebooks with `code/` as the working directory (the Jupyter default) and no per-notebook path editing is required. `code/data_prep.do` reads restricted-access cohort files from a `RAWDATA_DIR` environment variable (default: `OAdataset/`, relative to where Stata is run); `code/f1a_near.ipynb` reads SafeGraph mobility files from a `SAFEGRAPH_DIR` environment variable (default: `data/safegraph/`). Neither raw data source is included in this repository.

---

## Data

The analysis combines location-based mobility data with harmonized longitudinal aging cohorts. **These data are not redistributed in this repository**; they must be obtained from the original providers under their respective licenses.

**Mobility & population**
- Mobility (location records): SafeGraph — https://www.safegraph.com/
- Census Block Group population: 2020 ACS 5-year estimates — https://data.census.gov/

**Aging cohorts**
- HRS (USA) — https://hrs.isr.umich.edu/
- ELSA (UK) — https://www.elsa-project.ac.uk/
- SHARE (Europe) — https://share-eric.eu/
- CHARLS (China) — https://charls.charlsdata.com/
- MHAS (Mexico) — https://www.mhasweb.org/
- KLoSA (Korea) — https://survey.keis.or.kr/eng/klosa/klosa01.jsp
- LASI (India) — https://lasi-india.org/study-design/
- ALSA (Australia) — https://sites.flinders.edu.au/alsa/
- HAALSI (South Africa) — https://haalsi.org/haalsa-data/
- NSJE (Japan) — https://www.icpsr.umich.edu/web/NACDA/studies/26621/
- MIDJA (Japan) — https://www.icpsr.umich.edu/web/ICPSR/studies/30822/
- ELSI (Brazil) — https://elsi.cpqrr.fiocruz.br/en/home-english/
- CRELES (Costa Rica) — https://populationsciences.berkeley.edu/creles/

**Country-level indicators**
- UN Sustainable Development Goals data portal — https://unstats.un.org/sdgs/dataportal/database
- World Bank Open Data (downloaded by `code/WorldBank_download.ipynb`)

After obtaining the cohort data, the Stata cleaning script (`code/data_prep.do`) produces the harmonized analysis file used by the notebooks (`data/global40.dta`).

---

## License

Code is released under the [MIT License](LICENSE). The third-party datasets listed above are governed by their own access agreements and licenses.

---
