# Authors:     FL
# Maintainers: FL
# Copyright:   YYYY, HRDAG, GPL v2 or later
# =========================================
# Project-Name/parent-task/core-task/Makefile

input := input/filename.ext

.PHONY: help all clean

help:
	@echo "---------------HELP-----------------------------"
	@echo "To purge existing output, run make clean"
	@echo "To rebuild all output, run make all"
	@echo "To rebuild a single target, run make target_name"
	@echo "------------------------------------------------"

all: subtask_target sym_target py_target r_target

clean: 
	-rm -r output/*

subtask_target: dependency
	cd $@ && make

sym_target: dependency
	-mkdir output
	cd output && ln -s ../$< .

py_target: \
		src/task.py \
		$(input)
	-mkdir output
	python3 $< \
		--input=$(input) \
		--output=$@

r_target:\
		src/task.R \
		$(input) \
	-mkdir output
	Rscript --vanilla $< \
		--input=$(input) \
		--output=$@
# done.

