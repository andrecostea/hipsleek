(*
  Created 21-Feb-2006

  AST for the core language
*)

open Globals
open Gen.Basic
(* open Exc.ETABLE_NFLOW *)
open Exc.GTable
type n


module F = Cformula
module CF = Cformula
module P = Cpure
module MP = Mcpure
module Err = Error
module LO = Label_only.LOne

(*used in Predicate*)
let pure_hprel_map = ref ([]: (ident * ident) list)

type typed_ident = (typ * ident)

and prog_decl = { 
    mutable prog_data_decls : data_decl list;
    mutable prog_logical_vars : P.spec_var list;
    mutable prog_view_decls : view_decl list;
    mutable prog_rel_decls : rel_decl list; (* An Hoa : relation definitions *)
    mutable prog_hp_decls : hp_decl list; (*only used to compare against some expected output????*)
    mutable prog_view_equiv : (ident * ident) list; (*inferred with --pred-en-equiv*)
    mutable prog_axiom_decls : axiom_decl list; (* An Hoa : axiom definitions *)
    (*old_proc_decls : proc_decl list;*) (* To be removed completely *)
    new_proc_decls : (ident, proc_decl) Hashtbl.t; (* Mingled name with proc_delc *)
    (*mutable prog_left_coercions : coercion_decl list;*)
    (*mutable prog_right_coercions : coercion_decl list;*)
    prog_barrier_decls : barrier_decl list
}
    
and prog_or_branches = (prog_decl * 
    ((MP.mix_formula * (ident * (P.spec_var list))) option) )

and data_field_ann =
  | VAL
  | REC
  | F_NO_ANN

and data_decl = { 
    data_name : ident;
    data_pos : loc;
    data_fields : (typed_ident * (ident list) (* data_field_ann *)) list;
    data_parent_name : ident;
    data_invs : F.formula list;
    data_methods : proc_decl list; }
    
and ba_prun_cond = Gen.Baga(P.PtrSV).baga * formula_label
    
and mater_property = {
    mater_var : P.spec_var;
    mater_full_flag : bool;
    mater_target_view : ident list; (*the view to which it materializes*)
}

and barrier_decl = {
    barrier_thc : int;
    barrier_name : ident;
    barrier_shared_vars : P.spec_var list;
    barrier_tr_list : (int*int* F.struc_formula list) list ;
    barrier_def: F.struc_formula ;
    barrier_prune_branches: formula_label list; (* all the branches of a view *)
    barrier_prune_conditions: (P.b_formula * (formula_label list)) list;
    barrier_prune_conditions_state: (int * (formula_label list)) list;
    barrier_prune_conditions_perm: (Tree_shares.Ts.t_sh* (formula_label list)) list ;
    barrier_prune_conditions_baga: ba_prun_cond list;
    barrier_prune_invariants : (formula_label list * (Gen.Baga(P.PtrSV).baga * P.b_formula list )) list ;
}  

and view_kind =
  | View_PRIM
  | View_NORM
  | View_EXTN
  | View_SPEC

and view_decl = { 
    view_name : ident; 
    view_vars : P.spec_var list;
    view_cont_vars : P.spec_var list;
    view_case_vars : P.spec_var list; (* predicate parameters that are bound to guard of case, but excluding self; subset of view_vars*)
    view_uni_vars : P.spec_var list; (*predicate parameters that may become universal variables of universal lemmas*)
    view_labels : LO.t list;
    view_modes : mode list;
    view_domains: ident list; (*View_EXT have been applied in this view*)
    view_is_prim : bool;
    view_kind : view_kind;
    view_prop_extns:  P.spec_var list; (*for extn views*)
    view_parent_name: ident option;
    (*a map of shape <-> pure properties*)
    view_extns: (ident * int * int) list;(* (view_extn_name, r_pos , extn_arg_pos) list;*)
    (* below to detect @L in post-condition *)
    mutable view_contains_L_ann : bool;
    view_ann_params : (P.annot_arg * int) list;
    view_params_orig: (P.view_arg * int) list;
    mutable view_partially_bound_vars : bool list;
    mutable view_materialized_vars : mater_property list; (* view vars that can point to objects *)
    view_data_name : ident;
    view_formula : F.struc_formula; (* case-structured formula *)
    mutable view_user_inv : MP.mix_formula; (* XPURE 0 -> revert to P.formula*)
    view_mem : F.mem_perm_formula option; (* Memory Region Spec *)
    view_inv_lock : F.formula option;
    mutable view_x_formula : (MP.mix_formula); (*XPURE 1 -> revert to P.formula*)
    mutable view_xpure_flag : bool; (* flag to indicate if XPURE0 <=> XPURE1 *)
    mutable view_baga : Gen.Baga(P.PtrSV).baga;
    mutable view_addr_vars : P.spec_var list;
    (* if view has only a single eqn, then place complex subpart into complex_inv *)  
    view_complex_inv : MP.mix_formula  option; (*COMPLEX INV for --eps option*)
    view_un_struc_formula : (Cformula.formula * formula_label) list ; (*used by the unfold, pre transformed in order to avoid multiple transformations*)
    view_base_case : (P.formula *MP.mix_formula) option; (* guard for base case, base case*)
    view_prune_branches: formula_label list; (* all the branches of a view *)
    view_is_rec : bool;
    view_pt_by_self : ident list;
    view_prune_conditions: (P.b_formula * (formula_label list)) list;
    view_prune_conditions_baga: ba_prun_cond list;
    view_prune_invariants : (formula_label list * (Gen.Baga(P.PtrSV).baga * P.b_formula list )) list ;
    view_pos : loc;
    view_raw_base_case: Cformula.formula option;}

(* An Hoa : relation *)					
and rel_decl = { 
    rel_name : ident; 
    rel_vars : P.spec_var list;
    rel_formula : P.formula;}

and hp_decl = { 
    hp_name : ident;
    hp_vars_inst : (P.spec_var * Globals.hp_arg_kind) list;
    hp_part_vars: (int list) list; (*partition vars into groups e.g. pointer + pure properties*)
    mutable hp_root_pos: int;
    hp_is_pre: bool;
    hp_formula : F.formula;}

(** An Hoa : axiom *)
and axiom_decl = {
    axiom_id : int;
    axiom_hypothesis : P.formula;
    axiom_conclusion : P.formula; }

