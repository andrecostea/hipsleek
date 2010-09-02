%{
  open Globals
  open Cpure

  module Err = Error
  let subst_lst = ref ([]:(string*string*typ)list)
  
  (*let get_pos p = Parsing.rhs_start_pos p*)
  let get_pos x = 
				{start_pos = Parsing.symbol_start_pos ();
				 end_pos = Parsing. symbol_end_pos ();
				 mid_pos = Parsing.rhs_start_pos x;
				}	
  let rec trans_null (b:formula):formula = 
    let rec trans_b_f_null b = match b with
      | Lt (e1,e2,p) -> (match (e1,e2) with
            | IConst (i,_), Var(v,l) ->  if (is_object_var v) then if (i>=0) then Neq(e2,Null l,p) else BConst (true,p) else b
            | Var (v,l), IConst (i,_) -> if (is_object_var v) then if (i<=1) then Eq(e1,Null l,p) else BConst(true,p) else b          
            | _ -> b)
      | Lte(e1,e2,p) ->(match (e1,e2) with
            | IConst (i,_), Var(v,l) ->  if (is_object_var v) then if (i>=1) then Neq(e2,Null l,p) else BConst (true,p) else b
            | Var (v,l), IConst (i,_) -> if (is_object_var v) then if (i<1) then Eq(e1,Null l,p) else BConst(true,p) else b          
            | _ -> b) 
      | Gt (e1,e2,p) -> trans_b_f_null (Lt (e2,e1,p))
      | Gte(e1,e2,p) -> trans_b_f_null (Lte (e2,e1,p))
      | _ -> b in
    match b with
      | BForm (b,l) -> BForm ((trans_b_f_null b),l)
      | And (f1,f2,l) -> mkAnd (trans_null f1) (trans_null f2) l
      | Or (f1,f2,fl,l) -> mkOr (trans_null f1) (trans_null f2) fl l
      | Not (f,fl,l) -> Not ((trans_null f),fl,l)
      | Forall (sv,f,fl,l) -> Forall(sv,(trans_null f),fl,l)
      | Exists (sv,f,fl,l) -> Exists(sv,(trans_null f),fl,l)
%}

%token AND
%token BOOL
%token CBRACE
%token COLON
%token COMMA
%token CPAREN
%token CSQUARE
%token DOT
%token EQ
%token EOF
%token EQEQ
%token EXISTS
%token FALSE
%token FORALL
%token GT
%token GTE
%token <int> ICONST
%token <string> ID
%token <string> IDPRIMED
%token LT
%token LTE
%token MINUS
%token NEQ
%token NOT
%token OBRACE
%token OPAREN
%token OR
%token OSQUARE
%token PLUS
%token PRINT
%token SEMICOLON
%token TIMES
%token TRUE
%token UNION

%left UNION
%left OR
%left AND
%right NOT
%left EQ NEQ GT GTE LT LTE
%left PLUS MINUS
%left UMINUS

%start oc_output
%type <Cpure.relation> oc_output

%%

oc_output: relation {
  $1
}
;

relation: relation UNION relation {
  UnionRel ($1, $3)
}
| OBRACE OSQUARE aexp_list CSQUARE COLON pconstr CBRACE {
  BaseRel ($3, $6)
}
| OBRACE OSQUARE aexp_list CSQUARE CBRACE {
	BaseRel ($3, mkTrue (get_pos 1))
  }
| OBRACE TRUE CBRACE {
	ConstRel true
  } 
| OBRACE FALSE CBRACE {
	ConstRel false
  }
;

pconstr: pconstr AND pconstr { 
  mkAnd $1 $3 (get_pos 2)
}
| lbconstr { 
	trans_null (fst $1)
  }
| EXISTS OPAREN var_list COLON pconstr CPAREN { 
	let svars = $3 in
	let qf f v = mkExists [v] f None (get_pos 1) in
	let res = List.fold_left qf $5 svars in
	  res
}
;

lbconstr: bconstr { 
	(fst $1, snd $1)
  }
| lbconstr LT aexp_list {
	let b, oae = $1 in
	  match oae with
		| Some ae ->
			let tmp = build_relation mkLt ae $3 None (get_pos 2) in
			  (mkAnd b tmp (get_pos 2), Some $3)
		| None -> Err.report_error {Err.error_loc = get_pos 2;
									Err.error_text = "parse error in lhs of <"}
  }
