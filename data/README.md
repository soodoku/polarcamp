# Data access and provenance

The repository and release archives include the six source files listed below,
with the author's authorization. Their bytes are preserved from the original
research archive and verified against the source manifests. Other inputs and
generated respondent-level files remain ignored by Git and excluded from release
archives. The manuscript is an unpublished working paper.

The manuscript inputs and SHA-256 hashes are recorded in
[`docs/sources.csv`](../docs/sources.csv). Additional panel and experiment inputs
are recorded in [`extensions/sources.csv`](../extensions/sources.csv). All six
files are included in `data/raw/`:

- `naes00.rdata`, `naes04.rdata`, `naes08.rdata`: archived NAES research workspaces;
- `nes08panel.Rdata`: archived ANES panel workspace, version 20100903;
- `CCAP_STAN_OUTPUT.CSV`, `CCAP_STAN_all_rand2.sav`: 2012 advertising study exports.

The supplied archive was named `polarcamp.zip`, SHA-256
`b2798b46d52e69723b66dd567e71ba5e51bbd71ef00de39a0f1a83589feaca65`.
The archive itself is not required to reproduce the current analyses.
In that archive, the survey inputs are under `polarcamp/data/` and the experiment
exports under `polarcamp/ads_exp/`. If reacquired, keep the archive outside the public repo.
It also holds the historical manuscript, programs, correspondence, and ancillary
files. They are not dependencies of the current build.

The [NAES program](https://www.annenbergpublicpolicycenter.org/political-communication/naes/)
and [ANES study page](https://electionstudies.org/data-center/2008-2009-panel-study/)
are the providers' starting points for access and documentation. New downloads
are not automatically byte-identical to these archived workspaces. Reconstructing
from a different release requires an explicit mapping and a new source manifest;
do not bypass a failed checksum to make the pipeline run.

`make analysis` verifies the three NAES sources before estimating or overwriting outputs.
Missing or changed files stop the build. Nothing silently substitutes synthetic
data for research results. `data/derived/` contains generated respondent-level
files and session information and is also ignored. `make test` uses synthetic
fixtures and works without source datasets; `make check` uses the three included
NAES inputs and compiles the paper from fresh analysis outputs. `make extensions`
uses the three included panel and experiment inputs.

Variable definitions, missingness rules, weights, and inferential assumptions
are documented in [`docs/methods.md`](../docs/methods.md).

## Inputs for planned extensions

The public PRL archive `raw/prl_all_data_20261004.zip` is a separate, ignored
input acquired for the contemporary extension. It is not required by the
manuscript build and has not been used to generate manuscript results.
Its source, checksum, date coverage, and remaining design checks are recorded in
[the extension inventory](../extensions/docs/data-extension.md). Newer ANES inputs remain
to be acquired from the official releases.

## Sources needed to finish the original advertising analysis

The 2000 and 2004 Wisconsin Advertising Project presidential airing files
must identify broadcast date, media market, ad creative, sponsor/candidate,
and tone. We also need market coverage dates, codebooks, and the geographic
crosswalk used to link respondents to media markets. These inputs allow
reconstruction of strictly prior thirty-day exposure and distinguish observed
zero airings from unobserved markets or dates.

A filename attested in another local replication script is
`Political Advertising in 2000.sav`. The same script uses
`WiscAs - GSH 2003-2004.dta`, which covers other offices; locate the
presidential counterpart. Search terms include `WiscAds`, `WAP`, `CMAG`,
`presidential`, `2000`, `2004`, `DMA`, and `crosswalk`. These are search clues,
not verified filenames in this project's original archive. Previously merged
`naes00ad.rdata` and `naes04ad.rdata` are insufficient to reconstruct exposure.

For the 2012 experiment we already have `CCAP_STAN_OUTPUT.CSV` and
`CCAP_STAN_all_rand2.sav`. Additional useful records are the fielded
questionnaire/program, stimuli, assignment records, dispositions, and the rule
selecting 1,200 cases from the 1,264 completed-case export. The original project
identifier in the export metadata is `CCAP12_STN_full2`; the original folder
was `polarcamp/ads_exp/`. This study concerns distinct ad bundles; comparing
negative to positive bundles and comparing negative bundles to control answer
different questions.

Complete original NAES releases and questionnaires for 2000, 2004, and 2008
would also help verify inherited demographics, party identification, and
weights. Search for `NAES00`, `NAES04`, `NAES08`, `Annenberg`, and `RCS`.
We already have the smaller author workspaces `naes00.rdata`, `naes04.rdata`,
and `naes08.rdata`; the full releases would supply additional provenance.
