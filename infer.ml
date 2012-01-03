open Globals
module DD = Debug
open Gen
open Exc.GTable
open Perm
open Cformula
open Context
open Cpure

module Err = Error
module CP = Cpure
module MCP = Mcpure
module CF = Cformula
module TP = Tpdispatcher

let no_infer estate = (estate.es_infer_vars == [])

let no_infer_rel estate = (estate.es_infer_vars_rel == [])
 
let remove_infer_vars_all estate =
  let iv = estate.es_infer_vars in
   ({estate with es_infer_vars=[];}, iv) 

let remove_infer_vars_partial estate rt =
  let iv = estate.es_infer_vars in
  if (iv==[]) then (estate,iv)
  else ({estate with es_infer_vars=CP.diff_svl iv rt;}, iv) 

let remove_infer_vars_partial estate rt =
  let pr1 = !print_entail_state in
  let pr2 = !print_svl in
  Debug.no_2 "remove_infer_vars_partial" pr1 pr2 (pr_pair pr1 pr2) 
      remove_infer_vars_partial estate rt 

let rec remove_infer_vars_all_ctx ctx =
  match ctx with
  | Ctx estate -> 
        let (es,_) = remove_infer_vars_all estate in
        Ctx es
  | OCtx (ctx1, ctx2) -> OCtx (remove_infer_vars_all_ctx ctx1, remove_infer_vars_all_ctx ctx2)

let remove_infer_vars_all_partial_context (a,pc) = 
  (a,List.map (fun (b,c) -> (b,remove_infer_vars_all_ctx c)) pc)

let remove_infer_vars_all_list_context ctx = 
  match ctx with
  | FailCtx _ -> ctx
  | SuccCtx lst -> SuccCtx (List.map remove_infer_vars_all_ctx lst)

let remove_infer_vars_all_list_partial_context lpc = 
  List.map remove_infer_vars_all_partial_context lpc

(* let collect_pre_heap_list_partial_context (ctx:list_partial_context) = *)
(*   let r = List.map (fun (_,cl) -> List.concat (List.map (fun (_,c) -> collect_pre_heap c) cl))  ctx in *)
(*   List.concat r *)

let rec restore_infer_vars_ctx iv ctx = 
  match ctx with
  | Ctx estate -> 
        if iv==[] then ctx
        else Ctx {estate with es_infer_vars=iv;}
  | OCtx (ctx1, ctx2) -> OCtx (restore_infer_vars_ctx iv ctx1, restore_infer_vars_ctx iv ctx2)

let add_impl_vars_ctx iv ctx =
  let rec helper ctx = 
    match ctx with
      | Ctx estate -> Ctx {estate with es_gen_impl_vars = iv@estate.es_gen_impl_vars;}
      | OCtx (ctx1, ctx2) -> OCtx (helper ctx1, helper ctx2)
  in helper ctx

let add_impl_vars_list_partial_context iv (ctx:list_partial_context) =
  List.map (fun (fl,bl) -> (fl, List.map (fun (t,b) -> (t,add_impl_vars_ctx iv b)) bl)) ctx

let restore_infer_vars iv cl =
  if (iv==[]) then cl
  else match cl with
    | FailCtx _ -> cl
    | SuccCtx lst -> SuccCtx (List.map (restore_infer_vars_ctx iv) lst)

let rec get_all_args alias_of_root heap = match heap with
  | ViewNode h -> h.h_formula_view_arguments
  | Star s -> (get_all_args alias_of_root s.h_formula_star_h1) @ (get_all_args alias_of_root s.h_formula_star_h2)
  | Conj c -> (get_all_args alias_of_root c.h_formula_conj_h1) @ (get_all_args alias_of_root c.h_formula_conj_h1)
  | Phase p -> (get_all_args alias_of_root p.h_formula_phase_rd) @ (get_all_args alias_of_root p.h_formula_phase_rw) 
  | _ -> []


let is_inferred_pre_list_context ctx = 
  match ctx with
  | FailCtx _ -> false
  | SuccCtx lst -> List.exists CF.is_inferred_pre_ctx lst

let is_inferred_pre_list_context ctx = 
  Debug.no_1 "is_inferred_pre_list_context"
      !print_list_context string_of_bool
      is_inferred_pre_list_context ctx

(* let rec is_inferred_pre_list_context = match ctx with *)
(*   | Ctx estate -> is_inferred_pre estate  *)
(*   | OCtx (ctx1, ctx2) -> (is_inferred_pre_ctx ctx1) || (is_inferred_pre_ctx ctx2) *)

let collect_pre_heap_list_context ctx = 
  match ctx with
  | FailCtx _ -> []
  | SuccCtx lst -> List.concat (List.map collect_pre_heap lst)

let collect_infer_vars_list_context ctx = 
  match ctx with
  | FailCtx _ -> []
  | SuccCtx lst -> List.concat (List.map collect_infer_vars lst)

let collect_formula_list_context ctx = 
  match ctx with
  | FailCtx _ -> []
  | SuccCtx lst -> List.concat (List.map collect_formula lst)

let collect_pre_heap_list_partial_context (ctx:list_partial_context) =
  let r = List.map (fun (_,cl) -> List.concat (List.map (fun (_,c) -> collect_pre_heap c) cl))  ctx in
  List.concat r

let collect_infer_vars_list_partial_context (ctx:list_partial_context) =
  let r = List.map (fun (_,cl) -> List.concat (List.map (fun (_,c) -> collect_infer_vars c) cl))  ctx in
  List.concat r

let collect_formula_list_partial_context (ctx:list_partial_context) =
  let r = List.map (fun (_,cl) -> List.concat (List.map (fun (_,c) -> collect_formula c) cl))  ctx in
  List.concat r

let collect_pre_pure_list_context ctx = 
  match ctx with
  | FailCtx _ -> []
  | SuccCtx lst -> List.concat (List.map collect_pre_pure lst)

let collect_pre_pure_list_partial_context (ctx:list_partial_context) =
  let r = List.map (fun (_,cl) -> List.concat (List.map (fun (_,c) -> collect_pre_pure c) cl))  ctx in
  List.concat r

let collect_rel_list_context ctx = 
  match ctx with
  | FailCtx _ -> []
  | SuccCtx lst -> List.concat (List.map collect_rel lst)

let collect_rel_list_partial_context (ctx:list_partial_context) =
  let r = List.map (fun (_,cl) -> List.concat (List.map (fun (_,c) -> collect_rel c) cl))  ctx in
  List.concat r

let collect_rel_list_partial_context (ctx:list_partial_context) =
  let pr1 = !CF.print_list_partial_context in
  let pr2 = pr_list print_lhs_rhs in
  Debug.no_1 "collect_rel_list_partial_context"  pr1 pr2
      collect_rel_list_partial_context ctx
 
