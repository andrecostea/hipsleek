#include "xdebug.cppo"

open Cpure
open Globals
open Debug
open VarGen
(* Translate out array in cpure formula  *)

let global_unchanged_info = ref [];;


(* array_transform_info contains 2 fields. *target_array* denotes the array element expression to be translated, while *new_name* denoting the new expression *)
type array_transform_info =
  {
    target_array:exp;
    new_name:exp
  }
;;

type array_transform_return =
  {
    imply_ante: b_formula;
    imply_conseq: b_formula;
    array_to_var: b_formula;
  }
;;

let print_pure = ref (fun (c:formula) -> "printing not initialized");;
let print_p_formula = ref (fun (p:p_formula) -> "printing not initialized");;
let string_of_array_transform_info
    (a:array_transform_info):string=
  "array_transform: { target_array = "^(ArithNormalizer.string_of_exp a.target_array)^"; new_name = "^(ArithNormalizer.string_of_exp a.new_name)^" }"
;;

let get_array_name
    (e:exp):(spec_var)=
  match e with
  | ArrayAt (sv,_,_) -> sv
  | _ -> failwith "get_array_name: Invalid input"
;;

let get_array_at_index
    (e:exp):exp=
  match e with
  | ArrayAt (sv,elst,_)->
    begin
      match elst with
      | [index] -> index
      | _ -> failwith "get_array_at_index: Fail to handle multi-dimension array"
    end
  | _ -> failwith "get_array_at_index: Invalid input"
;;

let is_same_sv
    (sv1:spec_var) (sv2:spec_var):bool=
  (* let () = print_endline ((string_of_spec_var sv1)^" and "^(string_of_spec_var sv2)) in *)
  match sv1,sv2 with
  | SpecVar (t1,i1,p1), SpecVar (t2,i2,p2)->
    begin
      match p1,p2 with
      | Primed,Primed
      | Unprimed,Unprimed ->
        (* if (cmp_typ t1 t2) && (i1=i2) then true else false *)
        if (i1=i2) then true else false
      | _,_->
        (* let () = x_binfo_pp ("is_same_sv:different primed") no_pos in *)
        false
    end
;;

let rec remove_dupl equal lst =
  let rec helper item lst =
    match lst with
    | h::rest ->
      if equal item h then true
      else helper item rest
    | [] -> false
  in
  match lst with
  | h::rest ->
    if helper h rest
    then
      remove_dupl equal rest
    else
      h::(remove_dupl equal rest)
  | [] -> []
;;

(* let is_same_sv sv1 sv2 = *)
(*   Debug.no_2 "is_same_sv" string_of_spec_var string_of_spec_var string_of_bool is_same_sv sv1 sv2 *)
(* ;; *)

(* let is_same_var *)
(*     (v1:exp) (v2:exp):bool = *)
(*   match v1, v2 with *)
(*   | Var (sv1,_), Var (sv2,_)-> *)
(*     is_same_sv sv1 sv2 *)
(*   | Var _, IConst _ *)
(*   | IConst _, Var _ -> *)
(*     false *)
(*   | _ -> failwith ("is_same_var:"^(ArithNormalizer.string_of_exp v1)^" "^(ArithNormalizer.string_of_exp v2)^" Invalid input") *)
(* ;; *)

let rec is_same_exp
    (e1:exp) (e2:exp):bool=
  match e1,e2 with
  | Null _,Null _ -> true
  | Var (sv1,_), Var (sv2,_)
  | Level (sv1,_),Level (sv2,_) ->
    is_same_sv sv1 sv2
  | IConst (i1,_), IConst (i2,_)->
        i1=i2
  | FConst (i1,_), FConst (i2,_)->
    i1 = i2
  | ListHead (e1,_), ListHead (e2,_)
  | ListTail (e1,_), ListTail (e2,_)
  | ListLength (e1,_),ListLength (e2,_)
  | ListReverse (e1,_),ListReverse (e2,_) ->
    is_same_exp e1 e2
  | Tup2 ((e11,e12),_),Tup2((e21,e22),_)
  | Add (e11,e12,_),Add (e21,e22,_)
  | Subtract (e11,e12,_), Subtract (e21,e22,_)
  | Mult (e11,e12,_), Mult (e21,e22,_)
  | Div (e11,e12,_),Div (e21,e22,_)
  | Max (e11,e12,_),Max (e21,e22,_)
  | Min (e11,e12,_),Min (e21,e22,_)
  | BagDiff (e11,e12,_),BagDiff (e21,e22,_)
  | ListCons (e11,e12,_), ListCons (e21,e22,_) ->
    (is_same_exp e11 e21) && (is_same_exp e12 e22)
  | ListAppend (elst1,_), ListAppend (elst2,_)
  | Bag (elst1,_), Bag (elst2,_)
  | BagUnion (elst1,_), BagUnion (elst2,_)
  | List (elst1,_), List (elst2,_) ->
    List.fold_left2 (fun b e1 e2 -> b && (is_same_exp e1 e2)) true elst1 elst2
  | ArrayAt (sv1,elst1,_), ArrayAt (sv2,elst2,_)
  | Func (sv1,elst1,_), Func (sv2,elst2,_)->
    (is_same_sv sv1 sv2) && (List.fold_left2 (fun b e1 e2 -> b && (is_same_exp e1 e2)) true elst1 elst2)
  | _ -> false
;;

let is_same_array
    (e1:exp) (e2:exp):bool=
  match e1,e2 with
  | ArrayAt (sv1,elst1,_), ArrayAt (sv2,elst2,_) ->
    if is_same_sv sv1 sv2 then true else false
  | _,_ -> failwith "is_same_array: Invalid Input"
;;

(* It may not work properly for not-constant cases because the implementation of is_same_exp *)
let is_same_array_at
    (e1:exp) (e2:exp):bool=
  let is_same_exp_list
      (elst1:exp list) (elst2:exp list):bool=
    List.fold_left2 (fun b e1 e2 -> b && (is_same_exp e1 e2)) true elst1 elst2
  in
  match e1,e2 with
  | ArrayAt (sv1,elst1,_), ArrayAt (sv2,elst2,_) ->
    if (is_same_sv sv1 sv2) && (is_same_exp_list elst1 elst2) then true else false
  | _,_ -> failwith "is_same_array_at: Invalid Input"
;;

let rec remove_dupl_spec_var_list
    (svlst:spec_var list):(spec_var list) =
  let rec helper
      (sv:spec_var) (svlst:spec_var list):(spec_var list) =
    match svlst with
    | h::rest -> if is_same_sv sv h then helper sv rest else h::(helper sv rest)
    | [] -> []
  in
  match svlst with
  | h::rest -> h::(helper h (remove_dupl_spec_var_list rest))
  | [] -> []
;;

let remove_dupl_spec_var_list svlst =
  Debug.no_1 "remove_dupl_spec_var_list" (pr_list string_of_spec_var) (pr_list string_of_spec_var) (fun svlst ->remove_dupl_spec_var_list svlst) svlst
;;

let mk_imply
    (ante:formula) (conseq:formula):formula=
  Or (Not (ante,None,no_pos),conseq,None,no_pos)
;;

let mk_array_new_name_spec_var
    (sv:spec_var) (e:exp):spec_var =
  match sv with
  | SpecVar (typ,id,primed)->
    begin
      match typ with
      | Array (atyp,_)->
        begin
          match primed with
          | Primed ->
            (*Var( SpecVar (atyp,(id)^"_"^"primed_"^(ArithNormalizer.string_of_exp e),primed),no_pos)*)
            SpecVar (atyp,(id)^"___"^(ArithNormalizer.string_of_exp e)^"___",primed)
          | _ -> SpecVar (atyp,(id)^"___"^(ArithNormalizer.string_of_exp e)^"___",primed)
        end
      | _ -> failwith "mk_array_new_name: Not array type"
    end
;;

let mk_array_new_name_wrapper_for_array
    (e:exp):spec_var =
  match e with
  | ArrayAt (sv,[ne],_) ->
    mk_array_new_name_spec_var sv ne
  | _ ->
    failwith "mk_array_new_name_wrapper_for_array: Invalid input"
;;

let mk_array_new_name
    (sv:spec_var) (e:exp):exp=
  match sv with
  | SpecVar (typ,id,primed)->
    begin
      match typ with
      | Array (atyp,_)->
        begin
          match primed with
          | Primed ->
            (*Var( SpecVar (atyp,(id)^"_"^"primed_"^(ArithNormalizer.string_of_exp e),primed),no_pos)*)
            Var( SpecVar (atyp,(id)^"___"^(ArithNormalizer.string_of_exp e)^"___",primed),no_pos)
          | _ -> Var( SpecVar (atyp,(id)^"___"^(ArithNormalizer.string_of_exp e)^"___",primed),no_pos)
        end
      | _ -> failwith "mk_array_new_name: Not array type"
    end
;;

let mk_array_new_name
    (sv:spec_var) (e:exp):exp=
  let psv = string_of_spec_var in
  let pe = ArithNormalizer.string_of_exp in
  Debug.no_2 "mk_array_new_name" psv pe pe (fun sv e-> mk_array_new_name sv e) sv e
;;

let rec mk_and_list
    (flst:formula list):formula=
  match flst with
  | [h] -> h
  | h::rest -> And (h,mk_and_list rest,no_pos)
  | [] -> mkTrue no_pos
  (*| [] -> failwith "mk_and_list: Invalid input"*)
;;

let rec mk_or_list
    (flst:formula list):formula=
  match flst with
  | [h] -> h
  | h::rest -> Or (h,mk_or_list rest,None,no_pos)
  | [] -> failwith "mk_and_list: Invalid input"
;;

let rec contain_array
    (f:formula):bool=
  let rec contain_array_exp
      (e:exp):bool=
    match e with
    | ArrayAt _
      -> true
    | Tup2 ((e1,e2),loc)
    | Add (e1,e2,loc)
    | Subtract (e1,e2,loc)
    | Mult (e1,e2,loc)
    | Div (e1,e2,loc)
    | Max (e1,e2,loc)
    | Min (e1,e2,loc)
    | BagDiff (e1,e2,loc)
    | ListCons (e1,e2,loc)->
      ((contain_array_exp e1) or (contain_array_exp e2))
    | TypeCast (_,e1,loc)
    | ListHead (e1,loc)
    | ListTail (e1,loc)
    | ListLength (e1,loc)
    | ListReverse (e1,loc)->
      contain_array_exp e1
    | Null _|Var _|Level _|IConst _|FConst _|AConst _|InfConst _|Tsconst _|Bptriple _|ListAppend _|Template _
    | Func _
    | List _
    | Bag _
    | BagUnion _
    | BagIntersect _
      -> false
    | _ -> failwith "Unexpected case"
  in
  let contain_array_b_formula
      ((p,ba):b_formula):bool=
    match p with
    | Frm _
    | XPure _
    | LexVar _
    | BConst _
    | BVar _
    | BagMin _
    | BagMax _
    (*| VarPerm _*)
    | RelForm _ ->
      false
    | BagIn (sv,e1,loc)
    | BagNotIn (sv,e1,loc)->
      contain_array_exp e1
    | Lt (e1,e2,loc)
    | Lte (e1,e2,loc)
    | Gt (e1,e2,loc)
    | Gte (e1,e2,loc)
    | SubAnn (e1,e2,loc)
    | Eq (e1,e2,loc)
    | Neq (e1,e2,loc)
    | ListIn (e1,e2,loc)
    | ListNotIn (e1,e2,loc)
    | ListAllN (e1,e2,loc)
    | ListPerm (e1,e2,loc)->
      (contain_array_exp e1) || (contain_array_exp e2)
    | EqMax (e1,e2,e3,loc)
    | EqMin (e1,e2,e3,loc)->
      (contain_array_exp e1) || (contain_array_exp e2) || (contain_array_exp e3)
    | _ -> false
  in
  match f with
  | BForm (b,fl)->
    contain_array_b_formula b
  | And (f1,f2,loc)->
    (contain_array f1) || (contain_array f2)
  | AndList lst->
    failwith "contain_array: To Be Implemented"
  | Or (f1,f2,fl,loc)->
    (contain_array f1) || (contain_array f2)
  | Not (not_f,fl,loc)->
    contain_array not_f
  | Forall (sv,f1,fl,loc)->
    contain_array f1
  | Exists (sv,f1,fl,loc)->
    contain_array f1
;;

let contain_array
    (f:formula):bool =
  Debug.no_1 "contain_array" !print_pure string_of_bool (fun f->contain_array f
                                                        ) f
;;

(* ----------------------------------------------------------------------------------- *)

let rec normalize_not
    (f:formula):formula =
  match f with
  | BForm (b,fl)->
    f
  | And (f1,f2,l)->
    let nf1 = normalize_not f1 in
    let nf2 = normalize_not f2 in
    And (nf1,nf2,l)
  | AndList lst->
    failwith "normalize_not: To Be Implemented"
  | Or (f1,f2,fl,l)->
    let nf1 = normalize_not f1 in
    let nf2 = normalize_not f2 in
    Or (nf1,nf2,fl,l)
  | Not (not_f,fl,l)->
    begin
      match not_f with
      | BForm _ ->
        f
      | And (f1,f2,l)->
        let nf1 = normalize_not (Not (f1,None,no_pos)) in
        let nf2 = normalize_not (Not (f1,None,no_pos)) in
        Or (nf1,nf2,None,no_pos)
      | Or (f1,f2,fl,l)->
        let nf1 = normalize_not (Not (f1,None,no_pos)) in
        let nf2 = normalize_not (Not (f1,None,no_pos)) in
        And (nf1,nf2,no_pos)
      | AndList _ ->
        failwith "normalize_not: To Be Implemented"
      | Not (not_f1,fl1,l1) ->
        not_f1
      | _ ->
        f
    end
  | Forall _
  | Exists _->
    f
;;

let normalize_not
    (f:formula):formula =
  Debug.no_1 "normalize_not" !print_pure !print_pure (fun f -> normalize_not f) f
;;

let rec normalize_or
    (f:formula):(formula list) =
  match f with
  | BForm (b,fl)->
    [f]
  | And (f1,f2,l)->
    let flst1 = normalize_or f1 in
    let flst2 = normalize_or f2 in
    List.fold_left (
      fun result tmp_f1 -> result @ (List.map (fun tmp_f2 -> And (tmp_f1,tmp_f2,no_pos)) flst2)) [] flst1
  | AndList lst->
    failwith "normalize_or: To Be Implemented"
  | Or (f1,f2,fl,l)->
    let flst1 = normalize_or f1 in
    let flst2 = normalize_or f2 in
    flst1@flst2
  | Not (not_f,fl,l)->
    [f]
  | Forall _
  | Exists _->
    [f]
;;

let normalize_or
    (f:formula):(formula list)=
  let pflst = fun flst -> List.fold_left (fun s f -> s^" "^(!print_pure f)) "" flst in
  Debug.no_1 "normalize_or" !print_pure pflst (fun f -> normalize_or f) f
;;

let print_flst
    (flst:(formula list)):string =
  let helper
      (flst:(formula list)):string =
    List.fold_left (fun s f-> s^" "^(!print_pure f)) "" flst
  in
  "["^(helper flst)^"]"
;;

let print_flstlst
    (flstlst:((formula list) list)):string =
  let helper
      (flstlst:((formula list) list)):string =
    List.fold_left (fun s flst -> s^" "^(print_flst flst)) "" flstlst
  in
  "["^(helper flstlst)^"]"
;;

let rec normalize_to_lst
    (f:formula):((formula list) list) =
  let helper
      (f:formula):((formula list) list) =
    match f with
    | BForm (b,fl)->
      [[f]]
    | And (f1,f2,l)->
      let flst1 = normalize_to_lst f1 in
      let flst2 = normalize_to_lst f2 in
      List.fold_left (
        fun result tmp_f1 -> result @ (List.map (fun tmp_f2 -> tmp_f1@tmp_f2) flst2)) [] flst1
    | AndList lst->
      failwith "normalize_to_lst: To Be Implemented"
    | Or (f1,f2,fl,l)->
      let flst1 = normalize_to_lst f1 in
      let flst2 = normalize_to_lst f2 in
      flst1@flst2
    | Not (not_f,fl,l)->
      [[f]]
    | Forall _
    | Exists _->
      [[f]]
  in
  helper (normalize_not f)
;;

let normalize_to_lst
    (f:formula):((formula list) list) =
  Debug.no_1 "normalize_to_lst" !print_pure print_flstlst (fun f-> normalize_to_lst f) f
;;

let split_for_process
    (f:formula) (cond:formula->bool) :(((formula list) list) * ((formula list) list)) =
  let rec helper_for_lst
      (flstlst:((formula list) list)):(((formula list) list) * ((formula list) list)) =
    match flstlst with
    | h::rest ->
      let (keep,throw) = helper_for_one h in
      let (rest_keep,rest_throw) = helper_for_lst rest in
      (keep::rest_keep,throw::rest_throw)
    | [] -> ([],[])
  and helper_for_one
      (flst:(formula list)):((formula list)*(formula list)) =
    match flst with
    | h::rest ->
      let (rest_k,rest_t) = helper_for_one rest in
      if cond h
      then (h::rest_k,rest_t)
      else (rest_k,h::rest_t)
    | [] ->
      ([],[])
  in
  helper_for_lst (normalize_to_lst f)
;;

let split_for_process
    (f:formula) (cond:formula->bool) : (((formula list) list) * ((formula list) list)) =
  let print_flstlst_pair =
    function
    | (flst1,flst2) -> "("^(print_flstlst flst1)^","^(print_flstlst flst2)^")"
  in
  Debug.no_1 "split_for_process" !print_pure print_flstlst_pair (fun _ -> split_for_process f cond) f
;;

let split_and_process
    (f:formula) (cond:formula->bool) (processor:formula->formula):formula =
  let rec combine
      (flst1:(formula list) list) (flst2:(formula list) list) :((formula list) list) =
    match flst1, flst2 with
    | h1::rest1,h2::rest2 ->
      (h1@h2)::(combine rest1 rest2)
    | [],[]->[]
    | _,_ -> failwith "split_and_process: Invalid input"
  in
  let (keeplst,throwlst) = split_for_process f cond in
  let nkeeplst = List.map (fun flst -> [processor (mk_and_list flst)]) keeplst in
  let n_flst = combine nkeeplst throwlst in
  mk_or_list (List.map (fun flst -> mk_and_list flst) n_flst)
;;

let split_and_process
    (f:formula) (cond:formula->bool) (processor:formula->formula):formula =
  Debug.no_1 "split_and_process" !print_pure !print_pure (fun _ -> split_and_process f cond processor) f
;;

let rec can_be_simplify
    (f:formula) : bool =
  let rec is_valid_forall_helper_b_formula
      ((p,ba):b_formula) (sv:spec_var):bool =
    let rec is_valid_forall_helper_exp
        (e:exp) (sv:spec_var) :bool =
      match e with
      | ArrayAt (arr,[index],loc) ->
        if is_same_sv arr sv
        then true
        else
          begin
            match index with
            | Var (i_sv,_) ->
              not (is_same_sv i_sv sv)
            | IConst _ ->
              true
            | _ ->
              false
          end
      | ArrayAt _ ->
        false
      | Add (e1,e2,loc)
      | Subtract (e1,e2,loc)
      | Mult (e1,e2,loc)
      | Div (e1,e2,loc)->
        (is_valid_forall_helper_exp e1 sv) && (is_valid_forall_helper_exp e2 sv)
      | Var _
      | IConst _ ->
        true
      | _ -> failwith "is_valid_forall_helper_exp: To Be Implemented"
    in
    let is_valid_forall_helper_p_formula
        (p:p_formula) (sv:spec_var):bool =
      match p with
      | BConst _
      | BVar _
      | Frm _
      | XPure _
      | LexVar _
      | RelForm _ ->
        true
      | Lt (e1,e2,loc)
      | Lte (e1,e2,loc)
      | Gt (e1,e2,loc)
      | Gte (e1,e2,loc)
      | Eq (e1,e2,loc)
      | Neq (e1,e2,loc) ->
        (is_valid_forall_helper_exp e1 sv) && (is_valid_forall_helper_exp e2 sv)
      | _ ->
        failwith "is_valid_forall_helper_p_formula: To Be Implemented"
    in
    is_valid_forall_helper_p_formula p sv
  in
  let rec is_valid_forall
      (f1:formula) (sv:spec_var) : bool =
    match f1 with
    | BForm (b,fl)->
      is_valid_forall_helper_b_formula b sv
    | And (f1,f2,_)
    | Or (f1,f2,_,_)->
      (is_valid_forall f1 sv) && (is_valid_forall f2 sv)
    | AndList lst ->
      failwith "is_valid_forall: To Be Implemented"
    | Not (not_f,fl,loc)->
      (is_valid_forall not_f sv)
    (* | Forall (sv,f1,fl,loc) -> *)
    (*       false *)
    (* | Exists _ -> *)
    (*       false *)
    | Forall (nsv,nf,fl,loc) ->
      is_valid_forall nf nsv
    | Exists (nsv,nf,fl,loc) ->
      is_valid_forall nf nsv
  in
  let is_valid_forall
      (f1:formula) (sv:spec_var) : bool =
    Debug.no_2 "is_valid_forall" !print_pure string_of_spec_var string_of_bool (fun f sv-> is_valid_forall f sv) f1 sv
  in
  match f with
  | BForm (b,fl)->
    true
  | And _
  | AndList _
  | Or _->
    failwith ("can_be_simplify:"^(!print_pure f)^" Invalid Input")
  | Not (not_f,fl,loc)->
    (x_add_1 can_be_simplify not_f) || (not (contain_array not_f))
  | Forall (sv,f1,fl,loc) ->
    (is_valid_forall f1 sv) || (not (contain_array f1))
  | Exists (sv,f1,fl,loc) ->
    (is_valid_forall f1 sv) || (not (contain_array f1))
;;

let can_be_simplify
    (f:formula):bool =
  Debug.no_1 "can_be_simplify" !print_pure string_of_bool (fun f->can_be_simplify f) f
;;

(* let array_simplify *)
(*       (f:formula) (processor:formula->formula):formula = *)
(*   split_and_process f can_be_simplify processor *)
(* ;; *)

(* -------------------------------------------------------------------------------------------- *)
(* apply index replacement to array formula using quantifiers. If fail to replace, return None. *)



