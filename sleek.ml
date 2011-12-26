(*
  Driver.


  loop
  . read command
  . switch <command>
    . data def
    . pred def
    . coercion
      call trans_data/trans_view/trans_coercion and update program
    . entailment check
      call trans_formula and heap_entail
  end loop
*)

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

module XF = Xmlfront
module NF = Nativefront


let usage_msg = Sys.argv.(0) ^ " [options] <source files>"

let source_files = ref ([] : string list)

let set_source_file arg = 
  source_files := arg :: !source_files

let print_version () =
  print_endline ("SLEEK: A Separation Logic Entailment Checker");
  print_endline ("Version 1.0");
  print_endline ("THIS SOFTWARE IS PROVIDED AS-IS, WITHOUT ANY WARRANTIES.");
  print_endline ("IT IS CURRENTLY FREE FOR NON-COMMERCIAL USE");
  print_endline ("Copyright @ PLS2 @ NUS")

let process_cmd_line () = Arg.parse Scriptarguments.sleek_arguments set_source_file usage_msg

let inter = Scriptarguments.inter

let prompt = ref "SLEEK> "
let terminator = '.'
module M = Lexer.Make(Token.Token)

(*This is overriden by the below*)
(* let parse_file (parse) (source_file : string) = *)
(* 	(\* let _ = print_endline "parse_file 1" in *\) *)
(* 	try *)
(* 		let cmds = parse source_file in  *)
(* 		let _ = (List.map (fun c -> ( *)
(* 							match c with *)
(* 								 | DataDef ddef -> process_data_def ddef *)
(* 								 | PredDef pdef -> process_pred_def pdef *)
(*				                 | RelDef rdef -> process_rel_def rdef *)
(*								 | AxiomDef adef -> process_axiom_def adef (* An Hoa : Bug detected in MUTUALLY DEPENDENT relations! *) *)
                 (* | Infer (ivars, iante, iconseq) -> process_infer ivars iante iconseq *)
(* 								 | CaptureResidue lvar -> process_capture_residue lvar *)
(* 								 | LemmaDef ldef -> process_lemma ldef *)
(* 								 | PrintCmd pcmd ->  *)
(*                                      let _ = print_string " I am here \n" in (\*LDK*\) *)
(*                                      process_print_command pcmd *)
(* 								 | LetDef (lvar, lbody) -> put_var lvar lbody *)
(*                  | Time (b,s,_) -> if b then Gen.Profiling.push_time s else Gen.Profiling.pop_time s *)
(* 								 | EmptyCmd -> ())) cmds) in () *)
(* 	with *)
(* 	  | End_of_file -> *)
(* 		  print_string ("\n") *)
(*     | M.Loc.Exc_located (l,t)->  *)
(*       (print_string ((Camlp4.PreCast.Loc.to_string l)^"\n error: "^(Printexc.to_string t)^"\n at:"^(Printexc.get_backtrace ())); *)
(*       raise t) *)

let parse_file (parse) (source_file : string) =
  let rec parse_first (cmds:command list) : (command list)  =
    try 
       parse source_file 
	with
	  | End_of_file -> List.rev cmds
      | M.Loc.Exc_located (l,t)-> 
            (print_string ((Camlp4.PreCast.Loc.to_string l)^"\n error: "^(Printexc.to_string t)^"\n at:"^(Printexc.get_backtrace ()));
            raise t) in
  let proc_one_def c = 
    match c with
	  | DataDef ddef -> process_data_def ddef
	  | PredDef pdef -> process_pred_def_4_iast pdef
      | RelDef rdef -> process_rel_def rdef
      | AxiomDef adef -> process_axiom_def adef  (* An Hoa *)
      (* | Infer (ivars, iante, iconseq) -> process_infer ivars iante iconseq *)
	  | LemmaDef _
      | Infer _
	  | CaptureResidue _
	  | LetDef _
	  | EntailCheck _
	  | PrintCmd _ 
      | Time _
	  | EmptyCmd -> () in
  let proc_one_lemma c = 
    match c with
	  | LemmaDef ldef -> process_lemma ldef
	  | DataDef _
	  | PredDef _
      | RelDef _
      | AxiomDef _ (* An Hoa *)
	  | CaptureResidue _
	  | LetDef _
	  | EntailCheck _
    | Infer _
	  | PrintCmd _ 
      | Time _
	  | EmptyCmd -> () in
  let proc_one_cmd c = 
    match c with
	  | EntailCheck (iante, iconseq) -> 
          (* let _ = print_endline ("proc_one_cmd: xxx_after parse \n") in *)
          process_entail_check iante iconseq
      | Infer (ivars, iante, iconseq) -> process_infer ivars iante iconseq
	  | CaptureResidue lvar -> process_capture_residue lvar
	  | PrintCmd pcmd -> process_print_command pcmd
	  | LetDef (lvar, lbody) -> put_var lvar lbody
      | Time (b,s,_) -> 
            if b then Gen.Profiling.push_time s 
            else Gen.Profiling.pop_time s
	  | DataDef _
	  | PredDef _
      | RelDef _
      | AxiomDef _ (* An Hoa *)
	  | LemmaDef _
	  | EmptyCmd -> () in
  let cmds = parse_first [] in
   List.iter proc_one_def cmds;
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
  convert_pred_to_cast ();
  List.iter proc_one_lemma cmds;
  (*identify universal variables*)
  let cviews = !cprog.C.prog_view_decls in
  let cviews = List.map (Cast.add_uni_vars_to_view !cprog !cprog.C.prog_left_coercions) cviews in
   !cprog.C.prog_view_decls <- cviews;
   List.iter proc_one_cmd cmds 