let init_vars ctx infer_vars iv_rel orig_vars = 
  let rec helper ctx = 
    match ctx with
      | Ctx estate -> Ctx {estate with es_infer_vars = infer_vars; es_infer_vars_rel = iv_rel}
      | OCtx (ctx1, ctx2) -> OCtx (helper ctx1, helper ctx2)
  in helper ctx

(* let conv_infer_heap hs = *)
(*   let rec helper hs h = match hs with *)
(*     | [] -> h *)
(*     | x::xs ->  *)
(*       let acc =  *)
(* 	    Star({h_formula_star_h1 = x; *)
(* 	      h_formula_star_h2 = h; *)
(* 	      h_formula_star_pos = no_pos}) *)
(*         in helper xs acc in *)
(*   match hs with *)
(*     | [] -> HTrue  *)
(*     | x::xs -> helper xs x *)

(* let extract_pre_list_context x =  *)
(*   (\* TODO : this has to be implemented by extracting from es_infer_* *\) *)
(*   (\* print_endline (!print_list_context x); *\) *)
(*   None *)

let to_unprimed_data_root aset h =
  let r = h.h_formula_data_node in
  if CP.is_primed r then
    let alias = CP.EMapSV.find_equiv_all r aset in
    let alias = List.filter (CP.is_unprimed) alias in
    (match alias with
      | [] -> h
      | (ur::_) -> {h with h_formula_data_node = ur})
  else h

let to_unprimed_view_root aset h =
  let r = h.h_formula_view_node in
  if CP.is_primed r then
    let alias = CP.EMapSV.find_equiv_all r aset in
    let alias = List.filter (CP.is_unprimed) alias in
    (match alias with
      | [] -> h
      | ur::_ -> {h with h_formula_view_node = ur})
  else h

(* get exactly one root of h_formula *)
let get_args_h_formula aset (h:h_formula) =
  let av = CP.fresh_spec_var_ann () in
  match h with
    | DataNode h -> 
          let h = to_unprimed_data_root aset h in
          let root = h.h_formula_data_node in
          let arg = h.h_formula_data_arguments in
          let new_arg = CP.fresh_spec_vars_prefix "inf" arg in
          if (!Globals.allow_imm) then
            Some (root, arg,new_arg, [av],
            DataNode {h with h_formula_data_arguments=new_arg;
              h_formula_data_imm = mkPolyAnn av})
          else
            Some (root, arg,new_arg, [],
            DataNode {h with h_formula_data_arguments=new_arg})
    | ViewNode h -> 
          let h = to_unprimed_view_root aset h in
          let root = h.h_formula_view_node in
          let arg = h.h_formula_view_arguments in
          let new_arg = CP.fresh_spec_vars_prefix "inf" arg in
          if (!Globals.allow_imm) then
            Some (root, arg,new_arg, [av],
            ViewNode {h with h_formula_view_arguments=new_arg; 
              h_formula_view_imm = mkPolyAnn av} )
          else
            Some (root, arg,new_arg, [],
            ViewNode {h with h_formula_view_arguments=new_arg})
    | _ -> None

(*

  Cformula.h_formula ->
  (Cformula.CP.spec_var * Cformula.CP.spec_var list * CP.spec_var list *
   CP.spec_var list * Cformula.h_formula)
  option

*)

let get_args_h_formula aset (h:h_formula) =
  let pr1 = !print_h_formula in
  let pr2 = pr_option (pr_penta !print_sv !print_svl !print_svl !print_svl pr1) in
  Debug.no_1 "get_args_h_formula" pr1 pr2 (fun _ -> get_args_h_formula aset h) h

let get_alias_formula (f:CF.formula) =
  let (h, p, fl, b, t) = split_components f in
  let eqns = (MCP.ptr_equations_without_null p) in
  eqns

(* let get_alias_formula (f:CF.formula) = *)
(*   Debug.no_1 "get_alias_formula" !print_formula !print_pure_f get_alias_formula f *)

let build_var_aset lst = CP.EMapSV.build_eset lst

let is_elem_of conj conjs =
 (* let filtered = List.filter (fun c -> TP.imply_raw conj c && TP.imply_raw c conj) conjs in *)
  let filtered = List.filter (fun c -> CP.equalFormula conj c) conjs in
  match filtered with
    | [] -> false
    | _ -> true

let is_elem_of conj conjs = 
  let pr = !CP.print_formula in
  Debug.no_1 "is_elem_of" pr pr_no (fun _ -> is_elem_of conj conjs) conj

            (* (b,args,inf_arg,h,new_iv,over_iv,[orig_r]) in *)
            (* (List.exists (CP.eq_spec_var_aset lhs_aset r) *)
            (*    iv,args,inf_arg,h,new_iv,over_iv,[r]) in *)
            (* let args_al = List.map (fun v -> CP.EMapSV.find_equiv_all v rhs_aset) args in *)
(* (\* let _ = print_endline ("LHS aliases: "^(pr_list (pr_pair !print_sv !print_sv) lhs_als)) in *\) *)
(* (\* let _ = print_endline ("RHS aliases: "^(pr_list (pr_pair !print_sv !print_sv) rhs_als)) in *\) *)
(* let _ = print_endline ("root: "^(pr_option (fun (r,_,_,_) -> !print_sv r) rt)) in *)
(* let _ = print_endline ("rhs node: "^(!print_h_formula rhs)) in *)
(* let _ = print_endline ("renamed rhs node: "^(!print_h_formula new_h)) in *)
(* (\* let _ = print_endline ("heap args: "^(!print_svl args)) in *\) *)
(* (\* let _ = print_endline ("heap inf args: "^(!print_svl inf_vars)) in *\) *)
(* (\* let _ = print_endline ("heap arg aliases: "^(pr_list !print_svl args_al)) in *\) *)
(* let _ = print_endline ("root in iv: "^(string_of_bool b)) in *)
(* (\* let _ = print_endline ("RHS exist vars: "^(!print_svl es.es_evars)) in *\) *)
(* (\* let _ = print_endline ("RHS impl vars: "^(!print_svl es.es_gen_impl_vars)) in *\) *)
(* (\* let _ = print_endline ("RHS expl vars: "^(!print_svl es.es_gen_expl_vars)) in *\) *)
(* (\* let _ = print_endline ("imm pure stack: "^(pr_list !print_mix_formula es.es_imm_pure_stk)) in *\) *)

