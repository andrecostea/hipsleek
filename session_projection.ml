#include "xdebug.cppo"
open VarGen

open Globals
open Gen.Basic
open Printf
open Gen.BList
include Ipure_D (*elena*)

module SProt  = Session.IProtocol
module SBProt = Session.IProtocol_base
module SIOrd = Session.IOrders
module OS = Order_summary
module SProj = Session.IProjection
module SBProj = Session.IProjection_base
module STProj = Session.ITPProjection
module SBTProj = Session.ITPProjection_base

type role = SIOrd.role
type chan = SIOrd.chan

(* ====== Projection Maps ====== *)
(* ============================= *)

module Projection_map = 
struct
  type t = SProj.session 
  type base = SProj.t

  let bot () = SProj.SEmp
  let is_bot x = match x with
    | SProj.SEmp -> true
    | _ -> false
  let eq e1 e2 = failwith x_tbi
  let string_of f = SProj.string_of_session f
  let mk_base (base: base) : t = failwith x_tbi
  let mk_or   (or1:t) (or2:t) : t = failwith x_tbi 
  let mk_star (star1:t) (star2:t) : t = failwith x_tbi 
  let merge_seq (f1:t) (f2:t) : t = failwith x_tbi
  let merge_sor (f1:t) (f2:t) : t = failwith x_tbi
  let merge_star (f1:t) (f2:t) : t = failwith x_tbi
  let mkSingleton (e:base) : t = failwith x_tbi
  let add_elem (old_e:t) (new_e:t) : t  = new_e
end;;

module TProjection_map =
struct
  type t = STProj.session
  type base = STProj.t

  let bot () = STProj.SEmp
  let is_bot x = match x with
    | STProj.SEmp -> true
    | _ -> false
  let eq e1 e2 = failwith x_tbi
  let string_of f = STProj.string_of_session f
  let mk_base (base: base) : t = failwith x_tbi
  let mk_or   (or1:t) (or2:t) : t = failwith x_tbi 
  let mk_star (star1:t) (star2:t) : t = failwith x_tbi 
  let merge_seq (f1:t) (f2:t) : t = failwith x_tbi
  let merge_sor (f1:t) (f2:t) : t = failwith x_tbi
  let merge_star (f1:t) (f2:t) : t = failwith x_tbi
  let mkSingleton (e:base) : t = failwith x_tbi
  let add_elem (old_e:t) (new_e:t) : t  = new_e
end;;

module HProjection_map =
struct
  type t = Iformula.struc_formula
  type base = Iformula.struc_formula

  let bot () = failwith x_tbi 
  let is_bot x = failwith x_tbi
  let eq e1 e2 = failwith x_tbi
  let string_of f = !Iformula.print_struc_formula f 
  let mk_base (base: base) : t = failwith x_tbi
  let mk_or   (or1:t) (or2:t) : t = failwith x_tbi 
  let mk_star (star1:t) (star2:t) : t = failwith x_tbi 
  let merge_seq (f1:t) (f2:t) : t = failwith x_tbi
  let merge_sor (f1:t) (f2:t) : t = failwith x_tbi
  let merge_star (f1:t) (f2:t) : t = failwith x_tbi
  let mkSingleton (e:base) : t = failwith x_tbi
  let add_elem (old_e:t) (new_e:t) : t  = new_e
end;;


module PrjMap = OS.SMap(OS.IRole)(Projection_map)
module TPrjMap = OS.SMap(OS.IChanRole)(TProjection_map)

(* used to save projection as h_formula *)
module HPrjMap = OS.SMap(OS.IRole)(HProjection_map)
module HTPrjMap = OS.SMap(OS.IChanRole)(HProjection_map)

(* ====== Helpful functions ====== *)
(* =============================== *)

(* creates session projection base for party *)
let create_session_base_prj transmission chan msg_var pos heap_node msg =
  let base = SBProj.mk_base (transmission, chan, msg_var, pos) ~node:heap_node msg in
  let session_formula = SProj.SBase (SProj.Base base) in
  session_formula

(* creates session projection base for channel *)
let create_session_base_tprj transmission msg_var pos heap_node msg =
  let base = SBTProj.mk_base (transmission, msg_var, pos) ~node:heap_node msg in
  let session_formula = STProj.SBase (STProj.Base base) in
  session_formula

