-- for music composition
import Composer

-- For parsing input
import Compiler.Grammar
import Compiler.Tokens

-- Commnad line arguments and data input
import System.IO
import System.Environment

-- Functions regarding parsing input
readContent = do
    args <- getArgs
    if ( length args ) == 0
    then do
         contents <- getContents
         return contents
    else do
         handle <- openFile ( head args ) ReadMode
         contents <- hGetContents handle
         return contents

main::IO()
main = do
    -- reading the content from either command line or stdin
    inp <- readContent

    -- parsing the content to create ast ( form Compiler module)
    let ast = parseCalc (scanTokens inp)

    -- for testing purposes
    print ast

    -- save the binary file ( from Composer module )
    save outputFilePath ast

    --runCommand "ffmpeg -f f32le -ar 48000 -i output.bin output.wav"
    return ()