| lbconstr LTE aexp_list {
	let b, oae = $1 in
	  match oae with
		| Some ae ->
			let tmp = build_relation mkLte ae $3 None (get_pos 2) in
			  (mkAnd b tmp (get_pos 2) , Some $3)
		| None -> Err.report_error {Err.error_loc = get_pos 2;
									Err.error_text = "parse error in lhs of <="}
  }
| lbconstr GT aexp_list {
	let b, oae = $1 in
	  match oae with
		| Some ae ->
			let tmp = build_relation mkGt ae $3 None (get_pos 2) in
			  (mkAnd b tmp (get_pos 2), Some $3)
		| None -> Err.report_error {Err.error_loc = get_pos 2;
									Err.error_text = "parse error in lhs of >"}
}
| lbconstr GTE aexp_list {
	let b, oae = $1 in
	  match oae with
		| Some ae ->
			let tmp = build_relation mkGte ae $3 None (get_pos 2) in
			  (mkAnd b tmp (get_pos 2), Some $3)
		| None -> Err.report_error {Err.error_loc = get_pos 2;
									Err.error_text = "parse error in lhs of >="}
}
| lbconstr EQ aexp_list {
	let b, oae = $1 in
	  match oae with
		| Some ae ->
			let tmp = build_relation mkEq ae $3 None (get_pos 2) in
			  (mkAnd b tmp (get_pos 2), Some $3)
		| None -> Err.report_error {Err.error_loc = get_pos 2;
									Err.error_text = "parse error in lhs of ="}
}
| lbconstr NEQ aexp_list {
	let b, oae = $1 in
	  match oae with
		| Some ae ->
			let tmp = build_relation mkNeq ae $3 None (get_pos 2) in
			  (mkAnd b tmp (get_pos 2), Some $3)
		| None -> Err.report_error {Err.error_loc = get_pos 2;
									Err.error_text = "parse error in lhs of !="}
}
;

bconstr: aexp_list LT aexp_list { (build_relation mkLt $1 $3 None (get_pos 2), Some $3) }
| aexp_list LTE aexp_list { (build_relation mkLte $1 $3 None (get_pos 2), Some $3) }
| aexp_list GT aexp_list { (build_relation mkGt $1 $3 None (get_pos 2), Some $3) }
| aexp_list GTE aexp_list { (build_relation mkGte $1 $3 None (get_pos 2), Some $3) }
| aexp_list EQ aexp_list { (build_relation mkEq $1 $3 None (get_pos 2), Some $3) }
| aexp_list NEQ aexp_list { (build_relation mkNeq $1 $3 None (get_pos 2), Some $3) }
| TRUE { (BForm (BConst (true, get_pos 1) , None), None) }
| FALSE { (BForm (BConst (false, get_pos 1) , None), None) }
;

aexp: cid {
	Var ($1,get_pos 1)
  }
| ICONST {
	IConst ($1, get_pos 1)
  }
| ICONST cid {
	Mult (IConst ($1, get_pos 1), (Var ($2,get_pos 2)), get_pos 1)
  }
| aexp PLUS aexp {
	Add ($1, $3, get_pos 2)
  }
| aexp MINUS aexp {
	Subtract ($1, $3, get_pos 2)
  }
| MINUS aexp %prec UMINUS {
	Subtract (IConst (0, get_pos 1), $2, get_pos 1)
  }
;

aexp_list: { [] }
| aexp_list_rec { List.rev $1 }
;

aexp_list_rec: aexp { [$1] }
| aexp_list_rec COMMA aexp { $3 :: $1}
;

var_list: { [] : spec_var list }
| var_list_rec { List.rev $1 : spec_var list }
;

var_list_rec: cid { ([$1]) : spec_var list }
| var_list_rec COMMA cid { ($3 :: $1) : spec_var list }
;

/* identifiers appearing in constraints */
cid: ID { match (List.filter (fun (a,b,_)->((String.compare $1 a)==0)) !subst_lst) with 
					|  [] -> SpecVar(Prim Int,$1, Unprimed)
					| (a,b,t)::h-> SpecVar(t, b,Unprimed) }
| IDPRIMED { match (List.filter (fun (a,b,_)->((String.compare $1 a)==0)) !subst_lst) with 
					|  [] -> SpecVar(Prim Int,$1, Primed)
					| (a,b,t)::h-> SpecVar(t, b,Primed) }
;
