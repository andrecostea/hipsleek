open Globals
open Gen
open Cformula

module DD = Debug
module CF=Cformula
module CP=Cpure
module MCP=Mcpure
module C = Cast
module TP = Tpdispatcher
(* module SAU = Sautility *)


(***********************************************)
(*****ELIM unused parameters of view **********)
let norm_elim_useless_para_x view_name sf args=
  let extract_svl f=
    let f1 = CF.elim_exists f in
    let new_f = CF.drop_views_formula f1 [view_name] in
    (* let _ = Debug.info_zprint  (lazy  (" new_f:" ^ (Cprinter.prtt_string_of_formula new_f) )) no_pos in *)
     (CF.fv new_f)
  in
  let rec build_keep_pos_list rem_args res index all=
    match rem_args with
      | [] -> res
      | a::ass -> if (CP.mem_svl a all) then
            build_keep_pos_list ass (res@[index]) (index+1) all
          else build_keep_pos_list ass (res) (index+1) all
   in
  if args = [] then (view_name, args, []) else
    let svl = extract_svl (CF.struc_to_formula sf) in
    (* let _ = Debug.info_zprint  (lazy  (" svl:" ^ (!CP.print_svl svl) )) no_pos in *)
    (* let _ = Debug.info_zprint  (lazy  (" args:" ^ (!CP.print_svl args) )) no_pos in *)
    let new_args = CP.intersect_svl args svl in
    (* let _ = Debug.info_zprint  (lazy  (" new_args:" ^ (!CP.print_svl new_args) )) no_pos in *)
    if List.length args > List.length new_args then
      let keep_pos = build_keep_pos_list args [] 0 new_args in
      let new_vname = CP.fresh_old_name view_name in
      let ss = [(view_name,new_vname,keep_pos)] in
      (* let n_sf = CF.drop_view_paras_struc_formula sf ss in *)
      (* let n_ufs = List.map ( fun (uf, ufl) -> (CF.drop_view_paras_formula uf ss, ufl)) ufs in *)
      let dropped_args = CP.diff_svl args svl in
      let _ = Debug.info_zprint  (lazy  ("  ELIMINATE parameters:" ^ (!CP.print_svl dropped_args) ^ " of view " ^ view_name ^ "\n" )) no_pos in
      (new_vname, new_args, ss)
    else
      (view_name, args, [])

let norm_elim_useless_para view_name sf args=
  let pr1 = Cprinter.string_of_struc_formula in
  let pr2 = pr_triple pr_id !CP.print_svl (pr_list (pr_triple pr_id pr_id (pr_list string_of_int))) in
  Debug.no_2 "norm_elim_useless_para" pr1 !CP.print_svl pr2
      (fun _ _ -> norm_elim_useless_para_x view_name sf args) sf args

(*assume views are sorted*)
let norm_elim_useless_x vdefs sel_vns=
  let elim_vdef ss vdef=
    let new_vdef = { vdef with
        Cast.view_formula = CF.drop_view_paras_struc_formula vdef.Cast.view_formula ss;
        Cast.view_un_struc_formula =  List.map ( fun (uf, ufl) -> (CF.drop_view_paras_formula uf ss, ufl)) vdef.Cast.view_un_struc_formula;
    }
    in
    new_vdef
  in
  let process_one_view vdef rem_vdefs=
    if List.exists (fun vn -> String.compare vn vdef.Cast.view_name = 0) sel_vns then
      (*update vdef*)
      let new_vname, view_sv_vars, ss = norm_elim_useless_para vdef.Cast.view_name vdef.Cast.view_formula  vdef.Cast.view_vars in
      (*push it back*)
      if ss = [] then ([vdef],rem_vdefs) else
        let vn = CF.mkViewNode (CP.SpecVar (Named new_vname, self, Unprimed))
          new_vname view_sv_vars no_pos in
        let f = CF.formula_of_heap vn no_pos in
        let cf = CF.struc_formula_of_heap vn no_pos in
        let link_view={vdef with
            C.view_formula = cf;
            C.view_xpure_flag = true;
            C.view_addr_vars = [];
            C.view_baga = [];
            C.view_complex_inv = None;
            C.view_mem = None;
            C.view_inv_lock = None;
            C.view_un_struc_formula = [(f, (0,"0"))];
            C.view_base_case = None;
            C.view_is_rec = false;
            C.view_pt_by_self = [new_vname];
            C.view_case_vars = [];
            C.view_raw_base_case = None;
            C.view_prune_branches = [];
            C.view_prune_conditions = [];
            C.view_prune_conditions_baga = [];
            C.view_prune_invariants = []
        } in
        let new_def = {vdef with
            Cast.view_name = new_vname;
            Cast.view_vars = view_sv_vars;} in
        (*update rem_vdefs*)
        ([link_view;(elim_vdef ss new_def)], List.map (elim_vdef ss) rem_vdefs)
    else
      ([vdef],rem_vdefs)
  in
  let rec interate_helper rem_vdefs done_vdefs=
    match rem_vdefs with
      | [] -> done_vdefs
      | vdef::rest -> let new_defs,new_rest = process_one_view vdef rest in
        interate_helper new_rest (done_vdefs@new_defs)
  in
  let normal_view, rest_views = List.partition (fun vdcl -> vdcl.Cast.view_kind = Cast.View_NORM) vdefs in
  let n_normal_view = interate_helper normal_view [] in
  (rest_views@n_normal_view)

