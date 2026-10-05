candidate_pool_2008 <- function(raw = read_workspace("data/raw/naes08.rdata", "naes08")) {
  mapping <- data.frame(
    candidate = c("Obama", "Clinton", "Edwards", "McCain", "Romney", "Huckabee", "Giuliani", "Thompson", "Paul"),
    party = c(rep("Democrat", 3), rep("Republican", 6)),
    variable = c("abo01", "abc01", "abe01", "aam01", "aar01", "aah01", "aag01", "aat01", "aau01")
  )
  dates <- as.Date(as.character(raw$cdatestr), "%Y%m%d")
  keep <- dates >= as.Date("2008-01-01") & dates < election_date(2008) &
    !is.na(raw$pid3) & raw$pid3 %in% c("Democrat", "Republican")
  raw <- raw[keep, ]
  dates <- dates[keep]
  weeks <- -7 * ceiling(as.numeric(election_date(2008) - dates) / 7)
  output <- coverage <- list()
  for (j in seq_len(nrow(mapping))) {
    rating <- 10 * numeric_response(raw[[mapping$variable[j]]], 0:10, c(998, 999))
    valid <- is.finite(rating)
    stopifnot(any(valid))
    coverage[[j]] <- data.frame(
      candidate = mapping$candidate[j], party = mapping$party[j], variable = mapping$variable[j],
      first_rating = min(dates[valid]), last_rating = max(dates[valid]), n = sum(valid)
    )
    side <- ifelse(raw$pid3 == mapping$party[j], "Own-party respondents", "Opposing-party respondents")
    for (week in sort(unique(weeks))) {
      for (group in c("Own-party respondents", "Opposing-party respondents")) {
        ii <- weeks == week & side == group
        output[[length(output) + 1L]] <- cbind(
          candidate = mapping$candidate[j], party = mapping$party[j], week = week,
          group = group, eligible = sum(ii), weighted_summary(rating[ii], rep(1, sum(ii)))
        )
      }
    }
  }
  list(weekly = do.call(rbind, output), coverage = do.call(rbind, coverage))
}
