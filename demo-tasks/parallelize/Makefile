# vim: set ts=8 sts=0 sw=8 si fenc=utf-8 noet:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     BP
# Maintainers: BP
# Copyright:   2023, HRDAG, GPL v2 or later
# =========================================

lines := output/lines.parquet
pairs := output/linepairs.parquet

Lpy1 := output/L-py-singl.parquet
sdR1 := output/sd-R-singl.parquet

PHONY := tests

tests := \
         $(Lpy1)\
         $(sdR1)

$(Lpy1): src/Levanshtein.py
    python $< \
        --pairs=$(pairs)\
        --output=$@

$(sdR1): src/stringdist.R
    Rscript --vanilla $< \
        --pairs=$(pairs)\
        --output=$@
