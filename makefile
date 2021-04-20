all:
	ghc main.hs
test:
	./main
	rm -f output.wav
	ffmpeg -f f32le -ar 48000 -i output.bin output.wav
clean:
	rm output.*
cleanall:
	rm main main.hi main.o