(* let aux_test () = *)
(*       DD.trace_pprint "hello" no_pos *)
(* let aux_test () = *)
(*       Debug.no_1_loop "aux_test" pr_no pr_no aux_test () *)
(* let aux_test2 () = *)
(*       DD.trace_pprint "hello" no_pos *)
(* let aux_test2 () = *)
(*       Debug.no_1_num 13 "aux_test2" pr_no pr_no aux_test2 () *)

let infer_heap_nodes (es:entail_state) (rhs:h_formula) rhs_rest conseq pos = 
  if no_infer es then None
  else 
    let iv = es.es_infer_vars in
    let dead_iv = es.es_infer_vars_dead in
    let lhs_als = get_alias_formula es.es_formula in
    let lhs_aset = build_var_aset lhs_als in
    let rt = get_args_h_formula lhs_aset rhs in
    (* let _ = aux_test() in *)
    (* let _ = aux_test2() in *)
    (*  let rhs_als = get_alias_formula conseq in *)
    (*  let rhs_aset = build_var_aset rhs_als in *) 
    match rt with 
      | None -> None
      | Some (orig_r,args,inf_arg,inf_av,inf_rhs) -> 
            (* let (b,args,inf_vars,new_h,new_iv,iv_alias,r) = match rt with (\* is rt captured by iv *\) *)
            (*   | None -> (false,[],[],HTrue,iv,[],[]) *)
            (*   | Some (orig_r,args,inf_arg,inf_av,h) ->  *)
            let alias = CP.EMapSV.find_equiv_all orig_r lhs_aset in
            let rt_al = [orig_r]@alias in (* set of alias with root of rhs *)
            let over_dead = CP.intersect dead_iv rt_al in
            let iv_alias = CP.intersect iv rt_al in 
            let b = (over_dead!=[] || iv_alias == []) in (* does alias of root intersect with iv? *)
            (* let new_iv = (CP.diff_svl (inf_arg@iv) rt_al) in *)
            (* let alias = if List.mem orig_r iv then [] else alias in *)
            if b then None
            else 
              begin
                let new_iv = inf_av@inf_arg@iv in
                (* Take the alias as the inferred pure *)
                (* let iv_al = CP.intersect iv iv_alias in (\* All relevant vars of interest *\) *)
                (* let iv_al = CP.diff_svl iv_al r in *)
                (* iv_alias certainly has one element *)
                let new_r = List.hd iv_alias in
                (* each heap node may only be instantiated once *)
                (* let new_iv = diff_svl new_iv [new_r] in *)
                (* above cause incompleteness in 3.slk (29) & (30). *)
                let new_h = 
                  if CP.eq_spec_var orig_r new_r 
                  then inf_rhs
                  else 
                    (* replace with new root name *)
                    set_node_var new_r inf_rhs 
                in
                (* let _ = print_endline ("iv_alias:"^(!CP.print_svl iv_alias)) in *)
                (* let _ = print_endline ("orig root:"^(!CP.print_sv orig_r)) in *)
                (* let _ = print_endline ("new root:"^(!CP.print_sv new_r)) in *)
                (* let _ = print_endline ("new hform:"^(!print_h_formula new_h)) in *)
                (* we do not need to add lhs_root=iv into the inf_pure as info is in LHS*)
                (* let new_p = List.fold_left (fun p1 p2 -> CP.mkAnd p1 p2 no_pos) (CP.mkTrue no_pos)  *)
                (*   (List.map (fun a -> CP.BForm (CP.mkEq_b (CP.mkVar a no_pos) r no_pos, None)) iv_al) in *)
                (* let new_p = (CP.mkTrue no_pos) in *)
                let lhs_h,_,_,_,_ = CF.split_components es.es_formula in
                (* why is orig_ante being used?????? *)
                (* let _,ante_pure,_,_,_ = CF.split_components es.es_orig_ante in *)
                (* let ante_conjs = CP.list_of_conjs (MCP.pure_of_mix ante_pure) in *)
                (* let new_p_conjs = CP.list_of_conjs new_p in *)
                (* let new_p = List.fold_left (fun p1 p2 -> CP.mkAnd p1 p2 no_pos) (CP.mkTrue no_pos) *)
                (*   (List.filter (fun c -> not (is_elem_of c ante_conjs)) new_p_conjs) in *)
                DD.devel_pprint ">>>>>> infer_heap_nodes <<<<<<" pos;
                DD.devel_hprint (add_str "unmatch RHS : " !print_h_formula) rhs pos;
                DD.devel_hprint (add_str "orig inf vars : " !print_svl) iv pos;
                DD.devel_hprint (add_str "inf LHS heap:" !print_h_formula) new_h pos;
                DD.devel_hprint (add_str "new inf vars: " !print_svl) new_iv pos;
                DD.devel_hprint (add_str "dead inf vars: " !print_svl) iv_alias pos;
                (* DD.devel_hprint (add_str "new pure add: " !CP.print_formula) new_p pos; *)
                let r = {
                    match_res_lhs_node = new_h;
                    match_res_lhs_rest = lhs_h;
                    match_res_holes = [];
                    match_res_type = Root;
                    match_res_rhs_node = rhs;
                    match_res_rhs_rest = rhs_rest;
                } in
                let act = M_match r in
                (
                    (* WARNING : any dropping of match action must be followed by pop *)
                    must_action_stk # push act;
                    Some (new_iv,new_h,iv_alias))
              end


(*
type: Cformula.entail_state ->
  Cformula.h_formula ->
  Cformula.h_formula ->
  'a -> (Cformula.CP.spec_var list * Cformula.h_formula) option
*)
let infer_heap_nodes (es:entail_state) (rhs:h_formula) rhs_rest conseq pos = 
  let pr1 = !print_entail_state_short in
  let pr2 = !print_h_formula in
  let pr3 = pr_option (pr_triple !print_svl pr2 !print_svl) in
  Debug.to_2 "infer_heap_nodes" pr1 pr2 pr3
      (fun _ _ -> infer_heap_nodes es rhs rhs_rest conseq pos) es rhs

(* TODO : this procedure needs to be improved *)
(* picks ctr from f that are related to vars *)
(* may involve a weakening process *)
let rec filter_var f vars = match f with
  | CP.Or (f1,f2,l,p) -> 
        CP.Or (filter_var f1 vars, filter_var f2 vars, l, p)
  | _ -> if TP.is_sat_raw f then CP.filter_var f vars else CP.mkFalse no_pos
(*        let flag = TP.is_sat_raw f                                 *)
(*          try                                                      *)
(*            Omega.is_sat_weaken f "0"                              *)
(*          with _ -> true                                           *)
(*              (* spurious pre inf when set to true; check 2c.slk *)*)
(*        in
        if flag
        then CP.filter_var f vars 
        else CP.mkFalse no_pos*)

