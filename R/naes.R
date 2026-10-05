read_naes <- function(year, leaners = FALSE) {
  suffix <- substr(as.character(year), 3, 4)
  raw <- read_workspace(paste0("data/raw/naes", suffix, ".rdata"), paste0("naes", suffix))
  ids <- c(`2000` = "unique.id", `2004` = "ckey", `2008` = "rkey")
  party <- as.character(raw$pid3)
  party[!party %in% c("Republican", "Democrat")] <- NA_character_
  if (year == 2000) {
    original <- label_response(
      raw$cv01, c(republican = 1, democrat = 2),
      c("independent", "verbatim", "dont know", "no answer")
    )
    stopifnot(identical(party, ifelse(original == 1, "Republican", ifelse(original == 2, "Democrat", NA))))
  }
  if (leaners) {
    party <- ifelse(raw$pid7 %in% 1:3, "Republican",
      ifelse(raw$pid7 %in% 5:7, "Democrat", NA_character_)
    )
  }
  d <- data.frame(
    id = as.character(raw[[ids[as.character(year)]]]), year = year,
    date = as.Date(as.character(raw$cdatestr), "%Y%m%d"), state = toupper(raw$state),
    party = party, age = raw$age, female = as.numeric(as.character(raw$female) == "female"),
    black = raw$black, hispanic = raw$hispanic, education = raw$edu,
    weight = 1, weight1 = raw$weight1, weight2 = raw$weight2
  )
  stopifnot(!anyDuplicated(d$id), !anyNA(d$date), !anyNA(d$id))
  d$days_before <- as.integer(election_date(year) - d$date)
  battlegrounds <- list(
    `2000` = c("FL", "IA", "MO", "MN", "NH", "NM", "NV", "OH", "OR", "PA", "WI", "TN"),
    `2004` = c("FL", "IA", "MO", "MN", "NH", "NM", "NV", "OH", "OR", "PA", "WI"),
    `2008` = c("CO", "FL", "IA", "MI", "MN", "NC", "NM", "NH", "NV", "OH", "OR", "PA", "WI", "WV")
  )
  d$battleground <- as.integer(d$state %in% battlegrounds[[as.character(year)]])
  fields <- switch(as.character(year),
    `2000` = list(
      fav = c("ca01", "ca11"), rep = paste0("ca0", 2:5), dem = paste0("ca", 12:15),
      ideology = c("ca09", "ca19", "cv04"), missing = c(101, 102, 999), max = 100
    ),
    `2004` = list(
      fav = c("caa01", "cab01"), rep = paste0("caa", c("04", "05", "06", "07", "09", "10")),
      dem = paste0("cab", c("02", "03", "04", "05", "07", "08")),
      ideology = c("caa30", "cab27", "cma06"), missing = c(11, 12, 999), max = 10
    ),
    `2008` = list(
      fav = c("aam01", "abo01"), rep = paste0("aam0", 5:8), dem = paste0("abo0", 5:8),
      ideology = c("aam04", "abo04", "ma04"), missing = c(998, 999), max = 10
    )
  )
  fav <- lapply(fields$fav, function(v) 100 / fields$max * numeric_response(raw[[v]], 0:fields$max, fields$missing))
  paired <- complete.cases(fav[[1]], fav[[2]])
  fav[[1]][!paired] <- fav[[2]][!paired] <- NA_real_
  ratings <- orient_candidates(fav[[1]], fav[[2]], party)
  names(ratings) <- paste0(names(ratings), "_fav")
  traits <- lapply(c("rep", "dem"), function(side) {
    sapply(seq_along(fields[[side]]), function(j) {
      trait_response(raw[[fields[[side]][j]]], year, reverse = year == 2004 && j == 6)
    })
  })
  composite <- paired_traits(traits[[1]], traits[[2]], party)
  names(composite) <- c("own_trait", "other_trait", "gap_trait", "trait_items")
  d <- cbind(d, ratings, composite, trait_total = length(fields$rep))
  for (j in seq_along(fields$rep)) {
    item <- orient_candidates(traits[[1]][, j], traits[[2]][, j], party)
    d[[paste0("trait_", j)]] <- item$gap
  }
  ideology <- lapply(fields$ideology, function(v) ideology_response(raw[[v]]))
  placement <- orient_candidates(ideology[[1]], ideology[[2]], party)
  d$own_ideology <- placement$own
  d$other_ideology <- placement$other
  d$ideology_gap <- placement$gap
  d$self_ideology <- ideology[[3]]
  d$own_distance <- abs(d$own_ideology - d$self_ideology)
  d$other_distance <- abs(d$other_ideology - d$self_ideology)
  d
}

read_all_naes <- function(leaners = FALSE) {
  dplyr::bind_rows(lapply(c(2000, 2004, 2008), read_naes, leaners = leaners))
}
