for (file in sort(list.files("R", pattern = "[.]R$", full.names = TRUE))) source(file)
verify_sources("extensions/sources.csv")
panel <- read_panel()
r <- list(panel = panel_results(panel), experiment = experiment_results())
for (name in names(r$panel)) write_result(r$panel[[name]], paste0("panel_", name), "extensions/tabs")
for (name in names(r$experiment)) write_result(r$experiment[[name]], paste0("experiment_", name), "extensions/tabs")
dir.create("data/derived", recursive = TRUE, showWarnings = FALSE)
saveRDS(panel, "data/derived/panel.rds")
saveRDS(r, "data/derived/extensions.rds")
writeLines(capture.output(sessionInfo()), "data/derived/extensions-session-info.txt")
library(ggplot2)
p <- r$panel$trajectories
p$wave <- factor(p$wave, levels = c(1, 2, 6, 9, 10), labels = c("January", "February", "June", "September", "October"))
p$target <- factor(p$target, levels = c("candidate", "party"), labels = c("Candidates", "Parties"))
g <- ggplot(p, aes(wave, estimate, group = 1)) +
  geom_line(linewidth = .6) +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = .12) +
  geom_point(size = 2) +
  facet_wrap(~target) +
  coord_cartesian(ylim = c(0, 60)) +
  labs(x = "Nominal 2008 survey wave", y = "Own-minus-opposing rating gap (0–100 scale)") +
  paper_theme()
ggsave("extensions/figs/panel_trajectory.pdf", g, width = 7, height = 3.1, device = cairo_pdf)
x <- subset(r$panel$changes, sample == "paired" & leaners)
tex_table(
  data.frame(
    ifelse(x$spec == "original", "January--October", "September--October"),
    ifelse(x$target == "candidate", "Candidates", "Parties"),
    c(own = "Own", other = "Opposing", gap = "Gap")[x$measure], format_ci(x), x$n
  ),
  c("Nominal waves", "Object", "Measure", "Change [95\\% CI]", "$N$"), "lllrr", "extensions/tabs/panel_main.tex"
)
x <- subset(r$panel$retention, leaners)
tex_table(
  data.frame(
    ifelse(x$spec == "original", "January", "September"),
    ifelse(x$target == "candidate", "Candidates", "Parties"),
    c(all_baseline = "Baseline eligible", retained = "Retained", not_retained = "Not retained")[x$status],
    x$n, sprintf("%.1f", x$estimate)
  ),
  c("Baseline wave", "Object", "Sample", "$N$", "Baseline gap"), "lllrr", "extensions/tabs/retention.tex"
)
x <- subset(r$experiment$contrasts, comparison %in% c("negative_minus_positive", "negative_minus_control"))
tex_table(
  data.frame(
    ifelse(x$sample == "selected", "Selected export", "Available export"),
    ifelse(x$outcome == "candidate", "Candidates", "Parties"),
    ifelse(x$comparison == "negative_minus_positive", "Negative--positive", "Negative--control"), format_ci(x)
  ),
  c("Sample", "Absolute rating gap", "Comparison", "Contrast [95\\% CI]"), "lllr", "extensions/tabs/experiment.tex"
)
x <- subset(r$panel$joint_changes, leaners)
tex_table(
  data.frame(
    ifelse(x$spec == "original", "January--October", "September--October"),
    c(candidate = "Candidate gap", party = "Party gap", difference = "Candidate minus party")[x$measure],
    format_ci(x), x$n
  ),
  c("Nominal waves", "Change", "Estimate [95\\% CI]", "$N$"), "llrr", "extensions/tabs/panel_joint.tex"
)
