import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Builder as B
import Data.Foldable
import System.Process
import Text.Printf

type Pulse = Float
type Seconds = Float
type Samples = Float
type Hz = Float
type Semitones = Float

outputFilePath :: FilePath
outputFilePath = "output.bin"

volume::Float
volume = 0.5

sampleRate::Samples
sampleRate = 48000

pitchStandard::Hz
pitchStandard=440.0

f::Semitones->Hz
f n= pitchStandard * (2 ** (n/12.0))

freq::Hz->Seconds->[Pulse]
freq hz duration = 
    map (* volume) $ output 
    where 
        step = (hz * 2 * pi) / sampleRate
        output::[Pulse]
        output = map sin $ map (* step) [0.0 .. sampleRate * duration]

envelop::Seconds->Seconds->[Pulse]->[Pulse]
envelop attack release baseWave=
    if attack+release > 1.0 then error "not able to create attack and release"
    else
        baseWave
        where
            baseLen = length baseWave
            attackLen = round attack*(fromIntegral baseLen)

note::Semitones->Seconds->[Pulse]
note n duration = envelop 0.25 0.25 $ freq (f n) duration

wave::[Pulse]
wave = concat [note i 1|i<-[0..10]]


save::FilePath ->IO ()
save filePath = B.writeFile filePath $ B.toLazyByteString $ fold $ map B.floatLE wave

play::IO()
play = do
    save outputFilePath
    _ <- runCommand $ printf "ffplay -f f32le -showmode 1 -ar %f %s" sampleRate outputFilePath
    return ()