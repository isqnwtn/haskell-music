# Haskell Music Compiler
  This is a music compiler, which means the language written will be compiled into an audio file. The program handles both compiling and running of the source code
the language is unnamed at present. This language doesn't support inputs at present, which means the program should compile and run with the only result/output being
the audio file generated.

## example
```
fun main{
p 2 0.5
p 1 1.0
p 3 0.25
p 4 0.5
p 1 1.0
p 6 0.75
p 7 0.1
}
```
p stands for play, the next is an integer which denotes the note, and following its a float which denotes the duration for which the note is played

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

