(*
  Created 19-Feb-2006

  Input AST
*)

open Globals

module F = Iformula
module P = Ipure
module Err = Error
module CP = Cpure

type typ =
  | Prim of prim_type
  | Named of ident (* named type, could be enumerated or object *)
  | Array of (typ * int option) (* base type and optional dimension *)
	  
and typed_ident = (typ * ident)


type prog_decl = { mutable prog_data_decls : data_decl list;
                   prog_global_var_decls : exp_var_decl list;
                   prog_enum_decls : enum_decl list;
                   mutable prog_view_decls : view_decl list;
                   mutable prog_rel_decls : rel_decl list; 
                   (* An Hoa: relational declaration *)
                   prog_proc_decls : proc_decl list;
                   mutable prog_coercion_decls : coercion_decl list }

and data_decl = { data_name : ident;
		  data_fields : (typed_ident * loc) list;
		  data_parent_name : ident;
		  data_invs : F.formula list;
		  data_methods : proc_decl list }

(*
  and global_var_decl = { global_var_decl_type : typ;
  global_var_decl_decls : (ident * exp option * loc) list;
  global_var_decl_pos : loc }
*)

and view_decl = { view_name : ident; 
		  mutable view_data_name : ident;
		  view_vars : ident list;
		  view_labels : branch_label list;
		  view_modes : mode list;
		  mutable view_typed_vars : (CP.typ * ident) list;
		  view_invariant : (P.formula * (branch_label * P.formula) list);
		  view_formula : Iformula.struc_formula;
		  try_case_inference: bool}

(* An Hoa: relational declaration, nearly identical to view_decl except for the view_data_name *)
and rel_decl = { rel_name : ident; 
		  (* rel_vars : ident list; *)
		  (* rel_labels : branch_label list; *)
			rel_typed_vars : (typ * ident) list;
		  (* rel_invariant : (P.formula * (branch_label * P.formula) list); *)
		  rel_formula : P.formula (* Iformula.struc_formula *) ; 
		  (* try_case_inference: bool *)}

and enum_decl = { enum_name : ident;
		  enum_fields : (ident * int option) list } 
    (* a field of an enum may optionally be initialized by an integer *)

and param_modifier =
  | NoMod
  | RefMod
      
      
and jump_label_type =
  | NoJumpLabel 
  | JumpLabel of ident
      
and rise_type = 
  | Const_flow of constant_flow
  | Var_flow of ident

and param = { param_type : typ;
	      param_name : ident;
	      param_mod : param_modifier;
	      param_loc : loc }

(*
  and multi_spec = spec list

  and spec = 
  | SCase of scase_spec
  | SRequires of srequires_spec
  | SEnsure of sensures_spec
  
  and scase_spec = 
  {
  scase_branches : (Ipure.formula * multi_spec ) list ;
  scase_pos : loc 
  }
  
  and srequires_spec = 
  {		
  srequires_explicit_inst : (ident * primed) list;
  srequires_implicit_inst : (ident * primed) list;
  srequires_base : Iformula.formula;
  srequires_continuation : multi_spec;
  srequires_pos : loc
  }	
  
  and sensures_spec = 
  {
  sensures_base : Iformula.formula;
  sensures_pos : loc
  }
*)

and proc_decl = { proc_name : ident;
				  mutable proc_mingled_name : ident;
				  mutable proc_data_decl : data_decl option; (* the class containing the method *)
				  proc_constructor : bool;
				  proc_args : param list;
				  proc_return : typ;
				  proc_static_specs : Iformula.struc_formula;
				  proc_dynamic_specs : Iformula.struc_formula;
				  proc_exceptions : ident list;
				  proc_body : exp option;
          proc_file : string;
				  proc_loc : loc }

and coercion_decl = { coercion_type : coercion_type;
		      coercion_name : ident;
		      coercion_head : F.formula;
		      coercion_body : F.formula;
		      coercion_proof : exp }
and coercion_type = 
  | Left
  | Equiv
  | Right

and uni_op = 
  | OpUMinus
  | OpPreInc
  | OpPreDec
  | OpPostInc
  | OpPostDec
  | OpNot

and bin_op = 
  | OpPlus
  | OpMinus
  | OpMult
  | OpDiv
  | OpMod
  | OpEq
  | OpNeq
  | OpLt
  | OpLte
  | OpGt
  | OpGte
  | OpLogicalAnd
  | OpLogicalOr
  | OpIsNull
  | OpIsNotNull

and assign_op =
  | OpAssign
  | OpPlusAssign
  | OpMinusAssign
  | OpMultAssign
  | OpDivAssign
  | OpModAssign

(* An Hoa : v[i] where v is an identifier and i is an expression *)
and exp_arrayat = { exp_arrayat_array_name : ident;
	     exp_arrayat_index : exp;
			 exp_arrayat_pos : loc; }

(* An Hoa : array memory allocation expression *)
and exp_aalloc = { exp_aalloc_etype_name : ident; (* Name of the base element *)
	     exp_aalloc_dimensions : exp list; (* List of size for each dimensions *)
			 exp_aalloc_pos : loc; }

and exp_assert = { exp_assert_asserted_formula : (F.struc_formula*bool) option;
		   exp_assert_assumed_formula : F.formula option;
		   exp_assert_path_id : formula_label;
		   exp_assert_pos : loc }

and exp_assign = { exp_assign_op : assign_op;
		   exp_assign_lhs : exp;
		   exp_assign_rhs : exp;
		   exp_assign_path_id : control_path_id;
		   exp_assign_pos : loc }

and exp_binary = { exp_binary_op : bin_op;
		   exp_binary_oper1 : exp;
		   exp_binary_oper2 : exp;
		   exp_binary_path_id : control_path_id;
		   exp_binary_pos : loc }

and exp_bind = { exp_bind_bound_var : ident;
		 exp_bind_fields : ident list;
		 exp_bind_body : exp;
		 exp_bind_path_id : control_path_id;
		 exp_bind_pos : loc }
    
and exp_break = { exp_break_jump_label : jump_label_type;
		  exp_break_path_id : control_path_id;
		  exp_break_pos : loc }	

and exp_block = { exp_block_body : exp;
		  exp_block_jump_label : jump_label_type;
		  exp_block_local_vars: (ident*typ*loc) list;
		  exp_block_pos : loc }

and exp_bool_lit = { exp_bool_lit_val : bool;
		     exp_bool_lit_pos : loc }

and exp_call_nrecv = { exp_call_nrecv_method : ident;
		       exp_call_nrecv_arguments : exp list;
		       exp_call_nrecv_path_id : control_path_id;
		       exp_call_nrecv_pos : loc }

and exp_call_recv = { exp_call_recv_receiver : exp;
		      exp_call_recv_method : ident;
		      exp_call_recv_arguments : exp list;
		      exp_call_recv_path_id : control_path_id;
		      exp_call_recv_pos : loc }

and exp_catch = { exp_catch_var : ident option ;
		  exp_catch_flow_type : constant_flow;
		  exp_catch_flow_var : ident option;
		  exp_catch_body : exp;											   
		  exp_catch_pos : loc }
    
and exp_cast = { exp_cast_target_type : typ;
		 exp_cast_body : exp;
		 exp_cast_pos : loc }

