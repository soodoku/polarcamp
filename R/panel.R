panel_code <- function(x, missing = TRUE) {
  if (is.factor(x) || is.character(x)) {
    labels <- as.character(x)
    valid <- is.na(labels) | grepl("^-?[0-9]+[.]", labels)
    if (!all(valid)) stop("Unexpected panel label")
    x <- as.numeric(sub("^(-?[0-9]+)[.].*$", "\\1", labels))
  }
  if (missing) x[x < 0] <- NA_real_
  x
}

panel_rating <- function(direction, like, dislike) {
  a <- panel_code(direction)
  b <- panel_code(like)
  c <- panel_code(dislike)
  if (any(!is.na(a) & !a %in% 1:3)) stop("Unexpected rating direction")
  z <- rep(NA_real_, length(a))
  z[which(a == 3)] <- 50
  i <- which(a == 1 & b %in% 1:3)
  z[i] <- 100 * (7 - b[i]) / 6
  i <- which(a == 2 & c %in% 1:3)
  z[i] <- 100 * (c[i] - 1) / 6
  z
}

panel_pid <- function(raw, wave) {
  stem <- paste0("w", wave, if (wave == 1) "m" else "l")
  first <- panel_code(raw[[paste0(stem, 1)]], FALSE)
  third <- panel_code(raw[[paste0(stem, 3)]], FALSE)
  strength <- panel_code(raw[[paste0(stem, 5)]], FALSE)
  lean <- panel_code(raw[[paste0(stem, 6)]], FALSE)
  a <- ifelse(first > 0, first, ifelse(third > 0, third, NA_real_))
  a[which((first == -1 & third == -7) | (first == -7 & third == -1))] <- -7
  z <- rep(NA_real_, nrow(raw))
  z[which(a == 1 & strength == 1)] <- 0
  z[which(a == 1 & strength == 2)] <- 1
  z[which(a %in% c(3, 4) & lean == 2)] <- 2
  z[which(a %in% c(3, 4) & lean == 3)] <- 3
  z[which(a == -7 & strength == -1 & lean == 3)] <- 3
  z[which(a %in% c(3, 4) & strength == -1 & lean == -7)] <- 3
  z[which(a %in% c(3, 4) & lean == 1)] <- 4
  z[which(a == -7 & strength == -1 & lean == 1)] <- 4
  z[which(a == 2 & strength == 2)] <- 5
  z[which(a == 2 & strength == 1)] <- 6
  if (wave == 9) {
    z[which(a == 1 & strength == -5 & lean == -6)] <- 1
    z[which(a == 4 & strength == -5 & lean == -5)] <- 3
    z[which(a == 2 & strength == -7 & lean == -1)] <- 5
  }
  stopifnot(identical(z, panel_code(raw[[paste0("der08w", wave)]])))
  z
}

read_panel <- function() {
  raw <- read_workspace("data/raw/nes08panel.Rdata", "nes08p")
  stopifnot(!anyDuplicated(raw$caseid))
  d <- data.frame(
    id = raw$caseid, stratum = panel_code(raw$stratum), cohort = panel_code(raw$reccohor),
    weight_original = raw$wgtc10, weight_late = raw$wgtl10,
    baseline_original = raw$wgtcs_w1, baseline_late = raw$wgtcs_w9,
    pid_original = panel_pid(raw, 1), pid_late = panel_pid(raw, 9)
  )
  starts <- c(dem_party = 2, rep_party = 5, dem_candidate = 38, rep_candidate = 14)
  for (wave in c(1, 2, 6, 9, 10)) {
    d[[paste0("date_", wave)]] <- as.Date(as.character(raw[[paste0("w", wave, "date")]]), "%Y%m%d")
    for (object in names(starts)) {
      stem <- paste0("w", wave, "e")
      j <- starts[[object]]
      d[[paste0(object, "_", wave)]] <- panel_rating(
        raw[[paste0(stem, j)]],
        raw[[paste0(stem, j + 1)]], raw[[paste0(stem, j + 2)]]
      )
    }
  }
  d
}

panel_estimate <- function(design, variable) {
  result <- survey::svymean(reformulate(variable), design, na.rm = TRUE)
  interval <- confint(result, df = survey::degf(design))
  data.frame(
    n = nrow(design$variables), estimate = unname(coef(result)),
    se = unname(survey::SE(result)), lower = interval[, 1], upper = interval[, 2]
  )
}

