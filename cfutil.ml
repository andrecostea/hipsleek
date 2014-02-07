open Globals
open Gen
open Cformula

module DD = Debug
(* module CF = Cformula *)
module CP = Cpure
module MCP = Mcpure
module C = Cast
module I = Iast


let keep_data_view_hpargs_nodes prog f hd_nodes hv_nodes keep_rootvars keep_hpargs=
  let keep_ptrs = look_up_reachable_ptr_args prog hd_nodes hv_nodes keep_rootvars in
  drop_data_view_hpargs_nodes f check_nbelongsto_dnode check_nbelongsto_vnode
    check_neq_hpargs keep_ptrs keep_ptrs keep_hpargs

let keep_data_view_hpargs_nodes prog f hd_nodes hv_nodes keep_rootvars keep_hpargs=
  let pr1 = Cprinter.prtt_string_of_formula in
  let pr2 = pr_list (pr_pair !CP.print_sv !CP.print_svl) in
  Debug.no_3 "keep_data_view_hpargs_nodes" pr1 !CP.print_svl pr2 pr1
      (fun _ _ _ -> keep_data_view_hpargs_nodes prog f hd_nodes hv_nodes keep_rootvars keep_hpargs)
      f keep_rootvars keep_hpargs

let obtain_reachable_formula prog f roots=
  let (h ,mf,_,_,_) = split_components f in
  let hds, hvs, hrs = get_hp_rel_h_formula h in
  let eqsets = (MCP.ptr_equations_without_null mf) in
  let reach_ptrs= look_up_reachable_ptrs_w_alias_helper prog hds hvs eqsets roots in
  let hpargs = List.map (fun (hp,eargs,_) -> (hp, List.concat (List.map CP.afv eargs))) hrs in
  let sel_hpargs = List.filter (fun (_,args) -> CP.diff_svl args reach_ptrs = []) hpargs in
  let reach_f = keep_data_view_hpargs_nodes prog f hds hvs reach_ptrs sel_hpargs in
  reach_f

let obtain_reachable_formula prog f roots=
  let pr1 = !print_formula in
  let pr2 = !CP.print_svl in
  Debug.no_2 "obtain_reachable_formula" pr1 pr2 pr1
      (fun _ _ -> obtain_reachable_formula prog f roots)
      f roots

let find_dependent_hps_x hp_defs=
  let get_dep_hps eqs def=
    let f = disj_of_list (List.map fst def.def_rhs) no_pos in
    let hps = get_hp_rel_name_formula f in
    let hp0, _ = extract_HRel def.def_lhs in
    let n_eqs = List.fold_left  (fun r hp1 -> if CP.eq_spec_var hp0 hp1 then r
    else r@[(hp0, hp1)]) [] hps in
    eqs@n_eqs
  in
  let hps = List.fold_left (fun r def ->
      match def.def_cat with
        | CP.HPRelDefn (hp,_,_) -> r@[hp]
        | _ -> r
  ) [] hp_defs in
  let tpl_aset = CP.EMapSV.mkEmpty in
  let eqs = List.fold_left (get_dep_hps) [] hp_defs in
  let tpl_aset1 = List.fold_left (fun tpl (sv1,sv2) -> CP.add_equiv_eq tpl sv1 sv2) tpl_aset eqs in
  CP.EMapSV.partition tpl_aset1

let find_dependent_hps hp_defs=
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  let pr2 = pr_list_ln !CP.print_svl in
  Debug.no_1 "find_dependent_hps" pr1 pr2
      (fun _ -> find_dependent_hps_x hp_defs) hp_defs

 (*sort order of nrec_grps to subst*)
