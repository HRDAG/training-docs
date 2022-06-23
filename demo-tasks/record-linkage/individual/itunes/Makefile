setup  := ../../setup/output
input  := $(setup)/1_itunes.csv
output := output/itunes.parquet
src    := src/import-itunes.R

.PHONY: all clean

all: $(output)

clean: 
	-rm -r output/*

$(output): $(src) $(input)
	-mkdir output
	Rscript --vanilla $<
