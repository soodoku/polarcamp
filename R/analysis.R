weighted_summary <- function(x, weight) {
  ok <- is.finite(x) & is.finite(weight) & weight > 0
  x <- x[ok]
  weight <- weight[ok]
  n <- length(x)
  if (!n) {
    return(data.frame(n = 0, estimate = NA_real_, se = NA_real_, lower = NA_real_, upper = NA_real_))
  }
  normalized <- weight / sum(weight)
  estimate <- sum(x * normalized)
  se <- if (n > 1) sqrt(n / (n - 1) * sum((normalized * (x - estimate))^2)) else NA_real_
  margin <- if (n > 1) qt(.975, n - 1) * se else NA_real_
  data.frame(n = n, estimate = estimate, se = se, lower = estimate - margin, upper = estimate + margin)
}

contrast_interval <- function(model, contrast, data, method) {
  if (anyNA(coef(model))) stop("Rank-deficient model: revise supported covariates")
  if (method == "HC1") {
    variance <- sandwich::vcovHC(model, type = "HC1")
    df <- df.residual(model)
    clusters <- NA_integer_
  } else {
    group <- data[[method]]
    if (anyNA(group)) stop("Missing clustering identifier")
    clusters <- length(unique(group))
    if (clusters < 3) stop("Insufficient clusters")
    variance <- sandwich::vcovCL(model, cluster = group, type = "HC1", cadjust = TRUE)
    df <- clusters - 1
  }
  estimate <- sum(contrast * coef(model))
  contrast_variance <- drop(t(contrast) %*% variance %*% contrast)
  tolerance <- 100 * .Machine$double.eps * max(1, sum(abs(outer(contrast, contrast) * variance)))
  if (!is.finite(contrast_variance) || contrast_variance < -tolerance) {
    stop("Invalid contrast variance")
  }
  se <- sqrt(max(0, contrast_variance))
  margin <- qt(.975, df) * se
  data.frame(
    estimate = estimate, se = se, lower = estimate - margin, upper = estimate + margin,
    n = nobs(model), clusters = clusters, inference = method
  )
}

period_contrast <- function(d, outcome, adjusted = FALSE, weighted = TRUE) {
  d$y <- d[[outcome]]
  d$late <- as.integer(d$days_before <= 14 & d$days_before >= 1)
  autumn_start <- as.Date(paste0(format(d$date + d$days_before, "%Y"), "-09-01"))
  early <- d$date >= autumn_start & d$date <= autumn_start + 13
  target <- d[d$date >= autumn_start & d$days_before > 0, ]
  d <- d[early | d$late == 1, ]
  variables <- c("y", "weight", "state", "date")
  covariates <- c("age", "female", "black", "hispanic", "education", "party")
  if (adjusted) variables <- c(variables, covariates)
  d <- d[complete.cases(d[variables]), ]
  d$w <- if (weighted) d$weight else rep(1, nrow(d))
  target <- target[complete.cases(target[variables]), ]
  target$w <- if (weighted) target$weight else rep(1, nrow(target))
  if (!all(c(0, 1) %in% d$late)) stop("Both comparison periods must be observed")
  formula <- if (adjusted) {
    y ~ late * (age + female + black + hispanic + education + party)
  } else {
    y ~ late
  }
  model <- lm(formula, data = d, weights = w, na.action = na.fail)
  early_data <- late_data <- target
  early_data$late <- 0
  late_data$late <- 1
  terms <- delete.response(terms(model))
  difference <- model.matrix(terms, late_data) - model.matrix(terms, early_data)
  contrast <- colSums(difference * target$w) / sum(target$w)
  result <- do.call(rbind, lapply(c("state", "date", "HC1"), function(method) {
    contrast_interval(model, contrast, d, method)
  }))
  result$early_mean <- weighted.mean(d$y[d$late == 0], d$w[d$late == 0])
  result$late_mean <- weighted.mean(d$y[d$late == 1], d$w[d$late == 1])
  result$early_n <- sum(d$late == 0)
  result$late_n <- sum(d$late == 1)
  result$target_n <- nrow(target)
  result$adjusted <- adjusted
  result$weighted <- weighted && any(d$w != 1)
  result$outcome <- outcome
  result
}