let filter_var f vars =
  let pr = !print_pure_f in
  Debug.no_2 "i.filter_var" pr !print_svl pr filter_var f vars 

let simplify_helper f = match f with
  | BForm ((Neq _,_),_) -> f
  | Not _ -> f
  | _ -> TP.simplify_raw f

(* TODO : this simplify could be improved *)
let simplify f vars = TP.simplify_raw (filter_var (TP.simplify_raw f) vars)
let simplify_contra f vars = filter_var f vars

let simplify f vars =
  let pr = !print_pure_f in
  Debug.no_2 "i.simplify" pr !print_svl pr simplify f vars 

let infer_lhs_contra pre_thus lhs_xpure ivars pos msg =
  (* if ivars==[] then None *)
  (* else *)
  let lhs_xpure_orig = MCP.pure_of_mix lhs_xpure in
  let lhs_xpure = CP.drop_rel_formula lhs_xpure_orig in
  let check_sat = TP.is_sat_raw lhs_xpure in
  if not(check_sat) then None
  else 
    let f = simplify_contra lhs_xpure ivars in
    let vf = CP.fv f in
    let over_v = CP.intersect vf ivars in
    if (over_v ==[]) then None
    else 
      let exists_var = CP.diff_svl vf ivars in
      let f = simplify_helper (CP.mkExists exists_var f None pos) in
      if CP.isConstTrue f || CP.isConstFalse f then None
      else 
        let neg_f = Redlog.negate_formula f in
        let b = if CP.isConstTrue pre_thus then false
          else let f = CP.mkAnd pre_thus neg_f no_pos in
               not(TP.is_sat_raw f) 
        in
        DD.devel_pprint ">>>>>> infer_lhs_contra <<<<<<" pos; 
        DD.devel_hprint (add_str "trigger cond   : " pr_id) msg pos; 
        DD.devel_hprint (add_str "LHS pure       : " !print_formula) lhs_xpure_orig pos; 
        DD.devel_hprint (add_str "ovrlap inf vars: " !print_svl) over_v pos; 
        DD.devel_hprint (add_str "new pre infer   : " !print_formula) neg_f pos; 
        DD.devel_hprint (add_str "pre thus   : " !print_formula) pre_thus pos; 
        DD.devel_hprint (add_str "contradict?: " string_of_bool) b pos; 
        Some (neg_f)

let infer_lhs_contra pre_thus f ivars pos msg =
  let pr = !print_mix_formula in
  let pr2 = !print_pure_f in
  Debug.no_2 "infer_lhs_contra" pr !print_svl (pr_option pr2) 
      (fun _ _ -> infer_lhs_contra pre_thus f ivars pos msg) f ivars

let infer_lhs_contra_estate estate lhs_xpure pos msg =
  if no_infer estate then None
  else
    let ivars = estate.es_infer_vars in
    let p_thus = estate.es_infer_pure_thus in
    let r = infer_lhs_contra p_thus lhs_xpure ivars pos msg in
    match r with
      | None -> None
      | Some pf ->
            (* let prev_inf_h = estate.es_infer_heap in *)
            (* let prev_inf_p = estate.es_infer_pure in *)
            (* let _ = print_endline ("\nprev inf heap:"^(pr_list !print_h_formula prev_inf_h)) in *)
            (* let _ = print_endline ("prev inf pure:"^(pr_list !CP.print_formula prev_inf_p)) in *)
            let new_estate = CF.false_es_with_orig_ante estate estate.es_formula pos in

            Some (new_estate,pf)

let infer_lhs_contra_estate e f pos msg =
  let pr0 = !print_entail_state_short in
  let pr = !print_mix_formula in
  Debug.no_2 "infer_lhs_contra_estate" pr0 pr (pr_option pr0) (fun _ _ -> infer_lhs_contra_estate e f pos msg) e f

(*
   should this be done by ivars?
   (i) (lhs & rhs contradict)
       lhs & rhs --> false 
       find a lhs to negate to make state false
   (ii) rhs --> lhs (rhs is stronger)
        find a stronger rhs to add to lhs
*)
(* let infer_lhs_rhs_pure lhs_simp rhs_simp ivars (\* evars *\) = *)
(*   if ivars ==[] then None *)
(*   else  *)
(*     let fml = CP.mkAnd lhs_simp rhs_simp no_pos in *)
(*     let check_sat = Omega.is_sat fml "0" in *)
(*     if not(check_sat) then *)
(*       (\* lhs & rhs |- false *\) *)
(*       let f = simplify lhs_simp ivars in *)
(*       let vf = CP.fv f in *)
(*       let over_v = CP.intersect vf ivars in *)
(*       if (over_v ==[]) then None *)
(*       else Some (Redlog.negate_formula f) *)
(*     else  *)
(*       (\* rhs -> lhs *\) *)
(*       None *)

(* let infer_lhs_rhs_pure lhs rhs ivars = *)
(*   let pr = !print_pure_f in *)
(*   Debug.no_3 "infer_lhs_rhs_pure" pr pr !print_svl (pr_option pr) infer_lhs_rhs_pure lhs rhs ivars *)

(* let infer_lhs_rhs_pure_es estate lhs_xpure rhs_xpure pos = *)
(*   let ivars = estate.es_infer_vars in *)
(*   if ivars == [] then None *)
(*   else  *)
(*     let lhs_xpure = MCP.pure_of_mix lhs_xpure in *)
(*     let rhs_xpure = MCP.pure_of_mix rhs_xpure in *)
(*     let lhs_simp = simplify lhs_xpure ivars in *)
(*     let rhs_simp = simplify rhs_xpure ivars in *)
(*     let r = infer_lhs_rhs_pure lhs_simp rhs_simp ivars in *)
(*     match r with *)
(*       | None -> None *)
(*       | Some pf -> *)
(*             let new_estate = *)
(*               {estate with  *)
(*                   es_formula = normalize 0 estate.es_formula (CF.formula_of_pure_formula pf pos) pos; *)
(*                   es_infer_pure = estate.es_infer_pure@[pf]; *)
(*               } in *)
(*             Some new_estate *)

let helper fml lhs_rhs_p = 
  let new_fml = CP.mkAnd fml lhs_rhs_p no_pos in
  if TP.is_sat_raw new_fml then
    let args = CP.fv new_fml in
    let iv = CP.fv fml in
    let quan_var = CP.diff_svl args iv in
    CP.mkExists_with_simpl TP.simplify_raw quan_var new_fml None no_pos
  else CP.mkFalse no_pos

