test_that("election anchors and exposure windows use calendar days", {
  expect_equal(election_date(c(2000, 2004, 2008)), as.Date(c("2000-11-07", "2004-11-02", "2008-11-04")))
  expect_error(election_date(2012), "Unsupported")
  dates <- as.Date("2000-11-07") + c(-31, -30, -1, 0, 1, NA)
  expect_equal(prior_window(dates, as.Date("2000-11-07")), c(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE))
})

test_that("labels retain meaning when factor levels move", {
  x <- factor(c("liberal", "very conservative", "dont know"), levels = c("dont know", "liberal", "very conservative"))
  expect_equal(ideology_response(x), c(75, 0, NA))
  expect_equal(ideology_response(c(1, 5, 998)), c(0, 100, NA))
  expect_error(ideology_response(factor("unknown")), "Unexpected")
  expect_error(numeric_response(factor(c(1, 2)), 1:2), "Decode")
  expect_equal(trait_response(c(0, 10, 998), 2004, TRUE), c(100, 0, NA))
})

test_that("traits compare the same items and preserve empty rows", {
  rep <- matrix(c(100, 0, NA, 80, NA, NA), nrow = 3)
  dem <- matrix(c(20, 0, NA, NA, 100, NA), nrow = 3)
  z <- paired_traits(rep, dem, c("Republican", "Democrat", "Republican"))
  expect_equal(z$items, c(1, 1, 0))
  expect_equal(z$gap, c(80, 0, NA))
  expect_equal(orient_candidates(c(90, 90), c(10, 10), c("Democrat", NA))$gap, c(-80, NA))
})

test_that("geographic matching cannot multiply respondents or invent zero exposure", {
  r <- data.frame(id = 1:3, dma = c(1, 1, 2), date = as.Date("2000-10-01"))
  a <- data.frame(dma = 1, date = as.Date("2000-10-01"), total = 10, negative = 4)
  expect_equal(nrow(join_exposure(r, a)), 3)
  expect_equal(join_exposure(r, a)$total, c(10, 10, NA))
  expect_error(join_exposure(r, rbind(a, a)), "Ambiguous")
  a$negative <- 11
  expect_error(join_exposure(r, a), "Invalid")
})

test_that("panel branches decode codes, skip unused intensities, and orient consistently", {
  labels <- factor(c("3. Neither", "1. Like", "2. Dislike", "-9. Refused"))
  expect_equal(panel_rating(labels, c(NA, 1, NA, NA), c(NA, NA, 3, NA)), c(50, 100, 100 / 3, NA))
  expect_equal(panel_rating(c(1, 2), c(NA, 1), c(1, NA)), c(NA_real_, NA_real_))
  expect_equal(panel_code(factor(c("5. Republican", "0. Democrat", "-7. Missing"))), c(5, 0, NA))
})
