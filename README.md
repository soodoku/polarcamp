# Coming to Dislike Your Opponents

**Candidate Evaluations during Presidential Campaigns**

Gaurav Sood and Shanto Iyengar

An unpublished manuscript and reproducible research repository examining
candidate evaluations in the 2000, 2004, and 2008 NAES rolling cross sections.
Part 1 reconstructs the original manuscript's descriptive questions, separates
own- and opposing-candidate evaluations, and compares time periods and states.
The advertising section remains pending recovery of the original airing data
and geographic crosswalk; the current PDF is a working draft.
Release scope and remaining limitations are recorded in [CHANGELOG.md](CHANGELOG.md).

- [Read the manuscript](ms/main.pdf) · [LaTeX source](ms/main.tex)
- [Analysis definitions and source mappings](docs/methods.md)
- [Recent literature and the paper’s contribution](extensions/docs/literature.md)
- [Research extensions and design recommendations](extensions/docs/research-design.md)
- [Data opportunities through 2026 and verified measurement limits](extensions/docs/data-extension.md)
- [Data access and provenance](data/README.md)

## Reproduce

Use R 4.6.0, GNU Make, and XeLaTeX/latexmk with TeX Gyre fonts. R packages are
pinned in `renv.lock`. From the project root:

```sh
make restore
make check
```

`make check` rebuilds the analysis, figures, generated tables and prose numbers,
compiles `ms/main.pdf`, and runs linting and functional tests. It requires the
three authorized NAES source files documented in `data/README.md`. Source checksums
are checked before analysis. Missing inputs stop the build.

```sh
make test       # Synthetic fixtures; no source microdata needed
make lint
make format
make ci-docker
```

The Docker target uses the standard `rocker/verse:4.6.0` AMD64 image, restores
the locked R environment through Posit’s Linux binary mirror, installs the
required TeX packages, and runs the full
check with locally mounted inputs. A named Docker volume caches R packages
between runs.
On ARM hosts it requires Docker's AMD64 emulation. Public GitHub Actions run
linting and data-independent tests; confidential inputs are not uploaded to CI.

`make extensions` separately rebuilds the ANES panel and 2012 experiment
analyses using the three additional inputs in `extensions/sources.csv`. Their
outputs and research recommendations are retained in `extensions/`; they do
not enter the Part 1 manuscript or its default build.

`make candidate-pool` rebuilds the [2008 candidate-field figure](figs/candidate_pool_2008.pdf)
and observed-rating coverage tables, also included in the main build. It checks the broader primary field without
substituting a changing candidate pool for the manuscript's fixed nominee pairs.

Individual targets are `analysis`, `figures`, `tables`, and `manuscript`.
`make paper` rebuilds all empirical exhibits before compiling; `make manuscript`
only recompiles existing exhibits. `make clean` removes LaTeX build products.

## Repository

| Path | Contents |
|---|---|
| `R/` | Validated coding, estimators, and exhibit helpers |
| `scripts/` | Analysis, figure, and table entry points |
| `tests/testthat/` | Synthetic coding, matching, estimation, and output tests |
| `data/raw/` | Ignored, immutable local inputs |
| `data/derived/` | Ignored, generated respondent-level data and session information |
| `tabs/` | Generated aggregate CSVs and LaTeX tables |
| `figs/` | Generated publication figures |
| `ms/` | Manuscript, bibliography, generated numerical macros, and PDF |
| `docs/` | Part 1 methods and input checksums |
| `extensions/` | Separate panel/experiment outputs and Part 2 research advice |

Primary autumn contrasts are in `tabs/naes_changes.csv`; battleground slope
differences are in `tabs/naes_battleground.csv`. Weekly trajectories, components,
uncertainty, and sensitivity analyses should be interpreted together. None of
these comparisons identifies the effect of campaign exposure.

Historical materials remain outside this repository. Release archives include
code, documentation, aggregate outputs, and the manuscript PDF. Respondent-level
inputs, derived microdata, and local build environments are excluded.
The manuscript remains an unpublished working paper. The authors retain all
rights under `LICENSE`; data access and provider restrictions are documented
in `data/README.md`.
