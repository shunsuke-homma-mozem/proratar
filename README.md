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
    group = c("A", "A", "A", "A", "A", "B", "B"),
    vec_value = c(1, 2, 3, 4, 13, 1, 3),
    target_value = c(100, 100, 100, 100, 100, 200, 200)
  )

# Allocate target value(100) in proportion to vec_value
df_allocated <- df |> 
  group_by(group) |> 
  mutate(
    no_adjust = prorate(total = target_value, weights = vec_value, digits = 1, adjust = "none"),
    each_adjust = prorate(total = target_value, weights = vec_value, digits = 1, adjust = "each"),
    max_adjust = prorate(total = target_value, weights = vec_value, digits = 1, adjust = "max"),
    integer = prorate_int(total = target_value, weights = vec_value, adjust = "each")
  )

print(df_allocated)
#   group vec_value target_value no_adjust each_adjust max_adjust integer
#   <chr>     <dbl>        <dbl>     <dbl>       <dbl>      <dbl>   <int>
# 1 A             1          100       4.3         4.4        4.3       4
# 2 A             2          100       8.7         8.7        8.7       9
# 3 A             3          100      13          13         13        13
# 4 A             4          100      17.4        17.4       17.4      17
# 5 A            13          100      56.5        56.5       56.6      57
# 6 B             1          200      50          50         50        50
# 7 B             3          200     150         150        150       150
```