(* Makes projection per party for assumptions *)
let rec mk_prj_assume_on_role pred_orders role =
  match pred_orders with
   | SIOrd.And and_type -> 
       let and_head = and_type.and_assrt1 in
       let and_tail = and_type.and_assrt2 in
       let prj1 = mk_prj_assume_on_role and_head role in
       let prj2 = mk_prj_assume_on_role and_tail role in
       SIOrd.mk_and prj1 prj2 
   | SIOrd.Or or_type ->
       let or_head = or_type.or_assrt1 in
       let or_tail = or_type.or_assrt2 in
       let prj1 = mk_prj_assume_on_role or_head role in
       let prj2 = mk_prj_assume_on_role or_tail role in
       SIOrd.mk_or prj1 prj2
   | SIOrd.Event e ->
       if SBProt.eq_role role e.role then
         SIOrd.Event e
       else
         SIOrd.Bot
   | _ -> SIOrd.Bot

(* Makes projection per channel for assumptions
 * Returns a pair of SIOrd.assrt: 
   * (orders for Assume, orders for Guard) *)
let rec mk_prj_assume_on_chan pred_orders chan =
  match pred_orders with
   | SIOrd.And and_type ->
        let and_head = and_type.and_assrt1 in
        let and_tail = and_type.and_assrt2 in
        let prj_assume1, prj_guard1 = mk_prj_assume_on_chan and_head chan in
        let prj_assume2, prj_guard2 = mk_prj_assume_on_chan and_tail chan in
       (SIOrd.mk_and prj_assume1 prj_assume2, SIOrd.mk_and prj_guard1 prj_guard2) 
   | SIOrd.Or or_type ->
       let or_head = or_type.or_assrt1 in
       let or_tail = or_type.or_assrt2 in
       let prj_assume1, prj_guard1 = mk_prj_assume_on_chan or_head chan in
       let prj_assume2, prj_guard2 = mk_prj_assume_on_chan or_tail chan in
       (SIOrd.mk_or prj_assume1 prj_assume2, SIOrd.mk_or prj_guard1 prj_guard2)
   | SIOrd.Event e ->
       if SBProj.eq_chan chan e.channel then
         (SIOrd.Event e, SIOrd.Bot)
       else
         (SIOrd.Bot, SIOrd.Event e)
   | SIOrd.Order order ->
       begin match order with
       | SIOrd.HBe hbe ->
           let hbe_chan = hbe.hbe_event2.channel in
           if (SBProj.eq_chan chan hbe_chan) then
             (SIOrd.mk_order (SIOrd.HBe hbe), SIOrd.Bot)
           else
             (SIOrd.Bot, SIOrd.Bot)
       | _ -> (SIOrd.Bot, SIOrd.Bot)
       end
   | _ -> (SIOrd.Bot, SIOrd.Bot)
 
(* Makes projection per party for proof obligations *)
(* Returns a pair of SIOrd.assrt: 
  * (orders for Assume, orders for Guard) *)
let rec mk_prj_guard_on_role pred_orders role =
  match pred_orders with
   | SIOrd.And and_type -> 
       let and_head = and_type.and_assrt1 in
       let and_tail = and_type.and_assrt2 in
       let (prj_assume1, prj_guard1) = mk_prj_guard_on_role and_head role in
       let (prj_assume2, prj_guard2) = mk_prj_guard_on_role and_tail role in
       (SIOrd.mk_and prj_assume1 prj_assume2, SIOrd.mk_and prj_guard1 prj_guard2)
   | SIOrd.Or or_type ->
       let or_head = or_type.or_assrt1 in
       let or_tail = or_type.or_assrt2 in
       let (prj_assume1, prj_guard1) = mk_prj_guard_on_role or_head role in
       let (prj_assume2, prj_guard2) = mk_prj_guard_on_role or_tail role in
       (SIOrd.mk_or prj_assume1 prj_assume2, SIOrd.mk_or prj_guard1 prj_guard2)
   | SIOrd.Event e -> (SIOrd.Bot, SIOrd.Bot)
   | SIOrd.Order order ->
     begin
      match order with
      | SIOrd.HBe hbe -> 
          let hbe_role = hbe.hbe_event2.role in
          if (SBProt.eq_role role hbe_role) then
            (SIOrd.Bot, SIOrd.mk_order (SIOrd.HBe hbe))
          else 
            (SIOrd.mk_order (SIOrd.HBe hbe), SIOrd.Bot)
      | _ -> (SIOrd.Bot, SIOrd.Bot)
     end
   | _ -> (SIOrd.Bot, SIOrd.Bot)

