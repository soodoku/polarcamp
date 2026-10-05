# Analysis definitions

The manuscript is an unpublished working paper.
The estimands are descriptive changes in evaluations among observed partisan
respondents. Calendar time is not a randomized campaign treatment.

| Question | Sample and quantity | Implementation | Output |
|---|---|---|---|
| How do candidate evaluations evolve over the election year? | Weekly means among self-identified partisans; fixed eventual nominees | `survey_results()` | `tabs/naes_weekly.csv`, `figs/naes_gaps.pdf`, `figs/naes_fav.pdf`, `figs/naes_trait.pdf` |
| Do candidate gaps grow during the autumn? | Self-identified NAES partisans; final 14 pre-election days minus September 1–14; unweighted | `R/naes.R`, `period_contrast()` | `tabs/naes_changes.csv`, `tabs/naes_main.tex` |
| Which candidate's ratings change? | Paired own/opposing outcomes on the identical sample | `orient_candidates()`, `paired_traits()` | `tabs/decomposition.tex` |
| Do trends differ in battleground states? | Election-year linear slope difference per 100 days; historical state lists | `survey_results()` | `tabs/naes_battleground.csv`, `tabs/battleground.tex` |
| Does observed composition explain the comparison? | Period-specific linear models standardized to complete-case autumn respondents; uncertainty conditional on that target | `period_contrast(adjusted = TRUE)` | `tabs/naes_changes.csv` |
| Are results sensitive to scoring and selection? | Whole trait batteries, individual items, leaners, inherited weights, matched samples | `survey_results()`, `scripts/run_all.R` | `tabs/naes_sensitivity.csv` |
| How does perceived ideological disagreement change? | Available candidate placements and self–candidate distances; repeated cross-sectional descriptions | `ideology_response()` | `figs/naes_ideology.pdf`, `figs/naes_distance.pdf` |

## NAES construction

`data/raw/naes00.rdata`, `naes04.rdata`, and `naes08.rdata` contain the archived
objects `naes00`, `naes04`, and `naes08`. Outcome questions survive, but original
demographics and the 2004/2008 party-identification questions do not. Inherited
age, gender, Black/Hispanic indicators, education, `pid3`, and `pid7` therefore
remain a provenance limitation. The 2000 `pid3` coding is checked against `cv01`.
IDs are `unique.id`, `ckey`, and `rkey`; `cdatestr` uses YYYYMMDD. Outcomes are
rebuilt from the following fields, never from saved composite scores.

| Year | Republican / Democratic favorability | Trait fields (Republican / Democratic) | Ideology (Republican, Democratic, self) |
|---|---|---|---|
| 2000 | ca01 / ca11 | ca02–05 / ca12–15 | ca09, ca19, cv04 |
| 2004 | caa01 / cab01 | caa04,05,06,07,09,10 / cab02,03,04,05,07,08 | caa30, cab27, cma06 |
| 2008 | aam01 / abo01 | aam05–08 / abo05–08 | aam04, abo04, ma04 |

Favorability missing codes are 101/102/999 in 2000, 11/12/999 in 2004, and
998/999 in 2008. Numeric trait and ideology nonresponse codes are 998/999.
Factor responses use explicit label dictionaries, independent of level order.
Unknown codes fail rather than silently becoming valid responses. The 2000
traits use exact thirds. Recklessness alone is reversed. Traits require paired
responses within each item; the composite averages those paired items. No
paired items means missing, not zero. Favorability components require both
candidate responses. Ideology series use their own available cases.

Primary time series and battleground trends cover the election calendar year
through election eve. Weekly bins count backward in seven-day blocks from the
correct Election Day. The autumn contrast includes September 1–14 and days
14 through 1 before Election Day. The pooled standardization target begins
September 1 of the election year; earlier autumns never enter it.

Primary weights equal one, including respondents without inherited weights.
`weight1` and `weight2` are **author-created**, not verified NAES study weights.
Archived construction uses bases 1/phones and 1/(adults × phones), respectively,
then demographic raking. The latter household-size factor runs opposite to
inverse-probability adjustment for selecting one adult within a household.
The [2000 codebook, p. 12](https://sites.stat.columbia.edu/gelman/surveys.course/annenberg2000/Annenberg2000.pdf)
describes within-household adult selection. Full original household inputs do
not survive for every year, so neither scheme is certified or relabeled as an
official weight. The inherited 2008 clipping code also left extreme weights
above its upper comparison bound untouched. Sensitivities use the archived
values transparently, with an unweighted estimate on the exact same eligible
sample to distinguish weighting from sample exclusion.

Adjusted models interact the late-period indicator with every included
covariate: linear age and education, binary gender/Black/Hispanic indicators,
and categorical party. Their contrast averages predicted late-minus-early
outcomes over the outcome-specific complete-case autumn sample. Standard
errors condition on this empirical target. Complete-case unadjusted estimates
are provided separately. State-clustered HC1 covariance uses the cluster
finite-sample adjustment and t(G−1) intervals; interview-date clustering and
respondent-level HC1 are alternatives. These are separate one-way estimators.
Weekly means use independent-respondent HC1 intercept variance and t(n−1).
All intervals are pointwise, with no simultaneous-coverage claim.

Battleground slopes compare linear trends per 100 days toward Election Day,
using the lists recorded in `R/naes.R`. The historical classification uses
late-election competitiveness, not randomized or predetermined exposure.
It is a descriptive geographic comparison. There is no advertising-effect
estimate in this implementation. `join_exposure()` and `prior_window()` encode
row-conserving, strictly prior-day matching rules for a future reconstruction;
the current pipeline does not call them or infer missing exposure as zero.


The panel and experiment methods are documented separately in
[the extension methods](../extensions/docs/methods.md).

## Candidate identity and the primary field

The manuscript follows fixed eventual-nominee pairs throughout each election:
Bush/Gore, Bush/Kerry, and McCain/Obama. Entry or exit of other primary candidates
cannot mechanically change membership of these series. Selecting eventual
nominees retrospectively nevertheless limits inference about all candidates.

`make candidate-pool` plots the nine presidential contenders with verified
favorability fields in the 2008 archived workspace. The figure has one panel
per candidate and stops where ratings become unavailable. Biden and Palin are
excluded: their favorability items in this phone release begin during the
vice-presidential campaign. It is not a census of every primary entrant.

Mappings and question schedules are verified against the
[official NAES08 phone codebook](https://cdn.annenbergpublicpolicycenter.org/Downloads/NAES/PhoneSurvey/NAES08-Phone-Codebook.pdf),
pp. 37–43 and the detailed variable entries. The observed-date inventory in
`tabs/candidate_pool_2008_coverage.csv` is not a withdrawal-date roster.
Clinton's favorability item continues after her primary campaign, while Paul's
item appears only briefly in January. Do not infer an active candidate field
from question availability. Missing periods remain missing.

The separate candidate plots retain each candidate's available responses and
show own- and opposing-party evaluations. They are not matched-pair gaps or
within-person trajectories. A fixed all-candidate index over the full year is
not identified when candidates cease to be measured. Overlapping candidate
sets can support local comparisons, but linking such comparisons into one
series would introduce additional weighting and comparability choices.