let norm_elim_useless vdefs sel_vns=
  let pr1 = pr_list pr_id in
  let pr2 = pr_list_ln Cprinter.string_of_view_decl in
  Debug.no_2 "norm_elim_useless" pr2 pr1 pr2
      (fun _ _ -> norm_elim_useless_x vdefs sel_vns) vdefs sel_vns
(***********************************************)
   (********EXTRACT common pattern **********)
(***********************************************)
let view_to_hprel_h_formula hf0=
  let rec helper hf=
    match hf with
      | CF.Star {h_formula_star_h1 = hf1;
              h_formula_star_h2 = hf2;
              h_formula_star_pos = pos} ->
          let n_hf1,hvs1 = helper hf1 in
          let n_hf2,hvs2 = helper hf2 in
          let new_hf=
            match n_hf1,n_hf2 with
              | (HEmp,HEmp) -> HEmp
              | (HEmp,_) -> n_hf2
              | (_,HEmp) -> n_hf1
              | _ -> (Star {h_formula_star_h1 = n_hf1;
                            h_formula_star_h2 = n_hf2;
                            h_formula_star_pos = pos})
          in
          (new_hf,hvs1@hvs2)
      | CF.Conj { h_formula_conj_h1 = hf1;
               h_formula_conj_h2 = hf2;
               h_formula_conj_pos = pos} ->
          let n_hf1,hvs1 = helper hf1 in
          let n_hf2,hvs2 = helper hf2 in
          (Conj { h_formula_conj_h1 = n_hf1;
                 h_formula_conj_h2 = n_hf2;
                 h_formula_conj_pos = pos},hvs1@hvs2)
      | CF.Phase { CF.h_formula_phase_rd = hf1;
                CF.h_formula_phase_rw = hf2;
                h_formula_phase_pos = pos} ->
          let n_hf1,hvs1 = helper hf1 in
          let n_hf2,hvs2 = helper hf2 in
          (CF.Phase { CF.h_formula_phase_rd = n_hf1;
                  CF.h_formula_phase_rw = n_hf2;
                  CF.h_formula_phase_pos = pos},hvs1@hvs2)
      | CF.DataNode hd -> (hf,[])
      | CF.ThreadNode ht -> (hf,[])
      | CF.ViewNode hv ->
          let eargs = List.map (fun v -> CP.mkVar v no_pos) (hv.CF.h_formula_view_node::hv.CF.h_formula_view_arguments) in
          let nh = CF.HRel (CP.SpecVar (HpT, hv.CF.h_formula_view_name, Unprimed ),eargs, no_pos) in
          (nh, [hv])
      | CF.HRel _
      | CF.Hole _ | CF.FrmHole _
      | CF.HTrue
      | CF.HFalse
      | CF.HEmp -> (hf,[])
      | CF.StarMinus _ | CF.ConjStar _ | CF.ConjConj _ -> report_error no_pos "NORM.view_to_hprel_h_formula: not handle yet"
  in
  helper hf0

