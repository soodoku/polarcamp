# What this study can establish, and how to strengthen it

The descriptive starting point is how candidate and party evaluations change.
This distinction has direct precedents, especially Singh and Thornton (2024);
see the [recent literature and contribution assessment](literature.md). The panel follows the same people,
fixes their baseline identity, and observes the two objects moving differently.
The NAES repeated cross sections then show how candidate ratings evolve across
three elections, with explicit sensitivity to the autumn window, respondent
composition, weighting, and item availability. The Part 1 manuscript and separate extension
tables report the estimates and intervals; those values should be read from
those outputs rather than maintained as another numerical copy here.

These comparisons do not identify the effect of campaigning. They do not show
that advertising produces hostility toward ordinary opposing partisans, and
they do not distinguish learning from motivated evaluation. Those are separate
research questions requiring different evidence.

The paper first establishes the descriptive pattern. An explanatory exercise
follows only when assignment and measurement support it. A precise small effect
of a specified treatment can be informative even if it does not explain the
pattern; an unidentified or imprecise estimate leaves the explanation open.

## Existing-data extensions now implemented

- Separate own- and opposing-candidate ratings on identical outcome samples.
  The sum of their changes tests whether opponent deterioration exceeds own
  improvement; the gap alone cannot answer that question.
- Standardize autumn contrasts to observed respondent characteristics and
  report unadjusted comparisons on the same complete-case samples. Similarity
  probes measured composition, while leaving unmeasured selection unresolved.
- Compare individual traits and whole batteries, response availability,
  floors and ceilings, leaner definitions, and both inherited weight schemes.
  This distinguishes a general tendency from a specific measurement choice.
- Follow fixed baseline partisans in the panel, contrast candidate and party
  ratings, inspect five-wave complete cases, and compare retained versus
  nonretained respondents at baseline. The shorter panel comparison limits
  how much of the long change can be attributed to the general-election period.

- Compare candidate and party changes on exactly the same people, for both
  observation windows and both leaner definitions. The joint-complete domain
  retains the covariance of the two changes. These are additional exploratory
  descriptive comparisons, not preregistered tests or a causal design.

## Highest-value next analyses with these sources

1. **Show the distribution of individual changes.** Distinguish people whose
   own ratings rise, whose opposing ratings fall, both, or neither, retaining
   ties and the coarseness of the seven-category scale. Means can conceal
   offsetting movement. Choose substantively meaningful change categories
   before inspecting subgroup significance.
2. **Model response and attrition sensitivity.** Add baseline demographics and
   prior outcomes to retention diagnostics, report common support, and examine
   how conclusions vary under explicit assumptions about unobserved changes
   among nonrespondents. Inverse-response weighting alone cannot certify that
   missingness is ignorable. Extreme bounds may be wide but show what the data
   themselves establish without assumptions.
3. **Study specific events only with a defensible comparison.** Debate or
   nomination dates can organize descriptive trajectories. A date break by
   itself is not a causal discontinuity: news and sample composition change
   around the same dates, and anticipation is plausible. Specify the event,
   bandwidth, contemporaneous events, and negative-control outcomes first.

## The 2012 advertising study

The archived study, *Political Advertising and Affective Polarization*, is by
Kyle A. Dropp, Shanto Iyengar, and Gaurav Sood. The supplied archive contains its original manuscript
under `ads_exp/kyle.mess/apsa/apsa_writeup.pdf`.

The available files cover a selected analysis export and a larger export that
itself retains only completed cases. They are not an assignment roster. There
are seven arms: control; two mixed-candidate positive bundles; two mixed-candidate
negative bundles; an Obama-negative bundle; and a Romney-negative bundle.
Each mixed bundle contains one Obama advertisement, one Romney advertisement,
and one product advertisement. We give the two bundles within each tone condition
equal weight. Comparing all negative arms to all positive arms would change both
tone and candidate composition.

Descriptive estimates are in [the cell table](../tabs/experiment_cells.csv) and
[the contrast table](../tabs/experiment_contrasts.csv). The outcomes are absolute
party and candidate thermometer gaps, so they do not require trusting the timing
of the inherited partisan profile. Their intervals concern sampling variability
within the available exports. They cannot account for undocumented assignment,
post-assignment exclusions, or selection into those exports.

Before treating this as a randomized experiment, recover:

