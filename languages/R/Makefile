# vim: set ts=8 sts=0 sw=8 si fenc=utf-8 noet:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     TS
# Maintainers: TS
# Copyright:   2022, HRDAG, GPL v2 or later
# =========================================

.PHONY: all clean

sections := performance

all: $(patsubst %,output/%.md,$(sections))

clean: 
	-rm -r output/*

output/%.md: src/%.Rmd
	-mkdir output
	Rscript -e "rmarkdown::render('$<')"
	mv src/$*.md $@
	
