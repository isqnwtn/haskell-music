{
module Compiler.Grammar where
import Compiler.Tokens
}

%name parseCalc
%tokentype { Token }
%error { parseError }

%token
    p   { TokenP }
    fun { TokenFun }
    int { TokenInt $$ }
    float { TokenFloat $$ }
    var { TokenSym $$ }
    '=' { TokenEq }
    '+' { TokenPlus }
    '-' { TokenMinus }
    '*' { TokenTimes }
    '/' { TokenDiv }
    '(' { TokenLParen }
    ')' { TokenRParen }
    '{' { TokenLCurl }
    '}' { TokenRCurl }

%right in
%nonassoc '>' '<'
%left '+' '-'
%left '*' '/'
%left NEG

%%

Function: fun var '{' Notes '}' { $4 }

Notes: Note                  { [$1] }
     | Note Notes            { ($1:$2) }

Note: p int float            { NoteC $2 $3 }


{

parseError :: [Token] -> a
parseError _ = error "Parse error"


data Note = NoteC Int Float
          deriving Show
}
