# Candidate, party, and supporter evaluations: research context

Review updated October 5, 2026. This is a focused review of the closest substantive,
measurement, and identification precedents, not a systematic review. Some sources were available only as abstracts or selected publisher sections,
as noted below.

The manuscript should first establish what changes, for whom, and over which
period. Explaining those changes is a separate task. A well-identified null can
rule out a substantively important effect of a particular intervention in a
particular setting. A noisy estimate, an exposure proxy, or an unidentified
regression cannot do that. This distinction allows the descriptive contribution
to stand even when a proposed explanation does not survive testing.

## Closest precedents

- **Singh and Thornton (2024), [Does the Salience of Partisan Competition
  Increase Affective Polarization in the United States?](https://doi.org/10.1177/10659129231192943).**
  They report candidate differentiation without corresponding party movement,
  using NAES and ANES sources that overlap ours. This is a direct precedent;
  the broad finding is not a new contribution. Their interview-timing argument
  concerns election salience. It does not identify negative advertising, and
  our use of similar sources does not automatically inherit their identification.
- **Fasching, Iyengar, Lelkes, and Westwood (2024), [Persistent Polarization](https://pmc.ncbi.nlm.nih.gov/articles/PMC11373587/).**
  Their large 2022 election study finds little evidence of a pre-election rise
  or subsequent gradual decline in partisan animosity. There is a small
  pre/post level difference in their thermometer results; “nothing changes”
  would overstate their finding. They discuss the earlier Sood–Iyengar draft.
  Comparing our historical candidate trajectories with their partisan measures
  is useful, but target, era, election type, and observation window differ.
  Those differences cannot themselves identify why findings differ.
- **Bolsen and Thornton (2021), [Candidate and Party Affective Polarization in
  U.S. Presidential Elections](https://doi.org/10.1016/j.electstud.2021.102293).**
  Their ANES analyses connect political sophistication with a greater candidate
  than party gap, including more negative out-party candidate evaluations.
  Knowledge or engagement is therefore a useful descriptive moderator, provided
  measured at baseline. It should not be treated as randomly assigned or as a
  uniquely diagnostic measure of motivated reasoning.
- **Reiljan, Garzia, Ferreira da Silva, and Trechsel (2024), [Patterns of
  Affective Polarization toward Parties and Leaders across the Democratic
  World](https://doi.org/10.1017/S0003055423000485).**
  Their cross-national comparison finds related but distinct leader and party
  evaluations, with the United States unusual in exhibiting greater leader
  polarization. The useful extension here concerns within-campaign changes,
  rather than another demonstration that the objects differ in level.

## What the measurement distinction buys us

**Candidates, broad parties, and ordinary supporters are three targets.**
[Druckman and Levendusky (2019)](https://doi.org/10.1093/poq/nfz003) show that
respondents often understand party questions as referring to elites and express
more negativity toward elites than voters. Thus our candidate–party comparison
is not an elite–citizen comparison. Neither source supplies the repeated,
explicit ordinary-supporter ratings needed to establish spillover to citizens.
The [2026 review by Druckman, Klar, Krupnikov, Levendusky, and Ryan](https://doi.org/10.1111/pops.70152)
also emphasizes matching the target, dimension, and measurement context to the
concept. Preserve exact question wording when extending the time series.

**A larger gap is not necessarily more out-group hostility.**
[Eck and Michel (2026)](https://doi.org/10.1016/j.electstud.2026.103116) find in
a Belgian election panel that party gaps grow through unequal increases in
warmth toward parties; voter-directed gaps do not similarly increase. Report
own and opposing evaluations alongside every gap, including ties, missingness,
and room to move on each scale. The current analysis implements the mean
components; individual transition distributions remain a useful extension.

**Evaluation is not the whole of emotion or democratic hostility.**
[Bakker and Lelkes (2024)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11182229/)
argue for a richer treatment of affect than a single warmth score.
[Campos and Federico (2026; online 2025)](https://doi.org/10.1017/S0003055425000255)
distinguish othering, aversion, and moralization in a validated multidimensional
scale. Their components have different associations with democratic attitudes.
A future study should measure these outcomes directly where relevant; the old
thermometers cannot be retroactively relabeled as those constructs.

## Which explanations can be tested?

[Lelkes (2021; online 2019)](https://doi.org/10.1017/psrm.2019.18) independently
randomizes hypothetical candidates' ideology and party labels and finds stronger
responses to ideology. That gives policy-based evaluation a serious place among
the explanations. It does not show that actual campaign-period change is caused
by learning. Perceived ideological disagreement can accompany changing affect
without beliefs becoming more accurate. A within-person association would be
informative; its direction remains unresolved because affect can also shape
placements and common events can change both.

[Holliday, Lelkes, and Westwood (2025)](https://doi.org/10.1073/pnas.2508827122)
find that average reductions from depolarization interventions are modest and
short-lived, with no clear durable advantage from stacking or repeating them.
Immediate responses and persistence need separate estimands. Their evidence
about reducing animosity does not establish that negative ads cannot increase it.

For this repository, a causal explanatory analysis requires specifying:

1. **Treatment and estimand:** the effect of a particular balanced message bundle,
   a framing manipulation, information, or a plausibly exogenous exposure change.
   These are different interventions, not interchangeable versions of “campaigning.”
2. **Assignment and counterfactual:** why comparable respondents receive different
   exposure, which comparisons identify the effect, and where overlap exists.
   Interview-date balance addresses respondent selection; it does not separate
   advertising from other events happening at the same time.
3. **Outcomes and timing:** baseline identity, repeated candidate/party/supporter
   outcomes, accuracy benchmarks where learning is proposed, and delayed follow-up.
4. **Interpretation of a null:** intervals against an independently motivated
   smallest meaningful effect, and an account of noncompliance and attrition.
   Failure to reject zero is not evidence that a mechanism contributes nothing.

The existing advertising exports need an assignment roster and protocol before
supporting a randomized comparison. Even then, the balanced tone contrast is an
effect of the available bundles, not an isolated tone effect. Details and recovery
requirements are in [research-design.md](research-design.md).

## Findings that change the extension design

- **Phillips and Warner (2026), [Election Outcomes and Affective Polarization in
  the United States](https://doi.org/10.1177/10659129251411892).** Their ANES
  pre/post comparisons already extend through 2024. They attribute the
  winner–loser difference principally to losers' declining in-party warmth.
  The paper uses different pre/post scales and examines this in its appendix.
  Its close-race design concerns local electoral success; respondent fixed
  effects alone do not identify the effect of national victory. Our extension
  must distinguish campaign growth from election-transition change.
- **Tyler and Iyengar (2024), [Testing the Robustness of the ANES Feeling
  Thermometer Indicators of Affective Polarization](https://doi.org/10.1017/S0003055423001302).**
  Mode changes account for some apparent growth in mixed-mode ANES trends, while
  rising out-party animus remains after their checks. This makes comparable-mode
  estimates necessary; neither “all artifact” nor ignoring mode follows.
- **Dias and Lelkes (2022), [The Nature of Affective Polarization](https://doi.org/10.1111/ajps.12628).**
  Their survey and experiments distinguish policy disagreement from identity
  while showing that policies convey identity information. Read beside
  Lelkes (2021), this rules out treating independently randomized labels and
  positions as automatically independent psychological pathways.
- **Gidron, Adams, Horne, and Tichelbaecker (2025), [Beyond Observational
  Relationships](https://doi.org/10.1017/S0007123425000158).** Randomized prompts
  about cultural or economic disputes increase distrust of opposing supporters
  relative to a nonpolitical prompt. This tests salience, not accurate learning.
  The immigration-specific analysis selects people by a post-treatment written
  response; balancing that selected group does not inherit the prompt's random
  assignment. Distinguish the randomized contrast from this secondary analysis.
- **Allcott et al. (2026), [The Effects of Political Advertising on Facebook and
  Instagram before the 2020 US Election](https://doi.org/10.1038/s41562-025-02328-w).**
  Random removal of political ads gives a direct exposure test and finds no
  detectable polarization or candidate-favorability effects. It tests a specific
  advertising mix on two platforms over six weeks, with other communication
  continuing. It does not isolate negative tone. Inspect outcome-specific bounds
  before calling an effect negligible. The
  [author manuscript](https://web.stanford.edu/~gentzkow/research/ads_experimental.pdf)
  supplies the design and outcome definitions; published metadata establish the
  2026 publication date.
- **Sood and Iyengar (2018), [All in the Eye of the Beholder: Partisan Affect and
  Ideological Accountability](https://gsood.com/research/papers/inNout.pdf).**
  The [companion replication](https://github.com/soodoku/in-n-out) separates
  perceived disagreement from evaluation conditional on disagreement. In the
  unreleased revised CCES analysis, the co-partisan approval slope is steeper for
  perceived than actual distance; opposing-party slopes are similar. A check
  holding observations fixed within each group preserves that pattern. These
  estimates condition on the common item calibration and are cross-sectional
  associations, not estimates of perceptions causing approval.
  The experiment assigns hypothetical candidate positions within
  partisan-consistent ranges. Its out-party extremity contrasts are negative,
  while its in-party contrasts show no consistent penalty. Extremity need not
  increase distance from a particular respondent, and absolute and squared
  distance yield different comparisons for some groups. It therefore motivates
  separate own- and opposing-candidate associations without supplying a universal
  spatial-response function. This tests supplied positions rather than
  corrections of prior beliefs about actual candidates. A real-candidate
  correction study with baseline perceptions, supporter outcomes, and delayed
  measurement asks a different question; novelty still requires comparison
  with existing correction experiments.

## What to build next

Prioritize compatible repeated measurements through 2024, followed by contemporary
party/group series through their actual last observation. Compare within-campaign,
election-transition, and between-election changes separately. The
[data inventory](data-extension.md) identifies a consequential obstacle: the 2020
Social Media Study does not repeat the respondent's candidate thermometers in its
post-election questionnaire. Questions about how others rate a candidate cannot
fill that gap.

The implemented joint 2008 panel contrast sharpens the historical description,
but is not sufficient novelty by itself. The strongest extension would locate
when candidate-specific movement occurs, how its components differ, and whether
movement later appears in explicitly measured supporter evaluations. Baseline
familiarity and scale limits can describe heterogeneity; they cannot identify
its cause. A repeated Trump series also changes political roles across waves.

Use the two focused interventions in [research-design.md](research-design.md) to
test specified information and message effects. Do not promise a decomposition
of natural campaign change into psychological mechanisms. Continue the descriptive
paper even if a well-powered intervention produces a precisely small effect.

## Source coverage

The discussion of Singh and Thornton, Bolsen and Thornton, Eck and Michel,
the 2026 Druckman et al. review, Dias and Lelkes, and Bakker and Lelkes relies
on abstracts or selected publisher sections. Detailed use of their estimators
requires consulting the full texts. Other discussions draw on full texts or
substantial methods and results sections. The revised Sood–Iyengar estimates
refer to an unreleased companion replication and may differ from the linked
published chapter.

This focused review covers campaign timing, evaluation targets, advertising,
policy perceptions, and measurement. It is not an exhaustive novelty search.
