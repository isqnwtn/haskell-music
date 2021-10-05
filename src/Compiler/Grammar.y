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
    fun { TokenFun }
    beg { TokenBeg }
    end { TokenEnd }
    if  { TokenIf }
    else{ TokenElse }
    while{ TokenWhile }
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

Func : fun var Args beg Statements end { Func $2 $3 $5}

Args : '(' ')' {[]}
     | '(' ArgList ')' { $2 }

ArgList : var { [$1] }
        | var ArgList { ($1:$2) }

Statement : var '=' Exp { AssignC $1 $3 }
          | if '(' var ')' beg Statements end { IfC $3 $6 }
          | if '(' var ')' beg Statements end else beg Statements end { IfElC $3 $6 $10 }
          | while '(' var ')'  beg Statements end { WhileC $3 $6 }

Statements : Statement        { [$1] }
           | Statement Statements { ($1:$2) }

Exps : Exp          { [$1] }
     | Exp Exps  { ($1:$2) }

Exp : Exp '+' Exp            { Plus $1 $3 }
    | Exp '-' Exp            { Minus $1 $3 }
    | Exp '*' Exp            { Times $1 $3 }
    | Exp '/' Exp            { Div $1 $3 }
    | '(' Exp ')'            { Brack $2 }
    | '-' Exp %prec NEG      { Negate $2 }
    | int                    { Int $1 }
    | var                    { Var $1 }



{

parseError :: [Token] -> a
parseError _ = error "Parse error"

type Program = [Function]

data Function = Func String [String] [Statement]

data Statement = AssignC String Exp
               | IfC String [Statement]
               | IfElC String [Statement] [Statement]
               | WhileC String [Statement]

data Exp = Plus Exp Exp
         | Minus Exp Exp
         | Times Exp Exp
         | Div Exp Exp
         | Negate Exp
         | Brack Exp
         | Int Int
         | Var String
         deriving Show
}