(* Makes projection per channel for proof obligations *)
let rec mk_prj_guard_on_chan pred_orders chan =
  match pred_orders with
   | SIOrd.And and_type -> 
       let and_head = and_type.and_assrt1 in
       let and_tail = and_type.and_assrt2 in
       let prj1 = mk_prj_guard_on_chan and_head chan in
       let prj2 = mk_prj_guard_on_chan and_tail chan in
       SIOrd.mk_and prj1 prj2 
   | SIOrd.Or or_type ->
       let or_head = or_type.or_assrt1 in
       let or_tail = or_type.or_assrt2 in
       let prj1 = mk_prj_guard_on_chan or_head chan in
       let prj2 = mk_prj_guard_on_chan or_tail chan in
       SIOrd.mk_or prj1 prj2
   | SIOrd.Order order ->
       begin match order with
       | SIOrd.HBe hbe ->
           let hbe_chan = hbe.hbe_event2.channel in
           if (SBProj.eq_chan chan hbe_chan) then
             SIOrd.mk_order (SIOrd.HBe hbe)
           else
             SIOrd.Bot
       | _ -> SIOrd.Bot
       end
   | _ -> SIOrd.Bot

(* per party *)
let norm_proj (session:SProj.session) : SProj.session = 
  (* removes assrt Bot *)
  let norm_sess = SProj.norm_assrt session in
  (* removes assertions and guards that contain orders with only one Bot *)
  let norm_sess = SProj.remove_assrt_bot norm_sess in
  let norm_sess = SProj.remove_emps norm_sess in
  norm_sess

(* per channel *)
let norm_tproj (session:STProj.session) : STProj.session =
  (* removes assrt Bot *)
  let norm_sess = STProj.norm_assrt session in
  (* removes assertions and guards that contain orders with only one Bot *)
  let norm_sess = STProj.remove_assrt_bot norm_sess in
  let norm_sess = STProj.remove_emps norm_sess in
  norm_sess

let rec remove_bot_from_list_x lst new_lst = match lst with
  | [] -> new_lst
  | head :: tail ->
      let h = SProt.norm_orders head in
      remove_bot_from_list_x tail (new_lst @ [h])

let rec remove_bot_from_list lst new_lst =
  let pr = pr_list SIOrd.string_of in
  Debug.no_1 "SP.remove_bot_from_list" pr pr (fun _ -> remove_bot_from_list_x lst new_lst) lst

(* ====== Projection per party / channel ====== *)
(* ============================================ *)

(* Projection per party *)
(* global spec -> per party spec *)
let mk_projection_per_party prot role =
  let rec deconstruct_prot prot = match prot with
    | SProt.SSeq seq -> 
        let head      = seq.session_seq_formula_head in
        let tail      = seq.session_seq_formula_tail in
        let pos       = seq.session_seq_formula_pos in
        let sess_prj1 = deconstruct_prot head in
        let sess_prj2 = deconstruct_prot tail in
        SProj.mk_session_seq_formula sess_prj1 sess_prj2 pos
    | SProt.SOr sor ->
        let session1  = sor.session_sor_formula_or1 in
        let session2  = sor.session_sor_formula_or2 in
        let pos       = sor.session_sor_formula_pos in
        let sess_prj1 = deconstruct_prot session1 in
        let sess_prj2 = deconstruct_prot session2 in
        SProj.mk_session_or_formula sess_prj1 sess_prj2 pos
    | SProt.SStar star ->
        let session1  = star.session_star_formula_star1 in 
        let session2  = star.session_star_formula_star2 in 
        let pos       = star.session_star_formula_pos in
        let sess_prj1 = deconstruct_prot session1 in
        let sess_prj2 = deconstruct_prot session2 in
        SProj.mk_session_star_formula sess_prj1 sess_prj2 pos
    | SProt.SBase sb -> 
        begin
          match sb with
          | SProt.Base base ->
            (* gets information nedeed for projection *)
            let pos = SBProt.get_base_pos base in
            let msg_var = SBProt.get_message_var base in
            let msg = SBProt.get_message base in
            let chan =  SBProt.get_chan base in
            let chan = match chan with
              | Some ch -> ch
              | None -> session_msg in
            let sender = SBProt.get_sender base in
            let receiver = SBProt.get_receiver base in
            let heap_node = SBProt.get_session_heap_node base in
            (* creates session_formula based on transmission role *) 
            if (SBProt.eq_role sender role) then 
              let session_formula = create_session_base_prj Session.TSend chan msg_var pos heap_node msg in
              session_formula
            else if (SBProt.eq_role receiver role) then
              let session_formula = create_session_base_prj Session.TReceive chan msg_var pos heap_node msg in
              session_formula
            else
              SProj.SEmp
          | SProt.Predicate sp ->
            (* gets information nedeed for projection *)
            let pred_pos    = sp.session_predicate_pos in
            let pred_orders = sp.session_predicate_orders in
            let pred_kind   = sp.session_predicate_kind in
            (* makes projection per Predicate kind *)
            (* only Assert Assume and Assert Guard are taken into consideration *)
            begin match pred_kind with
            | Assert a -> 
              begin
                match a with
                | Assume ->
                    let assrt = mk_prj_assume_on_role pred_orders role in
                    let prot = SProt.update_session_predicate ~orders:assrt sp in
                    let proj = Session.convert_pred_from_prot_to_proj prot in
                    proj
                | Guard -> 
                    let (assrt_assume, assrt_guard) = mk_prj_guard_on_role pred_orders role in
                    let prot_assume = SProt.update_session_predicate ~orders:assrt_assume sp in
                    let proj_assume = Session.convert_pred_from_prot_to_proj prot_assume in
                    let prot_guard = SProt.update_session_predicate ~orders:assrt_guard sp in
                    let proj_guard = Session.convert_pred_from_prot_to_proj prot_assume in
                    SProj.mk_session_seq_formula proj_assume proj_guard pred_pos
                | _ -> SProj.SEmp
              end
            | _ -> SProj.SEmp 
            end
          | _ -> SProj.SEmp
        end
    | _ -> SProj.SEmp
  in
  let session = deconstruct_prot prot in
  norm_proj session

