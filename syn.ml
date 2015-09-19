#include "xdebug.cppo"
open VarGen
open Globals
open Gen
open Others
open Label_only
open SynUtils
module CP = Cpure
module IF = Iformula
module CF = Cformula
(* module CFU = Cfutil *)
module MCP = Mcpure
(* module CEQ = Checkeq *)

(***************************)
(***** ADDING DANGLING *****)
(***************************)

let dangling_view_name = "Dangling"

let mk_dangling_view_prim = 
  Cast.mk_view_prim dangling_view_name [] (MCP.mkMTrue no_pos) no_pos

let mk_dangling_view_node dangling_var = 
  CF.mkViewNode dangling_var dangling_view_name [] no_pos

let add_dangling_hprel prog (hpr: CF.hprel) =
  let _, lhs_p, _, _, _, _ = CF.split_components hpr.hprel_lhs in
  let lhs_aliases = MCP.ptr_equations_with_null lhs_p in
  let guard_aliases =
    match hpr.hprel_guard with
    | None -> []
    | Some g -> 
      let _, guard_p, _, _, _, _ = CF.split_components g in
      MCP.ptr_equations_with_null guard_p
  in
  let aliases = CP.find_all_closures (lhs_aliases @ guard_aliases) in
  let null_aliases =
    try List.find (fun svl -> List.exists CP.is_null_const svl) aliases
    with _ -> []
  in
  let lhs_args = collect_feasible_heap_args_formula prog null_aliases hpr.hprel_lhs in
  let lhs_nodes = CF.collect_node_var_formula hpr.hprel_lhs in
  let rhs_args = collect_feasible_heap_args_formula prog null_aliases hpr.hprel_rhs in
  let rhs_args_w_aliases = List.concat (List.map (fun arg ->
    try List.find (fun svl -> mem arg svl) aliases
    with _ -> [arg]) rhs_args) in 
  let dangling_args = List.filter CP.is_node_typ (diff (* (diff lhs_args lhs_nodes) *) lhs_args rhs_args_w_aliases) in
  let () = x_binfo_hp (add_str "Dangling args" !CP.print_svl) dangling_args no_pos in
  let combine_dangling_args f = List.fold_left (fun acc_f dangling_arg ->
      CF.mkStar_combine_heap acc_f (mk_dangling_view_node dangling_arg) CF.Flow_combine no_pos
    ) f dangling_args in
  if is_empty dangling_args then hpr, false
  else
    (* let n_hpr =                                                                             *)
    (*   if is_pre_hprel hpr then { hpr with hprel_rhs = combine_dangling_args hpr.hprel_rhs } *)
    (*   else { hpr with hprel_lhs = combine_dangling_args hpr.hprel_lhs }                     *)
    (* in                                                                                      *)
    (* n_hpr, true                                                                             *)
    { hpr with hprel_rhs = combine_dangling_args hpr.hprel_rhs }, true

let add_dangling_hprel prog (hpr: CF.hprel) = 
  let pr = Cprinter.string_of_hprel_short in
  Debug.no_1 "Syn:add_dangling_hprel" pr (pr_pair pr string_of_bool) (add_dangling_hprel prog) hpr

let add_dangling_hprel_list prog (hpr_list: CF.hprel list) =
  fst (List.split (List.map (x_add add_dangling_hprel prog) hpr_list))

(*******************)
(***** MERGING *****)
(*******************)
let partition_hprel_list hprels = 
  partition_by_key (fun hpr -> name_of_hprel hpr) CP.eq_spec_var hprels

let rename_hprel_args n_args hprel =
  let hprel_name, hprel_args = sig_of_hprel hprel in
  try
    let sst = List.combine hprel_args n_args in
    CF.subst_hprel_constr sst hprel 
  with _ -> failwith ("Mismatch number of arguments of " ^ (!CP.print_sv hprel_name))

let rename_hprel_list hprels = 
  match hprels with
  | [] -> []
  | hpr::hprs -> 
    let n_args = args_of_hprel hpr in
    hpr::(List.map (rename_hprel_args n_args) hprs)

