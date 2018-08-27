{
open Core
open Lexing
open Generator

exception SyntaxError of string

module State = struct
  type lex_state = INITIAL
    | STRING
    | IND_STRING
    | INSIDE_DOLLAR_CURLY

  type t = {
    states: lex_state Stack.t;
  }

  let initial () =
    { states = Stack.of_list [INITIAL] }
end

open State

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }

let parse_integer value =
  try
    Int64.of_string value
  with Failure _ ->
    raise (SyntaxError ("Invalid integer literal " ^ value))

let parse_float value =
  try
    Float.of_string value
  with Failure _ ->
    raise (SyntaxError ("Invalid float literal " ^ value))

}

let id = ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_' '\'' '-']*
let int =  ['0'-'9']+
let float =  ((['1'-'9']['0'-'9']* '.' ['0'-'9']*)|('0'? '.' ['0'-'9']+))(['E' 'e']['+' '-']?['0'-'9']+)?
let path = ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+']*('/' ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+']+)+ '/'?
let hpath = '~' ('/' ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+']+)+ '/'?
let spath = '<' ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+']+('/' ['a'-'z' 'A'-'Z' '0'-'9' '.' '_' '-' '+'] '+')* '>'
let uri = ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '+' '-' '.']* ':' ['a'-'z' 'A'-'Z' '0'-'9' '%' '/' '?' ':' '@' '&' '=' '+' '$' ',' '-''_' '.' '!' '~' '*' '\'']+

rule read state = parse 
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
  | id { ID(lexeme lexbuf) }
  | int { INT(parse_integer (lexeme lexbuf)) }
  | float { FLOAT(parse_float (lexeme lexbuf)) }
  | "${" {
    (match (Stack.top state.states) with
       | Some INITIAL | Some INSIDE_DOLLAR_CURLY ->
           ignore (Stack.push state.states INSIDE_DOLLAR_CURLY);
       |_ -> ());
    DOLLAR_CURLY
  }
  | "}" {
    if (Stack.top state.states = (Some INSIDE_DOLLAR_CURLY)) then 
      ignore (Stack.pop state.states);
    CURLY_CLOSED
  }
  | "{" {
    if (Stack.top state.states = (Some INSIDE_DOLLAR_CURLY)) then 
      ignore (Stack.push state.states INSIDE_DOLLAR_CURLY);
    CURLY_OPENED
  }
  | eof { EOF }
