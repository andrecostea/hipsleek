(*
2011: Immutability module:
  - utils for immutability
*)

open Globals
open Cast
open Prooftracer
open Gen.Basic
open Cformula

module CP = Cpure
module PR = Cprinter
module MCP = Mcpure
module Err = Error
module TP = Tpdispatcher
module IF = Iformula
module IP = Iprinter

let rec split_phase_debug_lhs h = Debug.no_1 "split_phase(lhs)"
  Cprinter.string_of_h_formula 
  (fun (a,b,c) -> "RD = " ^ (Cprinter.string_of_h_formula a) ^ "; WR = " ^ (Cprinter.string_of_h_formula b) ^ "; NEXT = " ^ (Cprinter.string_of_h_formula c) ^ "\n") 
  split_phase h

and split_phase_debug_rhs h = Debug.no_1 "split_phase(rhs)"
  Cprinter.string_of_h_formula 
  (fun (a,b,c) -> "RD = " ^ (Cprinter.string_of_h_formula a) ^ "; WR = " ^ (Cprinter.string_of_h_formula b) ^ "; NEXT = " ^ (Cprinter.string_of_h_formula c) ^ "\n") 
  split_phase h

and split_phase (h : h_formula) : (h_formula * h_formula * h_formula )= 
  let pr = Cprinter.string_of_h_formula in
  let pr2 = pr_triple pr pr pr in
  Debug.no_1 "split_phase" pr pr2 split_phase_x h

and split_phase_x (h : h_formula) : (h_formula * h_formula * h_formula ) = 
  let h = remove_true_rd_phase h in
  match h with
    | Phase ({h_formula_phase_rd = h1;
	  h_formula_phase_rw = h2;
	  h_formula_phase_pos = pos}) -> 
	      let h3, h4 = split_wr_phase h2 in
	      (h1, h3, h4)
    | Star _ ->
	      let h3, h4 = split_wr_phase h in
	      (HTrue, h3, h4)
    | _ ->
	      if (consume_heap_h_formula h) then
	        (HTrue, h, HTrue)
	      else
	        (h, HTrue, HTrue)

and split_wr_phase (h : h_formula) : (h_formula * h_formula) = 
  match h with 
    | Star ({h_formula_star_h1 = h1;
	  h_formula_star_h2 = h2;
	  h_formula_star_pos = pos}) -> 
      (* let _ = print_string("[cris]: split star " ^ (Cprinter.string_of_h_formula h) ^ "\n") in *)
	      (match h2 with
	        | Phase _ -> (h1, h2)
	        | Star ({h_formula_star_h1 = sh1;
		      h_formula_star_h2 = sh2;
		      h_formula_star_pos = spos}) ->
		          split_wr_phase (CF.mkStarH (CF.mkStarH h1 sh1 pos) sh2 pos)
	        | _ -> 
		  (* if ((is_lend_h_formula h1) && is_lend_h_formula h2) then *)
		  (*   (, h2) *)
		  (* else  *)
		    (h, HTrue)
	      )
    | Conj _ -> report_error no_pos ("[solver.ml] : Conjunction should not appear at this level \n")
    | Phase({h_formula_phase_rd = h1;
	  h_formula_phase_rw = h2;
	  h_formula_phase_pos = pos}) ->
	      (HTrue, h)
    | _ -> (h, HTrue)

and remove_true_rd_phase (h : CF.h_formula) : CF.h_formula = 
  match h with
    | CF.Phase ({CF.h_formula_phase_rd = h1;
	  CF.h_formula_phase_rw = h2;
	  CF.h_formula_phase_pos = pos
	 }) -> 
      if (h1 == CF.HTrue) then h2
      else if (h2 == CF.HTrue) then h1
      else h
    | CF.Star ({CF.h_formula_star_h1 = h1;
	  CF.h_formula_star_h2 = h2;
	  CF.h_formula_star_pos = pos
	 }) -> 
      let h1r = remove_true_rd_phase h1 in
      let h2r = remove_true_rd_phase h2 in
      CF.mkStarH h1r h2r pos
    | _ -> h


