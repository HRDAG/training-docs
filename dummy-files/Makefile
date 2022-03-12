# Authors:     FL
# Maintainers: FL
# Copyright:   YYYY, HRDAG, GPL v2 or later
# =========================================
# Project-Name/parent-task/core-task/Makefile

input := ‘input/filename.ext’
output := ‘output/filename.ext’

src_py := ‘src/code.py’
src_R := ‘src/code.R’

.PHONY: all clean

all: $(output)

clean: 
	-rm -r output/*

$(output): \
		$(src_py) \
		$(input)
	-mkdir output
	python3 $< \
		--input=$(input) \
		--output=$@

$(output):\
		$(src_R) \
$(input)
	-mkdir output
	Rscript --vanilla $< \
		--input=$(input) \
		--output=$@
# done.