let hp_defs_topo_sort_x hp_defs=
  (*******INTERNAL********)
  let ini_order_from_grp def=
    let hp,_ = extract_HRel def.def_lhs in
    (def,hp,0) (*called one topo*)
  in
  let is_mutrec scc_defs =
    let rec dfs working trav_hps eqs=
      match working with
        | []-> false
        | hp::rest ->
              if CP.mem_svl hp trav_hps then true else
                let child_hps = List.fold_left (fun r (sv1, sv2) ->
                    if CP.eq_spec_var hp sv1 then r@[sv2] else r
                ) [] eqs in
                dfs (rest@(CP.remove_dups_svl child_hps)) (trav_hps@[hp]) eqs
    in
    let scc_hps, deps = List.fold_left (fun (r1,r2) (def,hp, _)->
        let succ_hps = List.fold_left (fun r (f,_) -> r@(get_hp_rel_name_formula f)) [] def.def_rhs in
        (r1@[hp], r2@(List.map (fun hp1 -> (hp,hp1))
            (List.filter (fun hp1 -> not (CP.eq_spec_var hp hp1)) (CP.remove_dups_svl succ_hps))))
    ) ([],[]) scc_defs in
    ( List.exists (fun hp -> dfs [hp] [] deps) scc_hps)
  in
  let rec partition hpdefs scc res=
    match scc with
      | [] -> res
      | hp::rest ->
            try
              let hp_defs = List.find (fun ((_,hp1,_) as r) -> CP.eq_spec_var hp hp1) hpdefs in
              partition hpdefs rest (res@[hp_defs])
            with _ -> partition hpdefs rest res
  in
  let topo_sort scc_defs=
    (*get name of n_rec_hps, intial its number with 0*)
    let update_order_from_def updated_hps incr (def,hp, old_n)=
      if CP.mem_svl hp updated_hps then
        (def,hp,old_n+incr)
      else (def,hp,old_n)
    in
  (*each grp, find succ_hp, add number of each succ hp + 1*)
    let process_one_def topo (def,hp,_)=
      let succ_hps = List.fold_left (fun r (f,_) -> r@(get_hp_rel_name_formula f)) [] def.def_rhs in
      (*remove dups*)
      let succ_hps1 = Gen.BList.remove_dups_eq CP.eq_spec_var succ_hps in
      (* DD.ninfo_pprint ("       process_dep_group succ_hps: " ^ (!CP.print_svl succ_hps)) no_pos; *)
      (*remove itself hp and unk_hps*)
      let succ_hps2 = List.filter (fun hp1 -> not (CP.eq_spec_var hp1 hp))  succ_hps1 in
      List.map (update_order_from_def succ_hps2 1) topo
    in
    (*detect mutrec*)
    if is_mutrec scc_defs then (true, scc_defs) else
      let topo1 = List.fold_left process_one_def scc_defs scc_defs in
      (*sort decreasing and return the topo list*)
      let topo2 = List.sort (fun (_,_,n1) (_,_,n2) -> n1-n2) topo1 in
      (false, topo2)
  in
  (******END*INTERNAL********)
  let eqhp_sccs = find_dependent_hps hp_defs in
  let hp_defs1 = List.map ini_order_from_grp hp_defs in
  let scc_hp_defs1 = List.map (fun eqs -> partition hp_defs1 eqs []) eqhp_sccs in
  let scc_hp_defs2 = List.map topo_sort scc_hp_defs1 in
  let sort_hpdefs, mutrec_hpdefs = List.fold_left (fun (r1,r2) (is_mut, scc) ->
      let hp_defs = List.map (fun (def,_,_) -> def) scc in
      if is_mut then (r1,r2@hp_defs) else (r1@[hp_defs], r2)
  ) ([],[]) scc_hp_defs2 in
  sort_hpdefs, mutrec_hpdefs

(*for debugging*)
let hp_defs_topo_sort defs=
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  Debug.no_1 "hp_defs_topo_sort" pr1 (pr_pair (pr_list_ln pr1) pr1)
      (fun _ -> hp_defs_topo_sort_x defs) defs

(*
(i) build emap for LHS/RHS 
  - eqnull -> make closure. do not subst
  - cycle nodes: DO NOT subst
  - inside one preds, do not subst
(ii) common free vars for both LHS/RHS
(iii) subs both sides to use smallest common vars
        lhs     |- P(v* )
*)

