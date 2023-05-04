# vim: set ts=8 sts=0 sw=8 si fenc=utf-8 noet:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     FL
# Maintainers: FL
# Copyright:   YYYY, HRDAG, GPL v2 or later
# =========================================
# Project-Name/parent-task/core-task/Makefile

# ---- dependencies {{{
HERE := $(shell git rev-parse --show-toplevel)
input := $(HERE)/other-parent/other-core/output/filename.ext
subtask_target := $(HERE)/parent-task/sub-task
py_target := $(HERE)/parent-task/core-task/output/py-out.parquet
r_target := $(HERE)/parent-task/core-task/output/r-out.parquet
# }}}

# ---- standard {{{
.PHONY: help all clean sym_target

help:
	@echo "---------------HELP-----------------------------"
	@echo "To purge existing output, run make clean"
	@echo "To rebuild all output, run make all"
	@echo "To rebuild a single target, run make target_name"
	@echo "------------------------------------------------"

all: subtask_target sym_target py_target r_target

clean: 
	-rm -r output/*
# }}}

# "$<" tells Make to fill in the variable with the first dependency passed to the target
# "$@" tells Make to fill in the variable with the target name
# ---- task-specific {{{
subtask_target: dependency
	cd $@ && make

sym_target: dependency
	-mkdir output
	cd output && ln -s ../$< .

py_target: \
		src/task.py \
		$(input)
	-mkdir output
	python $< \
		--input=$(input) \
		--output=$@

r_target:\
		src/task.R \
		$(input)
	-mkdir output
	Rscript --vanilla $< \
		--input=$(input) \
		--output=$@
# }}}
 
# done.