let view_to_hprel_x (f0:CF.formula) : (CF.formula*CF.h_formula_view list)=
  let rec helper f2_f=
    match f2_f with
      | Or ({formula_or_f1 = f1; formula_or_f2 = f2; formula_or_pos = pos}) ->
          let nf1,hvs1 = helper f1 in
          let nf2,hvs2 = helper f2 in
          (Or {formula_or_f1 = nf1 ; formula_or_f2 =  nf2 ; formula_or_pos = pos}, hvs1@hvs2)
      | Base b ->
          let nh,hvs= view_to_hprel_h_formula b.formula_base_heap in
          (Base { b with formula_base_heap =nh;}, hvs)
      | Exists b ->
          let nh,hvs = view_to_hprel_h_formula b.formula_exists_heap in
          (Exists {b with formula_exists_heap = nh;}, hvs)
  in
  helper f0

let view_to_hprel (f2_f:formula): (CF.formula*CF.h_formula_view list) =
  let pr1 hv= Cprinter.prtt_string_of_h_formula (CF.ViewNode hv) in
  let pr2 =pr_list pr1 in
  Debug.no_1 "view_to_hprel" !print_formula (pr_pair !print_formula pr2)
      view_to_hprel_x f2_f

let hprel_to_view_h_formula hf0=
  let rec helper hf=
    match hf with
      | CF.Star {h_formula_star_h1 = hf1;
              h_formula_star_h2 = hf2;
              h_formula_star_pos = pos} ->
          let n_hf1 = helper hf1 in
          let n_hf2 = helper hf2 in
          let new_hf=
            match n_hf1,n_hf2 with
              | (HEmp,HEmp) -> HEmp
              | (HEmp,_) -> n_hf2
              | (_,HEmp) -> n_hf1
              | _ -> (Star {h_formula_star_h1 = n_hf1;
                            h_formula_star_h2 = n_hf2;
                            h_formula_star_pos = pos})
          in
          (new_hf)
      | CF.Conj { h_formula_conj_h1 = hf1;
               h_formula_conj_h2 = hf2;
               h_formula_conj_pos = pos} ->
          let n_hf1 = helper hf1 in
          let n_hf2 = helper hf2 in
          (Conj { h_formula_conj_h1 = n_hf1;
                 h_formula_conj_h2 = n_hf2;
                 h_formula_conj_pos = pos})
      | CF.Phase { CF.h_formula_phase_rd = hf1;
                CF.h_formula_phase_rw = hf2;
                h_formula_phase_pos = pos} ->
          let n_hf1 = helper hf1 in
          let n_hf2 = helper hf2 in
          (CF.Phase { CF.h_formula_phase_rd = n_hf1;
                  CF.h_formula_phase_rw = n_hf2;
                  CF.h_formula_phase_pos = pos})
      | CF.DataNode hd -> (hf)
      | CF.ViewNode hv -> hf
      | CF.ThreadNode ht -> hf
      | CF.HRel (hp, eargs, p) ->
          let args = List.fold_left List.append [] (List.map CP.afv eargs) in
          (CF.mkViewNode (List.hd args) (CP.name_of_spec_var hp) (List.tl args) p)
      | CF.Hole _ | CF.FrmHole _
      | CF.HTrue
      | CF.HFalse
      | CF.HEmp -> (hf)
      | CF.StarMinus _ | CF.ConjStar _ | CF.ConjConj _ -> hf
  in
  helper hf0

let hprel_to_view_x (f0:formula): (CF.formula) =
  let rec helper f=
    match f with
      | CF.Or ({formula_or_f1 = f1; formula_or_f2 = f2; formula_or_pos = pos}) ->
          let nf1 = helper f1 in
          let nf2 = helper f2 in
          (Or {formula_or_f1 = nf1 ; formula_or_f2 =  nf2 ; formula_or_pos = pos})
      | CF.Base b ->
          let nh= hprel_to_view_h_formula b.formula_base_heap in
          (Base { b with formula_base_heap =nh;})
      | CF.Exists b ->
          let qvars, base1 = CF.split_quantifiers f in
          let nf = helper base1 in
          CF.add_quantifiers qvars nf
  in
  helper f0