let cond_of_hprel (hprel: CF.hprel) = 
  let _, lhs_p, _, _, _, _ = CF.split_components hprel.hprel_lhs in
  match hprel.hprel_guard with
  | None -> MCP.pure_of_mix lhs_p
  | Some g -> 
    let _, g_p, _, _, _, _ = CF.split_components g in
    CP.mkAnd (MCP.pure_of_mix lhs_p) (MCP.pure_of_mix g_p) no_pos

let cond_guard_of_hprel cond_list hprel_cond =
  let all_cond_guard = List.find_all (fun c -> imply hprel_cond c) cond_list in
  let cond_guard = CP.join_conjunctions all_cond_guard in
  cond_guard

let transform_hprel_w_cond_guard cond_guard (hprel: CF.hprel) =
  let f_m_f m_f =
    let p_f = MCP.pure_of_mix m_f in
    let gist_p_f = Tpdispatcher.om_gist p_f cond_guard in
    MCP.mix_of_pure gist_p_f
  in
  { hprel with
    hprel_lhs = trans_pure_formula f_m_f hprel.hprel_lhs;
    hprel_guard = map_opt (trans_pure_formula f_m_f) hprel.hprel_guard; }

let transform_hprel_w_cond_guard cond_guard (hprel: CF.hprel) =
  let pr1 = !CP.print_formula in
  let pr2 = Cprinter.string_of_hprel_short in
  Debug.no_2 "transform_hprel_w_cond_guard" pr1 pr2 pr2 
    transform_hprel_w_cond_guard cond_guard hprel

let should_merge_hprels prog hprels = 
  match hprels with
  | []
  | _ ::[] -> false
  | hpr::hprs ->
    let args = args_of_hprel hpr in
    let ex_hpr_lhs = push_exists_for_args hpr.CF.hprel_lhs args in
    List.for_all (fun hp ->
      let ex_hp_lhs = push_exists_for_args hp.CF.hprel_lhs args in
      let equiv_lhs () = 
        (heap_entail_exact_formula prog ex_hpr_lhs ex_hp_lhs) &&
        (heap_entail_exact_formula prog ex_hp_lhs ex_hpr_lhs)
      in
      let equiv_guard () = 
        match hpr.CF.hprel_guard, hp.CF.hprel_guard with
        | None, None -> true
        | Some gr, Some g ->
          (heap_entail_exact_formula prog g gr) &&
          (heap_entail_exact_formula prog gr g)
        | _ -> false
      in (equiv_lhs ()) && (equiv_guard ())) hprs

let should_merge_hprels prog hprels = 
  let pr = Cprinter.string_of_hprel_list_short in
  Debug.no_1 "should_merge_hprels" pr string_of_bool
    (should_merge_hprels prog) hprels
  
(* hprels have the same name *)
let merge_hprel_list prog hprels =
  match hprels with
  | []
  | _::[] -> hprels
  | _ ->
    if List.exists (fun hpr -> is_None hpr.CF.hprel_guard) hprels then hprels
    else
      let hprels = rename_hprel_list hprels in
      let conds = List.map cond_of_hprel hprels in
      let sub_conds = List.concat (List.map CP.split_conjunctions conds) in
      let unsat_core = Smtsolver.get_unsat_core sub_conds in
      if is_empty unsat_core then hprels
      else
        let cond_guards = List.map (fun c -> cond_guard_of_hprel unsat_core c) conds in
        let cond_guard_hprels = List.combine cond_guards hprels in
        let trans_hprels = List.map (fun (c, hpr) -> transform_hprel_w_cond_guard c hpr) cond_guard_hprels in
        (* if not (should_merge_hprels prog trans_hprels) then hprels *)
        (* else                                                       *)
          let disj_rhs_list = List.fold_left (fun acc (c, hprel) ->
            let rhs_w_cond = CF.add_pure_formula_to_formula c hprel.CF.hprel_rhs in
            acc @ [rhs_w_cond]) [] cond_guard_hprels in
          let disj_rhs = List.fold_left (fun acc f ->
            CF.mkOr acc f no_pos) (List.hd disj_rhs_list) (List.tl disj_rhs_list) in
          let comb_hpr = List.hd trans_hprels in
          let comb_hpr = { comb_hpr with hprel_rhs = disj_rhs } in
          [comb_hpr]

