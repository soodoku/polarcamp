# Data for extending the paper through the present

Checked October 4, 2026. The historical estimates in the manuscript still use
the documented 2000–2008 sources. This inventory does not present results from
newer elections. Dataset availability, compatible items, and credible
identification are separate requirements. The extension protocol is in
[research-design.md](research-design.md).

## Priority sources

| Source | Verified opportunity | Important limitation | Implementation status |
|---|---|---|---|
| [ANES 2024 Time Series](https://electionstudies.org/data-center/2024-time-series-study/) | Named candidates and parties in the pre-election wave; candidate thermometers and CSES evaluations afterward. May 19, 2026 release. | Fresh samples and a returning cohort have different targets. One pre and one post interview do not supply a within-person early/late campaign contrast. | Official metadata and relevant instrument sections inspected; microdata not yet acquired. |
| [ANES 2016–2020–2024 merged panel](https://electionstudies.org/data-center/2016-2020-2024-panel-merged-study/) | Repeated respondents, with additional maintenance surveys; May 19, 2026 release. | A surviving 2016 cohort, not the 2024 electorate. Maintenance waves are not automatically complete affect batteries. | Official design inspected; repeated-variable mapping and appropriate longitudinal weights still required. |
| [ANES 2020–2022 Social Media Study](https://electionstudies.org/data-center/2020-2022-social-media-study/) | Three-wave online probability panel; repeated party thermometers, candidate traits, and policy perceptions. | The 2020 post-election questionnaire omits direct candidate thermometers. Linked Facebook records require separate restricted access. | Codebook and post questionnaire inspected; public survey microdata not yet acquired. |
| [Polarization Research Lab / America's Political Pulse](https://americaspoliticalpulse.com/data) | Frequent contemporary group-affect and democratic-attitude measurements; public survey archive and codebook. | Group wording is not an explicit ordinary-supporter measure; do not assume recurring candidate outcomes. Reinterviews and weights need design checks. | Public archive acquisition and date/schema verification described below. |
| [ANES Data Center](https://electionstudies.org/data-center/) — 2012, 2016, 2020 releases and cumulative file | Intermediate elections for comparison with 2024. | Harmonized names are not proof of equal mode, wording, universe, or date coverage. | Retrieve individual-study codebooks and item mappings before pooling. These years are coverage targets, not completed analyses. |
| [Sood–Iyengar ideological-accountability materials](https://github.com/soodoku/in-n-out) | Existing experimental policy-position variation. | Hypothetical positions in partisan-consistent ranges; not natural learning or real-candidate corrections. | Paper design reviewed; assignment and raw materials need reproduction before reuse. |

## Verified item anchors

The [2024 codebook](https://electionstudies.org/anes_timeseries_2024_userguidecodebook_accessible_html/)
identifies pre-election Harris and Trump thermometers as `V241156`/`V241157`
and party thermometers as `V241166`/`V241167`. Post-election CSES party
like/dislike items are `V242432`/`V242433`; corresponding candidate items are
`V242434`/`V242435`. CSES responses run 0–10, with special positive and negative
missing codes. These must not enter means as valid responses. The pre-election
thermometers and post-election CSES items differ in wording and resolution;
multiplying by ten cannot validate change. A within-wave candidate–party contrast
is feasible, but its change across instruments needs a measurement argument.
Record exact release, item order, mode, and eligibility alongside every mapping.

The [Social Media Study codebook](https://electionstudies.org/anes_specialstudy_2020-2022_socialmedia_userguidecodebook_20230705/)
provides `fttrump`, `ftjb`, `ftdem`, `ftrep` at baseline, party thermometers
`w2ftdem`/`w2ftrep` at wave 2, and `w3fttrump`, `w3ftjb`, `w3ftdem`, `w3ftrep`
at wave 3. Weights are `weight_pre`, `weight_post`, and `w3weight` for the
corresponding observation sets. The codebook dates are August 20–September 17,
2020; November 1, 2020–January 1, 2021; and November 9, 2022–January 2, 2023.
Check actual dates because the nominal post-election wave starts before Election
Day. The [wave-2 questionnaire](https://electionstudies.org/anes_specialstudy_2020_socialmedia_post_qnaire/)
confirms that direct candidate thermometers are absent. Its third-person items
ask how typical voters rate candidates and parties; they measure perceived
others' views, not the respondent's own candidate or supporter affect. The
baseline-to-2022 candidate comparison is therefore a different, longer-period
estimand, not an uninterrupted three-wave candidate trajectory.

## Contemporary public-opinion series

The lab's [public codebook](https://americaspoliticalpulse.com/data/codebook)
identifies `democrat_therm_1`, `republican_therm_1`, `pid3`, `pid7`, `weight`,
`survey`, `uid_public`, `starttime`, and `endtime`. Its thermometer wording names
Democrats and Republicans as groups. Preserve that wording in labels. Do not
rename these variables as candidate ratings or ratings of explicitly ordinary
voters. The page describes propensity-score weights, which do not turn an
opt-in survey into a probability sample.

The [survey archive](https://americaspoliticalpulse.com/data/all-data.zip) was
acquired as `data/raw/prl_all_data_20261004.zip` (ignored; not part of the
historical build). SHA-256:
`249e147c21a7d3ac37d30c96246b5ecdc5a08900cad44503a996bfd857e59451`.
It contains 167,000 rows. Schema and date checks, without outcome estimation,
found valid interview start dates through June 29, 2026 and 155 invalid/empty
starts. The [manifest](https://americaspoliticalpulse.com/data/manifest.json)
instead reports coverage ending September 20, 2026. Reconcile this disagreement
before claiming September coverage. Older records use `survey`; six newer blocks
use `wave` while `survey` is blank. A naive grouping by either column would pool
unrelated interviews. Using the nonempty `survey` or `wave` field gives no duplicate
respondent–wave pairs in this snapshot. `uid_public` contains repeated respondents,
so rows cannot all be treated as independent people. Of the 167,000 rows, 6,000
are marked 2026; this is not a complete weekly series through September. No
contemporary affect estimates have been
added to the manuscript from this file.

Before estimating trajectories, verify duplicate respondent IDs, repeat
participation, per-wave party and item coverage, weight targets, and questionnaire
revisions. Cluster repeated observations by person and account for the sampling
of dates when the claim concerns a time series. A website's elite-rhetoric archive
is a record of messages issued; it does not establish respondent exposure.

## Acquisition and analysis sequence

1. Freeze each official release and errata, preserve a checksum, and map only
   verified questions. Keep respondent-level files ignored. Automated direct
   retrieval from ANES returned HTTP 403 in this session; the public codebooks
   were readable through the web tool. A normal official download or an
   authenticated institutional mirror is still needed for those microdata.
2. Inspect IDs, dates, universes, design variables, and item availability before
   looking at new contrasts. Report which comparisons fail coverage. Do not fill
   unavailable candidate outcomes with traits, approval, or perceived others'
   ratings.
3. Begin with comparable within-wave candidate–party contrasts and repeated
   candidate measurements, then estimate change only where the same instrument
   and population are supported. Keep cross sections, panels, and election
   transitions separate. Reproduce the closest published comparison alongside
   any added result to show what is new.
4. Use the contemporary lab series to assess the stability and components of
   group affect. It cannot supply the missing candidate–party–supporter joint
   panel by itself. Verify other prospective or archived panels against this
   exact requirement before adding sources simply for sample size.
5. For a 2026 prospective study, specify House/Senate candidate targets, baseline
   identity, explicit supporter questions, and follow-ups before fielding.
   This is a midterm extension with distinct populations and offices. New data
   collection and platform/IRB access are separate undertakings, not implied by
   having downloaded public survey files.
