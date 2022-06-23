recs := ../import/output/music.parquet
ents := ../cluster/output/entity-ids.parquet
output := output/music-entities.parquet

.PHONY: all clean

all: $(output)

clean: 
	-rm -r output/*

$(output): src/choose-canonical.R $(recs) $(ents)
	-mkdir output
	Rscript --vanilla $<
	