let merge_hprel_list prog hprels =
  let pr = Cprinter.string_of_hprel_list_short in
  Debug.no_1 "Syn:merging" pr pr (merge_hprel_list prog) hprels

let merging prog hprels = 
  let hprel_lists = List.map snd (partition_hprel_list hprels) in
  List.concat (List.map (merge_hprel_list prog) hprel_lists)

(*********************)
(***** UNFOLDING *****)
(*********************)
module Ident = struct
  type t = ident
  let compare = String.compare
  let hash = Hashtbl.hash
  let equal i1 i2 = compare i1 i2 == 0 
end

module CG = Graph.Persistent.Digraph.Concrete(Ident)
module CGC = Graph.Components.Make(CG)

let hprel_num = ref 0

let fresh_hprel_num () =
  hprel_num := !hprel_num + 1;
  !hprel_num

type hprel_id = {
  hprel_constr: CF.hprel;
  hprel_id: int;
}

let mk_hprel_id hpr = 
  { hprel_constr = hpr; hprel_id = fresh_hprel_num (); }

let partition_hprel_id_list hprel_ids = 
  partition_by_key (fun hpri -> name_of_hprel hpri.hprel_constr) CP.eq_spec_var hprel_ids

let add_back_hrel ctx hrel = 
  let hrel_f = CF.mkBase_simp hrel (MCP.mkMTrue no_pos) in
  combine_Star ctx hrel_f

let unfolding_one_hrel_def prog ctx hrel (hrel_def: CF.hprel) =
  let pos = no_pos in
  let hrd_lhs = hrel_def.hprel_lhs in
  let hrel_name, hrel_args = sig_of_hrel hrel in
  let _, lhs_p, _, _, _, _ = CF.split_components hrd_lhs in
  let lhs_p = MCP.pure_of_mix lhs_p in
  let ex_lhs_p = MCP.mix_of_pure (simplify lhs_p hrel_args) in
  let hrd_guard = hrel_def.hprel_guard in
  let guard_f = 
    match hrd_guard with
    | None -> CF.mkBase_simp HEmp (MCP.mkMTrue pos)
    | Some g -> g
  in
  let guard_h, guard_p, _, _, _, _ = CF.split_components guard_f in
  let guard_h_f = CF.mkBase_simp guard_h ex_lhs_p in
  let rs, residue = x_add heap_entail_formula prog ctx guard_h_f in
  if rs then
    let _, ctx_p, _, _, _, _ = CF.split_components ctx in
    if is_sat (MCP.merge_mems ctx_p guard_p true) then
      (* Prevent self-recursive pred to avoid infinite unfolding *)
      let hprel_rhs_fv = CF.fv hrel_def.hprel_rhs in
      if mem hrel_name hprel_rhs_fv then
        failwith "Unfolding self-recursive predicate is not allowed to avoid possibly infinite unfolding!"
      else
        let comb_f = combine_Star guard_f residue in
        Some (combine_Star comb_f hrel_def.hprel_rhs)
    else None
  else None

let unfolding_one_hrel_def prog ctx hrel (hrel_def: CF.hprel) =
  let pr1 = !CF.print_formula in
  let pr2 = Cprinter.string_of_hprel_short in
  Debug.no_2 "Syn:unfolding_one_hrel_def" pr1 pr2 (pr_option pr1)
    (fun _ _ -> unfolding_one_hrel_def prog ctx hrel hrel_def) ctx hrel_def