let hprel_to_view (f2_f:formula): (CF.formula) =
  Debug.no_1 "hprel_to_view" !print_formula !print_formula 
      hprel_to_view_x f2_f

let rec look_for_anonymous_h_formula_x hf0=
  let rec helper hf=
    match hf with
      | CF.Star { h_formula_star_h1 = hf1;
                  h_formula_star_h2 = hf2}
      | StarMinus { h_formula_starminus_h1 = hf1;
                    h_formula_starminus_h2 = hf2} ->
          let hr1 = helper hf1 in
          let hr2 = helper hf2 in
          (hr1@hr2)
      | Conj { h_formula_conj_h1 = hf1;
               h_formula_conj_h2 = hf2;}
      | ConjStar { h_formula_conjstar_h1 = hf1;
                   h_formula_conjstar_h2 = hf2;}
      | ConjConj { h_formula_conjconj_h1 = hf1;
                   h_formula_conjconj_h2 = hf2;} ->
          let hr1 = (helper hf1)in
          let hr2 = (helper hf2) in
          (hr1@hr2)
      | Phase { h_formula_phase_rd = hf1;
                h_formula_phase_rw = hf2;} ->
          let hr1 = (helper hf1) in
          let hr2 = (helper hf2) in
          (hr1@hr2)
      | DataNode hd -> (* hd.CF.h_formula_data_node:: *)hd.CF.h_formula_data_arguments
      | ViewNode hv -> hv.CF.h_formula_view_node::hv.CF.h_formula_view_arguments
      | ThreadNode ht ->
          let rec helper (f:CF.formula) : (CP.spec_var list) =
            match f with
              | CF.Or ({formula_or_f1 = f1; formula_or_f2 = f2;}) -> (helper f1)@(helper f2)
              | CF.Base b -> look_for_anonymous_h_formula b.formula_base_heap
              | CF.Exists e ->
                  let qvars= look_for_anonymous_h_formula e.CF.formula_exists_heap in
                  CP.diff_svl qvars e.CF.formula_exists_qvars
          in
          ht.CF.h_formula_thread_node::(helper ht.CF.h_formula_thread_resource)
      | HRel _
      | Hole _ | CF.FrmHole _
      | HTrue
      | HFalse
      | HEmp -> []
  in
  let svl = CP.remove_dups_svl (helper hf0) in
  svl

and look_for_anonymous_h_formula hf0=
  let pr1 = Cprinter.string_of_h_formula in
  Debug.no_1 "look_for_anonymous_h_formula" pr1 !CP.print_svl
      (fun _ -> look_for_anonymous_h_formula_x hf0) hf0

and convert_anonym_to_exist_formula_x f0 args=
  let rec helper f=
    match f with
      | CF.Or ({formula_or_f1 = f1; formula_or_f2 = f2; formula_or_pos = pos}) ->
          let nf1 = helper f1 in
          let nf2 = helper f2 in
          (Or {formula_or_f1 = nf1 ; formula_or_f2 =  nf2 ; formula_or_pos = pos})
      | CF.Base b ->
          let qvars= look_for_anonymous_h_formula b.formula_base_heap in
          let qvars1 = CP.diff_svl qvars args in
          CF.add_quantifiers qvars1 f
      | CF.Exists e ->
         let qvars= look_for_anonymous_h_formula e.CF.formula_exists_heap in
         let qvars1 = CP.diff_svl qvars (args@e.CF.formula_exists_qvars) in
         CF.add_quantifiers qvars1 f
  in
  helper f0

and convert_anonym_to_exist_formula f0 args=
  let pr1 = Cprinter.string_of_formula in
  Debug.no_1 "convert_anonym_to_exist_formula" pr1 pr1
      (fun _ -> convert_anonym_to_exist_formula_x f0 args) f0