and proc_decl = {
    proc_name : ident;
    proc_args : typed_ident list;
    proc_source : ident; (* source file *)
    proc_return : typ;
    proc_flags : (ident*ident*(flags option)) list;
    mutable proc_important_vars : P.spec_var list; (* An Hoa : pre-computed list of important variables; namely the program parameters & logical variables in the specification that need to be retained during the process of verification i.e. such variables should not be removed when we perform simplification. Remark - all primed variables are important. *)
    proc_static_specs : Cformula.struc_formula;
    (* proc_static_specs_with_pre : Cformula.struc_formula; *)
    (* this puts invariant of pre into the post-condition *)
    proc_dynamic_specs : Cformula.struc_formula;
    (*proc_dynamic_specs_with_pre : Cformula.struc_formula;*)
    (* stack of static specs inferred *)
    proc_stk_of_static_specs : Cformula.struc_formula Gen.stack;
    mutable proc_hprel_ass: Cformula.hprel list;
    mutable proc_hprel_unkmap: ((P.spec_var * int list) * P.xpure_view) list;
    mutable proc_sel_hps: P.spec_var list;
    mutable proc_sel_post_hps: P.spec_var list;
    mutable proc_hpdefs: Cformula.hp_rel_def list;(*set of heap predicate constraints derived from this method*)
    mutable proc_callee_hpdefs: Cformula.hp_rel_def list;
    (*set of heap predicate constraints derived from calls in this method*)
    (*due to the bottom up inference they are always just copyed from the proc_hpdefs of called methods*)
    proc_by_name_params : P.spec_var list;
    proc_by_copy_params: P.spec_var list;
    proc_body : exp option;
    (* Termination: Set of logical variables of the proc's scc group *)
    proc_logical_vars : P.spec_var list;
    proc_call_order : int;
    proc_is_main : bool;
    proc_is_invoked : bool;
    proc_is_recursive : bool;
    proc_file : string;
    proc_loc : loc;
    proc_test_comps :  test_comps option}

and test_comps = 
    {
        expected_ass: (ident list * ident list *(Cformula.formula * Cformula.formula) list) option;
        expected_hpdefs: (ident list * ident list *(Cformula.formula * Cformula.formula) list) option;
    }

(*TODO: should we change lemma need struc formulas?
  would this help with lemma folding later? *)

(* TODO : coercion type ->, <-, <-> just added *)
and coercion_case =
  | Simple
  | Complex
  | Ramify
  | Normalize of bool 
        (* 
           |LHS| > |RHS| --> Normalize of true --> combine
           |LHS| < |RHS| --> Normalize of false --> split
           Otherwise, simple or complex
        *)

and coercion_decl = { 
    coercion_type : coercion_type;
    coercion_exact : bool;
    coercion_name : ident;
    coercion_head : F.formula; (* used as antecedent during --elp *)
    coercion_head_norm : F.formula; (* used as consequent during --elp *)
    coercion_body : F.formula; (* used as antecedent during --elp *)
    coercion_body_norm : F.struc_formula; (* used as consequent during --elp *)
    coercion_impl_vars : P.spec_var list; (* list of implicit vars *)
    coercion_univ_vars : P.spec_var list; (* list of universally quantified variables. *)

    coercion_infer_vars :  P.spec_var list;
    (* coercion_proof : exp; *)
    (* coercion_head_exist : F.formula;   *)
 
    (* this used to build a defn for folding right lemma *)
    coercion_fold_def : view_decl Gen.mut_option;
 
    (* same as head except for annotation to self node? *)
    coercion_head_view : ident; 
    (* the name of the predicate where this coercion can be applied *)
    coercion_body_view : ident;  (* used for cycles checking *)
    coercion_mater_vars : mater_property list;
    (* coercion_simple_lhs :bool; (\* signify if LHS is simple or complex *\) *)
    coercion_case : coercion_case; (*Simple or Complex*)
    coercion_type_orig: coercion_type option; 
    coercion_kind: lemma_kind;
}

and coercion_type = Iast.coercion_type
    (* | Left *)
    (* | Equiv *)
    (* | Right *)
    

and sharp_flow = 
  | Sharp_ct of F.flow_formula
  | Sharp_id of ident

        
and sharp_val = 
  | Sharp_no_val (* captures flow without a value *)
  | Sharp_flow of ident   (* capture flow explicitly and a value*)
  | Sharp_var of typed_ident (* captures flow through a var *)

(* An Hoa : v[i] where v is an identifier and i is an expression *)
(* and exp_arrayat = { exp_arrayat_type : P.typ; (* Type of the array element *)
   exp_arrayat_array_base : ident; (* Name of the array *)
   exp_arrayat_index : exp; (* Integer valued expression for the index *)
   exp_arrayat_pos : loc; } *)

(* An Hoa : The exp_assign in core representation does not allow lhs to be another expression so array modification statement is necessary *)
(* and exp_arraymod = { exp_arraymod_lhs : exp_arrayat; (* v[i] *)
   exp_arraymod_rhs : exp; 
   exp_arraymod_pos : loc } *)

and exp_assert = { 
    exp_assert_asserted_formula : F.struc_formula option;
    exp_assert_assumed_formula : F.formula option;
    exp_assert_path_id : formula_label;
    exp_assert_type : assert_type;
    exp_assert_pos : loc }

and exp_assign = 
    { exp_assign_lhs : ident;
    exp_assign_rhs : exp;
    exp_assign_pos : loc }

and exp_bconst = { 
    exp_bconst_val : bool;
    exp_bconst_pos : loc }

and exp_bind = { 
    exp_bind_type : typ; (* the type of the entire bind construct, i.e. the type of the body *)
    exp_bind_bound_var : typed_ident;
    exp_bind_fields : typed_ident list;
    exp_bind_body : exp;
    exp_bind_imm : P.ann;
    exp_bind_param_imm : P.ann list;
    exp_bind_read_only : bool; (*for frac perm, indicate whether the body will read or write to bound vars in exp_bind_fields*)
    exp_bind_path_id : control_path_id_strict;
    exp_bind_pos : loc }

and exp_block = { exp_block_type : typ;
exp_block_body : exp;
exp_block_local_vars : typed_ident list;
exp_block_pos : loc }

and exp_barrier = {exp_barrier_recv : typed_ident; exp_barrier_pos : loc}

and exp_cast = {
    exp_cast_target_type : typ;
    exp_cast_body : exp;
    exp_cast_pos : loc }

and exp_cond = { exp_cond_type : typ;
exp_cond_condition : ident;
exp_cond_then_arm : exp;
exp_cond_else_arm : exp;
exp_cond_path_id : control_path_id_strict;
exp_cond_pos : loc }

and exp_debug = {
    exp_debug_flag : bool;
    exp_debug_pos : loc }

and exp_fconst = {
    exp_fconst_val : float;
    exp_fconst_pos : loc }

(* instance call *)
and exp_icall = { exp_icall_type : typ;
exp_icall_receiver : ident;
exp_icall_receiver_type : typ;
exp_icall_method_name : ident;
exp_icall_arguments : ident list;
exp_icall_is_rec : bool; (* set for each mutual-recursive call *)
(*exp_icall_visible_names : P.spec_var list;*) (* list of visible names at location the call is made *)
exp_icall_path_id : control_path_id;
exp_icall_pos : loc }

and exp_iconst = {
    exp_iconst_val : int;
    exp_iconst_pos : loc }

and exp_new = {
    exp_new_class_name : ident;
    exp_new_parent_name : ident;
    exp_new_arguments : typed_ident list;
    exp_new_pos : loc }

and exp_return = { exp_return_type : typ;
exp_return_val : ident option;
exp_return_pos : loc }

(* static call *)
and exp_scall = { exp_scall_type : typ;
exp_scall_method_name : ident;
exp_scall_lock : ident option;
exp_scall_arguments : ident list;
exp_scall_is_rec : bool; (* set for each mutual-recursive call *)
(*exp_scall_visible_names : P.spec_var list;*) (* list of visible names at location the call is made *)
exp_scall_path_id : control_path_id;
exp_scall_pos : loc }

and exp_seq = { exp_seq_type : typ;
exp_seq_exp1 : exp;
exp_seq_exp2 : exp;
exp_seq_pos : loc }

and exp_sharp = {
    exp_sharp_type : typ;
    exp_sharp_flow_type :sharp_flow;(*the new flow*)
    exp_sharp_val :sharp_val;(*returned value*)
    exp_sharp_unpack : bool;(*true if it must get the new flow from the second element of the current flow pair*)
    exp_sharp_path_id : control_path_id;
    exp_sharp_pos : loc;
}

and exp_catch = {
    exp_catch_flow_type : nflow (* nflow *) ;
    exp_catch_flow_var : ident option;
    exp_catch_var : typed_ident option;
    exp_catch_body : exp;
    exp_catch_pos : loc }

and exp_try = { exp_try_type : typ;
exp_try_body : exp;
exp_try_path_id : control_path_id_strict;
exp_catch_clause : exp ;
exp_try_pos : loc }

and exp_this = { exp_this_type : typ;
exp_this_pos : loc }

and exp_var = { exp_var_type : typ;
exp_var_name : ident;
exp_var_pos : loc }

(* An Hoa : Empty array - only for initialization purpose *)
and exp_emparray = { exp_emparray_type : typ;
exp_emparray_dim : int;
exp_emparray_pos : loc }

and exp_var_decl = { exp_var_decl_type : typ;
exp_var_decl_name : ident;
exp_var_decl_pos : loc }

and exp_while = { 
    exp_while_condition : ident;
    exp_while_body : exp;
    exp_while_spec : Cformula.struc_formula (*multi_spec*);
    exp_while_path_id : control_path_id;
    exp_while_pos : loc }

and exp_dprint = { 
    exp_dprint_string : ident;
    exp_dprint_visible_names : ident list;
    exp_dprint_pos : loc }

and exp_unfold = { 
    exp_unfold_var : P.spec_var;
    exp_unfold_pos : loc }

and exp_check_ref = { 
    exp_check_ref_var : ident;
    exp_check_ref_pos : loc }

and exp_java = { 
    exp_java_code : string;
    exp_java_pos : loc}
and exp_label = {
    exp_label_type : typ;
    exp_label_path_id : (control_path_id * path_label);
    exp_label_exp: exp;}
    
and exp = (* expressions keep their types *)
    (* for runtime checking *)
  | Label of exp_label
  | CheckRef of exp_check_ref
  | Java of exp_java
        (* standard expressions *)
	(* | ArrayAt of exp_arrayat (* An Hoa *) *)
	(* | ArrayMod of exp_arraymod (* An Hoa *) *)
  | Assert of exp_assert
  | Assign of exp_assign
  | BConst of exp_bconst
  | Bind of exp_bind
  | Block of exp_block
  | Barrier of exp_barrier
  | Cond of exp_cond
  | Cast of exp_cast
  | Catch of exp_catch
  | Debug of exp_debug
  | Dprint of exp_dprint
  | FConst of exp_fconst
        (*
	  | FieldRead of (P.typ * (ident * P.typ) * (ident * int) * loc) 
        (* v.f --> (type of f, v, (f, position of f in field list), pos *)
	  | FieldWrite of ((ident * P.typ) * (ident * int) * ident * loc) 
        (* field assignment is flattened to form x.f = y only *)
        *)
  | ICall of exp_icall
  | IConst of exp_iconst
	(*| ArrayAlloc of exp_aalloc *) (* An Hoa *)
  | New of exp_new
  | Null of loc
  | EmptyArray of exp_emparray (* An Hoa : add empty array as default value for array declaration *)
  | Print of (int * loc)
        (* | Return of exp_return*)
  | SCall of exp_scall
  | Seq of exp_seq
  | This of exp_this
  | Time of (bool*string*loc)
  | Var of exp_var
  | VarDecl of exp_var_decl
  | Unfold of exp_unfold
  | Unit of loc
  | While of exp_while
  | Sharp of exp_sharp
  | Try of exp_try


let get_sharp_flow sf = match sf with
  | Sharp_ct ff -> ff.F.formula_flow_interval
  | Sharp_id id -> exlist # get_hash id


let print_mix_formula = ref (fun (c:MP.mix_formula) -> "cpure printer has not been initialized")
let print_b_formula = ref (fun (c:P.b_formula) -> "cpure printer has not been initialized")
let print_h_formula = ref (fun (c:F.h_formula) -> "cpure printer has not been initialized")
let print_exp = ref (fun (c:P.exp) -> "cpure printer has not been initialized")
let print_prog_exp = ref (fun (c:exp) -> "cpure printer has not been initialized")
let print_formula = ref (fun (c:F.formula) -> "cform printer has not been initialized")
let print_pure_formula = ref (fun (c:P.formula) -> "cform printer has not been initialized")
let print_spec_var_list = ref (fun (c:P.spec_var list) -> "cpure printer has not been initialized")
let print_struc_formula = ref (fun (c:F.struc_formula) -> "cpure printer has not been initialized")
let print_svl = ref (fun (c:P.spec_var list) -> "cpure printer has not been initialized")
let print_sv = ref (fun (c:P.spec_var) -> "cpure printer has not been initialized")
let print_mater_prop = ref (fun (c:mater_property) -> "cast printer has not been initialized")
let print_mater_prop_list = ref (fun (c:mater_property list) -> "cast printer has not been initialized")

(*single node -> simple (true), otherwise -> complex (false*)
(* let is_simple_formula x = true *)
let print_view_decl = ref (fun (c:view_decl) -> "cast printer has not been initialized")
let print_view_decl_short = ref (fun (c:view_decl) -> "cast printer has not been initialized")
let print_hp_decl = ref (fun (c:hp_decl) -> "cast printer has not been initialized")
let print_coercion = ref (fun (c:coercion_decl) -> "cast printer has not been initialized")
let print_coerc_decl_list = ref (fun (c:coercion_decl list) -> "cast printer has not been initialized")
let print_mater_prop_list = ref (fun (c:mater_property list) -> "cast printer has not been initialized")

(** An Hoa [22/08/2011] Extract data field information **)

let is_primitive_proc p = (*p.proc_body==None*) not p.proc_is_main

let name_of_proc p = p.proc_name


let get_field_typ (f,_) = fst f

let get_field_name (f,_) = snd f

(** An Hoa [22/08/2011] End **)

(* transform each proc by a map function *)
(* Replaced by proc_decls_map f_p prog *)
(*
let map_proc (prog:prog_decl)
  (f_p : proc_decl -> proc_decl) : prog_decl =
  { prog with
      prog_proc_decls = List.map (f_p) prog.prog_proc_decls;
  }
*)

(* Sort a list of proc_decl by proc_call_order *)
let sort_proc_decls (pl: proc_decl list) : proc_decl list =
  List.fast_sort (fun p1 p2 -> p1.proc_call_order - p2.proc_call_order) pl

let same_call_scc p1 p2 = p1.proc_call_order == p2.proc_call_order

(* returns (procs_wo_body, proc_mutual_rec list) *)
(* The list of proc_decl must be sorted *)
let re_proc_mutual (pl : proc_decl list) : (proc_decl list * ((proc_decl list) list) ) = 
  let (pr_prim, pr_rest) = List.partition is_primitive_proc pl in
  let rec helper acc pl = match pl with
    | [] -> if acc==[] then [] else [acc]
    | x::rest -> 
          begin
            match acc with
              | [] -> helper [x] rest
              | a::_ -> if same_call_scc a x then helper (x::acc) rest
                else acc::(helper [x] rest)
          end
  in (pr_prim, helper [] pr_rest)

(* Create a hash table which contains 
 * a list of proc_decl *)
let create_proc_decls_hashtbl (cp: proc_decl list) : (ident, proc_decl) Hashtbl.t =
  let h_tbl = Hashtbl.create 20 in
  let _ = List.iter (fun p -> Hashtbl.add h_tbl (p.proc_name) p) cp in
  h_tbl

let replace_proc cp new_proc =
  let id = new_proc.proc_name in
  let _ = Hashtbl.replace cp.new_proc_decls id new_proc in
  cp

let proc_decls_map f decls =
  let _ = Hashtbl.iter (fun i p -> 
    let np = f p in
    Hashtbl.replace decls i np   
  ) decls in
  decls

(* returns Not_found if id not in prog_decls *)
let find_proc cp id =
  Hashtbl.find cp.new_proc_decls id

(* returns None if id not in prog_decls *)
let find_proc_opt cp id =
  try 
    Some (find_proc cp id)
  with _ -> None

let list_of_procs cp =
  Hashtbl.fold (fun id pd lst -> pd::lst) cp.new_proc_decls []

let re_proc_mutual_from_prog cp : (proc_decl list * ((proc_decl list) list) ) = 
  let lst = list_of_procs cp
  in re_proc_mutual lst

let mater_prop_var a = a.mater_var 
let mater_prop_cmp_var a c = P.eq_spec_var_ident a.mater_var c.mater_var 
let mk_mater_prop v ff tv = {mater_var=v; mater_full_flag = ff; mater_target_view = tv}
let mater_prop_cmp c1 c2 = P.spec_var_cmp c1.mater_var c2.mater_var
let merge_mater_views v1 v2 = match v1,v2 with
  | [],[] -> ([],true) 
  | [],_ -> ([],false)
  | _ ,[] -> ([],false)
  | _ -> 
    if (List.length v1 == 1 && List.length v2 == 1) then
      if (String.compare (List.hd v1)(List.hd v2) == 0) then (v1,true)
      else (v1@v2,false)
    else (v1@v2,false)
  
let merge_mater_props_x x y = 
  let nl,flag = merge_mater_views x.mater_target_view y.mater_target_view in
  mk_mater_prop x.mater_var (x.mater_full_flag && y.mater_full_flag && flag)  nl

let merge_mater_props x y =
  let pr = !print_mater_prop in
  Debug.no_2 "merge_mater_props" pr pr pr merge_mater_props_x x y
  
let mater_props_to_sv_list l =  List.map (fun c-> c.mater_var) l
  
let subst_mater_list fr t l = 
  let lsv = List.combine fr t in
  (* let _ = print_string "subst_mater_list: inside \n" in (\*LDK*\) *)
  List.map (fun c-> 
      {c with mater_var = P.subs_one lsv c.mater_var
              (* ; mater_var = P.subs_one lsv c.mater_var *)
      }) l

let subst_mater_list_nth i fr t l = 
  let pr_svl = !print_svl in
  Debug.no_2_num i "subst_mater_list" pr_svl pr_svl pr_no (fun _ _ -> subst_mater_list fr t l) fr t 

let subst_mater_list_nth i fr t l = 
  let pr_svl = !print_svl in
  Debug.no_3_num i "subst_mater_list" pr_svl pr_svl !print_mater_prop_list pr_no  subst_mater_list fr t l

let subst_coercion fr t (c:coercion_decl) = 
      {c with coercion_head = F.subst_avoid_capture fr t c.coercion_head
              ; coercion_body = F.subst_avoid_capture fr t c.coercion_body
      }
 
let subst_coercion fr t (c:coercion_decl) = 
  let pr = !print_coercion in
  Debug.no_1 "subst_coercion" pr pr (fun _ -> subst_coercion fr t c ) c

(* process each proc into some data which are then combined,
   e.g. verify each method and collect the failure points
*)
(* The following function is replace by proc_decls_fold *)
(*
let fold_proc (prog:prog_decl)
  (f_p : proc_decl -> 'b) (f_comb: 'b -> 'b -> 'b) (zero:'b) : 'b =
  List.fold_left (fun x p -> f_comb (f_p p) x) 
		zero prog.prog_proc_decls
*)

let proc_decls_fold (prog: prog_decl)
  (f_p : proc_decl -> 'b) (f_comb: 'b -> 'b -> 'b) (zero:'b) : 'b =
  Hashtbl.fold (fun id p acc -> f_comb (f_p p) acc) prog.new_proc_decls zero

(* iterate each proc to check for some property *)
(* The following function is replace by proc_decls_iter *) 
(*
let iter_proc (prog:prog_decl) (f_p : proc_decl -> unit) : unit =
  fold_proc prog (f_p) (fun _ _ -> ()) ()
*)

let proc_decls_iter (prog:prog_decl) (f_p : proc_decl -> unit) : unit =
  proc_decls_fold prog (f_p) (fun _ _ -> ()) ()

(*let arrayat_of_exp e = match e with
	| ArrayAt t -> t
	| _ -> failwith "arrayat_of_exp :: input is not case ArrayAt of exp"*)

let transform_exp (e:exp) (init_arg:'b)(f:'b->exp->(exp* 'a) option)  (f_args:'b->exp->'b)(comb_f:'a list -> 'a) (zero:'a) :(exp * 'a) =
  let rec helper (in_arg:'b) (e:exp) :(exp* 'a) =	
    match (f in_arg e) with
      | Some e1 -> e1
      | None  -> 
	        let n_arg = f_args in_arg e in
	        match e with
	          | Assert _
	          | Java _
	          | CheckRef _ 
	          | BConst _
	          | Debug _
	          | Dprint _
	          | FConst _
	          | ICall _
	          | IConst _
						(* | ArrayAlloc _ *) (* An Hoa *)
	          | New _
	          | Null _
						| EmptyArray _ (* An Hoa *)
	          | Print _
			  | Barrier _
	          | SCall _
	          | This _
	          | Time _
	          | Var _
	          | VarDecl _
	          | Unfold _
	          | Unit _
	          | Sharp _
		          -> (e, zero)
	          | Label b ->
		            let e1,r1 = helper n_arg b.exp_label_exp  in
		            (Label { b with exp_label_exp = e1;}, r1)
	          | Assign b ->
		            let e1,r1 = helper n_arg b.exp_assign_rhs in
		            (Assign { b with exp_assign_rhs = e1; }, r1)
						(* | ArrayAt b -> (* An Hoa *)
		            let e1,r1 = helper n_arg b.exp_arrayat_index in
		            (ArrayAt { b with exp_arrayat_index = e1; }, r1) *)
						(* | ArrayMod b ->
								let e1,r1 = helper n_arg (ArrayAt b.exp_arraymod_lhs) in
		            let e2,r2 = helper n_arg b.exp_arraymod_rhs in
		            (ArrayMod { b with exp_arraymod_lhs = (arrayat_of_exp e1); exp_arraymod_rhs = e2; }, comb_f [r1;r2]) *)
	          | Bind b ->
		            let e1,r1 = helper n_arg b.exp_bind_body  in
		            (Bind { b with exp_bind_body = e1; }, r1)
	          | Block b ->
		            let e1,r1 = helper n_arg b.exp_block_body in
		            (Block { b with exp_block_body = e1; }, r1)		         
	          | Cond b ->
		            let e1,r1 = helper n_arg b.exp_cond_then_arm in
		            let e2,r2 = helper n_arg b.exp_cond_else_arm in
		            let r = comb_f [r1;r2] in
		            (Cond {b with
			            exp_cond_then_arm = e1;
			            exp_cond_else_arm = e2;},r)
	          | Cast b -> 
                    let e1,r1 = helper n_arg b.exp_cast_body  in  
		            (Cast {b with exp_cast_body = e1},r1)
              | Catch b ->
                    let e1,r1 = helper n_arg b.exp_catch_body in
                    (Catch {b with exp_catch_body = e1},r1)
	          | Seq b ->
		            let e1,r1 = helper n_arg b.exp_seq_exp1 in 
		            let e2,r2 = helper n_arg b.exp_seq_exp2 in 
		            let r = comb_f [r1;r2] in
		            (Seq {b with exp_seq_exp1 = e1;exp_seq_exp2 = e2;},r)

	          | While b ->
		            let e1,r1 = helper n_arg b.exp_while_body in 
		            (While { b with exp_while_body = e1; }, r1)

	          | Try b ->
                    let e1,r1 = helper n_arg b.exp_try_body in 
                    let e2,r2 = helper n_arg b.exp_catch_clause in
		            (Try { b with exp_try_body = e1; exp_catch_clause=e2}, (comb_f [r1;r2]))

  in helper init_arg e



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
  

let distributive_views : string list ref = ref ([])

let distributive c = List.mem c !distributive_views

let add_distributive c = distributive_views := c :: !distributive_views

let void_type = Void

let int_type = Int

let infint_type = INFInt

let float_type = Float

let bool_type = Bool

let bag_type = (BagT Int)

let list_type = List Int

let place_holder = P.SpecVar (Int, "pholder___", Unprimed)

(* smart constructors *)
(*let mkMultiSpec pos = [ SEnsure {
		sensures_base = Cformula.mkTrue pos;
		sensures_pos = pos;
	}]*)
let stub_branch_point_id s = (-1,s)
let mkEAssume pos = 
	let f = Cformula.mkTrue (Cformula.mkTrueFlow ()) pos in
	Cformula.mkEAssume [] f (Cformula.mkEBase f None no_pos) (stub_branch_point_id "") None
 
let mkEAssume_norm pos = 
	let f = Cformula.mkTrue (Cformula.mkNormalFlow ()) pos in
	(* let sf = Cformula.mkEBase f None no_pos in *)
	Cformula.mkEAssume [] f (Cformula.mkEBase f None no_pos) (stub_branch_point_id "") None
	
let mkSeq t e1 e2 pos = match e1 with
  | Unit _ -> e2
  | _ -> match e2 with
	  | Unit _ -> e1
	  | _ -> Seq ({exp_seq_type = t; exp_seq_exp1= e1; exp_seq_exp2 = e2; exp_seq_pos = pos})

(* utility functions *)

let is_var (e : exp) = match e with Var _ -> true | _ -> false

(* An Hoa : for array access a[i], the var is a *)
let get_var (e : exp) = match e with 
	| Var ({exp_var_type = _; exp_var_name = v; exp_var_pos = _}) -> v
	| _ -> failwith ("get_var: can't get identifier")

let is_block (e : exp) : bool = match e with Block _ -> true | _ -> false

let is_call (e : exp) : bool = match e with SCall _ -> true | _ -> false

let is_new (e : exp) : bool = match e with New _ -> true | _ -> false

let is_unit (e : exp) : bool = match e with Unit _ -> true | _ -> false

let is_cond (e : exp) : bool = match e with Cond _ -> true | _ -> false

let rec type_of_exp (e : exp) = match e with
  | Label b -> type_of_exp b.exp_label_exp
  | CheckRef _ -> None
  | Java _ -> None
  | Assert _ -> None
	(*| ArrayAt b -> Some b.exp_arrayat_type (* An Hoa *)*)
	(*| ArrayMod _ -> Some void_type (* An Hoa *)*)
  | Assign _ -> Some void_type
  | Barrier _ -> Some void_type
  | BConst _ -> Some bool_type
  | Bind ({exp_bind_type = t; 
		   exp_bind_bound_var = _; 
		   exp_bind_fields = _;
		   exp_bind_body = _;
		   exp_bind_pos = _}) -> Some t
  | Block ({exp_block_type = t;
			exp_block_body = _;
			exp_block_local_vars = _;
			exp_block_pos = _}) -> Some t
  | ICall ({exp_icall_type = t;
			exp_icall_receiver = _;
			exp_icall_method_name = _;
			exp_icall_arguments = _;
			exp_icall_pos = _}) -> Some t
  | Cast ({exp_cast_target_type = t}) -> Some t
  | Catch _ -> Some void_type
  | Cond ({exp_cond_type = t;
		   exp_cond_condition = _;
		   exp_cond_then_arm = _;
		   exp_cond_else_arm = _;
		   exp_cond_pos = _}) -> Some t
  | Debug _ -> None
  | Dprint _ -> None
  | FConst _ -> Some float_type
	  (*| FieldRead (t, _, _, _) -> Some t*)
	  (*| FieldWrite _ -> Some Void*)
  | IConst _ -> Some int_type
	(* An Hoa *)
	(* | ArrayAlloc ({exp_aalloc_etype = t; 
		  exp_aalloc_dimension = _; 
		  exp_aalloc_pos = _}) -> Some (P.Array t) *)
  | New ({exp_new_class_name = c; 
		  exp_new_arguments = _; 
		  exp_new_pos = _}) -> Some (Named c) (*---- ok? *)
  | Null _ -> Some (Named "")
	| EmptyArray b -> Some (Array (b.exp_emparray_type, b.exp_emparray_dim)) (* An Hoa *)
  | Print _ -> None
 (* | Return ({exp_return_type = t; 
			 exp_return_val = _; 
			 exp_return_pos = _}) -> Some t*)
  | SCall ({exp_scall_type = t;
			exp_scall_method_name = _;
			exp_scall_arguments = _;
			exp_scall_pos = _}) -> Some t
  | Seq ({exp_seq_type = t; exp_seq_exp1 = _; exp_seq_exp2 = _; exp_seq_pos = _}) -> Some t
  | This ({exp_this_type = t}) -> Some t
  | Var ({exp_var_type = t; exp_var_name = _; exp_var_pos = _}) -> Some t
  | VarDecl _ -> Some void_type
  | Unit _ -> Some void_type
  | While _ -> Some void_type
  | Unfold _ -> Some void_type
  | Try _ -> Some void_type
  | Time _ -> None
  | Sharp b -> Some b.exp_sharp_type

and is_transparent e = match e with
  | Assert _ | Assign _ | Debug _ | Print _ -> true
  | _ -> false

(* let rec name_of_type (t : typ) = match t with *)
(*   | Prim Int -> "int" *)
(*   | Prim Bool -> "bool" *)
(*   | Prim Void -> "void" *)
(*   | Prim Float -> "float" *)
(*   | Prim (BagT t) -> "bag("^(name_of_type (Prim t))^")" *)
(*   | Prim (TVar i) -> "TVar["^(string_of_int i)^"]" *)
(*   | Prim List -> "list" *)
(*   | Named c -> c *)
(*   | Array (et, _) -> (name_of_type et) ^ "[]" (\* An hoa *\)  *)

let mingle_name (m : ident) (targs : typ list) = 
  let param_tnames = String.concat "~" (List.map string_of_typ targs) in
	m ^ "$" ^ param_tnames

let unmingle_name (m : ident) = 
  try
	let i = String.index m '$' in
	  String.sub m 0 i
  with
	| Not_found -> m

let rec look_up_view_def_raw (defs : view_decl list) (name : ident) = match defs with
  | d :: rest -> if d.view_name = name then d else look_up_view_def_raw rest name
  | [] -> raise Not_found

let look_up_view_def_raw i (defs : view_decl list) (name : ident) = 
  let pr = fun x -> x in
  let pr_out = !print_view_decl in
  Debug.no_1_num i "look_up_view_def_raw" pr pr_out (fun _ -> look_up_view_def_raw defs name) name

let look_up_view_def_ext_size (defs : view_decl list) num_rec_br0 num_base0 =
  let ext_views = List.filter (fun v ->
      let b1 = v.view_kind=View_EXTN && List.length v.view_prop_extns = 1 in
      let num_base = match v.view_base_case with
        | None -> 0
        | Some _ -> 1
      in
      let num_rec_br = List.length v.view_un_struc_formula - num_base in
      b1 && (num_rec_br0 = num_rec_br) && (num_base0 = num_base)
  ) defs in
  ext_views

let look_up_view_inv defs act_args name inv_compute_fnc =
  let vdcl = look_up_view_def_raw 46 defs name in
  let ss = List.combine ((P.SpecVar (Named vdcl.view_data_name, self, Unprimed))::vdcl.view_vars) act_args in
  let inv =
    let p1 = MP.pure_of_mix vdcl.view_user_inv in
    if P.isConstTrue p1 then
      (*make sure inv is not computed*)
      if !Globals.do_infer_inv then
        MP.pure_of_mix vdcl.view_x_formula
      else
        try
          (*case Globals.do_infer_inv = false*)
          let _ = Globals.do_infer_inv := true in
          let new_pf = inv_compute_fnc name vdcl.view_vars vdcl.view_un_struc_formula p1 in
          let _ = Globals.do_infer_inv := false in
          new_pf
        with _ -> p1
    else p1
  in
  P.subst ss inv

(* An Hoa *)
let rec look_up_rel_def_raw (defs : rel_decl list) (name : ident) = match defs with
  | d :: rest -> if d.rel_name = name then d else look_up_rel_def_raw rest name
  | [] -> raise Not_found

let rec look_up_hp_def_raw_x (defs : hp_decl list) (name : ident) = match defs with
  | d :: rest -> if d.hp_name = name then d else look_up_hp_def_raw_x rest name
  | [] -> raise Not_found

let look_up_hp_def_raw defs name=
  let pr1 = !print_hp_decl in
  Debug.no_1 "look_up_hp_def_raw" pr_id pr1
      (fun _ -> look_up_hp_def_raw_x defs name) name

let look_up_hp_parts decls hp=
  let hp_dc = look_up_hp_def_raw decls hp in
  hp_dc.hp_part_vars

let look_up_hp_decl_data_name_x decls hp arg_pos=
  let rec look_up_data_name args n=
    match args with
      | [] -> report_error no_pos "Cast.look_up_hp_decl_data_name 1"
      | (sv,_)::rest ->( if n = arg_pos then
          match Cpure.type_of_spec_var sv with
            | Named id -> id
            | _ -> report_error no_pos "Cast.look_up_hp_decl_data_name: only pure-extend for pointer"
          else look_up_data_name rest (n+1)
        )
  in
  let hp_dcl = look_up_hp_def_raw decls hp in
  look_up_data_name hp_dcl.hp_vars_inst 0

let look_up_hp_decl_data_name decls hp arg_pos=
  Debug.no_2 "look_up_hp_decl_data_name" pr_id string_of_int pr_id
      (fun _ _ -> look_up_hp_decl_data_name_x decls hp arg_pos)
      hp arg_pos

let cmp_hp_def d1 d2 = String.compare d1.hp_name d2.hp_name = 0

let generate_pure_rel hprel=
  let n_p_hprel ={
      rel_name = default_prefix_pure_hprel ^ hprel.hp_name;
      rel_vars = List.map fst hprel.hp_vars_inst;
      rel_formula = F.get_pure hprel.hp_formula;
  }
  in
  (*add map*)
  let _ = pure_hprel_map := !pure_hprel_map@[(hprel.hp_name, n_p_hprel.rel_name)] in
  let _= Smtsolver.add_relation n_p_hprel.rel_name n_p_hprel.rel_vars n_p_hprel.rel_formula in
  n_p_hprel

let add_raw_hp_rel_x prog is_pre is_unknown unknown_ptrs pos=
  if (List.length unknown_ptrs > 0) then
    let hp_decl =
      { hp_name = (if is_unknown then Globals.unkhp_default_prefix_name else
        if is_pre then Globals.hp_default_prefix_name else hppost_default_prefix_name)
        ^ (string_of_int (Globals.fresh_int()));
      hp_part_vars = [];
      hp_root_pos = 0; (*default, reset when def is inferred*)
      hp_vars_inst = unknown_ptrs;
      hp_is_pre = is_pre;
      hp_formula = F.mkBase F.HEmp (MP.mkMTrue pos) F.TypeTrue (F.mkTrueFlow()) [] pos;}
    in
    let unk_args = (fst (List.split hp_decl.hp_vars_inst)) in
    prog.prog_hp_decls <- (hp_decl :: prog.prog_hp_decls);
    (* PURE_RELATION_OF_HEAP_PRED *)
    let p_hp_decl = generate_pure_rel hp_decl in
    let _ = prog.prog_rel_decls <- (p_hp_decl::prog.prog_rel_decls) in
    Smtsolver.add_hp_relation hp_decl.hp_name unk_args hp_decl.hp_formula;
    let hf =
      F.HRel (P.SpecVar (HpT,hp_decl.hp_name, Unprimed), 
               List.map (fun sv -> P.mkVar sv pos) unk_args,
      pos)
    in
    let _ = Debug.tinfo_hprint (add_str "define: " !print_hp_decl) hp_decl pos in
    Debug.ninfo_zprint (lazy (("       gen hp_rel: " ^ (!F.print_h_formula hf)))) pos;
    (hf, P.SpecVar (HpT,hp_decl.hp_name, Unprimed))
  else report_error pos "sau.add_raw_hp_rel: args should be not empty"

let add_raw_hp_rel prog is_pre is_unknown unknown_args pos=
  let pr1 = pr_list (pr_pair !P.print_sv print_arg_kind) in
  let pr2 = !F.print_h_formula in
  let pr4 (hf,_) = pr2 hf in
  Debug.no_1 "add_raw_hp_rel" pr1 pr4
      (fun _ -> add_raw_hp_rel_x prog is_pre is_unknown unknown_args pos) unknown_args

let set_proot_hp_def_raw r_pos defs name=
  let hpdclr = look_up_hp_def_raw defs name in
  let _ = hpdclr.hp_root_pos <- r_pos in
  hpdclr

let get_proot_hp_def_raw defs name=
  let hpdclr = look_up_hp_def_raw defs name in
  hpdclr.hp_root_pos

let get_root_args_hprel hprels hp_name actual_args=
  let rec part_sv_from_pos ls n n_need rem=
    match ls with
      | [] -> report_error no_pos "sau.get_sv_from_pos"
      | sv1::rest -> if n = n_need then (sv1, rem@rest)
        else part_sv_from_pos rest (n+1) n_need (rem@[sv1])
  in
  let retrieve_root hp_name args=
    let rpos = get_proot_hp_def_raw hprels hp_name in
    let r,paras = part_sv_from_pos args 0 rpos [] in
    (r,paras)
  in
  retrieve_root hp_name actual_args

let get_root_typ_hprel hprels hp_name=
  let rec part_sv_from_pos ls n n_need rem=
    match ls with
      | [] -> report_error no_pos "sau.get_sv_from_pos"
      | sv1::rest -> if n = n_need then (sv1, rem@rest)
        else part_sv_from_pos rest (n+1) n_need (rem@[sv1])
  in
  let retrieve_root hp_name=
    let hpdclr = look_up_hp_def_raw hprels hp_name in
    let rpos = hpdclr.hp_root_pos in
    let r,_ = part_sv_from_pos (List.map fst hpdclr.hp_vars_inst) 0 rpos [] in
    match Cpure.type_of_spec_var r with
      | Named id -> id
      | _ -> ""
  in
  retrieve_root hp_name

let check_pre_post_hp defs hp_name=
  let hpdecl = look_up_hp_def_raw defs hp_name in
  hpdecl.hp_is_pre

let rec look_up_view_def (pos : loc) (defs : view_decl list) (name : ident) = match defs with
  | d :: rest -> 
	    if d.view_name = name then d 
	    else look_up_view_def pos rest name
  | [] -> Error.report_error {Error.error_loc = pos;
	Error.error_text = name ^ " is not a view definition"}

let look_up_view_def_num i (pos : loc) (defs : view_decl list) (name : ident) = 
  Debug.no_1_num i "look_up_view_def" pr_id pr_no 
      (fun _ -> look_up_view_def pos defs name) name

let collect_rhs_view (n:ident) (e:F.struc_formula) : (ident * ident list) =
  let f_comb = List.concat in
  let f e = match e with 
    | F.ViewNode {F.h_formula_view_name = n} -> Some [n] 
    | _ -> None in
  let f_heap e = F.fold_h_formula e f f_comb in
   (n, F.foldheap_struc_formula f_heap f_comb e)

let collect_rhs_view (n:ident) (f:F.struc_formula) : (ident * ident list) =
  let id x = x in
  let pr1 x = x in
  let pr2 = pr_pair id (pr_list id) in 
  Debug.no_1 "collect_rhs_view" pr1 pr2 (fun _ -> collect_rhs_view n f) n

let is_self_rec_rhs (lhs:ident) (rhs:F.struc_formula) : bool =
  let  (_,ns) = collect_rhs_view lhs rhs in
  List.mem lhs ns

let is_self_rec_rhs (lhs:ident) (rhs:F.struc_formula) : bool =
  Debug.no_1 "is_self_rec_rhs" (fun x -> x) (string_of_bool) (fun _ -> is_self_rec_rhs lhs rhs) lhs

(* pre: name exists as a view in prog *)
let is_rec_view_def prog (name : ident) : bool = 
   let vdef = look_up_view_def_num 2 no_pos prog.prog_view_decls name in
   (* let _ = collect_rhs_view vdef in *)
   vdef.view_is_rec

(*check whether a view is a lock invariant*)
let get_lock_inv prog (name : ident) : (bool * F.formula) =
  let vdef = look_up_view_def_raw 1 prog.prog_view_decls name in
  match vdef.view_inv_lock with
    | None -> (false, (F.mkTrue (F.mkTrueFlow ()) no_pos))
    | Some f -> (true, f)

let is_lock_inv prog (name : ident) : bool =
  let vdef = look_up_view_def_raw 2 prog.prog_view_decls name in
  match vdef.view_inv_lock with
    | None -> false
    | Some f -> true

let self_param vdef = P.SpecVar (Named vdef.view_data_name, self, Unprimed) 

let look_up_view_baga prog (c : ident) (root:P.spec_var) (args : P.spec_var list) : P.spec_var list = 
  let vdef = look_up_view_def no_pos prog.prog_view_decls c in
  let ba = vdef.view_baga in
  (* let _ = print_endline (" look_up_view_baga: baga= " ^ (!print_svl ba)) in *)
  let from_svs = (self_param vdef) :: vdef.view_vars in
  let to_svs = root :: args in
  P.subst_var_list_avoid_capture from_svs to_svs ba

let look_up_view_baga  prog (c : ident) (root:P.spec_var) (args : P.spec_var list) : P.spec_var list = 
      Debug.no_2 "look_up_view_baga" (fun v -> !print_svl [v]) !print_svl !print_svl 
      (fun r a ->  look_up_view_baga prog c r a) root args

let rec look_up_data_def pos (ddefs : data_decl list) (name : string) = match ddefs with
  | d :: rest -> 
	  if d.data_name = name then d 
	  else look_up_data_def pos rest name
  | [] -> Error.report_error {Error.error_loc = pos;
							  Error.error_text = name ^ " is not a data/class declaration"}

let look_up_extn_info_rec_field_x ddefs dname=
  let rec look_up_helper fields=
    match fields with
      | ((t,_), extns)::rest -> begin
          match t with
            | Named id1 -> if String.compare id1 dname = 0 then
                extns
              else look_up_helper rest
            | _ -> look_up_helper rest
        end
      | [] -> raise Not_found
  in
  let dd = look_up_data_def no_pos ddefs dname in
  let _ = Debug.ninfo_hprint (add_str "    dd.data_fields:" (pr_list (pr_pair (pr_pair string_of_typ pr_id) (pr_list pr_id))))
      dd.data_fields no_pos in
  try
    look_up_helper dd.data_fields
  with _ ->
      let (_, extns) = List.hd dd.data_fields in
      extns

let look_up_extn_info_rec_field ddefs dname=
  Debug.no_1 "look_up_extn_info_rec_field" pr_id (pr_list pr_id)
      (fun _ -> look_up_extn_info_rec_field_x ddefs dname)
      dname

let rec look_up_parent_name pos ddefs name =
  let ddef = look_up_data_def pos ddefs name in
	ddef.data_parent_name

(*
let rec look_up_proc_def_raw (procs : proc_decl list) (name : string) = match procs with
  | p :: rest ->
      if p.proc_name = name then
		p
      else
		look_up_proc_def_raw rest name
  | [] -> raise Not_found
*)

let rec look_up_proc_def_raw (procs : (ident, proc_decl) Hashtbl.t) (name : string) = 
  Hashtbl.find procs name 

(*			  
let rec look_up_proc_def pos (procs : proc_decl list) (name : string) = match procs with
  | p :: rest ->
      if p.proc_name = name then
		p
      else
		look_up_proc_def pos rest name
  | [] -> Error.report_error {Error.error_loc = pos;
							  Error.error_text = "procedure " ^ name ^ " is not found"}
*)

let rec look_up_proc_def pos (procs : (ident, proc_decl) Hashtbl.t) (name : string) = 
  try Hashtbl.find procs name 
	with Not_found -> Error.report_error {
    Error.error_loc = pos;
    Error.error_text = "look_up_proc_def: Procedure " ^ name ^ " is not found."}
let look_up_hpdefs_proc (procs : (ident, proc_decl) Hashtbl.t) (name : string) = 
  try
      let proc = Hashtbl.find procs name in
      proc.proc_hpdefs
  with Not_found -> Error.report_error {
      Error.error_loc = no_pos;
      Error.error_text = "look_up_hpdefs_proc: Procedure " ^ name ^ " is not found."}

let update_hpdefs_proc (procs : (ident, proc_decl) Hashtbl.t) hpdefs (name : string) = 
  try
      let proc = Hashtbl.find procs name in
      (* let new_proc = {proc with proc_hpdefs = proc.proc_hpdefs@hpdefs} in *)
      let _ = proc.proc_hpdefs <- proc.proc_hpdefs@hpdefs in ()
      (* Hashtbl.replace procs name proc *)
  with Not_found -> Error.report_error {
      Error.error_loc = no_pos;
      Error.error_text = "update_hpdefs_proc: Procedure " ^ name ^ " is not found."}

let look_up_callee_hpdefs_proc (procs : (ident, proc_decl) Hashtbl.t) (name : string) = 
  try
      let proc = Hashtbl.find procs name in
      proc.proc_callee_hpdefs
  with Not_found -> []
(* Error.report_error { *)
      (* Error.error_loc = no_pos; *)
      (* Error.error_text = "Procedure " ^ name ^ " is not found."} *)

let update_callee_hpdefs_proc (procs : (ident, proc_decl) Hashtbl.t) caller_name (callee_name : string) = 
  try
      let hpdefs = look_up_hpdefs_proc procs callee_name in
      let proc = Hashtbl.find procs caller_name in
      (* let new_proc = {proc with proc_callee_hpdefs = proc.proc_callee_hpdefs@hpdefs} in *)
      let _ = proc.proc_callee_hpdefs <- proc.proc_callee_hpdefs@hpdefs in ()
      (* Hashtbl.replace procs name new_proc *)
  with Not_found -> Error.report_error {
      Error.error_loc = no_pos;
      Error.error_text = "update_callee_hpdefs_proc: Procedure " ^ caller_name ^ " is not found."}

(* Replaced by the new function with Hashtbl *)
(*
let rec look_up_proc_def_no_mingling pos (procs : proc_decl list) (name : string) = match procs with
  | p :: rest ->
	  if unmingle_name p.proc_name = name then p
	  else look_up_proc_def_no_mingling pos rest name
  | [] -> Error.report_error {Error.error_loc = pos;
							  Error.error_text = "procedure " ^ name ^ " is not found"}
*)
let rec look_up_proc_def_no_mingling pos (procs : (ident, proc_decl) Hashtbl.t) (name : string) = 
  let proc = Hashtbl.fold (fun i p acc -> 
    match acc with
    | None -> if unmingle_name i = name then Some p else None
    | Some _ -> acc
  ) procs None in
  match proc with
  | None -> Error.report_error {
      Error.error_loc = pos;
      Error.error_text = "look_up_proc_def_no_mingling: Procedure " ^ name ^ " is not found." }
  | Some p -> p
  
(* takes a class and returns the list of all the methods from that class or from any of the parent classes *)
and look_up_all_methods (prog : prog_decl) (c : data_decl) : proc_decl list = match c.data_name with 
  | "Object" -> [] (* it does not have a superclass *)
  | _ ->  
      let cparent_decl = List.find (fun t -> (String.compare t.data_name c.data_parent_name) = 0) prog.prog_data_decls in
        c.data_methods @ (look_up_all_methods prog cparent_decl)  

(*
  coers: a list of coercion rules (proc_coercion must be true)
*)
(*
let rec look_up_distributive_def_raw coers (c : ident) : (F.formula * F.formula) list = match coers with
  | p :: rest -> begin
	  let rec find_formula coercion_list = match coercion_list with
		| (pc, (pre, post)) :: rest ->
			if pc = c then
			  Some (pre, post)
			else
			  find_formula rest
		| [] -> None 
	  in
	  let rest_coers = look_up_distributive_def_raw rest c in
		match find_formula p.proc_coercion_list with
		  | Some (pre, post) -> (pre, post) :: rest_coers
		  | None -> rest_coers
	end
  | [] -> []
*)
let lookup_view_invs rem_br v_def = 
  try 
    snd(snd (List.find (fun (c1,_)-> Gen.BList.list_setequal_eq (=) c1 rem_br) v_def.view_prune_invariants))
  with | Not_found -> []

let lookup_bar_invs_with_subs rem_br b_def zip  = 
  try 
    let v=snd(snd (List.find (fun (c1,_)-> Gen.BList.list_setequal_eq (=) c1 rem_br) b_def.barrier_prune_invariants)) in
    List.map (P.b_apply_subs zip) v
  with | Not_found -> []


let lookup_view_invs_with_subs rem_br v_def zip  = 
  try 
    let v=snd(snd (List.find (fun (c1,_)-> Gen.BList.list_setequal_eq (=) c1 rem_br) v_def.view_prune_invariants)) in
    List.map (P.b_apply_subs zip) v
  with | Not_found -> []

let lookup_view_baga_with_subs rem_br v_def from_v to_v  = 
  try 
    let v=fst(snd (List.find (fun (c1,_)-> Gen.BList.list_setequal_eq (=) c1 rem_br) v_def.view_prune_invariants)) in
    P.subst_var_list_avoid_capture from_v to_v v
  with | Not_found -> []

let look_up_coercion_def_raw coers (c : ident) : coercion_decl list = 
  List.filter (fun p ->  p.coercion_head_view = c ) coers
  
let look_up_coercion_def_raw coers (c : ident) : coercion_decl list =
  let pr1 = !print_coerc_decl_list in
	(* let pr1 l = string_of_int (List.length l) in *)
	Debug.no_2 "look_up_coercion_def_raw" pr1 (fun c-> c) (fun c-> "") look_up_coercion_def_raw coers c
  (* match coers with *)
  (* | p :: rest -> begin *)
  (*     let tmp = look_up_coercion_def_raw rest c in *)
  (*   	if p.coercion_head_view = c then p :: tmp *)
  (*   	else tmp *)
  (*   end *)
  (* | [] -> [] *)

(*
  a coercion can be simple, complex or normalizing
  Note that:
  Complex + Left == normalization
*)
(*TODO: re-implement with care*)
let case_of_coercion_x (lhs:F.formula) (rhs:F.formula) : coercion_case =
  let h,_,_,_,_ = F.split_components lhs in
  let hs = F.split_star_conjunctions h in
  let flag = if (List.length hs) == 1 then 
	    let sm = List.hd hs in (match sm with
	      | F.StarMinus _ -> true
	      | _ -> false)
	  else false in
  if(flag) then Ramify
  else
    let fct f = match f with
      | Cformula.Base {F.formula_base_heap=h}
      | Cformula.Exists {F.formula_exists_heap=h} ->      
          let _ = Debug.tinfo_hprint (add_str "formula_exists_heap" !print_h_formula ) h no_pos in 
          let hs = F.split_star_conjunctions h in
          let hs = List.filter (fun c -> not (c=F.HTrue || c=F.HEmp)) hs in
	      let self_n = List.for_all (fun c-> 
              let _ = Debug.tinfo_hprint (add_str "c" !print_h_formula ) c no_pos in
              let only_self = match c with
                | F.DataNode _
                | F.ViewNode _-> (P.name_of_spec_var (F.get_node_var c)) = self 
                | F.HRel (sv,exp_lst,_) -> (
                    let _ = Debug.tinfo_hprint (add_str "sv" !print_sv ) sv no_pos in
                    match exp_lst with
                      | [sv] -> (
                          match sv with
                            | (P.Var (v,_)) -> (P.name_of_spec_var v) = self
                            | _ -> false)
                      | _ -> false
                )
                | _ -> failwith ("Only nodes and HRel allowed after split_star_conjunctions ") 
              in
              only_self) hs  in
          let get_name h = match h with
            | F.DataNode _
            | F.ViewNode _-> F.get_node_name h
            | F.HRel (sv,exp_lst,_) -> P.name_of_spec_var sv
            | _ -> failwith ("Only nodes and HRel allowed after split_star_conjunctions ") in
          (List.length hs),self_n, List.map get_name hs
      | _ -> 1,false,[]
    in
    (*length = #nodes, sn = is there a self node, typ= List of names of nodes*)
    let lhs_length,l_sn,lhs_typ = fct lhs in
    let rhs_length,r_sn,rhs_typ = fct rhs in
    match lhs_typ@rhs_typ with
	  | [] -> Simple
	| h::t ->
        (*
          Why using concret numbers (e.g. 1,2) here ?
          If there is a lemma that split 1 node into 3 nodes,
          it is also considered a split lemma?
        *)
        (*special case, detecting inconsistency using lemmas*)
        if rhs_length=0  then Normalize true else 
		if l_sn && r_sn && (List.for_all (fun c-> h=c) t) then
            (*all nodes having the same names*)
            (* ??? why using the node names *)
			if lhs_length=2 && rhs_length=1  then Normalize true
			else if lhs_length=1 && rhs_length=2  then Normalize false
			else if lhs_length=1 then Simple
			else Complex
		else if lhs_length=1 then Simple
			else Complex
		
let case_of_coercion lhs rhs =
	let pr1 r = match r with | Simple -> "simple" | Complex -> "complex" | Ramify -> "ramify" | Normalize b-> "normalize "^string_of_bool b in
	Debug.no_2 "case_of_coercion" !Cformula.print_formula !Cformula.print_formula pr1 case_of_coercion_x lhs rhs  

let  look_up_coercion_with_target coers (c : ident) (t : ident) : coercion_decl list = 
    List.filter (fun p ->  p.coercion_head_view = c && p.coercion_body_view = t  ) coers

let  look_up_coercion_with_target coers (c : ident) (t : ident) : coercion_decl list = 
  let pr1 = pr_list !print_coercion in
  Debug.no_3 "look_up_coercion_with_target" (fun x-> x)  (fun x-> x) pr1 pr1 
    (fun _ _ _ -> look_up_coercion_with_target coers c t) c t coers
 
let rec callees_of_proc (prog : prog_decl) (name : ident) : ident list =
  (*let pdef = look_up_proc_def_no_mingling no_pos prog.old_proc_decls name in*)
  let pdef = look_up_proc_def_no_mingling no_pos prog.new_proc_decls name in
  let callees = match pdef.proc_body with
	  | Some e -> callees_of_exp e
	  | None -> [] 
  in
	callees

and callees_of_exp (e0 : exp) : ident list = match e0 with
  | Label e -> callees_of_exp e.exp_label_exp
  | CheckRef _ -> []
  | Java _ -> []
  | Assert _ -> []
	(* AN HOA *)
	(*| ArrayAt ({exp_arrayat_type = _;
			 exp_arrayat_array_base = _;
			 exp_arrayat_index = e;
			 exp_arrayat_pos = _; }) -> callees_of_exp e*)
	(*| ArrayMod ({exp_arraymod_lhs = l;
			 exp_arraymod_rhs = r;
			 exp_arraymod_pos = _}) -> U.remove_dups (callees_of_exp (ArrayAt l) @ callees_of_exp r)*)
  (* AN HOA *)
	| Assign ({exp_assign_lhs = _;
			 exp_assign_rhs = e;
			 exp_assign_pos = _}) -> callees_of_exp e
  | BConst _ -> []
  | Bind ({exp_bind_type = _;
		   exp_bind_bound_var = _;
		   exp_bind_fields = _;
		   exp_bind_body = e;
		   exp_bind_pos = _}) -> callees_of_exp e
  | Block ({exp_block_type = _;
			exp_block_body = e;
			exp_block_local_vars = _;
			exp_block_pos = _}) -> callees_of_exp e
  | Barrier _ -> [] 
  | Cast ({exp_cast_body = e}) -> callees_of_exp e
  | Catch e-> callees_of_exp e.exp_catch_body
  | Cond ({exp_cond_type = _;
		   exp_cond_condition = _;
		   exp_cond_then_arm = e1;
		   exp_cond_else_arm = e2;
		   exp_cond_pos = _}) -> Gen.BList.remove_dups_eq (=) (callees_of_exp e1 @ callees_of_exp e2)
  | Debug _ -> []
  | Dprint _ -> []
  | FConst _ -> []
	  (*| FieldRead _ -> []*)
	  (*| FieldWrite _ -> []*)
  | ICall ({exp_icall_type = _;
			exp_icall_receiver = _;
			exp_icall_method_name = n;
			exp_icall_arguments = _;
			exp_icall_pos = _}) -> [unmingle_name n] (* to be fixed: look up n, go down recursively *)
  | IConst _ -> []
	(*| ArrayAlloc _ -> []*)
  | New _ -> []
  | Null _ -> []
	| EmptyArray _ -> [] (* An Hoa : empty array has no callee *)
  | Print _ -> []
  | Sharp b -> []
  | SCall ({exp_scall_type = _;
			exp_scall_method_name = n;
			exp_scall_arguments = _;
			exp_scall_pos = _}) -> [unmingle_name n]
  | Seq ({exp_seq_type = _;
		  exp_seq_exp1 = e1;
		  exp_seq_exp2 = e2;
		  exp_seq_pos = _}) -> Gen.BList.remove_dups_eq (=) (callees_of_exp e1 @ callees_of_exp e2)
  | This _ -> []
  | Time _ -> []
  | Var _ -> []
  | VarDecl _ -> []
  | Unit _ -> []
  | While ({exp_while_condition = _;
			exp_while_body = e;
			exp_while_spec = _;
			exp_while_pos = _ }) -> callees_of_exp e (*-----???*)
  | Try b -> Gen.BList.remove_dups_eq (=) ((callees_of_exp b.exp_try_body)@(callees_of_exp b.exp_catch_clause))
  | Unfold _ -> []

let procs_to_verify (prog : prog_decl) (names : ident list) : ident list =
  let tmp1 = List.map (callees_of_proc prog) names in
  let tmp2 = names @ (List.concat tmp1) in
  let tmp3 = Gen.BList.remove_dups_eq (=) tmp2 in
	tmp3


(*************************************************************)
(* Building the graph representing the class hierarchy       *)
(*************************************************************)

type ch_node = { ch_node_name : ident;
				 mutable ch_node_class : data_decl option;
				 mutable ch_node_coercion : proc_decl option (* coercion rule to the parent class *) }

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
	CH.add_edge class_hierarchy (CH.V.create {ch_node_name = cdef.data_name; 
											  ch_node_class = None; 
											  ch_node_coercion = None})
	  (CH.V.create {ch_node_name = cdef.data_parent_name; 
					ch_node_class = None; 
					ch_node_coercion = None}) in
  let _ = List.map add_edge prog.prog_data_decls in
	if TraverseCH.has_cycle class_hierarchy then begin
		print_string ("Class hierarchy has cycles");
		failwith ("Class hierarchy has cycles");
	  end 
	else begin
		(* now add class definitions in *)
		let update_node node = 
		  if not (node.ch_node_name = "") then
			let cdef = look_up_data_def no_pos prog.prog_data_decls node.ch_node_name in
			  node.ch_node_class <- Some cdef
		in
		  CH.iter_vertex update_node class_hierarchy
	  end

(*
  subnode: the sub class object to be converted to super class object plus
           extesions
  cdefs: list of class definition, going from super class to sub class
*)
let rec generate_extensions (subnode : F.h_formula_data) cdefs0 (pos:loc) : F.h_formula = match cdefs0 with
  | cdef1 :: _ -> begin
	  (* generate the first node *)
	  let sub_tvar = List.hd subnode.F.h_formula_data_arguments in
	  (* let sub_tvar_ann = List.hd subnode.F.h_formula_data_param_imm in *)
	  let sub_ext_var = List.hd (List.tl subnode.F.h_formula_data_arguments) in
		(* call gen_exts with sup_ext_var to link the 
		   head node with extensions *)
	  let heap_args = List.tl (List.tl subnode.F.h_formula_data_arguments) in
	  let n = List.length cdef1.data_fields in
	  let to_sup, rest_fields = Gen.split_at heap_args n in
	  let ext_name = gen_ext_name subnode.F.h_formula_data_name cdef1.data_name in
	  (*--- 09.05.2000 *)
	  let fn1 = fresh_var_name ext_name pos.start_pos.Lexing.pos_lnum in
		(*let _ = (print_string ("\n[cast.ml, line 556]: fresh name = " ^ fn1 ^ "!!!!!!!!!!!\n\n")) in*)
		(*09.05.2000 ---*)
	  let sup_ext_var = P.SpecVar (Named ext_name, fn1, Unprimed) in
	  let sup_h = F.DataNode ({F.h_formula_data_node = subnode.F.h_formula_data_node;
							   F.h_formula_data_name = cdef1.data_name;
							   F.h_formula_data_derv = subnode.F.h_formula_data_derv;
							   F.h_formula_data_imm = subnode.F.h_formula_data_imm;
                               F.h_formula_data_param_imm = subnode.F.h_formula_data_param_imm;
							   F.h_formula_data_perm = subnode.F.h_formula_data_perm; (*LDK*)
							   F.h_formula_data_origins = subnode.F.h_formula_data_origins;
							   F.h_formula_data_original = subnode.F.h_formula_data_original;
							   F.h_formula_data_arguments = sub_tvar :: sup_ext_var :: to_sup;
	                           F.h_formula_data_holes = []; (* An Hoa : Don't know what to do! *)
							   F.h_formula_data_label = subnode.F.h_formula_data_label;
                 F.h_formula_data_remaining_branches = None;
                 F.h_formula_data_pruning_conditions = [];
							   F.h_formula_data_pos = pos}) in
		(* generate extensions for the rest of the fields *)
	  let rec gen_exts top_p link_p args cdefs : F.h_formula = match cdefs with
		| cdef1 :: cdef2 :: rest -> begin
			let i = List.length cdef2.data_fields in
			let to_ext, rest_fields = Gen.split_at args i in
			let ext_name = gen_ext_name cdef1.data_name cdef2.data_name in
			  if Gen.is_empty rest then
				let ext_h = F.DataNode ({F.h_formula_data_node = top_p;
										 F.h_formula_data_name = ext_name;
										 F.h_formula_data_derv = subnode.F.h_formula_data_derv;
										 F.h_formula_data_imm = subnode.F.h_formula_data_imm;
                                         F.h_formula_data_param_imm = subnode.F.h_formula_data_param_imm;
										 F.h_formula_data_perm = subnode.F.h_formula_data_perm; (*LDK*)
							             F.h_formula_data_origins = subnode.F.h_formula_data_origins;
							             F.h_formula_data_original = subnode.F.h_formula_data_original;
										 F.h_formula_data_arguments = link_p :: to_ext;
						F.h_formula_data_holes = []; (* An Hoa : Don't know what to do! *)
										 F.h_formula_data_label = subnode.F.h_formula_data_label;
                     F.h_formula_data_remaining_branches = None;
                     F.h_formula_data_pruning_conditions = [];
										 F.h_formula_data_pos = pos}) in
				  ext_h
			  else
				let ext_link_name = gen_ext_name cdef2.data_name ((List.hd rest).data_name) in
				(*--- 09.05.2000 *)
	  		let fn2 = fresh_var_name ext_name pos.start_pos.Lexing.pos_lnum in
				(*let _ = (print_string ("\n[cast.ml, line 579]: fresh name = " ^ fn2 ^ "!!!!!!!!!!!\n\n")) in*)
				(*09.05.2000 ---*)
				let ext_link_p = P.SpecVar (Named ext_link_name, fn2, Unprimed) in
				let ext_h = F.DataNode ({F.h_formula_data_node = top_p;
										 F.h_formula_data_name = ext_name;
										 F.h_formula_data_derv = subnode.F.h_formula_data_derv;
										 F.h_formula_data_imm = subnode.F.h_formula_data_imm;
                                         F.h_formula_data_param_imm = subnode.F.h_formula_data_param_imm;
										 F.h_formula_data_perm = subnode.F.h_formula_data_perm;
							             F.h_formula_data_origins = subnode.F.h_formula_data_origins;
							             F.h_formula_data_original = subnode.F.h_formula_data_original;
										 F.h_formula_data_arguments = ext_link_p :: to_ext;
								F.h_formula_data_holes = []; (* An Hoa : Don't know what to do! *)
										 F.h_formula_data_label = subnode.F.h_formula_data_label;
                     F.h_formula_data_remaining_branches = None;
                     F.h_formula_data_pruning_conditions = [];
										 F.h_formula_data_pos = pos}) in
				let rest_exts = gen_exts ext_link_p link_p rest_fields (cdef2 :: rest) in
				let ext = F.mkStarH ext_h rest_exts pos in
				  ext
		  end
		| _ -> F.HEmp in
	  let exts = gen_exts sup_ext_var sub_ext_var rest_fields cdefs0 in
	  let res = F.mkStarH sup_h exts pos in
		res
	end
  | _ -> F.HEmp


(*
  Checks if c1 is subtype of c2 or the other way and returns the 
  list of classes going from c1 to c2 (or c2 to c1), including c2.

  If the first component of the result is true, c1 is subtype of c2.
  If it is false, c2 is subtype of c1
*)

let find_classes (c1 : ident) (c2 : ident) : (bool * data_decl list) = 
  let v1 = CH.V.create {ch_node_name = c1; ch_node_class = None; ch_node_coercion = None} in
  let v2 = CH.V.create {ch_node_name = c2; ch_node_class = None; ch_node_coercion = None} in
	try
	  let path, _ = PathCH.shortest_path class_hierarchy v1 v2 in
		(true, List.rev (List.map (fun e -> Gen.unsome ((CH.E.dst e).ch_node_class)) path))
	with
	  | Not_found -> 
		  try
			let path, _ = PathCH.shortest_path class_hierarchy v2 v1 in
			  (false, List.rev (List.map (fun e -> Gen.unsome ((CH.E.dst e).ch_node_class)) path))
		  with
			| Not_found -> failwith ("find_classes: " ^ c1 ^ " and " ^ c2 ^ " are not related!")


(* let rec sub_type (t1 : typ) (t2 : typ) = match t1 with *)
(*   | Named c1 -> begin match t2 with *)
(* 	    | Named c2 -> begin *)
(* 		    if c1 = c2 then true *)
(* 		    else if c1 = "" then true (\* t1 is null in this case *\) *)
(* 		    else  *)
(* 			  let v1 = CH.V.create {ch_node_name = c1;  *)
(* 								    ch_node_class = None;  *)
(* 								    ch_node_coercion = None} in *)
(* 			  let v2 = CH.V.create {ch_node_name = c2;  *)
(* 								    ch_node_class = None;  *)
(* 								    ch_node_coercion = None} in *)
(* 			  try *)
(* 				  let _ = PathCH.shortest_path class_hierarchy v1 v2 in *)
(* 				  true *)
(* 			  with *)
(* 				| Not_found -> false *)
(*         end *)
(*         | Array _ | _ -> false (\* An Hoa add P.Array _ *\) *)
(*   end *)
(* 	(\* An Hoa *\) *)
(*   | Array (et1, _) -> begin *)
(* 	  match t2 with *)
(* 		| Array (et2, _) -> (sub_type et1 et2) *)
(* 		| _ -> false *)
(*   end *)
(*   |  _ -> t1 = t2 *)

let sub_type (t1 : typ) (t2 : typ) = sub_type t1 t2

and exp_to_check (e:exp) :bool = match e with
  | CheckRef _
  | Debug _
  | Dprint _
  | Bind _
  | Seq _
  | Unfold _
  | Unit _
  | Print _
  | VarDecl _
  | Cast _
  | Catch _
  | Block _
  | FConst _
  | Assert _ 
  | Cond _
  | Try _ 
  | Time _ 
  | Java _ -> false
  
  | Barrier _ 
  | BConst _
	      (*| ArrayAt _ (* An Hoa TODO NO IDEA *)*)
	      (*| ArrayMod _ (* An Hoa TODO NO IDEA *)*)
  | Assign _
  | ICall _
  | IConst _
  | While _ 
  | This _
  | Var _
  | Null _
  | EmptyArray _ (* An Hoa : NO IDEA *)
	(*| ArrayAlloc _*) (* An Hoa : NO IDEA *)
  | New _
  | Sharp _
  | SCall _
  | Label _
      -> true
  
  
let rec pos_of_exp (e:exp) :loc = match e with
	(*| ArrayAt b -> b.exp_arrayat_pos (* An Hoa *)*)
	(*| ArrayMod b -> b.exp_arraymod_pos (* An Hoa *)*)
  | CheckRef b -> b.exp_check_ref_pos
  | BConst b -> b.exp_bconst_pos
  | Bind b -> b.exp_bind_pos
  | Cast b -> b.exp_cast_pos
  | Catch b -> b.exp_catch_pos
  | Debug b -> b.exp_debug_pos
  | Dprint b -> b.exp_dprint_pos
  | Assign b -> b.exp_assign_pos
  | FConst b -> b.exp_fconst_pos
  | ICall b -> b.exp_icall_pos
  | IConst b -> b.exp_iconst_pos
  | Print (_,b) -> b
  | Seq b -> b.exp_seq_pos
  | VarDecl b -> b.exp_var_decl_pos
  | Unfold b -> b.exp_unfold_pos
  | Unit b -> b
  | This b -> b.exp_this_pos
  | Time (_,_,p)-> p
  | Var b -> b.exp_var_pos
  | Null b -> b
	| EmptyArray b -> b.exp_emparray_pos (* An Hoa *)
  | Cond b -> b.exp_cond_pos
  | Block b -> b.exp_block_pos
  | Barrier b -> b.exp_barrier_pos
  | Java b  -> b.exp_java_pos
  | Assert b -> b.exp_assert_pos
  | New b -> b.exp_new_pos
  | Sharp b -> b.exp_sharp_pos
  | SCall b -> b.exp_scall_pos
  | While b -> b.exp_while_pos
  | Try b -> b.exp_try_pos
  | Label b -> pos_of_exp b.exp_label_exp
	  
let get_catch_of_exp e = match e with
	| Catch e -> e
	| _  -> Error.report_error {Err.error_loc = pos_of_exp e; Err.error_text = "malformed expression, expecting catch clause"}
  
(* let get_catch_of_exp e = *)
(*   let pr = !print_prog_exp in *)
(*   Debug.no_1 "get_catch_of_exp" pr pr_no get_catch_of_exp e *)

let check_proper_return cret_type exc_list f = 
  let overlap_flow_type fl res_t = match res_t with 
	| Named ot -> F.overlapping fl (exlist # get_hash ot)
	| _ -> false in
  let rec check_proper_return_f f0 = match f0 with
	| F.Base b->
		  let res_t,b_rez = F.get_result_type f0 in
		  let fl_int = b.F.formula_base_flow.F.formula_flow_interval in
		  if b_rez & not(F.equal_flow_interval !error_flow_int fl_int)
            & not(F.equal_flow_interval !top_flow_int fl_int) then
			if (F.equal_flow_interval !norm_flow_int fl_int) then 
			  if not (sub_type res_t cret_type) then 					
				Err.report_error{Err.error_loc = b.F.formula_base_pos;Err.error_text ="result type does not correspond with the return type";}
			  else ()
			else if not (List.exists (fun c-> 
                (* let _ =print_endline "XX" in *) F.subsume_flow c fl_int) exc_list) then
			  Err.report_error{Err.error_loc = b.F.formula_base_pos;Err.error_text ="the result type is not covered by the throw list";}
			else if not(overlap_flow_type fl_int res_t) then
			  Err.report_error{Err.error_loc = b.F.formula_base_pos;Err.error_text ="result type does not correspond (overlap) with the flow type";}
			else ()			
		  else 
			(*let _ =print_string ("\n ("^(string_of_int (fst fl_int))^" "^(string_of_int (snd fl_int))^"="^(Exc.get_closest fl_int)^
			  (string_of_bool (Cpure.is_void_type res_t))^"\n") in*)
			if not(((F.equal_flow_interval !norm_flow_int fl_int)&&(Cpure.is_void_type res_t))|| (not (F.equal_flow_interval !norm_flow_int fl_int))) then 
			  Error.report_error {Err.error_loc = b.F.formula_base_pos; Err.error_text ="no return in a non void function or for a non normal flow"}
			else ()
	| F.Exists b->
		  let res_t,b_rez = F.get_result_type f0 in
		  let fl_int = b.F.formula_exists_flow.F.formula_flow_interval in
		  if b_rez then
			if (F.equal_flow_interval !norm_flow_int fl_int) then 
			  if not (sub_type res_t cret_type) then 					
				Err.report_error{Err.error_loc = b.F.formula_exists_pos;Err.error_text ="result type does not correspond with the return type";}
			  else ()
			else 
			  if not (List.exists (fun c-> F.subsume_flow c fl_int) exc_list) then
				Err.report_error{Err.error_loc = b.F.formula_exists_pos;Err.error_text ="not all specified flow types are covered by the throw list";}
			  else if not(overlap_flow_type fl_int res_t) then
				Err.report_error{Err.error_loc = b.F.formula_exists_pos;Err.error_text ="result type does not correspond with the flow type";}
			  else ()			
		  else 
			(* let _ =print_string ("\n ("^(string_of_int (fst fl_int))^" "^(string_of_int (snd fl_int))^"="^(Exc.get_closest fl_int)^
			   (string_of_bool (Cpure.is_void_type res_t))^"\n") in*)
			if not(((F.equal_flow_interval !norm_flow_int fl_int)&&(Cpure.is_void_type res_t))|| (not (F.equal_flow_interval !norm_flow_int fl_int))) then 
			  Error.report_error {Err.error_loc = b.F.formula_exists_pos;Err.error_text ="no return in a non void function or for a non normal flow"}
			else ()			
	| F.Or b-> check_proper_return_f b.F.formula_or_f1 ; check_proper_return_f b.F.formula_or_f2 in
  let rec helper f0 = match f0 with 
	| F.EBase b   -> (match b.F.formula_struc_continuation with | None -> () | Some l -> helper l)
	| F.ECase b   -> List.iter (fun (_,c)-> helper c) b.F.formula_case_branches
	| F.EAssume b -> 
			if (F.isAnyConstFalse b.F.formula_assume_simpl)||(F.isAnyConstTrue b.F.formula_assume_simpl) then () 
			else check_proper_return_f b.F.formula_assume_simpl
	| F.EInfer b  -> ()(*check_proper_return cret_type exc_list b.formula_inf_continuation*)
	| F.EList b   -> List.iter (fun c-> helper(snd c)) b 
	in
  helper f

 
(* type: Globals.typ -> Globals.nflow list -> F.struc_formula -> unit *)
let check_proper_return cret_type exc_list f = 
  let pr1 = pr_list pr_no in
  let pr2 = !print_struc_formula in
  Debug.no_2 "check_proper_return" pr1 pr2 pr_no (fun _ _ -> check_proper_return cret_type exc_list f) exc_list f
(* TODO : res must be consistent with flow outcome *)

let formula_of_unstruc_view_f vd = F.formula_of_disjuncts (fst (List.split vd.view_un_struc_formula))


let vdef_fold_use_bc prog ln2  = match ln2 with
  | F.ViewNode vn -> 
    (try 
      let vd = look_up_view_def_raw 3 prog.prog_view_decls vn.F.h_formula_view_name in
      match vd.view_raw_base_case with
        | None -> None
        | Some f-> Some {vd with view_formula = F.formula_to_struc_formula f}
    with  
    | Not_found -> report_error no_pos ("fold: view def not found:"^vn.F.h_formula_view_name^"\n"))
  | _ -> None

let vdef_fold_use_bc prog ln2  = 
  let pr1 x = "?" in
  let pr2 x = match x with
    | None -> "None"
    | Some f -> !print_struc_formula f.view_formula in
  Debug.no_1 "vdef_fold_use_bc" pr1 pr2 (fun _ -> vdef_fold_use_bc prog ln2) ln2

(* WN : this helps build a vdef to perform right lemma folding *)
(* This will make sure that the variables in coer
coincide with the variables in the corresponding
view definition
   In the present of permissions, this may not hold
   as the LHS of a view definition does not have permissions
   while the LHS of a coer does.
*)

let vdef_lemma_fold prog coer  = 
  let cfd = coer.coercion_fold_def in
  let lhs = coer.coercion_head in
  (* body contains orig=false but not body_norm*)
  let rhs = CF.formula_to_struc_formula coer.coercion_body in
  (* let _ = Debug.info_hprint (add_str "head" Cprinter.string_of_formula) lhs no_pos in *)
  (* let _ = Debug.info_hprint (add_str "body" Cprinter.string_of_struc_formula) rhs no_pos in *)
  if cfd # is_init then cfd # get
  else
    let vd2 = match lhs with
      | CF.Base bf ->
            begin
              match bf.CF.formula_base_heap with
                | CF.ViewNode vn -> 
                      (try 
                        let vd = look_up_view_def_raw 13 prog.prog_view_decls vn.F.h_formula_view_name in
                        let to_vars = vd.view_vars in
                        let from_vars = vn.CF.h_formula_view_arguments in
                        let subs = List.combine from_vars to_vars in
                        (* let pr = Cprinter.string_of_spec_var_list in *)
                        (* let _ = Debug.tinfo_hprint (add_str "from_vars" pr)  from_vars no_pos in *)
                        (* let _ = Debug.tinfo_hprint (add_str "to_vars" pr) to_vars no_pos in *)
                        let rhs = CF.subst_struc subs rhs in
                        Some {vd with view_formula = rhs}
                      with  
                        | Not_found -> None
                      )
                | _ -> None 
            end
      | _ -> None in
    (* let _ = Debug.tinfo_hprint (add_str "vd2" (pr_option Cprinter.string_of_view_decl_short)) vd2 no_pos in *)
    let _ = cfd # set vd2 in
    vd2

(* let vdef_lemma_fold prog coer  =  *)
(*   let cfd = coer.coercion_fold_def in *)
(*   let lhs = coer.coercion_head in *)
(*   let rhs = coer.coercion_body_norm in *)
(*   let _ = Debug.info_hprint (add_str "head" !print_formula) lhs no_pos in *)
(*   let _ = Debug.info_hprint (add_str "body" !print_struc_formula) rhs no_pos in *)
(*   if cfd # is_init then cfd # get *)
(*   else *)
(*     let vd2 = match lhs with *)
(*       | F.Base bf -> *)
(*             begin *)
(*               match bf.F.formula_base_heap with *)
(*                 | F.ViewNode vn ->  *)
(*                       (try  *)
(*                         let vd = look_up_view_def_raw 13 prog.prog_view_decls vn.F.h_formula_view_name in *)
(*                         Some {vd with view_formula = rhs} *)
(*                       with   *)
(*                         | Not_found -> None *)
(*                       ) *)
(*                 | _ -> None  *)
(*             end *)
(*       | _ -> None in *)
(*     let _ = cfd # set vd2 in *)
(*     vd2 *)

let vdef_lemma_fold prog coer  = 
  let op = coer.coercion_fold_def in
  let pr _ = pr_option !print_view_decl_short (op # get) in
   Debug.no_1 "vdef_lemma_fold" pr pr (fun _ -> vdef_lemma_fold prog coer) ()

let get_xpure_one vdef rm_br  =
  match rm_br with
    | Some l -> let n=(List.length l) in  
      if n<(List.length vdef.view_prune_branches) then None
      else (match vdef.view_complex_inv with 
        | None -> None
        | Some f -> Some f)  (* unspecialised with a complex_inv *)
    | None -> Some vdef.view_x_formula 

let get_xpure_one vdef rm_br  =
  let pr mf = !print_mix_formula mf in
  Debug.no_1 "get_xpure_one" pr_no (pr_option pr) (fun _ -> get_xpure_one vdef rm_br) rm_br

let any_xpure_1 prog (f:F.h_formula) : bool = 
  let ff e = match e with
	| F.ViewNode ({ F.h_formula_view_node = p;
	  F.h_formula_view_name = c;
	  F.h_formula_view_remaining_branches = rm_br;
	  F.h_formula_view_pos = pos}) ->      
          let vdef = look_up_view_def_num 1 pos prog.prog_view_decls c in
          (match get_xpure_one vdef rm_br with
            | None -> Some false
            | Some r -> Some true (* check against vdef for complex_inv *)
          ) 
    | _ -> None
  in
  let comb_f = List.exists (fun x-> x) in
  F.fold_h_formula f ff comb_f

let any_xpure_1 prog (f:F.h_formula) : bool =
  let pr = !print_h_formula in
  Debug.no_1 "any_xpure_1" pr string_of_bool (fun _ -> any_xpure_1 prog f) f 

(*find and add uni_vars to view*)
(*if the view is recursive, only consider its view_vars
otherwise, go into its heap node and 
find all possible uni_vars*)
let rec add_uni_vars_to_view_x cprog (l2r_coers:coercion_decl list) (view:view_decl) : view_decl =
  let view_vars = view.view_vars in
  let look_up_one_x (coer:coercion_decl) (view:view_decl): P.spec_var list =
    let coer_uni_vars = coer.coercion_univ_vars in
    if (coer_uni_vars=[]) then []
    else
      let rec process_h_formula (h_f:F.h_formula):P.spec_var list = 
        match h_f with
          | F.ViewNode vn ->
              (* let _ = print_string "\n process_h_formula: F.ViewNode \n" in *)
              (* let _ = print_string ("\n process_h_formula:" *)
              (*                       ^"\n ### vn = " ^ (Cprinter.string_of_ident vn.F.h_formula_view_name) *)
              (*                       ^"\n ### view.view_name = " ^ (Cprinter.string_of_ident view.view_name) *)
              (*                       ^ "\n\n") in *)
              if ((String.compare vn.F.h_formula_view_name view.view_name)!=0) then []
              else
                let args = vn.F.h_formula_view_arguments in
                (* let _ = print_string ("\n process_h_formula:" *)
                (*                       ^"\n ### coer_uni_vars = " ^ (Cprinter.string_of_spec_var_list coer_uni_vars) *)
                (*                       ^"\n ### args = " ^ (Cprinter.string_of_spec_var_list args) *)
                (*                       ^"\n ### view_vars = " ^ (Cprinter.string_of_spec_var_list view_vars) *)
                (* ^ "\n\n") in *)
            (*at this point |view_vars| = |args|*)
                let rec helper args view_vars =
                  match args, view_vars with
                    | arg::argvs, var::vars ->
                        let res = helper argvs vars in
                        if (List.mem arg coer_uni_vars) then var::res
                        else res
                    | _ -> []
                in
                helper args view_vars
          | F.Star {  F.h_formula_star_h1 = h1;
                       F.h_formula_star_h2 = h2}
              -> 
              (* let _ = print_string "\n process_h_formula: F.Star \n" in *)
              let vars1 =  process_h_formula h1 in
              let vars2 =  process_h_formula h2 in
              P.remove_dups_svl vars1@vars2
              
          | _ -> 
              (* let _ = print_string "\n process_h_formula: [] \n" in *)
              []
      in
      let body = coer.coercion_body in
      match body with
        | F.Base {F.formula_base_heap = h}
        | F.Exists {F.formula_exists_heap = h} ->
            (* let _ = print_string "\n process_h_formula: F.Exists \n" in *)
            process_h_formula h
        | _ -> []
  in 
  let look_up_one (coer:coercion_decl) (view:view_decl): P.spec_var list =
    Debug.no_2 "look_up_one"
        !print_coercion
        !print_view_decl
        !print_svl
        look_up_one_x coer view
  in
  let res = List.map (fun coer -> look_up_one coer view) l2r_coers in
  let res1 = List.flatten res in
  (* let _ = print_string ("\n add_uni_vars_to_view:" *)
  (*                       ^"\n ### res1 = " ^ (Cprinter.string_of_spec_var_list res1) *)
  (*                       ^ "\n\n") in *)
  let uni_vars = P.remove_dups_svl res1 in
  if (view.view_is_rec) then {view with view_uni_vars = uni_vars}
  else
	let rec process_h_formula (h_f:F.h_formula):P.spec_var list = match h_f with
		| F.ViewNode vn ->
            if ((String.compare vn.F.h_formula_view_name view.view_name)=0) then []
			else
				let vdef = look_up_view_def_raw 4 cprog.prog_view_decls vn.F.h_formula_view_name in
				let vdef = add_uni_vars_to_view_x cprog l2r_coers vdef in
				let vdef_uni_vars = vdef.view_uni_vars in
				let fr = vdef.view_vars in
				let t = vn.F.h_formula_view_arguments in
				let vdef_uni_vars = P.subst_var_list_avoid_capture fr t vdef_uni_vars in
				vdef_uni_vars
        | F.Star {  F.h_formula_star_h1 = h1;
					F.h_formula_star_h2 = h2} -> 
				let vars1 =  process_h_formula h1 in
                let vars2 =  process_h_formula h2 in
                P.remove_dups_svl vars1@vars2
        | _ -> [] in
    let rec process_struc_formula (f:F.struc_formula):P.spec_var list = match f with
          | F.EBase e ->
            (*find all possible universal vars from a h_formula*)
              let vars1 = match e.F.formula_struc_base with
                  | F.Base {F.formula_base_heap = h;F.formula_base_pure = p}
                  | F.Exists {F.formula_exists_heap = h;F.formula_exists_pure = p} ->
                      let vars = process_h_formula h in
                      (match vars with
                        | [] -> []
                        | v::vs -> 
                            let xs = MP.find_closure_mix_formula v p in
                            let xs = Gen.BList.intersect_eq P.eq_spec_var xs view_vars in xs)
                (*vars is the set of all possible uni_vars in all nodes*)
                  | _ -> []
              in
              let vars2 = match e.F.formula_struc_continuation with | None -> [] | Some l -> process_struc_formula l in
              P.remove_dups_svl (vars1@vars2)
		  | F.EList b -> P.remove_dups_svl (List.flatten (List.map (fun c-> process_struc_formula (snd c)) b))
          | _ ->
              let _ = print_string "[add_uni_vars_to_view] Warning: only handle EBase \n" in
              []
      in
    let vars = process_struc_formula view.view_formula in
    let vars = vars@uni_vars in
    let vars = P.remove_dups_svl vars in
    {view with view_uni_vars = vars}

(*find and add uni_vars to view*)
let add_uni_vars_to_view cprog (l2r_coers:coercion_decl list) (view:view_decl) : view_decl =
  Debug.no_2 "add_uni_vars_to_view"
      !print_coerc_decl_list
      !print_view_decl
      !print_view_decl
      (fun _ _ -> add_uni_vars_to_view_x cprog l2r_coers view) l2r_coers view

(************************************************************
Building the call graph for procedure hierarchy based on Cast
*************************************************************)
module IdentComp = struct
  type t = ident
  let compare = compare
  let hash = Hashtbl.hash
  let equal = ( = )
end
module IG = Graph.Persistent.Digraph.Concrete(IdentComp)
module IGO = Graph.Oper.P(IG)
module IGC = Graph.Components.Make(IG)
module IGP = Graph.Path.Check(IG)
module IGN = Graph.Oper.Neighbourhood(IG)
module IGT = Graph.Topological.Make(IG)

let ex_args f a b = f b a

let ngs_union gs = 
  List.fold_left IGO.union IG.empty gs 

let addin_callgraph_of_exp (cg:IG.t) exp mnv : IG.t = 
  let f e = 
    match e with
    | ICall e ->
      (* let _ = print_endline (mnv ^ " -> " ^ e.exp_icall_method_name) in *)
      Some (IG.add_edge cg mnv e.exp_icall_method_name)
    | SCall e ->
      (* let _ = print_endline (mnv ^ " -> " ^ e.exp_scall_method_name) in *)
      Some (IG.add_edge cg mnv e.exp_scall_method_name)
    | _ -> None
  in
  fold_exp exp f ngs_union cg
	
let addin_callgraph_of_proc cg proc : IG.t = 
  match proc.proc_body with
  | None -> cg
  | Some e -> addin_callgraph_of_exp cg e proc.proc_name

let callgraph_of_prog prog : IG.t = 
  let cg = IG.empty in
  let pn pc = pc.proc_name in
  (*let mns = List.map pn prog.old_proc_decls in*)
  let mns = List.map pn (list_of_procs prog) in 
  let cg = List.fold_right (ex_args IG.add_vertex) mns cg in
  (*List.fold_right (ex_args addin_callgraph_of_proc) prog.old_proc_decls cg*)
  Hashtbl.fold (fun i pd acc -> ex_args addin_callgraph_of_proc pd acc) prog.new_proc_decls cg

let count_term_scc (procs: proc_decl list) : int =
  List.fold_left (fun acc p -> 
    acc + (F.count_term_struc p.proc_static_specs)) 0 procs

(* Mutual groups with logical phase variables added *)
(* those with logical variables explicitly added will
   not have a re-numbering done *)
let stk_scc_with_phases = new Gen.stack 

(* Termination: Add the call numbers and the implicit phase 
 * variables to specifications if the option 
 * --dis-call-num and --dis-phase-num are not enabled (default) *)
let rec add_term_nums_prog (cp: prog_decl) : prog_decl =
  if !Globals.dis_call_num && !Globals.dis_phase_num then cp 
  else 
    let (prim_grp, mutual_grps) = re_proc_mutual (sort_proc_decls (list_of_procs cp)) in
    let log_vars = cp.prog_logical_vars in
    (* Only add the phase variables into scc group with >1 Term *)
    let mutual_grps = List.map (fun scc -> (count_term_scc scc, scc)) mutual_grps in
    let mutual_grps = List.filter (fun (c,_) -> c>0) mutual_grps in
    if mutual_grps!=[] then 
      begin
        let pr p = p.proc_name in
        Debug.devel_zprint (lazy (">>>>>> [term.ml][Adding Call Number and Phase Logical Vars] <<<<<<")) no_pos;
        Debug.devel_hprint (add_str ("Mutual Groups") (pr_list (pr_pair string_of_int (pr_list pr)))) mutual_grps no_pos;
        Debug.devel_pprint "\n" no_pos

      end;
    let pvs = List.map (fun (n, procs) ->
        let mn = List.hd procs in
        let pv = add_term_nums_proc_scc procs cp.new_proc_decls log_vars
          ((not !dis_call_num) (* && n>0 *)) ((not !dis_phase_num) && n>1 & mn.proc_is_recursive) 
        in (match pv with 
          | [] -> ()
          | x::_ -> stk_scc_with_phases # push mn.proc_call_order); pv
    ) mutual_grps
    in
    let () = Debug.dinfo_hprint (add_str "Mutual Grps with Phases" 
        (pr_list (string_of_int))) (stk_scc_with_phases # get_stk) no_pos in
    let () = Debug.dinfo_hprint (add_str "Mutual Grps" (pr_list (pr_pair string_of_int (pr_list (fun p -> p.proc_name))))) mutual_grps no_pos in
    let () = Debug.dinfo_hprint (add_str "Phase Vars Added" (pr_list (pr_list !P.print_sv))) pvs no_pos in
    let pvl = Gen.BList.remove_dups_eq P.eq_spec_var 
      ((List.concat pvs) @ log_vars) in
    { cp with prog_logical_vars = pvl } 

(* Do not add call numbers and phase variables 
 * into the specification of a primitive call. 
 * The return value contains a list of new 
 * added spec_var *)   
and add_term_nums_proc_scc_x (procs: proc_decl list) tbl log_vars (add_call: bool) (add_phase: bool) =
  let n_procs, pvs = List.split (List.map (fun proc -> 
    add_term_nums_proc proc log_vars add_call add_phase
  ) procs) in 
  let pvs = List.concat pvs in
  let n_procs = List.map (fun proc -> { proc with
    (* Option 1: Add logical variables of scc group into specifications for inference *)
    (* Option 2: Store the set of logical variables into proc_logical_vars 
     * It will be added into the initial context in check_proc *)
       proc_logical_vars = pvs;
  }) n_procs in
  let _ = List.iter (fun proc ->
    Hashtbl.replace tbl proc.proc_name proc 
  ) n_procs in 
  pvs

and add_term_nums_proc_scc (procs: proc_decl list) tbl log_vars (add_call: bool) (add_phase: bool) =
  let pr ps = pr_list (fun p -> p.proc_name) ps in
  Debug.no_1 "add_term_nums_proc_scc" pr !P.print_svl
      (fun _ -> add_term_nums_proc_scc_x (procs: proc_decl list) tbl log_vars (add_call: bool) (add_phase: bool)) procs

(* adding call number and phase variables into spec *)
and add_term_nums_proc (proc: proc_decl) log_vars add_call add_phase = 
  if not (proc.proc_is_main) then (proc, [])
  else if (not add_call) && (not add_phase) then (proc, [])
  else 
    let call_num = 
      if add_call then Some proc.proc_call_order
      else None
    in
    let n_ss, pvl1 = F.add_term_nums_struc proc.proc_static_specs log_vars call_num add_phase in
    let n_ds, pvl2 = F.add_term_nums_struc proc.proc_dynamic_specs log_vars call_num add_phase in
    ({ proc with
      proc_static_specs = n_ss; 
      proc_dynamic_specs = n_ds; 
    }, pvl1 @ pvl2)


let collect_hp_rels prog= Hashtbl.fold (fun i p acc-> 
	let name = unmingle_name p.proc_name in
	(List.map (fun c-> name,c) p.proc_hpdefs)@acc) prog.new_proc_decls []

let look_up_cont_args_x a_args vname cviews=
  let vdef = look_up_view_def_raw 5 cviews vname in
  let pr_args = List.combine vdef.view_vars a_args in
  List.fold_left (fun ls cont_sv -> ls@[List.assoc cont_sv pr_args]) [] vdef.view_cont_vars

let look_up_cont_args a_args vname cviews=
  let pr1 = !Cpure.print_svl in
  Debug.no_2 "look_up_cont_args" pr1 pr_id pr1
      (fun _ _ -> look_up_cont_args_x a_args vname cviews) a_args vname
	  
	  
	  
let exp_fv (e:exp) = 
  let comb_f = List.concat in
  let f (ac:ident list) e : ident list option= match e with
			  | Assert b -> 
				let l = (Gen.fold_opt F.struc_fv b.exp_assert_asserted_formula)@ (Gen.fold_opt F.fv b.exp_assert_assumed_formula)in
				Some (ac@ List.map P.name_of_spec_var l)
	          | Java _ -> Some ac
	          | CheckRef b-> Some (b.exp_check_ref_var::ac)
	          | BConst _ -> Some ac
	          | Debug _ -> Some ac
	          | Dprint b -> Some (b.exp_dprint_visible_names@ac)
	          | FConst _ -> Some ac
	          | ICall b -> Some (b.exp_icall_receiver::b.exp_icall_arguments@ac)
	          | IConst _ -> Some ac
			  | New b -> Some ((List.map snd b.exp_new_arguments)@ac)
	          | Null _ -> Some ac
			  | EmptyArray _ -> Some ac
	          | Print _ -> Some ac
			  | Barrier b-> Some ((snd b.exp_barrier_recv)::ac)
	          | SCall b -> Some (ac@b.exp_scall_arguments)
	          | This _ -> Some ac
	          | Time _ -> Some ac
	          | Var b -> Some (b.exp_var_name::ac)
	          | VarDecl b -> Some (b.exp_var_decl_name::ac)
	          | Unfold b -> Some ((P.name_of_spec_var b.exp_unfold_var)::ac)
	          | Unit _ -> Some ac
	          | Sharp _ -> Some ac
			  |  _ -> None in
    let f_args (ac:ident list) e : ident list= match e with
		| Label b -> ac
		| Assign b -> b.exp_assign_lhs::ac
		| Bind b ->ac@ ((snd b.exp_bind_bound_var)::(List.map snd b.exp_bind_fields))
		| Block b -> ac@(List.map snd b.exp_block_local_vars)
		| Cond b ->b.exp_cond_condition::ac
		| Cast b -> ac
		| Catch b -> (Gen.fold_opt (fun (_,c)-> [c]) b.exp_catch_var)@ac
		| Seq b -> ac
		| While b -> ac@[b.exp_while_condition]@(List.map P.name_of_spec_var (F.struc_fv b.exp_while_spec))
		| Try b -> ac
		| _ -> ac in
  fold_exp_args e [] f f_args comb_f []