let mk_projection_per_party prot role =
  let pr1 = SProt.string_of_session in
  let pr2 = Iformula.string_of_spec_var in
  let pr_out = SProj.string_of_session in
  Debug.no_2 "SP.mk_projection_per_party" pr1 pr2 pr_out (fun _ _ -> mk_projection_per_party prot role) prot role


(* Projection per channel *)
(* per party spec -> per channel spec *)
let mk_projection_per_channel prj chan =
  let rec prj_per_chan prj chan = match prj with
  | SProj.SSeq seq -> 
      let head      = seq.session_seq_formula_head in
      let tail      = seq.session_seq_formula_tail in
      let pos       = seq.session_seq_formula_pos in
      let sess_prj1 = prj_per_chan head chan in
      let sess_prj2 = prj_per_chan tail chan in
      STProj.mk_session_seq_formula sess_prj1 sess_prj2 pos
  | SProj.SOr sor ->
      let session1  = sor.session_sor_formula_or1 in
      let session2  = sor.session_sor_formula_or2 in
      let pos       = sor.session_sor_formula_pos in
      let sess_prj1 = prj_per_chan session1 chan in
      let sess_prj2 = prj_per_chan session2 chan in
      STProj.mk_session_or_formula sess_prj1 sess_prj2 pos
  | SProj.SStar star ->
      let session1  = star.session_star_formula_star1 in 
      let session2  = star.session_star_formula_star2 in 
      let pos       = star.session_star_formula_pos in
      let sess_prj1 = prj_per_chan session1 chan in
      let sess_prj2 = prj_per_chan session2 chan in
      STProj.mk_session_star_formula sess_prj1 sess_prj2 pos
  | SProj.SBase sb -> 
      begin match sb with
      | SProj.Base base ->
          (* gets information nedeed for projection *)
          let transmission = SBProj.get_base_transmission base in
          let ch = SBProj.get_channel base in
          let msg = SBProj.get_message base in
          let msg_var = SBProj.get_message_var base in
          let heap_node = SBProj.get_session_heap_node base in
          let pos = SBProj.get_base_pos base in
          begin match transmission with
          | Session.TSend
          | Session.TReceive ->
              if SBProj.eq_chan ch chan then
                create_session_base_tprj transmission msg_var pos heap_node msg
              else STProj.SEmp
          end
      | SProj.Predicate pred ->
          (* gets information nedeed for projection *)
          let pred_pos    = pred.session_predicate_pos in
          let pred_orders = pred.session_predicate_orders in
          let pred_kind   = pred.session_predicate_kind in
          begin match pred_kind with
            | Assert a -> 
              begin
                match a with
                | Assume ->
                    let (assrt_assume, assrt_guard) = mk_prj_assume_on_chan pred_orders chan in
                    let prot_assume = SProj.update_session_predicate ~orders:assrt_assume pred in
                    let proj_assume = Session.convert_pred_from_prot_to_tproj prot_assume in
                    let prot_guard = SProj.update_session_predicate ~orders:assrt_guard pred in
                    let proj_guard = Session.convert_pred_from_prot_to_tproj prot_guard in
                    STProj.mk_session_seq_formula proj_assume proj_guard pred_pos
                | Guard ->
                    let assrt = mk_prj_guard_on_chan pred_orders chan in
                    let prot = SProj.update_session_predicate ~orders:assrt pred in
                    let proj = Session.convert_pred_from_prot_to_tproj prot in
                    proj
                | _ -> STProj.SEmp
              end
            | _ -> STProj.SEmp
          end
      | _ -> STProj.SEmp
      end
  | _ -> STProj.SEmp
  in
  let session = prj_per_chan prj chan in
  norm_tproj session