let unfolding_one_hrel prog ctx hprel_name hrel hprel_groups =
  let pos = no_pos in
  let hrel_name, hrel_args = sig_of_hrel hrel in
  if CP.eq_spec_var hprel_name hrel_name then
    [add_back_hrel ctx hrel]
  else
    let hrel_defs = List.filter (fun (hpr_sv, _) -> 
        CP.eq_spec_var hpr_sv hrel_name) hprel_groups in
    let hrel_defs = List.concat (List.map snd hrel_defs) in
    if is_empty hrel_defs then [add_back_hrel ctx hrel]
    else
      let subst_hrel_defs = List.map (
        fun hprel ->
          try
            let sst = List.combine (args_of_hprel hprel) hrel_args in
            CF.subst_hprel_constr sst hprel 
          with _ -> failwith ("Mismatch number of arguments of " ^ (!CP.print_sv hrel_name))
        ) hrel_defs
      in
      let guarded_hrel_defs, unguarded_hrel_defs = List.partition (fun hrel_def ->
          match hrel_def.CF.hprel_guard with Some _ -> true | None -> false) subst_hrel_defs in
      let non_inst_unguarded_hrel_defs, unguarded_hrel_defs = List.partition (is_non_inst_hprel prog) unguarded_hrel_defs in
      (* Only unfolding guarded hrel or non-inst hrel *)
      let unfolding_ctx_list = List.fold_left (fun acc hrel_def ->
          let unfolding_ctx = x_add unfolding_one_hrel_def prog ctx hrel hrel_def in
          match unfolding_ctx with
          | None -> acc
          | Some ctx -> acc @ [ctx]) [] (guarded_hrel_defs @ non_inst_unguarded_hrel_defs)
      in
      let unfolding_ctx_list = 
        if is_empty unguarded_hrel_defs 
        then unfolding_ctx_list
        else unfolding_ctx_list @ [add_back_hrel ctx hrel]
      in
      if is_empty unfolding_ctx_list then
        [add_back_hrel ctx hrel]
      else unfolding_ctx_list

let unfolding_one_hrel prog ctx hprel_name hrel hprel_groups =
  let pr1 = !CF.print_formula in
  let pr2 = !CF.print_h_formula in
  Debug.no_2 "Syn:unfolding_one_hrel" pr1 pr2 (pr_list pr1)
    (fun _ _ -> unfolding_one_hrel prog ctx hprel_name hrel hprel_groups) 
    ctx hrel

let unfolding_hrel_list prog ctx hprel_name hrel_list hprel_groups =
  let rec helper ctx hrel_list = 
    match hrel_list with
    | [] -> [ctx]
    | hr::hrl ->
      let ctx_list = x_add unfolding_one_hrel prog ctx hprel_name hr hprel_groups in
      List.concat (List.map (fun ctx -> helper ctx hrl) ctx_list)
  in
  let non_inst_hrel_list, norm_hrel_list = List.partition (is_non_inst_hrel prog) hrel_list in
  helper ctx (norm_hrel_list @ non_inst_hrel_list)

let unfolding_hrel_list prog ctx hprel_name hrel_list hprel_groups =
  let pr1 = !CF.print_formula in
  let pr2 = pr_list !CF.print_h_formula in
  Debug.no_2 "Syn:unfolding_hrel_list" pr1 pr2 (pr_list pr1)
    (fun _ _ -> unfolding_hrel_list prog ctx hprel_name hrel_list hprel_groups) 
    ctx hrel_list

let rec unfolding_hprel prog hprel_groups (hpr: CF.hprel): CF.hprel list =
  let hpr_name, hpr_args = sig_of_hprel hpr in 
  let hpr_rhs = hpr.hprel_rhs in
  let rhs_h, rhs_p, _, _, _, _ = CF.split_components hpr_rhs in
  let rhs_hrels, rhs_hpreds = List.partition CF.is_hrel (CF.split_star_conjunctions rhs_h) in
  let ctx = CF.mkBase_simp (CF.join_star_conjunctions rhs_hpreds) rhs_p in
  let unfolding_ctx_list = x_add unfolding_hrel_list prog ctx hpr_name rhs_hrels hprel_groups in
  let unfolding_hpr_list = List.map (fun unfolding_rhs -> 
      { hpr with hprel_rhs = unfolding_rhs }) unfolding_ctx_list in
  unfolding_hpr_list

let unfolding_hprel prog hprel_groups (hpr: CF.hprel): CF.hprel list =
  let pr = Cprinter.string_of_hprel_short in
  Debug.no_1 "Syn:unfolding_hprel" pr (pr_list pr)
    (fun _ -> unfolding_hprel prog hprel_groups hpr) hpr

