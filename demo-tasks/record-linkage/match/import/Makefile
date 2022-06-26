
amz := ../../individual/amazon/output/amz.parquet
itn := ../../individual/itunes/output/itunes.parquet
output := output/music.parquet
src := src/concatenate.R

.PHONY: all clean

all: $(output)

clean: 
	-rm -r output/*

$(output): $(src) $(amz) $(itn)
	-mkdir output
	Rscript --vanilla $<
