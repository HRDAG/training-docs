# vim: set ts=8 sts=0 sw=8 si fenc=utf-8 noet:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     TS
# Maintainers: TS
# Copyright:   2022, HRDAG, GPL v2 or later
# =========================================

.PHONY: all clean

all: \
	output/dfs.md \
	output/basics.md

clean: 
	-rm -r output/*

Manifest.toml: Project.toml
	julia --project -e "using Pkg; Pkg.resolve(); Pkg.instantiate()"

output/%.md: src/%.jl Manifest.toml
	-mkdir output
	julia --project --threads=auto src/compile-md.jl $< output

# done.
