all: output/music-entities.parquet

output/music-entities.parquet: ../merge/output/music-entities.parquet
	-mkdir output
	cd output && ln -s ../$<
	
# done.
