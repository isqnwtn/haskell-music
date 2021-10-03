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
outputFilePath = "output/output.bin"

outputWavPath :: FilePath
outputWavPath = "output/output.wav"

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
        zipWith (*) baseWave env
        where
            baseLen = fromIntegral $ length baseWave
            attackLen = attack * baseLen
            attackStep = 1.0 / attackLen
            attackArray = [0.0,attackStep..1.0]
            releaseLen = release * baseLen
            releaseStep = 1.0 / releaseLen
            releaseArray = reverse [0.0,releaseStep..1.0]
            sustainArray = take ( round (baseLen - (attackLen + releaseLen)) ) $ repeat 1.0
            env = concat [attackArray , sustainArray , releaseArray] :: [Pulse]
            

note::Semitones->Seconds->[Pulse]
note n duration = envelop 0.1 0.1 $ freq (f n) duration

wave::[Pulse]
wave = concat [note i 1.0|i<-[0..10]]


save::FilePath ->IO ()
save filePath = B.writeFile filePath $ B.toLazyByteString $ fold $ map B.floatLE wave

main::IO()
main = do
    save outputFilePath
    --runCommand "ffmpeg -f f32le -ar 48000 -i output.bin output.wav"
    return ()