let dependent_graph_of_hprel dg hprel = 
  let hpr_name = CP.name_of_spec_var (name_of_hprel hprel) in 
  let hpr_rhs = hprel.hprel_rhs in
  let rhs_h, _, _, _, _, _ = CF.split_components hpr_rhs in
  let rhs_hrels = List.filter CF.is_hrel (CF.split_star_conjunctions rhs_h) in
  let rhs_hrels_name = List.map (fun hr -> CP.name_of_spec_var (name_of_hrel hr)) rhs_hrels in
  List.fold_left (fun dg hr_name -> CG.add_edge dg hpr_name hr_name) dg rhs_hrels_name

let dependent_graph_of_hprel_list hprel_list =
  let dg = CG.empty in
  List.fold_left (fun dg hprel -> dependent_graph_of_hprel dg hprel) dg hprel_list

let sort_hprel_list hprel_list = 
  let dg = dependent_graph_of_hprel_list hprel_list in
  let _, scc_f = CGC.scc dg in
  let compare hpr1 hpr2 =
    let hpr1_name = CP.name_of_spec_var (name_of_hprel hpr1) in
    let hpr2_name = CP.name_of_spec_var (name_of_hprel hpr2) in 
    (scc_f hpr1_name) - (scc_f hpr2_name)
  in
  List.sort compare hprel_list

let rec update_hprel_id_groups hprel_id hprel_sv hprel_id_list hprel_id_groups =
  match hprel_id_groups with
  | [] -> []
  | (hpr_sv, hpri_group)::hpri_groups ->
    if CP.eq_spec_var hpr_sv hprel_sv then
      let replaced_hpri_group = 
        hprel_id_list @ 
        (List.filter (fun hpri -> hpri.hprel_id != hprel_id) hpri_group) 
      in
      (hpr_sv, replaced_hpri_group)::hpri_groups
    else 
      (hpr_sv, hpri_group)::(update_hprel_id_groups hprel_id hprel_sv hprel_id_list hpri_groups)

let rec helper_unfolding_hprel_list prog hprel_id_groups hprel_id_list =
  match hprel_id_list with
  | [] -> []
  | hpri::hpril ->
    let hprel_groups = List.map (fun (hprel_sv, hprel_id_list) ->
        (hprel_sv, List.map (fun hpri -> hpri.hprel_constr) hprel_id_list)
      ) hprel_id_groups in
    let unfolding_hpr = x_add unfolding_hprel prog hprel_groups hpri.hprel_constr in
    let unfolding_hpri = List.map mk_hprel_id unfolding_hpr in
    let updated_hprel_id_groups = update_hprel_id_groups 
      hpri.hprel_id (name_of_hprel hpri.hprel_constr) unfolding_hpri hprel_id_groups in
    unfolding_hpr @ (helper_unfolding_hprel_list prog updated_hprel_id_groups hpril)

let helper_unfolding_hprel_list prog hprel_id_groups hprel_id_list =
  let pr1 = Cprinter.string_of_hprel_list_short in
  let pr2 hpril = pr1 (List.map (fun hpri -> hpri.hprel_constr) hpril) in
  let pr3 = pr_list (pr_pair !CP.print_sv pr2) in
  Debug.no_2 "Syn:helper_unfolding_hprel_list" pr2 pr3 pr1
    (fun _ _ -> helper_unfolding_hprel_list prog hprel_id_groups hprel_id_list)
    hprel_id_list hprel_id_groups

let unfolding_hprel_list prog hprel_list =
  let sorted_hprel_list = sort_hprel_list hprel_list in
  let hprel_id_list = List.map mk_hprel_id sorted_hprel_list in
  let hprel_id_groups = partition_hprel_id_list hprel_id_list in
  x_add helper_unfolding_hprel_list prog hprel_id_groups hprel_id_list

