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

note::Semitones->Seconds->[Pulse]
note n duration = freq (f n) duration

wave::[Pulse]
wave = concat [note i 1|i<-[0..10]]


save::FilePath ->IO ()
save filePath = B.writeFile filePath $ B.toLazyByteString $ fold $ map B.floatLE wave

play::IO()
play = do
    save outputFilePath
    _ <- runCommand $ printf "ffplay -f f32le -showmode 1 -ar %f %s" sampleRate outputFilePath
    return ()