# UHI-Energy Nexus

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.XXXXXXX.svg)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![R Version](https://img.shields.io/badge/R-4.1.2%2B-blue)](https://www.r-project.org/)
[![ArcGIS Pro](https://img.shields.io/badge/ArcGIS%20Pro-2.9-green)](https://www.esri.com/)
[![Journal](https://img.shields.io/badge/journal-Science%20of%20the%20Total%20Environment-informational)](https://www.sciencedirect.com/journal/science-of-the-total-environment)

**Spatiotemporal coupling of urbanization, surface heat islands, and escalating energy demand in a Himalayan valley: A remote sensing and econometric approach**

*Repository for the research paper published in Science of the Total Environment*

---

## 📋 Overview

This repository contains all code, data, and documentation necessary to reproduce the analysis presented in our study examining the relationship between urban heat island (UHI) intensification and household energy consumption in Nepal's Kathmandu Valley (2014–2019).

We integrate **Landsat 8 remote sensing data** with **district-level residential electricity consumption** using:
- **Spatiotemporal trend analysis** (Mann-Kendall test, Sen's Slope)
- **Surface Urban Heat Island Intensity (SUHII)** quantification
- **Panel regression modeling** with climate controls

**Key finding:** A 1°C increase in SUHII is associated with a 4–6% rise in annual household energy consumption, controlling for urban extent and climate variability.

---

## 📁 Repository Structure

```
kathmandu-uhi-energy-nexus/
│
├── README.md                 # This file
├── LICENSE                    # MIT License
├── .gitignore                 # Files to exclude from version control
├── CITATION.cff               # Citation metadata
│
├── data/
│   ├── raw/                   # Original, unmodified data
│   │   ├── landsat_metadata.csv       # Scene IDs and acquisition dates
│   │   ├── energy_consumption.csv     # Raw NEA electricity data
│   │   └── meteorological.csv         # Raw DHM temperature data
│   │
│   ├── processed/             # Cleaned, analysis-ready data
│   │   ├── lst_2014_2019.tif         # Land Surface Temperature rasters
│   │   ├── ndvi_2014_2019.tif        # NDVI rasters
│   │   ├── ndbi_2014_2019.tif        # NDBI rasters
│   │   ├── suhii_2014_2019.tif       # SUHII rasters
│   │   └── panel_data.csv             # District-year panel dataset
│   │
│   └── spatial/               # Spatial boundary files
│       ├── kathmandu_district.shp
│       ├── bhaktapur_district.shp
│       └── study_area_boundary.shp
│
├── scripts/
│   ├── 01_download_landsat.R          # Landsat 8 data acquisition
│   ├── 02_preprocess_landsat.R        # Radiometric/atmospheric correction
│   ├── 03_calculate_indices.R          # NDVI, NDBI, LST, SUHII
│   ├── 04_trend_analysis.R             # Mann-Kendall & Sen's Slope
│   ├── 05_prepare_panel_data.R         # Align spatial & energy data
│   ├── 06_correlation_analysis.R       # Pearson correlations
│   ├── 07_regression_model.R           # Panel regression with LOOCV
│   ├── 08_visualization.R              # Generate figures
│   └── utils/
│       ├── landsat_functions.R         # Helper functions for Landsat
│       ├── statistical_functions.R     # Custom statistical tools
│       └── plotting_theme.R            # Publication-quality themes
│
├── outputs/
│   ├── figures/                # Publication-ready figures
│   │   ├── figure1_study_area.png
│   │   ├── figure2_methodology_workflow.png
│   │   ├── figure3_lst_maps_2014_2019.png
│   │   ├── figure4_ndvi_maps.png
│   │   ├── figure5_ndbi_maps.png
│   │   ├── figure6_suhii_maps.png
│   │   ├── figure7_trend_maps.png       # Mann-Kendall significance
│   │   ├── figure8_energy_trend.png
│   │   └── figure9_correlation_matrix.png
│   │
│   ├── tables/                 # Publication-ready tables
│   │   ├── table1_landsat_acquisition.csv
│   │   ├── table2_descriptive_stats.csv
│   │   ├── table3_correlation_matrix.csv
│   │   ├── table4_regression_results.csv
│   │   └── table5_validation_metrics.csv
│   │
│   └── supplementary/          # Additional materials
│       ├── supplementary_methods.pdf
│       └── validation_results.pdf
│
├── manuscript/
│   ├── manuscript.docx          # Full paper draft
│   ├── figures/                 # Figures embedded in manuscript
│   └── references.bib           # BibTeX references
│
└── environment/
    ├── environment.yml           # Conda environment (Python users)
    ├── renv.lock                  # R environment lockfile
    └── requirements.txt           # Python dependencies
```

---

## 🚀 Getting Started

### Prerequisites

- **R** (≥ 4.1.2) with packages:
  ```r
  install.packages(c("raster", "sf", "rgdal", "ggplot2", "dplyr", 
                     "tidyr", "trend", "Kendall", "zyp", "plm",
                     "lmtest", "caret", "corrplot", "gridExtra"))
  ```
- **ArcGIS Pro 2.9** (optional, for spatial visualization)
- **QGIS 3.16+** (free alternative for spatial processing)
- **Python 3.8+** (if using Python workflow; see `environment.yml`)

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/kathmandu-uhi-energy-nexus.git
   cd kathmandu-uhi-energy-nexus
   ```

2. **Set up the environment**
   ```bash
   # For R users
   Rscript scripts/utils/install_dependencies.R
   
   # For Python users
   conda env create -f environment/environment.yml
   conda activate uhi-energy-nexus
   ```

3. **Run the complete analysis pipeline**
   ```bash
   # Execute scripts in order
   Rscript scripts/01_download_landsat.R
   Rscript scripts/02_preprocess_landsat.R
   Rscript scripts/03_calculate_indices.R
   Rscript scripts/04_trend_analysis.R
   Rscript scripts/05_prepare_panel_data.R
   Rscript scripts/06_correlation_analysis.R
   Rscript scripts/07_regression_model.R
   Rscript scripts/08_visualization.R
   ```

4. **View results**
   - All figures: `outputs/figures/`
   - All tables: `outputs/tables/`
   - Processed data: `data/processed/`

---

## 📊 Data Sources

| Data Type | Source | Access | License |
|-----------|--------|--------|---------|
| Landsat 8 OLI/TIRS | USGS EarthExplorer | [earthexplorer.usgs.gov](https://earthexplorer.usgs.gov/) | Public domain |
| Residential electricity consumption | Nepal Electricity Authority (NEA) | Available upon request | Restricted |
| Meteorological data | Department of Hydrology and Meteorology (DHM), Nepal | [dhm.gov.np](https://www.dhm.gov.np/) | Public |
| Administrative boundaries | Central Bureau of Statistics, Nepal | [cbs.gov.np](https://cbs.gov.np/) | Public |

**Note:** Due to data sharing restrictions, raw energy consumption data are not included in this repository. Processed, anonymized panel data are available in `data/processed/panel_data.csv`.

---

## 🔬 Reproducibility

This repository is designed for **full computational reproducibility**. To verify our results:

1. **Run the complete pipeline** as described above
2. **Compare outputs** with our published figures/tables
3. **Cross-validate** using the LOOCV results in `outputs/tables/table5_validation_metrics.csv`

All random seeds are fixed for stochastic processes. The `renv.lock` file ensures exact R package versions.

---

## 📈 Key Results

| Finding | Value | Significance |
|---------|-------|--------------|
| SUHII increase (2014–2019) | +3.2°C (summer), +2.1°C (winter) | p < 0.01 (Mann-Kendall) |
| Residential energy increase | +85% (Kathmandu), +100% (Bhaktapur) | - |
| SUHII–Energy correlation | r = 0.89 | p < 0.05 |
| Regression coefficient (β₁) | 4.8% energy increase per 1°C SUHII | p < 0.05 |
| Model validation RMSE | 12.4 GWh | MAPE: 6.2% |

See `outputs/tables/` for complete statistical results.

---

## 🖼️ Key Figures

| Figure | Description | File |
|--------|-------------|------|
| Figure 1 | Study area map | `outputs/figures/figure1_study_area.png` |
| Figure 2 | Methodology workflow | `outputs/figures/figure2_methodology_workflow.png` |
| Figure 3 | LST maps (2014 vs 2019) | `outputs/figures/figure3_lst_maps_2014_2019.png` |
| Figure 6 | SUHII maps | `outputs/figures/figure6_suhii_maps.png` |
| Figure 7 | Mann-Kendall trend significance | `outputs/figures/figure7_trend_maps.png` |
| Figure 9 | Correlation matrix | `outputs/figures/figure9_correlation_matrix.png` |

---

## 📝 Citation

If you use this code or data in your research, please cite:

**Paper:**
```
Thapa, P. (2025). Spatiotemporal coupling of urbanization, surface heat islands, 
and escalating energy demand in a Himalayan valley: A remote sensing and 
econometric approach. Science of the Total Environment, XXX, XXX-XXX.
https://doi.org/10.1016/j.scitotenv.2025.XX.XXX
```

**Repository:**
```
Thapa, P. (2025). kathmandu-uhi-energy-nexus: Code and data for UHI-energy 
analysis in Nepal's Kathmandu Valley (Version v1.0.0) [Computer software].
https://github.com/yourusername/kathmandu-uhi-energy-nexus
```

A `CITATION.cff` file is included for automated citation.

---

## 🤝 Contributing

We welcome contributions that improve reproducibility or extend the analysis:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -m 'Add improvement'`)
4. Push to branch (`git push origin feature/improvement`)
5. Open a Pull Request

Please ensure all code is documented and tested.

---

## 🐛 Issues and Support

- **Bug reports:** Use the [GitHub Issues](https://github.com/yourusername/kathmandu-uhi-energy-nexus/issues) page
- **Questions:** Contact the corresponding author at [pawan.thapa@email.com](mailto:pawan.thapa@email.com)
- **Reproducibility help:** Check the troubleshooting guide in `docs/TROUBLESHOOTING.md`

---

## 📄 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

**Data licenses:**
- Landsat data: Public domain (USGS)
- Energy data: Used with permission from NEA – not for redistribution
- Meteorological data: Public domain (DHM, Nepal)

---

## 🙏 Acknowledgments

- **Nepal Electricity Authority (NEA)** for providing residential energy consumption data
- **Department of Hydrology and Meteorology (DHM), Nepal** for meteorological observations
- **United States Geological Survey (USGS)** for Landsat data
- **University of Alabama** for research support
- **Reviewers and editors** for valuable feedback

---

## 📚 Related Resources

- [Landsat 8 Data Users Handbook](https://www.usgs.gov/media/files/landsat-8-data-users-handbook)
- [USGS Landsat Level-2 Science Products](https://www.usgs.gov/landsat-missions/landsat-collection-2-level-2-science-products)
- [R for Data Science](https://r4ds.had.co.nz/)
- [Spatial Data Science with R](https://r-spatial.org/book/)

---

**Maintained by [Pawan Thapa](https://github.com/yourusername)** – Last updated: March 2026
```

---

## Additional Essential Files

### 1. `.gitignore`

Create this file to exclude unnecessary files:

```
# Data (raw, not to be shared)
data/raw/*
!data/raw/README.md

# Outputs (except those we want to track)
outputs/figures/temp/
outputs/tables/temp/

# R environment
.Rhistory
.RData
.Ruserdata
*.Rproj

# Python
__pycache__/
*.pyc
.env

# OS files
.DS_Store
Thumbs.db

# Large files (keep repo lean)
*.tif
*.tiff
*.zip
*.tar.gz
*.7z
```

### 2. `CITATION.cff`

```yaml
cff-version: 1.2.0
message: "If you use this software, please cite it as below."
authors:
  - family-names: "Thapa"
    given-names: "Pawan"
    orcid: "https://orcid.org/XXXX-XXXX-XXXX-XXXX"
title: "kathmandu-uhi-energy-nexus: Code and data for UHI-energy analysis in Nepal's Kathmandu Valley"
version: 1.0.0
doi: 10.5281/zenodo.XXXXXXX
date-released: 2025-03-08
url: "https://github.com/yourusername/kathmandu-uhi-energy-nexus"
repository-code: "https://github.com/yourusername/kathmandu-uhi-energy-nexus"
license: MIT
```

### 3. `data/processed/README.md`

```markdown
# Processed Data

This directory contains analysis-ready data generated from raw sources.

| File | Description | Format | Source |
|------|-------------|--------|--------|
| `lst_2014_2019.tif` | Land Surface Temperature (seasonal composites) | GeoTIFF, 30m | Landsat 8 |
| `ndvi_2014_2019.tif` | Normalized Difference Vegetation Index | GeoTIFF, 30m | Landsat 8 |
| `ndbi_2014_2019.tif` | Normalized Difference Built-up Index | GeoTIFF, 30m | Landsat 8 |
| `suhii_2014_2019.tif` | Surface Urban Heat Island Intensity | GeoTIFF, 30m | Calculated |
| `panel_data.csv` | District-year panel dataset | CSV | Aggregated |

**Panel Data Variables:**
- `district`: Kathmandu or Bhaktapur
- `year`: 2014, 2019
- `energy_gwh`: Residential electricity consumption (GWh)
- `suhii_mean`: Mean SUHII (°C)
- `ndbi_mean`: Mean NDBI
- `ndvi_mean`: Mean NDVI
- `cdd`: Cooling Degree Days
- `hdd`: Heating Degree Days
```

---

