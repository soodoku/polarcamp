# Manuscript and repository scope

- This is an unpublished manuscript being prepared for its first public version.
- Preserve the existing introduction, theory, literature discussion, and voice
  where consistent with the evidence. Concentrate revisions on methods, results,
  exhibits, and consequential abstract/discussion claims.
- Treat the comparisons as descriptive. Candidate, party, and ordinary-supporter
  evaluations are different constructs. Calendar time does not identify exposure.
- Use `../hidden` as the reference for R/LaTeX reproducibility and presentation.
- Rebuild source outcomes and generate all empirical numbers, tables, and macros.
- Test locally with `make check`; `make ci-docker` uses a standard Rocker image.
- Keep respondent-level data in ignored `data/raw/` and `data/derived/` paths.
- The original archive can be reacquired if needed; keep it outside this repo. Do not bring audit
  reports, superseded code, correspondence, or obsolete results into this repo.
- Analysis definitions and extension opportunities are in `docs/methods.md` and
  `extensions/docs/research-design.md`; source requirements are in `data/README.md`.

- Finish Part 1 against the original ComingToDislike manuscript before integrating
  extensions. Preserve supported original prose and descriptive questions.
- Part 2 code and research advice are retained separately in `extensions/` and
  built with `make extensions`. They are not manuscript dependencies.
- Advertising associations may be retained once airing records, geography, dates,
  and coverage are validated. Recover sources before rebuilding the failed join.
