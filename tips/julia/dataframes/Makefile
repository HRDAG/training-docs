# vim: set ts=8 sts=0 sw=8 si fenc=utf-8 noet:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     TS
# Maintainers: TS
# Copyright:   2022, HRDAG, GPL v2 or later
# =========================================

readme := ./dfs.md
script := src/dfs.jl

.PHONY: all clean

all: $(readme)

clean: 
	-rm -r output/*

$(readme): $(script)
	julia --project -e "using Pkg; Pkg.resolve(); Pkg.instantiate()"
	julia --project --threads=auto \
		-e 'using Literate; Literate.markdown("$<", outputdir=".", flavor=Literate.CommonMarkFlavor(); config=Dict("execute" => true))'