and exp_cond = { exp_cond_condition : exp;
		 exp_cond_then_arm : exp;
		 exp_cond_else_arm : exp;
		 exp_cond_path_id : control_path_id;
		 exp_cond_pos : loc }

and exp_const_decl = { exp_const_decl_type : typ;
		       exp_const_decl_decls : (ident * exp * loc) list;
		       exp_const_decl_pos : loc }

and exp_continue = { exp_continue_jump_label : jump_label_type;
		     exp_continue_path_id : control_path_id;
		     exp_continue_pos : loc }
    
and exp_debug = { exp_debug_flag : bool;
		  exp_debug_pos : loc }

and exp_finally = { exp_finally_body : exp;
		    exp_finally_pos : loc }

and exp_float_lit = { exp_float_lit_val : float;
		      exp_float_lit_pos : loc }

and exp_int_lit = { exp_int_lit_val : int;
		    exp_int_lit_pos : loc }

and exp_java = { exp_java_code : string;
		 exp_java_pos : loc }

and exp_member = { exp_member_base : exp;
		   exp_member_fields : ident list;
		   exp_member_path_id : control_path_id;
		   exp_member_pos : loc }

and exp_new = { exp_new_class_name : ident;
		exp_new_arguments : exp list;
		exp_new_pos : loc }

and exp_raise = { exp_raise_type : rise_type;
		  exp_raise_val : exp option;
		  exp_raise_from_final :bool; (*if so the result can have any type...*)
		  exp_raise_path_id : control_path_id;
		  exp_raise_pos : loc }
    
and exp_return = { exp_return_val : exp option;
		   exp_return_path_id : control_path_id;
		   exp_return_pos : loc }

and exp_seq = { exp_seq_exp1 : exp;
		exp_seq_exp2 : exp;
		exp_seq_pos : loc }

and exp_this = { exp_this_pos : loc }

and exp_try = { exp_try_block : exp;
		exp_catch_clauses : exp list;
		exp_finally_clause : exp list;
		exp_try_path_id : control_path_id;
		exp_try_pos : loc}

(*and exp_throw = { exp_throw_type : ident;
  exp_throw_pos : loc }
*)
and exp_unary = { exp_unary_op : uni_op;
		  exp_unary_exp : exp;
		  exp_unary_path_id : control_path_id;
		  exp_unary_pos : loc }

and exp_var = { exp_var_name : ident;
		exp_var_pos : loc }

and exp_var_decl = { exp_var_decl_type : typ;
                     exp_var_decl_decls : (ident * exp option * loc) list;
                     exp_var_decl_pos : loc }

and exp_while = { exp_while_condition : exp;
		  exp_while_body : exp;
		  exp_while_specs : Iformula.struc_formula (*multi_spec*);
		  exp_while_jump_label : jump_label_type;
		  exp_while_path_id : control_path_id;
		  exp_while_f_name: ident;
		  exp_while_wrappings: exp option;
		  (*used temporary to store the break wrappers, these wrappers are catch clauses which will
		    wrap the method so that it catches and converts the break flows with target jump_label_type*)
		  exp_while_pos : loc }

and exp_dprint = { exp_dprint_string : string;
		   exp_dprint_pos : loc }

and exp_unfold = { exp_unfold_var : (string * primed);
		   exp_unfold_pos : loc } 

and exp =
	| ArrayAt of exp_arrayat (* An Hoa *)
	| ArrayAlloc of exp_aalloc (* An Hoa *)
  | Assert of exp_assert
  | Assign of exp_assign
  | Binary of exp_binary
  | Bind of exp_bind
  | Block of exp_block
  | BoolLit of exp_bool_lit
  | Break of exp_break
  | CallRecv of exp_call_recv
  | CallNRecv of exp_call_nrecv
  | Cast of exp_cast
  | Cond of exp_cond
  | ConstDecl of exp_const_decl
  | Continue of exp_continue
  | Catch of exp_catch
  | Debug of exp_debug
  | Dprint of exp_dprint
  | Empty of loc
  | FloatLit of exp_float_lit
  | Finally of exp_finally
  | IntLit of exp_int_lit
  | Java of exp_java
  | Label of ((control_path_id * path_label) * exp)
  | Member of exp_member
  | New of exp_new
  | Null of loc
  | Raise of exp_raise 
  | Return of exp_return
  | Seq of exp_seq
  | This of exp_this
  | Time of (bool*string*loc)
  | Try of exp_try
  | Unary of exp_unary
  | Unfold of exp_unfold
  | Var of exp_var
  | VarDecl of exp_var_decl
  | While of exp_while
  
(* type constants *)

let void_type = Prim Void

let int_type = Prim Int

let float_type = Prim Float

let bool_type = Prim Bool

(* utility functions *)

(* apply substitution to an id *)
let apply_subs_to_id (subs:(ident *ident) list) (id:ident) : ident
 = try       
     List.assoc id subs
   with 
     Not_found -> id

(* apply substitution to exp_var *)
let apply_subs_to_exp_var (subs:(ident *ident) list) (ev:exp_var) : exp_var
 = { ev with  exp_var_name = apply_subs_to_id subs ev.exp_var_name; }

(* apply substitution to list of id *)
let apply_subs_to_list_id (subs:(ident *ident) list) (lst:ident list) : ident list
 = List.map (apply_subs_to_id subs) lst


(* check if id is in domain of subs *)
let member_domain (id:ident) (subs:(ident * ident) list)  : bool
 = List.exists (fun (x,_) -> (String.compare id x)==0) subs


(* intersection of two lists of ids *)
let intersect (lst1:'a list) (lst2:'a list) : 'a list
  = List.filter (fun x -> List.mem x lst2) lst1


(* make new renaming substitution that avoids name clash *)
let new_renaming (lst:ident list) : (ident * ident) list
  = List.map (fun x -> (x,x^"_tmp" (* fresh name *))) lst

(* transform each proc by a map function *)
let map_proc (prog:prog_decl)
  (f_p : proc_decl -> proc_decl) : prog_decl =
  { prog with
      prog_proc_decls = List.map (f_p) prog.prog_proc_decls;
  }

