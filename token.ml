open Camlp4.PreCast

type sleek_token =
  | IDENTIFIER    of string
  | INT_LITER     of int * string
  | FLOAT_LIT     of float * string
  | CHAR_LIT      of char * string
  | STRING        of string * string
  | COMMENT       of string
  | EOF 
  | JAVA          of string
  (*keywords*)
  | ASSERT | ASSUME | ALLN | APPEND
  | BIND | BOOL | BREAK | BAGMAX | BAGMIN
  | CASE | CHECKENTAIL | CAPTURERESIDUE | CLASS | COERCION | COMPOSE | CONST | CONTINUE
	| DATA | DDEBUG | DIFF | DYNAMIC 
  | DTIME
  | ELSE_TT
  | ENSURES | ENUM | EXISTS | EXTENDS
  | FALSE | FLOAT | FORALL
	| IF 
  | IN_T | INT | INTERSECT | INV
	| LEMMA | LET
  | MAX | MIN 
  | NEW | NOTIN | NULL
  | OFF | ON | ORWORD
	| PRED | PRINT
	| REF | REQUIRES | RES of string | RETURN
	| SELFT of string | SPLIT | SUBSET | STATIC
  | THEN| THIS of string | TO | TRUE 
  | UNFOLD | UNION
  | VOID 
  | WHILE | FLOW of string
  (*operators*)
  | AND |  ANDAND | AT | IMM| CBRACE | CLIST | COLON | COLONCOLON | COLONCOLONCOLON | COMMA | CPAREN | CSQUARE | DOLLAR 
  | DOT | DOUBLEQUOTE | EQ | EQEQ | RIGHTARROW | EQUIV | GT | GTE | HASH  | HEAD | INLIST | LEFTARROW | LENGTH
  | LT | LTE | MINUS | NEQ | NOT | NOTINLIST | OBRACE |OLIST | OPAREN | OP_ADD_ASSIGN | OP_DEC | OP_DIV_ASSIGN 
  | OP_INC | OP_MOD_ASSIGN | OP_MULT_ASSIGN | OP_SUB_ASSIGN | OR | OROR | PERM | DERIVE | OSQUARE  | REVERSE | SET | TAIL 
  | PERCENT 
  | PLUS | PRIME 
  | SEMICOLON 
  | STAR | DIV
  | GLOBAL |VARIANCE| ESCAPE | HPRED | REFINES | JOIN | WITH | COMBINE | FINALIZE | TRY | CATCH | FINALLY | THROWS | RAISE 

module type SleekTokenS = Camlp4.Sig.Token with type t = sleek_token
  