let cmp_fn sv1 sv2 = let n= String.compare (CP.name_of_spec_var sv1) (CP.name_of_spec_var sv2) in
  if n=0 then
    if CP.primed_of_spec_var sv1 = Unprimed then -1 else 1
  else n
let build_subst_comm_x args prog_vars emap comm_svl=
  (* let find_comm_eq ls_eq sv= *)
  (*   if List.exists (fun svl -> CP.mem_svl sv svl) ls_eq then ls_eq else *)
  (*     let com_eq_svl = CP.EMapSV.find_equiv_all sv emap in *)
  (*     if com_eq_svl = [] then ls_eq else *)
  (*       ls_eq@[com_eq_svl] *)
  (* in *)
  let build_subst subst evars=
    let inter1 = CP.intersect_svl evars prog_vars in
    let keep_sv = if inter1 <> [] then
      List.hd (List.sort cmp_fn inter1)
    else
      let inter2 = CP.intersect_svl evars args in
      if inter2 <> [] then
        List.hd (List.sort cmp_fn inter2)
      else
        let evars1 = List.sort cmp_fn evars in
        List.hd evars1
    in
    let new_ss = List.fold_left (fun r sv -> if CP.eq_spec_var keep_sv sv then r else r@[(sv, keep_sv)]) [] evars in
    subst@new_ss
  in
  let epart0 = CP.EMapSV.partition emap in
  (* let ls_com_eq_svl = List.fold_left find_comm_eq [] comm_svl in *)
  let ls_com_eq_svl, ls_non_com_eq_svl = List.partition (fun svl ->
      CP.intersect_svl svl comm_svl <> []
  ) epart0 in
  let ss1 =  if ls_com_eq_svl = [] then [] else
    List.fold_left build_subst [] ls_com_eq_svl
  in
  let ss2 = if ls_non_com_eq_svl = [] then [] else
    List.fold_left build_subst [] ls_non_com_eq_svl
  in
  (ss1@ss2)

let build_subst_comm args prog_vars emap comm_svl=
  let pr1 = CP.EMapSV.string_of in
  let pr2 =  !CP.print_svl in
  let pr3 = pr_list (pr_pair !CP.print_sv !CP.print_sv ) in
  Debug.no_4 "SAU.build_subst_comm" pr2 pr2 pr1 pr2 pr3
      (fun _ _ _ _ ->  build_subst_comm_x args prog_vars emap comm_svl)
      args prog_vars emap comm_svl

let expose_expl_closure_eq_null_x lhs_b lhs_args emap0=
  let rec find_equiv_all eparts sv all_parts=
    match eparts with
      | [] -> [],all_parts
      | ls::rest -> if CP.mem_svl sv ls then (ls,all_parts@rest) else
          find_equiv_all rest sv (all_parts@[ls])
  in
  let look_up_eq_null (epart, ls_null_args, ls_expl_eqs, ss) sv=
    (* let eq_nulls,rem_parts = find_equiv_all epart sv [] in *)
    let eq_nulls,rem_parts = find_equiv_all epart sv [] in
    let eq_null_args = CP.intersect_svl eq_nulls lhs_args in
    if List.length eq_null_args > 1 then
      let eq_null_args1 = (List.sort cmp_fn eq_null_args) in
      let keep_sv = List.hd eq_null_args1 in
      let ss2 = List.fold_left (fun ss1 sv ->
          if CP.eq_spec_var keep_sv sv then ss1
          else ss1@[(sv, keep_sv)]
      ) [] eq_nulls
      in
      let ss3 = List.map (fun sv -> (sv, keep_sv) ) (List.tl eq_null_args1) in
      (rem_parts, ls_null_args@eq_null_args, ls_expl_eqs@ss3,ss@ss2)
    else (epart, ls_null_args, ls_expl_eqs, ss)
  in
  let eq_null_svl = CP.remove_dups_svl (MCP.get_null_ptrs lhs_b.formula_base_pure) in
  let epart0 = CP.EMapSV.partition emap0 in
  let rem_parts, eq_null_args, expl_eq_args, ss = List.fold_left look_up_eq_null (epart0, [],[],[]) eq_null_svl in
  let cls_e_null = List.map (fun sv -> CP.mkNull sv no_pos) eq_null_args in
  (* let expl_eq_ps = List.map (fun (sv1,sv2) -> CP.mkEqVar sv1 sv2 no_pos) expl_eq_args in *)
  (CP.EMapSV.un_partition rem_parts, (* expl_eq_ps@ *)cls_e_null, ss)