(* process each proc into some data which are then combined,
   e.g. verify each method and collect the failure points
*)
let fold_proc (prog:prog_decl)
  (f_p : proc_decl -> 'b) (f_comb: 'b -> 'b -> 'b) (zero:'b) : 'b =
  List.fold_left (fun x p -> f_comb (f_p p) x) 
		zero prog.prog_proc_decls

(* iterate each proc to check for some property *)
let iter_proc (prog:prog_decl) (f_p : proc_decl -> unit) : unit =
  fold_proc prog (f_p) (fun _ _ -> ()) ()

let set_proc_data_decl (p : proc_decl) (d : data_decl) = p.proc_data_decl <- Some d

let name_of_type (t : typ) = match t with
  | Prim Int -> "int"
  | Prim Bool -> "bool"
  | Prim Void -> "void"
  | Prim Float -> "float"
  | Prim Bag -> "bag"
  | Prim List -> "list"
  | Named c -> c
  | Array _ -> "Array"

let are_same_type (t1 : typ) (t2 : typ) = t1 = t2 (*TODO: this function should be removed, use the one in Cast instead *)

let is_named_type (t : typ) = match t with
  | Named _ -> true
  | _ -> false

let is_null (e : exp) : bool = match e with
  | Null _ -> true
  | _ -> false


let is_var (e : exp) : bool = match e with
  | Var _ -> true
  | _ ->false
  
let rec get_exp_pos (e0 : exp) : loc = match e0 with
	| ArrayAt e -> e.exp_arrayat_pos (* An Hoa *)
  | Label (_,e) -> get_exp_pos e
  | Assert e -> e.exp_assert_pos
  | Assign e -> e.exp_assign_pos
  | Binary e -> e.exp_binary_pos
  | Bind e -> e.exp_bind_pos
  | Block e -> e.exp_block_pos
  | BoolLit e -> e.exp_bool_lit_pos
  | Break p -> p.exp_break_pos
  | CallRecv e -> e.exp_call_recv_pos
  | CallNRecv e -> e.exp_call_nrecv_pos
  | Cast e -> e.exp_cast_pos
  | Catch e -> e.exp_catch_pos
  | Cond e -> e.exp_cond_pos
  | ConstDecl e -> e.exp_const_decl_pos
  | Continue p -> p.exp_continue_pos
  | Debug e -> e.exp_debug_pos
  | Dprint e -> e.exp_dprint_pos
  | Empty p -> p
  | FloatLit e -> e.exp_float_lit_pos
  | Finally e -> e.exp_finally_pos
  | IntLit e -> e.exp_int_lit_pos
  | Java e -> e.exp_java_pos
  | Member e -> e.exp_member_pos
	| ArrayAlloc e -> e.exp_aalloc_pos (* An Hoa *)
  | New e -> e.exp_new_pos
  | Null p -> p
  | Return e -> e.exp_return_pos
  | Seq e -> e.exp_seq_pos
  | This e -> e.exp_this_pos
  | Unary e -> e.exp_unary_pos
  | Var e -> e.exp_var_pos
  | VarDecl e -> e.exp_var_decl_pos
  | While e -> e.exp_while_pos
  | Unfold e -> e.exp_unfold_pos
  | Try e -> e.exp_try_pos
  | Time (_,_,l) ->  l
  | Raise e -> e.exp_raise_pos
	  
	  
let get_catch_of_exp e = match e with
	| Catch e -> e
	| _  -> Error.report_error {Err.error_loc = get_exp_pos e; Err.error_text = "malformed expression, expecting catch clause"}

let get_finally_of_exp e = match e with
	| Finally e -> e
	| _  -> Error.report_error {Err.error_loc = get_exp_pos e; Err.error_text = "malformed expression, expecting finally clause"}
	(*
let rec type_of_exp e = match e with
  | Assert _ -> None
  | Assign _ -> Some void_type
  | Binary { 
      exp_binary_op = op;
      exp_binary_oper1 = e1;
      exp_binary_oper2 = e2;
      exp_binary_pos = _ 
    } ->
        begin
          let t1 = type_of_exp e1 in
          let t2 = type_of_exp e2 in
          let typ = match op with
            | OpEq | OpNeq | OpLt | OpLte | OpGt | OpGte
            | OpLogicalAnd | OpLogicalOr | OpIsNull | OpIsNotNull -> 
                bool_type
            | OpPlus | OpMinus | OpMult ->
                begin
                  match t1, t2 with
                  | Some Prim Int, Some Prim Int -> int_type 
                  | _ -> float_type
                end
            | OpDiv -> float_type
            | OpMod -> int_type
          in Some typ
        end
  | Bind {
      exp_bind_bound_var = _;
      exp_bind_fields = _;
      exp_bind_body = e1;
      exp_bind_pos = _
    } -> type_of_exp e1
  | Block _ -> Some void_type
  | BoolLit _ -> Some bool_type
  | Break _ -> Some void_type
  | CallRecv _ -> None (* FIX-IT *)
  | CallNRecv _ -> Some void_type
  | Cast {
      exp_cast_target_type = typ;
      exp_cast_body = _;
      exp_cast_pos = _
    } -> Some typ
  | Cond _ -> Some void_type
  | ConstDecl _ -> Some void_type
  | Continue _ -> Some void_type
  | Debug _ -> None
  | Dprint _ -> None
  | Empty _ -> None
  | FloatLit _ -> Some float_type
  | IntLit _ -> Some int_type
  | Java _ -> None
  | Member _ -> None (* FIX-IT *)
  | New {
      exp_new_class_name = name;
      exp_new_arguments = _;
      exp_new_pos = _
    } -> Some (Named name)
  | Null _ -> Some void_type
  | Raise _ -> Some void_type
  | Return _ -> Some void_type
  | Seq _ -> Some void_type
  | This _ -> None
  | Try _ -> Some void_type
  | Unary {
      exp_unary_op = op;
      exp_unary_exp = e1;
      exp_unary_pos = _
    } -> type_of_exp e1
  | Unfold _ -> None
  | Var _ -> None
  | VarDecl _ -> Some void_type
  | While _ -> Some void_type
*)

and mkSpecTrue pos = Iformula.mkETrue pos
	(*[SRequires {
		srequires_explicit_inst = [];
		srequires_implicit_inst = [];
		srequires_base  = Iformula.mkTrue pos;
		srequires_continuation =  [SEnsure{
			sensures_base =  Iformula.mkTrue pos;
			sensures_pos = pos
			}];
		srequires_pos = pos
		}]	*)
		
		

let trans_exp (e:exp) (init_arg:'b)(f:'b->exp->(exp* 'a) option)  (f_args:'b->exp->'b)(comb_f:exp -> 'a list -> 'a) :(exp * 'a) =
  let rec helper (in_arg:'b) (e:exp) :(exp* 'a) =	
    match (f in_arg e) with
	  | Some e1 -> e1
	  | None  ->   let n_arg = f_args in_arg e in 
        let comb_f = comb_f e in
        let zero = comb_f [] in  match e with	
          | Assert _ 
          | BoolLit _ 
          | Break _
          | Continue _ 
          | Debug _ 
          | Dprint _ 
          | Empty _ 
          | FloatLit _ 
          | IntLit _
          | Java _ 
          | Null _ 
          | This _ 
          | Time _ 
          | Unfold _ 
          | Var _ -> (e,zero)
					| ArrayAt b -> (* An Hoa *)
								let e1,r1 = helper n_arg b.exp_arrayat_index in
								(ArrayAt {b with exp_arrayat_index = e1},r1)
          | Assign b ->
                let e1,r1 = helper n_arg b.exp_assign_lhs  in
                let e2,r2 = helper n_arg b.exp_assign_rhs  in
                (Assign { b with exp_assign_lhs = e1; exp_assign_rhs = e2;},(comb_f [r1;r2]))
          | Binary b -> 
                let e1,r1 = helper n_arg b.exp_binary_oper1  in
                let e2,r2 = helper n_arg b.exp_binary_oper2  in
                (Binary {b with exp_binary_oper1 = e1; exp_binary_oper2 = e2;},(comb_f [r1;r2]))
          | Bind b -> 
                let e1,r1 = helper n_arg b.exp_bind_body  in     
                (Bind {b with exp_bind_body = e1; },r1)
          | Block b -> 
                let e1,r1 = helper n_arg b.exp_block_body  in     
                (Block {b with exp_block_body = e1;},r1)
          | CallRecv b -> 
                let e1,r1 = helper n_arg b.exp_call_recv_receiver  in     
                let ler = List.map (helper n_arg) b.exp_call_recv_arguments in    
                let e2l,r2l = List.split ler in
                let r = comb_f (r1::r2l) in
                (CallRecv {b with exp_call_recv_receiver = e1;exp_call_recv_arguments = e2l;},r)
          | CallNRecv b -> 
                let ler = List.map (helper n_arg) b.exp_call_nrecv_arguments in    
                let e2l,r2l = List.split ler in
                let r = comb_f r2l in
                (CallNRecv {b with exp_call_nrecv_arguments = e2l;},r)
          | Cast b -> 
                let e1,r1 = helper n_arg b.exp_cast_body  in  
                (Cast {b with exp_cast_body = e1},r1)
	      | Catch b -> 
		        let e1,r1 = helper n_arg b.exp_catch_body in
		        (Catch {b with exp_catch_body = e1},r1)
          | Cond b -> 
                let e1,r1 = helper n_arg b.exp_cond_condition in
                let e2,r2 = helper n_arg b.exp_cond_then_arm in
                let e3,r3 = helper n_arg b.exp_cond_else_arm in
                let r = comb_f [r1;r2;r3] in
                (Cond {b with
                    exp_cond_condition = e1;
                    exp_cond_then_arm = e2;
                    exp_cond_else_arm = e3;},r)
	      | Finally b ->
		        let e1,r1 = helper n_arg b.exp_finally_body in
		        (Finally {b with exp_finally_body=e1},r1)
          | Label (l,b) -> 
                let e1,r1 = helper n_arg b in
                (Label (l,e1),r1)
          | Member b -> 
                let e1,r1 = helper n_arg b.exp_member_base in
                (Member {b with exp_member_base = e1;},r1)
					(* An Hoa *)
					| ArrayAlloc b -> 
                let el,rl = List.split (List.map (helper n_arg) b.exp_aalloc_dimensions) in
                (ArrayAlloc {b with exp_aalloc_dimensions = el},(comb_f rl))
          | New b -> 
                let el,rl = List.split (List.map (helper n_arg) b.exp_new_arguments) in
                (New {b with exp_new_arguments = el},(comb_f rl))
          | Raise b -> (match b.exp_raise_val with
              | None -> (e,zero)
              | Some body -> 
                    let e1,r1 = helper n_arg body in
                    (Raise {b with exp_raise_val = Some e1},r1))
          | Return b->(match b.exp_return_val with
              | None -> (e,zero)
              | Some body -> 
                    let e1,r1 = helper n_arg body in
                    (Return {b with exp_return_val = Some e1},r1))
          | Seq b -> 
                let e1,r1 = helper n_arg  b.exp_seq_exp1 in 
                let e2,r2 = helper n_arg  b.exp_seq_exp2 in 
                let r = comb_f [r1;r2] in
                (Seq {b with exp_seq_exp1 = e1;exp_seq_exp2 = e2;},r)
          | Try b -> 
                let ecl = List.map (helper n_arg) b.exp_catch_clauses in
                let fcl = List.map (helper n_arg) b.exp_finally_clause in
                let tb,r1 = helper n_arg b.exp_try_block in
                let catc, rc = List.split ecl in
                let fin, rf = List.split fcl in
                let r = comb_f (r1::(rc@rf)) in
                (Try {b with
                    exp_try_block = tb;
                    exp_catch_clauses = catc;
                    exp_finally_clause = fin;},r)
          | Unary b -> 
                let e1,r1 = helper n_arg b.exp_unary_exp in
                (Unary {b with exp_unary_exp = e1},r1)
          | ConstDecl b -> 
                let l = List.map (fun (c1,c2,c3)-> 
                    let e1,r1 = helper n_arg c2 in
                    ((c1,e1,c3),r1))b.exp_const_decl_decls in
                let el,rl = List.split l in
                let r = comb_f rl in
                (ConstDecl {b with exp_const_decl_decls=el},r) 
          | VarDecl b -> 
                let ll = List.map (fun (c1,c2,c3)-> match c2 with
                  | None -> ((c1,None,c3),zero)
                  | Some s -> 
                        let e1,r1 = helper n_arg s in
                        ((c1,Some e1, c3),r1)) b.exp_var_decl_decls in 
                let dl,rl =List.split ll in
                let r = comb_f rl in
                (VarDecl {b with exp_var_decl_decls = dl},r)
          | While b -> 
                let wrp,r = match b.exp_while_wrappings with
                  | None -> (None,zero)
                  | Some s -> 
                        let wrp,r = helper n_arg s in
                        ((Some wrp),r) in
                let ce,cr = helper n_arg b.exp_while_condition in
                let be,br = helper n_arg b.exp_while_body in
                let r = comb_f [r;cr;br] in
                (While {b with
                    exp_while_condition = ce;
                    exp_while_body = be;
                    exp_while_wrappings = wrp},r) in
  helper init_arg e

let transform_exp (e:exp) (init_arg:'b)(f:'b->exp->(exp* 'a) option)  (f_args:'b->exp->'b)(comb_f:'a list -> 'a) (zero:'a) :(exp * 'a) =
  let f_c e lst = match lst with
    | [] -> zero
    | _ -> comb_f lst in
  trans_exp e init_arg f f_args f_c

  (*this maps an expression by passing an argument*)
let map_exp_args (e:exp) (arg:'a) (f:'a -> exp -> exp option) (f_args: 'a -> exp -> 'a) : exp =
  let f1 ac e = push_opt_void_pair (f ac e) in
  fst (transform_exp e arg f1 f_args voidf ())

  (*this maps an expression without passing an argument*)
let map_exp (e:exp) (f:exp->exp option) : exp = 
  (* fst (transform_exp e () (fun _ e -> push_opt_void_pair (f e)) idf2  voidf ()) *)
  map_exp_args e () (fun _ e -> f e) idf2 

  (*this computes a result from expression passing an argument*)
let fold_exp_args (e:exp) (init_a:'a) (f:'a -> exp-> 'b option) (f_args: 'a -> exp -> 'a) (comb_f: 'b list->'b) (zero:'b) : 'b =
  let f1 ac e = match (f ac e) with
    | Some r -> Some (e,r)
    | None ->  None in
  snd(transform_exp e init_a f1 f_args comb_f zero)
 
  (*this computes a result from expression without passing an argument*)
let fold_exp (e:exp) (f:exp-> 'b option) (comb_f: 'b list->'b) (zero:'b) : 'b =
  fold_exp_args e () (fun _ e-> f e) voidf2 comb_f zero

  (*this iterates over the expression and passing an argument*)
let iter_exp_args (e:exp) (init_arg:'a) (f:'a -> exp-> unit option) (f_args: 'a -> exp -> 'a) : unit =
  fold_exp_args  e init_arg f f_args voidf ()

  (*this iterates over the expression without passing an argument*)
let iter_exp (e:exp) (f:exp-> unit option)  : unit =  iter_exp_args e () (fun _ e-> f e) voidf2

  (*this computes a result from expression passing an argument with side-effects*)
let fold_exp_args_imp (e:exp)  (arg:'a) (imp:'c ref) (f:'a -> 'c ref -> exp-> 'b option)
  (f_args: 'a -> 'c ref -> exp -> 'a) (f_imp: 'c ref -> exp -> 'c ref) (f_comb:'b list->'b) (zero:'b) : 'b =
  let fn (arg,imp) e = match (f arg imp e) with
    | Some r -> Some (e,r)
    | None -> None in
  let fnargs (arg,imp) e = ((f_args arg imp e), (f_imp imp e)) in
  snd(transform_exp e (arg,imp) fn fnargs f_comb zero)

  (*this iterates over the expression and passing an argument*)
let iter_exp_args_imp e (arg:'a) (imp:'c ref) (f:'a -> 'c ref -> exp -> unit option)
  (f_args: 'a -> 'c ref -> exp -> 'a) (f_imp: 'c ref -> exp -> 'c ref) : unit =
  fold_exp_args_imp e arg imp f f_args f_imp voidf ()

(* look up functions *)

let rec look_up_data_def pos (defs : data_decl list) (name : ident) = match defs with
  | d :: rest -> if d.data_name = name then d else look_up_data_def pos rest name
  | [] -> Err.report_error {Err.error_loc = pos; Err.error_text = "no type declaration named " ^ name ^ " is found"}

and look_up_parent_name pos ddefs name =
  let ddef = look_up_data_def pos ddefs name in
  ddef.data_parent_name

and look_up_data_def_raw (defs : data_decl list) (name : ident) = match defs with
  | d :: rest -> if d.data_name = name then d else look_up_data_def_raw rest name
  | [] -> raise Not_found

and look_up_view_def_raw (defs : view_decl list) (name : ident) = match defs with
  | d :: rest -> if d.view_name = name then d else look_up_view_def_raw rest name
  | [] -> raise Not_found

(* An Hoa *)
and look_up_rel_def_raw (defs : rel_decl list) (name : ident) = match defs with
  | d :: rest -> if d.rel_name = name then d else look_up_rel_def_raw rest name
  | [] -> raise Not_found

and look_up_enum_def pos (defs : enum_decl list) (name : ident) = match defs with
  | d :: rest -> if d.enum_name = name then d else look_up_enum_def pos rest name
  | [] -> Err.report_error {Err.error_loc = pos; Err.error_text = "no enum declaration named " ^ name ^ " is found"}

and look_up_enum_def_raw (defs : enum_decl list) (name : ident) = match defs with
  | d :: rest -> if d.enum_name = name then d else look_up_enum_def_raw rest name
  | [] -> raise Not_found

and look_up_proc_def_raw (procs : proc_decl list) (name : string) = match procs with
  | p :: rest ->
        if p.proc_name = name then
		  p
        else
		  look_up_proc_def_raw rest name
  | [] -> raise Not_found
	    
and look_up_proc_def_mingled_name (procs : proc_decl list) (name : string) = match procs with
  | p :: rest ->
        if p.proc_mingled_name = name then
		  p
        else
		  look_up_proc_def_mingled_name rest name
  | [] -> raise Not_found

(*
(* takes a proc and returns the class where it is declared *)
  and look_up_proc_class_mingled_name (classes : class_decl list) (name : string) = match classes with
  | c :: rest ->
  if (List.exists (fun t -> t.proc_mingled_name =  name) c.class_methods) then c
  else (look_up_proc_class_mingled_name rest name)
  | []	-> raise Not_found    
*)

(* takes a class and returns the list of all the methods from that class or from any of the parent classes *)
and look_up_all_methods (prog : prog_decl) (c : data_decl) : proc_decl list = match c.data_parent_name with 
  | "Object" -> c.data_methods (* it does not have a superclass *)
  | _ ->  
        let cparent_decl = List.find (fun t -> (String.compare t.data_name c.data_parent_name) = 0) prog.prog_data_decls in
        c.data_methods @ (look_up_all_methods prog cparent_decl)  

and look_up_all_fields (prog : prog_decl) (c : data_decl) : (typed_ident * loc) list = 
  let current_fields = c.data_fields in
  if (String.compare c.data_name "Object") = 0 then
	[]
  else
    let parent = (look_up_data_def no_pos prog.prog_data_decls c.data_parent_name) in 
	current_fields @ (look_up_all_fields prog parent)

(*
  Find view_data_name. Look at each branch, find the data self points to.
  If there are conflicts, report as errors.
*)

and data_name_of_view (view_decls : view_decl list) (f0 : Iformula.struc_formula) : ident = 

  let handle_list_res  (e:string list): string = 
	let r = List.filter (fun c-> (String.length c)>0) e in
	if (List.length r == 0 ) then ""
	else
	  let h = List.hd r in
	  let tl = List.tl r in
	  if (List.for_all (fun c-> (String.compare c h)==0 ) tl) then (List.hd r)
	  else "" in
  
  let rec data_name_in_ext (f:Iformula.ext_formula):ident = match f with
	| Iformula.EAssume (b,_) -> data_name_of_view1 view_decls b
	| Iformula.ECase b-> handle_list_res (List.map (fun (c1,c2) -> data_name_of_view  view_decls c2) b.Iformula.formula_case_branches)
	| Iformula.EBase b-> handle_list_res ([(data_name_of_view1 view_decls b.Iformula.formula_ext_base)]@
		  [(data_name_of_view view_decls b.Iformula.formula_ext_continuation)])
	| Iformula.EVariance b -> ""
  in
  handle_list_res (List.map data_name_in_ext f0) 

and data_name_of_view1 (view_decls : view_decl list) (f0 : F.formula) : ident = 
  let rec get_name_from_heap (h0 : F.h_formula) : ident option = match h0 with
	| F.HeapNode h ->
		  let (v, p), c = h.F.h_formula_heap_node, h.F.h_formula_heap_name in
		  if v = self then
			(* if c is a view, use the view's data name recursively.
			   Otherwise (c is data) use c *)
			try
			  let vdef = look_up_view_def_raw view_decls c in
			  if String.length (vdef.view_data_name) > 0 then
				Some vdef.view_data_name
			  else
				Some (data_name_of_view view_decls vdef.view_formula)
			with
			  | Not_found -> Some c
		  else
			None
	| F.Star h ->
		  let h1, h2, pos = h.F.h_formula_star_h1, h.F.h_formula_star_h2, h.F.h_formula_star_pos in
		  let n1 = get_name_from_heap h1 in
		  let n2 = get_name_from_heap h2 in
		  if Gen.is_some n1 && Gen.is_some n2 then
			report_error pos ("multiple occurrences of self as heap nodes in one branch are not allowed")
		  else if Gen.is_some n1 then
			n1
		  else
			n2
	| _ -> None 
  and get_name (f0 : F.formula) = match f0 with
	| F.Or f ->
		  let f1, f2, pos = f.F.formula_or_f1, f.F.formula_or_f2, f.F.formula_or_pos in
		  let n1 = get_name f1 in
		  let n2 = get_name f2 in
		  if Gen.is_some n1 && Gen.is_some n2 then
			let nn1 = Gen.unsome n1 in
			let nn2 = Gen.unsome n2 in
			if nn1 = nn2 then
			  Some nn1
			else
			  report_error pos ("two branches define self with different node types")
		  else if Gen.is_some n1 then
			n1
		  else
			n2
	| F.Base f ->
		  let h, p, pos = f.F.formula_base_heap, f.F.formula_base_pure, f.F.formula_base_pos in
		  get_name_from_heap h
	| F.Exists f ->
		  let h, p, pos = f.F.formula_exists_heap, f.F.formula_exists_pure, f.F.formula_exists_pos in
		  get_name_from_heap h
  in
  let data_name = match get_name f0 with
	| Some nn -> nn
	| None -> ""
  in
  data_name

and contains_field_ho (e:exp) : bool =
  let helper e = match e with | Member _ -> Some true | _ -> None in
  fold_exp e (helper) (List.exists (fun b -> b)) false
(*
and contains_field2 (e0 : exp) : bool = match e0 with
  | Assert _ -> false
  | Assign _ -> false
  | Binary e -> (contains_field2 e.exp_binary_oper1) || (contains_field2 e.exp_binary_oper2)
  | Bind e -> contains_field2 e.exp_bind_body
  | Block e -> contains_field2 e.exp_block_body
  | BoolLit _ -> false
  | Break _ -> false
  | CallRecv e -> 
	    contains_field2 e.exp_call_recv_receiver 
	    || (List.exists contains_field2 e.exp_call_recv_arguments)
  | CallNRecv e -> List.exists contains_field2 e.exp_call_nrecv_arguments
  | Cast e -> contains_field2 e.exp_cast_body
  | Catch e -> contains_field2 e.exp_catch_body
  | Cond e ->
	    let e1 = e.exp_cond_condition in
	    let e2 = e.exp_cond_then_arm in
	    let e3 = e.exp_cond_else_arm in
		(contains_field2 e1) || (contains_field2 e2) || (contains_field2 e3)
  | ConstDecl _ -> false
  | Continue _ -> false
  | Debug _ -> false
  | Dprint _ -> false
  | Empty _ -> false
  | FloatLit _ -> false
  | Finally e -> contains_field2 e.exp_finally_body
  | IntLit _ -> false
  | Java _ -> false
  | Label (_,e)-> contains_field2 e
  | Member _ -> true
  | New e -> List.exists contains_field2 e.exp_new_arguments
  | Null _ -> false
  | Return e -> 
	    let ret_val = e.exp_return_val in
		if Gen.is_some ret_val then contains_field2 (Gen.unsome ret_val) else false
  | Seq e -> (contains_field2 e.exp_seq_exp1) || (contains_field2 e.exp_seq_exp2)
  | This e -> false
  | Unary e -> contains_field2 e.exp_unary_exp
  | Var _ -> false
  | VarDecl _ -> false (* this can't happen on RHS anyway *)
  | While e -> (contains_field2 e.exp_while_condition) || (contains_field2 e.exp_while_body)
  | Unfold _ -> false
  | Raise e -> begin match e.exp_raise_val with | None -> false | Some e -> contains_field2 e end
  | Try e -> (contains_field2 e.exp_try_block) ||
		(List.exists contains_field2 e.exp_catch_clauses)||
			(List.exists contains_field2 e.exp_finally_clause)
  | Time _ -> false
*)
 
(* smart constructors *)

let mkConstDecl t d p = ConstDecl { exp_const_decl_type = t;
									exp_const_decl_decls = d;
									exp_const_decl_pos = p }

and mkVarDecl t d p = VarDecl { exp_var_decl_type = t;
								exp_var_decl_decls = d;
								exp_var_decl_pos = p }

and mkGlobalVarDecl t d p = { exp_var_decl_type = t;
							  exp_var_decl_decls = d;
							  exp_var_decl_pos = p }

and mkSeq e1 e2 l = match e1 with
  | Empty _ -> e2
  | _ -> match e2 with
	  | Empty _ -> e1
	  | _ -> Seq { exp_seq_exp1 = e1;
				   exp_seq_exp2 = e2;
				   exp_seq_pos = l }

and mkAssign op lhs rhs pos = 	Assign { exp_assign_op = op;
										 exp_assign_lhs = lhs;
										 exp_assign_rhs = rhs;
										 exp_assign_path_id = (fresh_branch_point_id "") ;
										 exp_assign_pos = pos }

and mkBinary op oper1 oper2 pos = Binary { exp_binary_op = op;
										   exp_binary_oper1 = oper1;
										   exp_binary_oper2 = oper2;
										   exp_binary_path_id = (fresh_branch_point_id "") ;
										   exp_binary_pos = pos }

and mkUnary op oper pos = Unary { exp_unary_op = op;
								  exp_unary_exp = oper;
								  exp_unary_path_id = (fresh_branch_point_id "") ;
								  exp_unary_pos = pos }

(*************************************************************)
(* Building the graph representing the class hierarchy       *)
(*************************************************************)

type ch_node = { ch_node_name : ident
				   (* mutable ch_node_class : data_decl option *) }
	
module CD = struct
  type t = ch_node
  let compare c1 c2 = compare c1.ch_node_name c2.ch_node_name
  let hash c = Hashtbl.hash c.ch_node_name
  let equal c1 c2 = (c1.ch_node_name = c2.ch_node_name)
end

module CH = Graph.Imperative.Digraph.Concrete(CD)
module TraverseCH = Graph.Traverse.Dfs(CH)

module W = struct
  type label = CH.E.label
  type t = int
  let weight x = 1
  let zero = 0
  let add = (+)
  let compare = compare
end

module PathCH = Graph.Path.Dijkstra(CH)(W)

let class_hierarchy = CH.create ()

let build_hierarchy (prog : prog_decl) =
  (* build the class hierarchy *)
  let add_edge (cdef : data_decl) = 
	CH.add_edge class_hierarchy (CH.V.create {ch_node_name = cdef.data_name})
	  (CH.V.create {ch_node_name = cdef.data_parent_name}) in
  let _ = List.map add_edge prog.prog_data_decls in
	if TraverseCH.has_cycle class_hierarchy then begin
	  print_string ("Error: Class hierarchy has cycles\n");
	  failwith ("Class hierarchy has cycles\n");
	end (* else begin
	  (* now add class definitions in *)
		   let update_node node = 
		   let cdef = look_up_data_def no_pos prog.prog_data_decls node.ch_node_name in
		   node.ch_node_class <- Some cdef
		   in
		   CH.iter_vertex update_node class_hierarchy
		   end
		*)

(*
  see if c1 is sub class of c2 and what are the classes in between.
*)
let find_classes (c1 : ident) (c2 : ident) : ident list = 
  let v1 = CH.V.create {ch_node_name = c1} in
  let v2 = CH.V.create {ch_node_name = c2} in
  let path, _ = PathCH.shortest_path class_hierarchy v1 v2 in
	List.map (fun e -> (CH.E.dst e).ch_node_name) path

let sub_type (t1 : typ) (t2 : typ) = 
  let c1 = name_of_type t1 in
  let c2 = name_of_type t2 in
	if c1 = c2 || (is_named_type t2 && c1 = "") then true
	else false
	  (*
		try
		let _ = find_classes c1 c2 in
		true
		with
		| Not_found -> false
	  *)

let compatible_types (t1 : typ) (t2 : typ) = sub_type t1 t2 || sub_type t2 t1

let build_exc_hierarchy (clean:bool)(prog : prog_decl) =
  (* build the class hierarchy *)
    
  let _ = (Gen.ExcNumbering.add_edge c_flow top_flow) in
  let _ = (Gen.ExcNumbering.add_edge "__abort" top_flow) in
  let _ = (Gen.ExcNumbering.add_edge n_flow c_flow) in
  let _ = (Gen.ExcNumbering.add_edge abnormal_flow c_flow) in
  let _ = (Gen.ExcNumbering.add_edge raisable_class abnormal_flow) in
  let _ = (Gen.ExcNumbering.add_edge "__others" abnormal_flow) in
  let _ = (Gen.ExcNumbering.add_edge ret_flow "__others") in
  let _ = (Gen.ExcNumbering.add_edge cont_top "__others") in
  let _ = (Gen.ExcNumbering.add_edge brk_top "__others") in
  let _ = (Gen.ExcNumbering.add_edge spec_flow "__others") in
  let _ = List.map (fun c-> (Gen.ExcNumbering.add_edge c.data_name c.data_parent_name)) prog.prog_data_decls in
  let _ = if clean then (Gen.ExcNumbering.clean_duplicates ()) in
	if (Gen.ExcNumbering.has_cycles ()) then begin
	  print_string ("Error: Exception hierarchy has cycles\n");
	  failwith ("Exception hierarchy has cycles\n");
	end 

let rec label_e e =
  let rec helper e = match e with
    | Catch e -> Error.report_error   {Err.error_loc = e.exp_catch_pos; Err.error_text = "unexpected catch clause"}  
    | Block _
		| ArrayAt _ (* AN HOA : no label for array access *)
    | Cast _
    | ConstDecl _ 
    | BoolLit _ 
    | Debug _ 
    | Dprint _ 
    | Empty _ 
    | FloatLit _ 
    | IntLit _
    | Java _ 
    | Unfold _ 
    | Var _ 
    | This _ 
    | Time _
    | Null _ 
    | VarDecl _
    | Seq _
		| ArrayAlloc _ (* An Hoa *)
    | New _ 
    | Finally _ 
    | Label _ -> None
    | _ -> Some (helper2 e)
  and helper2 e = match e with
    | Assert e -> 
		  let nl = fresh_formula_label (snd e.exp_assert_path_id) in
		  iast_label_table:= (Some nl,"assert",[],e.exp_assert_pos) ::!iast_label_table;
		  Assert {e with exp_assert_path_id = nl }
    | Assign e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"assign",[],e.exp_assign_pos) ::!iast_label_table;
		  Assign {e with 
			  exp_assign_lhs = label_e e.exp_assign_lhs;
			  exp_assign_rhs = label_e e.exp_assign_rhs;
			  exp_assign_path_id = nl;}
    | Binary e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"binary",[],e.exp_binary_pos) ::!iast_label_table;
		  Binary{e with
			  exp_binary_oper1 = label_e e.exp_binary_oper1;
			  exp_binary_oper2 = label_e e.exp_binary_oper2;
			  exp_binary_path_id = nl;}
    | Bind e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"bind",[],e.exp_bind_pos) ::!iast_label_table;
		  Bind {e with
 			  exp_bind_body = label_e e.exp_bind_body;
			  exp_bind_path_id  = nl;}
    | Break e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"break",[],e.exp_break_pos) ::!iast_label_table;
		  Break{ e with exp_break_path_id = nl;}  
    | CallRecv e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"callRecv",[],e.exp_call_recv_pos) ::!iast_label_table;
		  CallRecv {e with
			  exp_call_recv_receiver = label_e e.exp_call_recv_receiver;
			  exp_call_recv_arguments  = List.map label_e e.exp_call_recv_arguments;
			  exp_call_recv_path_id = nl;}
    | CallNRecv e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"callNRecv",[],e.exp_call_nrecv_pos) ::!iast_label_table;
		  CallNRecv { e with 
			  exp_call_nrecv_arguments =  List.map label_e e.exp_call_nrecv_arguments;
			  exp_call_nrecv_path_id = nl;}
    | Cond e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"cond",[(nl,0);(nl,1)],e.exp_cond_pos) ::!iast_label_table;
		  Cond {e with 
			  exp_cond_condition = label_e e.exp_cond_condition;
			  exp_cond_then_arm  = Label ((nl,0),(label_e e.exp_cond_then_arm));
			  exp_cond_else_arm  = Label ((nl,1),(label_e e.exp_cond_else_arm));
			  exp_cond_path_id =nl;}
    | Continue e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"continue",[],e.exp_continue_pos) ::!iast_label_table;
		  Continue {e with  exp_continue_path_id = nl;}
    | Member e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"member",[],e.exp_member_pos) ::!iast_label_table;
		  Member {e with
			  exp_member_base = label_e e.exp_member_base;
			  exp_member_path_id = nl;}  
    | Raise e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"raise",[],e.exp_raise_pos) ::!iast_label_table;
		  Raise {e with
		      exp_raise_val = 
			      (match e.exp_raise_val with 
				    | None -> None 
				    | Some s-> Some (label_e s));
		      exp_raise_path_id = nl;}  
    | Return e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"return",[],e.exp_return_pos) ::!iast_label_table;
		  Return{ e with
			  exp_return_val = (match e.exp_return_val with | None -> None | Some s-> Some (label_e s));
			  exp_return_path_id = nl;}  
    | Try e -> 
		  let nl = fresh_branch_point_id "" in
		  let rec lbl_list_constr n = if n==0 then [] else (nl,n)::(lbl_list_constr (n-1)) in
		  iast_label_table:= (nl,"try",(lbl_list_constr (List.length e.exp_catch_clauses)),e.exp_try_pos)::!iast_label_table;
		  let lbl_c n d = 
			let d = get_catch_of_exp d in
			Catch {d with	exp_catch_body = Label((nl,n),label_e d.exp_catch_body);} in
		  Try {e with
			  exp_try_block = label_e e.exp_try_block;
			  exp_try_path_id = nl;
			  exp_catch_clauses  = (fst (List.fold_left (fun (a,c) d-> ((lbl_c c d)::a, c+1)) ([],0) e.exp_catch_clauses));
			  exp_finally_clause = List.map label_e e.exp_finally_clause;}
    | Unary e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"unary",[],e.exp_unary_pos) ::!iast_label_table;
		  Unary{ e with
			  exp_unary_exp = label_e e.exp_unary_exp;
			  exp_unary_path_id = fresh_branch_point_id "";}  		
    | While e -> 
		  let nl = fresh_branch_point_id "" in
		  iast_label_table:= (nl,"while",[],e.exp_while_pos) ::!iast_label_table;
		  While {e with
			  exp_while_condition = label_e e.exp_while_condition;
			  exp_while_body = label_e e.exp_while_body;
			  exp_while_path_id = nl;
			  exp_while_wrappings = match e.exp_while_wrappings with | None -> None | Some s-> Some (label_e s);}  
    | _ -> Error.report_error   
      {Err.error_loc = get_exp_pos e; Err.error_text = "exp not considered in label_e yet"}  
  in map_exp e helper

