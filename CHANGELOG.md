# Releases

## 0.1.1 — 2026-10-04

Includes the six source datasets used by the manuscript and existing extensions:
the 2000, 2004, and 2008 NAES workspaces, the ANES panel workspace, and both
2012 advertising experiment exports. These files are distributed with the
author's authorization and match the existing source manifests. A checkout or
release ZIP now contains the inputs needed for `make check` and `make extensions`.

The manuscript, analysis code, and results are unchanged from 0.1.0. The
research limitations described below still apply. Other inputs, generated
respondent-level files, and local environments remain excluded.

## 0.1.0 — 2026-10-04

Initial working-paper snapshot of *Coming to Dislike Your Opponents:
Candidate Evaluations during Presidential Campaigns*.

The release includes the manuscript PDF and LaTeX source, a reproducible R
analysis of the 2000, 2004, and 2008 NAES surveys, generated tables and figures,
source manifests, and functional tests. It follows fixed eventual nominees
within each election and adds individual-candidate trajectories for the
broader observed 2008 primary field. ANES panel analyses, the 2012 advertising
experiment, and later-data research opportunities remain separate extensions.

This is a descriptive research release. The original observational advertising
analysis remains pending source airing records and the geographic crosswalk.
Archived NAES workspaces retain some researcher-created demographic, party-ID,
and weight fields; complete original releases would improve their provenance.
Experiment estimates remain conditional on the available exports while
assignment and selection documentation is recovered. None of these limitations
is resolved by issuing this snapshot.

Respondent-level data and local environments are not distributed. Rebuilding
empirical results requires authorized copies of the inputs documented in
`data/README.md`. Synthetic tests run without those inputs. The authors retain
all rights under `LICENSE`.
