election_dates <- c(`2000` = "2000-11-07", `2004` = "2004-11-02", `2008` = "2008-11-04")

election_date <- function(year) {
  if (any(!year %in% names(election_dates))) stop("Unsupported election year")
  as.Date(unname(election_dates[as.character(year)]))
}

numeric_response <- function(x, valid, missing = numeric()) {
  if (is.factor(x) || is.character(x)) stop("Decode labeled responses explicitly")
  if (any(!is.na(x) & !x %in% c(valid, missing))) stop("Unexpected response code")
  ifelse(x %in% valid, as.numeric(x), NA_real_)
}

label_response <- function(x, values, missing) {
  x <- as.character(x)
  if (any(!is.na(x) & !x %in% c(names(values), missing))) stop("Unexpected response label")
  unname(values[x])
}

ideology_response <- function(x) {
  if (is.numeric(x)) {
    return(25 * (numeric_response(x, 1:5, c(998, 999)) - 1))
  }
  label_response(x, c(
    "very conservative" = 0, "conservative" = 25, "somewhat conservative" = 25,
    "moderate" = 50, "liberal" = 75, "somewhat liberal" = 75, "very liberal" = 100
  ), c("dont know", "don't know", "no answer"))
}

trait_response <- function(x, year, reverse = FALSE) {
  if (year == 2000) {
    value <- label_response(x, c(
      "extremely well" = 100, "quite well" = 200 / 3,
      "not too well" = 100 / 3, "not well" = 0
    ), c("dont know", "no answer"))
  } else {
    value <- 10 * numeric_response(x, 0:10, c(998, 999))
  }
  if (reverse) 100 - value else value
}

orient_candidates <- function(republican, democrat, party) {
  if (length(republican) != length(democrat) || length(party) != length(republican)) {
    stop("Candidate and party vectors must have equal length")
  }
  own <- ifelse(party == "Republican", republican, ifelse(party == "Democrat", democrat, NA_real_))
  other <- ifelse(party == "Republican", democrat, ifelse(party == "Democrat", republican, NA_real_))
  data.frame(own = own, other = other, gap = own - other)
}

paired_traits <- function(republican, democrat, party) {
  if (!identical(dim(republican), dim(democrat))) stop("Trait matrices must match")
  paired <- is.finite(republican) & is.finite(democrat)
  republican[!paired] <- NA_real_
  democrat[!paired] <- NA_real_
  count <- rowSums(paired)
  rep_mean <- rowMeans(republican, na.rm = TRUE)
  dem_mean <- rowMeans(democrat, na.rm = TRUE)
  rep_mean[count == 0] <- dem_mean[count == 0] <- NA_real_
  cbind(orient_candidates(rep_mean, dem_mean, party), items = count)
}

join_exposure <- function(respondents, exposure) {
  required <- c("dma", "date", "total", "negative")
  if (!all(required %in% names(exposure))) stop("Incomplete exposure schema")
  key <- paste(exposure$dma, exposure$date, sep = "/")
  if (anyNA(exposure[c("dma", "date")]) || anyDuplicated(key)) stop("Ambiguous DMA-date exposure")
  if (any(exposure$negative < 0 | exposure$total < exposure$negative, na.rm = TRUE)) {
    stop("Invalid advertising counts")
  }
  index <- match(paste(respondents$dma, respondents$date, sep = "/"), key)
  cbind(respondents, exposure[index, c("total", "negative"), drop = FALSE])
}

prior_window <- function(airing_dates, interview, days = 30L) {
  if (length(days) != 1L || !is.finite(days) || days < 1 || days != as.integer(days)) {
    stop("Window length must be a positive integer")
  }
  if (!inherits(airing_dates, "Date") || !inherits(interview, "Date")) stop("Use calendar dates")
  if (length(interview) != 1L || is.na(interview)) stop("One interview date required")
  !is.na(airing_dates) & airing_dates >= interview - days & airing_dates < interview
}
