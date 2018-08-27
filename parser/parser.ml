open Core
exception Error of string

let parse ?start_line ?start_column ?path lines =
  let buffer =
    let buffer = Lexing.from_string lines in
    buffer.Lexing.lex_curr_p <- {
      Lexing.pos_fname = Option.value path ~default:"$invalid_path";
      pos_lnum = Option.value start_line ~default:1;
      pos_bol = -(Option.value start_column ~default:0);
      pos_cnum = 0;
    };
    buffer
  in
  let state = Lexer.State.initial () in

	Generator.parse (Lexer.read state) buffer
