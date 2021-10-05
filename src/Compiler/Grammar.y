{
module Compiler.Grammar where
import Compiler.Tokens
}

%name parseCalc
%tokentype { Token }
%error { parseError }

%token
    let { TokenLet }
    in  { TokenIn }
    p   { TokenP }
    int { TokenInt $$ }
    var { TokenSym $$ }
    '=' { TokenEq }
    '+' { TokenPlus }
    '-' { TokenMinus }
    '*' { TokenTimes }
    '/' { TokenDiv }
    '(' { TokenLParen }
    ')' { TokenRParen }

%right in
%nonassoc '>' '<'
%left '+' '-'
%left '*' '/'
%left NEG

%%

Notes: Note                  { [$1] }
     | Note Notes            { ($1:$2) }

Note: p int int            { NoteC $2 $3 }


{

parseError :: [Token] -> a
parseError _ = error "Parse error"


data Note = NoteC Int Int
          deriving Show
}