let selective_unfolding prog other_hprels hprels = 
  let pre_hprels, post_hprels = List.partition is_pre_hprel hprels in
  let sorted_hprel_list = sort_hprel_list pre_hprels in
  let hprel_id_list = List.map mk_hprel_id sorted_hprel_list in
  let other_hprel_id_list = List.map mk_hprel_id other_hprels in
  let hprel_id_groups = partition_hprel_id_list (hprel_id_list @ other_hprel_id_list) in 
  (x_add helper_unfolding_hprel_list prog hprel_id_groups hprel_id_list) @ post_hprels

let selective_unfolding prog other_hprels hprels = 
  let pr = Cprinter.string_of_hprel_list_short in
  Debug.no_2 "Syn:selective_unfolding" pr pr pr 
    (fun _ _ -> selective_unfolding prog other_hprels hprels) other_hprels hprels

let unfolding prog hprels = 
  let pre_hprels, post_hprels = List.partition is_pre_hprel hprels in
  (unfolding_hprel_list prog pre_hprels) @ post_hprels

let unfolding prog hprels = 
  let pr = Cprinter.string_of_hprel_list_short in
  Debug.no_1 "Syn:unfolding" pr pr (fun _ -> unfolding prog hprels) hprels

(**************************)
(***** PARAMETERIZING *****)
(**************************)
let remove_dangling_heap_formula (f: CF.formula) = 
  let f_h_f _ hf = 
    match hf with
    | CF.ViewNode ({ 
        h_formula_view_node = view_node;
        h_formula_view_name = view_name; } as v) ->
      if eq_id view_name dangling_view_name then
        Some (CF.HEmp, [view_node])
      else Some (hf, [])
    | _ -> None
  in
  trans_heap_formula f_h_f f

let remove_dangling_heap_formula (f: CF.formula) = 
  let pr1 = !CF.print_formula in
  let pr2 = !CP.print_svl in
  Debug.no_1 "Syn:remove_dangling_heap_formula" pr1 (pr_pair pr1 pr2)
    remove_dangling_heap_formula f
  
let add_dangling_params hrel_name dangling_params (f: CF.formula) = 
  let f_h_f _ hf = 
    match hf with
    | CF.HRel (hr_sv, hr_args, hr_pos) ->
      if CP.eq_spec_var hr_sv hrel_name then
        let parameterized_hrel = CF.HRel (hr_sv, hr_args @ dangling_params, hr_pos) in
        Some (parameterized_hrel, [])
      else Some (hf, [])
    | _ -> None
  in
  fst (trans_heap_formula f_h_f f)

let add_dangling_params hrel_name dangling_params (f: CF.formula) = 
  let pr1 = !CF.print_formula in
  let pr2 = !CP.print_sv in
  let pr3 = pr_list !CP.print_exp in
  Debug.no_3 "Syn:add_dangling_params" pr1 pr2 pr3 pr1
    (fun _ _ _ -> add_dangling_params hrel_name dangling_params f)
    f hrel_name dangling_params

let dangling_parameterizing_hprel (hpr: CF.hprel) =
  let is_pre = is_pre_hprel hpr in
  let param_f = if is_pre then hpr.hprel_rhs else hpr.hprel_lhs in 
  
  let n_param_f, dangling_vars = x_add_1 remove_dangling_heap_formula param_f in
  if is_empty dangling_vars then hpr, idf
  else
    let fresh_dangling_vars = CP.fresh_spec_vars dangling_vars in
    let dangling_params = List.map (fun dv -> CP.mkVar dv no_pos) fresh_dangling_vars in
    let n_param_f = CF.subst (List.combine dangling_vars fresh_dangling_vars) n_param_f in
    let hpr_name = name_of_hprel hpr in
    let f_update_params_hprel hpr =
      { hpr with
        CF.hprel_lhs = x_add add_dangling_params hpr_name dangling_params hpr.CF.hprel_lhs;
        CF.hprel_rhs = x_add add_dangling_params hpr_name dangling_params hpr.CF.hprel_rhs;
      }
    in
    let f_update_params_hprel hpr =
      let pr = Cprinter.string_of_hprel_short in
      Debug.no_1 "f_update_params_hprel" pr pr f_update_params_hprel hpr
    in
    let n_hpr = 
      if is_pre then { hpr with hprel_rhs = n_param_f }
      else { hpr with hprel_lhs = n_param_f }
    in 
    n_hpr, f_update_params_hprel

