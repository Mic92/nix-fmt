{
open Lexing
open Generator

exception SyntaxError of string

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }
}

let id = ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_' '\'' '-']*
let int =  ['0'-'9']+
let float =  ((['1'-'9']['0'-'9']* '.' ['0'-'9']*)|('0'? '.' ['0'-'9']+))(['E' 'e']['+' '-']?['0'-'9']+)?
let path = ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+']*('/' ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+']+)+ '/'?
let hpath = '~' ('/' ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+']+)+ '/'?
let spath = '<' ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+']+('/' ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+'] '+')* '>'
let uri = ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '+' '-' '.']* ':' ['a'-'z' 'A'-'Z' '0'-'9' '%' '/' '?' ':' '@' '&' '=' '+' '$' ',' '-''_' '.' '!' '~' '*' '\'']+

rule read = parse 
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | "assert" { ASSERT }
  | "with" { WITH }
  | "let" { LET }
  | "in" { IN }
  | "rec" { REC }
  | "inherit" { INHERIT }
  | "or" { OR }
  | "..." { ELLIPSIS }
  | "==" { EQ }
  | "!=" { NEQ }
  | "<=" { LEQ }
  | ">=" { GEQ }
  | "&&" { AND }
  | "||" { OR }
  | "->" { IMPL }
  | "//" { UPDATE }
  | "++" { CONCAT }
  | eof  { EOF }