and consume_heap (f : formula) : bool =  match f with
  | Base(bf) -> consume_heap_h_formula bf.formula_base_heap
  | Exists(ef) -> consume_heap_h_formula ef.formula_exists_heap
  | Or({formula_or_f1 = f1;
    formula_or_f2 = f2;
    formula_or_pos = pos}) ->
        (consume_heap f1) or (consume_heap f2)
            
and consume_heap_h_formula (f : h_formula) : bool =  match f with
  | DataNode (h1) -> ((isMutable h1.h_formula_data_imm) || (isImm h1.h_formula_data_imm))
  | ViewNode (h1) -> ((isMutable h1.h_formula_view_imm) || (isImm h1.h_formula_view_imm))
  | Conj({h_formula_conj_h1 = h1;
	h_formula_conj_h2 = h2;
	h_formula_conj_pos = pos})
  | Phase({h_formula_phase_rd = h1;
	h_formula_phase_rw = h2;
	h_formula_phase_pos = pos})
  | Star({h_formula_star_h1 = h1;
	h_formula_star_h2 = h2;
	h_formula_star_pos = pos}) -> (consume_heap_h_formula h1) or (consume_heap_h_formula h2)
  | _ -> false

       
and is_lend_debug f = 
  Debug.no_1 "is_lend"
      (!print_formula)
      (string_of_bool)
      is_lend f

and is_lend (f : formula) : bool =  match f with
  | Base(bf) -> is_lend_h_formula bf.formula_base_heap
  | Exists(ef) -> is_lend_h_formula ef.formula_exists_heap
  | Or({formula_or_f1 = f1;
    formula_or_f2 = f2;
    formula_or_pos = pos}) ->
        (is_lend f1) or (is_lend f2)
            
and is_lend_h_formula_debug f = 
  Debug.no_1 "is_lend_h_formula"
      (!print_h_formula)
      (string_of_bool)
      is_lend_h_formula f


and is_lend_h_formula (f : h_formula) : bool =  match f with
  | DataNode (h1) -> 
        if (isLend h1.h_formula_data_imm) then
          (* let _ = print_string("true for h = " ^ (!print_h_formula f) ^ "\n\n")  in *) true
        else
          false
  | ViewNode (h1) ->
        if (isLend h1.h_formula_view_imm) then
          (* let _ = print_string("true for h = " ^ (!print_h_formula f) ^ "\n\n") in *) true
        else
          false

  | Conj({h_formula_conj_h1 = h1;
	h_formula_conj_h2 = h2;
	h_formula_conj_pos = pos})
  | Phase({h_formula_phase_rd = h1;
	h_formula_phase_rw = h2;
	h_formula_phase_pos = pos}) -> true
  | Star({h_formula_star_h1 = h1;
	h_formula_star_h2 = h2;
	h_formula_star_pos = pos}) -> (is_lend_h_formula h1) or (is_lend_h_formula h2)
  | Hole _ -> false
  | _ -> false


and contains_phase_debug (f : h_formula) : bool =  
  Debug.no_1 "contains_phase"
      (!print_h_formula) 
      (string_of_bool)
      (contains_phase)
      f

(* normalization for iformula *)
(* normalization of the heap formula *)
(* emp & emp * K == K *)
(* KR: check there is only @L *)
(* KR & KR ==> KR ; (KR ; true) *)

let rec iformula_ann_to_cformula_ann (iann : IF.ann) : CF.ann = 
  match iann with
    | IF.ConstAnn(x) -> CF.ConstAnn(x)
    | IF.PolyAnn((id,p), l) -> 
      CF.PolyAnn(CP.SpecVar (AnnT, id, p))

and normalize_h_formula (h : IF.h_formula) (wr_phase : bool) : IF.h_formula =
  Debug.no_1 "normalize_h_formula"
    (IP.string_of_h_formula)
    (IP.string_of_h_formula)
    (fun _ -> normalize_h_formula_x h wr_phase) h

