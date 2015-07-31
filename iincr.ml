#include "xdebug.cppo"
open VarGen
open Gen
open Globals
open Wrapper
open Others
open Exc.GTable

open Cformula

module CP = Cpure
module CF = Cformula

let get_infer_type its0 inf0=
  (* let rec look_up ifts inf rem= *)
  (*   match ifts with *)
  (*     | [] -> raise Not_found *)
  (*     | it::rest -> if it == inf then it,rem@rest else *)
  (*         look_up rest inf (rem@[it]) *)
  (* in *)
  (* look_up its0 inf0 [] *)
  List.find (fun inf1 -> inf0==inf1) its0

let extract_inf_props prog scc=
  let rec get_from_one_spec spec=
    match (spec) with
    | (   EList el) -> List.fold_left (fun acc (_,sf) ->
          acc@(get_from_one_spec sf)
      ) [] el
    |    EInfer ei -> let inf_obj = ei.formula_inf_obj # clone in
      if inf_obj # is_size then
        [INF_SIZE]
      else []
    | _ -> []
  in
  List.fold_left (fun acc spec -> acc@(get_from_one_spec spec)) [] scc

let proc_extract_inf_props prog proc_name=
  try
    let proc = Cast.look_up_proc_def_raw prog.Cast.new_proc_decls proc_name in
    extract_inf_props prog [proc.Cast.proc_static_specs]
  with _ -> []

let get_closed_view prog (init_vns: string list)=
  let rec dfs_find_closure working_vns done_vns=
    match working_vns with
      | [] -> done_vns
      | vn::rest -> if List.exists (fun vn1 -> string_compare vn vn1) done_vns then
          dfs_find_closure rest done_vns
        else
          let vdclr = Cast.look_up_view_def_raw 65 prog.Cast.prog_view_decls vn in
          let dep_hviews = CF.get_views_struc vdclr.Cast.view_formula in
          let vns1 = Gen.BList.remove_dups_eq string_compare (List.map (fun vn -> vn.h_formula_view_name) dep_hviews) in
          dfs_find_closure (Gen.BList.remove_dups_eq string_compare (rest@vns1)) (done_vns@[vn])
  in
  dfs_find_closure init_vns []

(*
  for each view in scc: extd with ext_pred_name
  output: [old_vn, new_vn]
*)
let extend_views iprog prog rev_formula_fnc trans_view_fnc ext_pred_names proc=
  let vns = get_views_struc proc.Cast.proc_stk_of_static_specs # top in
  let vns1 = Gen.BList.remove_dups_eq string_compare (List.map (fun vn -> vn.h_formula_view_name) vns) in
  let () =  Debug.info_hprint (add_str "vns1" (pr_list pr_id)) vns1 no_pos in
  let cl_vns1 = get_closed_view prog vns1 in
  let rev_cl_vns1 = List.rev cl_vns1 in
  let () =  Debug.info_hprint (add_str "rev_cl_vns1" (pr_list pr_id)) rev_cl_vns1 no_pos in
  let vdcls = List.map (x_add Cast.look_up_view_def_raw 65 prog.Cast.prog_view_decls) ( rev_cl_vns1) in
  let pure_extn_views = List.map (Cast.look_up_view_def_raw 65 prog.Cast.prog_view_decls) ext_pred_names in
  (* (orig_view, der_view) list *)
  let map_ext_views = Derive.expose_pure_extn iprog prog rev_formula_fnc trans_view_fnc vdcls pure_extn_views in
  map_ext_views

(* subst original view_formual by the new ones with quantifiers *)
let extend_inf iprog prog map_views proc=
  (* let vnames = get_views_struc proc.Cast.proc_stk_of_static_specs # top in *)
  let t_spec = proc.Cast.proc_stk_of_static_specs # top in
  let new_t_spec = Cfutil.subst_views_struc map_views (* struc_formula_trans_heap_node [] (formula_map (hview_subst_trans)) *) t_spec in
  let () =  Debug.ninfo_hprint (add_str "derived top spec" (Cprinter.string_of_struc_formula)) new_t_spec no_pos in
  (* let () = proc.Cast.proc_stk_of_static_specs # pop in *)
  let () = proc.Cast.proc_stk_of_static_specs # push new_t_spec in
  let n_static_spec = Cfutil.subst_views_struc map_views (* struc_formula_trans_heap_node [] (formula_map (hview_subst_trans)) *) proc.Cast.proc_static_specs in
  let () =  Debug.ninfo_hprint (add_str "derived static spec" (Cprinter.string_of_struc_formula)) n_static_spec no_pos in
  let proc0 = {proc with Cast.proc_static_specs = n_static_spec} in
  let n_dyn_spec = Cfutil.subst_views_struc map_views (* struc_formula_trans_heap_node [] (formula_map (hview_subst_trans)) *) proc0.Cast.proc_dynamic_specs in
  let () =  Debug.ninfo_hprint (add_str "derived dynamic spec" (Cprinter.string_of_struc_formula)) n_dyn_spec no_pos in
  let proc1 = {proc0 with Cast.proc_dynamic_specs = n_dyn_spec} in
  proc1

let extend_pure_props_view_x iprog cprog rev_formula_fnc trans_view_fnc proc=
  let inf_props = proc_extract_inf_props cprog proc.Cast.proc_name in
  let props = List.fold_left (fun acc io ->
      begin
        match io with
          | INF_SIZE -> acc@["size"]
          | _ -> acc
      end
  ) [] inf_props in
  if props = [] then proc else
    let map_views = extend_views iprog cprog rev_formula_fnc trans_view_fnc props proc in
    let () =  Debug.info_hprint (add_str "extend" pr_id) "3" no_pos in
    let new_proc = (extend_inf iprog cprog  map_views) proc in
    new_proc

let extend_pure_props_view iprog cprog rev_formula_fnc trans_view_fnc proc=
  let pr1 = Cprinter.string_of_struc_formula in
  let pr2 p= "top spec:" ^ (pr1 p.Cast.proc_stk_of_static_specs # top) ^ "\n" ^
    "static spec:"  ^ (pr1 p.Cast.proc_static_specs) ^ "\n" ^
     "dynamic spec:"  ^ (pr1 p.Cast.proc_dynamic_specs) ^ "\n"
  in
  Debug.no_1 "extend_pure_props_view" pr2 pr2
      (fun _ -> extend_pure_props_view_x iprog cprog rev_formula_fnc trans_view_fnc proc) proc