let rec simplify_disjs pf lhs_rhs =
  match pf with
  | BForm _ -> if CP.isConstFalse pf then pf else helper pf lhs_rhs
  | And _ -> helper pf lhs_rhs
  | Or (f1,f2,l,p) -> mkOr (simplify_disjs f1 lhs_rhs) (simplify_disjs f2 lhs_rhs) l p
  | Forall (s,f,l,p) -> Forall (s,simplify_disjs f lhs_rhs,l,p)
  | Exists (s,f,l,p) -> Exists (s,simplify_disjs f lhs_rhs,l,p)
  | _ -> pf

let present_in (orig_ls:CP.formula list) (new_pre:CP.formula) : bool =
  (* not quite needed, it seems *)
  (* let disj_p = CP.split_disjunctions new_pre in *)
  (* List.exists (fun a -> List.exists (CP.equalFormula a) disj_p) orig_ls *)
  List.exists (CP.equalFormula new_pre) orig_ls


let infer_pure_m estate lhs_xpure_orig rhs_xpure pos =
  if no_infer estate then (None,None)
  else
    let rhs_xpure = MCP.pure_of_mix rhs_xpure in
    if not (TP.is_sat_raw rhs_xpure) then 
      (DD.devel_pprint "Cannot infer a precondition: RHS contradiction" pos;
      (None,None))
    else
      let lhs_xpure = MCP.pure_of_mix lhs_xpure_orig in
      (* let rhs_vars = CP.fv rhs_xpure in *)
      (* below will help greatly reduce the redundant information inferred from state *)
      (* let lhs_xpure = CP.filter_ante lhs_xpure rhs_xpure in *)
      let _ = DD.trace_hprint (add_str "lhs: " !CP.print_formula) lhs_xpure pos in
      let _ = DD.trace_hprint (add_str "rhs: " !CP.print_formula) rhs_xpure pos in
      let lhs_xpure = CP.filter_ante lhs_xpure rhs_xpure in
      let _ = DD.trace_hprint (add_str "lhs (after filter_ante): " !CP.print_formula) lhs_xpure pos in
      let fml = CP.mkAnd lhs_xpure rhs_xpure pos in
      let fml = CP.drop_rel_formula fml in
      let iv = estate.es_infer_vars in
      let check_sat = TP.is_sat_raw fml in
      if not(check_sat) then 
        (infer_lhs_contra_estate estate lhs_xpure_orig pos "ante contradict with conseq",None)
      else
      (*let invariants = List.fold_left (fun p1 p2 -> CP.mkAnd p1 p2 pos) (CP.mkTrue pos) estate.es_infer_invs in*)
      (* if check_sat then *)
      (*      let new_p = simplify fml iv in                            *)
      (*      let new_p = simplify (CP.mkAnd new_p invariants pos) iv in*)
      (*      if CP.isConstTrue new_p then None                         *)
      (*      else                                                      *)
      let args = CP.fv fml in
      let quan_var = CP.diff_svl args iv in
      let new_p = TP.simplify_raw (CP.mkForall quan_var 
          (CP.mkOr (CP.mkNot_s lhs_xpure) rhs_xpure None pos) None pos) in
      let _ = DD.trace_hprint (add_str "fml: " !CP.print_formula) fml pos in
      let _ = DD.trace_hprint (add_str "quan_var: " !CP.print_svl) quan_var pos in
      let _ = DD.trace_hprint (add_str "iv: " !CP.print_svl) iv pos in
      let _ = DD.trace_hprint (add_str "new_p1: " !CP.print_formula) new_p pos in
      let new_p = TP.simplify_raw (simplify_disjs new_p fml) in
      let _ = DD.trace_hprint (add_str "new_p2: " !CP.print_formula) new_p pos in
      let args = CP.fv new_p in
      let new_p =
        if CP.intersect args iv == [] && quan_var != [] then
          let new_p = if CP.isConstFalse new_p then fml else CP.mkAnd fml new_p pos in
          let _ = DD.trace_hprint (add_str "new_p3: " !CP.print_formula) new_p pos in
          let new_p = simplify new_p iv in
          let _ = DD.trace_hprint (add_str "new_p4: " !CP.print_formula) new_p pos in
          (*let new_p = simplify (CP.mkAnd new_p invariants pos) iv in*)
          let args = CP.fv new_p in
          let quan_var = CP.diff_svl args iv in
          TP.simplify_raw (CP.mkExists quan_var new_p None pos)
        else
          simplify new_p iv
      in
      (* abstract common terms from disj into conjunctive form *)
      if CP.isConstTrue new_p || CP.isConstFalse new_p then 
        begin
            DD.devel_pprint ">>>>>> infer_pure_m <<<<<<" pos;
            DD.devel_pprint "Did not manage to infer a useful precondition" pos;
            DD.devel_hprint (add_str "LHS : " !CP.print_formula) lhs_xpure pos;               
            DD.devel_hprint (add_str "RHS : " !CP.print_formula) rhs_xpure pos;
            (* DD.devel_hprint (add_str "new pure: " !CP.print_formula) new_p pos; *)
            DD.devel_hprint (add_str "new pure: " !CP.print_formula) new_p pos;
            (None,None)
        end
      else
        let new_p_good = CP.simplify_disj_new new_p in
        (* remove ctr already present in the orig LHS *)
        let lhs_orig_list = CP.split_conjunctions lhs_xpure in
        let pre_list = CP.split_conjunctions new_p_good in
        let (red_pre,pre_list) = List.partition (present_in lhs_orig_list) pre_list in
        if pre_list==[] then (None,None)
        else 
          let new_p_good = CP.join_conjunctions pre_list in
        (* filter away irrelevant constraint for infer_pure *)
        (* let new_p_good = CP.filter_ante new_p rhs_xpure in *)
        (* let _ = print_endline ("new_p:"^(!CP.print_formula new_p)) in *)
        (* let _ = print_endline ("new_p_good:"^(!CP.print_formula new_p_good)) in *)
        (* should not be using es_orig_ante *)
        (* let _,ante_pure,_,_,_ = CF.split_components estate.es_orig_ante in *)
        (* let ante_conjs = CP.list_of_conjs (MCP.pure_of_mix ante_pure) in *)
        (* let new_p_conjs = CP.list_of_conjs new_p_good in *)
        (* below redundant with filter_ante *)
       (* let new_p = List.fold_left (fun p1 p2 -> CP.mkAnd p1 p2 pos) (CP.mkTrue pos) *)
       (*    (List.filter (fun c -> not (is_elem_of c ante_conjs)) new_p_conjs) in *)
        (* if CP.isConstTrue new_p || CP.isConstFalse new_p then (None,None) *)
        (* else *)
          begin
            DD.devel_pprint ">>>>>> infer_pure_m <<<<<<" pos;
            DD.devel_hprint (add_str "LHS : " !CP.print_formula) lhs_xpure pos;               
            DD.devel_hprint (add_str "RHS : " !CP.print_formula) rhs_xpure pos;
            (* DD.devel_hprint (add_str "new pure: " !CP.print_formula) new_p pos; *)
            if red_pre!=[] then DD.devel_hprint (add_str "already in LHS: " (pr_list !CP.print_formula)) red_pre pos;
            DD.devel_hprint (add_str "new pure: " !CP.print_formula) new_p_good pos;
            (None,Some new_p_good)
          end
              (* Thai: Should check if the precondition overlaps with the orig ante *)
              (* And simplify the pure in the residue *)
              (*           let new_es_formula = normalize 0 estate.es_formula (CF.formula_of_pure_formula new_p pos) pos in *)
              (* (\*          let h, p, fl, b, t = CF.split_components new_es_formula in                                                 *\) *)
              (* (\*          let new_es_formula = Cformula.mkBase h (MCP.mix_of_pure (Omega.simplify (MCP.pure_of_mix p))) t fl b pos in*\) *)
              (*           let args = List.filter (fun v -> if is_substr "inf" (name_of_spec_var v) then true else false) (CP.fv new_p) in *)
              (*           let new_iv = CP.diff_svl iv args in *)
              (*           let new_estate = *)
              (*             {estate with  *)
              (*                 es_formula = new_es_formula; *)
              (*                 (\* es_infer_pure = estate.es_infer_pure@[new_p]; *\) *)
              (*                 es_infer_vars = new_iv *)
              (*             } *)
              (*           in *)
    (* below removed because of ex/bug-3e.slk *)
    (* else *)
    (*   (\* contradiction detected *\) *)
    (*   (infer_lhs_contra_estate estate lhs_xpure_orig pos "ante contradict with conseq",None) *)
