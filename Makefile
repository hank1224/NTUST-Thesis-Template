.PHONY: all pdf pdf-in-container check check-layout check-log logs clean

PYTHON ?= python3

THESIS_SOURCE := main.tex
THESIS_JOB := thesis
THESIS_PDF := build/$(THESIS_JOB).pdf
THESIS_LOG := build/$(THESIS_JOB).log

LATEX_ENV = TEXMFVAR="$(CURDIR)/build/texmf-var" TEXMFCACHE="$(CURDIR)/build/texmf-var"
LATEXMK_ARGS = -g -jobname=$(THESIS_JOB) -outdir=build -auxdir=build

all: pdf

pdf:
	tooling/latex/run-in-docker.sh

pdf-in-container:
	@test "$(THESIS_DOCKER_BUILD)" = "1" || { echo "Use 'make pdf'; host TeX compilation is not supported." >&2; exit 1; }
	@test -f /.dockerenv || { echo "The thesis TeX build must run inside the pinned Docker container." >&2; exit 1; }
	mkdir -p build/texmf-var
	$(LATEX_ENV) latexmk $(LATEXMK_ARGS) $(THESIS_SOURCE)

check:
	$(MAKE) pdf
	$(MAKE) check-layout check-log

check-layout:
	$(PYTHON) -m tooling.qa.checks.layout --fls build/thesis.fls

check-log:
	$(PYTHON) -m tooling.qa.checks.log --log "$(THESIS_LOG)" --warnings-output build/qa/log-warnings.txt

logs:
	tooling/latex/show-logs.sh

clean:
	$(RM) -r build