and normalize_h_formula_x (h : IF.h_formula) (wr_phase : bool) : IF.h_formula =
  let get_imm (h : IF.h_formula) : ann = 
    let iann =
      match h with
      | IF.HeapNode2 hf -> hf.IF.h_formula_heap2_imm
      | IF.HeapNode hf -> hf.IF.h_formula_heap_imm
      |  -> failwith ("Error in  normalize_h_formula\n")
    in
    (iformula_ann_to_cformula_ann iann)
  in
  let rec extract_inner_phase f = match f with
    | IF.Phase _ -> (IF.HTrue, f)
    | IF.Star ({IF.h_formula_star_h1 = h1;
                IF.h_formula_star_h2 = h2;
                IF.h_formula_star_pos = pos
               }) -> 
        let r11, r12 = extract_inner_phase h1 in 
        let r21, r22 = extract_inner_phase h2 in 
        (IF.mkStar r11 r21 pos, IF.mkStar r12 r22 pos) 
    | _ -> (f,IF.HTrue) 
  in
  match h with
  | IF.Phase({IF.h_formula_phase_rd = h1;
              IF.h_formula_phase_rw = h2;
              IF.h_formula_phase_pos = pos
             }) ->
      (* conj in read phase -> split into two separate read phases *)
      if not(validate_rd_phase h1) then
        Error.report_error
          {Error.error_loc = pos;
           Error.error_text =  ("Invalid read phase h = " ^ (Iprinter.string_of_h_formula h) ^ "\n")}
      else
        let rd_phase = normalize_h_formula_rd_phase h1 in
        let wr_phase = normalize_h_formula_x h2 true in 
        let res = insert_wr_phase rd_phase wr_phase in
        res
  | IF.Star({IF.h_formula_star_h1 = h1;
             IF.h_formula_star_h2 = h2;
             IF.h_formula_star_pos = pos
            }) ->
      let r1, r2 = extract_inner_phase h2 in
      if (r1 == IF.HTrue) || (r2 == IF.HTrue) then 
        IF.Star({IF.h_formula_star_h1 = h1;
                 IF.h_formula_star_h2 = normalize_h_formula_x h2 false;
                 IF.h_formula_star_pos = pos
                }) 
      else
        (* isolate the inner phase *)
        IF.Star({IF.h_formula_star_h1 = IF.mkStar h1 r1 pos;
                 IF.h_formula_star_h2 = normalize_h_formula_x r2 false;
                 IF.h_formula_star_pos = pos
                }) 
  | IF.Conj({IF.h_formula_conj_h1 = h1;
             IF.h_formula_conj_h2 = h2;
             IF.h_formula_conj_pos = pos
            }) ->
      normalize_h_formula_rd_phase h 
  | IF.HeapNode2 hf -> 
      (let annv = get_imm h in
      match annv with
      | ConstAnn(Lend) -> h
      | _ ->
         begin
         (* write phase *)
           if (wr_phase) then h
           else
            IF.Phase({IF.h_formula_phase_rd = IF.HTrue;
                      IF.h_formula_phase_rw = h;
                      IF.h_formula_phase_pos = no_pos;
                     })
         end)
  | IF.HeapNode hf ->
      (let annv = get_imm h in
      match annv with
      | ConstAnn(Lend) -> h
      | _ ->
        begin
          (* write phase *)
          if (wr_phase) then h
          else
            IF.Phase({IF.h_formula_phase_rd = IF.HTrue;
                      IF.h_formula_phase_rw = h;
                      IF.h_formula_phase_pos = no_pos;
                     })
        end)
  | _ ->  IF.Phase { IF.h_formula_phase_rd = IF.HTrue;
                     IF.h_formula_phase_rw = h;
                     IF.h_formula_phase_pos = no_pos }

and contains_phase (h : IF.h_formula) : bool = match h with
  | IF.Phase _ -> true
  | IF.Conj ({IF.h_formula_conj_h1 = h1;
	   IF.h_formula_conj_h2 = h2;
	   IF.h_formula_conj_pos = pos;
    }) 
  | IF.Star ({IF.h_formula_star_h1 = h1;
	 IF.h_formula_star_h2 = h2;
	 IF.h_formula_star_pos = pos}) ->
      (contains_phase h1) or (contains_phase h2)
  | _ -> false