(*       let check_sat = TP.is_sat_raw lhs_xpure in *)
(*       if not(check_sat) then None *)
(*       else *)
(*         let lhs_simplified = simplify lhs_xpure iv in *)
(*         let args = CP.fv lhs_simplified in *)
(*         let exists_var = CP.diff_svl args iv in *)
(*         let lhs_simplified = simplify_helper (CP.mkExists exists_var lhs_simplified None pos) in *)
(*         (\*let new_p = simplify_contra (CP.mkAnd (CP.mkNot_s lhs_simplified) invariants pos) iv in*\) *)
(*         let new_p = simplify_contra (CP.mkNot_s lhs_simplified) iv in *)
(*         if CP.isConstFalse new_p || CP.isConstTrue new_p then None *)
(*         else *)
(* (\*          let args = CP.fv new_p in *\) *)
(*           (\* let new_iv = (CP.diff_svl iv args) in *\) *)
(*           let new_estate = *)
(*             {estate with *)
(*                 es_formula = CF.mkFalse (CF.mkNormalFlow ()) pos *)
(*                 (\* ;es_infer_pure = estate.es_infer_pure@[new_p] *\) *)
(*                     (\* ;es_infer_vars = new_iv *\) *)
(*             } *)
(*           in *)
(*           Some (new_estate,new_p) *)
(*
  Cformula.entail_state ->
  MCP.mix_formula (LHS) ->
  MCP.mix_formula (RHS) ->
  Globals.loc -> (Cformula.entail_state * CP.formula) option
*)

let infer_pure_m estate lhs_xpure rhs_xpure pos =
  (* let _ = print_endline "WN : inside infer_pure_m" in *)
  let pr1 = !print_mix_formula in 
  let pr2 = !print_entail_state_short in 
  let pr_p = !CP.print_formula in
  let pr0 es = pr_pair pr2 !CP.print_svl (es,es.es_infer_vars) in
      Debug.to_3 "infer_pure_m" 
          (add_str "estate " pr0) 
          (add_str "lhs xpure " pr1) 
          (add_str "rhs xpure " pr1)
          (add_str "(new es,inf pure) " (pr_pair (pr_option (pr_pair pr2 !print_pure_f)) (pr_option pr_p)))
      (fun _ _ _ -> infer_pure_m estate lhs_xpure rhs_xpure pos) estate lhs_xpure rhs_xpure   

let remove_contra_disjs f1s f2 =
  let helper c1 c2 = 
    let conjs1 = CP.list_of_conjs c1 in
    let conjs2 = CP.list_of_conjs c2 in
    (Gen.BList.intersect_eq CP.equalFormula conjs1 conjs2) != []
  in 
  let new_f1s = List.filter (fun f -> helper f f2) f1s in
  match new_f1s with
    | [] -> f1s
    | [hd] -> [hd]
    | ls -> f1s
  

let lhs_simplifier lhs_h lhs_p =
  let disjs = CP.list_of_disjs lhs_h in
  let disjs = remove_contra_disjs disjs lhs_p in
  trans_dnf (CP.mkAnd (disj_of_list disjs no_pos) lhs_p no_pos)

(* TODO : proc below seems very inefficient *)
(*let rec simplify_fml pf =                                         *)
(*  let helper fml =                                                *)
(*    let fml = CP.drop_rel_formula fml in                          *)
(*    if TP.is_sat_raw fml then remove_dup_constraints fml          *)
(*    else CP.mkFalse no_pos                                        *)
(*  in                                                              *)
(*  match pf with                                                   *)
(*  | BForm _ -> if CP.isConstFalse pf then pf else helper pf       *)
(*  | And _ -> helper pf                                            *)
(*  | Or (f1,f2,l,p) -> mkOr (simplify_fml f1) (simplify_fml f2) l p*)
(*  | Forall (s,f,l,p) -> Forall (s,simplify_fml f,l,p)             *)
(*  | Exists (s,f,l,p) -> Exists (s,simplify_fml f,l,p)             *)
(*  | _ -> pf                                                       *)

(* a good simplifier is needed here *)
(*let lhs_simplifier lhs_h lhs_p =                                   *)
(*    let lhs = simplify_fml (trans_dnf(mkAnd lhs_h lhs_p no_pos)) in*)
(*    lhs                                                            *)

let lhs_simplifier_tp lhs_h lhs_p =
    (TP.simplify_raw (mkAnd lhs_h lhs_p no_pos))

let lhs_simplifier_tp lhs_h lhs_p =
  let pr = !CP.print_formula in
    Debug.no_2 "lhs_simplifier_tp" pr pr pr lhs_simplifier_tp lhs_h lhs_p

(* to filter relevant LHS term for selected relation rel *)
(* requires simplify and should preserve relation and != *)
let rel_filter_assumption is_sat lhs rel =
  (* let (lhs,rel) = CP.assumption_filter_aggressive_incomplete  lhs rel in *)
  let (lhs,rel) = CP.assumption_filter_aggressive is_sat lhs rel in
  (lhs,rel)

