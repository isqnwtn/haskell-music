# Haskell Music Compiler
  This is a music compiler, which means the language written will be compiled into an audio file. The program handles both compiling and running of the source code
the language is unnamed at present. This language doesn't support inputs at present, which means the program should compile and run with the only result/output being
the audio file generated.

## example
```
fun main{
p (0.5 2)
p (0.5 (1 3) )
p (1.0 1)
p (0.25 3)
p (0.5 4)
p (1.0 1)
p (0.75 6)
p (0.1 7)
}
```
p stands for play, the next is a float denoting the note duration, and following is an integer if its only playing one note, or a set of integers if its playing multiple notes together.

## Building and running
### build
```cosole
$cabal build
```
### run
```console
$ cabal run filename 
$ make 
```
renaming output file isnt a feature at present. Currently `cabal run <filename>` will yeild output/outpu.bin
make command can be used to convert all bin files inside output/ to wav files ( you'll need to have ffmpeg installed )