module Token = struct
  open Format
  module Loc = Loc
  type t = sleek_token
  type token = t

  let sf = Printf.sprintf

  let to_string k = match k with 
    | IDENTIFIER s | INT_LITER (_,s) | FLOAT_LIT (_,s)  | CHAR_LIT (_,s) | STRING (_,s)-> s
    | COMMENT s -> "/* "^s^" */"
    | EOF -> ""
    | JAVA s-> s
    | ASSERT -> "assert" | ASSUME -> "assume" | ALLN-> "alln" | APPEND -> "app" | BIND -> "bind"| BOOL -> "bool" | BREAK ->"break" | BAGMAX ->"bagmax" | BAGMIN->"bagmin"
    | CASE ->"case" | CHECKENTAIL ->"checkentail" | CAPTURERESIDUE ->"capture_residue" | CLASS ->"class" | CLIST -> "|]" | COERCION ->"coercion"
    | COMPOSE ->"compose" | CONST ->"const" | CONTINUE ->"continue"	| DATA ->"data" | DDEBUG ->"debug" | DIFF ->"diff"| DYNAMIC ->"dynamic"
    | DTIME ->"time" | ELSE_TT ->"else" | ENSURES ->"ensures" | ENUM ->"enum"| EXISTS ->"ex" | EXTENDS ->"extends"
    | FALSE ->"false"| FLOAT ->"float" | FORALL ->"forall"
    | IF ->"if" | IN_T ->"in" | INT ->"int"| INTERSECT ->"intersect" | INV->"inv"
    | LEMMA ->"lemma" | LET->"let" | MAX ->"max" | MIN ->"min" | NEW ->"new" | NOTIN ->"notin" | NULL ->"null"
    | OFF ->"off" | ON->"on" | ORWORD ->"or" | PRED ->"pred" | PRINT ->"print" | REF ->"ref"| REQUIRES ->"requires" | RES s->"res "^s 
    | RETURN->"return" | SELFT s ->"self "^s | SPLIT ->"split"| SUBSET ->"subset" | STATIC ->"static"
    | THEN->"then" | THIS s->"this "^s | TO ->"to" | TRUE ->"true" | UNFOLD->"unfold" | UNION->"union"
    | VOID->"void" | WHILE ->"while" | FLOW s->"flow "^s
  (*operators*)
    | AND ->"&" | ANDAND ->"&&" | AT ->"@"| IMM->"@I"| CBRACE ->"}"| COLON ->":"| COLONCOLON ->"::"| COLONCOLONCOLON -> ":::" | COMMA ->","| CPAREN->")" | CSQUARE ->"]"
    | DOLLAR ->"$" | DOT ->"." | DOUBLEQUOTE ->"\"" | DIV -> "/" | EQ ->"=" | EQEQ -> "==" | RIGHTARROW -> "<-"| EQUIV ->"<->" | GT ->">" | GTE ->">= " | HASH ->"#"
    | LEFTARROW -> "<-" | LT -> "<" | LTE -> "<=" | MINUS -> "-" | NEQ -> "!=" | NOT -> "!" | OBRACE ->"{" | OLIST -> "[|" | OPAREN ->"(" | OP_ADD_ASSIGN -> "+=" | OP_DEC -> "--"
    | OP_DIV_ASSIGN -> "\\=" | OP_INC -> "++" | OP_MOD_ASSIGN -> "%=" | OP_MULT_ASSIGN ->"*=" | OP_SUB_ASSIGN -> "-=" | OR -> "|" | OROR -> "||"
    | DERIVE -> "|-" | OSQUARE -> "[" | PERCENT ->"%" | PLUS -> "+" | PRIME -> "'" | SEMICOLON -> ";" | STAR -> "*"
    | RAISE -> "raise" | THROWS -> "throws" | FINALLY -> "finally" | COMBINE -> "combine" | WITH -> "with" | JOIN -> "join" | REFINES -> "refines"
    | HPRED -> "ho_pred" | ESCAPE -> "escape" | VARIANCE -> "variance" | GLOBAL -> "global" | TAIL -> "tail" | SET -> "set" | REVERSE -> "reverse"
    | PERM -> "perm" | NOTINLIST -> "notinlist" | CATCH -> "catch" | TRY -> "try" | FINALIZE -> "finalize" | LENGTH -> "len" | INLIST -> "inlist" | HEAD -> "head"
    
  let print ppf x = pp_print_string ppf (to_string x)

  let match_keyword kwd _ = false 
    
  let extract_string t = match t with
     | IDENTIFIER s | INT_LITER (_,s) | FLOAT_LIT (_,s)  | CHAR_LIT (_,s) | STRING (_,s) | COMMENT s | JAVA s | RES s | SELFT s | THIS s | FLOW s -> s
     | _ -> ""
     
    
  module Error = struct
    type t = string
    exception E of string
    let print = pp_print_string
    let to_string x = x
  end

  module Filter = struct
    type token_filter = (t, Loc.t) Camlp4.Sig.stream_filter

    type t =
      { is_kwd : string -> bool;
        mutable filter : token_filter }

    let mk is_kwd =
      { is_kwd = is_kwd;
        filter = (fun s -> s) }

    let filter x = fun strm -> x.filter strm

    let define_filter x f = x.filter <- f x.filter

    let keyword_added _ _ _ = ()
    let keyword_removed _ _ = ()
  end

end
module Error = Camlp4.Struct.EmptyError
