# Additional analyses

These analyses are built separately with `make extensions` and are not in the
manuscript.

## ANES panel construction

The archived `nes08p` object identifies version 20100903. The official
[study page](https://electionstudies.org/data-center/2008-2009-panel-study/),
[variable list](https://electionstudies.org/wp-content/uploads/2009/03/anes_specialstudy_2008_2009panel_variable_list.txt),
[questionnaire](https://electionstudies.org/wp-content/uploads/2009/03/anes_specialstudy_2008_2009panel_qnaire.pdf),
[derived-variable code](https://electionstudies.org/wp-content/uploads/2009/03/anes_specialstudy_2008_2009panel_DerivedVarCode.txt),
and [methodology report, pp. 90–92](https://electionstudies.org/wp-content/uploads/2009/03/anes_specialstudy_2008_2009panel_MethodologyRpt.pdf)
provide the mapping and weight definitions.

At each of waves 1, 2, 6, 9, and 10, direction/like-intensity/dislike-intensity
triples are e2/e3/e4 (Democratic party), e5/e6/e7 (Republican party), e38/e39/e40
(Obama), and e14/e15/e16 (McCain), preceded by `w{wave}`. Decode the signed
numeric prefix of labels. Negative codes are missing. Neither gives 50;
like intensity j gives 100(7−j)/6; dislike intensity j gives 100(j−1)/6.
Only the applicable intensity branch is required.

Baseline PID is reconstructed from w1m1/m3/m5/m6 or w9l1/l3/l5/l6, including
the official special-missing branches, and checked against der08w1/der08w9.
Codes 0–2 identify Democrats and 4–6 Republicans; leaner-excluded sensitivity
uses 0–1 and 5–6. Pure independents and missing identification are excluded.
One baseline orientation is applied throughout each comparison.

The original longitudinal weight is `wgtc10` (requires the intervening ANES
waves); the September–October weight is `wgtl10` (both recruitment cohorts).
`stratum` specifies the sampling strata and individuals are sampling units.
The full positive-weight design precedes analytic domain restrictions. The
later cohort alone is a subgroup sensitivity, not separately recalibrated.
Confidence intervals use Taylor linearization and design t degrees of freedom.
Calibration coefficients are treated as fixed; these intervals do not model
uncertainty from constructing the supplied weights.

October-wave interviews on or after November 4 are excluded. Nominal January,
February, and June field periods extend into later months. The long comparison
includes candidate-selection developments and is not a pure general-election
contrast. Five-wave complete cases are held fixed within each plotted object;
candidate and party complete-case sets need not be identical. Retention tables
use baseline cross-sectional weights for every row. Similar baseline means
are not a test of ignorable attrition.

## Experiment exports

The 2012 advertising study is described in [the research design](research-design.md).
Its available exports support descriptive comparisons; causal interpretation
requires the assignment and selection records described there.
`extensions/tabs/experiment_cells.csv` includes arm-specific
available counts, usable counts, missingness, means, and t intervals. Contrasts
use an arm-saturated model, HC2 covariance, and normal intervals. The balanced
negative-minus-positive contrast gives equal weight to arms 4 and 5 and
subtracts equal weights on arms 2 and 3. The negative-minus-control contrast averages arms 4 and 5 equally and
subtracts arm 1; it addresses a different comparison from tone. Six separate
arm-minus-control contrasts
are also reported for each of two outcomes. Holm correction covers all sixteen
contrasts within each export sample, not separate families by outcome.

## Joint candidate–party comparison

`extensions/tabs/panel_joint_changes.csv` and `extensions/tabs/panel_joint.tex` restrict each endpoint
comparison to respondents with both candidates and both parties rated at both
endpoints. Baseline identity, longitudinal weights, strata, and pre-election
October restrictions match the corresponding panel specification. The domain
is selected after constructing the survey design. Each respondent's change in
the party gap is subtracted from their change in the candidate gap before
estimation, retaining covariance. We report both component changes and their
difference with pointwise design-based intervals. Excluding leaners is a
sensitivity analysis. These exploratory comparisons do not use an untreated
control group and are not a causal difference-in-differences design.

Distribution diagnostics count values within `1e-8` points of zero or a scale
endpoint as equal to that value. This tolerance is far below the smallest
possible questionnaire step and prevents floating-point summation differences
from changing the reported share of ties or endpoint responses across platforms.
