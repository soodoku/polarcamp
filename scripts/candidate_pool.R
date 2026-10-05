for (file in sort(list.files("R", pattern = "[.]R$", full.names = TRUE))) source(file)
verify_sources()
r <- candidate_pool_2008()
write_result(r$weekly, "candidate_pool_2008_weekly")
write_result(r$coverage, "candidate_pool_2008_coverage")
library(ggplot2)
d <- r$weekly
d$group <- factor(d$group, levels = c("Own-party respondents", "Opposing-party respondents"))
d$candidate <- factor(d$candidate, levels = r$coverage$candidate)
d[d$n < 30, c("estimate", "lower", "upper")] <- NA_real_
g <- ggplot(d, aes(week, estimate, colour = group, linetype = group)) +
  geom_ribbon(aes(ymin = lower, ymax = upper, fill = group), alpha = .13, colour = NA, na.rm = TRUE) +
  geom_line(linewidth = .6, na.rm = TRUE) +
  geom_point(size = .5, na.rm = TRUE) +
  facet_wrap(~candidate, ncol = 3) +
  scale_colour_manual(values = c("#23618A", "#AA4930")) +
  scale_fill_manual(values = c("#23618A", "#AA4930")) +
  scale_x_continuous(breaks = c(-280, -140, 0)) +
  coord_cartesian(ylim = c(0, 100)) +
  labs(
    x = "Days before Election Day (weekly bins)", y = "Mean favorability (0–100)",
    caption = paste(
      "2008 NAES; self-identified partisans. Candidate-specific available responses, unweighted.",
      "Pointwise respondent-level robust 95% intervals; weeks with fewer than 30 ratings are omitted.",
      "Blank periods mean insufficient or unavailable ratings, not zero affect or verified withdrawal dates.",
      sep = "\n"
    )
  ) +
  paper_theme() +
  theme(plot.caption = element_text(hjust = 0, size = 9))
ggsave("figs/candidate_pool_2008.pdf", g, width = 9, height = 8, device = cairo_pdf)