let dangling_parameterizing_hprel (hpr: CF.hprel) =
  let pr1 = Cprinter.string_of_hprel_short in
  let pr2 = fun (hpr, _) -> pr1 hpr in
  Debug.no_1 "Syn:dangling_parameterizing_hprel" pr1 pr2 dangling_parameterizing_hprel hpr

let rec dangling_parameterizing hprels =
  let rec helper_x acc hprels = 
    match hprels with
    | [] -> acc
    | hpr::hprl ->
      let hpr_wo_dangling, f_update_params = x_add_1 dangling_parameterizing_hprel hpr in
      let n_hpr = f_update_params hpr_wo_dangling in
      let n_hprl = List.map f_update_params hprl in
      let n_acc = List.map f_update_params acc in
      helper (n_acc @ [n_hpr]) n_hprl

  and helper acc hprels =
    let pr = Cprinter.string_of_hprel_list_short in
    Debug.no_2 "dangling_parameterizing_helper" pr pr pr
      helper_x acc hprels
  in
  
  helper [] hprels

let dangling_parameterizing hprels = 
  let pr = Cprinter.string_of_hprel_list_short in
  Debug.no_1 "Syn:parameterizing" pr pr 
    (fun _ -> dangling_parameterizing hprels) hprels

(****************)
(***** MAIN *****)
(****************)
let syn_pre_preds prog (is: CF.infer_state) = 
  if !Globals.new_pred_syn then
    let () = x_binfo_pp ">>>>> Step 0: Simplification <<<<<" no_pos in
    let is_all_constrs = List.map (x_add_1 simplify_hprel) is.CF.is_all_constrs in
    let () = x_binfo_hp (add_str "Simplified hprels" 
        Cprinter.string_of_hprel_list_short) is_all_constrs no_pos
    in
  
    let () = x_binfo_pp ">>>>> Step 1: Adding dangling references <<<<<" no_pos in
    let is_all_constrs, has_dangling_vars = List.split (List.map (x_add add_dangling_hprel prog) is_all_constrs) in
    let has_dangling_vars = or_list has_dangling_vars in
    let prog =
      if has_dangling_vars then
        { prog with Cast.prog_view_decls = prog.Cast.prog_view_decls @ [mk_dangling_view_prim]; }
      else prog
    in
    let () =
      if has_dangling_vars then
        x_binfo_hp (add_str "Detected dangling vars" 
            Cprinter.string_of_hprel_list_short) is_all_constrs no_pos
      else x_binfo_pp "No dangling var is detected" no_pos
    in

    let () = x_binfo_pp ">>>>> Step 2A: Merging <<<<<" no_pos in
    let is_all_constrs = x_add merging prog is_all_constrs in
    let () = x_binfo_hp (add_str "Merging result" 
        Cprinter.string_of_hprel_list_short) is_all_constrs no_pos
    in
  
    let () = x_binfo_pp ">>>>> Step 2B: Unfolding <<<<<" no_pos in
    let is_all_constrs = x_add unfolding prog is_all_constrs in
    let () = x_binfo_hp (add_str "Unfolding result" 
        Cprinter.string_of_hprel_list_short) is_all_constrs no_pos
    in
  
    let () = x_binfo_pp ">>>>> Step 3: Dangling Parameterizing <<<<<" no_pos in
    let is_all_constrs = x_add_1 dangling_parameterizing is_all_constrs in
    let () = x_binfo_hp (add_str "Parameterizing result" 
        Cprinter.string_of_hprel_list_short) is_all_constrs no_pos
    in

    let () = x_binfo_pp ">>>>> Step 4: Inferring Segment Predicates <<<<<" no_pos in
    
    { is with CF.is_all_constrs = is_all_constrs }
  else is

let syn_pre_preds prog is = 
  let pr2 = Cprinter.string_of_infer_state_short in
  Debug.no_1 "Syn:syn_pre_preds" pr2 pr2
    (fun _ -> syn_pre_preds prog is) is
