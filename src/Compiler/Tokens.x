{
module Compiler.Tokens where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-

  $white+                       ;
  "--".*                        ;
  p                             { \s -> TokenP }
  fun                           { \s -> TokenFun }
  $digit+                       { \s -> TokenInt (read s) }
  $digit+"."$digit+             { \s -> TokenFloat (read s) }
  \=                            { \s -> TokenEq }
  \+                            { \s -> TokenPlus }
  \-                            { \s -> TokenMinus }
  \*                            { \s -> TokenTimes }
  \/                            { \s -> TokenDiv }
  \(                            { \s -> TokenLParen }
  \)                            { \s -> TokenRParen }
  \{                            { \s -> TokenLCurl }
  \}                            { \s -> TokenRCurl }
  $alpha [$alpha $digit \_ \']* { \s -> TokenSym s }

{

-- The token type:
data Token = TokenP
           | TokenFun
           | TokenInt Int
           | TokenSym String
           | TokenFloat Float
           | TokenEq
           | TokenPlus
           | TokenMinus
           | TokenTimes
           | TokenDiv
           | TokenLParen
           | TokenRParen
           | TokenLCurl
           | TokenRCurl
           deriving (Eq,Show)

scanTokens = alexScanTokens

}