- the assignment algorithm, probabilities, cohort dates, and any changes to arms;
- the complete assigned roster, dispositions, and inclusion/exclusion rules;
- the fielded questionnaire and timing of party identification relative to ads;
- the exact stimuli and the mapping from each arm to each message;
- any prospective hypotheses or analysis plan and the weights' construction.

The observed variables naming randomization describe message order and do not
by themselves document assignment to experimental arms. Unequal exclusions
and unidentified cohort changes are consequential, not cosmetic missing
metadata. If the protocol is recovered, estimate assignment effects using the
full assigned sample, report attrition by arm, and keep the balanced bundle
contrast distinct from a general claim about negative tone. Even a randomized
bundle effect combines tone, content, production, and candidate targeting.

## Extension through the present: question and contribution

Design updated October 4, 2026, after seeing the historical results and the
published literature. This is a prospective plan for additional work, not a
blinded preregistration of the existing analysis. New source metadata, some codebook marginal frequencies, and PRL item
availability have been inspected; new outcome contrasts have not been estimated. Record further exposure and deviations when implementing.
The [data inventory](data-extension.md) separates verified coverage from items
that still require verification.

The central question is **when candidate evaluations change without comparable
movement toward parties or ordinary supporters, and whether that divergence
persists**. Singh and Thornton already establish the broad distinction; Phillips
and Warner extend pre/post-election party affect through 2024. A defensible new
contribution needs comparable measurements, a consequential change in the pattern,
or evidence about persistence and transmission across targets. Additional years
and more significant coefficients are insufficient by themselves.

Use completed presidential elections through 2024 for historical comparisons.
Treat observations available in 2025–2026 as between-election or midterm evidence,
with the latest observed date recorded. The 2026 general election has not occurred
as of this design date; it cannot provide completed post-election outcomes.

### Three descriptive estimands

1. **Within-campaign change:** two observations strictly before Election Day,
   preferably September 1–14 and the final fourteen pre-election days. A panel
   contrast fixes baseline party identification, including leaners, and uses the
   same people for candidate and party changes. Define the joint contrast as
   mean[(late candidate gap − early candidate gap) − (late party gap − early
   party gap)]. Preserve the within-person covariance. Party ratings are not an
   untreated control, so this difference is not a causal difference-in-differences.
2. **Election-transition change:** compare genuinely pre-election and post-election
   responses separately, recording interview dates and elapsed time. Report the
   first 28 days after Election Day as a distinct domain if supported, alongside
   the full field period. This brackets the outcome and subsequent events; it is
   not a campaign-growth estimate or, by itself, an effect of winning or losing.
3. **Between-election change:** compare repeated named-person and party items at
   more distant waves. Track Trump as the same person across elections, but do not
   treat Clinton, Biden, and Harris as the same Democratic candidate. A former
   candidate's rating after two years concerns a changed political role, not the
   persistence of a randomized campaign treatment.

For repeated cross sections, estimate separate weighted population contrasts
between interview windows. Contemporaneous partisan classification, interview
selection, and changing composition distinguish these from panel changes. Display
both designs without pooling them into one campaign-effect coefficient.

### Sample, measurement, and inference rules

Choose the fresh-sample population for each election or the original cohort for
longitudinal comparisons; do not silently pool them. Fix identity at the relevant
baseline and retain party switchers, abstainers, and all assigned experimental
participants. Do not select on reported vote. For cross-election cohort analyses,
report both fixed initial identity and election-specific pre-election identity,
which answer different questions.

Map exact wording, response scales, item order, mode, universe, special missing
codes, candidate names, dates, weight, stratum, and PSU before producing estimates.
A numerical transformation to 0–100 does not establish measurement equivalence.
Where a scale changes, report the comparison separately and seek a bridge study
with random assignment of both formats; do not call rescaling a correction.
Restrict comparable historical contrasts to supported modes and observation
windows, while reporting how those restrictions change the target population.

Estimate each election and target separately. Main outcomes are the candidate
and party gaps and their joint change contrast; own and opposing ratings explain
those gaps. Explicit supporter ratings enter only where the question names
ordinary supporters. Report distributions of increases, decreases, and ties at
the original scale resolution. Establish the survey design before restricting
domains and carry the covariance of joint outcomes. Report effective sample sizes,
weight dispersion, endpoint retention, and baseline differences by retention.
Use response adjustment only with explicit missing-at-random assumptions and
show how conclusions change when missing respondents' mean changes differ from
responders'. Distinguish sampling intervals from sensitivity to missing outcomes.

