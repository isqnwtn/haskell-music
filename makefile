binfiles = $(wildcard output/*.bin)
wavfiles = $(patsubst %.bin, %.wav, $(binfiles))
all:$(wavfiles)
	@echo "Build wav files"
output/%.wav:output/%.bin
	ffmpeg -f f32le -ar 48000 -i $^ $@
clean:
	rm output/*.wav
cleanall:
	rm output/*
