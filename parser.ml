open Camlp4
open Globals
open Iast
open Token
open Sleekcommons
open Gen.Basic

  module F = Iformula
  module P = Ipure
  module E1 = Error
  module I = Iast
  
  module SHGram = Camlp4.Struct.Grammar.Static.Make(Lexer.Make(Token))
  
  type type_decl =
	| Data of data_decl
	| Enum of enum_decl
	| View of view_decl
    | Hopred of hopred_decl
		
  type decl = 
    | Type of type_decl
    | Rel of rel_decl (* An Hoa *)
    | Axm of axiom_decl (* An Hoa *)
    | Global_var of exp_var_decl
    | Proc of proc_decl
    | Coercion of coercion_decl
		
  type member = 
	| Field of (typed_ident * loc)
	| Inv of F.formula
	| Method of proc_decl
		
  type spec_qualifier =
	| Static
	| Dynamic 

  type ann =
	| AnnMode of mode
	| AnnType of typ

(* An Hoa : Counting of holes "#" *)
let hash_count = ref 0

(* An Hoa : Generic data type for the abbreviated syntax x.f::<a> *)
let generic_pointer_type_name = "_GENERIC_POINTER_"

let get_pos x = 
				{start_pos = Parsing.symbol_start_pos ();
				 end_pos = Parsing. symbol_end_pos ();
				 mid_pos = Parsing.rhs_start_pos x;
				}
let get_pos_camlp4 l x = 
                          {
                           start_pos = Camlp4.PreCast.Loc.start_pos l ;
				           end_pos = Camlp4.PreCast.Loc.stop_pos l ;
				           mid_pos = Camlp4.PreCast.Loc.start_pos (Camlp4.PreCast.Loc.shift x l);
                          }
        
let rec get_mode (anns : ann list) : mode = match anns with
	| ann :: rest -> begin
		match ann with
		  | AnnMode m -> m
		  | _ -> get_mode rest
	  end
	| [] -> ModeOut (* default to ModeOut if there is no annotation. *)

let rec get_modes (anns : ann list list) : mode list =
	match anns with
	  | alist :: rest ->
		  let m_rest = get_modes rest in
		  let m = get_mode alist in
			m :: m_rest
	| [] -> []
  
let rec split_specs specs = match specs with
	| sp :: rest -> begin
		let sspecs, dspecs = split_specs rest in
		  match sp with
			| (Static, pre, post) -> ((pre, post) :: sspecs, dspecs)
			| (Dynamic, pre, post) -> (sspecs, (pre, post) :: dspecs)
	  end
	| [] -> ([], [])

let rec split_members mbrs = match mbrs with
	| mbr :: rest -> begin
		let fields, invs, meths = split_members rest in
		  match mbr with
			| Field f -> (f :: fields, invs, meths)
			| Inv i -> (fields, i :: invs, meths)
			| Method m ->
				(fields, invs, m :: meths)
	  end
	| [] -> ([], [], [])
  
let rec remove_spec_qualifier (_, pre, post) = (pre, post)
  
let un_option s d = match s with
  | Some v -> v
  | None -> d
  
let error_on_dups f l p = if (Gen.BList.check_dups_eq f l) then report_error p ("list contains duplicates") else l

let label_formula f ofl = (match f with 
          | P.BForm (b,_) -> P.BForm (b,ofl)
          | P.And _ -> f
          | P.Or  (b1,b2,_,l)  -> P.Or(b1,b2,ofl,l)
          | P.Not (b1,_,l)     -> P.Not(b1,ofl,l)
          | P.Forall (q,b1,_,l)-> P.Forall(q,b1,ofl,l)
          | P.Exists (q,b1,_,l)-> P.Exists(q,b1,ofl,l))
  
let bf_to_var p = match p with
  | P.Var (v,_) -> v
  | _ -> report_error (get_pos 1) ("expected var, found : "^(Iprinter.string_of_formula_exp p)^"\n")
  
  (*intermediate representation for pure formulae*)
type pure_double =
  | Pure_f of P.formula
  | Pure_c of P.exp
  
let apply_pure_form1 fct form = match form with
  | Pure_f f -> Pure_f (fct f)
  | _ -> report_error (get_pos 1) "with 1 expected pure_form, found cexp"

let apply_cexp_form1 fct form = match form with
  | Pure_c f -> Pure_c (fct f)
  | _ -> report_error (get_pos 1) "with 1 expected cexp, found pure_form"
  
  
let apply_pure_form2 fct form1 form2 = match (form1,form2) with
  | Pure_f f1 ,Pure_f f2 -> Pure_f (fct f1 f2)
  | Pure_f f1 , Pure_c f2 -> (match f2 with 
                             | P.Var (v,_) -> Pure_f(fct f1 (P.BForm (((P.mkBVar v (get_pos 1)), None), None)))
                             | _ -> report_error (get_pos 1) "with 2 expected pure_form, found cexp in var" )
  | Pure_c f1, Pure_f f2 -> (match f1 with 
                             | P.Var (v,_) -> Pure_f(fct (P.BForm (((P.mkBVar v (get_pos 1)), None), None )) f2)
                             | _ -> report_error (get_pos 1) "with 2 expected pure_form in f1, found cexp")
  | _ -> report_error (get_pos 1) "with 2 expected pure_form, found cexp"

let apply_cexp_form2 fct form1 form2 = match (form1,form2) with
  | Pure_c f1, Pure_c f2 -> Pure_c (fct f1 f2)
  | _ -> report_error (get_pos 1) "with 2 expected cexp, found pure_form"

let cexp_to_pure1 fct f = match f with
  | Pure_c f -> Pure_f (P.BForm (((fct f), None), None))
  | _ -> report_error (get_pos 1) "with 1 convert expected cexp, found pure_form"

let cexp_to_pure2 fct f1 f2 = match (f1,f2) with
  | Pure_c f1 , Pure_c f2 -> (match f1 with
                             | P.List(explist,pos) -> let tmp = List.map (fun c -> P.BForm (((fct c f2), None), None)) explist
                               in let len =  List.length tmp
                               in let res =  if (len > 1) then List.fold_left (fun c1 c2 -> P.mkAnd c1 c2 (get_pos 2)) (List.hd tmp) (List.tl tmp)
                                             else  P.BForm (((fct f1 f2), None), None)
                               in Pure_f(res) 
                             | _ -> (match f2 with
                                    | P.List(explist,pos) -> let tmp = List.map (fun c -> P.BForm (((fct f1 c), None), None)) explist
                                      in let len = List.length tmp
                                      in let res = if ( len > 1 ) then List.fold_left (fun c1 c2 -> P.mkAnd c1 c2 (get_pos 2)) (List.hd tmp) (List.tl tmp)
                                                   else P.BForm (((fct f1 f2), None), None)
                                      in Pure_f(res) 
                                    | _ -> Pure_f (P.BForm(((fct f1 f2), None), None)))
                             )
  | Pure_f f1 , Pure_c f2 ->(match f1  with 
						    | P.BForm((pf,il),oe) -> (match pf with 
                                               | P.Lt (a1, a2, _) 
                                               | P.Lte (a1, a2, _) 
                                               | P.Gt (a1, a2, _) 
                                               | P.Gte (a1, a2, _)
                                               | P.Eq (a1, a2, _) 
                                               | P.Neq (a1, a2, _) -> let tmp = P.BForm(((fct a2 f2), None),None) in 
                                                 Pure_f (P.mkAnd f1 tmp (get_pos 2))
                                               | _ -> report_error (get_pos 1) "error should be an equality exp" )
                            | _ -> report_error (get_pos 1) "error should be a binary exp" )
  | _ -> report_error (get_pos 1) "with 2 convert expected cexp, found pure_form" 


(* Use the Stream.npeek to look ahead the TOKENS *)
let peek_try = 
 SHGram.Entry.of_parser "peek_try" 
    (fun strm -> 
       match Stream.npeek 2 strm with 
         | [_;IN_T,_]  -> ()
         | [_;NOTIN,_] -> ()
         | [SEMICOLON,_; CBRACE,_] -> raise Stream.Failure
         | [OPAREN,_; EXISTS,_ ] -> raise Stream.Failure
         | [GT,_;STAR,_] -> raise Stream.Failure
         | [GT,_;INV,_] -> raise Stream.Failure
         | [GT,_;AND,_] -> raise Stream.Failure
         | [GT,_;OR,_] -> raise Stream.Failure
         | [GT,_;ORWORD,_] -> raise Stream.Failure
         | [GT,_;DOT,_] -> raise Stream.Failure
         | [GT,_;DERIVE,_] -> raise Stream.Failure
         | [GT,_;LEFTARROW,_] -> raise Stream.Failure
         | [GT,_;RIGHTARROW,_] -> raise Stream.Failure
         | [GT,_;EQUIV,_] -> raise Stream.Failure
         | [GT,_;CPAREN,_] -> raise Stream.Failure  
         | [GT,_;SEMICOLON,_]-> raise Stream.Failure
         | [GT,_;ENSURES,_]-> raise Stream.Failure
         | [GT,_;IMM,_] -> raise Stream.Failure 
         | [GT,_;DERV,_] -> raise Stream.Failure 
         | [GT,_;CASE,_] -> raise Stream.Failure 
         | [GT,_;VARIANCE,_] -> raise Stream.Failure 
         | [GT,_;_] -> ()
         | [SEMICOLON,_;_] -> ()
         | _ -> raise Stream.Failure  ) 

 let peek_try_st = 
 SHGram.Entry.of_parser "peek_try_st" 
     (fun strm ->
       match Stream.npeek 2 strm with
          | [_; OP_DEC,_] -> ()
          | _ -> raise Stream.Failure)

 let peek_try_st_in = 
 SHGram.Entry.of_parser "peek_try_st_in" 
     (fun strm ->
       match Stream.npeek 2 strm with
          | [_; OP_INC,_] -> ()
          | _ -> raise Stream.Failure)

 let peek_try_st_qi = 
 SHGram.Entry.of_parser "peek_try_st_qi" 
     (fun strm ->
       match Stream.npeek 2 strm with
          | [_; DOT,_] -> ()
          | _ -> raise Stream.Failure)
		  
 let peek_invocation = 
 SHGram.Entry.of_parser "peek_invocation" 
     (fun strm ->
       match Stream.npeek 2 strm with
          | [_; OPAREN,_] -> ()
          | _ -> raise Stream.Failure)
		  
 let peek_member_name = 
 SHGram.Entry.of_parser "peek_member_name" 
     (fun strm ->
       match Stream.npeek 2 strm with
          | [IDENTIFIER n,_;DOT,_] -> raise Stream.Failure
          | _ -> ())
		  
 let peek_exp_st = 
 SHGram.Entry.of_parser "peek_exp_st" 
     (fun strm ->
       match Stream.npeek 1 strm with
          | [DPRINT,_] -> raise Stream.Failure
          | _ -> ())
		  
 let peek_try_declarest = 
 SHGram.Entry.of_parser "peek_try_declarest" 
     (fun strm ->
       match Stream.npeek 2 strm with
          | [_;EQ,_] -> raise Stream.Failure 
          | [CONST,_;_] -> ()
          | [INT,_;IDENTIFIER n,_] -> ()
          | [FLOAT,_;IDENTIFIER n,_] -> ()
          | [BOOL,_;IDENTIFIER n,_] -> ()
          | [IDENTIFIER n,_;IDENTIFIER id,_] -> () 
          | [INT,_;OSQUARE,_] -> ()
          | [FLOAT,_;OSQUARE,_] -> ()
          | [BOOL,_;OSQUARE,_] -> ()
          |  _ -> raise Stream.Failure)

 (* let peek_ensures =  *)
 (* SHGram.Entry.of_parser "peek_ensures"  *)
 (*     (fun strm -> *)
 (*       match Stream.npeek 3 strm with *)
 (*          | [ENSURES,_;i,_;j,_]-> print_string((Token.to_string i)^(Token.to_string j));() *)
 (*          | _ -> raise Stream.Failure) *)