let mk_projection_per_channel prj chan =
  let pr1 = SProj.string_of_session in
  let pr2 = Iformula.string_of_spec_var in
  let pr_out = STProj.string_of_session in
  Debug.no_2 "SP.mk_projection_per_channel" pr1 pr2 pr_out (fun _ _ -> mk_projection_per_channel prj chan) prj chan

(* Global projection: global spec -> shared spec *)
(* Collects assumptions from the global protocol *)
(* Returns a list of assumptions orders          *)
let mk_projection_shared_spec prot lst =
  let rec deconstruct_prot prot lst = match prot with
    | SProt.SSeq seq -> 
        let head      = seq.session_seq_formula_head in
        let tail      = seq.session_seq_formula_tail in
        let sess_prj1 = deconstruct_prot head lst in
        let sess_prj2 = deconstruct_prot tail lst in
        lst @ sess_prj1 @ sess_prj2
    | SProt.SOr sor ->
        let session1  = sor.session_sor_formula_or1 in
        let session2  = sor.session_sor_formula_or2 in
        let sess_prj1 = deconstruct_prot session1 lst in
        let sess_prj2 = deconstruct_prot session2 lst in
        lst @ sess_prj1 @ sess_prj2
    | SProt.SStar star ->
        let session1  = star.session_star_formula_star1 in 
        let session2  = star.session_star_formula_star2 in 
        let sess_prj1 = deconstruct_prot session1 lst in
        let sess_prj2 = deconstruct_prot session2 lst in
        lst @ sess_prj1 @ sess_prj2
    | SProt.SBase sb ->
        begin match sb with
        | SProt.Predicate pred ->
            let pred_orders = pred.session_predicate_orders in
            let pred_kind   = pred.session_predicate_kind in
            (* makes projection per Predicate kind *)
            (* only Assert Assume is checked *)
            begin match pred_kind with
            | Assert a -> 
              begin match a with
              | Assume ->
                  let rec order_prj pred_orders = begin match pred_orders with
                  | SIOrd.And typ ->
                      let assrt1 = typ.and_assrt1 in
                      let assrt2 = typ.and_assrt2 in
                      SIOrd.mk_and (order_prj assrt1) (order_prj assrt2)
                  | SIOrd.Or typ ->
                      let assrt1 = typ.or_assrt1 in
                      let assrt2 = typ.or_assrt2 in
                      SIOrd.mk_or (order_prj assrt1) (order_prj assrt2)
                  | SIOrd.Order order ->
                      begin match order with
                      | SIOrd.HBe _
                      | SIOrd.CBe _ -> SIOrd.Order order
                      | _ -> SIOrd.Bot
                      end
                  | _ -> SIOrd.Bot
                  end in
                  [order_prj pred_orders]
              | _ -> [] 
              end
            | _ -> []
            end
        | _ -> []
        end
    | _ -> lst in
  let res = deconstruct_prot prot [] in
  remove_bot_from_list res []
   
let mk_projection_shared_spec prot lst =
  let pr1 = SProt.string_of_session in
  let pr2 = pr_list SIOrd.string_of in
  Debug.no_1 "SP.mk_projection_shared_spec" pr1 pr2 (fun _ -> mk_projection_shared_spec prot lst) prot

(* ====== Helpful functions used to collect projection result ====== *)
(* ================================================================= *)

