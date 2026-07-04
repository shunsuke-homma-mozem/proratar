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

You can install the official released version of **proratar** from CRAN:

```r
install.packages("proratar")
```

## Quick Start

```r
library(proratar)
library(dplyr)

# Sample dataframe
df <- data.frame(
    name = c("A", "B", "C", "D", "E"),
    vec_value = c(1, 2, 3, 4, 13)
  )

# Allocate target value(100) in proportion to vec_value
df_allocated <- df |> 
  mutate(
    no_adjust = prorate(total = 100, weights = vec_value, digits = 1, adjust = "none"),
    each_adjust = prorate(total = 100, weights = vec_value, digits = 1, adjust = "each"),
    max_adjust = prorate(total = 100, weights = vec_value, digits = 1, adjust = "max"),
    integer = prorate_int(total = 100, weights = vec_value, adjust = "each")
  )

print(df_allocated)
#   name vec_value no_adjust each_adjust max_adjust integer
# 1    A         1       4.3         4.4        4.3       4
# 2    B         2       8.7         8.7        8.7       9
# 3    C         3      13.0        13.0       13.0      13
# 4    D         4      17.4        17.4       17.4      17
# 5    E        13      56.5        56.5       56.6      57
```