let expose_expl_closure_eq_null lhs_b lhs_args emap=
  let pr1 = CP.EMapSV.string_of in
  let pr2 = pr_list !CP.print_formula in
  let pr3 = pr_list (pr_pair !CP.print_sv !CP.print_sv ) in
  Debug.no_1 "SAU.expose_expl_closure_eq_null" pr1 (pr_triple pr1 pr2 pr3)
      (fun _ -> expose_expl_closure_eq_null_x lhs_b lhs_args emap) emap
(*
  - cycle nodes: DO NOT subst
  - inside one preds, do not subst

for each ls_eqs, if it contains at least two vars of the same group,
  - we remove this ls_eqs
  - add equality in lhs
 input:
  - emap: global emap (no r_qemap)
  - groups of args of unknown preds + args + data nodes
 output:
  - triple of (remain emap, equalifty formula to be added to lhs, ss for pure of lhs
  rhs
*)
let expose_expl_eqs_x emap0 prog_vars vars_grps0=
  (*move root to behind, donot loss it*)
  let roots = List.fold_left (fun roots0 args -> match args with
    | r::_ -> roots0@[r]
    | _ -> roots0
  ) [] vars_grps0 in
  let all_vars = List.concat vars_grps0 in
  let process_one_ls_eq ls_eqs =
    let ls_eq_args = List.fold_left (fun r args ->
        let inter = CP.intersect_svl args ls_eqs in
        if List.length inter > 1 then r@[inter] else r
        ) [] vars_grps0 in
    let ls_eq_args1 = List.sort (fun ls1 ls2 -> List.length ls2 - List.length ls1) ls_eq_args in
    let ls_eq_args2 = Gen.BList.remove_dups_eq (Gen.BList.subset_eq CP.eq_spec_var) ls_eq_args1 in
    if ls_eq_args2=[] then (false,[],[])
    else
      (* let _ = Debug.info_hprint (add_str  "ls_eq_args2 " (pr_list !CP.print_svl)) ls_eq_args2 no_pos in *)
      (*explicit equalities*)
      let expl_eqs, link_svl = List.fold_left (fun (r, keep_svl) ls ->
          let ls1 = List.sort cmp_fn ls in
          (* let inter = CP.intersect_svl roots ls1 in *)
          let keep_sv = (* if inter <> [] then List.hd inter else *) List.hd ls1 in
          (r@(List.map (fun sv -> (sv, keep_sv)) (List.tl ls1)), keep_svl@[keep_sv])
      ) ([],[]) ls_eq_args2
      in
      (*link among grps*)
      let link_expl_eqs = if link_svl = [] then [] else
        let link_svl1 = List.sort cmp_fn link_svl in
        let fst_sv = List.hd link_svl1 in
        List.map (fun sv -> (sv, fst_sv)) (List.tl link_svl1)
      in
      (*subst for others*)
      let keep_sv =
        let _ = Debug.ninfo_hprint (add_str  "link_svl" !CP.print_svl) link_svl no_pos in
        let inters1 = CP.intersect_svl (prog_vars) link_svl in
        let _ = Debug.ninfo_hprint (add_str  "inters1" !CP.print_svl) inters1 no_pos in
        if inters1 != [] then List.hd inters1 else
          (* let inters0 = CP.intersect_svl roots link_svl in *)
          (* let _ = Debug.info_hprint (add_str  "inters0" !CP.print_svl) inters0 no_pos in *)
          (* if inters0 != [] then List.hd (inters0) else *)
            let inters = CP.intersect_svl all_vars link_svl in
            let _ = Debug.ninfo_hprint (add_str  "inters" !CP.print_svl) inters no_pos in
          if inters = [] then List.hd (List.sort cmp_fn link_svl)
          else List.hd inters
      in
      (* let _ = Debug.info_hprint (add_str  "keep_sv " !CP.print_sv) keep_sv no_pos in *)
      (* let _ = Debug.info_hprint (add_str  "ls_eqs " !CP.print_svl) ls_eqs no_pos in *)
      let ss2 = List.fold_left (fun ss1 sv ->
          if CP.eq_spec_var keep_sv sv then ss1
          else ss1@[(sv, keep_sv)]
      ) [] ls_eqs
      in
      (true, expl_eqs@link_expl_eqs,ss2)
  in
  let epart0 = CP.EMapSV.partition emap0 in
  let rem_eparts, ls_eq_args, expl_eq_args,sst = List.fold_left (fun (r_eparts, r_eq_args, r_eqs, r_ss) ls_eqs->
      let b, n_eqs, n_ss = process_one_ls_eq ls_eqs in
      if b then
        (r_eparts, r_eq_args@[ls_eqs], r_eqs@n_eqs, r_ss@n_ss)
      else (r_eparts@[ls_eqs], r_eq_args, r_eqs, r_ss)
  ) ([],[],[],[]) epart0 in
  let expl_eq_ps = List.map (fun (sv1,sv2) -> CP.mkEqVar sv1 sv2 no_pos) expl_eq_args in
  (CP.EMapSV.un_partition rem_eparts, ls_eq_args, expl_eq_ps ,sst)

let expose_expl_eqs emap prog_vars vars_grps=
  let pr1 = pr_list_ln !CP.print_svl in
  let pr2 = CP.EMapSV.string_of in
  let pr3 = pr_list (pr_pair !CP.print_sv !CP.print_sv ) in
  let pr4 = pr_quad pr2 pr1 (pr_list !CP.print_formula) pr3 in
  Debug.no_2 "SAU.expose_expl_eqs" pr2 pr1 pr4
      (fun _ _ -> expose_expl_eqs_x emap prog_vars vars_grps)
      emap vars_grps

let h_subst ss ls_eq_args0 hf0=
  let rec is_expl_eqs ls_eq_args svl =
    match ls_eq_args with
      | [] -> false
      | eqs::rest ->
            if List.length (CP.intersect_svl eqs svl) > 1 then true else
              is_expl_eqs rest svl
  in
  match hf0 with
    | DataNode dn ->
          let svl = dn.h_formula_data_node::dn.h_formula_data_arguments in
          if is_expl_eqs ls_eq_args0 svl then hf0 else
            let hf1 = h_subst ss hf0 in
            hf1
    | ViewNode vn ->
          let svl = vn.h_formula_view_node::vn.h_formula_view_arguments in
          if is_expl_eqs ls_eq_args0 svl then hf0 else
            let hf1 = h_subst ss hf0 in
            hf1
    | HRel (hp, eargs, pos) ->
          let svl = List.fold_left List.append [] (List.map CP.afv eargs) in
          let _ = Debug.ninfo_hprint (add_str  "svl " !CP.print_svl) svl no_pos in
          if is_expl_eqs ls_eq_args0 svl then hf0 else
            let hf1 = h_subst ss hf0 in
            hf1
    | _ -> hf0


let smart_subst_new_x lhs_b rhs_b hpargs l_emap r_emap r_qemap unk_svl prog_vars=
  let largs= h_fv lhs_b.formula_base_heap in
  let rargs= h_fv rhs_b.formula_base_heap in
  let all_args = CP.remove_dups_svl (largs@rargs) in
  (*---------------------------------------*)
  let lsvl = fv (Base lhs_b) in
  let rsvl = (fv (Base rhs_b))@(CP.EMapSV.get_elems r_emap)@(CP.EMapSV.get_elems r_qemap) in
  let comm_svl = CP.intersect_svl lsvl rsvl in
  let lhs_b1, rhs_b1, prog_vars =
    if comm_svl = [] then
      (lhs_b, rhs_b, prog_vars)
    else
      let l_emap1, null_ps, null_sst = expose_expl_closure_eq_null lhs_b all_args l_emap in
      let emap0 = CP.EMapSV.merge_eset l_emap r_emap in
      let vars_grps = (get_data_node_ptrs_group_hf lhs_b.formula_base_heap)@(get_data_node_ptrs_group_hf rhs_b.formula_base_heap)@
        (List.map snd hpargs)
      in
      let emap0a, ls_eq_args, expl_eqs_ps, eq_sst = expose_expl_eqs emap0 prog_vars vars_grps in
      (* let _ = Debug.info_hprint (add_str  "ls_eq_args " (pr_list !CP.print_svl)) ls_eq_args no_pos in *)
      let emap1 = CP.EMapSV.merge_eset emap0a r_qemap in
      let ss = build_subst_comm all_args prog_vars emap1 comm_svl in
      let pr_ss = pr_list (pr_pair !CP.print_sv !CP.print_sv) in
      (* let _ = Debug.info_hprint (add_str  "ss " (pr_ss)) ss no_pos in *)
      (*LHS*)
      let lhs_b1 = subst_b ss lhs_b in
      let lhs_pure1 = MCP.pure_of_mix lhs_b1.formula_base_pure in
      let lhs_pure2 = CP.subst (null_sst@eq_sst) lhs_pure1 in
      let lpos = pos_of_formula (Base lhs_b1) in
      let lhs_pure_w_expl = CP.conj_of_list (lhs_pure2::(null_ps@expl_eqs_ps)) lpos in
      let lhs_b2 = {lhs_b1 with formula_base_pure = MCP.mix_of_pure
              (CP.remove_redundant lhs_pure_w_expl);
          formula_base_heap = trans_heap_hf (h_subst (null_sst@eq_sst) ls_eq_args) lhs_b1.formula_base_heap;
      } in
      (*RHS*)
      let rhs_b1 = subst_b ss rhs_b in
      (* let _ = Debug.info_hprint (add_str  "rhs_b1 " Cprinter.prtt_string_of_formula) (Base rhs_b1) no_pos in *)
      let rhs_b2 = {rhs_b1 with formula_base_pure = MCP.mix_of_pure
              (CP.remove_redundant (MCP.pure_of_mix rhs_b1.formula_base_pure));
          formula_base_heap = trans_heap_hf (h_subst (null_sst@eq_sst) ls_eq_args) rhs_b1.formula_base_heap;
      } in
      (lhs_b2, rhs_b2, CP.subst_var_list (ss@null_sst@eq_sst) prog_vars)
  in
  (lhs_b1, rhs_b1, prog_vars)

let smart_subst_new lhs_b rhs_b hpargs l_emap r_emap r_qemap unk_svl prog_vars=
  let pr1 = Cprinter.string_of_formula_base in
  let pr2 = !CP.print_svl in
  let pr3 = CP.EMapSV.string_of in
  let pr4 = pr_list (pr_pair !CP.print_sv !CP.print_svl) in
  Debug.no_7 "smart_subst_new" pr1 pr1 pr4 pr2 pr3 pr3 pr3 (pr_triple pr1 pr1 pr2)
      (fun _ _ _ _ _ _ _-> smart_subst_new_x lhs_b rhs_b hpargs l_emap r_emap r_qemap unk_svl prog_vars)
      lhs_b rhs_b hpargs prog_vars l_emap r_emap r_qemap

let elim_dangling_conj_star_hf unk_hps f0 =
  let rec helper f=
    match f with
      | HRel _
      | DataNode _ | ViewNode _ 
      | HTrue | HFalse | HEmp | Hole _-> f
      | Phase b -> Phase {b with h_formula_phase_rd = helper b.h_formula_phase_rd;
            h_formula_phase_rw = helper b.h_formula_phase_rw}
      | Conj b -> begin
           let hpargs1_opt = get_HRel b.h_formula_conj_h1 in
           let hpargs2_opt = get_HRel b.h_formula_conj_h2 in
           match hpargs1_opt,hpargs2_opt with
             | Some (hp1,_), Some (hp2, _) -> begin
                 let b1 = CP.mem_svl hp1 unk_hps in
                 let b2 = CP.mem_svl hp2 unk_hps in
                 match b1,b2 with
                   | false,false -> f
                   | true,false -> b.h_formula_conj_h2
                   | _ -> b.h_formula_conj_h1
               end
             | Some (hp1, _),_ -> if CP.mem_svl hp1 unk_hps then b.h_formula_conj_h2 else f
             | _ , Some (hp2, _) -> if CP.mem_svl hp2 unk_hps then b.h_formula_conj_h1 else f
             | _ -> f
        end
      | Star b -> begin let hf2 = helper b.h_formula_star_h2 in
        let hf1 = helper b.h_formula_star_h1 in
        match hf1,hf2 with
          | HEmp,HEmp -> HEmp
          | HEmp,_ -> hf2
          | _ , HEmp -> hf1
          | _ ->
            Star {b with h_formula_star_h2 = hf2; h_formula_star_h1 = hf1}
        end
      | ConjStar _|ConjConj _|StarMinus _ -> f
  in
  helper f0

let rec elim_dangling_conj_star struc_trav f =
  let recf = elim_dangling_conj_star struc_trav in
  match f with
    | Base b-> Base{b with  formula_base_heap = struc_trav b.formula_base_heap}
    | Exists b-> Exists{b with  formula_exists_heap =  struc_trav b.formula_exists_heap}
    | Or b-> Or {b with formula_or_f1 = recf b.formula_or_f1;formula_or_f2 = recf b.formula_or_f2}

let is_heap_conjs_hf hf0=
  let rec helper hf=
    match hf with
      | Conj _ -> true
      | Star b -> (helper b.h_formula_star_h2) || (helper b.h_formula_star_h1)
      | _ -> false
  in
  helper hf0

let rec is_heap_conjs f=
  match f with
    | Base b-> is_heap_conjs_hf b.formula_base_heap
    | Exists b->  is_heap_conjs_hf b.formula_exists_heap
    | Or b-> is_heap_conjs b.formula_or_f1 || is_heap_conjs b.formula_or_f2

let contain_folall_pure f=
  let p = get_pure f in
  CP.is_forall p


let unfold_non_rec_views prog unfold_fnc is_view_rec_fnc f=
  let vnodes = get_views f in
  if vnodes = [] then
    f
  else
    (*filter non_rec vnodes*)
    let nrec_vnodes = List.filter (fun vn ->
        try
          not (is_view_rec_fnc vn.h_formula_view_name)
        with _ -> false
    ) vnodes in
    if nrec_vnodes = [] then f else
      let nf, _ = List.fold_left (fun (f,ss) sv0 ->
          let sv = CP.subst_var_par ss sv0 in
          (* let _ = print_endline ("-- unfold lsh on " ^ (Cprinter.string_of_spec_var sv)) in *)
          let nf,ss1 = unfold_fnc f sv in
          (nf, ss@ss1)
      ) (f, []) (List.map (fun vn -> vn.h_formula_view_node) nrec_vnodes)
      in nf

let unfold_non_rec_views prog unfold_fnc is_view_rec_fnc f=
  let pr1 = !print_formula in
  Debug.no_1 "unfold_non_rec_views" pr1 pr1
      (fun _ -> unfold_non_rec_views prog unfold_fnc is_view_rec_fnc f)
      f