(* let rel_filter_assumption lhs rel = *)
(*   let pr = CP.print_formula in *)
(*   Debug.no_2 "rel_filter_assumption" pr pr (fun (r,_) -> pr r) rel_filter_assumption lhs rel  *)

let infer_collect_rel is_sat estate xpure_lhs_h1 (* lhs_h *) lhs_p (* lhs_b *) rhs_p rhs_p_br pos =
  (* TODO : need to handle pure_branches in future ? *)
  if no_infer_rel estate then (estate,lhs_p,rhs_p,rhs_p_br) 
  else 
    let ivs = estate.es_infer_vars_rel in
    let rhs_p_n = MCP.pure_of_mix rhs_p in
    let rhs_ls = CP.split_conjunctions rhs_p_n in
    let (rel_rhs,other_rhs) = List.partition (CP.is_rel_in_vars ivs) rhs_ls in 
    if rel_rhs==[] then (estate,lhs_p,rhs_p,rhs_p_br) 
    else 
      let lhs_p = MCP.pure_of_mix lhs_p in
      let (lhs_p_memo,subs,bvars) = CP.memoise_rel_formula ivs lhs_p in
      let pr = !CP.print_formula_br in
      (* let _ = print_endline (pr rhs_p_br) in *)
      let rhs_p_2 = CP.join_conjunctions other_rhs in
      let rhs_p_new = MCP.mix_of_pure rhs_p_2 in
      let lhs_h = MCP.pure_of_mix xpure_lhs_h1 in
      (* let lhs = lhs_simplifier lhs_h lhs_p_memo in *)
      let lhs = lhs_simplifier_tp lhs_h lhs_p_memo in
      let lhs_2 = CP.restore_memo_formula subs bvars lhs in
      let filter_ass lhs rhs = 
        let (lhs,rhs) = rel_filter_assumption is_sat lhs rhs in
        (simplify_disj_new lhs,rhs) in      
      let wrap_exists (lhs,rhs) =
        (* Begin: To keep vars of rel_form in lhs *)
        let lhs_ls = CP.split_conjunctions lhs in
        let rel_lhs = List.filter CP.is_RelForm lhs_ls in
        let rel_vars = List.concat (List.map CP.fv rel_lhs) in
        (* End  : To keep vars of rel_form in lhs *)
        
        let vs_r = CP.fv rhs in
        let vs_l = CP.fv lhs in
        let diff_vs = diff_svl vs_l (vs_r@rel_vars) in
        let new_lhs = CP.wrap_exists_svl lhs diff_vs in
        let new_lhs = Redlog.elim_exists_with_eq new_lhs in
        let new_lhs = CP.arith_simplify_new new_lhs in
        (new_lhs,rhs) in
      let inf_rel_ls = List.map (filter_ass lhs_2) rel_rhs in
      let inf_rel_ls = List.map wrap_exists inf_rel_ls in
      let estate = { estate with es_infer_rel = inf_rel_ls@(estate.es_infer_rel) } in
    (*let fp = if inf_rel_ls = [] then (CP.mkTrue no_pos) else Fixcalc.compute_fixpoint inf_rel_ls in
    print_endline ("FIXPOINT: " ^ Cprinter.string_of_pure_formula fp);*)
      if inf_rel_ls != [] then
        begin
          DD.devel_pprint ">>>>>> infer_collect_rel <<<<<<" pos;
          DD.devel_hprint (add_str "Infer Rel Ids:" !print_svl) ivs pos;
          (* DD.devel_hprint (add_str "LHS heap Xpure1:" !print_mix_formula) xpure_lhs_h1 pos; *)
          DD.devel_hprint (add_str "LHS pure:" !CP.print_formula) lhs_p pos;
          DD.devel_hprint (add_str "RHS pure:" !CP.print_formula) rhs_p_n pos;
          DD.devel_hprint (add_str "RHS Rel List:" (pr_list !CP.print_formula)) rel_rhs pos;
          DD.devel_hprint (add_str "Rel Inferred:" (pr_list print_lhs_rhs)) inf_rel_ls pos
        end;
      (estate,(MCP.mix_of_pure lhs_p_memo),rhs_p_new,rhs_p_br)
(*
Given:
infer vars:[n,R]
LHS heap Xpure1: x=null & n=0 | x!=null & 1<=n
LHS pure: x=null & rs=0
RHS pure R(rs,n) & x=null
(1) simplify LHS to:
     x=null & n=0 & rs=0
(2) partition RHS to 
    (a) R(rs,n)
    (b) x=null
(3) for inferred relation R, use filter
    assumption to obtain:
     (n=0 rs=0 --> R(rs,n)) to add to es_infer_rel 
*)


let infer_collect_rel is_sat estate xpure_lhs_h1 (* lhs_h *) lhs_p (* lhs_b *) rhs_p rhs_p_br pos =
  let pr0 = !print_svl in
  let pr1 = !print_mix_formula in
  let pr2 (es,l,r,_) = pr_triple pr1 pr1 (pr_list CP.print_lhs_rhs) (l,r,es.es_infer_rel) in
      Debug.no_3 "infer_pure_m" pr2 pr1 pr1 (pr_option pr2) 
      (fun _ _ _ -> infer_collect_rel is_sat estate xpure_lhs_h1 (* lhs_h *) lhs_p (* lhs_b *) rhs_p rhs_p_br pos) estate.es_infer_vars_rel lhs_p rhs_p

let infer_empty_rhs estate lhs_p rhs_p pos =
  estate

(* let infer_empty_rhs_old estate lhs_p rhs_p pos = *)
(*   if no_infer estate then estate *)
(*   else *)
(*     let _ = DD.devel_pprint ("\n inferring_empty_rhs:"^(!print_formula estate.es_formula)^ "\n\n")  pos in *)
(*     let rec filter_var f vars = match f with *)
(*       | CP.Or (f1,f2,l,p) -> CP.Or (filter_var f1 vars, filter_var f2 vars, l, p) *)
(*       | _ -> CP.filter_var f vars *)
(*     in *)
(*     let infer_pure = MCP.pure_of_mix rhs_p in *)
(*     let infer_pure = if CP.isConstTrue infer_pure then infer_pure *)
(*     else CP.mkAnd (MCP.pure_of_mix rhs_p) (MCP.pure_of_mix lhs_p) pos *)
(*     in *)
(*     (\*        print_endline ("PURE: " ^ Cprinter.string_of_pure_formula infer_pure);*\) *)
(*     let infer_pure = Omega.simplify (filter_var infer_pure estate.es_infer_vars) in *)
(*     let pure_part2 = Omega.simplify (List.fold_left (fun p1 p2 -> CP.mkAnd p1 p2 pos) (CP.mkTrue pos) *)
(*         (estate.es_infer_pures @ [MCP.pure_of_mix rhs_p])) in *)
(*     (\*        print_endline ("PURE2: " ^ Cprinter.string_of_pure_formula infer_pure);*\) *)
(*     let infer_pure = if Omega.is_sat pure_part2 "0" = false then [CP.mkFalse pos] else [infer_pure] in *)
(*       {estate with es_infer_heap = []; es_infer_pure = infer_pure; *)
(*           es_infer_pures = estate.es_infer_pures @ [(MCP.pure_of_mix rhs_p)]} *)

