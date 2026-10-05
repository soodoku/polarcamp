experiment_results <- function(
  all = as.data.frame(haven::read_sav("data/raw/CCAP_STAN_all_rand2.sav")),
  selected = read.csv("data/raw/CCAP_STAN_OUTPUT.CSV")
) {
  stopifnot(
    !anyNA(all$caseid), !anyNA(selected$caseid),
    all(all$treat_s2 %in% 1:7), all(selected$treat_s2 %in% 1:7)
  )
  stopifnot(!anyDuplicated(all$caseid), !anyDuplicated(selected$caseid), all(selected$caseid %in% all$caseid))
  cells <- contrasts <- list()
  for (sample in c("selected", "available")) {
    d <- if (sample == "selected") selected else all
    d$arm <- factor(as.numeric(d$treat_s2), levels = 1:7)
    for (variable in c("Q21a", "Q21b", "Q21e", "Q21f")) {
      d[[variable]] <- numeric_response(as.numeric(d[[variable]]), 0:100, c(998, 999))
    }
    d$party <- abs(d$Q21a - d$Q21b)
    d$candidate <- abs(d$Q21e - d$Q21f)
    for (outcome in c("party", "candidate")) {
      d$y <- d[[outcome]]
      for (arm in levels(d$arm)) {
        x <- d$y[d$arm == arm]
        cells[[length(cells) + 1L]] <- cbind(
          sample = sample, outcome = outcome, arm = arm,
          available = length(x), missing = sum(is.na(x)), weighted_summary(x, rep(1, length(x)))
        )
      }
      z <- d[is.finite(d$y), ]
      if (any(table(z$arm) < 2)) stop("Each arm needs at least two usable outcomes")
      model <- lm(y ~ 0 + arm, data = z)
      variance <- sandwich::vcovHC(model, type = "HC2")
      for (comparison in c("negative_minus_positive", "negative_minus_control", paste0("arm", 2:7, "_minus_control"))) {
        contrast <- numeric(7)
        if (comparison == "negative_minus_positive") {
          contrast[2:5] <- c(-.5, -.5, .5, .5)
        } else if (comparison == "negative_minus_control") {
          contrast[c(1, 4, 5)] <- c(-1, .5, .5)
        } else {
          contrast[1] <- -1
          contrast[as.integer(substr(comparison, 4, 4))] <- 1
        }
        estimate <- sum(contrast * coef(model))
        se <- sqrt(drop(t(contrast) %*% variance %*% contrast))
        contrasts[[length(contrasts) + 1L]] <- data.frame(
          sample = sample, outcome = outcome,
          comparison = comparison, estimate = estimate, se = se,
          lower = estimate - qnorm(.975) * se, upper = estimate + qnorm(.975) * se,
          p = 2 * pnorm(-abs(estimate / se))
        )
      }
    }
  }
  contrasts <- do.call(rbind, contrasts)
  contrasts$p_holm <- ave(contrasts$p, contrasts$sample, FUN = function(p) p.adjust(p, "holm"))
  list(cells = do.call(rbind, cells), contrasts = contrasts)
}