let peek_print = 
SHGram.Entry.of_parser "peek_print"
	(fun strm -> 
		match Stream.npeek 3 strm with
		| [i,_;j,_;k,_]-> print_string((Token.to_string i)^" "^(Token.to_string j)^" "^(Token.to_string k)^"\n");()
		| _ -> raise Stream.Failure)
 let peek_and = 
   SHGram.Entry.of_parser "peek_and"
       (fun strm -> 
           match Stream.npeek 2 strm with
             | [AND,_;FLOW i,_] -> raise Stream.Failure
             | [AND,_;OSQUARE,_] -> raise Stream.Failure
             | _ -> ())
 let peek_pure = 
   SHGram.Entry.of_parser "peek_pure"
       (fun strm -> 
           match Stream.npeek 3 strm with
             | [FORALL,_;OPAREN,_;_] -> ()
             | [EXISTS,_;OPAREN,_;_] -> ()
             | [UNION,_;OPAREN,_;_] -> ()
             | [IDENTIFIER id,_;OPAREN,_;_] -> ()
             | [_;COLONCOLON,_;_] -> raise Stream.Failure
             | [_;OPAREN,_;_] -> raise Stream.Failure 
             | [_;PRIME,_;COLONCOLON,_] -> raise Stream.Failure
             | [OPAREN,_;_;COLONCOLON,_] -> raise Stream.Failure
             | _ -> ())

 let peek_pure_out = 
   SHGram.Entry.of_parser "peek_pure_out"
       (fun strm -> 
           match Stream.npeek 3 strm with
             | [FORALL,_;OPAREN,_;_] -> ()
             | [EXISTS,_;OPAREN,_;_] -> ()
             | [UNION,_;OPAREN,_;_] -> ()
             | [_;COLONCOLON,_;_] -> raise Stream.Failure
             | [_;PRIME,_;COLONCOLON,_] -> raise Stream.Failure
             | [OPAREN,_;_;COLONCOLON,_] -> raise Stream.Failure
             | _ -> ())
let peek_dc = 
   SHGram.Entry.of_parser "peek_dc"
       (fun strm ->
           match Stream.npeek 2 strm with
             | [OPAREN,_;EXISTS,_] -> ()
             | _ -> raise Stream.Failure)

 let peek_and_pure = 
   SHGram.Entry.of_parser "peek_and_pure"
       (fun strm -> 
           match Stream.npeek 2 strm with
             | [AND,_;FLOW i,_] -> raise Stream.Failure
             | [AND,_;OSQUARE,_] -> raise Stream.Failure
             | _ -> ())

 let peek_heap_args = 
   SHGram.Entry.of_parser "peek_heap_args"
       (fun strm -> 
           match Stream.npeek 2 strm with
             | [IDENTIFIER n,_;EQ,_] ->  ()
             | _ -> raise Stream.Failure)

 let peek_extended = 
   SHGram.Entry.of_parser "peek_extended"
       (fun strm -> 
           match Stream.npeek 3 strm with
             | [OSQUARE,_;_;ORWORD,_] -> ()
             | _ -> raise Stream.Failure)

 let peek_cexp_list = 
   SHGram.Entry.of_parser "peek_cexp_list"
       (fun strm ->
           match Stream.npeek 6 strm with 
             | [_;COMMA,_;_;GTE,_;_;_] -> ()
             | [_;COMMA,_;_;AND,_;_;_] -> ()
             | [_;COMMA,_;_;COMMA,_;_;SEMICOLON,_] -> ()
             | _ -> raise Stream.Failure)

 let peek_heap = 
   SHGram.Entry.of_parser "peek_heap"
       (fun strm ->
           match Stream.npeek 3 strm with
             |[_;COLONCOLON,_;_] -> ()
             |[_;PRIME,_;COLONCOLON,_] -> ()
             | _ -> raise Stream.Failure)

let peek_star = 
   SHGram.Entry.of_parser "peek_star"
       (fun strm ->
           match Stream.npeek 2 strm with
             |[STAR,_;OPAREN,_] -> raise Stream.Failure
             | _ -> ())

let peek_array_type = 
   SHGram.Entry.of_parser "peek_array_type"
       (fun strm ->
           match Stream.npeek 2 strm with
             |[_;OSQUARE,_] -> (* An Hoa*) (*let _ = print_endline "Array found!" in*) ()
             | _ -> raise Stream.Failure)

(* Slicing Utils *)
let rec set_il_formula f il =
  match f with
	| P.BForm (bf, lbl) -> P.BForm (set_il_b_formula bf il, lbl)
	| _ -> f

and set_il_b_formula bf il =
  let (pf, _) = bf in (pf, il)

and set_il_exp exp il =
  let (pe, _) = exp in (pe, il)				   
				   
and set_slicing_utils_pure_double f il =
  if !Globals.do_slicing then
	match f with
	| Pure_f pf -> let ls = P.find_lexp_formula pf !F.linking_exp_list in
				   Pure_f (set_il_formula pf (Some (il, Globals.fresh_int(), ls)))
	| Pure_c pc -> let _ = Hashtbl.add !F.linking_exp_list pc 0 in f
  else f
				   
let sprog = SHGram.Entry.mk "sprog" 
let hprog = SHGram.Entry.mk "hprog"
let sprog_int = SHGram.Entry.mk "sprog_int"

EXTEND SHGram
  GLOBAL: sprog hprog sprog_int;
  sprog:[[ t = command_list; `EOF -> t ]];
  sprog_int:[[ t = command; `EOF -> t ]];
  hprog:[[ t = hprogn; `EOF ->  t ]];
  
command_list: [[ t = LIST0 non_empty_command_dot -> t ]];
  
command: [[ t=OPT non_empty_command_dot-> un_option t EmptyCmd]];
    
non_empty_command_dot: [[t=non_empty_command; `DOT -> t]];

non_empty_command:
    [[  t=data_decl           -> DataDef t
      | `PRED;t=view_decl     -> PredDef t
      | t = rel_decl          -> RelDef t
      | `LEMMA;t= coercion_decl -> LemmaDef t
	  | `AXIOM;t= axiom_decl -> AxiomDef t (* [4/10/2011] An Hoa : axiom declarations *)
      | t=let_decl            -> t
      | t=checkentail_cmd     -> EntailCheck t
      | t=infer_cmd           -> Infer t  
      | t=captureresidue_cmd  -> CaptureResidue t
      | t=print_cmd           -> PrintCmd t
      | t=time_cmd            -> t]];
  
data_decl:
    [[ dh=data_header ; db = data_body 
        -> {data_name = dh;
            data_fields = db;
            data_parent_name="Object"; (* Object; *)
            data_invs = [];
            data_methods = [];} ]];

with_typed_var: [[`OSQUARE; typ; `CSQUARE -> ()]];

data_header:
    [[ `DATA; `IDENTIFIER t; OPT with_typed_var -> t ]];

data_body: 
      [[`OBRACE; fl=field_list2;`SEMICOLON; `CBRACE -> fl
      | `OBRACE; fl=field_list2; `CBRACE   ->  fl
      | `OBRACE; `CBRACE                             -> []] ];
 
