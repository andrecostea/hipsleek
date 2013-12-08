open Globals
open Sleekcommons
open Sleekengine
open Gen.Basic
(* open Exc.ETABLE_NFLOW *)
open Exc.GTable

module H = Hashtbl
module I = Iast
module C = Cast
module CF = Cformula
module CP = Cpure
module IF = Iformula
module IP = Ipure
module AS = Astsimp

module NF = Nativefront

let sleeklib_init (args:string array) =
  wrap_exists_implicit_explicit := false ;
  Arg.parse_argv args Scriptarguments.sleek_arguments (fun _ -> ()) "";
	(if !Globals.override_slc_ps then Globals.en_slc_ps:=false else ());
  Scriptarguments.check_option_consistency ();
  Globals.silence_output := true;
  if (!Tpdispatcher.tp_batch_mode) then Tpdispatcher.start_prover ();
  let _ = process_data_def (I.b_data_constr b_datan []) in
  let _ = I.inbuilt_build_exc_hierarchy () in (* for inbuilt control flows *)
  let _ = Iast.build_exc_hierarchy true iprog in
  let _ = exlist # compute_hierarchy  in  
  ()
  
  	
let sleeklib_stop (_:bool) = 
if (!Tpdispatcher.tp_batch_mode) then Tpdispatcher.stop_prover ();
  Sleek.sleek_proof_log_Z3 ["stringInput"]
						
	
let process_cmd_list cmds :bool= 
  (*proc_one_def*)
  List.iter (fun c ->  match c with 
      | DataDef ddef -> process_data_def ddef
      | PredDef pdef -> process_pred_def_4_iast pdef
      | BarrierCheck bdef -> process_data_def (I.b_data_constr bdef.I.barrier_name bdef.I.barrier_shared_vars)
      | FuncDef fdef -> process_func_def fdef
      | RelDef rdef -> process_rel_def rdef
      | TemplDef tdef -> process_templ_def tdef
      | HpDef hpdef -> process_hp_def hpdef
      | AxiomDef adef -> process_axiom_def adef  (* An Hoa *)
      | _ -> ()) cmds;
  (* An Hoa : Parsing is completed. If there is undefined type, report error.
   * Otherwise, we perform second round checking!
   *)
  let udefs = !Astsimp.undef_data_types in
  let _ = match udefs with
    | [] ->	perform_second_parsing_stage ()
    | _ -> let udn,udp = List.hd (List.rev udefs) in
      Error.report_error { Error.error_loc  = udp;
      Error.error_text = "Data type " ^ udn ^ " is undefined!" }
  in ();
  Debug.tinfo_pprint "sleek : after 2nd parsing" no_pos;
  convert_data_and_pred_to_cast ();
  Debug.tinfo_pprint "sleek : after convert_data_and_pred_to_cast" no_pos;
   (*proc_one_lemma*)
  List.iter (fun c->  match c with
      | LemmaDef ldef -> process_lemma ldef
      | _ -> ()) cmds;
  Debug.tinfo_pprint "sleek : after proc one lemma" no_pos;
  (*identify universal variables*)
  let cviews = !cprog.C.prog_view_decls in
  let cviews = List.map (Cast.add_uni_vars_to_view !cprog !cprog.C.prog_left_coercions) cviews in
  !cprog.C.prog_view_decls <- cviews;
  (*proc_one_cmd*) 
  List.fold_left (fun a c-> match c with 
      | EntailCheck (iante, iconseq, etype) -> (process_entail_check iante iconseq etype) && a
      | EqCheck (lv, if1, if2) -> (process_eq_check lv if1 if2; a)
      | Infer (ivars, iante, iconseq) -> (process_infer ivars iante iconseq) && a
      | CaptureResidue lvar -> (process_capture_residue lvar; a)
      | PrintCmd pcmd -> (process_print_command pcmd; a)
      | CmpCmd ccmd -> (process_cmp_command ccmd; a)
      | LetDef (lvar, lbody) -> (put_var lvar lbody; a)
      | BarrierCheck bdef -> (process_barrier_def bdef; a)
      | Time (b,s,_) -> 
            (if b then Gen.Profiling.push_time s 
            else Gen.Profiling.pop_time s; a)
      | _ -> a) true cmds 


let process_cmd (cmd_string:string) (flush_context:bool)= 
	Globals.silence_output := true;
	let _ = if flush_context then begin
		let _ = clear_all () in
		let _ = process_data_def (I.b_data_constr b_datan []) in
		let _ = I.inbuilt_build_exc_hierarchy () in (* for inbuilt control flows *)
		let _ = Iast.build_exc_hierarchy true iprog in
		let _ = exlist # compute_hierarchy  in  
		()
		end 
    else () in
	let cmd = NF.list_parse_string cmd_string in (*cmd list*)	
	process_cmd_list cmd 
	  
	  
let () =
	  Callback.register "sleek_process_cmd" process_cmd ;
      Callback.register "sleeklib_init" sleeklib_init ;
      Callback.register "sleeklib_stop" sleeklib_stop
	  
