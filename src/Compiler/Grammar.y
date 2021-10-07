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

Function: fun var '{' Statements '}' { $4 }

Statements : Statement                   { [$1] }
           | Statement Statements         { ($1:$2) }

Statement: Note                          { $1 }
         | Chord                         { $1 }

Note: p '(' float int ')'           { NoteC $3 $4 }

Chord: p '(' float '(' ints ')' ')' { ChordC $3 $5 }

ints : int                          { [$1] }
     | int ints                     { ($1:$2) }


{

parseError :: [Token] -> a
parseError _ = error "Parse error"

type Program = [Statement]
data Statement = NoteC Float Int
               | ChordC Float [Int]
          deriving Show
}