panel_results <- function(panel) {
  changes <- trajectories <- retention <- list()
  for (spec in c("original", "late")) {
    baseline <- if (spec == "original") 1 else 9
    pid <- panel[[paste0("pid_", spec)]]
    for (leaners in c(TRUE, FALSE)) {
      party <- ifelse(pid %in% if (leaners) 0:2 else 0:1, "Democrat",
        ifelse(pid %in% if (leaners) 4:6 else 5:6, "Republican", NA_character_)
      )
      for (target in c("party", "candidate")) {
        d <- panel
        for (wave in c(1, 2, 6, 9, 10)) {
          scores <- orient_candidates(
            d[[paste0("rep_", target, "_", wave)]],
            d[[paste0("dem_", target, "_", wave)]], party
          )
          for (measure in names(scores)) d[[paste0(measure, "_", wave)]] <- scores[[measure]]
        }
        d$weight <- d[[paste0("weight_", spec)]]
        d$eligible <- !is.na(party) & complete.cases(d[c(paste0("gap_", baseline), "gap_10")]) &
          !is.na(d$date_10) & d$date_10 < election_date(2008)
        for (measure in c("own", "other", "gap")) {
          d[[paste0("delta_", measure)]] <- d[[paste0(measure, "_10")]] - d[[paste0(measure, "_", baseline)]]
        }
        baseline_ok <- !is.na(party) & is.finite(d[[paste0("gap_", baseline)]]) &
          is.finite(d[[paste0("baseline_", spec)]]) & d[[paste0("baseline_", spec)]] > 0
        for (status in c("all_baseline", "retained", "not_retained")) {
          keep <- baseline_ok
          retained <- d$eligible & is.finite(d$weight) & d$weight > 0
          if (status == "retained") keep <- keep & retained
          if (status == "not_retained") keep <- keep & !retained
          retention[[length(retention) + 1L]] <- cbind(
            spec = spec, target = target, leaners = leaners,
            status = status, weighted_summary(
              d[[paste0("gap_", baseline)]][keep],
              d[[paste0("baseline_", spec)]][keep]
            )[c("n", "estimate")]
          )
        }
        design <- survey::svydesign(
          ids = ~1, strata = ~stratum, weights = ~weight,
          data = d[is.finite(d$weight) & d$weight > 0, ]
        )
        for (sample in c("paired", if (spec == "original") "five_wave" else "cohort2")) {
          design$variables$included <- design$variables$eligible
          if (sample == "five_wave") {
            design$variables$included <- design$variables$included &
              complete.cases(design$variables[paste0("gap_", c(1, 2, 6, 9, 10))])
          }
          if (sample == "cohort2") {
            design$variables$included <- design$variables$included &
              design$variables$cohort == 2
          }
          subdesign <- subset(design, included)
          for (measure in c("own", "other", "gap")) {
            changes[[length(changes) + 1L]] <- cbind(
              spec = spec, target = target, leaners = leaners,
              sample = sample, measure = measure, panel_estimate(subdesign, paste0("delta_", measure))
            )
          }
          if (sample == "five_wave" && leaners) {
            for (wave in c(1, 2, 6, 9, 10)) {
              trajectories[[length(trajectories) + 1L]] <- cbind(
                target = target, wave = wave,
                panel_estimate(subdesign, paste0("gap_", wave))
              )
            }
          }
        }
      }
    }
  }
  list(
    changes = do.call(rbind, changes), trajectories = do.call(rbind, trajectories),
    retention = do.call(rbind, retention), joint_changes = panel_joint_changes(panel)
  )
}

panel_joint_changes <- function(panel) {
  results <- list()
  for (spec in c("original", "late")) {
    baseline <- if (spec == "original") 1 else 9
    pid <- panel[[paste0("pid_", spec)]]
    for (leaners in c(TRUE, FALSE)) {
      party <- ifelse(pid %in% if (leaners) 0:2 else 0:1, "Democrat",
        ifelse(pid %in% if (leaners) 4:6 else 5:6, "Republican", NA_character_)
      )
      d <- panel
      for (target in c("candidate", "party")) {
        for (wave in c(baseline, 10)) {
          scores <- orient_candidates(
            d[[paste0("rep_", target, "_", wave)]],
            d[[paste0("dem_", target, "_", wave)]], party
          )
          d[[paste0(target, "_", wave)]] <- scores$gap
        }
        d[[paste0("delta_", target)]] <- d[[paste0(target, "_10")]] - d[[paste0(target, "_", baseline)]]
      }
      d$delta_difference <- d$delta_candidate - d$delta_party
      d$weight <- d[[paste0("weight_", spec)]]
      d$eligible <- !is.na(party) & is.finite(d$delta_difference) &
        !is.na(d$date_10) & d$date_10 < election_date(2008)
      design <- survey::svydesign(
        ids = ~1, strata = ~stratum, weights = ~weight,
        data = d[is.finite(d$weight) & d$weight > 0, ]
      )
      joint <- subset(design, eligible)
      for (measure in c("candidate", "party", "difference")) {
        results[[length(results) + 1L]] <- cbind(
          spec = spec, leaners = leaners, measure = measure,
          panel_estimate(joint, paste0("delta_", measure))
        )
      }
    }
  }
  do.call(rbind, results)
}
