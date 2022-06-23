mz := ../import/output/music.parquet
pairs := ../blocking/output/candidate-pairs.parquet
output := output/pair-classifier-features.parquet

.PHONY: all clean

all: $(output)

clean: 
	-rm -r output/*

$(output): src/compare.R $(mz) $(pairs)
	-mkdir output
	Rscript --vanilla $<

# done.
	