let infer_empty_rhs2 estate lhs_xpure rhs_p pos =
  estate

(* let infer_empty_rhs2_old estate lhs_xpure rhs_p pos = *)
(*   if no_infer estate then estate *)
(*   else *)
(*     let _ = DD.devel_pprint ("\n inferring_empty_rhs2:"^(!print_formula estate.es_formula)^ "\n\n")  pos in *)
(*     (\* let lhs_xpure,_,_,_ = xpure prog estate.es_formula in *\) *)
(*     let pure_part_aux = Omega.is_sat (CP.mkAnd (MCP.pure_of_mix lhs_xpure) (MCP.pure_of_mix rhs_p) pos) "0" in *)
(*     let rec filter_var_aux f vars = match f with *)
(*       | CP.Or (f1,f2,l,p) -> CP.Or (filter_var_aux f1 vars, filter_var_aux f2 vars, l, p) *)
(*       | _ -> CP.filter_var f vars *)
(*     in *)
(*     let filter_var f vars =  *)
(*       if CP.isConstTrue (Omega.simplify f) then CP.mkTrue pos  *)
(*       else *)
(*         let res = filter_var_aux f vars in *)
(*         if CP.isConstTrue (Omega.simplify res) then CP.mkFalse pos *)
(*         else res *)
(*     in *)
(*     let invs = List.fold_left (fun p1 p2 -> CP.mkAnd p1 p2 pos) (CP.mkTrue pos) estate.es_infer_invs in *)
(*     let pure_part =  *)
(*       if pure_part_aux = false then *)
(*         let mkNot purefml =  *)
(*           let conjs = CP.split_conjunctions purefml in *)
(*           let conjs = List.map (fun c -> CP.mkNot_s c) conjs in *)
(*           List.fold_left (fun p1 p2 -> CP.mkAnd p1 p2 pos) (CP.mkTrue pos) conjs *)
(*         in *)
(*         let lhs_pure = CP.mkAnd (mkNot(Omega.simplify  *)
(*             (filter_var (MCP.pure_of_mix lhs_xpure) estate.es_infer_vars))) invs pos in *)
(*         (\*print_endline ("PURE2: " ^ Cprinter.string_of_pure_formula lhs_pure);*\) *)
(*         CP.mkAnd lhs_pure (MCP.pure_of_mix rhs_p) pos *)
(*       else Omega.simplify (CP.mkAnd (CP.mkAnd (MCP.pure_of_mix lhs_xpure) (MCP.pure_of_mix rhs_p) pos) invs pos) *)
(*     in *)
(*     let pure_part = filter_var (Omega.simplify pure_part) estate.es_infer_vars in *)
(*     (\*        print_endline ("PURE: " ^ Cprinter.string_of_mix_formula rhs_p);*\) *)
(*     let pure_part = Omega.simplify pure_part in *)
(*     let pure_part2 = Omega.simplify (CP.mkAnd pure_part  *)
(*         (List.fold_left (fun p1 p2 -> CP.mkAnd p1 p2 pos) (CP.mkTrue pos)  *)
(*             (estate.es_infer_pures @ [MCP.pure_of_mix rhs_p])) pos) in *)
(*     (\*        print_endline ("PURE1: " ^ Cprinter.string_of_pure_formula pure_part);*\) *)
(*     (\*        print_endline ("PURE2: " ^ Cprinter.string_of_pure_formula pure_part2);*\) *)
(*     let pure_part = if (CP.isConstTrue pure_part & pure_part_aux = false)  *)
(*       || Omega.is_sat pure_part2 "0" = false then [CP.mkFalse pos] else [pure_part] in *)
(*     {estate with es_infer_heap = []; es_infer_pure = pure_part; *)
(*         es_infer_pures = estate.es_infer_pures @ [(MCP.pure_of_mix rhs_p)]} *)

(* Calculate the invariant relating to unfolding *)
(*let infer_for_unfold prog estate lhs_node pos =
  if no_infer estate then estate
  else
(*    let _ = DD.devel_pprint ("\n inferring_for_unfold:"^(!print_formula estate.CF.es_formula)^ "\n\n")  pos in*)
    let inv = match lhs_node with
      | ViewNode ({h_formula_view_name = c}) ->
        let vdef = Cast.look_up_view_def pos prog.Cast.prog_view_decls c in
        let i = MCP.pure_of_mix (fst vdef.Cast.view_user_inv) in
        if List.mem i estate.es_infer_invs then estate.es_infer_invs
        else estate.es_infer_invs @ [i]
      | _ -> estate.es_infer_invs
    in {estate with es_infer_invs = inv} *)


(* Calculate the invariant relating to unfolding *)
(*let infer_for_unfold prog estate lhs_node pos =
  let pr es =  pr_list !CP.print_formula es.es_infer_invs in
  let pr2 = !print_h_formula in
  Debug.no_2 "infer_for_unfold" 
      (add_str "es_infer_inv (orig) " pr) 
      (add_str "lhs_node " pr2) 
      (add_str "es_infer_inv (new) " pr)
      (fun _ _ -> infer_for_unfold prog estate lhs_node pos) estate lhs_node*)


(* let infer_for_unfold_old prog estate lhs_node pos = *)
(*   if no_infer estate then estate *)
(*   else *)
(*     let _ = DD.devel_pprint ("\n inferring_for_unfold:"^(!print_formula estate.es_formula)^ "\n\n")  pos in *)
(*     let inv = matchcntha lhs_node with *)
(*       | ViewNode ({h_formula_view_name = c}) -> *)
(*             let vdef = Cast.look_up_view_def pos prog.Cast.prog_view_decls c in *)
(*             let i = MCP.pure_of_mix (fst vdef.Cast.view_user_inv) in *)
(*             if List.mem i estate.es_infer_invs then estate.es_infer_invs *)
(*             else estate.es_infer_invs @ [i] *)
(*       | _ -> estate.es_infer_invs *)
(*     in {estate with es_infer_invs = inv}  *)
