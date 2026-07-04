test_that("prorate() works with different adjustment methods", {
  w <- c(100, 4, 3)

  # Default (each) / Largest Remainder Method
  expect_equal(prorate(10, w, digits = 0, adjust = "each"), c(9, 1, 0))

  # Max adjustment
  expect_equal(prorate(10, w, digits = 0, adjust = "max"), c(10, 0, 0))

  # No adjustment
  expect_equal(prorate(10, w, digits = 0, adjust = "none"), c(9, 0, 0))
})

test_that("prorate_int() handles negative values and weights correctly", {
  # Negative total and mixed weights allocation
  expect_equal(prorate_int(-100, c(1, 2, -0.5), adjust = "each"), c(-40, -80, 20))
})

test_that("Input validation guards catch edge cases safely", {
  # Guardrail: Non-integer digits
  expect_error(prorate(100, c(1, 2), digits = 1.5))

  # Guardrail: Non-integer total in prorate_int
  expect_error(prorate_int(100.5, c(1, 2)))

  # Guardrail: Zero weight sum
  expect_error(prorate(100, c(10, -10)))

  # Guardrail: Vector total inconsistency
  expect_error(prorate(c(100, 200), c(1, 2)))
})