let rec process_quantifier
    (f:formula) :(formula)=
  let  get_array_index_replacement (* The input can be any form *)
      (f:formula) (sv:spec_var):(exp option) =
    let rec get_array_index_replacement_helper (* only pick up forms like !(i=c) *)
        (flst:formula list) (sv:spec_var):(exp option) =
      match flst with
        | h::rest ->
             begin
               match h with
                 | Not (BForm ((Eq(e1,e2,_),_),_),_,_)
                 | BForm((Neq (e1,e2,_),_),_)->
                       begin
                         match e1,e2 with
                           | Var (sv1,_),Var (sv2,_) ->
                                 if is_same_sv sv1 sv
                                 then Some (Var (sv2,no_pos))
                                 else
                                   if is_same_sv sv2 sv
                                   then Some (Var (sv1,no_pos))
                                   else
                                     get_array_index_replacement_helper rest sv
                           | Var (sv1,_), IConst i
                           | IConst i, Var (sv1,_) ->
                                 if is_same_sv sv1 sv
                                 then Some (IConst i)
                                 else get_array_index_replacement_helper rest sv
                           | _, _ ->
                                 get_array_index_replacement_helper rest sv
                       end
                 | _ -> get_array_index_replacement_helper rest sv
             end
        | [] ->
              None
    in
    let flst = normalize_or (normalize_not f) in
    get_array_index_replacement_helper flst sv
  in
  let get_array_index_replacement
      (f:formula) (sv:spec_var):(exp option) =
    let peo = function
      | Some e -> ArithNormalizer.string_of_exp e
      | None -> "None"
    in
    Debug.no_2 "get_array_index_replacement" !print_pure string_of_spec_var peo (fun f sv -> get_array_index_replacement f sv) f sv
  in
  let replace
      ((p,ba):b_formula) (ctx:((spec_var * exp) list)):b_formula =
    let rec find_replace
        (sv:spec_var) (ctx:((spec_var * exp) list)): (exp option) =
      match ctx with
      | (nsv,ne)::rest ->
        if is_same_sv nsv sv
        then Some ne
        else find_replace sv rest
      | [] ->
        None
    in
    let rec replace_exp
        (e:exp) (ctx:((spec_var * exp) list)):exp =
      match e with
      | ArrayAt (arr,[index],loc) ->
        begin
          match index with
          | Var (sv,_)->
            begin
              match find_replace sv ctx with
              | Some rep ->
                ArrayAt (arr, [rep], loc)
              | None ->
                e
            end
          | IConst _ ->
            e
          | _ ->
            failwith ("replace_exp: Invalid index form "^(ArithNormalizer.string_of_exp e))
        end
      | ArrayAt _ ->
        failwith "replace_exp: cannot handle multi-dimensional array"
      | Add (e1,e2,loc)->
        Add (replace_exp e1 ctx,replace_exp e2 ctx,loc)
      | Subtract (e1,e2,loc)->
        Subtract (replace_exp e1 ctx,replace_exp e2 ctx,loc)
      | Mult (e1,e2,loc)->
        Mult (replace_exp e1 ctx,replace_exp e2 ctx,loc)
      | Div (e1,e2,loc)->
        Div (replace_exp e1 ctx,replace_exp e2 ctx,loc)
      | _ ->
        e
    in
    match p with
    | Lt (e1, e2, loc)->
      (Lt (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
    | Lte (e1, e2, loc)->
      (Lte (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
    | Gt (e1, e2, loc)->
      (Gt (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
    | Gte (e1, e2, loc)->
      (Gte (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
    | SubAnn (e1, e2, loc)->
      (SubAnn (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
    | Eq (e1, e2, loc)->
      (Eq (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
    | Neq (e1, e2, loc)->
      (Neq (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
    | BConst _
    | BVar _
    | Frm _
    | XPure _
    | LexVar _
    | RelForm _->
      (p,ba)
    | _ -> failwith ("replace: "^(!print_p_formula p)^" To Be Implemented")
  in
  let rec process_helper
      (f:formula) (ctx:((spec_var * exp) list)) :(formula)=
    match f with
    | BForm (b,fl)->
      BForm (replace b ctx,fl)
    | And (f1,f2,loc)->
      And (process_helper f1 ctx, process_helper f2 ctx,loc)
    | AndList lst->
      failwith ("process_helper: "^(!print_pure f)^" To Be Implemented")
    | Or (f1,f2,fl,loc)->
      Or (process_helper f1 ctx,process_helper f2 ctx,fl,loc)
    | Not (not_f,fl,loc)->
      Not (process_helper not_f ctx,fl,loc)
    | Forall (sv,f1,fl,loc)->
      let r = get_array_index_replacement f1 sv in
      begin
        match r with
        | Some re ->
          Forall (sv,process_helper f1 ((sv,re)::ctx),fl,loc)
        | None ->
          Forall (sv,f1,fl,loc)
      end
    | Exists (sv,f1,fl,loc)->
      let r = get_array_index_replacement (Not (f1,None,no_pos)) sv in
      begin
        match r with
        | Some re ->
          Exists (sv,process_helper f1 ((sv,re)::ctx),fl,loc)
        | None ->
          Exists (sv,process_helper f1 ctx,fl,loc)
      end
  in
  process_helper f []
;;

let process_quantifier
    (f:formula) : (formula) =
  let pfo = function
    | Some fo -> !print_pure fo
    | None -> "None"
  in
  Debug.no_1 "process_quantifier" !print_pure !print_pure (fun f -> process_quantifier f) f
;;


(* This is actually problematic if there is disjunction inside *)
let constantize_ex_q f=
  let  get_array_index_replacement (* The input can be any form *)
        (f:formula) (sv:spec_var):(exp option) =
    let rec get_array_index_replacement_helper (* only pick up forms like (i=c) and !(i!=c) *)
          (f:formula) (sv:spec_var):(exp option) =
      (* let () = x_binfo_pp ("get_array_index_replacement_helper: "^(!print_pure f)) no_pos in *)
      match f with
        | Not (BForm ((Neq(e1,e2,_),_),_),_,_)
        | BForm((Eq (e1,e2,_),_),_)->
              begin
                match e1,e2 with
                  | Var (sv1,_),Var (sv2,_) ->
                        if is_same_sv sv1 sv
                        then Some (Var (sv2,no_pos))
                        else
                          if is_same_sv sv2 sv
                          then Some (Var (sv1,no_pos))
                          else
                            None
                  | Var (sv1,_), IConst i
                  | IConst i, Var (sv1,_) ->
                        if is_same_sv sv1 sv
                        then Some (IConst i)
                        else None
                  | _, _ ->
                        None
              end
        | And (f1,f2,loc)
        | Or (f1,f2,_,loc)->
              begin
                match get_array_index_replacement_helper f1 sv,get_array_index_replacement_helper f2 sv with
                  | None,None -> None
                  | Some r,_
                  | _,Some r ->
                        Some r
              end
        | Not (not_f,fl,loc)->
              get_array_index_replacement_helper not_f sv
        | AndList lst ->
              failwith ("process_helper: "^(!print_pure f)^" To Be Implemented")
        | _ ->
              None
    in
    (* let () = x_binfo_pp ("flst"^((pr_list !print_pure) flst)) no_pos in *)
    get_array_index_replacement_helper f sv
  in
  let get_array_index_replacement
        (f:formula) (sv:spec_var):(exp option) =
    let peo = function
      | Some e -> ArithNormalizer.string_of_exp e
      | None -> "None"
    in
    Debug.no_2 "exists:get_array_index_replacement" !print_pure string_of_spec_var peo (fun f sv -> get_array_index_replacement f sv) f sv
  in
  let replace
        ((p,ba):b_formula) (ctx:((spec_var * exp) list)):b_formula =
    let rec find_replace
          (sv:spec_var) (ctx:((spec_var * exp) list)): (exp option) =
      match ctx with
        | (nsv,ne)::rest ->
              if is_same_sv nsv sv
            then Some ne
            else find_replace sv rest
      | [] ->
            None
    in
    let rec replace_exp
          (e:exp) (ctx:((spec_var * exp) list)):exp =
      match e with
        | ArrayAt (arr,[index],loc) ->
              begin
                match index with
                  | Var (sv,_)->
                        begin
                          match find_replace sv ctx with
                            | Some rep ->
                                  ArrayAt (arr, [rep], loc)
                            | None ->
                                  e
                        end
                  | IConst _ ->
                        e
                  | _ ->
                        failwith ("replace_exp: Invalid index form "^(ArithNormalizer.string_of_exp e))
              end
        | ArrayAt _ ->
              failwith "replace_exp: cannot handle multi-dimensional array"
        | Add (e1,e2,loc)->
              Add (replace_exp e1 ctx,replace_exp e2 ctx,loc)
        | Subtract (e1,e2,loc)->
              Subtract (replace_exp e1 ctx,replace_exp e2 ctx,loc)
        | Mult (e1,e2,loc)->
              Mult (replace_exp e1 ctx,replace_exp e2 ctx,loc)
        | Div (e1,e2,loc)->
              Div (replace_exp e1 ctx,replace_exp e2 ctx,loc)
        | _ ->
              e
    in
    match p with
      | Lt (e1, e2, loc)->
            (Lt (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
      | Lte (e1, e2, loc)->
            (Lte (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
      | Gt (e1, e2, loc)->
            (Gt (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
      | Gte (e1, e2, loc)->
            (Gte (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
      | SubAnn (e1, e2, loc)->
            (SubAnn (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
      | Eq (e1, e2, loc)->
            (Eq (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
      | Neq (e1, e2, loc)->
            (Neq (replace_exp e1 ctx, replace_exp e2 ctx, loc),ba)
      | BConst _
      | BVar _
      | Frm _
      | XPure _
      | LexVar _
      | RelForm _->
            (p,ba)
      | _ -> failwith ("replace: "^(!print_p_formula p)^" To Be Implemented")
  in
  let rec process_helper
        (f:formula) (ctx:((spec_var * exp) list)) :(formula)=
    match f with
      | BForm (b,fl)->
            BForm (replace b ctx,fl)
      | And (f1,f2,loc)->
            And (process_helper f1 ctx, process_helper f2 ctx,loc)
      | AndList lst->
            failwith ("process_helper: "^(!print_pure f)^" To Be Implemented")
      | Or (f1,f2,fl,loc)->
            Or (process_helper f1 ctx,process_helper f2 ctx,fl,loc)
      | Not (not_f,fl,loc)->
            Not (process_helper not_f ctx,fl,loc)
      | Forall (sv,f1,fl,loc)->
            Forall (sv,process_helper f1 ctx,fl,loc)
      | Exists (sv,f1,fl,loc)->
            let r = get_array_index_replacement f1 sv in
            begin
              match r with
                | Some re ->
                      Exists (sv,process_helper f1 ((sv,re)::ctx),fl,loc)
                | None ->
                      Exists (sv,process_helper f1 ctx,fl,loc)
            end
  in
  process_helper f []
;;

(* ---------------------------------------------------------------------------------------------------- *)
(* Assuming that only one point of the array is accessed *)
(* And you need to append the result just inside the conjunction. Be careful to A\/B\/C...*)
(* let instantiate_forall *)
(*       (f:formula) : formula = *)
(*   let can_be_instantiated *)
(*         (f:formula):bool = *)
(*     true *)
(*   in *)
(*   let  *)

(* ---------------------------------------------------------------------------------------------------- *)

let name_counter = ref 0;;
let rec standarize_array_formula
    (f:formula):(formula * (formula list) * (spec_var list))=
  (* the (spec_var list) type return value is not used here *)

  let mk_new_name ():spec_var =
    let _ = name_counter:= !name_counter + 1 in
    mk_typed_spec_var Int ("tarrvar"^(string_of_int (!name_counter)))
  in
  let rec mk_index_form
      (e:exp):(exp * ((exp * exp) list) * (spec_var list))=
    match e with
    | ArrayAt (sv,elst,loc) ->
      let nsv = mk_new_name () in
      let nname = Var (nsv,no_pos) in
      let (ne,eelst,svlst) = standarize_exp e in
      (nname,(nname,ne)::eelst,nsv::svlst)
    | Add (e1,e2,loc)
    | Subtract (e1,e2,loc)
    | Mult (e1,e2,loc)
    | Div (e1,e2,loc)->
      let nsv = mk_new_name () in
      let nname = Var (nsv,no_pos) in
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      let neelst =
        begin
          match e with
          | Add _ ->(nname,Add (ne1,ne2,no_pos))::(eelst1@eelst2)
          | Subtract _ ->(nname,Subtract (ne1,ne2,no_pos))::(eelst1@eelst2)
          | Mult _ -> (nname,Mult (ne1,ne2,no_pos))::(eelst1@eelst2)
          | Div _ ->(nname,Div (ne1,ne2,no_pos))::(eelst1@eelst2)
          | _ -> failwith "standarize_exp: Invalid Input"
        end
      in
      (nname,neelst, (nsv::(svlst1@svlst2)))
    | Var _
    | IConst _ ->
      (e,[],[])
    | _ -> failwith "mk_index_form: Invalid case of index"
  and standarize_exp
      (e:exp):(exp * ((exp * exp) list) * (spec_var list))=
    match e with
    | ArrayAt (sv,elst,loc) ->
      begin
        match elst with
        | [h] ->
          let (nindex,eelst,svlst) = mk_index_form h in
          (ArrayAt (sv,[nindex],loc),eelst,svlst)
        | _ -> failwith "standarize_exp: Fail to handle multi-dimension array"
      end
    | Add (e1,e2,loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Add (ne1,ne2,loc),eelst1@eelst2,svlst1@svlst2)
    | Subtract (e1,e2,loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Subtract (ne1,ne2,loc),eelst1@eelst2,svlst1@svlst2)
    | Mult (e1,e2,loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Mult (ne1,ne2,loc),eelst1@eelst2,svlst1@svlst2)
    | Div (e1,e2,loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Div (ne1,ne2,loc),eelst1@eelst2,svlst1@svlst2)
    | IConst _
    | Var _
    | Null _ ->
      (e,[],[])
    | _ -> failwith ("standarzie_exp: "^(ArithNormalizer.string_of_exp e)^" To Be Implemented")
  in
  let standarize_p_formula
      (p:p_formula):(p_formula * (p_formula list) * (spec_var list))=
    let rec mk_p_formula_from_eelst
        (eelst: ( (exp * exp) list)):(p_formula list)=
      match eelst with
      | (e1,e2)::rest ->
        (Eq (e1,e2,no_pos))::(mk_p_formula_from_eelst rest)
      | [] -> []
    in
    match p with
    | Lt (e1, e2, loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Lt (ne1,ne2,loc),mk_p_formula_from_eelst (eelst1@eelst2),svlst1@svlst2)
    | Lte (e1, e2, loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Lte (ne1,ne2,loc),mk_p_formula_from_eelst (eelst1@eelst2),svlst1@svlst2)
    | Gt (e1, e2, loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Gt (ne1,ne2,loc),mk_p_formula_from_eelst (eelst1@eelst2),svlst1@svlst2)
    | Gte (e1, e2, loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Gte (ne1,ne2,loc),mk_p_formula_from_eelst (eelst1@eelst2),svlst1@svlst2)
    | SubAnn (e1, e2, loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (SubAnn (ne1,ne2,loc),mk_p_formula_from_eelst (eelst1@eelst2),svlst1@svlst2)
    | Eq (e1, e2, loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Eq (ne1,ne2,loc),mk_p_formula_from_eelst (eelst1@eelst2),svlst1@svlst2)
    | Neq (e1, e2, loc)->
      let (ne1,eelst1,svlst1) = standarize_exp e1 in
      let (ne2,eelst2,svlst2) = standarize_exp e2 in
      (Neq (ne1,ne2,loc),mk_p_formula_from_eelst (eelst1@eelst2),svlst1@svlst2)
    | BConst _
    | BVar _
    | Frm _
    | XPure _
    | LexVar _
    | RelForm _->
      (p,[],[])
    | BagSub _
    | ListIn _
    | ListNotIn _
    | ListAllN _
    | ListPerm _
    | EqMax _
    | EqMin _
    | BagIn _
    | BagNotIn _
    | BagMin _
    | BagMax _ ->
      (*| VarPerm _ ->*)
      failwith ("standarize_p_formula 1: "^(!print_p_formula p)^" To Be Implemented")
      (* | RelForm _ -> *)
      (*       failwith ("standarize_p_formula 2: "^(!print_p_formula p)^" To Be Implemented") *)
  in
  match f with
  | BForm ((p,_),fl)->
    let (np,plst,svlst) = standarize_p_formula p in
    let flst = List.map (fun p -> BForm((p,None),None)) plst in
    (BForm ((np,None),None),flst,svlst)
  | And (f1,f2,l)->
    let (nf1,flst1,svlst1) = standarize_array_formula f1 in
    let (nf2,flst2,svlst2) = standarize_array_formula f2 in
    (And (nf1,nf2,l),flst1@flst2,svlst1@svlst2)
  | AndList lst->
    (* let (flst,flstlst) = *)
    (*   (List.split (List.map (fun (t,f) -> let (nf,nflst) = (standarize_array_formula f) in ((t,nf),nflst)) lst)) in *)
    (* let nflst = List.fold_left (fun result l -> result@l) [] flstlst in *)
    (* (AndList flst,nflst) *)
    failwith "standarize_array_formula: AndList To Be Implemented"
  | Or (f1,f2,fl,l)->
    let (nf1,flst1,svlst1) = standarize_array_formula f1 in
    let (nf2,flst2,svlst2) = standarize_array_formula f2 in
    (Or (nf1,nf2,fl,l),flst1@flst2,svlst1@svlst2)
  | Not (f,fl,l)->
    let (nf1,flst1,svlst) = standarize_array_formula f in
    (Not (nf1,fl,l),flst1,svlst)
  | Forall (sv,f,fl,l)->
    let (nf1,flst1,svlst) = standarize_array_formula f in
    (Forall (sv,nf1,fl,l),flst1,svlst)
  | Exists (sv,f,fl,l)->
    let (nf1,flst1,svlst) = standarize_array_formula f in
    (Exists (sv,nf1,fl,l),flst1,svlst)
;;

let rec standarize_one_formula
    (f:formula):formula=
  let helper
      (f:formula):formula=
    match f with
    | BForm (b,fl)->
      let (nf,flst,svlst) = standarize_array_formula f in
      let fbody = mk_and_list (nf::flst) in
      if List.length svlst = 0
      then fbody
      else
        (* let fbase = Exists (List.hd svlst,fbody,None,no_pos) in *)
        (* List.fold_left (fun nf sv -> Exists (sv,nf,None,no_pos)) fbase (List.tl svlst) *)
        fbody
    | And (f1,f2,l)->
      And (standarize_one_formula f1,standarize_one_formula f2,l)
    | AndList lst->
      AndList (List.map (fun (t,f)->(t,standarize_one_formula f)) lst)
    | Or (f1,f2,fl,l)->
      Or (standarize_one_formula f1,standarize_one_formula f2,fl,l)
    | Not (f,fl,l)->
      Not (standarize_one_formula f,fl,l)
    | Forall (sv,f,fl,l)->
      Forall (sv,standarize_one_formula f,fl,l)
    | Exists (sv,f,fl,l)->
      Exists (sv,standarize_one_formula f,fl,l)
  in
  (helper f)
;;

let standarize_one_formula
    (f:formula):formula=
  let pf = !print_pure in
  Debug.no_1 "standarize_one_formula" pf pf (fun f-> standarize_one_formula f) f
;;

(* let standarize_array_imply *)
(*       (ante:formula) (conseq:formula):(formula * formula)= *)
(*   let (n_conseq,flst,svlst) = standarize_array_formula conseq in *)
(*   let ante = mk_and_list (ante::flst) in *)
(*   let n_ante = standarize_one_formula ante in *)
(*   (n_ante,n_conseq) *)
(* ;; *)

let standarize_array_imply
    (ante:formula) (conseq:formula):(formula * formula)=
  (* let (n_ante,flst1,_) = standarize_array_formula ante in *)
  (* let (n_conseq,flst2,_) = standarize_array_formula conseq in *)
  (* let n_ante = mk_and_list (n_ante::(flst1@flst2)) in *)
  (* (n_ante,n_conseq) *)
  let n_ante = standarize_one_formula ante in
  let (n_conseq,flst2,_) = standarize_array_formula conseq in
  let n_ante = mk_and_list (n_ante::(flst2)) in
  (n_ante,n_conseq)
;;

let standarize_array_imply
    (ante:formula) (conseq:formula):(formula * formula) =
  let pf = !print_pure in
  let pr =
    function
    |(a,b) -> "("^(!print_pure a)^", "^(!print_pure b)^")"
  in
  Debug.no_2 "standarize_array_imply" pf pf pr (fun ante conseq -> standarize_array_imply ante conseq) ante conseq
;;


(* ------------------------------------------------------------------- *)
(* For update_array_1d(a,a',v,i), translate it into forall(k:k!=i-->a[k]=a'[k]. *)

let rec translate_array_relation
    (f:formula):formula=
  let translate_array_relation_in_b_formula
      ((p,ba):b_formula):formula option=
    let helper
        (p:p_formula):formula option=
      match p with
      | RelForm (SpecVar (_,id,_),elst,loc) ->
        if id="update_array_1d"
        then
          begin
            match (List.nth elst 0), (List.nth elst 1) with
            | Var (SpecVar (t0,id0,p0) as old_array_sv,_), Var (SpecVar (t1,id1,p1) as new_array_sv,_) ->
              let new_array_at = ArrayAt (SpecVar (t1,id1,p1),[List.nth elst 3],no_pos) in
              let new_eq = BForm ((Eq (new_array_at,List.nth elst 2,no_pos),None),None )in
              let new_q = mk_spec_var "i" in
              let new_ante = BForm((Neq (Var (new_q,no_pos), List.nth elst 3,no_pos),None),None) in
              let new_conseq = BForm((Eq (ArrayAt (SpecVar (t1,id1,p1),[Var (new_q,no_pos)],no_pos), ArrayAt (SpecVar (t0,id0,p0),[Var (new_q,no_pos)],no_pos),no_pos),None),None) in
              let new_forall = Forall(new_q,mk_imply new_ante new_conseq,None,no_pos) in
              Some (And (new_eq,new_forall,no_pos))
            | _ -> failwith "translate_array_relation: Not Var"
          end
        else
          None
      | _ -> None
    in
    helper p
  in
  match f with
  | BForm (b,fl)->
    begin
      match translate_array_relation_in_b_formula b with
      | Some nf -> nf
      | None -> f
    end
  | And (f1,f2,loc)->
    And (translate_array_relation f1,translate_array_relation f2,loc)
  | AndList lst->
    AndList (List.map (fun (t,f)-> (t,translate_array_relation f)) lst)
  | Or (f1,f2,fl,loc)->
    Or (translate_array_relation f1,translate_array_relation f2,fl,loc)
  | Not (f,fl,loc)->
    Not (translate_array_relation f,fl,loc)
  | Forall (sv,f,fl,loc)->
    Forall (sv,translate_array_relation f,fl,loc)
  | Exists (sv,f,fl,loc)->
    Exists (sv,translate_array_relation f,fl,loc)
;;

let translate_array_relation
    (f:formula):formula=
  let pf = !print_pure in
  Debug.no_1 "translate_array_relation" pf pf (fun f-> translate_array_relation f) f
;;

let translate_array_relation f=
  if !Globals.array_translate
  then translate_array_relation f
  else f
;;

(* ------------------------------------------------------------------- *)

(* For a=a'*)

let translate_array_equality
    (f:formula) (scheme:((spec_var * (exp list)) list)):(formula option)=
  let produce_equality
      (sv1:spec_var) (sv2:spec_var) (indexlst: (exp list)):(formula list) =
    List.map (fun index -> BForm ((Eq (mk_array_new_name sv1 index,mk_array_new_name sv2 index,no_pos),None),None) ) indexlst
  in
  let rec find_match
      (scheme:((spec_var * (exp list)) list)) (sv:spec_var) : ((exp list) option) =
    match scheme with
    | (nsv,elst)::rest ->
      if is_same_sv nsv sv
      then Some elst
      else
        find_match rest sv
    | [] -> None
  in
  let helper_b_formula
      ((p,ba):b_formula) (scheme:((spec_var * (exp list)) list)):(formula list) =
    match p with
    | Eq (Var (sv1,_), Var (sv2,_),loc) ->
      if is_same_sv sv1 sv2
      then []
      else
        begin
          match find_match scheme sv1, find_match scheme sv2 with
          | Some indexlst1, Some indexlst2 ->
            (produce_equality sv1 sv2 indexlst1)@(produce_equality sv1 sv2 indexlst2)
          | Some indexlst,_
          | _,Some indexlst ->
            produce_equality sv1 sv2 indexlst
          | _,_ -> []
        end
    | _ -> []
  in
  let rec helper
      (f:formula) (scheme:((spec_var * (exp list)) list)):formula list=
    match f with
    | BForm (b,fl)->
      helper_b_formula b scheme
    | And (f1,f2,loc)->
      (helper f1 scheme) @ (helper f2 scheme)
    | AndList lst->
      failwith "translate_array_equality: AndList To Be Implemented"
    | Or (f1,f2,fl,loc)->
      (helper f1 scheme) @ (helper f2 scheme)
    | Not (f,fl,loc)->
      helper f scheme
    | Forall (sv,f,fl,loc)->
      []
    | Exists (sv,f,fl,loc)->
      []
  in
  match helper f scheme with
  | [] -> None
  | lst -> Some (mk_and_list lst)
;;

let translate_array_equality
    (f:formula) (scheme:((spec_var * (exp list)) list)):(formula)=
  let produce_equality (* produce *)
      (sv1:spec_var) (sv2:spec_var) (indexlst: (exp list)):(formula list) =
    List.map (fun index -> BForm ((Eq (mk_array_new_name sv1 index,mk_array_new_name sv2 index,no_pos),None),None) ) indexlst
  in
  let rec find_match
      (scheme:((spec_var * (exp list)) list)) (sv:spec_var) : ((exp list) option) =
    match scheme with
    | (nsv,elst)::rest ->
      if is_same_sv nsv sv
      then Some elst
      else
        find_match rest sv
    | [] -> None
  in
  let helper_b_formula
      ((p,ba):b_formula) (scheme:((spec_var * (exp list)) list)):formula =
    match p with
    | Eq (Var (sv1,_), Var (sv2,_),loc) ->
      if is_same_sv sv1 sv2
      then BForm ((p,ba),None)
      else
        begin
          match find_match scheme sv1, find_match scheme sv2 with
          | Some indexlst1, Some indexlst2 ->
            mk_and_list ((produce_equality sv1 sv2 indexlst1)@(produce_equality sv1 sv2 indexlst2))
          | Some indexlst,_
          | _,Some indexlst ->
            mk_and_list (produce_equality sv1 sv2 indexlst)
          | _,_ -> BForm ((p,ba),None)
        end
    | _ ->
      BForm ((p,ba),None)
  in
  let rec helper
      (f:formula) (scheme:((spec_var * (exp list)) list)):formula=
    match f with
    | BForm (b,fl)->
      helper_b_formula b scheme
    | And (f1,f2,loc)->
      And ((helper f1 scheme) , (helper f2 scheme),loc)
    | AndList lst->
      failwith "translate_array_equality: AndList To Be Implemented"
    | Or (f1,f2,fl,loc)->
      f
    (*Or (helper f1 scheme,helper f2 scheme,fl,loc)*)
    (*failwith "translate_array_equality: To Be Normalized!"*)
    | Not (f,fl,loc)->
      Not (helper f scheme,fl,loc)
    | Forall _->
      f
    | Exists _->
      f
  in
  helper f scheme
;;

let translate_array_equality
    (f:formula) (scheme: ((spec_var * (exp list)) list)):(formula) =
  let string_of_translate_scheme
      (ts:((spec_var * (exp list)) list)):string=
    let string_of_item
        ((arr,indexlst):(spec_var * (exp list))):string=
      let string_of_indexlst = List.fold_left (fun s e -> s^" "^(ArithNormalizer.string_of_exp e)^" ") "" indexlst in
      "array: "^(string_of_spec_var arr)^" { "^(string_of_indexlst)^"}"
    in
    List.fold_left (fun s item -> (string_of_item item)^" "^s) "" ts
  in
  let pfo = function
    | Some f -> !print_pure f
    | None -> "None"
  in
  Debug.no_2 "translate_array_equality" !print_pure string_of_translate_scheme !print_pure (fun f scheme -> translate_array_equality f scheme) f scheme
;;

(* ------------------------------------------------------------------- *)
let translate_array_equality_to_forall
    (f:formula) :(formula)=
  let helper_b_formula
      ((p,ba):b_formula):formula =
    match p with
    | Eq ((Var (SpecVar (Array _,arr1,_) as sv1,_)), (Var (SpecVar (Array _,arr2,_) as sv2,_)),_) ->
      if is_same_sv sv1 sv2
      then BForm ((p,ba),None)
      else
        let q = SpecVar (Int,"tmp_q",Unprimed) in
        let index = Var (q,no_pos) in
        let equation = BForm((Eq (ArrayAt (sv1,[index],no_pos),ArrayAt (sv2,[index],no_pos),no_pos),None),None) in
        let forall = Forall (q,equation,None,no_pos) in
        And (forall,BForm ((p,ba),None),no_pos)
    | _ ->
      BForm ((p,ba),None)
  in
  let rec helper
      (f:formula):formula=
    match f with
    | BForm (b,fl)->
      helper_b_formula b
    | And (f1,f2,loc)->
      And ((helper f1) , (helper f2),loc)
    | AndList lst->
      failwith "translate_array_equality: AndList To Be Implemented"
    | Or (f1,f2,fl,loc)->
      Or (helper f1,helper f2,fl,loc)
    (*Or (helper f1 scheme,helper f2 scheme,fl,loc)*)
    (*failwith "translate_array_equality: To Be Normalized!"*)
    | Not (f,fl,loc)->
      Not (helper f,fl,loc)
    | Forall (sv,nf,fl,loc)->
      Forall (sv,helper nf,fl,loc)
    | Exists (sv,nf,fl,loc)->
      Exists (sv,helper nf,fl,loc)
  in
  helper f
;;

let translate_array_equality_to_forall
    (f:formula) :(formula) =
  Debug.no_1 "translate_array_equality_to_forall" !print_pure !print_pure translate_array_equality_to_forall f
;;
(* ------------------------------------------------------------------- *)

let f_hole_name = ref 0;;
let rec split_formula
    (f:formula) (cond:formula -> bool):(formula * ((formula * spec_var) list)) =
  match f with
  | BForm (b,fl)->
    if cond f
    then (f,[])
    else
      let nname = "f___hole_"^(string_of_int !f_hole_name) in
      let _ = f_hole_name :=!f_hole_name + 1 in
      let nsv = mk_spec_var nname in
      let hole = BVar (nsv,no_pos) in
      let nf = BForm ((hole,None),fl) in
      (nf,[(f,nsv)])
  | And (f1,f2,loc)->
    let (nf1,sv2p1) = split_formula f1 cond in
    let (nf2,sv2p2) = split_formula f2 cond in
    (And (nf1,nf2,loc),sv2p1@sv2p2)
  | AndList lst->
    failwith "split_formula: AndList To Be Implemented"
  | Or (f1,f2,fl,loc)->
    let (nf1,sv2p1) = split_formula f1 cond in
    let (nf2,sv2p2) = split_formula f2 cond in
    (Or (nf1,nf2,fl,loc),sv2p1@sv2p2)
  | Not (not_f,fl,loc)->
    let (nnot_f,sv2p) = split_formula not_f cond in
    (Not (nnot_f,fl,loc),sv2p)
  | Forall (sv,f1,fl,loc)->
    if cond f
    then (f,[])
    else
      let nname = "f___hole_"^(string_of_int !f_hole_name) in
      let _ = f_hole_name := !f_hole_name + 1 in
      let nsv = mk_spec_var nname in
      let hole = BVar (nsv,no_pos) in
      let nf = BForm ((hole,None),fl) in
      (nf,[(f,nsv)])
  | Exists (sv,f1,fl,loc)->
    if cond f
    then (f,[])
    else
      let nname = "f___hole_"^(string_of_int !f_hole_name) in
      let _ = f_hole_name := !f_hole_name + 1 in
      let nsv = mk_spec_var nname in
      let hole = BVar (nsv,no_pos) in
      let nf = BForm ((hole,None),fl) in
      (nf,[(f,nsv)])
      (* failwith "exists!!!!" *)
;;

let split_formula
    (f:formula) (cond:formula -> bool):(formula * ((formula * spec_var) list)) =
  let psv2f = List.fold_left (fun s (f,sv) -> (s^"("^(!print_pure f)^","^(string_of_spec_var sv)^")")) "" in
  let presult = function
    | (f,sv2f) -> "new f:"^(!print_pure f)^" sv2f:"^(psv2f sv2f)
  in
  Debug.no_1 "split_formula" !print_pure presult (fun _ -> split_formula f cond) f
;;

let rec combine_formula
    (f:formula) (sv2f:((formula * spec_var) list)):formula =
  let rec find_match
      (holesv:spec_var) (sv2f:((formula * spec_var) list)):formula option =
    match sv2f with
    | (f,sv)::rest ->
      if is_same_sv sv holesv
      then Some f
      else find_match holesv rest
    | [] -> None
  in
  let contain
      ((p,ba):b_formula) (sv2f:((formula * spec_var) list)):formula option =
    match p with
    | BVar (holesv,_) ->
      find_match holesv sv2f
    | Lt (e1, e2, loc)
    | Lte (e1, e2, loc)
    | Gt (e1, e2, loc)
    | Gte (e1, e2, loc)
    | SubAnn (e1, e2, loc)
    | Eq (e1, e2, loc)
    | Neq (e1, e2, loc)
    | BagSub (e1, e2, loc)
    | ListIn (e1, e2, loc)
    | ListNotIn (e1, e2, loc)
    | ListAllN (e1, e2, loc)
    | ListPerm (e1, e2, loc)->
      begin
        match e1,e2 with
        | Var (holesv1,_),_
        | _,Var (holesv1,_) ->
          find_match holesv1 sv2f
        | _ -> None
      end
    | _ -> None
  in
  match f with
  | BForm (b,fl)->
    begin
      match contain b sv2f with
      | Some nf-> nf
      | None -> f
    end
  | And (f1,f2,loc)->
    And (combine_formula f1 sv2f,combine_formula f2 sv2f,loc)
  | AndList lst->
    failwith "split_formula: AndList To Be Implemented"
  | Or (f1,f2,fl,loc)->
    Or (combine_formula f1 sv2f,combine_formula f2 sv2f,fl,loc)
  | Not (not_f,fl,loc)->
    Not (combine_formula not_f sv2f,fl,loc)
  | Forall (sv,f1,fl,loc)->
    f
  | Exists (sv,f1,fl,loc)->
    f
;;

let combine_formula
    (f:formula) (sv2f:((formula * spec_var) list)):formula =
  let psv2f = List.fold_left (fun s (f,sv) -> s^"("^(!print_pure f)^","^(string_of_spec_var sv)^")") "" in
  Debug.no_2 "combine_formula" !print_pure psv2f !print_pure (fun f sv2f -> combine_formula f sv2f) f sv2f
;;

let split_and_combine
    (processor:formula -> formula) (cond:formula->bool) (f:formula):formula =
  let (keep,sv2f) = split_formula f cond in
  combine_formula (processor keep) sv2f
;;

let split_and_combine
    (processor:formula -> formula) (cond:formula->bool) (f:formula):formula =
  if (* Globals.infer_const_obj # is_arr_as_var *)
    !Globals.array_translate
  then split_and_combine processor cond f
  else processor f
;;

(* let weaken_array_in_imply_LHS *)
(*       (processor:formula -> formula -> 'a) (ante:formula) (conseq:formula):'a = *)
(*   let nante = new_translate_out_array_in_one_formula *)

(* ------------------------------------------------------------------- *)
(* !!!!! let extract_scheme_for_quantifier *)
(*       (f:formula):(spec_var option) = *)
(*   if can_be_simplify f *)
(*   then None *)
(*   else *)
(*     match f with *)
(*       | Forall (sv,f1,fl,l) -> *)
(*             helper f1 sv *)
(*       | _ -> *)


(* let weaken_quantifier *)
(*       (f:formula) (scheme: ((spec_var * (exp list)) list)):(formula * (formula option)) = *)
(*   if can_be_simplify f *)
(*   then (f,None) *)
(*   else *)
(*     match f with *)
(*       | Forall (sv,f1,fl,l)-> *)
(*             let  *)



(* ------------------------------------------------------------------- *)

module Index=
struct
  type t = exp
  let compare e1 e2=
    match e1,e2 with
    | Var (sv1,_), Var (sv2,_)->
      if is_same_sv sv1 sv2
      then 0
      else 1
    | IConst (i1,_), IConst (i2,_)->
      if i1=i2
      then 0
      else 1
    | _ , _ -> 1
end
;;



module IndexSet = Set.Make(Index);;

let extract_translate_scheme
    (f:formula):((spec_var * (exp list)) list)=
  let translate_scheme = Hashtbl.create 10000 in (* sv -> IndexSet *)
  let rec helper_exp
      (e:exp) (nfsv:spec_var option)=
    match e with
    | Var _
    | IConst _
    | Null _ ->
      ()
    | Add (e1,e2,loc)
    | Subtract (e1,e2,loc)
    | Mult (e1,e2,loc)
    | Div (e1,e2,loc)->
      begin
        helper_exp e1 nfsv;
        helper_exp e2 nfsv;
      end
    | ArrayAt (sv,elst,loc)->
      begin
        match elst with
        | [index] ->
          begin
            match index, nfsv with
            | Var (indexsv,_), Some nnfsv ->
              if is_same_sv indexsv nnfsv (* Just to avoid quantified variable *)
              then ()
              else
                let indexset =
                  try
                    Hashtbl.find translate_scheme sv
                  with
                    Not_found ->
                        let () = x_binfo_pp ("Not found, now insert "^(string_of_spec_var sv)) no_pos in
                        IndexSet.empty
                in
                Hashtbl.replace translate_scheme sv (IndexSet.add index indexset)
            | _,_ ->
              let indexset =
                try
                  Hashtbl.find translate_scheme sv
                with
                  Not_found ->
                      let () = x_binfo_pp ("Not found, now insert "^(string_of_spec_var sv)) no_pos in
                      IndexSet.empty
              in
              Hashtbl.replace translate_scheme sv (IndexSet.add index indexset)
          end
        | _ -> failwith "extract_translate_scheme: Fail to deal with multi-dimensional array"
      end
    | _ ->
      failwith ("Trans_arr.extract_translate_scheme: "^(ArithNormalizer.string_of_exp e)^" To Be Implemented")
  in
  let helper_b_formula
      ((p,ba):b_formula) (nfsv:spec_var option)=
    match p with
    | Lt (e1, e2, loc)
    | Lte (e1, e2, loc)
    | Gt (e1, e2, loc)
    | Gte (e1, e2, loc)
    | SubAnn (e1, e2, loc)
    | Eq (e1, e2, loc)
    | Neq (e1, e2, loc)
    | BagSub (e1, e2, loc)
    | ListIn (e1, e2, loc)
    | ListNotIn (e1, e2, loc)
    | ListAllN (e1, e2, loc)
    | ListPerm (e1, e2, loc)->
      begin
        helper_exp e1 nfsv;
        helper_exp e2 nfsv
      end
    | RelForm (sv,elst,loc) ->
      List.iter (fun re -> helper_exp re nfsv) elst
    | BConst _
    | XPure _
    | BVar _
    | LexVar _
    | Frm _->
      ()
    | EqMax _
    | EqMin _
    | BagIn _
    | BagNotIn _
    | BagMin _
    | BagMax _ ->
      (*| VarPerm _ ->*)
      failwith ("extract_translate_scheme: "^(!print_p_formula p)^" To Be Implemented")
  in
  let rec helper (* Still working on the Hashtbl *)
      (f:formula) (nfsv:spec_var option):unit=
    match f with
    | BForm (b,fl)->
      helper_b_formula b nfsv
    | And (f1,f2,l)->
      begin
        helper f1 nfsv;
        helper f2 nfsv
      end
    | AndList lst->
      List.iter (fun (t,f) -> helper f nfsv) lst
    | Or (f1,f2,fl,l)->
      begin
        helper f1 nfsv;
        helper f2 nfsv;
      end
    | Not (f,fl,l)->
      helper f nfsv
    | Forall (sv,f,fl,l)->
      helper f (Some sv)
    | Exists (sv,f,fl,l)->
      helper f (Some sv)
  in
  (* Very Dangerous!!! *)
  let () = helper f None in (* create and fullfil the hashtbl *)
  Hashtbl.fold
    (fun arr indexset result ->
       let indexlst = IndexSet.fold (fun i ilst -> i::ilst) indexset [] in
       (arr,indexlst)::result) translate_scheme []
;;

let extract_translate_scheme
    (f:formula):((spec_var * (exp list)) list)=
  let string_of_translate_scheme
      (ts:((spec_var * (exp list)) list)):string=
    let string_of_item
        ((arr,indexlst):(spec_var * (exp list))):string=
      let string_of_indexlst = List.fold_left (fun s e -> s^" "^(ArithNormalizer.string_of_exp e)^" ") "" indexlst in
      "array: "^(string_of_spec_var arr)^" { "^(string_of_indexlst)^"}"
    in
    List.fold_left (fun s item -> (string_of_item item)^" "^s) "" ts
  in
  Debug.no_1 "extract_translate_scheme" !print_pure string_of_translate_scheme (fun f -> extract_translate_scheme f) f
;;


(* Turn all the array element in f into normal variables *)
let rec mk_array_free_formula
    (f:formula):formula=
  let rec mk_array_free_exp
      (e:exp):exp=
    match e with
    | ArrayAt (sv,[exp],loc) ->
      mk_array_new_name sv exp
    | Add (e1,e2,loc)->
      Add (mk_array_free_exp e1, mk_array_free_exp e2,loc)
    | Subtract (e1,e2,loc)->
      Subtract (mk_array_free_exp e1, mk_array_free_exp e2,loc)
    | Mult (e1,e2,loc)->
      Mult (mk_array_free_exp e1, mk_array_free_exp e2,loc)
    | Div (e1,e2,loc)->
      Div (mk_array_free_exp e1, mk_array_free_exp e2,loc)
    | IConst _
    | Var _
    | Null _->
      e
    | _ -> failwith ("mk_array_free_exp: "^(ArithNormalizer.string_of_exp e)^" To Be Implemented")
  in
  let mk_array_free_b_formula
      ((p,ba):b_formula):b_formula=
    let mk_array_free_p_formula
        (p:p_formula):p_formula=
      match p with
      | Lt (e1, e2, loc)->
        Lt (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | Lte (e1, e2, loc)->
        Lte (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | Gt (e1, e2, loc)->
        Gt (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | Gte (e1, e2, loc)->
        Gte (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | SubAnn (e1, e2, loc)->
        SubAnn (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | Eq (e1, e2, loc)->
        Eq (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | Neq (e1, e2, loc)->
        Neq (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | BagSub (e1, e2, loc)->
        BagSub (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | ListIn (e1, e2, loc)->
        ListIn (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | ListNotIn (e1, e2, loc)->
        ListNotIn (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | ListAllN (e1, e2, loc)->
        ListAllN (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | ListPerm (e1, e2, loc)->
        ListPerm (mk_array_free_exp e1, mk_array_free_exp e2, loc)
      | EqMax (e1, e2, e3, loc)->
        EqMax (mk_array_free_exp e1, mk_array_free_exp e2, mk_array_free_exp e3, loc)
      | EqMin (e1, e2, e3, loc)->
        EqMin (mk_array_free_exp e1, mk_array_free_exp e2, mk_array_free_exp e3, loc)
      | BagIn (sv,e1,loc)->
        BagIn (sv, mk_array_free_exp e1, loc)
      | BagNotIn (sv,e1,loc)->
        BagNotIn (sv, mk_array_free_exp e1, loc)
      | BConst _
      | Frm _
      | LexVar _
      | BVar _
      | XPure _ ->
        p
      | RelForm (sv,elst,loc) ->
        RelForm (sv, List.map (fun re -> mk_array_free_exp re) elst,loc)
      | BagMin _
      | BagMax _->
        (*| VarPerm _->*)
        failwith ("mk_array_free_p_formula: 2"^(!print_p_formula p)^" To Be Implemented")
    in
    (mk_array_free_p_formula p,None)
  in
  match f with
  | BForm (b,fl)->
    BForm (mk_array_free_b_formula b,fl)
  | And (f1,f2,l)->
    And (mk_array_free_formula f1, mk_array_free_formula f2,l)
  | AndList lst->
    AndList (List.map (fun (t,f) -> (t,mk_array_free_formula f)) lst)
  | Or (f1,f2,fl,l)->
    Or (mk_array_free_formula f1, mk_array_free_formula f2, fl, l)
  | Not (f,fl,l)->
    Not (mk_array_free_formula f,fl,l)
  | Forall (sv,f,fl,l)->
    Forall (sv,mk_array_free_formula f,fl,l)
  | Exists (sv,f,fl,l)->
    Exists (sv,mk_array_free_formula f,fl,l)
;;

let mk_array_free_formula
    (f:formula):formula=
  let pr = !print_pure in
  Debug.no_1 "mk_array_free_formula" pr pr (fun f-> mk_array_free_formula f) f
;;

let mk_array_free_formula_split
    (f:formula):formula=
  split_and_process f (x_add_1 can_be_simplify) mk_array_free_formula
;;


let mk_array_free_formula_split
    (f:formula):formula=
  let pr = !print_pure in
  Debug.no_1 "mk_array_free_formula_split" pr pr (fun f-> mk_array_free_formula_split f) f
;;

(* The result will be index1=index2 -> arr_index1=arr_index2 *)
let mk_aux_formula
    (index1:exp) (index2:exp) (arr:spec_var):formula=
  let ante = BForm ((Eq (index1, index2, no_pos),None),None) in
  let conseq = BForm ((Eq (mk_array_new_name arr index1, mk_array_new_name arr index2, no_pos),None),None) in
  mk_imply ante conseq
;;

let mk_aux_formula_from_one_to_many
      (new_index:exp) (old_index_lst:exp list) (arr:spec_var):formula option =
  let rec helper n olst =
    match olst with
      | h::rest ->
            (mk_aux_formula new_index h arr)::(helper new_index rest)
      | [] ->
            []
  in
  let af = helper new_index old_index_lst in
  match af with
    | [] -> None
    | _ -> Some (mk_and_list af)
;;

(* ------------------------------------------- *)
let rec get_array_element_in_f
    (f:formula) (sv:spec_var):(exp list) =
  let rec get_array_element_in_exp
      (e:exp) (sv:spec_var):(exp list) =
    match e with
    | Var _
    | IConst _
    | Null _ ->
      []
    | Add (e1,e2,loc)
    | Subtract (e1,e2,loc)
    | Mult (e1,e2,loc)
    | Div (e1,e2,loc)->
      (get_array_element_in_exp e1 sv) @ (get_array_element_in_exp e2 sv)
    | ArrayAt (nsv,elst,loc)->
      if (is_same_sv nsv sv)
      then [e]
      else []
    | _ ->
      failwith ("Trans_arr.extract_translate_scheme: "^(ArithNormalizer.string_of_exp e)^" To Be Implemented")
  in
  let get_array_element_in_b_formula
      ((p,ba):b_formula) (sv:spec_var):(exp list) =
    match p with
    | Lt (e1, e2, loc)
    | Lte (e1, e2, loc)
    | Gt (e1, e2, loc)
    | Gte (e1, e2, loc)
    | SubAnn (e1, e2, loc)
    | Eq (e1, e2, loc)
    | Neq (e1, e2, loc)
    | BagSub (e1, e2, loc)
    | ListIn (e1, e2, loc)
    | ListNotIn (e1, e2, loc)
    | ListAllN (e1, e2, loc)
    | ListPerm (e1, e2, loc)->
      (get_array_element_in_exp e1 sv) @ (get_array_element_in_exp e2 sv)
    | RelForm (nsv,elst,loc) ->
      (* let () = x_binfo_pp ("get_array_element_in_b_formula: RelForm") no_pos in *)
      List.fold_left (fun r e -> (get_array_element_in_exp e sv)@r) [] elst
    | BConst _
    | XPure _
    | BVar _
    | LexVar _
    | Frm _->
      []
    | EqMax _
    | EqMin _
    | BagIn _
    | BagNotIn _
    | BagMin _
    | BagMax _ ->
      (* | VarPerm _ -> *)
      failwith ("extract_translate_scheme: "^(!print_p_formula p)^" To Be Implemented")
  in
  match f with
  | BForm (b,fl)->
    get_array_element_in_b_formula b sv
  | And (f1,f2,l)->
    (get_array_element_in_f f1 sv)@(get_array_element_in_f f2 sv)
  | AndList lst->
    failwith ("get_array_element_in_f: AndList To Be Implemented")
  | Or (f1,f2,fl,l)->
    (get_array_element_in_f f1 sv)@(get_array_element_in_f f2 sv)
  | Not (nf,fl,l)->
    get_array_element_in_f nf sv
  | Forall (nsv,nf,fl,l)->
    get_array_element_in_f nf sv
  | Exists (nsv,nf,fl,l)->
    get_array_element_in_f nf sv
;;

let get_array_element_in_f
    (f:formula) (sv:spec_var):(exp list) =
  Debug.no_2 "get_array_element_in_f" !print_pure string_of_spec_var (pr_list ArithNormalizer.string_of_exp) (fun f sv -> get_array_element_in_f f sv) f sv
;;

let get_array_element_as_spec_var_list
    (f:formula) (sv:spec_var) :(spec_var list) =
  let elst = get_array_element_in_f f sv in
  List.map (fun e -> mk_array_new_name_wrapper_for_array e) elst
;;

let get_array_element_as_spec_var_list
    (f:formula) (sv:spec_var) :(spec_var list) =
  Debug.no_2 "get_array_element_as_spec_var_list" !print_pure string_of_spec_var (pr_list string_of_spec_var) (fun f sv -> get_array_element_as_spec_var_list f sv) f sv
;;


let collect_free_array_index f:exp list =
  let rec helper_e e notfv =
    match e with
    | ArrayAt (arr,[index],loc) ->
      begin
        match index with
        | IConst _ ->
          [index]
        | Var (sv,_) ->
          if List.exists (fun s -> is_same_sv s sv) notfv
          then []
          else [index]
        | _ ->
          failwith "extend_env: Invalid input"
      end
    | ArrayAt _ ->
      failwith "extend_env_e: Invalid array format"
    | Add (e1,e2,loc)
    | Subtract (e1,e2,loc)
    | Mult (e1,e2,loc)
    | Div (e1,e2,loc)->
      (helper_e e1 notfv)@(helper_e e2 notfv)
    | Var _
    | IConst _ ->
      []
    | _ -> failwith "is_valid_forall_helper_exp: To Be Implemented"
  in
  let helper_b (p,ba) notfv =
    match p with
    | BConst _
    | BVar _
    | Frm _
    | XPure _
    | LexVar _
    | RelForm _ ->
      []
    | Lt (e1,e2,loc)
    | Lte (e1,e2,loc)
    | Gt (e1,e2,loc)
    | Gte (e1,e2,loc)
    | Eq (e1,e2,loc)
    | Neq (e1,e2,loc) ->
      (helper_e e1 notfv)@(helper_e e2 notfv)
    | _ ->
      failwith "extend_env_b: To Be Implemented"
  in
  let rec helper f notfv =
  match f with
  | BForm (b,fl)->
    helper_b b notfv
  | And (f1,f2,_)
  | Or (f1,f2,_,_) ->
    (helper f1 notfv)@(helper f2 notfv)
  | AndList lst->
    failwith "extend_env: AndList To Be Implemented"
  | Not (sub_f,fl,loc)->
    helper sub_f notfv
  | Forall (sv,sub_f,fl,loc)
  | Exists (sv,sub_f,fl,loc)->
    helper sub_f (sv::notfv)
  in
  remove_dupl is_same_exp (helper f [])
;;

let collect_free_array_index f =
  Debug.no_1 "collect_free_array_index" !print_pure (pr_list ArithNormalizer.string_of_exp) collect_free_array_index f
;;


(* The input formula for this process must be normalized *)
let rec process_exists_array
    (f:formula):formula =
  match f with
  | BForm (b,fl)->
    f
  | And (f1,f2,l)->
    And (process_exists_array f1, process_exists_array f2,l)
  | AndList lst->
    failwith "process_exists_array: AndList To Be Implemented"
  | Or (f1,f2,fl,l)->
    Or (process_exists_array f1,process_exists_array f2,fl,l)
  | Not (f,fl,l)->
    Not (process_exists_array f,fl,l)
  | Forall (sv,nf,fl,l)->
    Forall (sv,process_exists_array nf,fl,l)
  | Exists (SpecVar (typ,id,primed) as sv,nf,fl,l)->
    let nqlst =
      begin
        match typ with
        | Array _ ->
          remove_dupl is_same_exp (get_array_element_in_f nf sv)
        | _ -> []
      end
    in
    if List.length nqlst == 0
    then
      (* let () = x_binfo_pp ("process_exists_array: Nothing changed: "^(!print_pure f)) no_pos in *)
      let new_nf = process_exists_array nf in
      Exists (sv,new_nf,fl,l)
    else
      let mk_new_name_helper
          (e:exp) : spec_var =
        match e with
        | ArrayAt (SpecVar (typ,id,primed),[e],_)->
          begin
            match typ with
            | Array (atyp,_ ) ->
              begin
                match primed with
                | Primed ->
                  SpecVar (atyp,(id)^"___"^(ArithNormalizer.string_of_exp e)^"___",primed)
                | _ ->
                  SpecVar (atyp,(id)^"___"^(ArithNormalizer.string_of_exp e)^"___",primed)
              end
            | _ -> failwith "mk_new_name_helper: Not array type"
          end
        | _ -> failwith "mk_new_name_helper: Invalid input"
      in
      (* let () = x_binfo_pp ("f:"^(!print_pure f)) no_pos in *)
      (* let () = x_binfo_pp ("nqlst: "^((pr_list ArithNormalizer.string_of_exp) nqlst)) no_pos in *)
      let new_nf = Exists (sv,process_exists_array nf,fl,l) in
      List.fold_left (fun r nq -> Exists(mk_new_name_helper nq,r,None,no_pos)) new_nf nqlst
;;

let process_exists_array
    (f:formula):formula =
  Debug.no_1 "process_exists_array" !print_pure !print_pure (fun f -> process_exists_array f) f
;;

(* ------------------------------------------- *)
let rec drop_array_formula
    (f:formula):formula=
  let rec contain_array_exp
      (e:exp):bool=
    match e with
    | ArrayAt _
      -> true
    | Tup2 ((e1,e2),loc)
    | Add (e1,e2,loc)
    | Subtract (e1,e2,loc)
    | Mult (e1,e2,loc)
    | Div (e1,e2,loc)
    | Max (e1,e2,loc)
    | Min (e1,e2,loc)
    | BagDiff (e1,e2,loc)
    | ListCons (e1,e2,loc)->
      ((contain_array_exp e1) or (contain_array_exp e2))
    | TypeCast (_,e1,loc)
    | ListHead (e1,loc)
    | ListTail (e1,loc)
    | ListLength (e1,loc)
    | ListReverse (e1,loc)->
      contain_array_exp e1
    | Null _|Var _|Level _|IConst _|FConst _|AConst _|InfConst _|Tsconst _|Bptriple _|ListAppend _|Template _
    | Func _
    | List _
    | Bag _
    | BagUnion _
    | BagIntersect _
      -> false
    | _ -> failwith "drop_array_formula: Unexpected case"
  in
  let contain_array_b_formula
      ((p,ba):b_formula):bool=
    match p with
    | Frm _
    | XPure _
    | LexVar _
    | BConst _
    | BVar _
    | BagMin _
    | BagMax _
    (* | VarPerm _ *)
    | RelForm _ ->
      false
    | BagIn (sv,e1,loc)
    | BagNotIn (sv,e1,loc)->
      contain_array_exp e1
    | Lt (e1,e2,loc)
    | Lte (e1,e2,loc)
    | Gt (e1,e2,loc)
    | Gte (e1,e2,loc)
    | SubAnn (e1,e2,loc)
    | Eq (e1,e2,loc)
    | Neq (e1,e2,loc)
    | ListIn (e1,e2,loc)
    | ListNotIn (e1,e2,loc)
    | ListAllN (e1,e2,loc)
    | ListPerm (e1,e2,loc)->
      (contain_array_exp e1) || (contain_array_exp e2)
    | EqMax (e1,e2,e3,loc)
    | EqMin (e1,e2,e3,loc)->
      (contain_array_exp e1) || (contain_array_exp e2) || (contain_array_exp e3)
    | _ -> false
  in
  match f with
  | BForm (b,fl)->
    if contain_array_b_formula b then mkTrue no_pos else f
  | And (f1,f2,loc)->
    And (drop_array_formula f1,drop_array_formula f2,loc)
  | AndList lst->
    AndList (List.map (fun (t,f)-> (t,drop_array_formula f)) lst)
  | Or (f1,f2,fl,loc)->
    Or (drop_array_formula f1,drop_array_formula f2,fl,loc)
  | Not (f,fl,loc)->
    Not (drop_array_formula f,fl,loc)
  | Forall (sv,f,fl,loc)->
    Forall (sv,drop_array_formula f,fl,loc)
  | Exists (sv,f,fl,loc)->
    Exists (sv,drop_array_formula f,fl,loc)
;;

let drop_array_formula
    (f:formula):formula =
  if (* Globals.infer_const_obj # is_arr_as_var *)
    !Globals.array_translate
  then drop_array_formula f
  else f

let drop_array_formula
    (f:formula):formula=
  let pr = !print_pure in
  Debug.no_1 "drop_array_formula" pr pr (fun fo->drop_array_formula fo) f
;;
(* --------------------------------------------------------- *)

(* let rec drop_array_quantifier *)
(*     (f:formula):formula = *)
(*   match f with *)
(*   | BForm (b,fl)-> *)
(*     f *)
(*   | And (f1,f2,loc)-> *)
(*     And(drop_array_quantifier f1,drop_array_quantifier f2,loc) *)
(*   | AndList lst-> *)
(*     failwith "drop_array_quantifier: AndList To Be Implemented" *)
(*   | Or (f1,f2,fl,loc)-> *)
(*     Or (drop_array_quantifier f1,drop_array_quantifier f2,fl,loc) *)
(*   | Not (f,fl,loc)-> *)
(*     Not (drop_array_quantifier f,fl,loc) *)
(*   | Forall (sv,f,fl,loc)-> *)
(*     if contain_array f *)
(*     then mkTrue no_pos *)
(*     else Forall (sv,drop_array_quantifier f,fl,loc) *)
(*   | Exists (sv,f,fl,loc)-> *)
(*     if contain_array f *)
(*     then mkTrue no_pos *)
(*     else Exists (sv,drop_array_quantifier f,fl,loc) *)
(* ;; *)

(* let drop_array_quantifier *)
(*     (f:formula):formula = *)
(*   Debug.no_1 "drop_array_quantifier" !print_pure !print_pure (fun f -> drop_array_quantifier f) f *)
(* ;; *)

let rec produce_aux_formula
    (translate_scheme:((spec_var * (exp list)) list)):(formula option)=
  let needed_to_produce
      (h:exp) (e:exp):bool=
    match h,e with
    | IConst _, IConst _ -> false
    | Var (sv1,_), Var (sv2,_)->
          not (is_same_sv sv1 sv2)
    | IConst _, Var _
    | Var _, IConst _->
      true
    | _,_-> failwith "needed_to_produce: Invalid input"
  in
  let rec produce_aux_formula_helper
      (translate_scheme:((spec_var * (exp list)) list)):(formula list)=
    let produce_aux_formula_one
        ((arr_name,indexlst):(spec_var * (exp list))): (formula list)=
      let rec iterator
          (lst1:exp list) (lst2:exp list) : (formula list)=
        let rec iterator_helper
            (e:exp) (l:exp list):(formula list)=
          match l with
          | h::rest ->
            if needed_to_produce h e
            then
              (mk_aux_formula e h arr_name)::(iterator_helper e rest)
            else
              iterator_helper e rest
          | [] ->
            []
        in
        match lst1, lst2 with
        | h1::rest1,h2::rest2 ->
          (iterator_helper h1 lst2)@(iterator rest1 rest2)
        | [],_
        | _,[]->
          []
      in
      iterator indexlst indexlst
    in
    match translate_scheme with
    | h::rest ->
      (produce_aux_formula_one h)@(produce_aux_formula_helper rest)
    | [] ->
      []
  in
  let aux_formula_lst = produce_aux_formula_helper translate_scheme in
  match aux_formula_lst with
  | []-> None
  | _ -> Some (mk_and_list aux_formula_lst)
;;

let produce_aux_formula
    (translate_scheme:((spec_var * (exp list)) list)):(formula option)=
  let string_of_translate_scheme
      (ts:((spec_var * (exp list)) list)):string=
    let string_of_item
        ((arr,indexlst):(spec_var * (exp list))):string=
      let string_of_indexlst = List.fold_left (fun s e -> s^" "^(ArithNormalizer.string_of_exp e)^" ") "" indexlst in
      "array: "^(string_of_spec_var arr)^" { "^(string_of_indexlst)^"}"
    in
    List.fold_left (fun s item -> (string_of_item item)^" "^s) "" ts
  in
  let pr_option =
    function
    | Some f-> (!print_pure f)
    | None-> "None"
  in
  Debug.no_1 "produce_aux_formula" string_of_translate_scheme pr_option (fun ts -> produce_aux_formula ts) translate_scheme
;;

let rec contain_array_element f arr_sv index_sv:bool =
  let rec helper_e e arr_sv index:bool =
    match e with
      | ArrayAt (arr,[index],loc) ->
            if is_same_sv arr arr_sv
            then
              begin
                match index with
                  | IConst _ ->
                        false
                  | Var (sv,_) ->
                        if is_same_sv sv index_sv
                        then true
                        else false
                  | _ ->
                        failwith "contain_array_element: Invalid index"
              end
            else
              false
      | ArrayAt _ ->
            failwith "contain_array_element: Invalid array format"
      | Add (e1,e2,loc)
      | Subtract (e1,e2,loc)
      | Mult (e1,e2,loc)
      | Div (e1,e2,loc)->
            (helper_e e1 arr_sv index)||(helper_e e2 arr_sv index)
      | Var _
      | IConst _ ->
            false
      | _ -> failwith "is_valid_forall_helper_exp: To Be Implemented"
  in
  let helper_b ((p,ba):b_formula) arr_sv index =
    match p with
      | BConst _
      | BVar _
      | Frm _
      | XPure _
      | LexVar _
      | RelForm _ ->
            false
      | Lt (e1,e2,loc)
      | Lte (e1,e2,loc)
      | Gt (e1,e2,loc)
      | Gte (e1,e2,loc)
      | Eq (e1,e2,loc)
      | Neq (e1,e2,loc) ->
            (helper_e e1 arr_sv index)||(helper_e e2 arr_sv index)
      | _ ->
            failwith "extend_env_b: To Be Implemented"
  in
  match f with
    | BForm (b,fl)->
          helper_b b arr_sv index_sv
    | And (f1,f2,_)
    | Or (f1,f2,_,_) ->
          (contain_array_element f1 arr_sv index_sv)||(contain_array_element f2 arr_sv index_sv)
    | AndList lst->
          failwith "extend_env: AndList To Be Implemented"
    | Not (sub_f,fl,loc)->
          contain_array_element sub_f arr_sv index_sv
    | Forall (sv,sub_f,fl,loc)
    | Exists (sv,sub_f,fl,loc)->
          contain_array_element sub_f arr_sv index_sv
;;

(* For a formula and an index sv, produce the auxiliary formula that contains the information between the index sv to the other indexes *)
let produce_aux_formula_from_env f index_sv env =
  let new_index = Var (index_sv,no_pos) in
  let rec helper env =
    match env with
      | (arr_sv,indexlst)::rest ->
            if contain_array_element f arr_sv index_sv
            then
              begin
                let aux_1 = mk_aux_formula_from_one_to_many new_index indexlst arr_sv in
                match aux_1 with
                  | Some a ->
                        a::(helper rest)
                  | None -> helper rest
              end
            else
              helper rest
      | [] ->
            []
  in
  let aflst = helper env in
  match aflst with
    | [] -> None
    | _ -> Some (mk_and_list aflst)
;;



(* Assuming that the quantified variable can only be index or the array itself *)
type not_free_var = (spec_var list)
;;

let string_of_sv_lst = pr_list string_of_spec_var;;

let add_v  nfv sv:not_free_var =
  (sv::nfv)
;;



let not_free nfv sv =
  List.exists (fun ele -> is_same_sv ele sv) nfv
;;

(* (arr -> {sv list}) list *)
type arr2index_env = ((spec_var * (exp list)) list)
;;

let string_of_env env:string =
  let string_of_item
        ((arr,indexlst):(spec_var * (exp list))):string=
    let string_of_indexlst = List.fold_left (fun s e -> s^" "^(ArithNormalizer.string_of_exp e)^" ") "" indexlst in
    "array: "^(string_of_spec_var arr)^" { "^(string_of_indexlst)^"}"
  in
  (pr_list string_of_item) env
;;

let produce_aux_formula_from_env f index_sv env =
  let pro = function
    | Some f -> !print_pure f
    | None -> "None"
  in
  Debug.no_3 "produce_aux_formula_from_env" !print_pure string_of_spec_var string_of_env pro produce_aux_formula_from_env f index_sv env
;;

let add_env (env:arr2index_env) (arr:spec_var) (index:exp) =
  let rec helper
        env arr index =
    match env with
      | (array,elst)::rest ->
            if is_same_sv array arr
            then
              if List.exists (fun ele -> is_same_exp ele index) elst
              then env
              else
                (array,index::elst)::rest
            else
              (array,elst)::(helper rest arr index)
      | [] ->
            [(arr,[index])]
  in
  match index with
    | IConst _
    | Var _ ->
            helper env arr index
    | _ -> failwith "add_env: Invalid format of array index"
;;

(* Collect all the free array element in f *)
let rec extend_env old_env (nfv:not_free_var) f:arr2index_env =
  let rec extend_env_e old_env nfv e =
    match e with
      | ArrayAt (arr,[index],loc) ->
            begin
              match index with
                | IConst _ ->
                      if (not_free nfv arr)
                      then
                        old_env
                      else
                        add_env old_env arr index
                | Var (sv,_) ->
                      if (not_free nfv arr) || (not_free nfv sv)
                      then
                        old_env
                      else
                        add_env old_env arr index
                | _ ->
                      failwith "extend_env: Invalid input"
            end
      | ArrayAt _ ->
            failwith "extend_env_e: Invalid array format"
      | Add (e1,e2,loc)
      | Subtract (e1,e2,loc)
      | Mult (e1,e2,loc)
      | Div (e1,e2,loc)->
            let new_env1 = extend_env_e old_env nfv e1 in
            let new_env2 = extend_env_e new_env1 nfv e2 in
            new_env2
      | Var _
      | IConst _ ->
            old_env
      | _ -> failwith "is_valid_forall_helper_exp: To Be Implemented"
  in
  let extend_env_b old_env nfv ((p,ba):b_formula) =
    match p with
      | BConst _
      | BVar _
      | Frm _
      | XPure _
      | LexVar _
      | RelForm _ ->
            old_env
      | Lt (e1,e2,loc)
      | Lte (e1,e2,loc)
      | Gt (e1,e2,loc)
      | Gte (e1,e2,loc)
      | Eq (e1,e2,loc)
      | Neq (e1,e2,loc) ->
            let new_env1 = extend_env_e old_env nfv e1 in
            let new_env2 = extend_env_e new_env1 nfv e2 in
            new_env2
      | _ ->
            failwith "extend_env_b: To Be Implemented"
  in
  match f with
    | BForm (b,fl)->
          extend_env_b old_env nfv b
    | And (f1,f2,_)
    | Or (f1,f2,_,_) ->
          let new_env1 = extend_env old_env nfv f1 in
          let new_env2 = extend_env new_env1 nfv f2 in
          new_env2
    | AndList lst->
          failwith "extend_env: AndList To Be Implemented"
    | Not (sub_f,fl,loc)->
          extend_env old_env nfv sub_f
    | Forall (sv,sub_f,fl,loc)
    | Exists (sv,sub_f,fl,loc)->
          let new_env = extend_env old_env (add_v nfv sv) sub_f in
          new_env
;;

let extend_env old_env nfv f =
  Debug.no_3 "extend_env" string_of_env (pr_list string_of_spec_var) !print_pure string_of_env extend_env old_env nfv f
;;



(* let rec expand_array_variable *)
(*     (f:formula) (svlst:spec_var list) :(spec_var list) = *)
(*   let expand f sv = *)
(*     let array_element = get_array_element_as_spec_var_list f sv in *)
(*     array_element@[sv] *)
(*     (\* match array_element with *\) *)
(*     (\* | [] -> [sv] *\) *)
(*     (\* | _ -> array_element *\) *)
(*   in *)
(*   let helper f svlst = *)
(*     match svlst with *)
(*     | h::rest -> (expand f h)@(expand_array_variable f rest) *)
(*     | [] -> [] *)
(*   in *)
(*   remove_dupl_spec_var_list (helper f svlst) *)
(* ;; *)

let rec expand_array_variable
    (f:formula) (svlst:spec_var list) :(spec_var list) =
  let expand sv replace=
    match sv with
    | SpecVar (Array _,_,_) ->
      (List.map (
        fun i ->
          match mk_array_new_name sv i with
          | Var (nsv,_) ->
            nsv
          | _ -> sv
        ) replace)@[sv]
    | _ ->
      [sv]
  in
  let rec helper svlst replace=
    match svlst with
    | h::rest -> (expand h replace)@(helper rest replace)
    | [] -> []
  in
  (* let replace = *)
  (*   let env = extend_env [] [] f in *)
  (*   let collect = List.fold_left (fun r (arr,ilst) -> ilst@r) [] env in *)
  (*   remove_dupl is_same_exp collect *)
  (* in *)
  let replace = collect_free_array_index f in
  (* let () = x_binfo_pp ("expand_array_variable: replace "^((pr_list ArithNormalizer.string_of_exp) replace)) no_pos in *)
  remove_dupl_spec_var_list (helper svlst replace)
;;

let expand_array_variable f svlst =
  Debug.no_2 "expand_array_variable" !print_pure (pr_list string_of_spec_var) (pr_list string_of_spec_var) expand_array_variable f svlst
;;

let expand_array_variable
      (f:formula) (svlst:spec_var list): (spec_var list) =
  if !Globals.array_translate
  then expand_array_variable f svlst
  else svlst
;;


let expand_relation f =
   let string_of_replace replace =
      (* let string_of_item r = *)
      (*   match r with *)
      (*   | (arr,indexlst) -> *)
      (*     "("^(string_of_spec_var arr)^","^((pr_list ArithNormalizer.string_of_exp) indexlst) *)
      (* in *)
      (pr_list ArithNormalizer.string_of_exp) replace
   in
   let find_replace index_exp replace:exp list =
     (* given the name of an array, return the list of the array elements as replacement *)
     match index_exp with
      | Var (sv,_)->
        begin
          match sv with
          | SpecVar (Array _,id,_) ->
            List.map (fun i -> (ArrayAt (sv,[i],no_pos))) replace
          | _ ->
            []
        end
      | _ -> []
   in
   let find_replace index_exp replace =
     Debug.no_2 "find_replace" ArithNormalizer.string_of_exp string_of_replace (pr_list ArithNormalizer.string_of_exp)  find_replace index_exp replace
   in
   let replace_helper explst replace =
     let () = x_tinfo_pp ("replace: "^(string_of_replace replace)) no_pos in
     List.fold_left (fun nlst exp ->nlst@((find_replace exp replace)@[exp])) [] explst
   in
   let rec helper f replace =
     let helper_b ((p,ba):b_formula) replace =
       match p with
       | RelForm (SpecVar (_,id,_) as rel_name,explst,loc) ->
         if id = "update_array_1d"
         then
           (p,ba)
         else
           let new_explst = replace_helper explst replace in
           (RelForm (rel_name,new_explst,loc),ba)
       | _ ->
        (p,ba)
     in
     match f with
     | BForm (b,fl)->
       BForm (helper_b b replace,fl)
     | And (f1,f2,loc)->
       And (helper f1 replace,helper f2 replace,loc)
     | AndList lst->
       AndList (List.map (fun (t,f)-> (t,drop_array_formula f)) lst)
     | Or (f1,f2,fl,loc)->
       Or (helper f1 replace,helper f2 replace,fl,loc)
     | Not (f,fl,loc)->
       Not (helper f replace,fl,loc)
     | Forall (sv,nf,fl,loc)->
       Forall (sv,helper nf replace,fl,loc)
     | Exists (sv,nf,fl,loc)->
       Exists (sv,helper nf replace,fl,loc)
   in
   (* let replace = *)
   (*   let env = extend_env [] [] f in *)
   (*   let transform (arr,indexlst) = *)
   (*     (arr,List.map (fun index -> ArrayAt (arr,[index],no_pos)) indexlst) *)
   (*    in *)
   (*    (List.map transform env) *)
   (* in *)
   (* This one does not work because it only takes variables from free ones *)
   (* let replace = *)
   (*   let env = extend_env [] [] f in *)
   (*   let collect = List.fold_left (fun r (arr,ilst) -> ilst@r) [] env in *)
   (*   remove_dupl is_same_exp collect *)
   (* in *)
   (* let () = x_binfo_pp ("expand_relation: replace "^((pr_list ArithNormalizer.string_of_exp) replace)) no_pos in*)
   let replace = collect_free_array_index f in
   helper f replace
;;

let expand_relation f =
  Debug.no_1 "expand_relation" !print_pure !print_pure expand_relation f
;;

let expand_relation f =
  if !Globals.array_translate
  then expand_relation f
  else f
;;

(* let expand_for_fixcalc f pre_vars post_vars = *)
(*   let replace =  *)


(* The returned formula must be forall-free *)
let instantiate_forall
      (f:formula):formula =
  let instantiate_with_one_sv
        (f:formula) sv env:formula =
    (* env : exp list *)
    let rec replace_helper_e (e:exp) (sv:spec_var) (index:exp) =
      (* replace sv with index in the expression exp *)
      match e with
        | ArrayAt (arr,[nindex],loc) ->
              ArrayAt (arr,[replace_helper_e nindex sv index],loc)
        | ArrayAt _ ->
              failwith "extend_env_e: Invalid array format"
        | Add (e1,e2,loc)->
              Add (replace_helper_e e1 sv index, replace_helper_e e2 sv index,loc)
        | Subtract (e1,e2,loc)->
              Subtract (replace_helper_e e1 sv index, replace_helper_e e2 sv index,loc)
        | Mult (e1,e2,loc)->
              Mult (replace_helper_e e1 sv index, replace_helper_e e2 sv index,loc)
        | Div (e1,e2,loc)->
              Div (replace_helper_e e1 sv index, replace_helper_e e2 sv index,loc)
        | Var (nsv,_) ->
              if is_same_sv nsv sv
              then index
              else
                e
        | IConst _
        | Null _ ->
          e
        | _ -> failwith "instantiate_forall: To Be Implemented"
    in
    let replace_helper_b ((p,ba):b_formula) (sv:spec_var) (index:exp)=
      match p with
        | BConst _
        | BVar _
        | Frm _
        | XPure _
        | LexVar _
        | RelForm _ ->
              (p,ba)
        | Lt (e1,e2,loc)->
              (Lt (replace_helper_e e1 sv index,replace_helper_e e2 sv index,loc),ba)
        | Lte (e1,e2,loc)->
              (Lte (replace_helper_e e1 sv index,replace_helper_e e2 sv index,loc),ba)
        | Gt (e1,e2,loc)->
              (Gt (replace_helper_e e1 sv index,replace_helper_e e2 sv index,loc),ba)
        | Gte (e1,e2,loc)->
              (Gte (replace_helper_e e1 sv index,replace_helper_e e2 sv index,loc),ba)
        | Eq (e1,e2,loc)->
              (Eq (replace_helper_e e1 sv index,replace_helper_e e2 sv index,loc),ba)
        | Neq (e1,e2,loc) ->
              (Neq (replace_helper_e e1 sv index,replace_helper_e e2 sv index,loc),ba)
        | _ ->
              failwith "replace_helper: To Be Implemented"
    in
    (* replace sv in the formula f with index *)
    let rec instantiate_with_one_sv_helper
          (f:formula) (sv:spec_var) (index:exp) :formula =
      match f with
        | BForm (b,fl)->
              BForm (replace_helper_b b sv index,fl)
        | And (f1,f2,loc)->
              And (instantiate_with_one_sv_helper f1 sv index,instantiate_with_one_sv_helper f2 sv index,loc)
        | AndList lst->
              failwith "instantiate_forall: AndList To Be Implemented"
        | Or (f1,f2,fl,loc)->
              Or (instantiate_with_one_sv_helper f1 sv index,instantiate_with_one_sv_helper f2 sv index,fl,loc)
        | Not (f,fl,loc)->
              Not (instantiate_with_one_sv_helper f sv index,fl,loc)
        | Forall (n_sv,sub_f,fl,loc)->
              Forall (n_sv,instantiate_with_one_sv_helper sub_f sv index,fl,loc)
        | Exists (n_sv,sub_f,fl,loc)->
              Exists(n_sv,instantiate_with_one_sv_helper sub_f sv index,fl,loc)
    in
    let contains_arr f arr=
      (* To Be Implemented *)
      true
    in
    mk_and_list (List.map (fun r -> instantiate_with_one_sv_helper f sv r) env)
  in
  let instantiate_with_one_sv f sv env =
    Debug.no_3 "instantiate_with_one_sv" !print_pure string_of_spec_var (pr_list ArithNormalizer.string_of_exp)  !print_pure instantiate_with_one_sv f sv env
  in
  let rec instantiate_forall_helper
      (f:formula) env :formula =
    match f with
    | BForm (b,fl)->
      f
    | And (f1,f2,loc)->
      And (instantiate_forall_helper f1 env,instantiate_forall_helper f2 env,loc)
    | AndList lst->
      failwith "instantiate_forall: AndList To Be Implemented"
    | Or (f1,f2,fl,loc)->
      Or (instantiate_forall_helper f1 env,instantiate_forall_helper f2 env,fl,loc)
    | Not (f,fl,loc)->
      Not (instantiate_forall_helper f env,fl,loc)
    | Forall (sv,sub_f,fl,loc)->
      let new_env = remove_dupl is_same_exp ((collect_free_array_index sub_f)@env) in
      let new_sub_f = instantiate_forall_helper sub_f new_env in
      (try
         let instantiated_sub_f = instantiate_with_one_sv new_sub_f sv env in
         instantiated_sub_f
       with _ ->
         f
      )
    | Exists (sv,sub_f,fl,loc) ->
      let new_env = remove_dupl is_same_exp ((collect_free_array_index sub_f)@env) in
      let new_sub_f = instantiate_forall_helper sub_f new_env in
      Exists (sv,new_sub_f,fl,loc)
  in
  let instantiate_forall_helper f env =
    Debug.no_2 "instantiate_forall_helper" !print_pure  (pr_list ArithNormalizer.string_of_exp)  !print_pure instantiate_forall_helper f env
  in
  let env = collect_free_array_index f in
  instantiate_forall_helper f env

;;

let instantiate_forall f=
  let pr = !print_pure in
  Debug.no_1 "instantiate_forall" pr pr instantiate_forall f
;;

let rec instantiate_exists f =
  match f with
    | BForm (b,fl)->
          f
    | And (f1,f2,loc)->
          And (instantiate_exists f1,instantiate_exists f2,loc)
    | AndList lst->
          failwith "instantiate_forall: AndList To Be Implemented"
    | Or (f1,f2,fl,loc)->
          Or (instantiate_exists f1,instantiate_exists f2,fl,loc)
    | Not (f,fl,loc)->
          Not (instantiate_exists f,fl,loc)
    | Forall (sv,sub_f,fl,loc)->
          Forall (sv,instantiate_exists sub_f,fl,loc)
    | Exists (sv,sub_f,fl,loc)->
          begin
            match sv with
              | SpecVar (Array _,_,_) ->
                    Exists (sv,instantiate_exists sub_f,fl,loc)
              | _ -> instantiate_exists sub_f
          end
;;

let instantiate_exists f=
  Debug.no_1 "instantiate_exists" !print_pure !print_pure instantiate_exists f
;;

let rec produce_aux_formula_for_exists
      (f:formula) env:formula =
  match f with
    | Exists (nsv,sub_f,fl,l) ->
          let af = produce_aux_formula_from_env sub_f nsv env in
          let new_env = extend_env env [] sub_f in
          let new_sub_f = produce_aux_formula_for_exists sub_f new_env in
          begin
            match af with
              | Some new_f ->
                    let new_sub_f = And (new_f,new_sub_f,no_pos) in
                      Exists (nsv,new_sub_f,fl,l)
              | None ->
                    Exists (nsv,new_sub_f,fl,l)
          end
    | And (f1,f2,loc) ->
          And (produce_aux_formula_for_exists f1 env,produce_aux_formula_for_exists f2 env,loc)
    | Or (f1,f2,fl,loc) ->
          Or (produce_aux_formula_for_exists f1 env,produce_aux_formula_for_exists f2 env,fl,loc)
    | AndList lst->
          failwith "produce_aux_formula_for_exists: AndList To Be Implemented"
    | Not (sub_f,fl,loc)->
          Not (produce_aux_formula_for_exists sub_f env,fl,loc)
    | Forall (sv,sub_f,fl,loc)->
          let new_env = extend_env env [] sub_f in
          let new_sub_f = produce_aux_formula_for_exists sub_f new_env in
          Forall (sv,new_sub_f,fl,loc)
    | BForm (b,fl) ->
          f
;;

let produce_aux_formula_for_exists f env =
  Debug.no_2 "produce_aux_formula_for_exists" !print_pure string_of_env !print_pure produce_aux_formula_for_exists f env
;;

let translate_array_one_formula
      (f:formula):formula =

  let f = translate_array_equality_to_forall f in
  let f = translate_array_relation f in
  let f = constantize_ex_q f in

  let global_env = extend_env [] [] f in
  let f = instantiate_forall f in
  let f = process_exists_array f in

  let f = produce_aux_formula_for_exists f global_env in
  let array_free_formula = mk_array_free_formula f in
  let aux_formula = produce_aux_formula global_env in
  let new_f =
    match aux_formula with
      | None -> array_free_formula
      | Some af -> And (array_free_formula,af,no_pos)
  in
  new_f
;;



let translate_array_one_formula f =
      Debug.no_1 "#1translate_array_one_formula" !print_pure !print_pure translate_array_one_formula f
;;

let translate_array_one_formula f=
  if !Globals.array_translate
  then translate_array_one_formula f
  else f
;;

let translate_array_one_formula_for_validity
      (f:formula):formula =

  let f = translate_array_relation f in
  let f = constantize_ex_q f in
  let f = process_exists_array f in

  let global_env = extend_env [] [] f in
  let f = instantiate_forall f in
  let f = produce_aux_formula_for_exists f global_env in
  let array_free_formula = mk_array_free_formula f in
  let aux_formula = produce_aux_formula global_env in
  let new_f =
    match aux_formula with
      | None -> array_free_formula
      | Some af -> Or (array_free_formula,Not (af,None,no_pos),None,no_pos)
  in
  new_f
;;

let translate_array_one_formula_for_validity f =
      Debug.no_1 "#1translate_array_one_formula_for_validity" !print_pure !print_pure translate_array_one_formula_for_validity f
;;

let translate_array_one_formula_for_validity f=
  if !Globals.array_translate
  then translate_array_one_formula_for_validity f
  else f
;;

let translate_array_imply ante conseq=

  let ante = translate_array_relation ante in
  let ante = constantize_ex_q ante in
  let ante = process_exists_array ante in

  let global_env = x_add extend_env [] [] conseq in
  let global_env = x_add extend_env global_env [] ante in
  let ante = instantiate_forall ante in
  let ante = produce_aux_formula_for_exists ante global_env in
  let ante = mk_array_free_formula ante in
  let aux_formula = produce_aux_formula global_env in
  let ante =
    match aux_formula with
      | None -> ante
      | Some af -> And (ante,af,no_pos)
  in
  let conseq = mk_array_free_formula conseq in
  (ante,conseq)
;;

let translate_array_imply ante conseq =
  let pr = !print_pure in
  let pr_pair = function
    | (a,b) -> "("^(pr a)^","^(pr b)^")"
  in
  Debug.no_2 "#1translate_array_imply" pr pr pr_pair (fun ante conseq -> translate_array_imply ante conseq) ante conseq
;;


(* let new_translate_out_array_in_formula *)
(*       (f:formula):formula= *)
(*   let array_free_formula = mk_array_free_formula f in *)
(*   let aux_formula = produce_aux_formula (extract_translate_scheme f) in *)
(*   match aux_formula with *)
(*     | None -> array_free_formula *)
(*     | Some af -> And (array_free_formula,af,no_pos) *)
(* ;; *)

(* let new_translate_out_array_in_formula *)
(*       (f:formula):formula= *)
(*   Debug.no_1 "new_translate_out_array_in_formula" !print_pure !print_pure (fun f -> new_translate_out_array_in_formula f) f *)
(* ;; *)


(* let new_translate_out_array_in_imply *)
(*       (ante:formula) (conseq:formula):(formula * formula) = *)
(*   let translate_scheme = (extract_translate_scheme (And (ante,conseq,no_pos))) in *)
(*   let n_ante = *)
(*     match produce_aux_formula translate_scheme with *)
(*       | Some aux_f -> And (mk_array_free_formula ante,aux_f,no_pos) *)
(*       | None -> mk_array_free_formula ante *)
(*   in *)
(*   (\*let _ = mk_array_free_formula_split ante in*\) *)
(*   let n_conseq = mk_array_free_formula conseq in *)
(*   (n_ante,n_conseq) *)
(* ;; *)

(* let new_translate_out_array_in_imply *)
(*       (ante:formula) (conseq:formula):(formula * formula) = *)
(*   let pr = !print_pure in *)
(*   let pr_pair = function *)
(*     | (a,b) -> "("^(pr a)^","^(pr b)^")" *)
(*   in *)
(*   Debug.no_2 "new_translate_out_array_in_imply" pr pr pr_pair (fun ante conseq -> new_translate_out_array_in_imply ante conseq) ante conseq *)
(* ;; *)

(* let new_translate_out_array_in_imply_full *)
(*       (ante:formula) (conseq:formula):(formula * formula) = *)
(*   let (an,con) = (process_quantifier ante,process_quantifier conseq) in *)
(*   let (s_ante,s_conseq) = standarize_array_imply an con in *)
(*   new_translate_out_array_in_imply s_ante s_conseq *)
(* ;; *)

let new_translate_out_array_in_imply_split
    (ante:formula) (conseq:formula):(formula * formula) =
  let translate_scheme = (extract_translate_scheme (And (ante,conseq,no_pos))) in
  let n_ante =
    match produce_aux_formula translate_scheme with
    | Some aux_f -> And (mk_array_free_formula_split ante,aux_f,no_pos)
    | None -> mk_array_free_formula_split ante
  in
  (* let n_ante_with_eq = *)
  (*   match translate_array_equality ante translate_scheme with *)
  (*   | None   -> n_ante *)
  (*   | Some eq -> And (eq,n_ante,no_pos) *)
  (* in *)
  let n_ante_with_eq =
    translate_array_equality n_ante translate_scheme in
  (*let _ = mk_array_free_formula_split ante in*)
  let n_conseq = mk_array_free_formula_split conseq in
  (n_ante_with_eq,n_conseq)
;;

let new_translate_out_array_in_imply_split
    (ante:formula) (conseq:formula):(formula * formula) =
  (* let old_env = extend_env [] [] conseq in *)
  (* let ante= instantiate_forall ante old_env in *)
  let (keep_ante,sv2f_ante) = split_formula ante (x_add_1 can_be_simplify) in
  let (keep_conseq,sv2f_conseq) = split_formula conseq (x_add_1 can_be_simplify) in
  let (nante,nconseq) = new_translate_out_array_in_imply_split keep_ante keep_conseq in
  (combine_formula nante sv2f_ante,combine_formula nconseq sv2f_conseq)
;;

let new_translate_out_array_in_imply_split
    (ante:formula) (conseq:formula):(formula * formula) =
  let pr = !print_pure in
  let pr_pair = function
    | (a,b) -> "("^(pr a)^","^(pr b)^")"
  in
  Debug.no_2 "new_translate_out_array_in_imply_split" pr pr pr_pair (fun ante conseq -> new_translate_out_array_in_imply_split ante conseq) ante conseq
;;

let new_translate_out_array_in_imply_split_full
    (ante:formula) (conseq:formula):(formula * formula) =
  let (an,con) = (translate_array_relation ante,translate_array_relation conseq) in
  let (an,con) = standarize_array_imply an con in
  let (an,con) = (process_quantifier an,process_quantifier con) in
  new_translate_out_array_in_imply_split an con
;;

let new_translate_out_array_in_imply_split_full
    (ante:formula) (conseq:formula):(formula * formula) =
  let pr = !print_pure in
  let pr_pair = function
    | (a,b) -> "("^(pr a)^","^(pr b)^")"
  in
  Debug.no_2 "new_translate_out_array_in_imply_split_full" pr pr pr_pair (fun ante conseq -> new_translate_out_array_in_imply_split_full ante conseq) ante conseq
;;


let new_translate_out_array_in_imply_split_full
    (ante:formula) (conseq:formula):(formula * formula) =
  if !Globals.array_translate (* Globals.infer_const_obj # is_arr_as_var *)
  then new_translate_out_array_in_imply_split_full ante conseq
  else (ante,conseq)
;;

(* let new_translate_out_array_in_imply_split_full *)
(*       (ante:formula) (conseq:formula):(formula * formula) = *)
(*   if Globals.infer_const_obj # is_arr_as_var *)
(*   then new_translate_out_array_in_imply_split_full ante conseq *)
(*   else (ante,conseq) *)
(* ;; *)

let translate_preprocess_helper
     (translate_relation:bool) (f:formula):formula =
  let f =
    if translate_relation then
      translate_array_relation f
    else
      f
  in
  let f = standarize_one_formula f in
  let f = process_quantifier f in
  let f = process_exists_array f in
  f
;;

let translate_preprocess = translate_preprocess_helper true;;

let translate_preprocess_keep_relation = translate_preprocess_helper false;;

let translate_preprocess f =
  Debug.no_1 "translate_preprocess" !print_pure !print_pure translate_preprocess f
;;

(* let new_translate_out_array_in_one_formula *)
(*     (f:formula):formula= *)
(*   let f = process_exists_array f in *)
(*   let array_free_formula = mk_array_free_formula f in *)
(*   let scheme = extract_translate_scheme f in *)
(*   let aux_formula = produce_aux_formula scheme in *)
(*   let new_f = *)
(*     match aux_formula with *)
(*     | None -> array_free_formula *)
(*     | Some af -> And (array_free_formula,af,no_pos) *)
(*   in *)
(*   translate_array_equality new_f scheme *)
(*   (\* match translate_array_equality f scheme with *\) *)
(*   (\* | None -> new_f *\) *)
(*   (\* | Some ef -> And (ef,new_f,no_pos) *\) *)
(* ;; *)



(* After pre-process *)
let new_translate_out_array_in_one_formula
    (f:formula):formula=
  let _ = instantiate_forall f in
  let array_free_formula = mk_array_free_formula f in
  let scheme = extract_translate_scheme f in
  let aux_formula = produce_aux_formula scheme in
  let new_f =
    match aux_formula with
    | None -> array_free_formula
    | Some af -> And (array_free_formula,af,no_pos)
  in
  translate_array_equality new_f scheme
;;

let new_translate_out_array_in_one_formula
    (f:formula):formula=
  Debug.no_1 "new_translate_out_array_in_one_formula" !print_pure !print_pure (fun f -> new_translate_out_array_in_one_formula f) f
;;

let new_translate_out_array_in_one_formula_full 
    (f:formula):formula=
  let f = translate_preprocess f in
  new_translate_out_array_in_one_formula f
;;

(* let new_translate_out_array_in_one_formula_full_keep_relation *)
(*     (f:formula):formula= *)
(*   let f = translate_preprocess_keep_relation f in *)
(*   new_translate_out_array_in_one_formula f *)
(* ;; *)

(* let new_translate_out_array_in_one_formula_full_keep_relation *)
(*     (f:formula):formula = *)
(*   match f with *)
(*   | Or(f1,f2,fl,loc) -> *)
(*         Or(new_translate_out_array_in_one_formula_full_keep_relation f1,new_translate_out_array_in_one_formula_full_keep_relation f2,fl,loc) *)
(*   | _ -> new_translate_out_array_in_one_formula_full_keep_relation f *)
(* ;; *)

(* let new_translate_out_array_in_one_formula_full  *)
(*     (f:formula):formula= *)
(*   let f = translate_array_relation f in *)
(*   let nf = process_quantifier f in *)
(*   (\*let _ = mk_array_free_formula_split nf in*\) *)
(*   let sf = standarize_one_formula nf in *)
(*   new_translate_out_array_in_one_formula sf *)
(* ;; *)

let new_translate_out_array_in_one_formula_full
    (f:formula):formula =
  match f with
  | Or(f1,f2,fl,loc) ->
        Or(new_translate_out_array_in_one_formula_full f1,new_translate_out_array_in_one_formula_full f2,fl,loc)
  | _ -> new_translate_out_array_in_one_formula_full f
;;

(* let new_translate_out_array_in_one_formula_split *)
(*       (f:formula):formula = *)
(*   split_and_process (process_quantifier f) can_be_simplify new_translate_out_array_in_one_formula_full *)
(* ;; *)

(* let new_translate_out_array_in_one_formula_split_keep_relation *)
(*     (f:formula):formula = *)
(*   split_and_combine new_translate_out_array_in_one_formula_full_keep_relation (x_add_1 can_be_simplify) (f) *)
(* ;; *)

let new_translate_out_array_in_one_formula_split
    (f:formula):formula =
  split_and_combine new_translate_out_array_in_one_formula_full (x_add_1 can_be_simplify) (f)
;;

(* let new_translate_out_array_in_one_formula_split *)
(*     (f:formula):formula = *)
(*   if Globals.infer_const_obj # is_arr_as_var *)
(*   then new_translate_out_array_in_one_formula_split f *)
(*   else f *)
(* ;; *)

(* let new_translate_out_array_in_one_formula_split_keep_relation *)
(*     (f:formula):formula = *)
(*   if !Globals.array_translate  (\* Globals.infer_const_obj # is_arr_as_var *\) *)
(*   then Debug.no_1 "new_translate_out_array_in_one_formula_split" !print_pure !print_pure (fun f -> new_translate_out_array_in_one_formula_split_keep_relation f) f *)
(*   else f *)
(* ;; *)

(* let new_translate_out_array_in_one_formula_split_keep_relation *)
(*     (f:formula):formula = *)
(*   if !Globals.array_translate  (\* Globals.infer_const_obj # is_arr_as_var *\) *)
(*   then Debug.no_1 "new_translate_out_array_in_one_formula_split" !print_pure !print_pure (fun f -> new_translate_out_array_in_one_formula_split_keep_relation f) f *)
(*   else f *)
(* ;; *)

let new_translate_out_array_in_one_formula_split
    (f:formula):formula =
  if !Globals.array_translate  (* Globals.infer_const_obj # is_arr_as_var *)
  then Debug.no_1 "new_translate_out_array_in_one_formula_split" !print_pure !print_pure (fun f -> new_translate_out_array_in_one_formula_split f) f
  else f
;;


(* Given a formula, replace all the occurance of a variable in the formula with another variable *)
(* index is the variable to be replaced, with new_index *)
(* let rec produce_new_index_predicate *)
(*       (fo:formula) (index:exp) (new_index:exp):formula = *)
(*   let rec helper_exp *)
(*         (e:exp) (index:exp) (new_index:exp):exp = *)
(*     match e with *)
(*       | Var (sv,loc)-> *)
(*             if is_same_var e index then new_index else e *)
(*       | IConst _ *)
(*       | ArrayAt _ -> *)
(*             e *)
(*       | Add (e1,e2,loc) -> *)
(*             Add (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*       | Subtract (e1,e2,loc)-> *)
(*             Subtract (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*       | Mult (e1,e2,loc)-> *)
(*             Mult (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*       | Div (e1,e2,loc) -> *)
(*             Div (helper_exp e1 index new_index, helper_exp e2 index new_index,loc) *)
(*       | _ -> *)
(*             failwith "Trans_arr.produce_new_index_predicate: To Be Implemented" *)
(*   in *)
(*   let helper_b_formula *)
(*         ((p,ba):b_formula) (index:exp) (new_index:exp):b_formula = *)
(*     let helper_p_formula *)
(*           (p:p_formula) (index:exp) (new_index:exp):p_formula = *)
(*       match p with *)
(*         | Lt (e1, e2, loc)-> *)
(*               Lt (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | Lte (e1, e2, loc)-> *)
(*               Lte (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | Gt (e1, e2, loc)-> *)
(*               Gt (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | Gte (e1, e2, loc)-> *)
(*               Gte (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | SubAnn (e1, e2, loc)-> *)
(*               SubAnn (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | Eq (e1, e2, loc)-> *)
(*               Eq (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | Neq (e1, e2, loc)-> *)
(*               Neq (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | BagSub (e1, e2, loc)-> *)
(*               BagSub (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | ListIn (e1, e2, loc)-> *)
(*               ListIn (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | ListNotIn (e1, e2, loc)-> *)
(*               ListNotIn (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | ListAllN (e1, e2, loc)-> *)
(*               ListAllN (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | ListPerm (e1, e2, loc)-> *)
(*               ListPerm (helper_exp e1 index new_index, helper_exp e2 index new_index, loc) *)
(*         | EqMax (e1, e2, e3, loc)-> *)
(*               EqMax (helper_exp e1 index new_index, helper_exp e2 index new_index, helper_exp e3 index new_index, loc) *)
(*         | EqMin (e1, e2, e3, loc)-> *)
(*               EqMin (helper_exp e1 index new_index, helper_exp e2 index new_index, helper_exp e3 index new_index, loc) *)
(*         | BagIn (sv,e1,loc)-> *)
(*               BagIn (sv, helper_exp e1 index new_index, loc) *)
(*         | BagNotIn (sv,e1,loc)-> *)
(*               BagNotIn (sv, helper_exp e1 index new_index, loc) *)
(*         | Frm _ *)
(*         | XPure _ *)
(*         | LexVar _ *)
(*         | BConst _ *)
(*         | BVar _ *)
(*         | BagMin _ *)
(*         | BagMax _ *)
(*         | VarPerm _ *)
(*         | RelForm _ -> *)
(*               failwith "produce_new_index_predicate: To Be Implemented" *)
(*     in *)
(*     (helper_p_formula p index new_index, None) *)
(*   in *)
(*   match fo with *)
(*     | BForm (b,fl)-> *)
(*           let n_b = helper_b_formula b index new_index in *)
(*           BForm (n_b,fl) *)
(*     | And (f1,f2,l)-> *)
(*           And (produce_new_index_predicate f1 index new_index,produce_new_index_predicate f2 index new_index,l) *)
(*     | AndList lst-> *)
(*           AndList (List.map (fun (t,f) -> (t,produce_new_index_predicate f index new_index)) lst) *)
(*     | Or (f1,f2,fl,l)-> *)
(*           Or (produce_new_index_predicate f1 index new_index,produce_new_index_predicate f2 index new_index,fl,l) *)
(*     | Not (f,fl,l)-> *)
(*           Not (produce_new_index_predicate f index new_index,fl,l) *)
(*     | Forall (sv,f,fl,l)-> *)
(*           Forall (sv,produce_new_index_predicate f index new_index,fl,l) *)
(*     | Exists (sv,f,fl,l)-> *)
(*           Exists (sv,produce_new_index_predicate f index new_index,fl,l) *)
(* ;; *)

(* let produce_new_index_predicate *)
(*       (f:formula) (index:exp) (new_index:exp):formula = *)
(*   let pf = !print_pure in *)
(*   let pe = ArithNormalizer.string_of_exp in *)
(*   Debug.no_3 "produce_new_index_predicate" pf pe pe pf (fun f i n -> produce_new_index_predicate f i n) f index new_index *)
(* ;; *)

(* let produce_new_index_predicate_wrapper *)
(*       (fo:formula option) (index:exp) (new_index:exp):formula = *)
(*   match fo with *)
(*     | Some f -> produce_new_index_predicate f index new_index *)
(*     | None -> BForm ((Eq (index,new_index,no_pos),None),None) *)
(* ;; *)

(* Given a formula, extract all the subformulas that is related to some variable *)
(* let rec extract_index_predicate *)
(*       (f:formula) (index:exp):(formula option) = *)
(*   let rec is_involved_exp *)
(*         (e:exp) (index:exp):bool = *)
(*     match e with *)
(*       | Var (sv,loc)-> *)
(*             is_same_var e index *)
(*       | Add (e1,e2,loc) *)
(*       | Subtract (e1,e2,loc) *)
(*       | Mult (e1,e2,loc) *)
(*       | Div (e1,e2,loc)-> *)
(*             (is_involved_exp e1 index)||(is_involved_exp e2 index) *)
(*       | ArrayAt _ *)
(*       | IConst _ -> *)
(*             false *)
(*       | _ -> *)
(*             failwith ("Trans_arr.extract_index_predicate: "^(ArithNormalizer.string_of_exp e)^" To Be Implemented") *)
(*   in *)
(*   let helper_b_formula *)
(*         ((p,ba):b_formula) (index:exp):(b_formula option) = *)
(*     let helper_p_formula *)
(*           (p:p_formula) (index:exp):(p_formula option) = *)
(*       match p with *)
(*         | Lt (e1, e2, loc) *)
(*         | Lte (e1, e2, loc) *)
(*         | Gt (e1, e2, loc) *)
(*         | Gte (e1, e2, loc) *)
(*         | SubAnn (e1, e2, loc) *)
(*         | Eq (e1, e2, loc) *)
(*         | Neq (e1, e2, loc) *)
(*         | BagSub (e1, e2, loc) *)
(*         | ListIn (e1, e2, loc) *)
(*         | ListNotIn (e1, e2, loc) *)
(*         | ListAllN (e1, e2, loc) *)
(*         | ListPerm (e1, e2, loc)-> *)
(*               if (is_involved_exp e1 index) || (is_involved_exp e2 index) *)
(*               then *)
(*                 Some p *)
(*               else *)
(*                 None *)
(*         | EqMax (e1, e2, e3, loc) *)
(*         | EqMin (e1, e2, e3, loc)-> *)
(*               if (is_involved_exp e1 index) || (is_involved_exp e2 index) || (is_involved_exp e3 index) *)
(*               then *)
(*                 Some p *)
(*               else *)
(*                 None *)
(*         | BagIn (sv,e1,loc) *)
(*         | BagNotIn (sv,e1,loc)-> *)
(*               if (is_involved_exp e1 index) *)
(*               then *)
(*                 Some p *)
(*               else *)
(*                 None *)
(*         | Frm _ *)
(*         | XPure _ *)
(*         | LexVar _ *)
(*         | BConst _ *)
(*         | BVar _ *)
(*         | BagMin _ *)
(*         | BagMax _ *)
(*         | VarPerm _ *)
(*         | RelForm _ -> *)
(*               failwith "extract_index_predicate: To Be Implemented" *)
(*     in *)
(*     match helper_p_formula p index with *)
(*       | Some pf -> *)
(*             Some (pf,None) *)
(*       | None -> *)
(*             None *)
(*   in *)
(*   let rec helper *)
(*         (f:formula) (index:exp): (formula option) = *)
(*     match f with *)
(*       | BForm (b,fl)-> *)
(*             begin *)
(*               match (helper_b_formula b index) with *)
(*                 | Some bp -> *)
(*                       Some (BForm (bp,fl)) *)
(*                 | None -> *)
(*                       None *)
(*             end *)
(*       | And (f1,f2,l)-> *)
(*             begin *)
(*               match helper f1 index, helper f2 index with *)
(*                 | None,None -> None *)
(*                 | Some nf,None *)
(*                 | None, Some nf -> Some nf *)
(*                 | Some nf1, Some nf2 -> Some (And (nf1,nf2,l)) *)
(*             end *)
(*       | AndList lst-> *)
(*             let flst = List.fold_left *)
(*               (fun result (t,inputf) -> *)
(*                   match helper inputf index with *)
(*                     | Some nf -> nf::result *)
(*                     | None -> result *)
(*               ) [] lst *)
(*             in *)
(*             if List.length flst = 0 *)
(*             then None *)
(*             else Some (mk_and_list flst) *)
(*       | Or (f1,f2,fl,l)-> *)
(*             begin *)
(*               match helper f1 index, helper f2 index with *)
(*                 | None, None -> None *)
(*                 | Some nf, None *)
(*                 | None, Some nf -> Some nf *)
(*                 | Some nf1, Some nf2 -> Some (Or (nf1,nf2,fl,l)) *)
(*             end *)
(*       | Not (f,fl,l)-> *)
(*             begin *)
(*               match helper f index with *)
(*                 | Some nf -> Some (Not (nf,fl,l)) *)
(*                 | None -> None *)
(*             end *)
(*       | Forall (sv,f,fl,l)-> *)
(*             begin *)
(*               match helper f index with *)
(*                 | Some nf -> Some (Forall (sv,nf,fl,l)) *)
(*                 | None -> None *)
(*             end *)
(*       | Exists (sv,f,fl,l)-> *)
(*             begin *)
(*               match helper f index with *)
(*                 | Some nf -> Some (Exists (sv,nf,fl,l)) *)
(*                 | None -> None *)
(*             end *)
(*   in *)
(*   helper f index *)
(* ;; *)

(* let extract_index_predicate *)
(*       (f:formula) (index:exp):(formula option) = *)
(*   let pf = !print_pure in *)
(*   let pfo = function *)
(*     | Some f -> pf f *)
(*     | None -> "Constant index" *)
(*   in *)
(*   Debug.no_2 "extract_index_predicate" pf ArithNormalizer.string_of_exp pfo (fun f i -> extract_index_predicate f i) f index *)
(* ;; *)

(* Get array transform information from cpure formula *)
(* Actually I don't have to translate the array out here. But due to some historical reason, the implementation is like this. *)
(* In later usage of this method, I only use the array_transform_info list. *)

(* let get_array_transform_info_lst *)
(*       (f:formula):((array_transform_info list) * formula)= *)
(*   let rec get_array_transform_info_lst_helper *)
(*         (f:formula):((array_transform_info list) * formula)= *)
(*     let mk_array_new_name *)
(*           (sv:spec_var) (e:exp):exp= *)
(*       match sv with *)
(*         | SpecVar (typ,id,primed)-> *)
(*               begin *)
(*                 match typ with *)
(*                   | Array (atyp,_)-> *)
(*                         begin *)
(*                           match primed with *)
(*                             | Primed -> *)
(*                                   (\*Var( SpecVar (atyp,(id)^"_"^"primed_"^(ArithNormalizer.string_of_exp e),primed),no_pos)*\) *)
(*                                   Var( SpecVar (atyp,(id)^"___"^(ArithNormalizer.string_of_exp e)^"___",primed),no_pos) *)
(*                             | _ -> Var( SpecVar (atyp,(id)^"___"^(ArithNormalizer.string_of_exp e)^"___",primed),no_pos) *)
(*                         end *)
(*                   | _ -> failwith "get_array_transform_info_lst: Not array type" *)
(*               end *)
(*     in *)
(*     (\* return a list of array_transform_info and an array-free expression *\) *)
(*     let rec get_array_transform_info_lst_from_exp *)
(*           (e:exp):((array_transform_info list) * exp)= *)
(*       match e with *)
(*         | ArrayAt (sv,elst,_)-> *)
(*               begin *)
(*                 match elst with *)
(*                   | [h] -> *)
(*                         let new_name = mk_array_new_name sv h in *)
(*                         let new_info = { target_array = e; new_name = new_name } in *)
(*                         ([new_info],new_name) *)
(*                   | h::rest -> failwith "get_array_transform_info_lst_from_exp: Fail to handle multi-dimensional array" *)
(*                   | [] -> failwith "get_array_transform_info_lst_from_exp: Impossible Case" *)
(*               end *)
(*         | Tup2 ((e1,e2),loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*               (info1@info2,Tup2 ((ne1,ne2),loc)) *)
(*         | Add (e1,e2,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*               (info1@info2,Add (ne1,ne2,loc)) *)
(*         | Subtract (e1,e2,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*               (info1@info2,Subtract (ne1,ne2,loc)) *)
(*         | Mult (e1,e2,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*               (info1@info2,Mult (ne1,ne2,loc)) *)
(*         | Div (e1,e2,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*               (info1@info2,Div (ne1,ne2,loc)) *)
(*         | Max (e1,e2,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*               (info1@info2,Max (ne1,ne2,loc)) *)
(*         | Min (e1,e2,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*               (info1@info2,Min (ne1,ne2,loc)) *)
(*         | BagDiff (e1,e2,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*               (info1@info2,BagDiff (ne1,ne2,loc)) *)
(*         | ListCons (e1,e2,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*               (info1@info2,ListCons (ne1,ne2,loc)) *)
(*         | TypeCast (typ,e1,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               (info1,TypeCast (typ,ne1,loc)) *)
(*         | ListHead (e1,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               (info1,ListHead (ne1,loc)) *)
(*         | ListTail (e1,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               (info1,ListTail (ne1,loc)) *)
(*         | ListLength (e1,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               (info1,ListLength (ne1,loc)) *)
(*         | ListReverse (e1,loc)-> *)
(*               let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*               (info1,ListReverse (ne1,loc)) *)
(*         | Func _ -> failwith "get_array_transform_info_lst_from_exp: Func To Be Implemented" *)
(*         | List _ -> failwith "get_array_transform_info_lst_from_exp: List To Be Implemented" *)
(*         | Bag _ -> failwith "get_array_transform_info_lst_from_exp: Bag To Be Implemented" *)
(*         | BagUnion _ -> failwith "get_array_transform_info_lst_from_exp: BagUnion To Be Implemented" *)
(*         | BagIntersect _ -> failwith "get_array_transform_info_lst_from_exp: BagIntersect To Be Implemented" *)
(*         (\*| Var (sv,_) -> let _ = print_endline ("Var: sv = "^(string_of_spec_var sv)) in ([],e)*\) *)
(*         | _ -> ([],e) *)
(*     in *)
(*     let get_array_transform_info_lst_from_b_formula *)
(*           ((p,ba):b_formula):((array_transform_info list) * b_formula)= *)
(*       let helper *)
(*             (p:p_formula):((array_transform_info list) * p_formula)= *)
(*         match p with *)
(*           | Lt (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,Lt (ne1,ne2,loc)) *)
(*           | Lte (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,Lte (ne1,ne2,loc)) *)
(*           | Gt (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,Gt (ne1,ne2,loc)) *)
(*           | Gte (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,Gte (ne1,ne2,loc)) *)
(*           | SubAnn (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,SubAnn (ne1,ne2,loc)) *)
(*           | Eq (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,Eq (ne1,ne2,loc)) *)
(*           | Neq (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,Neq (ne1,ne2,loc)) *)
(*           | BagSub (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,BagSub (ne1,ne2,loc)) *)
(*           | ListIn (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,ListIn (ne1,ne2,loc)) *)
(*           | ListNotIn (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,ListNotIn (ne1,ne2,loc)) *)
(*           | ListAllN (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,ListAllN (ne1,ne2,loc)) *)
(*           | ListPerm (e1, e2, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 (info1@info2,ListPerm (ne1,ne2,loc)) *)
(*           | EqMax (e1, e2, e3, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 let (info3,ne3) = get_array_transform_info_lst_from_exp e3 in *)
(*                 ((info1@info2)@info3,EqMax (ne1,ne2,ne3,loc)) *)
(*           | EqMin (e1, e2, e3, loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 let (info2,ne2) = get_array_transform_info_lst_from_exp e2 in *)
(*                 let (info3,ne3) = get_array_transform_info_lst_from_exp e3 in *)
(*                 ((info1@info2)@info3,EqMin (ne1,ne2,ne3,loc)) *)
(*           | BagIn (sv,e1,loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 (info1,BagIn (sv,ne1,loc)) *)
(*           | BagNotIn (sv,e1,loc)-> *)
(*                 let (info1,ne1) = get_array_transform_info_lst_from_exp e1 in *)
(*                 (info1,BagNotIn (sv,ne1,loc)) *)
(*           | Frm _ *)
(*           | XPure _ *)
(*           | LexVar _ *)
(*           | BConst _ *)
(*           | BVar _ *)
(*           | BagMin _ *)
(*           | BagMax _ *)
(*           | VarPerm _ *)
(*           | RelForm _ -> *)
(*                 ([],p) *)
(*       in *)
(*       let (info,np) = helper p in *)
(*       (info, (np,None)) *)
(*     in *)
(*     match f with *)
(*       | BForm (b,fl)-> *)
(*             let (info,nb) = get_array_transform_info_lst_from_b_formula b in *)
(*             (info,BForm (nb,fl)) *)
(*       | And (f1,f2,l)-> *)
(*             let (info1,nf1) = get_array_transform_info_lst_helper f1 in *)
(*             let (info2,nf2) = get_array_transform_info_lst_helper f2 in *)
(*             (info1@info2,And (nf1,nf2,l)) *)
(*       | AndList lst-> *)
(*             let (result_info,result_nfl) = List.fold_left (fun (infol,nfl) (t,and_fo)->let (info,nf) = get_array_transform_info_lst_helper and_fo in (infol@info,nfl@[(t,nf)])) ([],[]) lst in *)
(*             (result_info,AndList result_nfl) *)
(*       | Or (f1,f2,fl,l)-> *)
(*             let (info1,nf1) = get_array_transform_info_lst_helper f1 in *)
(*             let (info2,nf2) = get_array_transform_info_lst_helper f2 in *)
(*             (info1@info2,Or (nf1,nf2,fl,l)) *)
(*       | Not (f,fl,l)-> *)
(*             let (info1,nf1) = get_array_transform_info_lst_helper f in *)
(*             (info1,Not (nf1,fl,l)) *)
(*       | Forall (sv,f,fl,l)-> *)
(*             let (info1,nf1) = get_array_transform_info_lst_helper f in *)
(*             (info1,Forall (sv,nf1,fl,l)) *)
(*       | Exists (sv,f,fl,l)-> *)
(*             let (info1,nf1) = get_array_transform_info_lst_helper f in *)
(*             (info1,Exists (sv,nf1,fl,l)) *)
(*   in *)
(*   let rec no_duplicate_array_name *)
(*         (alst:array_transform_info list):array_transform_info list= *)
(*     let rec duplicate_array_at *)
(*           (a:array_transform_info) (alst:array_transform_info list):bool= *)
(*       match alst with *)
(*         | h::rest -> if is_same_array_at a.target_array h.target_array then true else duplicate_array_at a rest *)
(*         | [] -> false *)
(*     in *)
(*     match alst with *)
(*       | h::rest -> if duplicate_array_at h rest then no_duplicate_array_name rest else h::(no_duplicate_array_name rest) *)
(*       | [] -> [] *)
(*   in *)
(*   let (infolst,nf) = get_array_transform_info_lst_helper f in *)
(*   (no_duplicate_array_name infolst,nf) *)
(* ;; *)

let get_array_index
    (e:exp):exp=
  match e with
  | ArrayAt (_,elst,_)->
    begin
      match elst with
      |[h] -> h
      | _ -> failwith "get_array_index: Invalid index format"
    end
  | _ -> failwith "get_array_index: Invalid input"
;;

(* What is returned is a list of (A*B). A is a list of array_transform_info, indicating the mapping from an ArrayAt to a Var. B is a list of (exp*exp), indicating the relation between indexes *)
(* let constraint_generator *)
(*       (baselst:exp list) (infolst:array_transform_info list):((array_transform_info list) * ((exp * exp) list)) list= *)
(*   let rec iterate *)
(*         (baselst:exp list) (infolst:array_transform_info list) (whole_infolst:array_transform_info list) (translate_info:(exp * array_transform_info) list):((array_transform_info list) * ((exp * exp) list)) list= *)
(*     match baselst, infolst with *)
(*       | hb::restb,hi::resti -> *)
(*             if is_same_array hb hi.target_array *)
(*             then (iterate restb whole_infolst whole_infolst ((hb,hi)::translate_info)) @ (iterate baselst resti whole_infolst translate_info) *)
(*             else iterate baselst resti whole_infolst translate_info *)
(*       | [], _ -> *)
(*             let mk_result *)
(*                   ((e,info):(exp * array_transform_info)):(array_transform_info * (exp * exp))= *)
(*               let (index1,index2) = (get_array_index e,get_array_index info.target_array) in *)
(*               ({target_array = e; new_name = info.new_name},(index1,index2)) *)
(*             in *)
(*             [(List.split (List.fold_left (fun result (e,info) -> (mk_result (e,info))::result) [] translate_info))] *)
(*       | _, [] -> *)
(*             [] *)
(*   in *)
(*   iterate baselst infolst infolst [] *)
(* ;; *)

(* return a list of exp, indicating what ArrayAt is contained in a p_formula*)
(* let extract_translate_base *)
(*       (p:p_formula):(exp list)= *)
(*   let rec extract_translate_base_exp *)
(*         (e:exp):(exp list)= *)
(*     match e with *)
(*       | ArrayAt _ -> *)
(*             [e] *)
(*       | Add (e1,e2,loc) *)
(*       | Subtract (e1,e2,loc) *)
(*       | Mult (e1,e2,loc) *)
(*       | Div (e1,e2,loc) -> *)
(*             (extract_translate_base_exp e1)@(extract_translate_base_exp e2) *)
(*       | _ -> [] *)
(*   in *)
(*   let helper *)
(*         (p:p_formula):(exp list) = *)
(*     match p with *)
(*       | Frm _ *)
(*       | XPure _ *)
(*       | LexVar _ *)
(*       | BConst _ *)
(*       | BVar _ *)
(*       | BagMin _ *)
(*       | BagMax _ *)
(*       | VarPerm _ *)
(*       | RelForm _ -> *)
(*             [] *)
(*       | BagIn (sv,e1,loc) *)
(*       | BagNotIn (sv,e1,loc)-> *)
(*             extract_translate_base_exp e1 *)
(*       | Lt (e1,e2,loc) *)
(*       | Lte (e1,e2,loc) *)
(*       | Gt (e1,e2,loc) *)
(*       | Gte (e1,e2,loc) *)
(*       | SubAnn (e1,e2,loc) *)
(*       | Eq (e1,e2,loc) *)
(*       | Neq (e1,e2,loc) *)
(*       | ListIn (e1,e2,loc) *)
(*       | ListNotIn (e1,e2,loc) *)
(*       | ListAllN (e1,e2,loc) *)
(*       | ListPerm (e1,e2,loc)-> *)
(*             (extract_translate_base_exp e1)@(extract_translate_base_exp e2) *)
(*       | EqMax (e1,e2,e3,loc) *)
(*       | EqMin (e1,e2,e3,loc)-> *)
(*             (extract_translate_base_exp e1)@(extract_translate_base_exp e2)@(extract_translate_base_exp e3) *)
(*       | _ ->  [] *)
(*   in *)
(*   helper p *)
(* ;; *)

(* find_replace: find a new name for an array expression, return the new expression and the new transform information *)
(* The array expressions and the new variable expressions are mapped one to one *)
(* let find_replace *)
(*       (e:exp) (infolst:array_transform_info list):(exp * (array_transform_info list))= *)
(*   let rec helper *)
(*         (e:exp) (infolst:array_transform_info list):(exp * (array_transform_info list))= *)
(*     match infolst with *)
(*       | h::rest -> *)
(*             if is_same_array_at e h.target_array *)
(*             then (h.new_name, rest) *)
(*             else *)
(*               helper e rest *)
(*       | []-> failwith "find_replace: Fail to find a new name for array" *)
(*   in *)
(*   match e with *)
(*     | ArrayAt _ -> *)
(*           helper e infolst *)
(*     | _ -> failwith "find_replace: Invalid input" *)
(* ;; *)

(* let find_replace *)
(*       (e:exp) (infolst:array_transform_info list):(exp* (array_transform_info list))= *)
(*   let p_result = *)
(*     function *)
(*         (e,alst) -> "exp: "^(ArithNormalizer.string_of_exp e)^"\n array_transform_info list: "^(List.fold_left (fun r i -> r^(string_of_array_transform_info i)^"\n") "\n" alst) *)
(*   in *)
(*   let p_infolst = *)
(*     function *)
(*         h -> List.fold_left (fun r i -> r^(string_of_array_transform_info i)^"\n") "\n" h *)
(*   in *)
(*   let p_e = ArithNormalizer.string_of_exp in *)
(*   Debug.no_2 "find_replace" p_e p_infolst p_result (fun e i -> find_replace e i) e infolst *)
(* ;; *)
(* END of find_replace *)

(* let translate_array_formula_LHS_b_formula *)
(*       ((p,ba):b_formula) (infolst:array_transform_info list):(((exp * exp) list) * b_formula) list= *)
(*   let translate_base = extract_translate_base p in *)
(*   (\* translate_base is a list of exp, denoting all the ArrayAt in a p_formula *\) *)
(*   let translate_infolstlst = constraint_generator translate_base infolst in *)
(*   let rec mk_array_free_exp *)
(*         (e:exp) (infolst:array_transform_info list):(exp * (array_transform_info list))= *)
(*     match e with *)
(*       | ArrayAt _ -> *)
(*             find_replace e infolst *)
(*       | Add (e1,e2,loc)-> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             (Add (ne1,ne2,loc),ninfolst) *)
(*       | Subtract (e1,e2,loc)-> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             (Subtract (ne1,ne2,loc),ninfolst) *)
(*       | Mult (e1,e2,loc)-> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             (Mult (ne1,ne2,loc),ninfolst) *)
(*       | Div (e1,e2,loc)-> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             (Div (ne1,ne2,loc),ninfolst) *)
(*       | _ -> (e,infolst) *)
(*   in *)
(*   let mk_array_free_formula *)
(*         (p:p_formula) (infolst:array_transform_info list):p_formula= *)
(*     match p with *)
(*       | Frm _ *)
(*       | XPure _ *)
(*       | LexVar _ *)
(*       | BConst _ *)
(*       | BVar _ *)
(*       | BagMin _ *)
(*       | BagMax _ *)
(*       | VarPerm _ *)
(*       | RelForm _ -> *)
(*             p *)
(*       | BagIn (sv,e1,loc)-> *)
(*             let (ne,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then BagIn (sv,ne,loc) *)
(*             else failwith "mk_array_free_formula: Invalid replacement" *)
(*       | BagNotIn (sv,e1,loc)-> *)
(*             let (ne,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then BagNotIn (sv,ne,loc) *)
(*             else failwith "mk_array_free_formula: Invalid replacement" *)
(*       | Lt (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               Lt (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | Lte (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               Lte (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | Gt (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               Gt (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | Gte (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               Gte (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | SubAnn (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               SubAnn (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | Eq (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               Eq (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | Neq (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               Neq (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | ListIn (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               ListIn (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | ListNotIn (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               ListNotIn (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | ListAllN (e1,e2,loc) -> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               ListAllN (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | ListPerm (e1,e2,loc)-> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               ListPerm (ne1,ne2,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | EqMax (e1,e2,e3,loc)-> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             let (ne3,ninfolst) = mk_array_free_exp e3 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               EqMax (ne1,ne2,ne3,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | EqMin (e1,e2,e3,loc)-> *)
(*             let (ne1,ninfolst) = mk_array_free_exp e1 infolst in *)
(*             let (ne2,ninfolst) = mk_array_free_exp e2 ninfolst in *)
(*             let (ne3,ninfolst) = mk_array_free_exp e3 ninfolst in *)
(*             if (List.length ninfolst)=0 *)
(*             then *)
(*               EqMin (ne1,ne2,ne3,loc) *)
(*             else *)
(*               failwith "mk_array_free_formula: Invalid replacement" *)
(*       | _ ->  p *)
(*   in *)
(*   let rec mk_array_free_formula_lst *)
(*         (\* (p:p_formula) (infolstlst:(((array_transform_info list) * ((exp * exp) list)) list)):(((p_formula list) * b_formula) list)= *\) *)
(*         (p:p_formula) (infolstlst:(((array_transform_info list) * ((exp * exp) list)) list)):((((exp * exp) list) * b_formula) list)= *)
(*     match infolstlst with *)
(*       | (alst,eelst)::rest -> *)
(*             (\* let plst = List.map (fun (e1,e2) -> Eq (e1,e2,no_pos)) eelst in *\) *)
(*             begin *)
(*               match eelst with *)
(*                 | [] -> mk_array_free_formula_lst p rest *)
(*                 | _ -> (eelst,(mk_array_free_formula p alst,None))::(mk_array_free_formula_lst p rest) *)
(*             end *)
(*       | [] -> [] *)
(*   in *)
(*   mk_array_free_formula_lst p translate_infolstlst *)
(* ;; *)

(* let rec translate_array_formula_LHS *)
(*       (f:formula) (infolst:array_transform_info list) (f_whole:formula):formula= *)
(*   match f with *)
(*     | BForm (b,fl)-> *)
(*           let rec helper *)
(*                 (\* (lhslst:((p_formula list) * b_formula) list):formula=*\) *)
(*                 (lhslst:((((exp * exp) list) * b_formula) list)) : formula = *)
(*             match lhslst with *)
(*               | [] -> f *)
(*               | (eelst,bformula)::rest -> *)
(*                     let ante = mk_and_list (List.map (fun (i, ni) -> produce_new_index_predicate_wrapper (extract_index_predicate f_whole i) i ni) eelst) in *)
(*                     (\* let ante = mk_and_list (List.map (fun p -> BForm ((p,None),None)) plst) in *\) *)
(*                     let imply = mk_imply ante (BForm (bformula,None)) in *)
(*                     And (imply,helper rest,no_pos) *)
(*           in *)
(*           let lhslst = translate_array_formula_LHS_b_formula b infolst in *)
(*           helper lhslst *)
(*     | And (f1,f2,l)-> *)
(*           And (translate_array_formula_LHS f1 infolst f_whole,translate_array_formula_LHS f2 infolst f_whole,l) *)
(*     | AndList lst-> *)
(*           AndList (List.map (fun (t,f)->(t,translate_array_formula_LHS f infolst f_whole)) lst) *)
(*     | Or (f1,f2,fl,l)-> *)
(*           Or (translate_array_formula_LHS f1 infolst f_whole,translate_array_formula_LHS f2 infolst f_whole,fl,l) *)
(*     | Not (f,fl,l)-> *)
(*           Not (translate_array_formula_LHS f infolst f_whole,fl,l) *)
(*     | Forall (sv,f,fl,l)-> *)
(*           Forall (sv,translate_array_formula_LHS f infolst f_whole,fl,l) *)
(*     | Exists (sv,f,fl,l)-> *)
(*           Exists (sv,translate_array_formula_LHS f infolst f_whole,fl,l) *)
(* ;; *)

(* let translate_array_formula_LHS *)
(*       (f:formula) (infolst:array_transform_info list):formula= *)
(*   translate_array_formula_LHS f infolst f *)
(* ;; *)

(* translating array equation *)
let mk_array_equal_formula
    (ante:formula) (infolst:array_transform_info list):formula option=
  let array_new_name_tbl = Hashtbl.create 10000 in
  let rec create_array_new_name_tbl
      (infolst:array_transform_info list)=
    match infolst with
    | h::rest ->
      let new_name_list =
        try
          Hashtbl.find array_new_name_tbl (get_array_name h.target_array)
        with
          Not_found-> []
      in
      let _ = Hashtbl.replace array_new_name_tbl (get_array_name h.target_array) (((get_array_index h.target_array),h.new_name)::new_name_list) in
      create_array_new_name_tbl rest
    | [] -> ()
  in
  let rec match_two_name_list
      (namelst1:(exp * exp) list) (namelst2:(exp * exp) list):formula=
    let rec helper
        ((i1,n1):(exp * exp)) (namelst:(exp * exp) list):formula=
      match namelst with
      | [(i2,n2)] ->
        let index_formula = BForm ((Eq (i1,i2,no_pos),None),None) in
        let name_formula = BForm( (Eq (n1,n2,no_pos),None),None) in
        mk_imply index_formula name_formula
      | (i2,n2)::rest ->
        let index_formula = BForm ((Eq (i1,i2,no_pos),None),None) in
        let name_formula = BForm( (Eq (n1,n2,no_pos),None),None) in
        let imply = mk_imply index_formula name_formula in
        And (imply,helper (i1,n1) rest,no_pos)
      | [] -> failwith "mk_array_equal_formula: Invalid input"
    in
    match namelst1 with
    | [h] -> helper h namelst2
    | h::rest ->
      And (helper h namelst2,match_two_name_list rest namelst2,no_pos)
    | [] -> failwith "mk_array_equal_formula: Invalid input"
  in
  let rec mk_array_equal_formula_list
      (ante:formula):(formula list)=
    let mk_array_equal_formula_list_b_formula
        ((p,ba):b_formula):(formula list)=
      match p with
      | Eq (Var (sv1,_), Var (sv2,_), loc) ->
        begin
          try
            let namelst1 = Hashtbl.find array_new_name_tbl sv1 in
            let namelst2 = Hashtbl.find array_new_name_tbl sv2 in
            [(match_two_name_list namelst1 namelst2)]
          with
            Not_found -> []
        end
      | _ -> []
    in
    match ante with
    | BForm (b,fl)->
      mk_array_equal_formula_list_b_formula b
    | And (f1,f2,loc)->
      (mk_array_equal_formula_list f1)@(mk_array_equal_formula_list f2)
    | AndList lst->
      List.fold_left (fun result (_,f) -> result@(mk_array_equal_formula_list f)) [] lst
    | Or (f1,f2,fl,loc)->
      (mk_array_equal_formula_list f1)@(mk_array_equal_formula_list f2)
    | Not (f,fl,loc)->
      mk_array_equal_formula_list f
    | Forall (sv,f,fl,loc)->
      mk_array_equal_formula_list f
    | Exists (sv,f,fl,loc)->
      mk_array_equal_formula_list f
  in
  let _ = create_array_new_name_tbl infolst in
  let flst = mk_array_equal_formula_list ante in
  match flst with
  | [] -> None
  | _ -> Some (mk_and_list flst)
;;


let mk_array_equal_formula
    (ante:formula) (infolst:array_transform_info list):(formula option)=
  let pinfolst=
    function
    | l-> List.fold_left (fun r i -> r^(string_of_array_transform_info i)^"\n") "\n" l
  in
  let pf = !print_pure in
  let presult =
    function
    | Some f -> pf f
    | None -> "None"
  in
  Debug.no_2 "mk_array_equal_formula" pf pinfolst presult (fun ante infolst-> mk_array_equal_formula ante infolst) ante infolst
;;
(* END of translating array equation *)

(* let translate_out_array_in_imply *)
(*       (ante:formula) (conseq:formula) : (formula * formula) = *)
(*   let (ante,conseq) = standarize_array_imply ante conseq in *)
(*   let (info_lst,n_conseq) = get_array_transform_info_lst (And (conseq,ante,no_pos)) in *)
(*   let n_ante = translate_array_formula_LHS ante info_lst in *)
(*   let n_ante = *)
(*     match mk_array_equal_formula ante info_lst with *)
(*       | Some f -> And (f,n_ante,no_pos) *)
(*       | None -> n_ante *)
(*   in *)
(*   let (_,n_conseq) = get_array_transform_info_lst conseq in *)
(*   (n_ante,n_conseq) *)
(* ;; *)
(* (\*          *******************************         *\) *)



(* let array_new_name_tbl size= *)
(*   let tbl = Hashtbl.create size in *)
(*   let find *)
(*         (sv:specvar):exp list= *)
(*     try *)
(*       Hashtbl.find tbl sv *)
(*     with *)
(*       | Not_found->[] *)
(*   in *)
(*   let add *)
(*         (sv:specvar) (e:exp)= *)
(*     let r = find sv in *)
(*     Hashtbl.replace sv (e::r) *)
(*   in *)
(*   let dispatch *)
(*         (meth_name:string) *)



(* let translate_out_array_in_one_formula *)
(*       (f:formula):formula= *)
(*   let f = standarize_one_formula f in *)
(*   let (info_lst,_) = get_array_transform_info_lst f in *)
(*   let nf = translate_array_formula_LHS f info_lst in *)
(*   let nf = *)
(*     match mk_array_equal_formula f info_lst with *)
(*       | Some f -> And (f,nf,no_pos) *)
(*       | None -> nf *)
(*   in *)
(*   nf *)
(* ;; *)

let simplify_array_equality f=
  let is_equal_arr_full eqlst arr1 arr2 =
    List.exists (fun (p1,p2) -> (is_same_sv p1 arr1 && is_same_sv p2 arr2)||(is_same_sv p1 arr2 && is_same_sv p2 arr1)) eqlst
  in
  let rec get_eqlst f =
    let get_eqlst_b (p,ba)=
      match p with
      | Eq (Var (SpecVar (Array _,_,_) as sv1,_), Var (SpecVar (Array _,_,_) as sv2,_),_) ->
        [(sv1,sv2)]
      | _ -> []
    in
    match f with
    | BForm (b,fl)->
      get_eqlst_b b
    | And (f1,f2,_)
    | Or (f1,f2,_,_)->
      (get_eqlst f1)@(get_eqlst f2)
    | AndList lst->
      failwith "get_eqlst: AndList To Be Implemented"
    | Not (sub_f,_,_)
    | Forall (_,sub_f,_,_)
    | Exists (_,sub_f,_,_)->
      get_eqlst sub_f
  in
  let is_equal_arr =
    is_equal_arr_full (get_eqlst f)
  in
  let helper_b (p,ba) =
    match p with
    | Eq (ArrayAt (arr1,[index1],_), ArrayAt (arr2,[index2],_) ,_)->
      if is_equal_arr arr1 arr2 && is_same_exp index1 index2
      then None
      else Some (p,ba)
    | _ -> Some (p,ba)
  in
  let rec simplify_helper f:formula option =
    match f with
    | BForm (b,fl)->
      begin
        match helper_b b with
        | Some new_b -> Some (BForm (new_b,fl))
        | None -> None
      end
    | And (f1,f2,loc)->
      begin
        match simplify_helper f1, simplify_helper f2 with
        | None,None -> None
        | Some new_f1,Some new_f2 -> Some (And (new_f1,new_f2,loc))
        | None, Some new_f2 -> Some new_f2
        | Some new_f1,None -> Some new_f1
      end
    | AndList lst->
      failwith "simplify_array_equality: AndList To Be Implemented"
    | Or (f1,f2,fl,loc)->
      begin
        match simplify_helper f1, simplify_helper f2 with
        | None,None -> None
        | Some new_f1,Some new_f2 -> Some (Or (new_f1,new_f2,fl,loc))
        | None, Some new_f2 -> Some new_f2
        | Some new_f1,None -> Some new_f1
      end
    | Not (nf,fl,loc)->
      begin
        match simplify_helper nf with
        | Some new_nf -> Some (Not (new_nf,fl,loc))
        | None -> None
      end
    | Forall (sv,nf,fl,loc)->
      begin
        match simplify_helper nf with
        | Some new_nf -> Some (Forall (sv,new_nf,fl,loc))
        | None -> None
      end
    | Exists (sv,nf,fl,loc)->
      begin
        match simplify_helper nf with
        | Some new_nf -> Some (Exists (sv,new_nf,fl,loc))
        | None -> None
      end
  in
  (* equal relation is a list of pairs *)
  match simplify_helper f with
  | Some new_f -> new_f
  | None -> mkTrue no_pos
;;

let simplify_array_equality f =
  Debug.no_1 "simplify_array_equality" !print_pure !print_pure simplify_array_equality f
;;

(* translate the array back to the formula *)
let rec translate_back_array_in_one_formula
    (f:formula):formula=
  let rec translate_back_array_in_exp
      (e:exp):exp =
    match e with
    | Var (sv,_)->
      begin
        match sv with
        | SpecVar (t,i,p)->
          let arr_var_regexp = Str.regexp ".*___.*___" in
          if (Str.string_match arr_var_regexp i 0)
          then
            (*let i = String.sub i 8 ((String.length i) - 9) in*)
            let splitter = Str.regexp "___" in
            let name_list = Str.split splitter i in
            let arr_name = List.nth name_list 0 in
            let index = List.nth name_list 1 in
            let n_sv = SpecVar (Array (t,1),arr_name,p) in
            let n_exp =
              try
                let const = int_of_string index in
                IConst (const,no_pos)
              with
                Failure "int_of_string" ->
                Var (SpecVar (Int,index,Unprimed),no_pos)
            in
            ArrayAt (n_sv,[n_exp],no_pos)
          else
            e
      end
    | Add (e1,e2,loc)->
      Add (translate_back_array_in_exp e1, translate_back_array_in_exp e2, loc)
    | Subtract (e1,e2,loc)->
      Subtract (translate_back_array_in_exp e1, translate_back_array_in_exp e2, loc)
    | Mult (e1,e2,loc)->
      Mult (translate_back_array_in_exp e1, translate_back_array_in_exp e2, loc)
    | Div (e1,e2,loc)->
      Div (translate_back_array_in_exp e1, translate_back_array_in_exp e2, loc)
    | _ -> e
  in
  let translate_back_array_in_b_formula
      ((p,ba):b_formula):b_formula =
    let helper
        (p:p_formula):p_formula =
      match p with
      | Frm _
      | XPure _
      | LexVar _
      | BConst _
      | BVar _
      | BagMin _
      | BagMax _
      (* | VarPerm _ *)
      | RelForm _ ->
        p
      | BagIn (sv,e1,loc)->
        p
      | BagNotIn (sv,e1,loc)->
        p
      | Lt (e1,e2,loc) ->
        Lt (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | Lte (e1,e2,loc) ->
        Lte (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | Gt (e1,e2,loc) ->
        Gt (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | Gte (e1,e2,loc) ->
        Gte (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | SubAnn (e1,e2,loc) ->
        SubAnn (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | Eq (e1,e2,loc) ->
        Eq (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | Neq (e1,e2,loc) ->
        Neq (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | ListIn (e1,e2,loc) ->
        ListIn (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | ListNotIn (e1,e2,loc) ->
        ListNotIn (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | ListAllN (e1,e2,loc) ->
        ListAllN (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | ListPerm (e1,e2,loc)->
        ListPerm (translate_back_array_in_exp e1, translate_back_array_in_exp e2,loc)
      | EqMax (e1,e2,e3,loc)->
        EqMax (translate_back_array_in_exp e1, translate_back_array_in_exp e2, translate_back_array_in_exp e3, loc)
      | EqMin (e1,e2,e3,loc)->
        EqMin (translate_back_array_in_exp e1, translate_back_array_in_exp e2,translate_back_array_in_exp e3,loc)
      | _ -> p
    in
    (helper p,ba)
  in
  match f with
  | BForm (b,fl)->
    BForm (translate_back_array_in_b_formula b,fl)
  | And (f1,f2,loc)->
    And (translate_back_array_in_one_formula f1,translate_back_array_in_one_formula f2,loc)
  | AndList lst->
    AndList (List.map (fun (t,f)-> (t,translate_back_array_in_one_formula f)) lst)
  | Or (f1,f2,fl,loc)->
    Or (translate_back_array_in_one_formula f1,translate_back_array_in_one_formula f2,fl,loc)
  | Not (f,fl,loc)->
    Not (translate_back_array_in_one_formula f,fl,loc)
  | Forall (sv,f,fl,loc)->
    Forall (sv,translate_back_array_in_one_formula f,fl,loc)
  | Exists (sv,f,fl,loc)->
    Exists (sv,translate_back_array_in_one_formula f,fl,loc)
;;

let translate_back_array_in_one_formula f =
  let res = translate_back_array_in_one_formula f in
  let res = simplify_array_equality res in
  res
;;

let translate_back_array_in_one_formula
    (f:formula):formula =
  let pf = !print_pure in
  Debug.no_1 "translate_back_array_in_one_formula" pf pf (fun f -> translate_back_array_in_one_formula f) f
;;

let translate_back_array_in_one_formula
    (f:formula):formula =
  if (!Globals.array_translate)  (* (Globals.infer_const_obj # is_arr_as_var) *)
  then translate_back_array_in_one_formula f
  else f
;;
(* END of translating back the array to a formula *)


(* Controlled by Globals.array_translate *)
(* let translate_out_array_in_imply *)
(*       (ante:formula)(conseq:formula):(formula*formula)= *)
(*   if Globals.infer_const_obj # is_arr_as_var then translate_out_array_in_imply ante conseq *)
(*   else (ante,conseq) *)

(* let drop_array_formula *)
(*       (f:formula):formula= *)
(*   if Globals.infer_const_obj # is_arr_as_var then drop_array_formula f *)
(*   else f *)
(* ;; *)




(* let drop_array_formula *)
(*       (f:formula):formula= *)
(*   let pr = !print_pure in *)
(*   Debug.no_1 "drop_array_formula" pr pr (fun fo->drop_array_formula fo) f *)

(* let translate_out_array_in_imply *)
(*       (ante:formula)(conseq:formula):(formula*formula)= *)
(*   let p1 = !print_pure in *)
(*   let p2 (f1,f2) = "new ante: "^(p1 f1)^"\nnew conseq: "^(p1 f2) in *)
(*   Debug.no_2 "translate_out_array_in_imply" p1 p1 p2 (fun f1 f2-> translate_out_array_in_imply f1 f2) ante conseq *)



(* let translate_out_array_in_one_formula_full *)
(*       (f:formula):formula= *)
(*   let f = translate_array_relation f in *)
(*   let nf = translate_out_array_in_one_formula f in *)
(*   let dnf = drop_array_formula nf in *)
(*   dnf *)
(* ;; *)

(* let translate_out_array_in_one_formula_full *)
(*       (f:formula):formula= *)
(*   if Globals.infer_const_obj # is_arr_as_var then translate_out_array_in_one_formula_full f *)
(*   else f *)
(* ;; *)

(* let translate_out_array_in_one_formula_full *)
(*       (f:formula):formula= *)
(*   let pf = !print_pure in *)
(*   Debug.no_1 "translate_out_array_in_one_formula_full" pf pf (fun f -> translate_out_array_in_one_formula_full f) f *)
(* ;; *)


(* let tmp_pre_processing f= *)
(*   if !Globals.array_translate *)
(*   then *)
(*     instantiate_forall (translate_array_equality_to_forall (translate_array_relation f)) [] *)
(*   else *)
(*     f *)
(* ;; *)

(* let get_unchanged_set f target= *)
(*   let target_set = ref [Var (target,no_pos)] in *)
(*   let index_set = ref [] in *)
(*   let updated = ref false in *)
(*   let add_index e = *)
(*     if (List.exists (fun item -> is_same_exp e item) !index_set) *)
(*     then *)
(*       () *)
(*     else *)
(*       ( *)
(*         updated := true; *)
(*         index_set := e::(!index_set) *)
(*       ) *)
(*   in *)
(*   let add_target arr = *)
(*     if (List.exists (fun item -> is_same_exp arr item) !target_set) *)
(*     then *)
(*       () *)
(*     else *)
(*       ( *)
(*         updated := true; *)
(*         target_set := arr::(!target_set) *)
(*       ) *)
(*   in *)
(*   let is_target old_arr = *)
(*     List.exists (fun item -> is_same_exp old_arr item) !target_set *)
(*   in *)
(*   let helper_b (p,ba) env = *)
(*     match p with *)
(*     | RelForm (SpecVar (_,id,_) as rel_name,explst,loc)-> *)
(*       if id = "update_array_1d" *)
(*       then *)
(*         let old_arr = List.nth explst 0 in *)
(*         let new_arr = List.nth explst 1 in *)
(*         if is_target old_arr *)
(*         then *)
(*           let new_index = List.nth explst 3 in *)
(*           begin *)
(*             match new_index with *)
(*             | Var (new_sv,_) -> *)
(*               if List.exists (fun e -> is_same_sv new_sv e) env *)
(*               then () *)
(*               else *)
(*                 let () = add_index (new_index) in *)
(*                 if (not (is_target new_arr)) *)
(*                 then add_target new_arr *)
(*                 else () *)
(*             | _ -> () *)
(*           end *)
(*         else *)
(*           () *)
(*       else *)
(*         () *)
(*     | _ -> () *)
(*   in *)
(*   let rec helper f env= *)
(*     match f with *)
(*     | BForm (b,fl)-> *)
(*       helper_b b env *)
(*     | And (f1,f2,_) *)
(*     | Or (f1,f2,_,_)-> *)
(*       ( *)
(*         helper f1 env; *)
(*         helper f2 env *)
(*       ) *)
(*     | AndList lst-> *)
(*       failwith "get_unchanged_set: AndList To Be Implemented" *)
(*     | Not (sub_f,fl,loc)-> *)
(*       helper sub_f env *)
(*     | Forall (nsv,sub_f,fl,loc) *)
(*     | Exists (nsv,sub_f,fl,loc)-> *)
(*       helper sub_f (nsv::env) *)
(*   in *)
(*   let rec iterator env = *)
(*     let () = helper f env in *)
(*     if !updated *)
(*     then *)
(*       ( *)
(*         updated:=false; *)
(*         iterator env *)
(*       ) *)
(*     else *)
(*       () *)
(*   in *)
(*   let () = *)
(*     iterator [] *)
(*   in *)
(*   !index_set *)
(*   (\*x_binfo_pp ("unchanged set"^((pr_list ArithNormalizer.string_of_exp) !index_set)) no_pos*\) *)
(* ;; *)

(* (\* type unchanged_formula= *\) *)
(* (\*   | Unchanged *\) *)
(* (\*   | Pure_F of  Cpure.formula *\) *)
(* (\* (\\* ;; *\\) *\) *)
(* (\* let calculate_unchanged_fixpoint f = *\) *)
(* (\*   let calculate_helper_b (p,ba) = *\) *)
(* (\*     match p with *\) *)
(* (\*     | RelForm (SpecVar (_,id,_),explst,loc) -> *\) *)
(* (\*       find_result id *\) *)
(* (\*     | _ -> None *\) *)
(* (\*   in *\) *)
(* (\*   let calculate_helper f = *\) *)
(* (\*     (\\* Expand the formula *\\) *\) *)
(* (\*     match f with *\) *)
(* (\*     | BForm (b,fl)-> *\) *)
(* (\*       begin *\) *)
(* (\*         match calculate_helper_b b with *\) *)
(* (\*         | Some new_f -> new_f *\) *)
(* (\*         | None -> f *\) *)
(* (\*       end *\) *)
(* (\*     | And (f1,f2,loc)-> *\) *)
(* (\*       And (calculate_helper f1,calculate_helper f2,loc) *\) *)
(* (\*     | AndList lst-> *\) *)
(* (\*       failwith "instantiate_forall: AndList To Be Implemented" *\) *)
(* (\*     | Or (f1,f2,fl,loc)-> *\) *)
(* (\*       Or (calculate_helper f1,calculate_helper f2,fl,loc) *\) *)
(* (\*     | Not (f,fl,loc)-> *\) *)
(* (\*       Not (calculate_helper f,fl,loc) *\) *)
(* (\*     | Forall (sv,sub_f,fl,loc)-> *\) *)
(* (\*       Forall (sv,calculate_helper sub_f,fl,loc) *\) *)
(* (\*     | Exists (sv,sub_f,fl,loc)-> *\) *)
(* (\*       Exists (sv,calculate_helper sub_f,fl,loc) *\) *)
(* (\*   in *\) *)
(* (\*   let iterator *\) *)
(* (\* ;; *\) *)

(* let add_unchanged_var f = *)
(*   let helper_b (p,ba) = *)
(*     match p with *)
(*     | RelForm (SpecVar (_,id,_) as relname,elst,loc) -> *)
(*       if id="update_array_1d" *)
(*       then *)
(*         (p,ba) *)
(*       else *)
(*         let ind =  Var ((SpecVar (Int,"unchanged_ind",Unprimed)),no_pos) in *)
(*         (RelForm (relname,elst@[ind],loc),ba) *)
(*     | _ -> *)
(*       (p,ba) *)
(*   in *)
(*   let rec helper f= *)
(*     match f with *)
(*     | BForm (b,fl)-> *)
(*       BForm (helper_b b,fl) *)
(*     | And (f1,f2,loc)-> *)
(*       And (helper f1,helper f2,loc) *)
(*     | AndList lst-> *)
(*       failwith "instantiate_forall: AndList To Be Implemented" *)
(*     | Or (f1,f2,fl,loc)-> *)
(*       Or (helper f1,helper f2,fl,loc) *)
(*     | Not (f,fl,loc)-> *)
(*       Not (helper f,fl,loc) *)
(*     | Forall (n_sv,sub_f,fl,loc)-> *)
(*       Forall (n_sv,helper sub_f,fl,loc) *)
(*     | Exists (n_sv,sub_f,fl,loc)-> *)
(*       Exists(n_sv,helper sub_f,fl,loc) *)
(*   in *)
(*   helper f *)
(* ;; *)

(* let add_unchanged_info f target = *)
(*   (\* The input formula must not have disjunction *\) *)
(*   let add_helper f = *)
(*     let index_set = get_unchanged_set f target in *)
(*     if List.length index_set>0 *)
(*     then *)
(*       let ind = Var ((SpecVar (Int,"unchanged_ind",Unprimed)),no_pos) in *)
(*       let new_f = *)
(*         if List.length index_set > 1 *)
(*         then *)
(*           List.fold_left (fun r e -> Or (r,BForm ((Eq (ind,e,no_pos),None),None),None,no_pos)) (BForm ((Eq (ind,(List.hd index_set),no_pos),None),None)) (List.tl index_set) *)
(*         else *)
(*           (BForm ((Eq (ind,(List.hd index_set),no_pos),None),None)) *)
(*       in *)
(*       And (f,new_f,no_pos) *)
(*     else *)
(*       f *)
(*   in *)
(*   let helper_b (p,ba) env = *)
(*     match p with *)
(*     | RelForm (SpecVar (_,id,_),_,_) -> *)
(*       if id = "update_array_1d" *)
(*       then *)
(*         Some (get_ind_f env) (\* ????? *\) *)
(*       else *)
(*         None *)
(*     | _ -> None *)
(*   in *)
(*   let rec helper f = *)
(*     match f with *)
(*     | BForm (b,fl)-> *)
(*       BForm (helper_b b,fl) *)
(*     | And (f1,f2,loc)-> *)
(*       And (helper f1,helper f2,loc) *)
(*     | AndList lst-> *)
(*       failwith "instantiate_forall: AndList To Be Implemented" *)
(*     | Or (f1,f2,fl,loc)-> *)
(*       Or (helper f1,helper f2,fl,loc) *)
(*     | Not (f,fl,loc)-> *)
(*       Not (helper f,fl,loc) *)
(*     | Forall (n_sv,sub_f,fl,loc)-> *)
(*       Forall (n_sv,helper sub_f,fl,loc) *)
(*     | Exists (n_sv,sub_f,fl,loc)-> *)
(*       Exists(n_sv,helper sub_f,fl,loc) *)
(*   let f = helper f in *)
(*   add_unchanged_var f *)
(* ;; *)

(* let add_unchanged_pre_var prevar = *)
(*   let ind_sv = SpecVar (Int,"unchanged_ind",Unprimed) in *)
(*   prevar@[ind_sv] *)
(* ;; *)

(* ((from:int,to:int),relation name:string) *)
(* let change_arr_rel = ref [];; *)

(* let check_args explist = *)
(*   let search_primed_match wholelist id = *)
(*     let rec search_helper list id pos = *)
(*       match list with *)
(*       | (ArrayAt (SpecVar (Array _,nid,primed)),_,_)::rest -> *)
(*         if nid = id *)
(*         then Some pos *)
(*         else search_helper rest id (pos+1) *)
(*       | _::rest -> search_helper rest id (pos+1) *)
(*       | [] -> None *)
(*     in *)
(*     search_helper wholelist id 0 *)
(*   in *)
(*   let rec helper explist wholelist pos = *)
(*     match explist with *)
(*     | (ArrayAt (SpecVar (Array _,id,Unprimed)),_,_)::rest -> *)
(*       begin *)
(*         match search_primed_match wholelist id with *)
(*         | Some primed_pos -> (pos,primed_pos)::(helper rest wholelist) *)
(*         | None -> helper rest wholelist *)
(*       end *)
(*     | _::rest -> helper rest wholelist *)
(*     | [] -> [] *)
(*   in *)
(*   helper explist explist 0 *)
(* ;; *)

(* let build_change_rel_tbl_lst lst= *)
(*   let rec helper lst= *)
(*     match lst with *)
(*     | (f,t)::rest -> *)
(*       ( *)
(*         change_arr_rel := (relname,(f,t))::(!change_arr_rel); *)
(*         helper rest *)
(*       ) *)
(*     | [] -> *)
(*       () *)
(*   in *)
(*   helper lst *)
(* ;; *)

(* let initial_change_arr_rel rel= *)
(*   let list_helper rel = *)
(*     match rel with *)
(*     | BForm ((RelForm (SpecVar (_,id,_),explist,loc)),pa) -> *)
(*       begin *)
(*         match check_args explist with *)
(*         | [] -> () *)
(*         | lst -> *)
(*           build_change_rel_tbl_lst lst id *)
(*       end *)
(*     | _ -> *)
(*       () *)
(*   in *)
(*   list_helper rel *)
(* ;; *)

(* (\* ((from:int, to:int),setname:string,set content:(exp list*exp list)) *\) *)
(* let unchanged_tbl = ref [];; *)
(* let name_count = ref 0;; *)

(* let add_change_info f t pos = *)
(*   unchanged_tbl := ((f,t),"Set_"^(string_of_int name_count),([pos],[]))::!unchanged_tbl; *)
(*   name_count := !name_count+1 *)
(* ;; *)

(* let build_up_unchange_tbl rel f = *)
(*   let () = initial_change_arr_rel rel in *)
(*   let helper_b (p,ba) = *)
(*     match p with *)
(*     | RelForm (SpecVar (_,id,_), explist, loc) -> *)
(*       if id = "update_array_1d" *)
(*       then *)
(*         add_change_info 1 2 (List.nth 3 explist) *)
(*       else *)
(*         begin *)
(*           match change_info id with *)
(*           | Some (f,t) -> *)
(*             add_change_info (List.nth f explist) (List.nth t explist) -1 *)
(*           | None -> *)
(*             () *)
(*         end *)
(*     | _ -> () *)
(*   in *)
(*   let helper f = *)
(*     match f with *)
(*     | BForm (b,fl)-> *)
(*       helper_b b *)
(*     | And (f1,f2,_) *)
(*     | Or (f1,f2,_,_)-> *)
(*       ( *)
(*         helper f1; *)
(*         helper f2 *)
(*       ) *)
(*     | AndList lst-> *)
(*       failwith "get_unchanged_set: AndList To Be Implemented" *)
(*     | Not (sub_f,fl,loc)-> *)
(*       helper sub_f *)
(*     | Forall (nsv,sub_f,fl,loc) *)
(*     | Exists (nsv,sub_f,fl,loc)-> *)
(*       helper sub_f *)
(*   in *)
(*   helper f *)
(* ;; *)

let string_of_unchanged_info (f,t,clst) =
  "("^(ArithNormalizer.string_of_exp f)^","^(ArithNormalizer.string_of_exp t)^","^((pr_list ArithNormalizer.string_of_exp) clst)
;;

let clean_list lst af at =
  let equal_unchanged (f1,t1,clst1) (f2,t2,clst2) =
          (is_same_exp f1 f2)&&(is_same_exp t1 t2)
  in
  let drop lst =
    List.fold_left (fun r (f,t,clst) -> if is_same_exp f t then r else (f,t,clst)::r) [] lst
  in
  let expand lst =
    let expand_one_helper (f,t,clst) =
      List.fold_left (fun r (nf,nt,nclst) -> if is_same_exp t nf then (f,nt,clst@nclst)::r else r) [(f,t,clst)] lst
    in
    let rec expand_helper lst =
      match lst with
      | h::rest -> (expand_one_helper h)@(expand_helper rest)
      | [] -> []
    in
    let new_lst = ref [] in
    let rec iterator lst =
      let result = remove_dupl equal_unchanged (expand_helper lst) in
      (* let () = x_binfo_pp ("expand_helper result: "^((pr_list string_of_unchanged_info) result)) no_pos in *)
      if not (List.length result=List.length !new_lst)
      then
        (
          new_lst := result;
          iterator result
        )
      else
        ()
    in
    (
      iterator lst;
      !new_lst
    )
  in
  let clean lst af at =
    try
      Some (List.hd (List.fold_left (fun r (f,t,clst) -> if is_same_exp f af && is_same_exp t at then (f,t,remove_dupl is_same_exp clst)::r else r) [] lst))
    with _ -> None
  in
  (* let () = x_binfo_pp ("clean_list"^((pr_list string_of_unchanged_info) lst)) no_pos in *)
  clean (expand (drop lst)) af at
;;

let clean_list lst af at =
  let po = function
    | Some u -> string_of_unchanged_info u
    | None ->"None"
  in
  Debug.no_3 "clean_list" (pr_list string_of_unchanged_info) (ArithNormalizer.string_of_exp) (ArithNormalizer.string_of_exp) po clean_list lst af at
;;

let same_unordered_list cmp lst1 lst2=
    let rec same_helper one blst =
      match blst with
      | h::rest ->
        if cmp h one
        then (true,rest)
        else same_helper one rest
      | [] ->
        (false,[])
    in
    let rec same_helper_2 alst blst =
      match alst with
      | h::rest ->
        let (found,newlst) = same_helper h blst in
        if found
        then true&&(same_helper_2 rest newlst)
        else false
      | [] ->
        List.length blst = 0
    in
    same_helper_2 lst1 lst2
;;

let unchanged_fixpoint (rel:formula) (define:formula list) =
  (* rel is the name of the relation, define is a list of disjunction formula that defines this relation *)
  let basic = ref (fun af at -> []) in
  let calculator relname (arg1:exp) (arg2:exp) (define:formula list) basic=
    (* Return a function, that takes in two arrays and returns the list of array relations between them *)
    (* arg1 and arg2 say that how the arguments look like in the definition *)
    let new_fun flst =
      let new_fun_x (af:exp) (at:exp)=
        let rec new_fun_helper (f:formula):((exp*exp*(exp list)) list) list =
          match f with
          | BForm (((RelForm (SpecVar (_,id,_),explist,loc)),pa),_) ->
            let uop1=
              if is_same_exp (List.nth explist 0)  arg1 then af else List.nth explist 0
            in
            let uop2=
              if is_same_exp (List.nth explist 1)  arg2 then at else List.nth explist 1
            in
            if id = "update_array_1d"
            then
              (* Only one disjunction *)
              [ [(uop1,uop2,[(List.nth explist 3)])] ]
            else
            if id = relname
            then
              [basic uop1 uop2]
            else
              []
          | BForm (((Eq ((Var (SpecVar (Array _,_,_),_) as v2),(Var (SpecVar (Array _,_,_),_) as v1),loc)),pa),_) ->
            let uop1=
              if is_same_exp v1  arg1 then af else v1
            in
            let uop2=
              if is_same_exp v2 arg2 then at else v2
            in
            [ [(uop1,uop2,[])] ]
          | And (f1,f2,loc) ->
            let dres1 = new_fun_helper f1 in
            let dres2 = new_fun_helper f2 in
            List.fold_left (fun result rlst1 -> (List.map (fun rlst2 -> rlst1@rlst2) dres2)@result) (dres1@dres2) dres1
          | _ -> []
        in
        let equal_unchanged (f1,t1,clst1) (f2,t2,clst2) =
          (is_same_exp f1 f2)&&(is_same_exp t1 t2)
        in
        let list_of_list = List.flatten (List.map new_fun_helper flst) in
        (List.fold_left
           (fun result flst ->
              match clean_list flst af at with
              | Some u -> u::result
              | None -> result
           ) [] list_of_list)
      in
      new_fun_x
    in
    new_fun define
  in
  let (relname,arg1,arg2) =
    match rel with
    | BForm (((RelForm (SpecVar (_,id,_),explist,loc)),pa),_) ->
      (id,List.nth explist 0,List.nth explist 1)
    | _ -> failwith "unchanged_fixpoint: Invalid rel"
  in
  let same_index_set = same_unordered_list is_same_exp in
  let same_unchanged_info (f1,t1,iset1) (f2,t2,iset2)=
    (is_same_exp f1 f2)&&(is_same_exp t1 t2)&&(same_index_set iset1 iset2)
  in
  let same_result = same_unordered_list same_unchanged_info in
  let rec iterator () =
    let old_result = !basic arg1 arg2 in
    (* let () = x_binfo_pp ("old_result "^((pr_list string_of_unchanged_info) old_result)) no_pos in *)
    let new_rel = calculator relname arg1 arg2 define !basic in
    let new_result = new_rel arg1 arg2 in
    let () = x_tinfo_pp ("new_result "^((pr_list string_of_unchanged_info) new_result)) no_pos in
    if (same_result new_result old_result)
    then
      new_rel
    else
      let () = basic := new_rel in
      iterator ()
  in
  iterator ()
;;

let unify_unchanged_fixpoint ulist =
  match ulist with
  | [] ->
    ulist
  | h::rest ->
    let result =
      List.fold_left (fun (rf,rt,rc) (nf,nt,nc) ->
          if not (((is_same_exp rf nf)&&(is_same_exp rt nt))||((is_same_exp rf nt)&&(is_same_exp rt nf)))
          then
            failwith "unify_unchanged_fixpoint: Invalid input"
          else
            (rf,rt,rc@nc)
        ) h rest
    in
    [result]
;;

let get_unchanged_fixpoint rel define =
  let (relname,arg1,arg2) =
    match rel with
    | BForm (((RelForm (SpecVar (_,id,_),explist,loc)),pa),_) ->
      (id,List.nth explist 0,List.nth explist 1)
    | _ -> failwith "unchanged_fixpoint: Invalid rel"
  in
  let result = (unchanged_fixpoint rel define) arg1 arg2 in
  let () = global_unchanged_info:= unify_unchanged_fixpoint result in
  result
;;

let get_unchanged_fixpoint rel define =
  Debug.no_2 "get_unchanged_fixpoint" !print_pure (pr_list !print_pure) (pr_list string_of_unchanged_info) get_unchanged_fixpoint rel define
;;

let get_unchanged_fixpoint rel define =
  if !Globals.array_translate
  then get_unchanged_fixpoint rel define
  else []
;;



let rec add_unchanged_info_to_formula unchanged f =
  let rec has_array_equal f e1 e2 =
    (* only conjuction, see whether there is a=a' *)
    match f with
    | BForm (((Eq ((Var (SpecVar (Array _,_,_),_) as v2),(Var (SpecVar (Array _,_,_),_) as v1),loc)),pa),_) ->
      (is_same_exp e1 v2 && is_same_exp e2 v1)||(is_same_exp e1 v1 && is_same_exp e2 v2)
    | And (f1,f2,_)->
      has_array_equal f1 e1 e2 || has_array_equal f2 e1 e2
    | _ -> false
  in
  let produce_unchanged_formula unchanged =
    match unchanged with
    | [(((Var (SpecVar _ as svf,_)) as e1),((Var (SpecVar _ as svt,_)) as e2),clst)] ->
      let new_qi = SpecVar (Int,"i",Unprimed) in
      let new_qi_var = Var (new_qi,no_pos) in
      let equal_f = BForm ((Eq (ArrayAt (svf,[new_qi_var],no_pos),ArrayAt (svt,[new_qi_var],no_pos),no_pos),None),None) in
      begin
        match clst with
        | [] ->
          Some (Forall (new_qi,equal_f,None,no_pos), e1, e2)
        | h::rest ->
          let pre_f = List.fold_left (
              fun result e ->
                let index_f = BForm ((Eq (new_qi_var,e,no_pos),None),None) in
                let not_f = Not (index_f,None,no_pos) in
                And (not_f,result,no_pos)
            ) (Not (BForm ((Eq (new_qi_var,h,no_pos),None),None),None,no_pos)) rest
          in
          let sub_f = Or (pre_f,equal_f,None,no_pos) in
          Some (Forall (new_qi,sub_f,None,no_pos),e1,e2)
      end
    | _ -> None
  in
  let helper unchanged f=
    let unchanged_formula = produce_unchanged_formula unchanged in
    match unchanged_formula with
    | None -> f
    | Some (uf,e1,e2) ->
      if has_array_equal f e1 e2
      then f
      else
        And (f,uf,no_pos)
  in
  match f with
  | Or (f1,f2,fl,loc) ->
    let new_f1 = add_unchanged_info_to_formula unchanged f1 in
    let new_f2 = add_unchanged_info_to_formula unchanged f2 in
    Or (new_f1,new_f2,fl,loc)
  | _ -> helper unchanged f
;;

let add_unchanged_info_to_formula unchanged f =
  Debug.no_2 "add_unchanged_info_to_formula" (pr_list string_of_unchanged_info) !print_pure !print_pure add_unchanged_info_to_formula unchanged f
;;

let add_unchanged_info_to_formula_f f =
  add_unchanged_info_to_formula !global_unchanged_info f
;;







(* let unchanged_fixpoint rel define = *)
(*   let function_tbl = rel [] in *)
(*   let get_update_array_1d a b c = *)
(*     [((a,b),[c])] *)
(*   in *)
(*   let basic_rel = ref (fun a1 a2 -> []) *)
(*   in *)
(*   let produce_set define a1 a2 = *)
(*     let helper define = *)
(*       match define with *)
(*       | BForm ((RelForm (SpecVar (_,id,_),explist,loc)),pa) -> *)
(*         if id = "update_array_1d" *)
(*         then *)
(*           get_update_array_1d (List.nth 0 explist) (List.nth 1 explist) (List.nth 3 explist) *)
(*         else *)
(*         if id = relname *)
(*         then basic_rel (List.nth pos1 explist) (List.nth pos2 explist) *)
(*         else [] *)
(*       | And (f1,f2,_) -> *)
(*         (helper f1)@(helper f2) *)
(*       | Or _ -> failwith "produce_set helper: Invalid input Or" *)
(*       | _ -> [] *)
(*     in *)
(*     let clean_list lst af at = *)
(*       let expand lst = *)
(*         let expand_one_helper (f,t,clst) = *)
(*           fold_left (fun r (nf,nt,nclst) -> if t = nf then (f,nt,clst@nclst)::r else r) [(f,t,clst)] lst *)
(*         in *)
(*         let rec expand_helper lst = *)
(*           match lst with *)
(*           | h::rest -> (expand_one_helper h)::(expand_helper lst) *)
(*           | [] -> [] *)
(*         in *)
(*         let new_lst = ref [] in *)
(*         let iterator lst = *)
(*           let result = expand_helper lst in *)
(*           if not (List.length result=List.length !new_lst) *)
(*           then *)
(*             ( *)
(*               new_lst := result; *)
(*               iterator result *)
(*             ) *)
(*           else *)
(*             () *)
(*         in *)
(*         ( *)
(*           iterator lst; *)
(*           !new_lst *)
(*         ) *)
(*       in *)
(*       let clean lst af at = *)
(*         fold_left (fun r (f,t,clst) -> if f=af && t=at then (f,t,clst)::r else r *)
(*       in *)
(*       clean (expand lst) *)
(*     in *)
    




(*     let change_list = helper define in *)
    





(*   let produce_define relname define = *)
(*     match define with *)
(*     | BForm ((RelForm (SpecVar (_,id,_),explist,loc)),pa) -> *)
(*       if id = "update_array_1d" *)
(*       then *)
(*         fun a1 a2 -> ((List.nth 0 explist,List.nth 1 explist),List.nth 3 explist) *)
(*       else *)
(*         if id = relname *)
(*         then basic *)
(*         else None *)
(*     | And (f1,f2,_) -> *)
(*       begin *)
(*         match produce_define relname f1, produce_define relname f2 with *)
(*         | None, None -> None *)
(*         | Some fun1,None -> Some fun1 *)
(*         | None, Some fun2 -> Some fun2 *)
(*         | Some fun1,Some fun2 ->  *)
