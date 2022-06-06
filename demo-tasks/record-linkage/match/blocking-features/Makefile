input := ../import/output/music.parquet
output := output/blockfeats.parquet
src := src/feats.R

.PHONY: all clean

all: $(output)

clean: 
	-rm -r output/*

$(output): $(src) $(input)
	-mkdir output
	Rscript --vanilla $<

# done.
	
