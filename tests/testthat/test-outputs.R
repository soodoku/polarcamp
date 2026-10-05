test_that("manuscript macros select exactly one intended result", {
  naes <- data.frame(
    year = c(2000, 2004, 2008), outcome = "gap_fav", inference = "state",
    adjusted = FALSE, estimate = 1:3, lower = 0:2, upper = 2:4
  )
  r <- list(naes = list(changes = naes))
  macros <- result_macros(r)
  expect_length(macros, 6)
  expect_true("\\newcommand{\\FavFour}{2.0}" %in% macros)
  r$naes$changes <- rbind(naes, naes[1, ])
  expect_error(result_macros(r))
})

test_that("experiment contrasts balance arms, preserve missingness, and reject invalid inputs", {
  arm <- rep(1:7, times = 3:9)
  d <- data.frame(
    caseid = seq_along(arm), treat_s2 = arm, Q21a = 10 * arm + seq_along(arm) %% 7,
    Q21b = 0, Q21e = 10 * arm + seq_along(arm) %% 3, Q21f = 0
  )
  d$Q21a[1] <- 998
  result <- experiment_results(d, d)
  cell <- subset(result$cells, sample == "selected" & outcome == "party" & arm == "1")
  expect_equal(cell$missing, 1)
  expect_equal(cell$n, 2)
  means <- tapply(d$Q21a, arm, mean)
  vars <- tapply(d$Q21a, arm, var)
  sizes <- table(arm)
  expected <- mean(means[4:5]) - mean(means[2:3])
  expected_se <- sqrt(sum(.25 * vars[2:5] / sizes[2:5]))
  contrast <- subset(
    result$contrasts, sample == "selected" & outcome == "party" &
      comparison == "negative_minus_positive"
  )
  expect_equal(contrast$estimate, expected, tolerance = 1e-10)
  expect_equal(contrast$se, unname(expected_se), tolerance = 1e-10)
  control <- subset(
    result$contrasts, sample == "selected" & outcome == "party" &
      comparison == "negative_minus_control"
  )
  clean <- d$Q21a
  clean[clean == 998] <- NA
  means <- tapply(clean, arm, mean, na.rm = TRUE)
  vars <- tapply(clean, arm, var, na.rm = TRUE)
  sizes <- tapply(!is.na(clean), arm, sum)
  expect_equal(control$estimate, unname(mean(means[4:5]) - means[1]))
  expect_equal(control$se, unname(sqrt(sum(.25 * vars[4:5] / sizes[4:5]) + vars[1] / sizes[1])))
  d$treat_s2[1] <- 8
  expect_error(experiment_results(d, d))
})

test_that("source verification rejects changed and missing data", {
  root <- tempfile()
  dir.create(root)
  withr::defer(unlink(root, recursive = TRUE))
  withr::local_dir(root)
  dir.create("docs")
  writeLines("authorized input", "source.txt")
  write.csv(data.frame(path = "source.txt", sha256 = digest::digest(file = "source.txt", algo = "sha256")),
    "docs/sources.csv",
    row.names = FALSE
  )
  expect_true(verify_sources())
  writeLines("different input", "source.txt")
  expect_error(verify_sources(), "checksum changed")
  unlink("source.txt")
  expect_error(verify_sources(), "Missing authorized source")
})