let recover_view_decl_x old_vdecl vname vvars ir f=
  let pos = CF.pos_of_struc_formula old_vdecl.C.view_formula in
  let f1 = convert_anonym_to_exist_formula f vvars in
  let cf = CF.formula_to_struc_formula f1 in
  let cf = CF.struc_formula_set_lhs_case false cf in
  (*inv = true*)
  let inv_pf = (CP.mkTrue pos) in
  let new_pf = inv_pf in
  let memo_pf_P = MCP.memoise_add_pure_P (MCP.mkMTrue pos) new_pf in
  let memo_pf_N = MCP.memoise_add_pure_N (MCP.mkMTrue pos) new_pf in
  let xpure_flag = TP.check_diff memo_pf_N memo_pf_P in
  let n_un_str =  CF.get_view_branches cf in
  let sf = [] in
  let rec f_tr_base f =
    let mf f h fl pos = if (CF.is_complex_heap h) then (CF.mkFalse fl pos)  else f in
    match f with
      | CF.Base b -> mf f b.CF.formula_base_heap b.CF.formula_base_flow b.CF.formula_base_pos
      | CF.Exists b -> mf f b.CF.formula_exists_heap b.CF.formula_exists_flow b.CF.formula_exists_pos
      | CF.Or b -> CF.mkOr (f_tr_base b.CF.formula_or_f1) (f_tr_base b.CF.formula_or_f2) no_pos
  in
  let rbc =
    if old_vdecl.C.view_is_prim then None
    else List.fold_left (fun a (c,l)->
        let fc = f_tr_base c in
        if (CF.isAnyConstFalse fc) then a
        else match a with
          | Some f1  -> Some (CF.mkOr f1 fc no_pos)
          | None -> Some fc) None n_un_str
  in
  { old_vdecl with
      C.view_name = vname;
      C.view_vars = vvars;
      C.view_formula = cf;
      C.view_x_formula = memo_pf_P;
      C.view_xpure_flag = xpure_flag;
      C.view_user_inv = memo_pf_N;
      C.view_mem = None;
      C.view_un_struc_formula = n_un_str;
      C.view_is_rec = ir;
      C.view_pt_by_self = sf;
      C.view_case_vars = CP.intersect_svl vvars (CF.guard_vars cf);
      C.view_raw_base_case = rbc;
  }

let recover_view_decl old_vdecl vname vvars ir f=
  let pr1 = Cprinter.string_of_view_decl in
  let pr2 = Cprinter.prtt_string_of_formula in
  Debug.no_4 "recover_view_decl" pr1 pr_id !CP.print_svl pr2 pr1
      (fun _ _ _ _ -> recover_view_decl_x old_vdecl vname vvars ir f) old_vdecl vname vvars f