(* conj in read phase -> split into two separate read phases *)
and normalize_h_formula_rd_phase (h : IF.h_formula) : IF.h_formula = match h with
  | IF.Conj({IF.h_formula_conj_h1 = h1;
	 IF.h_formula_conj_h2 = h2;
	 IF.h_formula_conj_pos = pos}) ->
      (* conj in read phase -> split into two separate read phases *)
      let conj1 = normalize_h_formula_rd_phase h1 in
	insert_rd_phase conj1 h2 
  | IF.Phase _ -> failwith "Shouldn't have phases inside the reading phase\n"
  | _ -> IF.Phase({IF.h_formula_phase_rd = h;
		IF.h_formula_phase_rw = IF.HTrue;
		IF.h_formula_phase_pos = no_pos;
	       })

(* the read phase contains only pred with the annotation @L *)
and validate_rd_phase (h : IF.h_formula) : bool = match h with
  | IF.Star({IF.h_formula_star_h1 = h1;
	 IF.h_formula_star_h2 = h2;
	 IF.h_formula_star_pos = pos}) 
  | IF.Conj({IF.h_formula_conj_h1 = h1;
	 IF.h_formula_conj_h2 = h2;
	 IF.h_formula_conj_pos = pos}) -> (validate_rd_phase h1) && (validate_rd_phase h2)
  | IF.Phase _ -> false (* Shouldn't have phases inside the reading phase *)
  | IF.HeapNode2 hf -> (IF.isLend hf.IF.h_formula_heap2_imm) 
  | IF.HeapNode hf -> (IF.isLend hf.IF.h_formula_heap_imm)
  | _ -> true

and insert_wr_phase (f : IF.h_formula) (wr_phase : IF.h_formula) : IF.h_formula = 
  match f with
    | IF.Phase ({IF.h_formula_phase_rd = h1;
	     IF.h_formula_phase_rw = h2;
	     IF.h_formula_phase_pos = pos}) ->
	let new_h2 = 
	  match h2 with
	    | IF.HTrue -> wr_phase (* insert the new phase *)
	    | IF.Star({IF.h_formula_star_h1 = h1_star;
		    IF.h_formula_star_h2 = h2_star;
		    IF.h_formula_star_pos = pos_star
		   }) ->
		(* when insert_wr_phase is called, f represents a reading phase ->
		   all the writing phases whould be emp *)
		if (contains_phase h2_star) then
		  (* insert in the nested phase *)
		  IF.Star({
			IF.h_formula_star_h1 = h1_star;
			IF.h_formula_star_h2 = insert_wr_phase h2_star wr_phase;
			IF.h_formula_star_pos = pos_star
		       })
		else failwith ("[iformula.ml] : should contain phase\n")
		  
	    | _ -> IF.Star({
			IF.h_formula_star_h1 = h2;
			IF.h_formula_star_h2 = wr_phase;
			IF.h_formula_star_pos = pos
		       })
	in
	  (* reconstruct the phase *)
	  IF.Phase({IF.h_formula_phase_rd = h1;
		 IF.h_formula_phase_rw = new_h2;
		IF.h_formula_phase_pos = pos})
    | _ -> failwith ("[iformula.ml] : There should be a phase at this point\n")


and insert_rd_phase (f : IF.h_formula) (rd_phase : IF.h_formula) : IF.h_formula = 
  match f with
    | IF.Phase ({IF.h_formula_phase_rd = h1;
	     IF.h_formula_phase_rw = h2;
	     IF.h_formula_phase_pos = pos}) ->
	let new_h2 = 
	(match h2 with
	   | IF.HTrue -> 
	       (* construct the new phase *)
		let new_phase = IF.Phase({IF.h_formula_phase_rd = rd_phase; 
				  IF.h_formula_phase_rw = IF.HTrue;
				  IF.h_formula_phase_pos = pos})
		in
		  (* input the new phase *)
		IF.Star({IF.h_formula_star_h1 = IF.HTrue;
		      IF.h_formula_star_h2 = new_phase;
		      IF.h_formula_star_pos = pos})
	   | IF.Conj _ -> failwith ("[cformula.ml] : Should not have conj at this point\n") (* the write phase does not contain conj *)	     
	   | IF.Star ({IF.h_formula_star_h1 = h1_star;
		    IF.h_formula_star_h2 = h2_star;
		    IF.h_formula_star_pos = pos_star
		   }) ->
	       let new_phase = insert_rd_phase h2_star rd_phase in
	       IF.Star({IF.h_formula_star_h1 = h1_star;
		     IF.h_formula_star_h2 = new_phase;
		     IF.h_formula_star_pos = pos_star})
	   | _ ->
		let new_phase = IF.Phase({IF.h_formula_phase_rd = rd_phase; 
				  IF.h_formula_phase_rw = IF.HTrue;
				  IF.h_formula_phase_pos = pos})
		in
		IF.Star({IF.h_formula_star_h1 = h2;
		      IF.h_formula_star_h2 = new_phase;
		      IF.h_formula_star_pos = pos})
	)
	in
	  IF.Phase({
		  IF.h_formula_phase_rd = h1;
		  IF.h_formula_phase_rw = new_h2;
		  IF.h_formula_phase_pos = pos;
		})
    | IF.Conj _ -> failwith ("[cformula.ml] : Should not have conj at this point\n")	     
    | _ -> 
		let new_phase = IF.Phase({IF.h_formula_phase_rd = rd_phase; 
				  IF.h_formula_phase_rw = IF.HTrue;
				  IF.h_formula_phase_pos = no_pos})
		in
		let new_star = IF.Star({IF.h_formula_star_h1 = IF.HTrue;
		      IF.h_formula_star_h2 = new_phase;
		      IF.h_formula_star_pos = no_pos})
		in 
		IF.Phase({
		  IF.h_formula_phase_rd = f;
		  IF.h_formula_phase_rw = new_star;
		  IF.h_formula_phase_pos = no_pos;
		})


and propagate_imm_struc_formula e (imm : ann)  =
  let f_e_f e = None  in
  let f_f e = None in
  let f_h_f f = Some (propagate_imm_h_formula f imm) in
  let f_p_t1 e = Some e in
  let f_p_t2 e = Some e in
  let f_p_t3 e = Some e in
  let f_p_t4 e = Some e in
  let f_p_t5 e = Some e in
  let f=(f_e_f,f_f,f_h_f,(f_p_t1,f_p_t2,f_p_t3,f_p_t4,f_p_t5)) in
    transform_struc_formula f e


and propagate_imm_formula (f : formula) (imm : ann) : formula = match f with
  | Or ({formula_or_f1 = f1; formula_or_f2 = f2; formula_or_pos = pos}) ->
	    let rf1 = propagate_imm_formula f1 imm in
	    let rf2 = propagate_imm_formula f2 imm in
	    let resform = mkOr rf1 rf2 pos in
		resform
  | Base f1 ->
        let f1_heap = propagate_imm_h_formula f1.formula_base_heap imm in
        Base({f1 with formula_base_heap = f1_heap})
  | Exists f1 ->
        let f1_heap = propagate_imm_h_formula f1.formula_exists_heap imm in
        Exists({f1 with formula_exists_heap = f1_heap})

and propagate_imm_h_formula (f : h_formula) (imm : ann) : h_formula = 
  match f with
    | ViewNode f1 -> ViewNode({f1 with h_formula_view_imm = imm})
    | DataNode f1 -> DataNode({f1 with h_formula_data_imm = imm})
    | Star f1 ->
	      let h1 = propagate_imm_h_formula f1.h_formula_star_h1 imm in
	      let h2 = propagate_imm_h_formula f1.h_formula_star_h2 imm in
	      mkStarH h1 h2 f1.h_formula_star_pos
    | Conj f1 ->
	      let h1 = propagate_imm_h_formula f1.h_formula_conj_h1 imm in
	      let h2 = propagate_imm_h_formula f1.h_formula_conj_h2 imm in
	      mkConjH h1 h2 f1.h_formula_conj_pos
    | Phase f1 ->
	      let h1 = propagate_imm_h_formula f1.h_formula_phase_rd imm in
	      let h2 = propagate_imm_h_formula f1.h_formula_phase_rw imm in
	      mkPhaseH h1 h2 f1.h_formula_phase_pos
    | _ -> f

(* return true if imm1 <: imm2 *)	
(* M <: I <: L *)

and subtype_ann (imm1 : ann) (imm2 : ann) : bool = 
    Debug.no_2 "subtype_ann" 
      (Cprinter.string_of_imm) 
      (Cprinter.string_of_imm) 
      string_of_bool 
      (fun _ _ -> subtype_ann_x imm1 imm2) imm1 imm2  

(* bool denotes possible subyping *)
and subtype_ann_x (imm1 : ann) (imm2 : ann) : bool =
  let (r,op) = subtype_ann_pair imm1 imm2 in r
  
and subtype_ann_pair (imm1 : ann) (imm2 : ann) : bool * ((CP.exp * CP.exp) option) =
   match imm1 with
    | PolyAnn v1 ->
          (match imm2 with
            | PolyAnn v2 -> (true, Some (CP.Var(v1, no_pos), CP.Var(v2, no_pos)))
            | ConstAnn k2 -> 
                  (true, Some (CP.Var(v1,no_pos), CP.AConst(k2,no_pos)))
          )
    | ConstAnn k1 ->
          (match imm2 with
            | PolyAnn v2 -> (true, Some (CP.AConst(k1,no_pos), CP.Var(v2,no_pos)))
             | ConstAnn k2 -> ((int_of_heap_ann k1)<=(int_of_heap_ann k2),None) 
          ) 

and subtype_ann_gen impl_vars (imm1 : ann) (imm2 : ann) : bool * (CP.formula option) * (CP.formula option) =
  let (f,op) = subtype_ann_pair imm1 imm2 in
  match op with
    | None -> (f,None,None)
    | Some (l,r) -> 
          let c = CP.BForm ((CP.SubAnn(l,r,no_pos),None), None) in
          let lhs = CP.BForm ((CP.Eq(l,r,no_pos),None), None) in
          begin
            match r with
              | CP.Var(v,_) -> 
                  if CP.mem v impl_vars then (f,Some lhs,None)
                  else (f,None,Some c)
              | _ -> (f,None,Some c)
          end

(* utilities for handling lhs heap state continuation *)
and push_cont_ctx (cont : h_formula) (ctx : Cformula.context) : Cformula.context =
  match ctx with
    | Ctx(es) -> Ctx(push_cont_es cont es)
    | OCtx(c1, c2) ->
	      OCtx(push_cont_ctx cont c1, push_cont_ctx cont c2)

and push_cont_es (cont : h_formula) (es : entail_state) : entail_state =  
  {  es with
      es_cont = cont::es.es_cont;
  }

and pop_cont_es (es : entail_state) : (h_formula * entail_state) =  
  let cont = es.es_cont in
  let crt_cont, cont =
    match cont with
      | h::r -> (h, r)
      | [] -> (HTrue, [])
  in
  (crt_cont, 
  {  es with
      es_cont = cont;
  })

(* utilities for handling lhs holes *)
(* push *)
and push_crt_holes_list_ctx (ctx : list_context) (holes : (h_formula * int) list) : list_context = 
  let pr1 = Cprinter.string_of_list_context in
  let pr2 = pr_no (* pr_list (pr_pair string_of_h_formula string_of_int ) *) in
  Debug.no_2 "push_crt_holes_list_ctx" pr1 pr2 pr1 (fun _ _-> push_crt_holes_list_ctx_x ctx holes) ctx holes
      
and push_crt_holes_list_ctx_x (ctx : list_context) (holes : (h_formula * int) list) : list_context = 
  match ctx with
    | FailCtx _ -> ctx
    | SuccCtx(cl) ->
	      SuccCtx(List.map (fun x -> push_crt_holes_ctx x holes) cl)

and push_crt_holes_ctx (ctx : context) (holes : (h_formula * int) list) : context = 
  match ctx with
    | Ctx(es) -> Ctx(push_crt_holes_es es holes)
    | OCtx(c1, c2) ->
	      let nc1 = push_crt_holes_ctx c1 holes in
	      let nc2 = push_crt_holes_ctx c2 holes in
	      OCtx(nc1, nc2)

and push_crt_holes_es (es : Cformula.entail_state) (holes : (h_formula * int) list) : Cformula.entail_state =
  {
      es with
          es_crt_holes = holes @ es.es_crt_holes; 
  }
      
and push_holes (es : Cformula.entail_state) : Cformula.entail_state = 
  {  es with
      es_hole_stk   = es.es_crt_holes::es.es_hole_stk;
      es_crt_holes = [];
  }

(* pop *)

and pop_holes_es (es : Cformula.entail_state) : Cformula.entail_state = 
  match es.es_hole_stk with
    | [] -> es
    | c2::stk -> {  es with
		  es_hole_stk = stk;
	      es_crt_holes = es.es_crt_holes @ c2;
	  }

(* substitute *)
and subs_crt_holes_list_ctx (ctx : list_context) : list_context = 
  match ctx with
    | FailCtx _ -> ctx
    | SuccCtx(cl) ->
	      SuccCtx(List.map subs_crt_holes_ctx cl)

and subs_crt_holes_ctx (ctx : context) : context = 
  match ctx with
    | Ctx(es) -> Ctx(subs_holes_es es)
    | OCtx(c1, c2) ->
	      let nc1 = subs_crt_holes_ctx c1 in
	      let nc2 = subs_crt_holes_ctx c2 in
	      OCtx(nc1, nc2)

and subs_holes_es (es : Cformula.entail_state) : Cformula.entail_state = 
  (* subs away current hole list *)
  {  es with
	  es_crt_holes   = [];
      es_formula = apply_subs es.es_crt_holes es.es_formula;
  }

and apply_subs (crt_holes : (h_formula * int) list) (f : formula) : formula =
  match f with
    | Base(bf) ->
	      Base{bf with formula_base_heap = apply_subs_h_formula crt_holes bf.formula_base_heap;}
    | Exists(ef) ->
	      Exists{ef with formula_exists_heap = apply_subs_h_formula crt_holes ef.formula_exists_heap;}
    | Or({formula_or_f1 = f1;
	  formula_or_f2 = f2;
	  formula_or_pos = pos}) ->
	      let sf1 = apply_subs crt_holes f1 in
	      let sf2 = apply_subs crt_holes f2 in
	      mkOr sf1  sf2 pos

and apply_subs_h_formula crt_holes (h : h_formula) : h_formula = 
  let rec helper (i : int) crt_holes : h_formula = 
    (match crt_holes with
	  | (h1, i1) :: rest -> 
	        if i==i1 then h1
	        else helper i rest
	  | [] -> Hole(i))
  in
  match h with
    | Hole(i) -> helper i crt_holes
    | Star({h_formula_star_h1 = h1;
	  h_formula_star_h2 = h2;
	  h_formula_star_pos = pos}) ->
	      let nh1 = apply_subs_h_formula crt_holes h1 in
	      let nh2 = apply_subs_h_formula crt_holes h2 in
	      Star({h_formula_star_h1 = nh1;
	      h_formula_star_h2 = nh2;
	      h_formula_star_pos = pos})
    | Conj({h_formula_conj_h1 = h1;
	  h_formula_conj_h2 = h2;
	  h_formula_conj_pos = pos}) ->
	      let nh1 = apply_subs_h_formula crt_holes h1 in
	      let nh2 = apply_subs_h_formula crt_holes h2 in
	      Conj({h_formula_conj_h1 = nh1;
	      h_formula_conj_h2 = nh2;
	      h_formula_conj_pos = pos})
    | Phase({h_formula_phase_rd = h1;
	  h_formula_phase_rw = h2;
	  h_formula_phase_pos = pos}) ->
	      let nh1 = apply_subs_h_formula crt_holes h1 in
	      let nh2 = apply_subs_h_formula crt_holes h2 in
	      Phase({h_formula_phase_rd = nh1;
	      h_formula_phase_rw = nh2;
	      h_formula_phase_pos = pos})
    | _ -> h

and get_imm (f : h_formula) : ann =  match f with
  | DataNode (h1) -> h1.h_formula_data_imm
  | ViewNode (h1) -> h1.h_formula_view_imm
  | _ -> ConstAnn(Mutable) (* we shouldn't get here *)




