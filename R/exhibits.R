paper_theme <- function() {
  ggplot2::theme_minimal(base_size = 11, base_family = "sans") +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(colour = "grey90", linewidth = .25),
      axis.text = ggplot2::element_text(colour = "grey15"),
      strip.text = ggplot2::element_text(face = "bold"), legend.position = "top",
      legend.title = ggplot2::element_blank(), plot.title.position = "plot"
    )
}

outcome_labels <- c(
  own_fav = "Own candidate", other_fav = "Opposing candidate", gap_fav = "Favorability gap",
  own_trait = "Own candidate", other_trait = "Opposing candidate", gap_trait = "Trait gap",
  own_ideology = "Own candidate", other_ideology = "Opposing candidate",
  own_distance = "Own candidate", other_distance = "Opposing candidate"
)

tex_table <- function(data, headers, align, file) {
  stopifnot(ncol(data) == length(headers))
  rows <- apply(data, 1, function(row) paste0(paste(row, collapse = " & "), " \\\\"))
  writeLines(c(
    paste0("\\begin{tabular}{", align, "}"), "\\toprule",
    paste0(paste(headers, collapse = " & "), " \\\\"), "\\midrule", rows,
    "\\bottomrule", "\\end{tabular}"
  ), file)
}

format_ci <- function(d) sprintf("%.1f [%.1f, %.1f]", d$estimate, d$lower, d$upper)

result_macros <- function(r) {
  macros <- character()
  for (election_year in c(2000, 2004, 2008)) {
    x <- subset(r$naes$changes, inference == "state" & !adjusted & outcome == "gap_fav" & year == election_year)
    stopifnot(nrow(x) == 1L)
    suffix <- c(`2000` = "Zero", `2004` = "Four", `2008` = "Eight")[[as.character(election_year)]]
    macros <- c(
      macros, sprintf("\\newcommand{\\Fav%s}{%.1f}", suffix, x$estimate),
      sprintf("\\newcommand{\\Fav%sCI}{[%.1f, %.1f]}", suffix, x$lower, x$upper)
    )
  }
  macros
}
