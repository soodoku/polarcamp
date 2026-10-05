library(ggplot2)
source("R/exhibits.R")
r <- readRDS("data/derived/results.rds")
dir.create("figs", showWarnings = FALSE)
w <- r$naes$weekly
w <- w[w$n >= 30 & is.finite(w$estimate), ]
for (kind in c("fav", "trait", "ideology", "distance")) {
  source_data <- if (kind %in% c("ideology", "distance")) r$naes$ideology_weekly else w
  d <- source_data[source_data$outcome %in% paste0(c("own_", "other_"), kind) & source_data$n >= 30, ]
  d$series <- factor(unname(outcome_labels[d$outcome]), levels = c("Own candidate", "Opposing candidate"))
  p <- ggplot(d, aes(week, estimate, colour = series, linetype = series)) +
    geom_ribbon(aes(ymin = lower, ymax = upper, fill = series), alpha = .13, colour = NA) +
    geom_line(linewidth = .6) +
    facet_wrap(~year, nrow = 1) +
    scale_colour_manual(values = c("#23618A", "#AA4930")) +
    scale_fill_manual(values = c("#23618A", "#AA4930")) +
    scale_x_continuous(breaks = c(-280, -140, 0)) +
    coord_cartesian(ylim = c(0, 100)) +
    labs(x = "Days before Election Day (weekly bins)", y = switch(kind,
      fav = "Mean favorability (0–100)",
      trait = "Mean trait rating (0–100)",
      ideology = "Placement: conservative 0, liberal 100",
      distance = "Mean absolute distance (0–100)"
    )) +
    paper_theme()
  if (kind %in% c("ideology", "distance")) p <- p + facet_grid(party ~ year)
  ggsave(paste0("figs/naes_", kind, ".pdf"), p,
    width = 7,
    height = if (kind %in% c("ideology", "distance")) 4.5 else 3.3, device = cairo_pdf
  )
}
a <- tidyr::pivot_longer(r$naes$availability, c("favorability", "traits", "ideology", "complete_traits"),
  names_to = "measure", values_to = "fraction"
)
g <- ggplot(a, aes(week, fraction, linetype = measure)) +
  geom_line() +
  facet_wrap(~year, nrow = 1) +
  scale_y_continuous(labels = scales::label_percent(), limits = c(0, 1)) +
  scale_x_continuous(breaks = c(-280, -140, 0)) +
  labs(x = "Days before Election Day", y = "Response availability") +
  scale_linetype_discrete(labels = c("All trait pairs", "Favorability pair", "Ideology pair", "Any trait pair")) +
  paper_theme()
ggsave("figs/availability.pdf", g, width = 7, height = 3.5, device = cairo_pdf)

d <- w[w$outcome %in% c("gap_fav", "gap_trait"), ]
d$measure <- factor(unname(outcome_labels[d$outcome]), levels = c("Favorability gap", "Trait gap"))
g <- ggplot(d, aes(week, estimate)) +
  geom_ribbon(aes(ymin = lower, ymax = upper), fill = "#23618A", alpha = .15) +
  geom_line(colour = "#23618A", linewidth = .6) +
  facet_grid(measure ~ year) +
  scale_x_continuous(breaks = c(-280, -140, 0)) +
  coord_cartesian(ylim = c(0, 100)) +
  labs(x = "Days before Election Day (weekly bins)", y = "Own-minus-opposing gap (scale points)") +
  paper_theme()
ggsave("figs/naes_gaps.pdf", g, width = 7, height = 4.5, device = cairo_pdf)
