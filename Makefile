.PHONY: all pdf watch check-log clean clean-aux

all: pdf

pdf:
	latexmk

watch:
	latexmk -pvc

check-log:
	@if [ ! -f build/thesis.log ]; then \
		echo "build/thesis.log not found; run make pdf first."; \
	else \
		grep -niE 'LaTeX Error|Package .*Warning|Class .*Warning|LaTeX Warning|undefined references?|undefined citations?|Citation .* undefined|Reference .* undefined|Label .* multiply defined|multiply defined|Overfull \\hbox|Underfull \\hbox|Missing character|Rerun to get|Please rerun|rerun LaTeX|BibTeX|Biber' build/thesis.log || echo "No matching log warnings found."; \
	fi

clean-aux:
	latexmk -c

clean:
	latexmk -C