(* This method adds (label,name,branches,loc) to iast_lable_table.
   For  branching points of expressions, such
   as conditionals, a Label construct is added.
*)
let label_exp e = label_e e 
(*
let rec label_exp e = match e with
  | Block e -> Block {e with exp_block_body = label_exp e.exp_block_body;}
  | Cast e -> Cast {e with  exp_cast_body = label_exp e.exp_cast_body;}
  | ConstDecl e -> ConstDecl {e with exp_const_decl_decls = List.map (fun (c1,c2,c3)-> (c1,(label_exp c2),c3)) e.exp_const_decl_decls;}
  | Catch e -> Error.report_error   {Err.error_loc = e.exp_catch_pos; Err.error_text = "unexpected catch clause"}
  | BoolLit _ 
  | Debug _ 
  | Dprint _ 
  | Empty _ 
  | FloatLit _ 
  | IntLit _
  | Java _ 
  | Unfold _ 
  | Var _ 
  | This _ 
  | Time _ 
  | Null _ -> e
  | VarDecl e -> VarDecl {e with exp_var_decl_decls = List.map (fun (c1,c2,c3)-> (c1,(match c2 with | None-> None | Some s -> Some(label_exp s)),c3)) e.exp_var_decl_decls;}  
  | Seq e -> Seq {e with
		exp_seq_exp1 = label_exp e.exp_seq_exp1;
		exp_seq_exp2 = label_exp e.exp_seq_exp2;}
  | New e -> New{e with exp_new_arguments = List.map label_exp e.exp_new_arguments;}
  | Finally e -> Finally {e with exp_finally_body = label_exp e.exp_finally_body}
  | Label (pid,e) -> Label (pid, (label_exp e))
  | Assert e -> 
		let nl = fresh_formula_label (snd e.exp_assert_path_id) in
		iast_label_table:= (Some nl,"assert",[],e.exp_assert_pos) ::!iast_label_table;
		Assert {e with exp_assert_path_id = nl }
  | Assign e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"assign",[],e.exp_assign_pos) ::!iast_label_table;
		Assign {e with 
				   exp_assign_lhs = label_exp e.exp_assign_lhs;
				   exp_assign_rhs = label_exp e.exp_assign_rhs;
				   exp_assign_path_id = nl;}
  | Binary e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"binary",[],e.exp_binary_pos) ::!iast_label_table;
		Binary{e with
				   exp_binary_oper1 = label_exp e.exp_binary_oper1;
				   exp_binary_oper2 = label_exp e.exp_binary_oper2;
				   exp_binary_path_id = nl;}
  | Bind e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"bind",[],e.exp_bind_pos) ::!iast_label_table;
		Bind {e with
 				 exp_bind_body = label_exp e.exp_bind_body;
				 exp_bind_path_id  = nl;}
  | Break e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"break",[],e.exp_break_pos) ::!iast_label_table;
		Break{ e with exp_break_path_id = nl;}  
  | CallRecv e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"callRecv",[],e.exp_call_recv_pos) ::!iast_label_table;
		CallRecv {e with
					  exp_call_recv_receiver = label_exp e.exp_call_recv_receiver;
					  exp_call_recv_arguments  = List.map label_exp e.exp_call_recv_arguments;
					  exp_call_recv_path_id = nl;}
  | CallNRecv e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"callNRecv",[],e.exp_call_nrecv_pos) ::!iast_label_table;
		CallNRecv { e with 
			exp_call_nrecv_arguments =  List.map label_exp e.exp_call_nrecv_arguments;
			exp_call_nrecv_path_id = nl;}
  | Cond e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"cond",[(nl,0);(nl,1)],e.exp_cond_pos) ::!iast_label_table;
		Cond {e with 
			exp_cond_condition = label_exp e.exp_cond_condition;
			exp_cond_then_arm  = Label ((nl,0),(label_exp e.exp_cond_then_arm));
			exp_cond_else_arm  = Label ((nl,1),(label_exp e.exp_cond_else_arm));
			exp_cond_path_id =nl;}
  | Continue e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"continue",[],e.exp_continue_pos) ::!iast_label_table;
		Continue {e with  exp_continue_path_id = nl;}
  | Member e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"member",[],e.exp_member_pos) ::!iast_label_table;
		Member {e with
			exp_member_base = label_exp e.exp_member_base;
			exp_member_path_id = nl;}  
  | Raise e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"raise",[],e.exp_raise_pos) ::!iast_label_table;
		Raise {e with
		exp_raise_val = 
			(match e.exp_raise_val with 
				| None -> None 
				| Some s-> Some (label_exp s));
		exp_raise_path_id = nl;}  
  | Return e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"return",[],e.exp_return_pos) ::!iast_label_table;
		Return{ e with
			exp_return_val = (match e.exp_return_val with | None -> None | Some s-> Some (label_exp s));
			exp_return_path_id = nl;}  
  | Try e -> 
		let nl = fresh_branch_point_id "" in
		let rec lbl_list_constr n = if n==0 then [] else (nl,n)::(lbl_list_constr (n-1)) in
		iast_label_table:= (nl,"try",(lbl_list_constr (List.length e.exp_catch_clauses)),e.exp_try_pos)::!iast_label_table;
		let lbl_c n d = 
			let d = get_catch_of_exp d in
			Catch {d with	exp_catch_body = Label((nl,n),label_exp d.exp_catch_body);} in
		Try {e with
				exp_try_block = label_exp e.exp_try_block;
				exp_try_path_id = nl;
				exp_catch_clauses  = (fst (List.fold_left (fun (a,c) d-> ((lbl_c c d)::a, c+1)) ([],0) e.exp_catch_clauses));
				exp_finally_clause = List.map label_exp e.exp_finally_clause;}
  | Unary e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"unary",[],e.exp_unary_pos) ::!iast_label_table;
		Unary{ e with
			exp_unary_exp = label_exp e.exp_unary_exp;
			exp_unary_path_id = fresh_branch_point_id "";}  		
  | While e -> 
		let nl = fresh_branch_point_id "" in
		iast_label_table:= (nl,"while",[],e.exp_while_pos) ::!iast_label_table;
		While {e with
			exp_while_condition = label_exp e.exp_while_condition;
			exp_while_body = label_exp e.exp_while_body;
			exp_while_path_id = nl;
			exp_while_wrappings = match e.exp_while_wrappings with | None -> None | Some s-> Some (label_exp s);}  
*)
	
let label_proc proc = {proc with
	proc_body = 
		match proc.proc_body with  
			| None -> None 
			| Some s -> Some (label_exp s);}
let label_procs_prog prog = {prog with
	prog_data_decls = List.map (fun c->{ c with data_methods = List.map label_proc c.data_methods}) prog.prog_data_decls;	
	prog_proc_decls = List.map label_proc prog.prog_proc_decls;
	}