let norm_extract_common_one_view_x iprog cprog cur_m cviews vdecl=
  let extract_view_name hf=
    match hf with
      | CF.ViewNode hv -> hv.CF.h_formula_view_name
      | _ -> report_error no_pos "Norm.norm_extract_common_one_view: hf must be a hv node"
  in
  let self_var = Cpure.SpecVar ((Named vdecl.C.view_data_name), self, Unprimed) in
  let hp = CP.SpecVar (HpT, vdecl.C.view_name, Unprimed) in
  let args = self_var::vdecl.C.view_vars in
  let unk_hps = [] in let unk_svl = [] in
  let cdefs = [] in
  let fs = CF.list_of_disjs (CF.struc_to_formula vdecl.C.view_formula) in
  (***views to hprels*******)
  let fs1 = List.map CF.elim_exists fs in
  let fs2,map = List.split (List.map view_to_hprel fs1) in
  let defs,elim_ss = Sautil.get_longest_common_hnodes_list cprog false cdefs unk_hps unk_svl
    hp self_var vdecl.C.view_vars args (List.map (fun f-> (f,None)) fs2) in
  match defs with
    | [a] -> [vdecl]
    | [(hp1,(* (_,hrel1,_,f1) *) def1);(hp2,(* (a,hrel2,_,f2) *) def2)] ->
        let _ = Debug.info_zprint  (lazy  ("  DO EXTRACT on view: "^ (!CP.print_sv hp1) ^ "\n")) no_pos in
        let f1 = CF.disj_of_list (List.map fst def1.CF.def_rhs) no_pos in
        let f2 = CF.disj_of_list (List.map fst def2.CF.def_rhs) no_pos in
        let n_f1 =
          if !Globals.pred_elim_useless then
            CF.subst_hrel_f f1 elim_ss
          else
            f1
        in
        (* let _ = Debug.info_zprint  (lazy  ("  hp2: "^ (!CP.print_sv hp2))) no_pos in *)
        (*IMPORTANT: process hp2 first + check equiv then hp1*)
        (*matching with current views*)
        let (_, eq_hfs) = Sautil.match_one_hp_views iprog cprog cur_m cviews def2 in
        let n_vdecl2, view_ss=
          if eq_hfs = [] then
             let _ = Debug.info_zprint  (lazy  ("  DO SYNTHESIZE view: "^ (!CP.print_sv hp2) ^ "\n")) no_pos in 
            let _,args2 = CF.extract_HRel def2.CF.def_lhs in
            let vname2 = (CP.name_of_spec_var hp2) in
            let self_var2 = Cpure.SpecVar ((Named vname2), self, Unprimed) in
            let ss = [(List.hd args2, self_var2)] in
            let n_f21 = hprel_to_view f2 in
            let n_f22 = CF.subst ss n_f21 in
            let n_vdecl2 = recover_view_decl vdecl vname2 (List.tl args2) vdecl.C.view_is_rec n_f22 in
            ([n_vdecl2],None)
          else
            let eq_hf = List.hd eq_hfs in
            let eq_vn = extract_view_name eq_hf in
            let _ = Debug.info_zprint  (lazy  ("  DO NOT SYNTHESIZE. MATCHED view: "^ (eq_vn) ^ "\n")) no_pos in 
            let to_hp = CP.SpecVar (HpT, eq_vn, Unprimed) in
            ([], Some ([hp2], to_hp))
        in
        (*hp1 must equal hp*)
        (* let _ = Debug.info_zprint  (lazy  ("  hp1: "^ (!CP.print_sv hp1))) no_pos in *)
        (***hprels to views*******)
        let n_f10 =
          match view_ss with
            | None -> n_f1
            | Some (from_hps, to_hp) -> CF.subst_hprel n_f1 from_hps to_hp
        in
        let n_f11 = hprel_to_view n_f10 in
        let n_vdecl1 = recover_view_decl vdecl vdecl.C.view_name vdecl.C.view_vars false n_f11 in
        n_vdecl2@[n_vdecl1]
    | _ -> report_error no_pos "norm:norm_extract_common_one_view: sth wrong"

let norm_extract_common_one_view iprog cprog cur_m cviews vdecl=
  let pr1 = Cprinter.string_of_view_decl in
  Debug.no_1 "norm_extract_common_one_view" pr1 (pr_list_ln pr1)
      (fun _ -> norm_extract_common_one_view_x iprog cprog cur_m cviews vdecl) vdecl

let norm_extract_common iprog cprog cviews sel_vns=
  let rec process_helper rem_vs done_vs=
    match rem_vs with
      | [] -> done_vs
      | vdecl::rest ->
          let n_vdecls =
            if List.exists (fun vn -> String.compare vn vdecl.Cast.view_name = 0) sel_vns then
              norm_extract_common_one_view iprog cprog [] (done_vs@rest) vdecl
            else [vdecl]
          in
          process_helper rest (done_vs@n_vdecls)
  in
  (*not sure it is necessary*)
  (* process_helper cviews [] *)
  cviews


(*****************************************************************)
   (********END EXTRACT common pattern **********)
