.PHONY: restore analysis figures tables manuscript paper format lint test check ci-docker clean extensions candidate-pool

restore:
	Rscript -e 'renv::restore(prompt = FALSE)'

analysis:
	Rscript scripts/run_all.R

figures: analysis
	Rscript scripts/figures.R
	Rscript scripts/candidate_pool.R

tables: analysis
	Rscript scripts/tables.R

candidate-pool:
	Rscript scripts/candidate_pool.R

extensions:
	Rscript scripts/extensions.R

manuscript:
	cd ms && latexmk -xelatex -interaction=nonstopmode -halt-on-error main.tex

paper: figures tables
	$(MAKE) manuscript

format:
	Rscript -e 'styler::cache_deactivate(); for (d in c("R", "scripts", "tests")) styler::style_dir(d)'

lint:
	Rscript -e 'l <- unlist(lapply(c("R", "scripts", "tests"), lintr::lint_dir), recursive = FALSE); print(l); quit(status = as.integer(length(l) > 0))'

test:
	Rscript -e 'testthat::test_dir("tests/testthat", stop_on_failure = TRUE)'

check: paper lint test

ci-docker:
	docker run --platform linux/amd64 --rm \
		-e RENV_CONFIG_REPOS_OVERRIDE=https://packagemanager.posit.co/cran/__linux__/noble/latest \
		-v polarcamp-renv-cache:/root/.cache/R/renv \
		-v "$(PWD):/project" -w /project rocker/verse:4.6.0 \
		bash -lc "tlmgr install latexmk tex-gyre amsfonts placeins fontspec geometry booktabs natbib setspace caption hyperref && make restore check"

clean:
	cd ms && latexmk -C main.tex
