#' Proportional Allocation
#'
#' @param total Scalar numeric. The total value to allocate.
#' @param weights Numeric vector of weights. NA values are automatically treated as zero.
#' @param digits Integer. Number of decimal places to round to. Default is NULL (no rounding).
#' @param adjust Character or Logical. Adjustment method for total sum consistency:
#'   `"each"` (default) distributes the difference 1 unit by 1 unit based on remainders;
#'   `"max"` allocates the entire difference to the element with the largest absolute value;
#'   `"none"` performs no adjustment. `TRUE` maps to `"each"` and `FALSE` maps to `"none"`.
#'
#' @return A numeric vector of allocated values.
#' @export
prorate <- function(total, weights, digits = NULL, adjust = c("each", "max", "none")) {
  # 1. Handle missing values in weights
  weights[is.na(weights)] <- 0

  # 2. Input validation
  if (sum(weights) == 0) {
    stop("The sum of 'weights' cannot be zero.")
  }

  # If total is a vector, ensure all elements are identical
  if (length(total) > 1) {
    if (length(unique(total)) == 1) {
      total <- total[1]
    } else {
      stop("'total' must be a single value or contain identical values within the allocation group.")
    }
  }

  if (is.na(total)) {
    stop("'total' must be a non-NA numeric value.")
  }

  if (!is.null(digits) && (digits %% 1 != 0)) {
    stop("'digits' must be a whole number (e.g., 0, 1, 2).")
  }

  # Convert logical input and match argument
  if (is.logical(adjust)) {
    adjust <- if (adjust) "each" else "none"
  }
  adjust <- match.arg(adjust)

  if (adjust != "none" && is.null(digits)) {
    stop("'digits' must be specified when adjustment is enabled.")
  }

  n <- length(weights)
  if (n == 0) return(numeric(0))

  # 3. Base proportional allocation (Raw exact values)
  allocated_raw <- total * (weights / sum(weights))

  # 4. Rounding and sum adjustment
  if (!is.null(digits)) {
    rounded <- round(allocated_raw, digits)

    if (adjust != "none") {
      target_total <- round(total, digits)
      diff         <- target_total - sum(rounded)
      step         <- 10^(-digits)

      # Handle actual rounding differences, ignoring floating-point noise
      if (abs(diff) > 1e-9) {
        if (adjust == "each") {
          # Distribute the difference 1 unit by 1 unit based on remainders
          n_steps    <- round(abs(diff) / step)
          remainders <- allocated_raw - rounded
          idx_order  <- if (diff > 0) order(remainders, decreasing = TRUE) else order(remainders, decreasing = FALSE)

          for (i in idx_order) {
            if (n_steps == 0) break
            rounded[i] <- rounded[i] + sign(diff) * step
            n_steps    <- n_steps - 1
          }
        } else if (adjust == "max") {
          # Allocate the entire difference to the largest element
          max_idx          <- which.max(abs(allocated_raw))
          rounded[max_idx] <- rounded[max_idx] + diff
        }
      }
    }
    allocated <- rounded
  } else {
    allocated <- allocated_raw
  }

  return(allocated)
}