(*****************************************************************)
let cont_para_analysis_view cprog vdef other_vds=
  (* cont paras are the paras that are
     - reachable from self
     - not defined in inductive branch
  *)
  let self_sv = CP.SpecVar (Named vdef.Cast.view_data_name, self, Unprimed) in
  let process_branch_x vname args f=
    let _, vns, _ = CF.get_hp_rel_formula f in
    if vns = [] then args else
      let _, reach_dns, reach_vns = look_up_reachable_ptrs_w_alias cprog f [self_sv] 3 in
      let ( _,mix_f,_,_,_) = CF.split_components f in
      let eqs = (MCP.ptr_equations_without_null mix_f) in
      let rec_vns, other_vns = List.partition (fun vn -> String.compare vn.CF.h_formula_view_name vname = 0) vns in
      (*cont paras are para not changed, just forwarded*)
      (* let cont_paras = List.fold_left (fun cur_cont_paras vn -> *)
      (*     let closed_rec_args = if eqs = [] then vn.CF.h_formula_view_arguments else *)
      (*       CF.find_close vn.CF.h_formula_view_arguments eqs *)
      (*     in *)
      (*     CP.intersect_svl cur_cont_paras closed_rec_args *)
      (* ) args rec_vns *)
      (* in *)
      let root_dn_svl, para_dn_svl = List.fold_left (fun (r1,r2) dn -> (r1@[dn.CF.h_formula_data_node], r2@dn.CF.h_formula_data_arguments) ) ([],[]) reach_dns in
      let root_vn_svl, para_vn_svl = List.fold_left (fun (r1,r2) vn -> (r1@[vn.CF.h_formula_view_node], r2@vn.CF.h_formula_view_arguments) ) ([],[]) reach_vns in
      let null_svls = CP.remove_dups_svl ((MCP.get_null_ptrs mix_f) ) in
      let defined_svl = CF.find_close (root_dn_svl@root_vn_svl@null_svls) eqs in
      let cont_svl = CP.diff_svl ( CF.find_close (para_dn_svl@para_vn_svl) eqs) defined_svl in
      CP.intersect_svl args  cont_svl
      (* process other_vns*)
      (* try *)
      (*   let cont_paras1 = List.fold_left (fun cur_cont_paras vn -> *)
      (*       let cont_args = Cast.look_up_cont_args vn.CF.h_formula_view_arguments vn.CF.h_formula_view_name other_vds in *)
      (*       let closed_rec_args = *)
      (*         if eqs = [] then cont_args else *)
      (*           CP.remove_dups_svl ((CF.find_close cont_args eqs)@cont_args) *)
      (*       in *)
      (*       CP.intersect_svl cur_cont_paras closed_rec_args *)
      (*   ) cont_paras other_vns *)
      (*   in *)
      (*   cont_paras1 *)
      (* with Not_found -> cont_paras *)
  in
  let process_branch vname args f=
    let pr1 = Cprinter.prtt_string_of_formula in
    let pr2 = !CP.print_svl in
    Debug.no_3 "cont_process_branch" pr_id pr2 pr1 pr2
        (fun _ _ _ -> process_branch_x vname args f) vname args f
  in
  let vname = vdef.Cast.view_name in
  let args = vdef.Cast.view_vars in
  let cont_paras = List.fold_left (fun cur_cont_paras (f,_) ->
      let br_cont_paras = (process_branch vname args f) in
          CP.intersect_svl cur_cont_paras br_cont_paras
      ) args vdef.Cast.view_un_struc_formula
  in
  {vdef with Cast.view_cont_vars = cont_paras}

(*assume cviews are sorted*)
let cont_para_analysis_x cprog cviews=
  let rec loop_helper rem_cviews done_cviews=
    match rem_cviews with
      | [] -> done_cviews
      | vdef::rest ->
            (*if non recursive then not check*)
            let new_vdef = if vdef.Cast.view_is_rec then
              cont_para_analysis_view cprog vdef done_cviews
            else vdef
            in
            loop_helper rest (done_cviews@[new_vdef])
  in
  loop_helper cviews []

let cont_para_analysis cprog cviews=
  (* let pr0 = pr_list_ln Cprinter.string_of_view_decl in *)
  (* let pr1 = pr_pair pr_id !CP.print_svl in *)
  let pr2a = Cprinter.string_of_view_decl in
  (* let pr2 vdef = pr1 (vdef.Cast.view_name, vdef.Cast.view_cont_vars) in *)
  let pr3 = pr_list pr2a in
  Debug.no_1 "cont_para_analysis" pr3 pr3
      (fun _ -> cont_para_analysis_x cprog cviews) cviews


let norm_split_args iprog cprog cview=
  cview


(*****************************************************************)
   (********END PARA CONTINUATION ANALYSIS **********)
(*****************************************************************)
let compute_base_case_raw branches=
  let rec get_base r f=
     match f with
       | CF.Base b -> 
            if is_empty_heap b.CF.formula_base_heap then
              r@[(MCP.pure_of_mix b.CF.formula_base_pure)]
            else r
       | CF.Exists _ ->
            let _, base = CF.split_quantifiers f in
            get_base r base
       | CF.Or _ -> r
  in
  let ps = List.fold_left (fun r (f,_) -> get_base r f) [] branches in
  match ps with
    | [p] -> Some p
    | _ -> None