(* field_list:[[ fl = LIST1 one_field SEP `SEMICOLON -> error_on_dups (fun n1 n2-> (snd (fst n1))==(snd (fst n2))) fl (get_pos_camlp4 _loc 1) *)
(*            ]];  *)


field_list2:[[ 
     t = typ; `IDENTIFIER n -> [((t,n),get_pos_camlp4 _loc 1,false)]
 	|  t = typ; `OSQUARE; t2=typ; `CSQUARE; `IDENTIFIER n -> [((t,n), get_pos_camlp4 _loc 1,false)]
  |   
       t=typ; `IDENTIFIER n; peek_try; `SEMICOLON; fl = SELF ->(  
			if List.mem n (List.map get_field_name fl) then
				report_error (get_pos_camlp4 _loc 4) (n ^ " is duplicated")
			else
				((t, n), get_pos_camlp4 _loc 3, false) :: fl )
  | t1= typ; `OSQUARE; t2=typ; `CSQUARE; `IDENTIFIER n; peek_try; `SEMICOLON; fl = SELF -> 
			(if List.mem n (List.map get_field_name fl) then
				report_error (get_pos_camlp4 _loc 4) (n ^ " is duplicated")
			else
				((t1, n), get_pos_camlp4 _loc 3, false) :: fl )]
	(* An Hoa [22/08/2011] Inline fields extension*)
	| "inline fields" [
	`INLINE; t = typ; `IDENTIFIER n -> [((t,n),get_pos_camlp4 _loc 1,true)]
 	| `INLINE; t = typ; `OSQUARE; t2=typ; `CSQUARE; `IDENTIFIER n -> [((t,n), get_pos_camlp4 _loc 1,true)]
	| `INLINE; t=typ; `IDENTIFIER n; peek_try; `SEMICOLON; fl = SELF ->(  
			if List.mem n (List.map get_field_name fl) then
				report_error (get_pos_camlp4 _loc 4) (n ^ " is duplicated")
			else
				((t, n), get_pos_camlp4 _loc 3, true) :: fl )
	| `INLINE; t1= typ; `OSQUARE; t2=typ; `CSQUARE; `IDENTIFIER n; peek_try; `SEMICOLON; fl = SELF -> 
			(if List.mem n (List.map get_field_name fl) then
				report_error (get_pos_camlp4 _loc 4) (n ^ " is duplicated")
			else
				((t1, n), get_pos_camlp4 _loc 3, true) :: fl )]];

(* one_field:   *)
(*   [[ t=typ; `IDENTIFIER n -> ((t, n), get_pos_camlp4 _loc 1) *)
(*    | t=typ; `OSQUARE; t2=typ; `CSQUARE; `IDENTIFIER n -> ((t,n), get_pos_camlp4 _loc 1)  *)
(*    ]];  *)

 (********** Views **********)

view_decl: 
  [[ vh=view_header; `EQEQ; vb=view_body; oi= opt_inv  
      -> { vh with view_formula = (fst vb); view_invariant = oi; try_case_inference = (snd vb) } ]];

opt_inv: [[t=OPT inv -> un_option t (P.mkTrue no_pos, [])]];

opt_derv: [[t=OPT derv -> un_option t false ]];

derv : [[ `DERV -> true ]];

inv: 
  [[`INV; pc=pure_constr; ob=opt_branches -> (pc,ob)
   |`INV; h=ho_fct_header -> (P.mkTrue no_pos, [])]];
 
opt_branches:[[t=OPT branches -> un_option t []]];

branches : [[`AND; `OSQUARE; b=LIST1 one_branch SEP `SEMICOLON ; `CSQUARE -> b ]];

one_branch : [[ `STRING (_,id); `COLON; pc=pure_constr -> (id,pc)]];

opt_branch:[[t=OPT branch -> un_option t ""]];

branch: [[ `STRING (_,id);`COLON -> id ]];

view_header:
  [[ `IDENTIFIER vn; `LT; l= opt_ann_cid_list; `GT ->
      let cids, anns = List.split l in
      let cids, br_labels = List.split cids in
      if List.exists (fun x -> match snd x with | Primed -> true | Unprimed -> false) cids then
        report_error (get_pos_camlp4 _loc 1) ("variables in view header are not allowed to be primed")
      else
        let modes = get_modes anns in
        { view_name = vn;
          view_data_name = "";
          view_vars = List.map fst cids;
          view_labels = br_labels;
          view_modes = modes;
          view_typed_vars = [];
          view_pt_by_self  = [];
          view_formula = F.mkETrue top_flow (get_pos_camlp4 _loc 1);
          view_invariant = (P.mkTrue (get_pos_camlp4 _loc 1), []);
          try_case_inference = false;
			}]];
      
(** An Hoa : Modify the rules to capture the extensional identifiers **)
cid: 
  [[ 
     (* `IDENTIFIER t; `PRIME	 	-> (* print_string ("primed id:"^t^"\n"); *) (t, Primed) *)
   `IDENTIFIER t	-> (* print_string ("cid: "^t^"\n"); *)
						if String.contains t '\'' then (* Remove the primed in the identifier *)
							(Str.global_replace (Str.regexp "[']") "" t,Primed) 
						else (t,Unprimed)
   | `RES _                 	-> (res, Unprimed)
   | `SELFT _               	-> (self, Unprimed)
   | `THIS _               		-> (this, Unprimed)]];

(** An Hoa : Access extension. For example: in "x.node.value", ".node.value" is the idext **)
(* idext:
	[[ `DOT; `IDENTIFIER t 				-> "." ^ t
	| `DOT; `IDENTIFIER t; u=idext 		-> "." ^ t ^ u]]; *)

view_body:
  [[ t = formulas -> ((F.subst_stub_flow_struc top_flow (fst t)),(snd t))
   | `FINALIZE; t = split_combine -> ([],false) 
  ]];
  
  
(********** Constraints **********)

opt_heap_arg_list: [[t=LIST1 cexp SEP `COMMA -> t
]];

opt_heap_arg_list2:[[t=LIST1 heap_arg2 SEP `COMMA ->error_on_dups (fun n1 n2-> (fst n1)==(fst n2)) t (get_pos_camlp4 _loc 1)]];
  
heap_arg2: [[ peek_heap_args; `IDENTIFIER id ; `EQ;  e=cexp -> (id,e)]]; 

opt_cid_list: [[t=LIST0 cid SEP `COMMA -> error_on_dups (fun n1 n2-> (fst n1)==(fst n2)) t (get_pos_camlp4 _loc 1)]];

cid_list: [[t=LIST1 cid SEP `COMMA -> error_on_dups (fun n1 n2-> (fst n1)==(fst n2)) t (get_pos_camlp4 _loc 1)]];
  
(* annotated cid list *)
opt_ann_cid_list: [[t=LIST0 ann_cid SEP `COMMA -> t]];
  
ann_cid:[[ ob=opt_branch; c=cid; al=opt_ann_list ->((c, ob), al)]];

opt_ann_list: [[t=LIST0 ann -> t]];
  
ann:
  [[ `AT; `IDENTIFIER id -> begin
      if id = "out" then AnnMode ModeOut
      else report_error (get_pos_camlp4 _loc 2) ("unrecognized mode: " ^ id) end
   | `AT ; `IN_T       -> AnnMode ModeIn]];
      
sq_clist: [[`OSQUARE; l= opt_cid_list; `CSQUARE -> l ]];

formulas:
  [[ ec=extended_l     ->(ec,false)
	 | dc=disjunctive_constr  -> ((Iformula.formula_to_struc_formula dc),true)]];
   
extended_l:
  [[ peek_extended; `OSQUARE; h=extended_constr ; `ORWORD; t=LIST1 extended_constr SEP `ORWORD; `CSQUARE -> h::t 
   | h=extended_constr -> [h]]];
   
extended_constr:
	[[ `CASE; `OBRACE; il= impl_list; `CBRACE -> 
      Iformula.ECase {
          Iformula.formula_case_branches = il;
          Iformula.formula_case_pos = (get_pos_camlp4 _loc 3) }
	| sl=sq_clist; oc=disjunctive_constr; rc= OPT extended_l -> Iformula.mkEBase sl [] [] oc (un_option rc [])(get_pos_camlp4 _loc 2)]];	
  
impl_list:[[t=LIST1 impl -> t]];

impl: [[ pc=pure_constr; `LEFTARROW; ec=extended_l; `SEMICOLON ->
			if(List.length (Ipure.look_for_anonymous_pure_formula pc))>0 then report_error (get_pos_camlp4 _loc 1) ("anonimous variables in case guard are disalowed")
		  else (pc,ec)]];

(* seem _loc 2 is empty *)
disjunctive_constr:
  [ "disj_or" LEFTA
    [ dc=SELF; `ORWORD; oc=SELF   -> F.mkOr dc oc (get_pos_camlp4 _loc 1)]    
  |  [peek_dc; `OPAREN;  dc=SELF; `CPAREN -> dc]
  | "disj_base"
   [ cc=core_constr             -> cc
   | `EXISTS; ocl= cid_list; `COLON; cc= core_constr   -> 
	  (match cc with
      | F.Base ({F.formula_base_heap = h;
               F.formula_base_pure = p;
               F.formula_base_flow = fl;
               F.formula_base_branches = b}) -> F.mkExists ocl h p fl b (get_pos_camlp4 _loc 1)
      | _ -> report_error (get_pos_camlp4 _loc 4) ("only Base is expected here."))
  
   ]
  ];
      
core_constr:
  [[ pc= pure_constr    ; fc= opt_flow_constraints; fb=opt_branches   -> F.replace_branches fb (F.formula_of_pure_with_flow pc fc (get_pos_camlp4 _loc 1))
   | hc= opt_heap_constr; pc= opt_pure_constr; fc= opt_flow_constraints; fb= opt_branches   -> F.mkBase hc pc fc fb (get_pos_camlp4 _loc 2)
   ]];

opt_flow_constraints: [[t=OPT flow_constraints -> un_option t stub_flow]];

flow_constraints: [[ `AND; `FLOW _; `IDENTIFIER id -> id]]; 

opt_formula_label: [[t=OPT formula_label -> un_option t None]];		

opt_label: [[t= OPT label->un_option t ""]]; 

label : [[  `STRING (_,id); `COLON -> id]];

(* opt_pure_label :[[t=Opure_label -> un_option t (fresh_branch_point_id "")]]; *)

pure_label : [[ `DOUBLEQUOTE; `IDENTIFIER id; `DOUBLEQUOTE; `COLON -> fresh_branch_point_id id]];

formula_label: [[ `AT; `STRING (_,id) ->(fresh_branch_point_id id)]];

opt_heap_constr: 
  [[ t = heap_constr -> t
     | `TRUE -> F.HTrue]];

(* heap_constr: *)
(*   [[    hrd=SELF; `STAR; hrw=SELF -> F.mkStar hrd hrw (get_pos_camlp4 _loc 2)]  *)
(* (\*      |[ shc = simple_heap_constr -> shc]  *\) *)
(*      |[ c=cid; `COLONCOLON; `IDENTIFIER id; simple2; hal=opt_heap_arg_list; `GT; ofl = opt_formula_label ->   *)
(*                     F.mkHeapNode c id false false false false hal ofl (get_pos_camlp4 _loc 2)  *)
(*   ]];  *)

heap_constr:
  [[ `OPAREN; hrd=heap_rd; `CPAREN; `SEMICOLON; hrw=heap_rw -> F.mkPhase hrd hrw (get_pos_camlp4 _loc 2)
   | `OPAREN; hrd=heap_rd; `CPAREN                          -> F.mkPhase hrd F.HTrue (get_pos_camlp4 _loc 2)
   | hrw = heap_rw                                          -> F.mkPhase F.HTrue hrw (get_pos_camlp4 _loc 2)]]; 

heap_rd: 
  [[ shi=simple_heap_constr_imm; `STAR; hrd=SELF -> F.mkStar shi hrd (get_pos_camlp4 _loc 2)
   | shi=simple_heap_constr_imm; `AND; hrd=SELF  -> F.mkConj shi hrd (get_pos_camlp4 _loc 2)
   | shi=simple_heap_constr_imm                  -> shi ]];

heap_rw:
  [[ hrd=heap_wr; `STAR; `OPAREN; hc=heap_constr; `CPAREN -> F.mkStar hrd hc (get_pos_camlp4 _loc 2)
   | hwr=heap_wr                                          -> F.mkPhase F.HTrue hwr (get_pos_camlp4 _loc 2)]];

heap_wr:
  [[   
     shc=SELF; peek_star; `STAR;  hw=simple_heap_constr     -> F.mkStar shc hw (get_pos_camlp4 _loc 2)
   | shc=simple_heap_constr        -> shc
   (* | shi=simple_heap_constr_imm; `STAR;  hw=SELF -> F.mkStar shi hw (get_pos_camlp4 _loc 2) *)
   (* | shi=simple_heap_constr_imm; `STAR; `OPAREN; hc=heap_constr; `CPAREN  -> F.mkStar shi hc (get_pos_camlp4 _loc 2) *)
  ]];
 
simple2:  [[ t= opt_type_var_list; `LT -> (* let _ = print_endline "PASSED simple2." in *)()]];
   
simple_heap_constr_imm:
  [[ peek_heap; c=cid; `COLONCOLON; `IDENTIFIER id; `LT; hl= opt_general_h_args; `GT;  `IMM; dr=opt_derv; ofl= opt_formula_label ->
     match hl with
        | ([],t) -> F.mkHeapNode2 c id dr true false false false t ofl (get_pos_camlp4 _loc 2)
        | (t,_)  -> F.mkHeapNode c id dr true false false false t ofl (get_pos_camlp4 _loc 2)]];

simple_heap_constr:
  [[ 
    peek_heap; c=cid; `COLONCOLON; `IDENTIFIER id; simple2; hl= opt_general_h_args; `GT;  `IMM; dr=opt_derv; ofl= opt_formula_label ->
    (match hl with
        | ([],t) -> F.mkHeapNode2 c id dr true false false false t ofl (get_pos_camlp4 _loc 2)
        | (t,_)  -> F.mkHeapNode c id dr true false false false t ofl (get_pos_camlp4 _loc 2))
  | peek_heap; c=cid; `COLONCOLON; `IDENTIFIER id; simple2; hal=opt_general_h_args; `GT; dr=opt_derv; ofl = opt_formula_label -> (* let _ = print_endline (fst c) in let _ = print_endline id in *)
    (match hal with
      | ([],t) -> F.mkHeapNode2 c id dr false false false false t ofl (get_pos_camlp4 _loc 2)
      | (t,_)  -> F.mkHeapNode c id dr false false false false t ofl (get_pos_camlp4 _loc 2))
  | t = ho_fct_header -> F.mkHeapNode ("",Primed) "" false (*dr*) false false false false [] None  (get_pos_camlp4 _loc 1)
	(* An Hoa : Abbreviated syntax. We translate into an empty type "" which will be filled up later. *)
  | peek_heap; c=cid; `COLONCOLON; simple2; hl= opt_general_h_args; `GT;  `IMM; dr=opt_derv; ofl= opt_formula_label ->
    (match hl with
        | ([],t) -> F.mkHeapNode2 c generic_pointer_type_name dr true false false false t ofl (get_pos_camlp4 _loc 2)
        | (t,_)  -> F.mkHeapNode c generic_pointer_type_name dr true false false false t ofl (get_pos_camlp4 _loc 2))
  | peek_heap; c=cid; `COLONCOLON; simple2; hal=opt_general_h_args; `GT; dr=opt_derv; ofl = opt_formula_label -> (* let _ = print_endline (fst c) in let _ = print_endline id in *)
    (match hal with
      | ([],t) -> F.mkHeapNode2 c generic_pointer_type_name dr false false false false t ofl (get_pos_camlp4 _loc 2)
      | (t,_)  -> F.mkHeapNode c generic_pointer_type_name dr false false false false t ofl (get_pos_camlp4 _loc 2))
  (* | t = ho_fct_header -> F.mkHeapNode ("",Primed) "" dr false false false false [] None  (get_pos_camlp4 _loc 1) *)
  ]];
  
opt_general_h_args: [[t = OPT general_h_args -> un_option t ([],[])]];   
        
(*general_h_args:
  [
  [ i = cexp ; t=opt_heap_arg_list -> (i::t,[])]
  |[ `IDENTIFIER id ; `EQ; i=cexp ; t=opt_heap_arg_list2 -> ([],(id,i)::t)]
  ];*)

general_h_args:
  [[ t= opt_heap_arg_list2 -> ([],t) 
  | t= opt_heap_arg_list -> (t,[])]];  

  
              
opt_pure_constr: [[t=OPT and_pure_constr -> un_option t (P.mkTrue no_pos)]];
    
and_pure_constr: [[ peek_and_pure; `AND; t=pure_constr ->t]];
    
(* (formula option , expr option )   *)
    
pure_constr: [[ peek_pure_out; t=cexp_w -> (*let _ = print_string ("pure_constr" ^ (string_of_int (get_pos_camlp4 _loc 1))) in*)
					match t with
                    | Pure_f f -> f
                    | Pure_c (P.Var (v,_)) ->  P.BForm ((P.mkBVar v (get_pos_camlp4 _loc 1), None), None)
                    | _ ->  report_error (get_pos_camlp4 _loc 1) "expected pure_constr, found cexp"]];

cexp: [[t=cexp_w -> match t with
                    | Pure_c f -> f
                    | _ -> report_error (get_pos_camlp4 _loc 1) "expected cexp, found pure_constr"]
];

(*opt_slicing_label: [[ t = OPT slicing_label -> un_option t false ]];*)

slicing_label: [[ `DOLLAR -> true ]];

cexp_w :
  [ "pure_lbl"
    [ofl= pure_label ; spc=SELF (*LEVEL "pure_or"*)          -> apply_pure_form1 (fun c-> label_formula c ofl) spc]   (*apply_cexp*)

  | "slicing_label"
	[ sl=slicing_label; f=SELF -> set_slicing_utils_pure_double f sl ]
  
  | "pure_or" RIGHTA
   [ pc1=SELF; `OR; pc2=SELF             -> apply_pure_form2 (fun c1 c2-> P.mkOr c1 c2 None (get_pos_camlp4 _loc 2)) pc1 pc2]
  
  | "pure_and" RIGHTA
   [ pc1=SELF; peek_and; `AND; pc2=SELF              -> apply_pure_form2 (fun c1 c2-> P.mkAnd c1 c2 (get_pos_camlp4 _loc 2)) pc1 pc2]

  |"bconstrp" RIGHTA
    [  lc=SELF; `NEQ;  cl=SELF       ->
		let f = cexp_to_pure2 (fun c1 c2-> P.mkNeq c1 c2 (get_pos_camlp4 _loc 2)) lc cl in
		set_slicing_utils_pure_double f false
	 | lc=SELF; `EQ;   cl=SELF  ->
		let f = cexp_to_pure2 (fun c1 c2-> P.mkEq c1 c2 (get_pos_camlp4 _loc 2)) lc cl in
		set_slicing_utils_pure_double f false
    ]  
  | "bconstr" 
    [ (*  lc=SELF; `NEQ;    cl=SELF       -> cexp_to_pure2 (fun c1 c2-> P.mkNeq c1 c2 (get_pos_camlp4 _loc 2)) lc cl *)
     (* | lc=SELF; `EQ;   cl=SELF   -> cexp_to_pure2 (fun c1 c2-> P.mkEq c1 c2 (get_pos_camlp4 _loc 2)) lc cl  *)
     (* |  *)
	   lc=SELF; `LTE;    cl=SELF       ->
			let f = cexp_to_pure2 (fun c1 c2-> P.mkLte c1 c2 (get_pos_camlp4 _loc 2)) lc cl in
			set_slicing_utils_pure_double f false
     | lc=SELF; `LT;     cl=SELF       ->
			let f = cexp_to_pure2 (fun c1 c2-> P.mkLt c1 c2 (get_pos_camlp4 _loc 2)) lc cl in
			set_slicing_utils_pure_double f false
     | lc=SELF; peek_try; `GT;     cl=SELF       ->
	 let f = cexp_to_pure2 (fun c1 c2-> P.mkGt c1 c2 (get_pos_camlp4 _loc 2)) lc cl in
	 set_slicing_utils_pure_double f false
     | lc=SELF; `GTE;    cl=SELF       ->
	 let f = cexp_to_pure2 (fun c1 c2-> P.mkGte c1 c2 (get_pos_camlp4 _loc 2)) lc cl in
	   set_slicing_utils_pure_double f false
     | peek_try; lc=cid; `IN_T;   cl=SELF                      ->
	 let f = cexp_to_pure1 (fun c2-> P.BagIn (lc,c2,(get_pos_camlp4 _loc 2))) cl in
	 set_slicing_utils_pure_double f false
     | peek_try; lc=cid; `NOTIN;  cl=SELF                      ->
	 let f = cexp_to_pure1 (fun c2-> P.BagNotIn(lc,c2,(get_pos_camlp4 _loc 2))) cl  in
	 set_slicing_utils_pure_double f false
     | lc=SELF; `SUBSET; cl=SELF                            ->
	 let f = cexp_to_pure2 (fun c1 c2-> P.BagSub (c1, c2, (get_pos_camlp4 _loc 2))) lc cl in
	 set_slicing_utils_pure_double f false
     | `BAGMAX; `OPAREN; c1=cid; `COMMA; c2=cid; `CPAREN        ->
	 let f = Pure_f (P.BForm ((P.BagMax (c1, c2, (get_pos_camlp4 _loc 2)), None), None)) in
	 set_slicing_utils_pure_double f false
     | `BAGMIN; `OPAREN; c1=cid; `COMMA; c2=cid; `CPAREN        ->
	 let f = Pure_f (P.BForm ((P.BagMin (c1, c2, (get_pos_camlp4 _loc 2)), None), None))  in
	 set_slicing_utils_pure_double f false
     | lc=SELF; `INLIST; cl=SELF                ->
	 let f = cexp_to_pure2 (fun c1 c2-> P.ListIn (c1, c2, (get_pos_camlp4 _loc 2))) lc cl in
	 set_slicing_utils_pure_double f false
     | lc=SELF; `NOTINLIST; cl=SELF             ->
	 let f = cexp_to_pure2 (fun c1 c2-> P.ListNotIn (c1, c2, (get_pos_camlp4 _loc 2))) lc cl in
	 set_slicing_utils_pure_double f false
     | `ALLN; `OPAREN; lc=SELF; `COMMA; cl=SELF; `CPAREN    ->
	 let f = cexp_to_pure2 (fun c1 c2-> P.ListAllN (c1, c2, (get_pos_camlp4 _loc 2))) lc cl  in
	 set_slicing_utils_pure_double f false
     | `PERM; `OPAREN; lc=SELF; `COMMA; cl=SELF; `CPAREN    ->
	 let f = cexp_to_pure2 (fun c1 c2-> P.ListPerm (c1, c2, (get_pos_camlp4 _loc 2))) lc cl in
	 set_slicing_utils_pure_double f false]

 
   
  | "pure_paren" 
         [peek_pure; `OPAREN;  dc=SELF; `CPAREN -> dc ] 

   
(* constraint expressions *)
   | "gen" 
   [ `OBRACE; c= opt_cexp_list; `CBRACE                            -> Pure_c (P.Bag (c, get_pos_camlp4 _loc 1)) 
   | `UNION; `OPAREN; c=opt_cexp_list; `CPAREN                     -> Pure_c (P.BagUnion (c, get_pos_camlp4 _loc 1))
   | `INTERSECT; `OPAREN; c=opt_cexp_list; `CPAREN                 -> Pure_c (P.BagIntersect (c, get_pos_camlp4 _loc 1)) 
   | `DIFF; `OPAREN; c1=SELF; `COMMA; c2=SELF; `CPAREN             -> apply_cexp_form2 (fun c1 c2-> P.BagDiff (c1, c2, get_pos_camlp4 _loc 1) ) c1 c2
 

   | `OLIST; c1 = opt_cexp_list; `CLIST                              -> Pure_c (P.List (c1, get_pos_camlp4 _loc 1)) 
   |  c1=SELF; `COLONCOLONCOLON; c2=SELF -> apply_cexp_form2 (fun c1 c2-> P.ListCons (c1, c2, get_pos_camlp4 _loc 2)) c1 c2 
   | `TAIL; `OPAREN; c1=SELF; `CPAREN                -> apply_cexp_form1 (fun c1-> P.ListTail (c1, get_pos_camlp4 _loc 1)) c1 
   | `APPEND; `OPAREN; c1=opt_cexp_list; `CPAREN                   -> Pure_c (P.ListAppend (c1, get_pos_camlp4 _loc 1))
   | `HEAD; `OPAREN; c=SELF; `CPAREN         -> apply_cexp_form1 (fun c -> P.ListHead (c, get_pos_camlp4 _loc 1)) c
   | `LENGTH; `OPAREN; c=SELF; `CPAREN       -> (* print_string("herel"); *)apply_cexp_form1 (fun c -> P.ListLength (c, get_pos_camlp4 _loc 1)) c
   | `REVERSE; `OPAREN; c1=SELF; `CPAREN             -> apply_cexp_form1 (fun c1-> P.ListReverse (c1, get_pos_camlp4 _loc 1)) c1 
   (* | t=cexp_w LEVEL "addit" -> t *) ]
 
   | [`MINUS; c=SELF               -> apply_cexp_form1 (fun c-> P.mkSubtract (P.IConst (0, get_pos_camlp4 _loc 1)) c (get_pos_camlp4 _loc 1)) c]

   | "addit"
     [ c1=SELF ; `PLUS; c2=SELF       -> apply_cexp_form2 (fun c1 c2-> P.mkAdd c1 c2 (get_pos_camlp4 _loc 2)) c1 c2  
     | c1=SELF ; `MINUS; c2=SELF      -> apply_cexp_form2 (fun c1 c2-> P.mkSubtract c1 c2 (get_pos_camlp4 _loc 2)) c1 c2
     (*| t =cexp_w LEVEL "mul"                                        -> t*)]
     
   | "mul"
     [ t1=SELF ; `STAR; t2=SELF         -> apply_cexp_form2 (fun c1 c2-> P.mkMult c1 c2 (get_pos_camlp4 _loc 2)) t1 t2
     | t1=SELF ; `DIV ; t2=SELF         -> apply_cexp_form2 (fun c1 c2-> P.mkDiv c1 c2 (get_pos_camlp4 _loc 2)) t1 t2  
     (*| t =cexp_w                                                 -> t *)]


   | "una"
     [(*   h = ho_fct_header                   -> Pure_f (P.mkTrue (get_pos_camlp4 _loc 1)) *)
     (* | *) `NULL                                     -> Pure_c (P.Null (get_pos_camlp4 _loc 1))

	(* An Hoa : Hole for partial structures, represented by the hash # character. *)
	 | `HASH -> let _ = hash_count := !hash_count + 1 in 
			Pure_c (P.Var (("#" ^ (string_of_int !hash_count),Unprimed),(get_pos_camlp4 _loc 1)))

     | `IDENTIFIER id; `OPAREN; cl = opt_cexp_list; CPAREN -> (* print_string("here"); *)
    (* AnHoa: relation constraint, for instance, given the relation 
     * s(a,b,c) == c = a + b.
     * After this definition, we can have the relation constraint like
     * s(x,1,x+1), s(x,y,x+y), ...
	 * in our formula.
     *)
            Pure_f(P.BForm ((P.RelForm (id, cl, get_pos_camlp4 _loc 1), None), None))

     | peek_cexp_list; ocl = opt_comma_list -> (* let tmp = List.map (fun c -> P.Var(c,get_pos_camlp4 _loc 1)) ocl in *) Pure_c(P.List(ocl, get_pos_camlp4 _loc 1)) 
     | t = cid                -> (* print_string ("cexp:"^(fst t)^"\n"); *)Pure_c (P.Var (t, get_pos_camlp4 _loc 1))
     | `INT_LITER (i,_)                          -> Pure_c (P.IConst (i, get_pos_camlp4 _loc 1)) 
     | `FLOAT_LIT (f,_)                          -> (* (print_string ("FLOAT:"^string_of_float(f)^"\n"); *) Pure_c (P.FConst (f, get_pos_camlp4 _loc 1))
     | `OPAREN; t=SELF; `CPAREN                -> t  
     |  i=cid; (* An Hoa : extend with multi-dimensional array access *) `OSQUARE; c = LIST1 cexp SEP `COMMA; `CSQUARE                            -> Pure_c (P.ArrayAt (i, c, get_pos_camlp4 _loc 1))
     | `MAX; `OPAREN; c1=SELF; `COMMA; c2=SELF; `CPAREN 
                                                 -> apply_cexp_form2 (fun c1 c2-> P.mkMax c1 c2 (get_pos_camlp4 _loc 1)) c1 c2
     | `MIN; `OPAREN; c1=SELF; `COMMA; c2=SELF; `CPAREN 
                                                 -> apply_cexp_form2 (fun c1 c2-> P.mkMin c1 c2 (get_pos_camlp4 _loc 1)) c1 c2
]
 
   | "pure_base"
     [ `TRUE                             -> Pure_f (P.mkTrue (get_pos_camlp4 _loc 1))
     | `FALSE                            -> Pure_f (P.mkFalse (get_pos_camlp4 _loc 1))
     | `EXISTS; `OPAREN; ocl=opt_cid_list; `COLON; pc=SELF; `CPAREN      
                                         -> apply_pure_form1 (fun c-> List.fold_left (fun f v ->P.mkExists [v] f None (get_pos_camlp4 _loc 1)) c ocl) pc
     | `FORALL; `OPAREN; ocl=opt_cid_list; `COLON; pc=SELF; `CPAREN 
                                         -> apply_pure_form1 (fun c-> List.fold_left (fun f v-> P.mkForall [v] f None (get_pos_camlp4 _loc 1)) c ocl) pc
     | t=cid                             -> (*print_string ("pure_form:"^(fst t)^"\n");*) Pure_f (P.BForm ((P.mkBVar t (get_pos_camlp4 _loc 1), None), None ))
     | `NOT; t=cid                       -> Pure_f (P.mkNot (P.BForm ((P.mkBVar t (get_pos_camlp4 _loc 2), None), None )) None (get_pos_camlp4 _loc 1))
     | `NOT; `OPAREN; c=pure_constr; `CPAREN     -> Pure_f (P.mkNot c None (get_pos_camlp4 _loc 1))  
    
     (*| lc=cexp_w LEVEL "bconstr"    -> lc*)
     ]

  
   ];

opt_comma_list:[[t = LIST0 opt_comma SEP `COMMA -> t
]];

opt_comma:[[t = cid ->  P.Var (t, get_pos_camlp4 _loc 1)
  | `INT_LITER (i,_) ->  P.IConst (i, get_pos_camlp4 _loc 1)
  | `FLOAT_LIT (f,_)  -> P.FConst (f, get_pos_camlp4 _loc 1)
   ]];

opt_cexp_list:[[t=LIST0 cexp SEP `COMMA -> t]]; 

(* cexp_list: [[t=LIST1 cexp_w SEP `COMMA -> t]]; *)

(********** Procedures and Coercion **********)


checkentail_cmd:
  [[ `CHECKENTAIL; t=meta_constr; `DERIVE; b=extended_meta_constr -> (t, b)]];

infer_cmd:
  [[ `INFER; `OSQUARE; il=id_list; `CSQUARE; t=meta_constr; `DERIVE; b=extended_meta_constr -> (il, t, b)]];

captureresidue_cmd:
  [[ `CAPTURERESIDUE; `DOLLAR; `IDENTIFIER id -> id ]];

compose_cmd:
  [[ `COMPOSE; `OSQUARE; il=id_list; `CSQUARE; `OPAREN; mc1=meta_constr; `SEMICOLON; mc2=meta_constr; `CPAREN ->(il, mc1, mc2)
   | `COMPOSE; `OPAREN; mc1=meta_constr; `SEMICOLON; mc2=meta_constr; `CPAREN -> ([], mc1, mc2)]];

print_cmd:
  [[ `PRINT; `IDENTIFIER id           -> PCmd id
   | `PRINT; `DOLLAR; `IDENTIFIER id  -> PVar id]];

time_cmd:
  [[ `DTIME; `ON; `IDENTIFIER id   -> Time(true, id, get_pos_camlp4 _loc 1)
   | `DTIME; `OFF; `IDENTIFIER id  -> Time(false, id, get_pos_camlp4 _loc 1)]];

let_decl:
  [[ `LET; `DOLLAR; `IDENTIFIER id; `EQ; mc=meta_constr ->	LetDef (id, mc)]];
  
extended_meta_constr:
  [[ `DOLLAR;`IDENTIFIER id  -> MetaVar id
   | f= formulas              -> MetaEForm (F.subst_stub_flow_struc n_flow (fst f))
	 | c = compose_cmd           -> MetaCompose c]];
   
meta_constr:
  [[ `DOLLAR; `IDENTIFIER id -> MetaVar id
   | d=disjunctive_constr    -> MetaForm (F.subst_stub_flow n_flow d)
   | c=compose_cmd           -> MetaCompose c]];

coercion_decl:
  [[ on=opt_name; dc1=disjunctive_constr; cd=coercion_direction; dc2=disjunctive_constr ->
      { coercion_type = cd;
        coercion_name = (* on; *)
        (let v=on in (if (String.compare v "")==0 then (fresh_any_name "lem") else v));
        (* coercion_head = dc1; *)
        (* coercion_body = dc2; *)
        (* must remove stub flow from formula - replace with top_flow *)
        coercion_head = (F.subst_stub_flow top_flow dc1);
        coercion_body = (F.subst_stub_flow top_flow dc2);
        (* coercion_head = (F.subst_stub_flow n_flow dc1); *)
        (* coercion_body = (F.subst_stub_flow n_flow dc2); *)
        coercion_proof = Return ({ exp_return_val = None;
                     exp_return_path_id = None ;
                     exp_return_pos = get_pos_camlp4 _loc 1 })}]];

coercion_direction:
  [[ `LEFTARROW  -> Left
   | `EQUIV      -> Equiv 
   | `RIGHTARROW -> Right]];

opt_name: [[t= OPT name-> un_option t ""]];

name:[[ `STRING(_,id)  -> id]];

typ:
  [[ peek_array_type; t=array_type     -> (* An Hoa *) (*let _ = print_endline "Parsed array type" in *) t
    | t=non_array_type -> (* An Hoa *) (* let _ = print_endline "Parsed a non-array type" in *) t]];

non_array_type:
  [[ `INT                -> int_type
   | `FLOAT              -> float_type 
   | `BOOL               -> bool_type
   | `IDENTIFIER id      -> Named id ]];  

array_type:
  [[ (* t=array_type; r=rank_specifier -> Array (t, None)
  | *) t=non_array_type; r=rank_specifier -> Array (t, r)]];

rank_specifier:
  [[`OSQUARE; c = OPT comma_list; `CSQUARE -> un_option c 1]];

comma_list: [[`COMMA; s = OPT SELF -> 1 + (un_option s 1)]];
  
id_list_opt:[[t= LIST0 id SEP `COMMA ->t]];

id_list:[[t=LIST1 id SEP `COMMA -> t]];

id:[[`IDENTIFIER id-> id]];
  
(********** Higher Order Preds *******)

hopred_decl: 
  [[`HPRED; h=hpred_header; `EXTENDS; b=ext_form 
      -> mkHoPred  (fst (fst h)) "extends" [(fst b)] (snd (fst h)) (fst (snd h)) (snd (snd h)) (snd b) (P.mkTrue no_pos ,[("Inv", P.mkTrue no_pos)])
	| `HPRED; h=hpred_header; `REFINES;  b=ext_form
      -> mkHoPred  (fst (fst h)) "refines" [(fst b)] (snd (fst h)) (fst (snd h)) (snd (snd h)) (snd b) (P.mkTrue no_pos ,[("Inv", P.mkTrue no_pos)])
  | `HPRED; h=hpred_header; `JOIN; s=split_combine 
      -> mkHoPred (fst (fst h)) "split_combine" [] [] [] [] [] (P.mkTrue no_pos ,[("Inv", P.mkTrue no_pos)])
	| `HPRED; h=hpred_header;  `EQEQ; s=shape; oi= opt_inv; `SEMICOLON 
      -> mkHoPred (fst (fst h)) "pure_higherorder_pred" [] (snd (fst h)) (fst (snd h)) (snd (snd h)) [s] oi]];
      
shape: [[ t= formulas -> fst t]];

split_combine: 
  [[ h=hpred_header -> ()
   | h=hpred_header; `SPLIT; t=SELF -> ()
   | h=hpred_header; `COMBINE; t=SELF -> ()]];
   
ext_form: [[ h=hpred_header;	`WITH; `OBRACE; t=ho_fct_def_list; `CBRACE ->("",[])]];
  
ho_fct_header: [[`IDENTIFIER id; `OPAREN; f=fct_arg_list; `CPAREN -> f]];

ho_fct_def:	[[ h=ho_fct_header; `EQ; s=shape -> ()]];

ho_fct_def_list: [[t = LIST1 ho_fct_def  -> ()]];

hpred_header: [[`IDENTIFIER id; t=opt_type_var_list; `LT; t2=opt_typed_arg_list; `GT; t3=opt_fct_list -> ((id,t),(t2,t3))]];

typed_arg:
   [[ t=typ -> ()
    | `SET;  `OSQUARE; t=typ;  `CSQUARE -> ()
    | `SET;  `OSQUARE; t=typ;  `CSQUARE; `COLON; t3=SELF -> ()
    | t=typ; `OSQUARE; t2=typ; `CSQUARE -> ()
    | t=typ; `OSQUARE; t2=typ; `CSQUARE; `COLON; t3=SELF -> ()
    | t=typ; `COLON;   t2=SELF -> ()]];

opt_typed_arg_list: [[t=LIST0 typed_arg SEP `COMMA -> [] ]];

type_var: 
   [[ t= typ -> ()
    | `SET; `OSQUARE; t=typ; `CSQUARE -> ()
    | t=typ; `OSQUARE; t2=typ; `CSQUARE -> ()]];

type_var_list: [[`OSQUARE; t= LIST1 type_var SEP `COMMA; `CSQUARE -> ()]];

opt_type_var_list: [[ t= OPT type_var_list -> [] ]];

fct_arg_list: [[ t=LIST1 cid SEP `COMMA -> t]];

fct_list: [[ `OSQUARE; t=fct_arg_list; `CSQUARE -> [] ]];

opt_fct_list:[[ t = OPT fct_list -> []]];
  


(************ An Hoa :: Relations ************)
rel_decl:[[ rh=rel_header; `EQEQ; rb=rel_body (* opt_inv *) -> 
	{ rh with rel_formula = rb (* (fst $3) *); (* rel_invariant = $4; *) }
	(* [4/10/2011] allow for declaration of relation without body; such relations are constant true and need to be axiomatized using axioms declarations. *)
	| rh=rel_header -> rh
  | rh = rel_header; `EQ -> report_error (get_pos_camlp4 _loc 2) ("use == to define a relation")
]];

typed_id_list:[[ t = typ; `IDENTIFIER id ->  (t,id) ]];

typed_id_list_opt: [[ t = LIST0 typed_id_list SEP `COMMA -> t ]];

rel_header:[[
`REL; `IDENTIFIER id; `OPAREN; tl=typed_id_list_opt; (* opt_ann_cid_list *) `CPAREN  ->
    (* let cids, anns = List.split $4 in
    let cids, br_labels = List.split cids in
	  if List.exists 
		(fun x -> match snd x with | Primed -> true | Unprimed -> false) cids 
	  then
		report_error (get_pos_camlp4 _loc 1) 
		  ("variables in view header are not allowed to be primed")
	  else
		let modes = get_modes anns in *)
		  { rel_name = id;
			rel_typed_vars = tl;
			rel_formula = P.mkTrue no_pos; (* F.mkETrue top_flow (get_pos_camlp4 _loc 1); *)}
]];

rel_body:[[ (* formulas { 
    ((F.subst_stub_flow_struc top_flow (fst $1)),(snd $1)) } *)
	pc=pure_constr -> pc (* Only allow pure constraint in relation definition. *)
]];

axiom_decl:[[
	`AXIOM; lhs=pure_constr; `ESCAPE; rhs=pure_constr ->
		{ axiom_hypothesis = lhs;
		  axiom_conclusion = rhs; }
]];

 (*end of sleek part*)   
 (*start of hip part*)
hprogn: 
  [[ t = opt_decl_list ->
      let data_defs = ref ([] : data_decl list) in
      let global_var_defs = ref ([] : exp_var_decl list) in
      let enum_defs = ref ([] : enum_decl list) in
      let view_defs = ref ([] : view_decl list) in
	  let rel_defs = ref ([] : rel_decl list) in (* An Hoa *)
	  let axiom_defs = ref ([] : axiom_decl list) in (* [4/10/2011] An Hoa *)
      let proc_defs = ref ([] : proc_decl list) in
      let coercion_defs = ref ([] : coercion_decl list) in
      let hopred_defs = ref ([] : hopred_decl list) in
      let choose d = match d with
        | Type tdef -> begin
          match tdef with
          | Data ddef -> data_defs := ddef :: !data_defs
          | Enum edef -> enum_defs := edef :: !enum_defs
          | View vdef -> view_defs := vdef :: !view_defs
          | Hopred hpdef -> hopred_defs := hpdef :: !hopred_defs
          end
        | Rel rdef -> rel_defs := rdef :: !rel_defs (* An Hoa *)
        | Axm adef -> axiom_defs := adef :: !axiom_defs (* An Hoa *)
        | Global_var glvdef -> global_var_defs := glvdef :: !global_var_defs 
        | Proc pdef -> proc_defs := pdef :: !proc_defs 
      | Coercion cdef -> coercion_defs := cdef :: !coercion_defs in
    let _ = List.map choose t in
    let obj_def = { data_name = "Object";
					data_fields = [];
					data_parent_name = "";
					data_invs = []; (* F.mkTrue no_pos; *)
					data_methods = [] } in
    let string_def = { data_name = "String";
					   data_fields = [];
					   data_parent_name = "Object";
					   data_invs = []; (* F.mkTrue no_pos; *)
					   data_methods = [] } in
    { prog_data_decls = obj_def :: string_def :: !data_defs;
      prog_global_var_decls = !global_var_defs;
      prog_enum_decls = !enum_defs;
      (* prog_rel_decls = [];  TODO : new field for array parsing *)
      prog_view_decls = !view_defs;
      prog_rel_decls = !rel_defs; (* An Hoa *)
      prog_axiom_decls = !axiom_defs; (* [4/10/2011] An Hoa *)
      prog_proc_decls = !proc_defs;
      prog_coercion_decls = !coercion_defs; 
      prog_hopred_decls = !hopred_defs;} ]];

opt_decl_list: [[t=LIST0 decl -> t]];
  
decl:
  [[ t=type_decl                  -> Type t
  |  r=rel_decl; `DOT -> Rel r (* An Hoa *)
  |  a=axiom_decl; `DOT -> Axm a (* [4/10/2011] An Hoa *)
  |  g=global_var_decl            -> Global_var g
  |  p=proc_decl                  -> Proc p
  | `COERCION; c= coercion_decl; `SEMICOLON    -> Coercion c ]];

type_decl: 
  [[ t= data_decl  -> Data t
   | c=class_decl -> Data c
   | e=enum_decl  -> Enum e
   | v=view_decl; `SEMICOLON -> View v
   | h=hopred_decl-> Hopred h ]];

   
(***************** Global_variable **************)
global_var_decl:
  [[ `GLOBAL; lvt=local_variable_type; vd=variable_declarators; `SEMICOLON -> mkGlobalVarDecl lvt vd (get_pos_camlp4 _loc 1)]];

(**************** Class ******************)

class_decl:
  [[ `CLASS; `IDENTIFIER id; par=OPT extends; `OBRACE; ml=member_list_opt; `CBRACE ->
      let t1, t2, t3 = split_members ml in
		(* An Hoa [22/08/2011] : blindly add the members as non-inline because we do not support inline fields in classes. TODO revise. *)
		let t1 = List.map (fun (t, p) -> (t, p, false)) t1 in
      let cdef = { data_name = id;
                   data_parent_name = un_option par "Object";
                   data_fields = t1;
                   data_invs = t2; 
                   data_methods = t3 } in
      let _ = List.map (fun d -> set_proc_data_decl d cdef) t3 in
      cdef]];

extends: [[`EXTENDS; `IDENTIFIER id -> id]];

member_list_opt: [[t = LIST0 member SEP `SEMICOLON -> t]];

member:
 [[ t=typ; `IDENTIFIER id -> Field ((t, id), get_pos_camlp4 _loc 2) 
  | `INV;  dc=disjunctive_constr -> Inv (F.subst_stub_flow top_flow dc) 
  | pd=proc_decl -> Method pd
  | cd=constructor_decl -> Method cd]];
 
(*************** Enums ******************)

enum_decl:
  [[ h=enum_header; b=enum_body -> { enum_name = h; enum_fields = b }]];

enum_header: [[`ENUM; `IDENTIFIER n -> n]];

enum_body: [[`OBRACE; l=enum_list; `CBRACE -> l]];

enum_list:[[t=LIST1 enumerator SEP `COMMA -> t]];

enumerator:
  [[ `IDENTIFIER n -> (n, None)
   | `IDENTIFIER n; `EQ;  `INT_LITER(i,_) -> (n, Some i) ]];
 
 
(****Specs *******)
opt_sq_clist : [[t = OPT sq_clist -> un_option t []]];
 
opt_spec_list: [[t = LIST0 spec -> t]];
  
spec_list : [[t= LIST1 spec -> t ]];

spec: 
  [[ `REQUIRES; cl= opt_sq_clist; dc= disjunctive_constr; s=SELF ->
		 Iformula.EBase {
			 Iformula.formula_ext_explicit_inst =cl;
			 Iformula.formula_ext_implicit_inst = [];
			 Iformula.formula_ext_exists = [];
			 Iformula.formula_ext_base = (F.subst_stub_flow n_flow dc);
			 Iformula.formula_ext_continuation = [s];
			 Iformula.formula_ext_pos = (get_pos_camlp4 _loc 1)}
	 | `REQUIRES; cl=opt_sq_clist; dc=disjunctive_constr; `OBRACE; sl=spec_list; `CBRACE ->
	    	Iformula.EBase {
	    	 Iformula.formula_ext_explicit_inst =cl;
	    	 Iformula.formula_ext_implicit_inst = [];
	    	 Iformula.formula_ext_exists = [];
	    	 Iformula.formula_ext_base =  (F.subst_stub_flow n_flow dc);
	    	 Iformula.formula_ext_continuation = if ((List.length sl)==0) then report_error (get_pos_camlp4 _loc 1) "spec must contain ensures"
	    																					else sl;
	    	 Iformula.formula_ext_pos = (get_pos_camlp4 _loc 1)}
       
	 | `ENSURES; ol= opt_label; dc= disjunctive_constr; `SEMICOLON ->
      Iformula.EAssume ((F.subst_stub_flow n_flow dc),(fresh_formula_label ol))
	 | `CASE; `OBRACE; bl= branch_list; `CBRACE ->
			Iformula.ECase {
						Iformula.formula_case_branches = bl; 
						Iformula.formula_case_pos = get_pos_camlp4 _loc 1; }
	 | `VARIANCE; il=opt_var_label; m=opt_measures; ec=opt_escape_conditions; s=SELF ->
			Iformula.EVariance {
					Iformula.formula_var_label = il;
					Iformula.formula_var_measures = m;
					Iformula.formula_var_escape_clauses = ec;
					Iformula.formula_var_continuation = [s];
					Iformula.formula_var_pos = get_pos_camlp4 _loc 1;}]];

opt_var_label: [[t=OPT var_label -> t]];

var_label: [[ `OPAREN; vl=integer_literal; `CPAREN -> vl
|`OPAREN ; `MINUS; vl=integer_literal; `CPAREN -> -vl]];	
          
opt_measures: [[t=OPT measures -> un_option t []]];

measures: [[`OSQUARE; vl=variance_list; `CSQUARE -> vl]];

variance_list: [[t=LIST1 cexp_with_bound SEP `COMMA -> t]];

cexp_with_bound: 
  [[ t=cexp -> (t, None)
	 | t1=cexp; `AT; t2=cexp -> (t1, Some t2)]];

opt_escape_conditions: [[ t= OPT escape_conditions -> un_option t []]];

escape_conditions: [[ `ESCAPE; `OSQUARE; t=condition_list; `CSQUARE -> t]];

condition_list: [[t=pure_constr ->[t]]];
  
branch_list: [[t=LIST1 spec_branch -> List.rev t]];

spec_branch: [[ pc=pure_constr; `LEFTARROW; sl= spec_list -> (pc,sl)]];
	 
 
 (***********Proc decls ***********)

opt_throws: [[ t = OPT throws -> un_option t []]];
throws: [[ `THROWS; l=cid_list -> List.map fst l]];

proc_decl: 
  [[ h=proc_header; b=proc_body -> { h with proc_body = Some b ; proc_loc = {(h.proc_loc) with end_pos = Parsing.symbol_end_pos()} }
   | h=proc_header -> h]];
  
proc_header:
  [[ t=typ; `IDENTIFIER id; `OPAREN; fpl=opt_formal_parameter_list; `CPAREN; ot=opt_throws; osl=opt_spec_list ->
    (*let static_specs, dynamic_specs = split_specs osl in*)
     mkProc id "" None false ot fpl t osl [] (get_pos_camlp4 _loc 1) None
     
  | `VOID; `IDENTIFIER id; `OPAREN; fpl=opt_formal_parameter_list; `CPAREN; ot=opt_throws; osl=opt_spec_list ->
    (*let static_specs, dynamic_specs = split_specs $6 in*)
    mkProc id "" None false ot fpl void_type osl [] (get_pos_camlp4 _loc 1) None]];

constructor_decl: 
  [[ h=constructor_header; b=proc_body -> {h with proc_body = Some b}
   | h=constructor_header -> h]];

constructor_header:
  [[ `IDENTIFIER id; `OPAREN; fpl=opt_formal_parameter_list; `CPAREN; ot=opt_throws; osl=opt_spec_list ->
    (*let static_specs, dynamic_specs = split_specs $5 in*)
		(*if Util.empty dynamic_specs then*)
      mkProc id "" None true ot fpl (Named id) osl [] (get_pos_camlp4 _loc 1) None
    (*	else
		  report_error (get_pos_camlp4 _loc 1) ("constructors have only static speficiations");*) ]];
	


opt_formal_parameter_list: [[t= LIST0 fixed_parameter SEP `COMMA -> t]];
  
fixed_parameter:
  [[ pm=OPT ref_t; t=typ; `IDENTIFIER id -> 
      { param_mod = un_option pm NoMod;
        param_type = t;
        param_loc = get_pos_camlp4 _loc 3;
        param_name = id }]];

ref_t: [[REF -> RefMod]];
  
proc_body: [[t=block-> t]];

(*********** Statements ***************)

block: 
  [[ `OBRACE; t=statement_list; `CBRACE -> 
	  match t with
	  | Empty _ -> Block { exp_block_body = Empty (get_pos_camlp4 _loc 1);
                         exp_block_jump_label = NoJumpLabel;
                         exp_block_local_vars = [];
                         exp_block_pos = get_pos_camlp4 _loc 1 }
	  | _ -> Block { exp_block_body = t;
                   exp_block_jump_label = NoJumpLabel;
                   exp_block_local_vars = [];
                   exp_block_pos = get_pos_camlp4 _loc 1 }
				   ]];

statement_list: 
[[ s = statement -> s
  | sl=SELF; s=statement  -> Seq { exp_seq_exp1 = sl;
									 exp_seq_exp2 = s;
									 exp_seq_pos = get_pos_camlp4 _loc 1 }
]];

(* opt_statement_list: [[ t= LIST0 statement SEP `SEMICOLON ->  *)
(*     match t with  *)
(*      | [] ->  Empty no_pos *)
(*      | h::t -> List.fold_left (fun a c-> Seq {exp_seq_exp1 = a; exp_seq_exp2=c; exp_seq_pos =get_pos_camlp4 _loc 1}) h t ]]; *)
  
statement:
  [[ t=declaration_statement; `SEMICOLON -> t
   | t=labeled_valid_declaration_statement -> t]];

declaration_statement:
  [[peek_try_declarest; t=local_variable_declaration -> t
   | peek_try_declarest; t=local_constant_declaration -> t]];

local_variable_type: [[ t= typ ->  t]];

local_variable_declaration: [[  t1=local_variable_type; t2=variable_declarators -> mkVarDecl t1 t2 (get_pos_camlp4 _loc 1)]]; 

local_constant_declaration: [[ `CONST; lvt=local_variable_type; cd=constant_declarators ->  mkConstDecl lvt cd (get_pos_camlp4 _loc 1)]];
	
variable_declarators: [[ t= LIST1 variable_declarator SEP `COMMA -> t]];
  
variable_declarator:
  [[ `IDENTIFIER id; `EQ; t=variable_initializer  -> (* print_string ("Identifier : "^id^"\n"); *) (id, Some t, get_pos_camlp4 _loc 1)
   | `IDENTIFIER id -> (* print_string ("Identifier : "^id^"\n"); *)(id, None, get_pos_camlp4 _loc 1) ]];

variable_initializer: [[t= expression ->t]];

constant_declarators: [[t=LIST1 constant_declarator SEP `COMMA -> t]];

constant_declarator: [[ `IDENTIFIER id; `EQ; ce=constant_expression -> (id, ce, get_pos_camlp4 _loc 1)]];

labeled_valid_declaration_statement:
	[[ `IDENTIFIER id ; `COLON; t=valid_declaration_statement -> 
		(match t with
      | Block	b -> Block { b with exp_block_jump_label = JumpLabel id; }
      | While b -> While { b with exp_while_jump_label = JumpLabel id; }	
      | _ -> report_error (get_pos_camlp4 _loc 1) ("only blocks try and while statements can have labels"))		
	 (* | t= OPT valid_declaration_statement -> un_option t (Empty (get_pos_camlp4 _loc 1) ) *)
      | t = valid_declaration_statement -> t ]];
  
valid_declaration_statement:
  [[ t=block -> t
  | t=expression_statement;`SEMICOLON ->t
  | t=selection_statement -> t
  | t=iteration_statement -> t
  | t=try_statement; `SEMICOLON -> t
  | t=java_statement -> t
  | t=jump_statement;`SEMICOLON  -> t
  | t=assert_statement;`SEMICOLON -> t
  | t=dprint_statement;`SEMICOLON  -> t
  | t=debug_statement -> t
  | t=time_statement -> t
  | t=bind_statement -> t
  | t=unfold_statement -> t]
  | [t= empty_statement -> t]
];

empty_statement: [[`SEMICOLON -> Empty (get_pos_camlp4 _loc 1) ]];

unfold_statement: [[ `UNFOLD; t=cid  ->	Unfold { exp_unfold_var = t; exp_unfold_pos = get_pos_camlp4 _loc 1 }]];
 
assert_statement:
  [[ `ASSERT; ol= opt_label; f=formulas -> 
       mkAssert (Some ((F.subst_stub_flow_struc n_flow (fst f)),(snd f))) None (fresh_formula_label ol) (get_pos_camlp4 _loc 1)
   | `ASSUME; ol=opt_label; dc=disjunctive_constr ->
       mkAssert None (Some (F.subst_stub_flow n_flow dc)) (fresh_formula_label ol) (get_pos_camlp4 _loc 1)
   | `ASSERT; ol=opt_label; f=formulas; `ASSUME; dc=disjunctive_constr ->  
       mkAssert (Some ((F.subst_stub_flow_struc n_flow (fst f)),(snd f))) (Some (F.subst_stub_flow n_flow dc)) (fresh_formula_label ol) (get_pos_camlp4 _loc 1)]];

debug_statement:
  [[ `DDEBUG; `ON -> Debug { exp_debug_flag = true;	exp_debug_pos = get_pos_camlp4 _loc 2 }
   | `DDEBUG; `OFF -> Debug { exp_debug_flag = false; exp_debug_pos = get_pos_camlp4 _loc 2 }]];
   
time_statement:
  [[ `DTIME; `ON; `IDENTIFIER id -> I.Time (true,id,get_pos_camlp4 _loc 1)
   | `DTIME; `OFF; `IDENTIFIER id -> I.Time (false,id,get_pos_camlp4 _loc 1)]];

dprint_statement:
  [[ `DPRINT  -> Dprint ({exp_dprint_string = ""; exp_dprint_pos = (get_pos_camlp4 _loc 1)})
   | `DPRINT; `STRING(_,id)  -> Dprint ({exp_dprint_string = id;  exp_dprint_pos = (get_pos_camlp4 _loc 1)})]];
   
bind_statement:
  [[ `BIND; `IDENTIFIER id; `TO; `OPAREN; il = id_list_opt; `CPAREN; `IN_T; b=block ->
      Bind { exp_bind_bound_var = id;
             exp_bind_fields = il;
             exp_bind_body = b;
             exp_bind_path_id = None ;
             exp_bind_pos = get_pos_camlp4 _loc 1 }]];

java_statement: [[ `JAVA s -> Java { exp_java_code = s;exp_java_pos = get_pos_camlp4 _loc 1 }]];

expression_statement: [[(* t=statement_expression -> t *)
        t= invocation_expression -> t
      | t=object_creation_expression -> t
      | t= post_increment_expression -> t
      | t= post_decrement_expression -> t
      | t= pre_increment_expression -> t  
      | t= pre_decrement_expression -> t
      | peek_exp_st; t= assignment_expression -> t]]; 

(*statement_expression:
  [[
      
  ]];*)

selection_statement: [[t=if_statement -> t]];

embedded_statement: [[t=valid_declaration_statement -> t]];

if_statement:
  [[ `IF; `OPAREN; bc = boolean_expression; `CPAREN; es=embedded_statement ->
	  Cond { exp_cond_condition = bc;
           exp_cond_then_arm = es;
           exp_cond_else_arm = Empty (get_pos_camlp4 _loc 1);
           exp_cond_path_id = None; 
           exp_cond_pos = get_pos_camlp4 _loc 1 } 	   
  |`IF; 
  `OPAREN; bc=boolean_expression; 
  `CPAREN; tb=embedded_statement; 
  `ELSE_TT; eb=embedded_statement ->
		Cond { exp_cond_condition = bc;
			   exp_cond_then_arm = tb;
			   exp_cond_else_arm = eb;
			   exp_cond_path_id = None; 
			   exp_cond_pos = get_pos_camlp4 _loc 1 }]];

iteration_statement: [[t=while_statement -> t]];

while_statement:
  [[ `WHILE; `OPAREN; bc=boolean_expression; `CPAREN; es=embedded_statement ->
        While { exp_while_condition = bc;
            exp_while_body = es;
            exp_while_specs = Iast.mkSpecTrue n_flow (get_pos_camlp4 _loc 1);
            exp_while_jump_label = NoJumpLabel;
            exp_while_path_id = None ;
            exp_while_f_name = "";
            exp_while_wrappings = None;
            exp_while_pos = get_pos_camlp4 _loc 1 }
   | `WHILE; `OPAREN; bc=boolean_expression; `CPAREN; sl=spec_list; es=embedded_statement ->
        While { exp_while_condition = bc;
          exp_while_body = es;
          exp_while_specs = sl;(*List.map remove_spec_qualifier $5;*)
          exp_while_jump_label = NoJumpLabel;
          exp_while_path_id = None ;
          exp_while_f_name = "";
          exp_while_wrappings = None;
          exp_while_pos = get_pos_camlp4 _loc 1 }]];

jump_statement:
  [[ t=return_statement -> t
   | t=break_statement -> t
   | t=continue_statement -> t
   | t=raise_statement -> t]];

break_statement:
  [[ `BREAK  ->
        Break {
				  exp_break_jump_label = NoJumpLabel;
				  exp_break_path_id = None;
					exp_break_pos = (get_pos_camlp4 _loc 1);}
	| `BREAK; `IDENTIFIER id  ->
        Break {exp_break_jump_label = (JumpLabel id);
				  		 exp_break_path_id = None; 
							exp_break_pos = get_pos_camlp4 _loc 1}]];

continue_statement:
  [[ `CONTINUE  ->
      Continue {exp_continue_jump_label = NoJumpLabel;
							 exp_continue_path_id = None; 
							 exp_continue_pos = get_pos_camlp4 _loc 1}
   | `CONTINUE; `IDENTIFIER  id ->
      Continue {exp_continue_jump_label = (JumpLabel id);
							 exp_continue_path_id = None;
							 exp_continue_pos = get_pos_camlp4 _loc 1}]];

return_statement:
  [[ `RETURN; t=opt_expression ->
      Return { exp_return_val = t;
			 		     exp_return_path_id = None;
							 exp_return_pos = get_pos_camlp4 _loc 1 }]];

raise_statement:
	[[ `RAISE; t=expression ->
      Raise { exp_raise_type = Const_flow "" ;
						  exp_raise_val = Some t;
              exp_raise_from_final = false;
              exp_raise_path_id = None; 
              exp_raise_pos = get_pos_camlp4 _loc 1 }]];
              
try_statement:
	[[ `TRY; t=valid_declaration_statement; cl=opt_catch_list; fl=opt_finally->
      Try { exp_try_block = t;
            exp_catch_clauses = cl;
            exp_finally_clause = fl;
            exp_try_path_id = None;
            exp_try_pos = get_pos_camlp4 _loc 1 }]];

opt_catch_list: [[t= LIST0 catch_clause -> t]];
	
catch_clause:
	[[ `CATCH; `OPAREN; `IDENTIFIER id1; `IDENTIFIER id2; `CPAREN; vds = valid_declaration_statement ->
		  Catch { exp_catch_var = Some id2;
              exp_catch_flow_type = id1;
              exp_catch_flow_var = None;
              exp_catch_body = vds;																					   
              exp_catch_pos = get_pos_camlp4 _loc 1 }]];

opt_finally: [[t =OPT finally_c -> un_option t [] ]];
	
finally_c: [[`FINALLY; vds=valid_declaration_statement -> [Finally {exp_finally_body = vds;exp_finally_pos = get_pos_camlp4 _loc 1 }]]];

opt_expression: [[t=OPT expression -> t]];
  
  
(********** Expressions **********)

object_creation_expression: [[t=object_or_delegate_creation_expression-> t]];

object_or_delegate_creation_expression:
  [[ `NEW; `IDENTIFIER id; `OPAREN; al=opt_argument_list; `CPAREN ->
      New { exp_new_class_name = id;
            exp_new_arguments = al;
            exp_new_pos = get_pos_camlp4 _loc 1 }
	(* An Hoa : Array allocation. *)
	| `NEW; `INT; `OSQUARE; al = argument_list; `CSQUARE ->
		ArrayAlloc { exp_aalloc_etype_name = "int";
					 exp_aalloc_dimensions = al;
					 exp_aalloc_pos = get_pos_camlp4 _loc 1; } ]];

new_expression: [[t=object_or_delegate_creation_expression -> t]];

opt_argument_list : [[t= LIST0 argument SEP `COMMA -> t]];

argument_list : [[t= LIST1 argument SEP `COMMA -> t]];

(* opt_argument_list : [[ t = OPT argument_list -> un_option t [] ]];

argument_list : [[  t = expression -> [t]
				  | arg_list = SELF; `COMMA; t = expression -> t::arg_list
			    ]]; *)

argument: [[t=expression -> t]];

expression:
  [[ t=conditional_expression -> t
   | t=assignment_expression -> t]];

constant_expression: [[t=expression -> t]];
  
boolean_expression:  [[t=expression -> t]];

assignment_expression:
  [[ t1= prefixed_unary_expression; `EQ;  t2=expression            -> mkAssign OpAssign t1 t2 (get_pos_camlp4 _loc 2)
	 | t1=prefixed_unary_expression; `OP_MULT_ASSIGN;t2=expression  -> mkAssign OpMultAssign t1 t2 (get_pos_camlp4 _loc 2)
   | t1=prefixed_unary_expression; `OP_DIV_ASSIGN; t2=expression  -> mkAssign OpDivAssign t1 t2 (get_pos_camlp4 _loc 2)
   | t1=prefixed_unary_expression; `OP_MOD_ASSIGN; t2=expression  -> mkAssign OpModAssign t1 t2 (get_pos_camlp4 _loc 2)
	 | t1=prefixed_unary_expression; `OP_ADD_ASSIGN; t2=expression  -> mkAssign OpPlusAssign t1 t2 (get_pos_camlp4 _loc 2)
	 | t1=prefixed_unary_expression; `OP_SUB_ASSIGN; t2=expression  -> mkAssign OpMinusAssign t1 t2 (get_pos_camlp4 _loc 2)]];

conditional_expression: 
  [[ t= conditional_or_expression -> t
   (*| t= conditional_or_expression; `INTERR; e1=expression; `COLON; e2=expression -> 
          Cond { exp_cond_condition = t;
             exp_cond_then_arm = e1;
             exp_cond_else_arm = e2;
             exp_cond_path_id = None ;
             exp_cond_pos = get_pos_camlp4 _loc 2 }*)]];

conditional_or_expression:
  [[ t=conditional_and_expression -> t
   | t1=SELF; `OROR; t2=conditional_and_expression -> mkBinary OpLogicalOr t1 t2 (get_pos_camlp4 _loc 2)]];
	
conditional_and_expression:
  [[ t=inclusive_or_expression -> t
   | t1=SELF; `ANDAND; t2=inclusive_or_expression -> mkBinary OpLogicalAnd t1 t2 (get_pos_camlp4 _loc 2)]];

(* bitwise *)
inclusive_or_expression : [[ t=exclusive_or_expression -> t]];

exclusive_or_expression : [[ t=and_expression -> t]];

and_expression : [[t=equality_expression -> t]];

equality_expression : 
 [[ t=relational_expression -> t
  | t1=SELF; `EQEQ; t2=relational_expression -> mkBinary OpEq t1 t2 (get_pos_camlp4 _loc 2)
  | t1=SELF; `NEQ; t2=relational_expression -> mkBinary OpNeq t1 t2 (get_pos_camlp4 _loc 2)]];

relational_expression :
 [[ t=shift_expression                 -> t
  | t1=SELF; `LT; t2=shift_expression  -> mkBinary OpLt t1 t2 (get_pos_camlp4 _loc 2)
  | t1=SELF; `GT; t2=shift_expression  -> mkBinary OpGt t1 t2 (get_pos_camlp4 _loc 2)
  | t1=SELF; `LTE; t2=shift_expression -> mkBinary OpLte t1 t2 (get_pos_camlp4 _loc 2)
  | t1=SELF; `GTE; t2=shift_expression -> mkBinary OpGte t1 t2 (get_pos_camlp4 _loc 2)]];

shift_expression: [[t=additive_expression -> t]];

additive_expression: 
 [[ t=multiplicative_expression                   -> t
  | t1=SELF; `PLUS; t2=multiplicative_expression  -> mkBinary OpPlus t1 t2 (get_pos_camlp4 _loc 2)
	| t1=SELF; `MINUS; t2=multiplicative_expression -> mkBinary OpMinus t1 t2 (get_pos_camlp4 _loc 2)]];

multiplicative_expression:
 [[ t=unary_expression                            -> t 
  | t1=SELF; `STAR; t2=prefixed_unary_expression  -> mkBinary OpMult t1 t2 (get_pos_camlp4 _loc 2)
	| t1=SELF; `DIV;  t2=prefixed_unary_expression  -> mkBinary OpDiv t1 t2 (get_pos_camlp4 _loc 2)
	| t1=SELF; `PERCENT; t2=prefixed_unary_expression -> mkBinary OpMod t1 t2 (get_pos_camlp4 _loc 2)]];

prefixed_unary_expression: [[ t=unary_expression -> t]];

pre_increment_expression: [[`OP_INC; t=prefixed_unary_expression -> mkUnary OpPreInc t (get_pos_camlp4 _loc 1)]];

pre_decrement_expression: [[`OP_DEC; t=prefixed_unary_expression -> mkUnary OpPreDec t (get_pos_camlp4 _loc 1)]];

post_increment_expression: [[peek_try_st_in; t=primary_expression; `OP_INC -> mkUnary OpPostInc t (get_pos_camlp4 _loc 2)]];

post_decrement_expression: [[ peek_try_st; t=primary_expression; `OP_DEC -> mkUnary OpPostDec t (get_pos_camlp4 _loc 2)]];

unary_expression: 
 [[ t=unary_expression_not_plusminus -> t
  | `PLUS; t=SELF ->
		let zero = IntLit { exp_int_lit_val = 0;
                        exp_int_lit_pos = get_pos_camlp4 _loc 1 }in
		  mkBinary OpPlus zero t (get_pos_camlp4 _loc 1)
  | `MINUS; t=SELF ->
		let zero = IntLit { exp_int_lit_val = 0;
                        exp_int_lit_pos = get_pos_camlp4 _loc 1 }	in
		  mkBinary OpMinus zero t (get_pos_camlp4 _loc 1)
  | t=pre_increment_expression -> t
  | t=pre_decrement_expression -> t]];

unary_expression_not_plusminus:
 [[ t=postfix_expression -> t
  | `NOT; t = prefixed_unary_expression -> mkUnary OpNot t (get_pos_camlp4 _loc 1)
  | t=cast_expression -> t]];

postfix_expression: 
 [[ t=primary_expression -> t
  | t=post_increment_expression -> t
  | t=post_decrement_expression -> t]];

cast_expression:
 [[ `OPAREN; e=expression; `CPAREN; ue=unary_expression_not_plusminus ->
	  (match e with
		| Var v -> Cast { exp_cast_target_type = Named v.exp_var_name; (*TODO: fix this *)
                      exp_cast_body = ue;
                      exp_cast_pos = get_pos_camlp4 _loc 1 }
		| _ -> report_error (get_pos_camlp4 _loc 2) ("Expecting a type"))
  | `OPAREN; `INT; `CPAREN; t=unary_expression ->
      Cast { exp_cast_target_type = Int;
             exp_cast_body = t;
             exp_cast_pos = get_pos_camlp4 _loc 1 }
  | `OPAREN; `BOOL; `CPAREN; t=unary_expression ->
      Cast { exp_cast_target_type = Bool;
             exp_cast_body = t;
             exp_cast_pos = get_pos_camlp4 _loc 1 }
  | `OPAREN; `FLOAT; `CPAREN; t=unary_expression ->
      Cast { exp_cast_target_type = Float;
             exp_cast_body = t;
             exp_cast_pos = get_pos_camlp4 _loc 1 }]];

invocation_expression:
 [[ peek_invocation; qi=qualified_identifier; `OPAREN; oal=opt_argument_list; `CPAREN ->
	  CallRecv { exp_call_recv_receiver = fst qi;
               exp_call_recv_method = snd qi;
               exp_call_recv_arguments = oal;
               exp_call_recv_path_id = None;
               exp_call_recv_pos = get_pos_camlp4 _loc 1 }
  | `IDENTIFIER id; `OPAREN; oal=opt_argument_list; `CPAREN ->
    CallNRecv { exp_call_nrecv_method = id;
                exp_call_nrecv_arguments = oal;
                exp_call_nrecv_path_id = None;
                exp_call_nrecv_pos = get_pos_camlp4 _loc 1 }]];

qualified_identifier: [[peek_try_st_qi; t=primary_expression; `DOT; `IDENTIFIER id -> (t, id)]];

(* member_access: [[peek_try_st; t=primary_expression; `DOT; `IDENTIFIER id -> *)
(* 	Member { exp_member_base = t; *)
(*            exp_member_fields = [id]; *)
(*            exp_member_path_id = None ; *)
(*            exp_member_pos = get_pos_camlp4 _loc 3 }] *)
(* 		   | [ `IDENTIFIER id ->   Var { exp_var_name = id; exp_var_pos = get_pos_camlp4 _loc 1 } *)
(* 			| `THIS _ -> This{exp_this_pos = get_pos_camlp4 _loc 1}] *)
(* 		   ]; *)

literal:
 [[ t=boolean_literal -> BoolLit { exp_bool_lit_val = t; exp_bool_lit_pos = get_pos_camlp4 _loc 1 }
  | t=integer_literal -> IntLit { exp_int_lit_val = t;exp_int_lit_pos = get_pos_camlp4 _loc 1 }
  | t=real_literal -> FloatLit { exp_float_lit_val = t; exp_float_lit_pos = get_pos_camlp4 _loc 1 }
  | `NULL -> Null (get_pos_camlp4 _loc 1) ]];

real_literal:[[ `FLOAT_LIT (t,_) -> t]];

integer_literal: [[`INT_LITER (t,_) -> t]];

boolean_literal : 
  [[ `TRUE -> true
   | `FALSE-> false]];

primary_expression :
 [[ t=parenthesized_expression -> t
  | t=primary_expression_no_parenthesis -> t]];

parenthesized_expression : [[`OPAREN; e= expression; `CPAREN -> e]];

primary_expression_no_parenthesis :
	[[ peek_array_type; t = arrayaccess_expression -> t
	|  t = primary_expression_no_array_no_parenthesis -> t ]];

primary_expression_no_array_no_parenthesis :
 [[ t= literal -> t
  (*| t= member_access -> t*)
  (*| t= member_name -> t*) 
  | t=SELF; `DOT; `IDENTIFIER id ->
	Member { exp_member_base = t;
           exp_member_fields = [id];
           exp_member_path_id = None ;
           exp_member_pos = get_pos_camlp4 _loc 3 }
  | t = invocation_expression -> t
  | t = new_expression -> t
  | `THIS _ -> This{exp_this_pos = get_pos_camlp4 _loc 1} 
  ]
  | [`IDENTIFIER id -> (* print_string ("Variable Id : "^id^"\n"); *)
		let pos = get_pos_camlp4 _loc 1 in
		let res = if (String.contains id '.') then (* Identifier contains "." ==> this must be field access. *)
				let flds = Str.split (Str.regexp "\\.") id in
				(* let _ = print_endline "Member field access" in *)
					Member {
						exp_member_base = Var { exp_var_name = List.hd flds;
												exp_var_pos = pos };
						exp_member_fields = List.tl flds; (* TODO merge the field access to match the core representation! *)
						exp_member_path_id = None;
						exp_member_pos = pos } 
			else (* let _ = print_endline "Simple variable" in *)
				Var { exp_var_name = id; exp_var_pos = pos } in
		(* let _ = print_endline ("Parsed expression at " ^ (string_of_loc pos) ^ ": { " ^ (Iprinter.string_of_exp res) ^ " }") in *)
			res
]];

(* An Hoa : array access expression *)
arrayaccess_expression:[[
             id=primary_expression_no_array_no_parenthesis; `OSQUARE; ex = LIST1 expression SEP `COMMA; `CSQUARE ->
			ArrayAt { 
				exp_arrayat_array_base = id; 
				exp_arrayat_index = ex; 
				exp_arrayat_pos = get_pos_camlp4 _loc 1 }
	         ]];
(* member_name : *)
(*  [[ `IDENTIFIER id ->   Var { exp_var_name = id; exp_var_pos = get_pos_camlp4 _loc 1 } *)
(*   | `THIS _ -> This{exp_this_pos = get_pos_camlp4 _loc 1}]]; *)
 
(*end of hip part*)
END;;

let parse_sleek n s = SHGram.parse sprog (PreCast.Loc.mk n) s
(* let parse_sleek n s =  *)
(*   Gen.Debug.loop_1_no "parse_sleek" (fun x -> x) (fun _ -> "?") (fun n -> parse_sleek n s) n *)
let parse_hip n s =  SHGram.parse hprog (PreCast.Loc.mk n) s
(* let parse_hip n s =   *)
(*   Gen.Debug.loop_1_no "parse_hip" (fun x -> x) (fun _ -> "?") (fun n -> parse_hip n s) n *)
let parse_sleek_int n s = SHGram.parse_string sprog_int (PreCast.Loc.mk n) s
let parse_hip_string n s = SHGram.parse_string hprog (PreCast.Loc.mk n) s
(* let parse_hip_string n s = 
  let pr x = x in
  let pr_no x = "?" in Gen.Debug.no_2 "parse_hip_string" pr pr pr_no parse_hip_string n s *)

 
