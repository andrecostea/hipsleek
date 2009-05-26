(*
*)

open Globals
open Cpure

let infilename = "input.mona." ^ (string_of_int (Unix.getpid ()))
let resultfilename = "result.mona." ^ (string_of_int (Unix.getpid()))

let log_all_flag = ref true
let log_all = open_out ("allinput.set" (* ^ (string_of_int (Unix.getpid ())) *) )

(*************************************************************)
(*************************************************************)
(*************************************************************)

(* Determining first-order variables *)
(*
  Rename all quantified variables. Use the same var_map for the entire formula.
*)

module H = Hashtbl

type var_type =
  | FO (* First order var *)
  | SO (* Second order var *)
  | ZO (* zeroth order var *)

and var_map_t = (ident, var_type) H.t

let var_map_ref = ref (H.create 103)

let presPred = "
pred xor(var0 x,y) = x&~y | ~x&y;
pred at_least_two(var0 x,y,z) = x&y | x&z | y&z;
pred plus(var2 p,q,r) =
  ex2 c: 0 notin c
   & all1 t: (t+1 in c <=> at_least_two(t in p, t in q, t in c))
     & (t in r <=> xor(xor(t in p, t in q), t in c));
pred less(var2 p,q) = ex2 t: t ~= empty & plus(p,t,q);
pred lessEq(var2 p, q) = less(p, q) | (p=q);
pred greater(var2 p, q) = less(q, p);
pred greaterEq(var2 p, q) = greater(p, q) | (p=q);
pred equal(var2 p, q) = p = q;
pred nequal(var2 p, q) = p ~= q;
"

(*
  Determine which variables need to be first order.
  Put those into var_map.
*)
let rec compute_fo_formula (f0 : formula) var_map : unit = 
  let bforms = b_formulas_list f0 in
	compute_fo_b_formula bforms var_map

(*
  List of atomic formulas: return a list of all atomic formulas?
  How about quantified formulas? Rename all quantified variables.
*)
and b_formulas_list (f0 : formula) : b_formula list = match f0 with
  | BForm bf -> [bf]
  | And (f1, f2, _)
  | Or (f1, f2, _) ->
	  let l1 = b_formulas_list f1 in
	  let l2 = b_formulas_list f2 in
		l1 @ l2
  | Not (f1, _)
  | Forall (_, f1, _)
  | Exists (_, f1, _) ->
	  b_formulas_list f1