(* Collects projections per party into the Map *)
let save_party_prj_into_map map prj_elem role =
  match PrjMap.is_empty map with
    | true -> PrjMap.init [(role, prj_elem)]
    | false -> PrjMap.add_elem_dupl map role prj_elem

let save_party_prj_into_map map prj_elem role =
  let pr = PrjMap.string_of in
  Debug.no_1 "SP.save_party_prj_into_map" pr pr (fun _ -> save_party_prj_into_map map prj_elem role) map

(* Collects projections per channel into the Map *)
let save_chan_prj_into_map map prj_elem pair =
  match TPrjMap.is_empty map with
    | true -> TPrjMap.init [(pair, prj_elem)]
    | false -> TPrjMap.add_elem_dupl map pair prj_elem

let save_chan_prj_into_map map prj_elem pair =
  let pr = TPrjMap.string_of in
  Debug.no_1 "SP.save_chan_prj_into_map" pr pr (fun _ -> save_chan_prj_into_map map prj_elem pair) map

(* per party *)
let rec create_map_of_prj prot vars map =
  List.fold_left (fun acc (typ, var) ->
    if cmp_typ typ role_typ then
      let role = Session.IMessage.mk_var var in
      let prj_per_party = mk_projection_per_party prot role in
      save_party_prj_into_map acc prj_per_party role
    else acc) map vars

(* per channel *)
let create_map_of_tprj prj_map vars =
  let rec mk_prj_per_channel prj role vars map =
    List.fold_left (fun acc (typ, var) ->
      if cmp_typ typ chan_typ then
        let chan = Session.IMessage.mk_var var in
        let prj_per_chan = mk_projection_per_channel prj chan in
        save_chan_prj_into_map acc prj_per_chan (chan, role)
      else
        acc) map vars in
  List.fold_left (fun acc (role, prj) -> mk_prj_per_channel prj role vars acc) (TPrjMap.mkEmpty()) prj_map
      
(* Applies projection per party, then per channel.
 * Returns a pair of projections *)
let mk_projection prot vars =
  let prj_map = create_map_of_prj prot vars (PrjMap.mkEmpty()) in
  let tprj_map = create_map_of_tprj prj_map vars in
  let assrt_prj_list = mk_projection_shared_spec prot [] in
  (prj_map, tprj_map, assrt_prj_list)

let mk_projection prot vars =
  let pr = SProt.string_of_session in
  let pr_out = pr_triple PrjMap.string_of TPrjMap.string_of (pr_list SIOrd.string_of) in
  Debug.no_1 "SP.mk_projection_x" pr pr_out (fun _ -> mk_projection prot vars) prot


(* ====== Transform session to h_formula ====== *)
(* ============================================ *)

(* Converts session projections to h_form and saves the result in new maps *)
let convert_prj_maps prj_map tprj_map =
  let hprj_map = PrjMap.map_data_ext (fun elem ->
    let pos = SProj.get_pos elem in
    let elem = match elem with
      | SProj.SBase sb -> 
          begin match sb with
        | SProj.Predicate pred ->
            let orders = pred.session_predicate_orders in
            elem
        | _ -> elem
        end
      | _ -> elem in
    let h_form = SProj.trans_from_session elem in
    let form = SProj.mk_formula_heap_only h_form pos in
    Session.IMessage.mk_struc_formula form pos 
   ) prj_map
  in
  let htprj_map = TPrjMap.map_data_ext (fun elem ->
    let pos = STProj.get_pos elem in
    let elem = match elem with
      | STProj.SBase sb -> begin match sb with
        | STProj.Predicate pred ->
            let orders = pred.session_predicate_orders in
            elem
        | _ -> elem
        end
      | _ -> elem in
    let h_form = STProj.trans_from_session elem in
    let form = STProj.mk_formula_heap_only h_form pos in
    Session.IMessage.mk_struc_formula form pos
    ) tprj_map
  in
  (HPrjMap.init hprj_map, HTPrjMap.init htprj_map)

let convert_prj_maps prj_map tprj_map =
  let pr1 = PrjMap.string_of in
  let pr2 = TPrjMap.string_of in
  let pr_out = pr_pair HPrjMap.string_of HTPrjMap.string_of in
  Debug.no_2 "SP.convert_prj_maps" pr1 pr2 pr_out (fun _ _ -> convert_prj_maps prj_map tprj_map) prj_map tprj_map