Show all planned election comparisons and pointwise intervals; adjust a small
family of formal cross-election tests with Holm's method. Define any equivalence
bound before inspecting new contrast estimates and report precision against it.
Do not infer a time trend in effects from significance in one election and not
another. Election contexts, rather than respondents, limit historical
extrapolation. Familiarity, baseline knowledge, identification strength, and room
to move on the scale are descriptive moderators; none identifies a mechanism.

### Two focused intervention designs

**Verified policy information.** Recruit the population to which the claim will
apply, with baseline preferences, candidate-position beliefs, confidence,
familiarity, identity, and evaluations measured before assignment. Establish
factual benchmarks and resolve ambiguous or changing positions before fielding.
Preclassify whether correcting a belief reveals greater agreement or disagreement.
Randomize verified information against an equally engaging control within those
baseline groups, party, and candidate target. Balance topics and candidates;
register the assignment probabilities and retain the full roster.

The primary estimands are assignment effects on belief accuracy and candidate
ratings at a seven-day follow-up, including a prespecified contrast between
corrections revealing agreement and disagreement. Measure immediate accuracy and
all three affect targets, but account for possible priming by the accuracy
questions, for example by randomizing measurement order. Party and explicitly
ordinary-supporter ratings assess spillover; a 28-day follow-up assesses duration.
Avoid conditioning the main effect on actually learning, reading, or complying.
A post-treatment belief regression or information instrument does not identify
mediation: information may also change competence, trust, salience, or identity.

**Matched messages.** Randomize a narrowly defined negative framing versus neutral
presentation while holding the factual proposition, source, target, length, and
format constant. Use multiple independently developed message pairs. Pilot whether
respondents infer different facts or policy positions; if so, describe the
intervention as a bundle. Randomize message exemplars and treatment within
exemplars. Estimate the average assignment effect over that declared message set,
with uncertainty accommodating respondent and message variation. Generalization
to other messages requires a defensible sampling argument. Measure candidates,
parties, and ordinary supporters before, immediately after, and at delayed waves.

These are interventions, not purified psychological mechanisms. Policy positions
can convey identity and party labels can convey unmentioned policies. A factorial
experiment does not remove those inferences merely because assignment is
independent. The information experiment should be prioritized over a large
factorial design unless the latter answers an additional, powered interaction
question. Existing Sood–Iyengar policy-position experiments and recent ad-removal
experiments are benchmarks to reproduce before commissioning a new study.

### Interpretation, precision, and stopping decisions

| Observed result | What it would establish |
|---|---|
| No improvement in accuracy | The information manipulation did not produce the intended learning; the learning explanation remains open. |
| Accuracy improves; a narrow affect interval lies inside the prespecified equivalence region | Those corrections have a small effect for this population, dose, and horizon. |
| Candidate ratings change; supporter effects are precisely small | Limited spillover to ordinary supporters under this intervention. |
| Immediate effect disappears | A transient response under the tested schedule; repeated natural exposure remains a separate question. |
| Wide intervals | Inconclusive evidence, even when the p-value exceeds .05. |

Before collection, choose the smallest meaningful change in 0–100 scale points
using a substantive benchmark, not the old selected-export estimate. Use blinded
pilot variances, realistic attrition, assignment ratios, repeated-measure
correlation, and multiplicity to power the directional interaction and equivalence
claims as well as the main effect. No numerical sample size is justified before
those inputs and the bound are fixed. Analyze assignment effects with baseline
adjustment and the actual randomization strata; report arm-specific attrition and
sensitivity to missing outcomes. Any respondent incentives or new collection need
a separate budget and fieldwork protocol.

**Proceed now:** instrument mapping, source acquisition, comparable descriptive
extensions, and replication of the closest published results. **Proceed to causal
estimation only** with documented randomization or a specified defensible natural
experiment. **Do not proceed** with a universal harmonized trend if target, mode,
or scale changes cannot be separated from substantive change. If newer compatible
panels add neither a consequential pattern nor sharper bounds, frame the historical
paper as a careful replication and refinement rather than manufacture novelty.

A geographic advertising design remains conditional on airing records, stable
media-market borders, prior-interview exposure, and enough independent geographic
units. Targeting, local news, campaign visits, migration, and cross-border spillovers
must support the proposed assignment argument. Balance and fixed effects are not
that argument. A close-election discontinuity instead concerns narrowly winning a
particular race; it does not identify the effects of campaigning or negative ads.
