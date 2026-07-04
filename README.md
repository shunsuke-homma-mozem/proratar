# proratar <img src="https://www.r-project.org/logo/Rlogo.svg" align="right" height="40" />

[![CRAN status](https://www.r-pkg.org/badges/version/proratar)](https://CRAN.R-project.org/package=proratar)
[![CRAN Downloads](https://cranlogs.r-pkg.org/badges/last-month/proratar)](https://CRAN.R-project.org/package=proratar)

## Overview
**proratar** is an R package designed for robust, sum-consistent proportional allocation of numeric values.

### Key Features
* **Two Adjustment Methods**: 
  * `each`: The Largest Remainder Method (Hamilton method) for mathematically unbiased allocation.
  * `max`: Max-Value Adjustment to align discrepancies into the largest component—simulating traditional spreadsheet (Excel) business conventions.
* **Production-Grade Guardrails**: Comprehensive internal validation for `NA`, `NaN`, zero divisions, and vector length mismatches. 
* **Tidyverse Seamless Integration**: Native design optimized to work inside `dplyr::mutate()` pipelines across grouped dataframes.

## Installation

You can install the official released version of **proratar** directly from CRAN:

```r
install.packages("proratar")
