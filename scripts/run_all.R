for (file in sort(list.files("R", pattern = "[.]R$", full.names = TRUE))) source(file)
verify_sources()
survey <- read_all_naes()
results <- survey_results(survey)
leaners <- read_all_naes(leaners = TRUE)
leaners <- leaners[leaners$days_before > 0 & !is.na(leaners$party), ]
extra <- list()
for (year in c(2000, 2004, 2008)) {
  d <- leaners[leaners$year == year, ]
  for (outcome in c("gap_fav", "gap_trait")) {
    extra[[length(extra) + 1L]] <- cbind(year = year, scheme = "include_leaners", period_contrast(d, outcome))
    z <- survey[survey$year == year & survey$days_before > 0 & !is.na(survey$party), ]
    z <- z[complete.cases(z[c("age", "female", "black", "hispanic", "education", "party")]), ]
    extra[[length(extra) + 1L]] <- cbind(year = year, scheme = "adjustment_complete_cases", period_contrast(z, outcome))
  }
}
results$sensitivity <- rbind(results$sensitivity, do.call(rbind, extra))
for (name in names(results)) write_result(results[[name]], paste0("naes_", name))
dir.create("data/derived", recursive = TRUE, showWarnings = FALSE)
saveRDS(survey, "data/derived/naes.rds")
saveRDS(list(naes = results), "data/derived/results.rds")
writeLines(capture.output(sessionInfo()), "data/derived/session-info.txt")
message("Analysis complete: tables in tabs/; inputs verified by SHA-256.")
