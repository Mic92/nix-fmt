%token <int> INT
%token <float> FLOAT
%token <string> ID
%token <string> STRING
%token IF
%token THEN
%token ELSE
%token ASSERT
%token WITH
%token LET
%token IN
%token REC
%token INHERIT
%token OR_KW
%token ELLIPSIS
%token EQ
%token NEQ
%token LEQ
%token GEQ
%token AND
%token OR
%token IMPL
%token UPDATE
%token CONCAT

%token EOF
%start <Nix.value option> exp
%%

exp:
  | v = value { Some v }
  | EOF       { None } ;

value:
  | IF
  { `If }
