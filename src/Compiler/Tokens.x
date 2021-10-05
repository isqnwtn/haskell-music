{
module Compiler.Tokens where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-

  $white+                       ;
  "--".*                        ;
  let                           { \s -> TokenLet }
  in                            { \s -> TokenIn }
  fun                           { \s -> TokenFun }
  beg                           { \s -> TokenBeg }
  end                           { \s -> TokenEnd }
  if                            { \s -> TokenIf }
  else                          { \s -> TokenElse }
  while                         { \s -> TokenWhile }
  $digit+                       { \s -> TokenInt (read s) }
  \=                            { \s -> TokenEq }
  \+                            { \s -> TokenPlus }
  \-                            { \s -> TokenMinus }
  \*                            { \s -> TokenTimes }
  \/                            { \s -> TokenDiv }
  \(                            { \s -> TokenLParen }
  \)                            { \s -> TokenRParen }
  $alpha [$alpha $digit \_ \']* { \s -> TokenSym s }

{

-- The token type:
data Token = TokenLet
           | TokenIn
           | TokenFun
           | TokenBeg
           | TokenEnd
           | TokenIf
           | TokenElse
           | TokenWhile
           | TokenInt Int
           | TokenSym String
           | TokenEq
           | TokenPlus
           | TokenMinus
           | TokenTimes
           | TokenDiv
           | TokenLParen
           | TokenRParen
           deriving (Eq,Show)

scanTokens = alexScanTokens

}
