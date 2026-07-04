#' Integer Proportional Allocation
#'
#' @param total Scalar numeric or integer. The total value to allocate. Must be a whole number.
#' @param weights Numeric vector of weights. NA values are automatically treated as zero.
#' @param adjust Character or Logical. Adjustment method for total sum consistency:
#'   `"each"` (default) distributes the difference 1 unit by 1 unit based on remainders (Largest Remainder Method);
#'   `"max"` allocates the entire difference to the element with the largest absolute value;
#'   `"none"` performs no adjustment. `TRUE` maps to `"each"` and `FALSE` maps to `"none"`.
#'
#' @return An integer vector of allocated values summing exactly to `total`.
#' @export
prorate_int <- function(total, weights, adjust = c("each", "max", "none")) {
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
    stop("'total' must be a single non-NA value.")
  }

  if (total %% 1 != 0) {
    stop("'total' must be a whole number. Please round or floor 'total' explicitly beforehand.")
  }

  # Convert logical input and match argument
  if (is.logical(adjust)) {
    adjust <- if (adjust) "each" else "none"
  }
  adjust <- match.arg(adjust)

  total <- as.integer(total)
  n <- length(weights)
  if (n == 0) return(integer(0))

  # 3. Base allocation using floor() to guarantee base integer slots
  allocated_raw <- total * (weights / sum(weights))
  floored       <- floor(allocated_raw)

  # 4. Calculate the remaining integer difference
  diff <- total - sum(floored)

  # 5. Distribute the difference based on the selected method
  if (diff != 0 && adjust != "none") {
    if (diff > 0) {
      if (adjust == "each") {
        # Largest Remainder Method (Hamilton method)
        remainders <- allocated_raw - floored
        idx_order  <- order(remainders, decreasing = TRUE)
        for (i in idx_order) {
          if (diff == 0) break
          floored[i] <- floored[i] + 1
          diff       <- diff - 1
        }
      } else if (adjust == "max") {
        # Allocate the entire difference to the largest element
        max_idx          <- which.max(abs(allocated_raw))
        floored[max_idx] <- floored[max_idx] + diff
      }
    }
  }

  # 6. Final type casting and return
  allocated <- as.integer(floored)
  return(allocated)
}