survey_results <- function(survey) {
  outcomes <- c("own_fav", "other_fav", "gap_fav", "own_trait", "other_trait", "gap_trait")
  survey <- survey[survey$days_before > 0 & format(survey$date, "%Y") == survey$year & !is.na(survey$party), ]
  survey$week <- -7 * ceiling(survey$days_before / 7)
  weekly <- list()
  ideology_weekly <- list()
  availability <- list()
  contrasts <- list()
  slopes <- list()
  sensitivity <- list()
  composition <- list()
  distributions <- list()
  for (year in unique(survey$year)) {
    d <- survey[survey$year == year, ]
    for (week in sort(unique(d$week))) {
      z <- d[d$week == week, ]
      for (outcome in c(outcomes, "own_ideology", "other_ideology", "own_distance", "other_distance")) {
        weekly[[length(weekly) + 1L]] <- cbind(
          year = year, week = week, outcome = outcome,
          weighted_summary(z[[outcome]], z$weight)
        )
      }
      for (party in c("Republican", "Democrat")) {
        by_party <- z[z$party == party, ]
        for (outcome in c("own_ideology", "other_ideology", "own_distance", "other_distance")) {
          ideology_weekly[[length(ideology_weekly) + 1L]] <- cbind(
            year = year, week = week, party = party, outcome = outcome,
            weighted_summary(by_party[[outcome]], by_party$weight)
          )
        }
      }
      availability[[length(availability) + 1L]] <- data.frame(
        year = year, week = week, n = nrow(z),
        favorability = mean(is.finite(z$gap_fav)), traits = mean(is.finite(z$gap_trait)),
        ideology = mean(is.finite(z$ideology_gap)), complete_traits = mean(z$trait_items == z$trait_total)
      )
    }
    d$sum_fav <- d$own_fav + d$other_fav
    d$sum_trait <- d$own_trait + d$other_trait
    for (outcome in c(outcomes, "sum_fav", "sum_trait")) {
      for (adjusted in c(FALSE, TRUE)) {
        contrasts[[length(contrasts) + 1L]] <- cbind(year = year, period_contrast(d, outcome, adjusted))
      }
    }
    for (scheme in c("weight1", "weight2")) {
      z <- d[is.finite(d[[scheme]]) & d[[scheme]] > 0, ]
      z$weight <- z[[scheme]]
      for (outcome in c("gap_fav", "gap_trait")) {
        for (weighted in c(FALSE, TRUE)) {
          sensitivity[[length(sensitivity) + 1L]] <- cbind(
            year = year, scheme = scheme, period_contrast(z, outcome, weighted = weighted)
          )
        }
      }
    }
    for (outcome in c("gap_fav", "gap_trait", paste0("trait_", seq_len(d$trait_total[1])))) {
      z <- if (outcome == "gap_trait") d[d$trait_items == d$trait_total, ] else d
      sensitivity[[length(sensitivity) + 1L]] <- cbind(
        year = year, scheme = if (outcome == "gap_trait") "complete_traits" else "item",
        period_contrast(z, outcome)
      )
    }
    for (period in c("early", "late")) {
      z <- if (period == "early") {
        early <- format(d$date, "%m-%d") >= "09-01" & format(d$date, "%m-%d") <= "09-14"
        d[early, ]
      } else {
        d[d$days_before <= 14, ]
      }
      z$democrat <- as.numeric(z$party == "Democrat")
      for (v in c("age", "female", "black", "hispanic", "education", "democrat")) {
        composition[[length(composition) + 1L]] <- cbind(
          year = year, period = period, variable = v,
          weighted_summary(z[[v]], z$weight)
        )
      }
      for (outcome in outcomes) {
        x <- z[[outcome]]
        distributions[[length(distributions) + 1L]] <- cbind(
          year = year, period = period, outcome = outcome,
          distribution_summary(x, if (startsWith(outcome, "gap_")) -100 else 0)
        )
      }
    }
    for (outcome in c("gap_fav", "gap_trait")) {
      d$y <- d[[outcome]]
      z <- d[complete.cases(d[c("y", "state", "date", "battleground")]), ]
      z$time <- -z$days_before / 100
      model <- lm(y ~ time * battleground, data = z, weights = weight)
      contrast <- setNames(rep(0, length(coef(model))), names(coef(model)))
      contrast["time:battleground"] <- 1
      slopes[[length(slopes) + 1L]] <- cbind(
        year = year, outcome = outcome,
        contrast_interval(model, contrast, z, "state")
      )
    }
  }
  list(
    weekly = do.call(rbind, weekly), ideology_weekly = do.call(rbind, ideology_weekly),
    availability = do.call(rbind, availability),
    changes = do.call(rbind, contrasts), battleground = do.call(rbind, slopes),
    sensitivity = do.call(rbind, sensitivity), composition = do.call(rbind, composition),
    distributions = do.call(rbind, distributions)
  )
}

distribution_summary <- function(x, lower_bound = 0) {
  observed <- x[is.finite(x)]
  data.frame(
    n = length(observed), missing = mean(!is.finite(x)),
    zero = mean(abs(observed) < 1e-8),
    floor = mean(abs(observed - lower_bound) < 1e-8),
    ceiling = mean(abs(observed - 100) < 1e-8), sd = sd(observed)
  )
}