let main () = 
  let iprog = { I.prog_data_decls = [iobj_def];
                I.prog_global_var_decls = [];
                I.prog_enum_decls = [];
                I.prog_view_decls = [];
                I.prog_rel_decls = [];
                I.prog_rel_ids = [];
                I.prog_axiom_decls = []; (* [4/10/2011] An Hoa *)
                I.prog_proc_decls = [];
                I.prog_coercion_decls = [];
                I.prog_hopred_decls = [];
  } in
  let _ = I.inbuilt_build_exc_hierarchy () in (* for inbuilt control flows *)
  let _ = Iast.build_exc_hierarchy true iprog in
  let _ = exlist # compute_hierarchy  in
  (* let _ = print_endline ("GenExcNum"^(Exc.string_of_exc_list (1))) in *)
  let quit = ref false in
  let parse x =
    match !Scriptarguments.fe with
      | Scriptarguments.NativeFE -> NF.parse x
      | Scriptarguments.XmlFE -> XF.parse x in
  let parse x = Gen.Debug.no_1 "parse" pr_id string_of_command parse x in
  let buffer = Buffer.create 10240 in
    try
      if (!inter) then 
        while not (!quit) do
          if !inter then (* check for interactivity *)
            print_string !prompt;
          let input = read_line () in
          match input with
            | "" -> ()
            | _ -> 
              try
                let term_indx = String.index input terminator in
                let s = String.sub input 0 (term_indx+1) in
                Buffer.add_string buffer s;
                let cts = Buffer.contents buffer in
                if cts = "quit" || cts = "quit\n" then quit := true
                else try
                  let cmd = parse cts in
                  (match cmd with
                     | DataDef ddef -> process_data_def ddef
                     | PredDef pdef -> process_pred_def pdef
                     | RelDef rdef -> process_rel_def rdef
                     | AxiomDef adef -> process_axiom_def adef
                     | EntailCheck (iante, iconseq) -> process_entail_check iante iconseq
                     | Infer (ivars, iante, iconseq) -> process_infer ivars iante iconseq
                     | CaptureResidue lvar -> process_capture_residue lvar
                     | LemmaDef ldef ->   process_lemma ldef
                     | PrintCmd pcmd -> process_print_command pcmd
                     | LetDef (lvar, lbody) -> put_var lvar lbody
                     | Time (b,s,_) -> if b then Gen.Profiling.push_time s else Gen.Profiling.pop_time s
                     | EmptyCmd -> ());
                  Buffer.clear buffer;
                  if !inter then
                      prompt := "SLEEK> "
                with
                  | _ -> dummy_exception();
                print_string ("Error.\n");
                Buffer.clear buffer;
                if !inter then prompt := "SLEEK> "
              with 
                | SLEEK_Exception
                | Not_found -> dummy_exception();
              Buffer.add_string buffer input;
              Buffer.add_char buffer '\n';
              if !inter then prompt := "- "
        done
      else 
        (* let _ = print_endline "Prior to parse_file" in *)
        let _ = List.map (parse_file NF.list_parse) !source_files in ()
    with
      | End_of_file -> print_string ("\n")
      (* | Not_found -> print_string ("Not found exception caught!\n") *)

(* let main () =  *)
(*   Gen.Debug.loop_1_no "main" (fun () -> "?") (fun () -> "?") main () *)

let _ =
   wrap_exists_implicit_explicit := false ;
  process_cmd_line ();
  Scriptarguments.check_option_consistency ();
  if !Globals.print_version_flag then begin
	print_version ()
  end else
    let _ = Printexc.record_backtrace !Globals.trace_failure in
    (Tpdispatcher.start_prover ();
    Gen.Profiling.push_time "Overall";
    (* let _ = print_endline "before main" in *)
    main ();
    (* let _ = print_endline "after main" in *)
    Gen.Profiling.pop_time "Overall";
    let _ = 
      if (!Globals.profiling && not !inter) then 
        ( Gen.Profiling.print_info (); print_string (Gen.Profiling.string_of_counters ())) in
    Tpdispatcher.stop_prover ();
    print_string "\n")
