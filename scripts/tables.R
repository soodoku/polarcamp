source("R/exhibits.R")
r <- readRDS("data/derived/results.rds")
x <- subset(r$naes$changes, inference == "state" & !adjusted & outcome %in% c("gap_fav", "gap_trait"))
y <- subset(r$naes$changes, inference == "state" & adjusted & outcome %in% c("gap_fav", "gap_trait"))
stopifnot(identical(x$outcome, y$outcome), identical(x$year, y$year))
tex_table(
  data.frame(
    x$year, unname(outcome_labels[x$outcome]), sprintf("%.1f", x$early_mean),
    sprintf("%.1f", x$late_mean), format_ci(x), format_ci(y)
  ),
  c("Year", "Measure", "Early", "Late", "Change [95\\% CI]", "Adjusted change"), "llrrrr", "tabs/naes_main.tex"
)
x <- subset(
  r$naes$changes, inference == "state" & !adjusted &
    outcome %in% c("own_fav", "other_fav", "own_trait", "other_trait")
)
tex_table(
  data.frame(
    x$year, ifelse(grepl("fav", x$outcome), "Favorability", "Traits"),
    unname(outcome_labels[x$outcome]), format_ci(x), x$n
  ),
  c("Year", "Measure", "Candidate", "Change [95\\% CI]", "$N$"), "lllrr", "tabs/decomposition.tex"
)
x <- subset(
  r$naes$sensitivity, inference == "state" & outcome %in% c("gap_fav", "gap_trait") &
    (scheme %in% c("complete_traits", "include_leaners") | (scheme %in% c("weight1", "weight2") & weighted))
)
x$label <- c(
  weight1 = "Inherited weight 1", weight2 = "Inherited weight 2", complete_traits = "All trait pairs",
  include_leaners = "Including leaners"
)[x$scheme]
tex_table(
  data.frame(x$year, unname(outcome_labels[x$outcome]), x$label, format_ci(x), x$n),
  c("Year", "Measure", "Specification", "Change [95\\% CI]", "$N$"), "lllrr", "tabs/sensitivity.tex"
)
x <- r$naes$battleground
tex_table(
  data.frame(x$year, unname(outcome_labels[x$outcome]), format_ci(x), x$n),
  c("Year", "Measure", "Slope difference [95\\% CI]", "$N$"), "llrr", "tabs/battleground.tex"
)
writeLines(result_macros(r), "ms/results.tex")