(*
  returns true if new FO vars are added to var_map
*)
and compute_fo_b_formula (bf0 : b_formula list) var_map : unit = 
  let current_bforms = ref bf0 in
  let next_bforms = ref [] in
  let cont = ref true in
	while !cont do
	  cont := false;
	  let cont2 = ref true in
		while !cont2 do
		  match !current_bforms with
			| bf :: rest -> begin
				current_bforms := rest; (* prepare for next iteration *)
				match bf with
					(* Bag constraints *)
				  | BagIn (sv, e, _)
				  | BagNotIn (sv, e, _) ->
					  (* sv is first-order, e must be a bag *)
					  let r1 = compute_fo_var sv FO var_map in
					  let r2 = compute_fo_exp e SO var_map in
						cont := r1 || r2 (* var_map may have changed. Note that we only care about FO case *)
				  | BagSub (e1, e2, _) ->
					  let r1 = compute_fo_exp e1 SO var_map in
					  let r2 = compute_fo_exp e2 SO var_map in
						cont := r1 || r2
				  | BagMin _
				  | BagMax _ -> failwith ("compute_fo_b_formula: BagMin/BagMax not supported.")
					(* Booleans *)
				  | BConst _ -> compute_fo_b_formula rest var_map
				  | BVar (sv, _) ->
					  ignore (compute_fo_var sv SO var_map) (* make boolean var second order for now *)
					(* Arithmetic *)
				  | Lt (e1, e2, _)
				  | Lte (e1, e2, _)
				  | Gt (e1, e2, _)
				  | Gte (e1, e2, _)
					(* Equality and disequality *)
				  | Eq (e1, e2, _)
				  | Neq (e1, e2, _) ->
					  (* not necessary to force e1, e2 to be FO here
					  if is_arith e1 || is_arith e2 then
						let r1 = compute_fo_exp e1 FO var_map in
						let r2 = compute_fo_exp e2 FO var_map in
						  if r1 || r2 then
							cont := true
						  else
							() (* this formula doesn't add anything new *)
							  (* next_bforms := bf :: !next_bforms *)
					  else 
					  *)
					  if is_bag e1 || is_bag e2 then
						let r1 = compute_fo_exp e1 SO var_map in
						let r2 = compute_fo_exp e2 SO var_map in
						  if r1 || r2 then
							cont := true
						  else
							() (* this formula doesn't add anything new, discarded *)
							  (* next_bforms := bf :: !next_bforms *)
					  else
						let svs = combine_avars e1 e2 in
						let res = to_fo svs var_map in
						  if res then
							cont := true
						  else
							next_bforms := bf :: !next_bforms
				  | EqMin (e1, e2, e3, _)
				  | EqMax (e1, e2, e3, _) ->
					  let tmp1 = afv e1 in
					  let tmp2 = afv e2 in
					  let tmp3 = afv e3 in
					  let svs = Util.remove_dups (tmp1 @ tmp2 @ tmp3) in
					  let res = to_fo svs var_map in
						if res then
						  cont := true
						else
						  next_bforms := bf :: !next_bforms
			  end (* end of bf :: rest case *)
			| [] ->
				cont2 := false;
				current_bforms := !next_bforms;
				next_bforms := []
		done
	done

and is_fo (sv : spec_var) var_map : bool = 
  try
	let msv = mona_of_spec_var sv in
	let vo = H.find var_map msv in
	  vo = FO
  with
	| Not_found ->
		false (* absence from var_map means not FO *)

(*
  let unprimed_name = name_of_spec_var sv in
  let primed_name = unprimed_name ^ Oclexer.primed_str in
	try
	  let vo = H.find var_map unprimed_name in
		vo = FO
	with
	  | Not_found -> 
		  try
			let vo = H.find var_map primed_name in
			  vo = FO
		  with
			| Not_found ->
				false (* absence from var_map means not FO *)
*)

and is_fo_ref (sv : spec_var) : bool =
  is_fo sv !var_map_ref

and compute_fo_var (sv : spec_var) order var_map : bool =
  let msv = mona_of_spec_var sv in
	try
	  let vo = H.find var_map msv in
		if vo = order then false (* no change *)
		else failwith ("compute_fo_var: order-mismatch for " ^ msv)
	with
	  | Not_found -> 
		  let unprimed_name = name_of_spec_var sv in
		  let primed_name = unprimed_name ^ Oclexer.primed_str in
			H.add var_map unprimed_name order;
			H.add var_map primed_name order;
			(*  H.add var_map msv order; *)
			order = FO (* new FO var added *)
			
(*
  If any variable in svs is FO, set all variables in svs
  to FO and return true. Otherwise do nothing and return false.
*)
and to_fo (svs : spec_var list) var_map : bool =
  if List.exists (fun v -> is_fo v var_map) svs then
	let tmp = List.map (fun v -> compute_fo_var v FO var_map) svs in
	let res = List.exists (fun v -> v) tmp in
	  res
  else
	false

(*
  e0 is a bag, so terms inside e0 must be FO, unless e0 itself is a SO var.
*)
and compute_fo_exp (e0 : exp) order var_map : bool = match e0 with
  | Null _ 
  | IConst _ -> false
  | Var (sv, _) -> compute_fo_var sv order var_map
  | Add (e1, e2, _)
  | Subtract (e1, e2, _)
  | Max (e1, e2, _)
  | Min (e1, e2, _) ->
	  let r1 = compute_fo_exp e1 order var_map in
	  let r2 = compute_fo_exp e2 order var_map in
		r1 || r2
  | Mult (_, e1, _) ->
	  compute_fo_exp e1 order var_map
  | Bag (es, _) ->
	  if order = SO then
		let r =	List.map (fun e -> compute_fo_exp e FO var_map) es in
		  List.exists (fun v -> v) r
	  else
		failwith ("compute_fo_exp: invalid parameters: non SO bag expression.")
  | BagUnion (es, _)
  | BagIntersect (es, _) ->
	  if order = SO then
		let r = List.map (fun e -> compute_fo_exp e SO var_map) es in
		  List.exists (fun v -> v) r
	  else
		failwith ("compute_fo_exp: invalid parameters: non SO bag expression.")
  | BagDiff (e1, e2, _) ->
	  if order = SO then begin
		let r1 = compute_fo_exp e1 SO var_map in
		let r2 = compute_fo_exp e2 SO var_map in
		  r1 || r2
	  end else
		failwith ("compute_fo_exp: invalid parameters: non SO bag expression.")

(* 
   Transformations: 
   a1 < a2 + a3 ==> ex f . a1 < f & f = a2 + a3
   a1 = a2 + a3 + a4 ==> ex f . f = a2 + a3 & a1 = f + a4
*)
and normalize (f0 : formula) : formula = match f0 with
  | BForm bf -> normalize_b_formula bf
  | And (f1, f2, pos) ->
	  let nf1 = normalize f1 in
	  let nf2 = normalize f2 in
	  let nf = mkAnd nf1 nf2 pos in
		nf
  | Or (f1, f2, pos) ->
	  let nf1 = normalize f1 in
	  let nf2 = normalize f2 in
	  let nf = mkOr nf1 nf2 pos in
		nf
  | Not (f1, pos) ->
	  let nf1 = normalize f1 in
	  let nf = mkNot nf1 pos in
		nf
  | Forall (qvar, qf, pos) ->
	  let nqf = normalize qf in
	  let nf = Forall (qvar, nqf, pos) in
		nf
  | Exists (qvar, qf, pos) ->
	  let nqf = normalize qf in
	  let nf = Exists (qvar, nqf, pos) in
		nf

(*
and normalize_b_formula (bf0 : b_formula) : formula = 
  (* 
	 helper0, helper1: flatten nested Add.
	 Return value:
	 first component: new expression
	 second component: (optional) formula linking new expression and old one
	 last component: existential variables introduced during the process
  *)
  let helper0 e =
	if is_var_num e then (e, [], [])
	else 
	  let fn = fresh_name () in
	  let pos = pos_of_exp e in
	  let sv = SpecVar (Prim Int, fn, Unprimed) in
	  let new_e = Var (sv, pos) in
	  let additional_e = BForm (Eq (new_e, e, pos)) in
		(new_e, [additional_e], [sv])
  in
  let rec helper1 e = match e with
	| Add (e1, e2, pos) ->
		if is_var e1 && is_var e2 then
		  helper0 e
		else
		  let new_e1, a1, v1 = helper1 e1 in
		  let new_e2, a2, v2 = helper1 e2 in
		  let tmp1 = Add (new_e1, new_e2, pos) in
		  let tmp2 = a1 @ a2 in
		  let tmp3 = v1 @ v2 in
			(tmp1, tmp2, tmp3)
	| _ -> helper0 e
  in
	(* 
	   transform Subtract to Add. Does it work with Subtract nested inside Add? No
	*)
  let rec helper2 mk e1 e2 pos = match e1, e2 with
	| Subtract (a, b, p1), Subtract (c, d, p2) ->
		let new_e1 = Add (a, d, p1) in
		let new_e2 = Add (c, b, p2) in
		  helper2 mk new_e1 new_e2 pos
	| Subtract (a, b, p1), _ ->
		let new_e1 = a in
		let new_e2 = Add (b, e2, pos) in
		  helper2 mk new_e1 new_e2 pos
	| _, Subtract (c, d, p2) ->
		let new_e1 = Add (e1, d, pos) in
		let new_e2 = c in
		  helper2 mk new_e1 new_e2 pos
	| _ ->
		let new_e1, additional_e1, var_e1 = helper1 e1 in
		let new_e2, additional_e2, var_e2 = helper1 e2 in
		let tmp1 = BForm (mk new_e1 new_e2 pos) in
		let tmp2 = tmp1 :: (additional_e1 @ additional_e2) in
		let tmp3 = List.fold_left (fun a -> fun b -> mkAnd a b pos) (mkTrue pos) tmp2 in
		let tmp4 = mkExists (var_e1 @ var_e2) tmp3 pos in
		  tmp4
  in
	match bf0 with
	  | BConst _
	  | BVar _
	  | EqMin _
	  | EqMax _
	  | BagIn _
	  | BagNotIn _
	  | BagSub _
	  | BagMin _
	  | BagMax _ -> BForm bf0
	  | Eq (e1, e2, pos) -> helper2 mkEq e1 e2 pos
	  | Neq (e1, e2, pos) -> helper2 mkNeq e1 e2 pos
	  | Lt (e1, e2, pos) -> helper2 mkLt e1 e2 pos
	  | Lte (e1, e2, pos) -> helper2 mkLte e1 e2 pos
	  | Gt (e1, e2, pos) -> helper2 mkGt e1 e2 pos
	  | Gte (e1, e2, pos) -> helper2 mkGte e1 e2 pos
*)

and is_normalized_term (e : exp) : bool = match e with
  | Null _
  | Var _
  | IConst _ -> true
  | Add (e1, e2, _) -> (is_var_num e1) && (is_var_num e2)
  | _ -> false

and normalize_b_formula (bf0 : b_formula) : formula =
  let helper2 mk e1 e2 pos =
	let a1, s1 = split_add_subtract e1 in
	let a2, s2 = split_add_subtract e2 in
	let left = a1 @ s2 in
	let right = a2 @ s1 in
	let left_e, left_f, left_v = flatten_list left in
	let right_e, right_f, right_v = flatten_list right in
	let tmp = BForm (mk left_e right_e pos) in
	let tmp1 = mkAnd left_f right_f pos in
	let tmp2 = mkAnd tmp tmp1 pos in
	let res_f = mkExists (left_v @ right_v) tmp2 pos in
	  res_f
  in
	match bf0 with
	  | BConst _
	  | BVar _
	  | EqMin _
	  | EqMax _
	  | BagIn _
	  | BagNotIn _
	  | BagSub _
	  | BagMin _
	  | BagMax _ -> BForm bf0
	  | Eq (e1, e2, pos) -> 
		  if ((is_var_num e1 || is_null e1) && is_normalized_term e2) || 
			((is_var_num e2 || is_null e2) && is_normalized_term e1)
		  then (BForm bf0)
		  else helper2 mkEq e1 e2 pos
	  | Neq (e1, e2, pos) -> mkNot (helper2 mkEq e1 e2 pos) pos
	  | Lt (e1, e2, pos) -> helper2 mkLt e1 e2 pos
	  | Lte (e1, e2, pos) -> helper2 mkLte e1 e2 pos
	  | Gt (e1, e2, pos) -> helper2 mkGt e1 e2 pos
	  | Gte (e1, e2, pos) -> helper2 mkGte e1 e2 pos
		  
(*
  return value:
  first component: list of "add" terms
  second component: list of "subtract" terms

  example: split_add_subtract (a + b - c + d - e) = ([a, b, d], [c, e])
*)
and split_add_subtract (e0 : exp) : (exp list * exp list) = match e0 with
  | Null _ -> ([e0], [])
  | Var _ -> ([e0], [])
  | IConst (i, pos) ->
	  if i >= 0 then ([e0], [])
	  else ([], [IConst (-i, pos)])
  | Add (e1, e2, _) ->
	  let a1, s1 = split_add_subtract e1 in
	  let a2, s2 = split_add_subtract e2 in
		(a1 @ a2, s1 @ s2)
  | Subtract (e1, e2, _) -> 
	  let a1, s1 = split_add_subtract e1 in
	  let a2, s2 = split_add_subtract e2 in
		(a1 @ s2, s1 @ a2)
  | Mult (i, e1, pos) ->
	  if i = 1 then ([e1], [])
	  else if i = -1 then ([], [e1])
	  else failwith ("split_add_subtract: Mult with unsupported coefficent: " ^ (string_of_int i))
  | _ -> ([e0], [])


(* 
   flatten nested Add.
   Return value:
   first component: new expression
   second component: (optional) formula linking new expression and old one
   last component: existential variables introduced during the process
*)
and flatten_list (es0 : exp list) : (exp * formula * spec_var list) = 
(*
  let helper e =
	if is_var_num e || is_null e then (e, mkTrue no_pos, [])
	else 
	  let fn = fresh_name () in
	  let pos = pos_of_exp e in
	  let sv = SpecVar (Prim Int, fn, Unprimed) in
	  let new_e = Var (sv, pos) in
	  let additional_e = BForm (Eq (new_e, e, pos)) in
		(new_e, additional_e, [sv])
  in
*)
  match es0 with
	| [] -> failwith ("flatten_list: es0 should be nonempty.")
	| [e] -> (e, mkTrue no_pos, [])
	| e1 :: e2 :: rest -> begin
		if is_zero e1 then flatten_list (e2 :: rest)
		else if is_zero e2 then flatten_list (e1 :: rest)
		else
		  let pos = pos_of_exp e1 in
			let fn = fresh_var_name "int" pos.start_pos.Lexing.pos_lnum in
		  let sv = SpecVar (Prim Int, fn, Unprimed) in
		  let new_e = Var (sv, pos) in
		  let additional_e = BForm (Eq (new_e, Add (e1, e2, pos), pos)) in
			if Util.empty rest then
			  (new_e, additional_e, [sv])
			else
			  let new_es = new_e :: rest in
			  let new1, f1, v1 = flatten_list new_es in
			  let res_f = mkAnd f1 additional_e pos in
				(new1, res_f, sv :: v1)
	  end

(*************************************************************)
(*************************************************************)
(*************************************************************)

and mona_of_spec_var sv = match sv with
  | SpecVar (_, v, p) -> v ^ (if is_primed sv then Oclexer.primed_str else "")

and mona_of_exp order e0 = match e0 with
  | Null _ -> 
	  if order = FO then "0" 
	  else "empty"
  | Var (v, _) -> 
	  (*
		if order = FO && not (is_fo_ref v) then
		let _ = print_var_map !var_map_ref in
		failwith ("mona_of_exp: FO var is not FO in var_map: " ^ (mona_of_spec_var v))
		else
	  *)
	  mona_of_spec_var v
  | IConst (i, _) ->
	  if order = FO then (string_of_int i)
	  else "pconst(" ^ (string_of_int i) ^ ")"
  | Bag (es, _) ->
	  if order = FO then
		failwith ("mona_of_exp: bag is invoked with FO")
	  else
		let tmp1 = List.map (mona_of_exp FO) es in
		let tmp2 = String.concat ", " tmp1 in
		  "{" ^ tmp2 ^ "}"
  | BagUnion (es, _) ->
	  if order = FO then
		failwith ("mona_of_exp: bag is invoked with FO")
	  else
		let tmp1 = List.map (mona_of_exp SO) es in
		let tmp2 = String.concat " union " tmp1 in
		  "(" ^ tmp2 ^ ")"
  | BagIntersect (es, _) ->
	  if order = FO then
		failwith ("mona_of_exp: bag is invoked with FO")
	  else
		let tmp1 = List.map (mona_of_exp SO) es in
		let tmp2 = String.concat " inter " tmp1 in
		  "(" ^ tmp2 ^ ")"
  | BagDiff (e1, e2, _) ->
	  if order = FO then
		failwith ("mona_of_exp: bag is invoked with FO")
	  else
		let tmp1 = mona_of_exp SO e1 in
		let tmp2 = mona_of_exp SO e2 in
		  "(" ^ tmp1 ^ " \ " ^ tmp2 ^ ")"
  | Add (e1, e2, _) ->
	  let e1str = mona_of_exp order e1 in
	  let e2str = mona_of_exp order e2 in
		e1str ^ " + " ^ e2str
  | Subtract (e1, e2, _) ->
	  let e1str = mona_of_exp order e1 in
	  let e2str = mona_of_exp order e2 in
		e1str ^ " - " ^ e2str
  | _ -> failwith ("mona_of_exp: " ^ (Cprinter.string_of_formula_exp e0) 
				   ^ ": not supported in set mode.")

and is_fo_exp (e0 : exp) = match e0 with
  | Var (sv, _) -> is_fo_ref sv
  | _ -> false

and mona_of_bin_op op1 op2 e1 e2 =
  if is_fo_exp e1 || is_fo_exp e2 then
	let tmp1 = mona_of_exp FO e1 in
	let tmp2 = mona_of_exp FO e2 in
	  tmp1 ^ op1 ^ tmp2
  else
	let tmp1 = mona_of_exp SO e1 in
	let tmp2 = mona_of_exp SO e2 in
	  op2 ^ "(" ^ tmp1 ^ ", " ^ tmp2 ^ ")"

and mona_of_b_formula bf0 = match bf0 with
  | BConst (b, _) -> if b then "true" else "false"
  | BVar (sv, _) -> "(" ^ (mona_of_spec_var sv) ^ " ~= empty)"
(*
  | Eq (e1, e2, _) -> mona_of_bin_op " = " "equal" e1 e2
  | Neq (e1, e2, _) -> mona_of_bin_op " ~= " "nequal" e1 e2
*)
  | Eq (e1, e2, pos) ->
	  if not (is_var_num e1 || is_var_num e2) then
		failwith ("mona_of_b_formula: Eq: normalize failed to transform: " ^ (Cprinter.string_of_b_formula bf0))
	  else if not (is_var_num e1) then mona_of_b_formula (Eq (e2, e1, pos))
	  else 
		begin
		  if is_fo_exp e1 || is_fo_exp e2 then
			let e1str = mona_of_exp FO e1 in
			let e2str = mona_of_exp FO e2 in
			  "(" ^ e1str ^ " = " ^ e2str ^ ")"
		  else
			match e2 with
			  | Add (a, b, _) ->
				  let e1str = mona_of_exp SO e1 in
				  let astr = mona_of_exp SO a in
				  let bstr = mona_of_exp SO b in
					"plus(" ^ astr ^ ", " ^ bstr ^ ", " ^ e1str ^ ")"
			  | Subtract (a, b, _) ->
				  failwith ("normalize failed to transform: " ^ (Cprinter.string_of_b_formula bf0))
			  | _ ->
				  let e1str = mona_of_exp SO e1 in
				  let e2str = mona_of_exp SO e2 in
					"(" ^ e1str ^ " = " ^ e2str ^ ")"
(*
				  if is_fo_ref ve1 then ve1str ^ " = " ^ (mona_of_exp FO e2)
				  else ve1str ^ " = " ^ (mona_of_exp SO e2)
*)
		end
  | Neq (e1, e2, pos) -> "~(" ^ (mona_of_b_formula (Eq (e1, e2, pos))) ^ ")"
  | Lt (e1, e2, _) -> mona_of_bin_op " < " "less" e1 e2
  | Lte (e1, e2, _) -> mona_of_bin_op " <= " "lessEq" e1 e2
  | Gt (e1, e2, _) -> mona_of_bin_op " > " "greater" e1 e2
  | Gte (e1, e2, _) -> mona_of_bin_op " >= " "greaterEq" e1 e2
  | EqMin (e1, e2, e3, _) -> 
	  if is_fo_exp e1 || is_fo_exp e2 || is_fo_exp e3 then
		let e1str = mona_of_exp FO e1 in
		let e2str = mona_of_exp FO e2 in
		let e3str = mona_of_exp FO e3 in
		  "((" ^ e2str ^ " < " ^ e3str ^ " & " ^ e1str ^ " = " ^ e2str ^ ")"
		  ^ " | (" ^ e2str ^ " >= " ^ e3str ^ " & " ^ e1str ^ " = " ^ e3str ^ "))"
	  else
		let e1str = mona_of_exp SO e1 in
		let e2str = mona_of_exp SO e2 in
		let e3str = mona_of_exp SO e3 in
		  "((less(" ^ e2str ^ ", " ^ e3str ^ ") & " ^ e1str ^ " = " ^ e2str ^ ")"
		  ^ " | (lessEq(" ^ e2str ^ ", " ^ e3str ^ ") & " ^ e1str ^ " = " ^ e3str ^ "))"
  | BagIn (sv, e, _) ->
	  let tmp1 = mona_of_spec_var sv in
	  let tmp2 = mona_of_exp SO e in
		tmp1 ^ " in " ^ tmp2
  | BagNotIn (sv, e, _) ->
	  let tmp1 = mona_of_spec_var sv in
	  let tmp2 = mona_of_exp SO e in
		tmp1 ^ " notin " ^ tmp2
  | BagSub (e1, e2, _) ->
	  let tmp1 = mona_of_exp SO e1 in
	  let tmp2 = mona_of_exp SO e2 in
		tmp1 ^ " sub " ^ tmp2
  | BagMin (sv1, sv2, _) ->
	  let tmp1 = mona_of_spec_var sv1 in
	  let tmp2 = mona_of_spec_var sv2 in
		"min {" ^ tmp1 ^ ", " ^ tmp2 ^ "}"
  | BagMax (sv1, sv2, _) ->
	  let tmp1 = mona_of_spec_var sv1 in
	  let tmp2 = mona_of_spec_var sv2 in
		"max {" ^ tmp1 ^ ", " ^ tmp2 ^ "}"
  | _ -> failwith ("mona_of_b_formula: " ^ (Cprinter.string_of_b_formula bf0)
				   ^ ": not supported in set mode.")

and ex_quant_of_spec_var (sv : spec_var) : string =
  if is_fo_ref sv then "ex1 "
  else "ex2" (* don't use ex0 -- bool vars are encoded as second order vars *)
	  
and forall_quant_of_spec_var (sv : spec_var) : string =
  if is_fo_ref sv then "all1 "
  else "all2"

and print_var_map var_map =
  let p k i = print_string (k ^ " --> " ^ ((if i = FO then "FO" else "SO")) ^ "\n") in
	print_string "\n";
	H.iter p var_map;
	print_string "\n"

	
and mona_of_formula f0 = mona_of_formula_helper f0

and mona_of_formula_helper f0 = match f0 with
  | BForm bf -> mona_of_b_formula bf 
  | And (f1, f2, _) ->
	  let tmp1 = mona_of_formula_helper f1 in
	  let tmp2 = mona_of_formula_helper f2 in
		"(" ^ tmp1 ^ " & " ^ tmp2 ^ ")"
  | Or (f1, f2, _) ->
	  let tmp1 = mona_of_formula_helper f1 in
	  let tmp2 = mona_of_formula_helper f2 in
		"(" ^ tmp1 ^ " | " ^ tmp2 ^ ")"
  | Not (f1, _) ->
	  let tmp1 = mona_of_formula_helper f1 in
		"(~(" ^ tmp1 ^ "))"
  | Forall (sv, f, _) ->
	  let tmp1 = mona_of_spec_var sv in
	  let tmp2 = mona_of_formula_helper f in
	  let quant = forall_quant_of_spec_var sv in
		"(" ^ quant ^ " " ^ tmp1 ^ " : " ^ tmp2 ^ ")"
  | Exists (sv, f, _) ->
	  let tmp1 = mona_of_spec_var sv in
	  let tmp2 = mona_of_formula_helper f in
	  let quant = ex_quant_of_spec_var sv in
		"(" ^ quant ^ " " ^ tmp1 ^ " : " ^ tmp2 ^ ")"

(*
  Interfacing with MONA in set mode.
*)

let mona = "mona"

let mona_command = mona ^ " " ^ infilename ^ " > " ^ resultfilename

let run_mona (input : string) : unit = 
  let chn = open_out infilename in
	if !log_all_flag then
	  (output_string log_all "\n#setmona:\n"; output_string log_all input; flush log_all);
	output_string chn (Util.break_lines input);
	close_out chn;
	ignore (Sys.command mona_command)

(*
  Interface for Tpdispatcher.
*)
(*
let rec imply (ante : formula) (conseq : formula) : bool =
  let tmp1 = break_implication ante conseq in
	if (List.length tmp1) <= 1 then
	  imply1 ante conseq
	else
	  let res = List.for_all (fun (a, c) -> imply1 a c) tmp1 in
		res
*)

(*
  Return lists of first and second order vars
*)
let rec compute_vars (svs : spec_var list) : (ident list * ident list) =
  let vsn = List.map mona_of_spec_var svs in
	compute_vars_helper vsn

and compute_vars_helper (vsn : ident list) : (ident list * ident list) = match vsn with
  | vs :: rest -> begin
	  let fovars, sovars = compute_vars_helper rest in
		try
		  let vo = H.find !var_map_ref vs in
			if vo = FO then (vs :: fovars, sovars)
			else (fovars, vs :: sovars)
		with
		  | Not_found -> 
			  (fovars, vs :: sovars)
	end
  | [] -> ([], [])

let imply (ante : formula) (conseq : formula) : bool =
  (*
	let ante1 = elim_exists ante0 in
	let conseq = elim_exists conseq0 in
	let ante = 
	if isConstFalse conseq0 then ante1
	else filter_var ante1 (fv conseq)
	in
	let _ = output_string log_all ("\n\n#imply") in
	let _ = output_string log_all ("\n#ante0:\n" ^ (mona_of_formula ante0) ^ "\n") in
	let _ = output_string log_all ("\n#ante1:\n" ^ (mona_of_formula ante1) ^ "\n") in
	let _ = output_string log_all ("\n#ante:\n" ^ (mona_of_formula ante) ^ "\n") in
	let _ = output_string log_all ("\n#conseq0:\n" ^ (mona_of_formula conseq0) ^ "\n") in
	let _ = output_string log_all ("\n#conseq:\n" ^ (mona_of_formula conseq) ^ "\n") in
  *)
  let ante = normalize ante in
  let conseq = normalize conseq in
  let var_map = H.create 103 in
  let tmptmp = mkOr ante conseq no_pos in
(*  let _ = print_string ("\ntmptmp:\n" ^ (Cprinter.string_of_pure_formula tmptmp ^ "\n")) in *)
  let _ = compute_fo_formula tmptmp var_map in
  let _ = var_map_ref := var_map in
  let tmp_vars = fv tmptmp in
  let fvars, svars = compute_vars tmp_vars in
  let var_decls =
	(if Util.empty fvars then ""
	 else "var1 " ^ (String.concat ", " fvars) ^ ";\n")
	^ (if Util.empty svars then ""
	   else "var2 " ^ (String.concat ", " svars) ^ ";\n") in
  let ante_str = mona_of_formula ante in
  let conseq_str = mona_of_formula conseq in
  let mona_str = presPred ^ "\n\n" ^ var_decls ^ "(" ^ ante_str ^ ") => (" ^ conseq_str ^ ");\n" in
  let _ = run_mona mona_str in
  let fd = open_in resultfilename in
  let quit = ref false in
  let automaton_completed = ref false in
  let result = ref false in
	while not(!quit) do
	  try
		let line = input_line fd  in
	      match line with
			| "Formula is valid" -> 	
      			if !log_all_flag = true then 
      		      (output_string log_all (" [mona.ml]: --> SUCCESS\n"); flush log_all);
      			quit := true;
				result := true
            | "ANALYSIS" -> automaton_completed := true 		   
			| "Execution aborted" -> failwith ("Error in MONA input file.")
            | _ -> ()
	  with
		| End_of_file -> 
			if !automaton_completed = false then begin
			  output_string log_all ("\nERROR... Mona is out of memory\n");
			  (*failwith "[mona.ml] : out of memory";*)
			  quit := true;
			  result := false
			end else begin
			  if !log_all_flag==true then
				(output_string log_all (" [mona.ml]: --> Unable to prove theory \n"); flush log_all);
              quit := true;
			  result := false
			end
	done;
	!result

let is_sat (f : formula) : bool = 
  if !log_all_flag == true then
	output_string log_all "\n\n[mona.ml]: #is_sat\n";
  let f = elim_exists f in
  let tmp_form = (imply f (BForm(BConst(false, no_pos)))) in
	match tmp_form with
	  | true -> 
		  begin 
			if !log_all_flag == true then 
			  output_string log_all "[mona.ml]: is_sat --> false\n"; 					
			false; 
		  end
	  | false -> 
		  begin 
			if !log_all_flag == true then 
			  output_string log_all "[mona.ml]: is_sat --> true\n"; 
			true; 
		  end
