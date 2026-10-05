test_that("paired uncertainty uses within-person changes", {
  baseline <- c(10, 40, 70, 90)
  end <- baseline + c(1, 3, 5, 7)
  result <- weighted_summary(end - baseline, rep(1, 4))
  expect_equal(result$estimate, 4)
  expect_equal(result$se, sd(c(1, 3, 5, 7)) / 2)
  expect_equal(weighted_summary(c(0, 100), c(1, 3))$estimate, 75)
  expect_true(is.na(weighted_summary(NA_real_, 1)$estimate))
})

test_that("distribution masses tolerate arithmetic noise without rounding real changes", {
  x <- c(0, 1e-14, 1, -100, 100, 100 - 1e-14, NA)
  result <- distribution_summary(x, -100)
  expect_equal(result$n, 6L)
  expect_equal(result$missing, 1 / 7)
  expect_equal(result$zero, 2 / 6)
  expect_equal(result$floor, 1 / 6)
  expect_equal(result$ceiling, 2 / 6)
})

test_that("joint panel changes use identical people and retain covariance", {
  d <- data.frame(
    stratum = 1, pid_original = rep(0, 5), pid_late = rep(0, 5),
    weight_original = 1, weight_late = 1, date_10 = as.Date("2008-10-20")
  )
  for (wave in c(1, 9, 10)) {
    d[[paste0("rep_candidate_", wave)]] <- 20
    d[[paste0("rep_party_", wave)]] <- 20
    d[[paste0("dem_candidate_", wave)]] <- 50
    d[[paste0("dem_party_", wave)]] <- 50
  }
  d$dem_candidate_10 <- 50 + c(2, 6, 10, 14, 40)
  d$dem_party_10 <- 50 + c(1, 3, 5, 7, NA)
  result <- panel_joint_changes(d)
  difference <- subset(result, spec == "original" & leaners & measure == "difference")
  expect_equal(difference$n, 4L)
  expect_equal(difference$estimate, 4)
  residuals <- c(-3, -1, 1, 3, 0)
  expect_equal(difference$se, sqrt(5 / 4 * sum(residuals^2) / 4^2))
  d$date_10[4] <- election_date(2008)
  result <- panel_joint_changes(d)
  expect_true(all(result$n == 3L))
})

test_that("period contrast estimates late minus early with state clustering", {
  d <- expand.grid(state = LETTERS[1:5], period = c(0, 1), day = 1:8)
  d$date <- as.Date(ifelse(d$period == 0, "2004-09-01", "2004-10-19")) + d$day - 1
  d$days_before <- as.integer(election_date(2004) - d$date)
  d$weight <- 1
  d$y <- 20 + 4 * d$period + as.integer(d$state)
  result <- period_contrast(d, "y")
  expect_equal(result$estimate, rep(4, 3), tolerance = 1e-10)
  expect_equal(result$clusters[1], 5)
  expect_true(all(is.finite(result$se)))
  expect_equal(result$se[1:2], c(0, 0), tolerance = 1e-7)
  expect_equal(result$early_n, rep(40L, 3))
})

test_that("prior-year autumn observations never enter the election-year target", {
  d <- expand.grid(state = LETTERS[1:5], period = c(0, 1), day = 1:8)
  d$date <- as.Date(ifelse(d$period == 0, "2004-09-01", "2004-10-19")) + d$day - 1
  d$weight <- 1
  d$y <- 20 + 4 * d$period + as.integer(d$state)
  prior <- d
  prior$date <- prior$date - 366
  prior$y <- 100
  d <- rbind(d, prior)
  d$days_before <- as.integer(election_date(2004) - d$date)
  result <- period_contrast(d, "y")
  expect_equal(result$target_n, rep(80L, 3))
  expect_equal(result$n, rep(80L, 3))
  expect_equal(result$estimate, rep(4, 3), tolerance = 1e-10)
})

test_that("candidate field diagnostics preserve candidate-specific coverage and missing periods", {
  d <- data.frame(
    cdatestr = c(20080103, 20080104, 20080111, 20080112, 20080118, 20080119),
    pid3 = rep(c("Democrat", "Republican"), 3)
  )
  for (v in c("abo01", "abc01", "abe01", "aam01", "aar01", "aah01", "aag01", "aat01", "aau01")) d[[v]] <- 5
  d$aau01[3:6] <- c(998, 999, NA, NA)
  d$aam01 <- 8
  result <- candidate_pool_2008(d)
  paul <- subset(result$coverage, candidate == "Paul")
  expect_equal(paul$n, 2L)
  expect_equal(paul$last_rating, as.Date("2008-01-04"))
  missing <- subset(result$weekly, candidate == "Paul" & n == 0)
  expect_equal(nrow(missing), 4L)
  expect_true(all(is.na(missing$estimate)))
  expect_true(all(subset(result$weekly, candidate == "McCain")$estimate == 80))
  expect_equal(sum(subset(result$weekly, candidate == "Paul")$n), 2L)
})