let norm_ann_seg_opz_x iprog cprog cviews=
  (*************INTERNAL***************)
  (*a view can be applied for seg optimization if:
    - seg
    - exists base case = emp
  *)
  let compute_seg_opz view=
    let is_seg, seg_emp_base = if view.Cast.view_cont_vars = [] then
      (false, None)
    else
      match view.Cast.view_base_case with
        | None -> begin
            (*re-compute by other ways*)
            match compute_base_case_raw view.Cast.view_un_struc_formula with
              | Some p -> (true, Some p)
              | None -> (false, None)
          end
        | Some (p,_) -> begin
            let neq_null_svl = Cpure.get_neq_null_svl p in
          if neq_null_svl != [] then
            (false, None)
          else
            (true, Some p)
          end
    in
    is_seg, {view with Cast.view_seg_opz = seg_emp_base}
  in
  (*************END INTERNAL***************)
  let cviews1 = if !Globals.norm_cont_analysis then cviews
  else cont_para_analysis cprog cviews
  in
  List.fold_left (fun (b, r) v ->
      let b1, n_v = compute_seg_opz v in
      (b || b1, r@[n_v])
  ) (false, []) cviews1

let norm_ann_seg_opz iprog cprog cviews=
  let pr1 v =
    let pr = pr_quad pr_id Cprinter.string_of_struc_formula !CP.print_svl (pr_opt !CP.print_formula) in
    pr (v.Cast.view_name, v.Cast.view_formula,  v.Cast.view_cont_vars, v.Cast.view_seg_opz)
  in
  let pr2 = pr_list_ln pr1 in
  Debug.no_1 "norm_ann_seg_opz" pr2 (pr_pair string_of_bool pr2)
      (fun _ -> norm_ann_seg_opz_x iprog cprog cviews) cviews

  (************* NORM for the FORMULA USED DURING UNFOLDING ***************)

and norm_formula_for_unfold cprog vdef = 
  let new_un_formula = List.map (fun (def,l) -> ((Cvutil.remove_imm_from_formula cprog def (CP.ConstAnn(Lend))), l)) vdef.C.view_un_struc_formula in
  {vdef with C.view_un_struc_formula =  new_un_formula;}

  (*********** end NORM for the FORMULA USED DURING UNFOLDING *************)

  (************* MERGE STATES with IDENTICAL FORMULAS (syntactic check) ***************)
let octx_2_es_list (ctx: CF.context): CF.entail_state list =
  let rec helper ctx =
    match ctx with
      | CF.Ctx es       -> [es]
      | CF.OCtx (c1,c2) -> (helper c1)@(helper c2)
  in helper ctx

let eq_estate (es1: CF.entail_state) (es2: CF.entail_state): bool =
  let equals = 
    try 
      fst (Checkeq.checkeq_formulas [] es1.CF.es_formula es2.CF.es_formula)
    with _ -> false in
  equals

let eq_context (ctx1: CF.context) (ctx2: CF.context): bool =
  match ctx1, ctx2 with
    | CF.Ctx es1, CF.Ctx es2 -> eq_estate es1 es2
    | CF.OCtx _, CF.OCtx _   ->
          let es_l1, es_l2 = octx_2_es_list ctx1, octx_2_es_list ctx2 in
          Gen.BList.list_setequal_eq  eq_estate es_l1 es_l2
    | _, _ -> false

let merge_contexts_x (ctx: CF.list_context): CF.list_context =
  match ctx with
    | FailCtx _        -> ctx
    | SuccCtx ctx_list -> SuccCtx (Gen.BList.remove_dups_eq eq_context ctx_list)

let merge_contexts (ctx: CF.list_context): CF.list_context =
  let pr = Cprinter.string_of_list_context in
  Debug.no_1 "merge_contexts" pr pr  merge_contexts_x ctx

  (********** end MERGE STATES with IDENTICAL FORMULAS (syntactic check) ***************)
