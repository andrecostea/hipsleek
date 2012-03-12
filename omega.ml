(*
  Call Omega Calculator, send input to it
*)
open Globals
open Gen.Basic
open Cpure

module CP = Cpure

let set_generated_prover_input = ref (fun _ -> ())
let set_prover_original_output = ref (fun _ -> ())

let omega_call_count: int ref = ref 0
let is_omega_running = ref false
let in_timeout = ref 15.0 (* default timeout is 15 seconds *)

(***********)
let test_number = ref 0
let last_test_number = ref 0
let log_all_flag = ref false
let omega_restart_interval = ref (-1)
let log_all = open_out ("allinput.oc" (* ^ (string_of_int (Unix.getpid ())) *) )

(* currently not used --should be removed*)
let infilename = ref (!tmp_files_path ^ "input.oc." ^ (string_of_int (Unix.getpid ())))
let resultfilename = ref (!tmp_files_path ^ "result.txt." ^ (string_of_int (Unix.getpid())))

(*let oc_maxVars = ref 1024*)
let print_pure = ref (fun (c:formula)-> " printing not initialized")

let process = ref {name = "omega"; pid = 0;  inchannel = stdin; outchannel = stdout; errchannel = stdin}

let init_files () =
  begin
	infilename := "input.oc." ^ (string_of_int (Unix.getpid ()));
	resultfilename := "result.txt." ^ (string_of_int (Unix.getpid()));
  end

let omega_of_spec_var (sv : spec_var):string = match sv with
  | SpecVar (t, v, p) -> 
		let r = match (List.filter (fun (a,b,_)-> ((String.compare v b)==0) )!omega_subst_lst) with
				  | []->           
            let ln = (String.length v) in  
            let r_c = if (ln<15) then v
              else 
                let v_s = String.sub v (ln-15)  15 in
                if((String.get v_s 0)=='_') then String.sub v_s 1 ((String.length v_s)-1) else v_s in
            begin
              omega_subst_lst := (r_c,v,t)::!omega_subst_lst; 
							r_c end
					| (a,b,_)::h->  a in 
		r ^ (if is_primed sv then Oclexer.primed_str else "")


let rec omega_of_exp e0 = match e0 with
  | Null _ -> "0"
  | Var (sv, _) -> omega_of_spec_var sv
  | IConst (i, _) -> string_of_int i 
  | AConst (i, _) -> string_of_int(int_of_heap_ann i) 
  | Add (a1, a2, _) ->  (omega_of_exp a1)^ " + " ^(omega_of_exp a2) 
  | Subtract (a1, a2, _) ->  (omega_of_exp a1)^ " - " ^"("^(omega_of_exp a2)^")"
  | Mult (a1, a2, l) ->
      let r = match a1 with
        | IConst (i, _) -> (string_of_int i) ^ "(" ^ (omega_of_exp a2) ^ ")"
        | _ -> let rr = match a2 with
            | IConst (i, _) -> (string_of_int i) ^ "(" ^ (omega_of_exp a1) ^ ")"
            | _ -> illegal_format "[omega.ml] Non-linear arithmetic is not supported by Omega."
                (* Error.report_error { *)
                (*   Error.error_loc = l; *)
                (*   Error.error_text = "[omega.ml] Non-linear arithmetic is not supported by Omega." *)
                (* } *)
            in rr
      in r
  | Div (_, _, l) -> illegal_format "[omega.ml] Divide is not supported."
      (* Error.report_error { *)
      (*   Error.error_loc = l; *)
      (*   Error.error_text ="[omega.ml] Divide is not supported." *)
      (* } *)
  | Max _
  | Min _ -> illegal_format ("Omega.omega_of_exp: min/max should not appear here")
  | FConst _ -> illegal_format ("Omega.omega_of_exp: FConst")
  | Func _ -> "0" (* TODO: Need to handle *)
  | _ -> illegal_format ("Omega.omega_of_exp: array, bag or list constraint")
(*
(ArrayAt _|ListReverse _|ListAppend _|ListLength _|ListTail _|ListHead _|
ListCons _|List _|BagDiff _|BagIntersect _|BagUnion _|Bag _|FConst _)
*)

and omega_of_b_formula b =
  let (pf, _) = b in
  match pf with
  | BConst (c, _) -> if c then "(0=0)" else "(0>0)"
  | BVar (bv, _) ->  (omega_of_spec_var bv) ^ " > 0" (* easy to track boolean var *)
  | Lt (a1, a2, _) ->(omega_of_exp a1) ^ " < " ^ (omega_of_exp a2)
  | Lte (a1, a2, _) -> (omega_of_exp a1) ^ " <= " ^ (omega_of_exp a2)
  | Gt (a1, a2, _) ->  (omega_of_exp a1) ^ " > " ^ (omega_of_exp a2)
  | Gte (a1, a2, _) -> (omega_of_exp a1) ^ " >= " ^ (omega_of_exp a2)
  | SubAnn (a1, a2, _) -> (omega_of_exp a1) ^ " <= " ^ (omega_of_exp a2)
  (* | LexVar (_, a1, a2, _) -> "(0=0)" *)
  | Eq (a1, a2, _) -> begin
        if is_null a2 then	(omega_of_exp a1) ^ " < 1" (* " = 0 " *)
        else if is_null a1 then (omega_of_exp a2) ^ " < 1" (* " = 0 " *)
        else (omega_of_exp a1) ^ " = " ^ (omega_of_exp a2)
  end
  | Neq (a1, a2, _) -> begin
        if is_null a2 then
          (omega_of_exp a1) ^ " > 0"
        else if is_null a1 then						
        	(omega_of_exp a2) ^ " > 0"
        else (omega_of_exp a1) ^ " != " ^ (omega_of_exp a2)
    end
  | EqMax (a1, a2, a3, _) ->
      let a1str = omega_of_exp a1 in
      let a2str = omega_of_exp a2 in
      let a3str = omega_of_exp a3 in
        "((" ^ a2str ^ " >= " ^ a3str ^ " & " ^ a1str ^ " = " ^ a2str ^ ") | ("
        ^ a3str ^ " > " ^ a2str ^ " & " ^ a1str ^ " = " ^ a3str ^ "))"
  | EqMin (a1, a2, a3, _) ->
      let a1str = omega_of_exp a1  in
      let a2str = omega_of_exp a2  in
      let a3str = omega_of_exp a3  in
        "((" ^ a2str ^ " >= " ^ a3str ^ " & " ^ a1str ^ " = " ^ a3str ^ ") | ("
        ^ a3str ^ " > " ^ a2str ^ " & " ^ a1str ^ " = " ^ a2str ^ "))"
  | RelForm _ -> illegal_format ("Omega.omega_of_exp: RelForm")
  | LexVar _ -> illegal_format ("Omega.omega_of_exp: LexVar")
  | _ -> illegal_format ("Omega.omega_of_exp: bag or list constraint")
 
(* and omega_of_formula f  = *)
(*   let rec helper f =  *)
(*     match f with *)
(*   | BForm (b,_) -> 		"(" ^ (omega_of_b_formula b) ^ ")" *)
(*   | And (p1, p2, _) -> 	"(" ^ (helper p1) ^ " & " ^ (helper p2 ) ^ ")" *)
(*   | Or (p1, p2,_ , _) -> 	"(" ^ (helper p1) ^ " | " ^ (helper p2) ^ ")" *)
(*   | Not (p,_ , _) ->       " (not (" ^ (helper p) ^ ")) "	 *)
(*   | Forall (sv, p,_ , _) -> " (forall (" ^ (omega_of_spec_var sv) ^ ":" ^ (helper p) ^ ")) " *)
(*   | Exists (sv, p,_ , _) -> " (exists (" ^ (omega_of_spec_var sv) ^ ":" ^ (helper p) ^ ")) " *)
(*   in helper f *)

and omega_of_formula_old f  =
  let (pr_w,pr_s) = no_drop_ops in
  try 
    Some (omega_of_formula pr_w pr_s f)
  with | _ -> None

and omega_of_formula pr_w pr_s f  =
  let rec helper f = 
    match f with
  | BForm ((b,_) as bf,_) -> 		
        begin
          match (pr_w b) with
            | None -> "(" ^ (omega_of_b_formula bf) ^ ")"
            | Some f -> helper f
        end
  | And (p1, p2, _) -> 	"(" ^ (helper p1) ^ " & " ^ (helper p2 ) ^ ")"
  | Or (p1, p2,_ , _) -> 	"(" ^ (helper p1) ^ " | " ^ (helper p2) ^ ")"
  | Not (p,_ , _) ->       " (not (" ^ (omega_of_formula pr_s pr_w p) ^ ")) "	
  | Forall (sv, p,_ , _) -> " (forall (" ^ (omega_of_spec_var sv) ^ ":" ^ (helper p) ^ ")) "
  | Exists (sv, p,_ , _) -> " (exists (" ^ (omega_of_spec_var sv) ^ ":" ^ (helper p) ^ ")) "
  in helper f

let omega_of_formula i pr_w pr_s f  =
  let pr = !print_formula in
  Debug.no_1_num i "omega_of_formula" 
      pr pr_id (fun _ -> omega_of_formula pr_w pr_s f) f

(* let omega_of_formula_old i f  = *)
(*   let pr = !print_formula in *)
(*   Debug.no_1_num i "omega_of_formula_old"  *)
(*       pr pr_id (fun _ -> omega_of_formula_old f) f *)

let omegacalc = ref ("oc":string)
(*let modified_omegacalc = "/usr/local/bin/oc5"*)
(* TODO: fix oc path *)
(*let omegacalc = "/home/locle/workspace/hg/error_specs/sleekex/omega_modified/omega_calc/obj/oc"*)

let start_with str prefix =
  (String.length str >= String.length prefix) && (String.sub str 0 (String.length prefix) = prefix) 
let send_cmd cmd =
  if !is_omega_running then output_string (!process.outchannel) (cmd ^ "\n")

let set_process (proc: Globals.prover_process_t) = 
  process := proc

let prelude () =
  let finished = ref false in
  while not !finished do
    let line = input_line (!process.inchannel) in
	  (*let _ = print_endline line in *)
	(if !log_all_flag then
          output_string log_all ("[omega.ml]: >> " ^ line ^ "\nOC is running\n") );
    if (start_with line "#") then finished := true;
  done

  (* start omega system in a separated process and load redlog package *)
let start() =
  if not !is_omega_running then begin
      print_endline ("Starting Omega..." ^ !omegacalc); flush stdout;
      last_test_number := !test_number;
      let _ = Procutils.PrvComms.start !log_all_flag log_all ("omega", !omegacalc, [||]) set_process prelude in
      is_omega_running := true;
  end

(* stop Omega system *)
let stop () =
  if !is_omega_running then begin
    let num_tasks = !test_number - !last_test_number in
    print_string ("Stop Omega... "^(string_of_int !omega_call_count)^" invocations "); flush stdout;
    let _ = Procutils.PrvComms.stop !log_all_flag log_all !process num_tasks Sys.sigkill (fun () -> ()) in
    is_omega_running := false;
  end

(* restart Omega system *)
let restart reason =
  if !is_omega_running then begin
    let _ = print_string (reason^" Restarting Omega after ... "^(string_of_int !omega_call_count)^" invocations ") in
    Procutils.PrvComms.restart !log_all_flag log_all reason "omega" start stop
  end
  else begin
    let _ = print_string (reason^" not restarting Omega ... "^(string_of_int !omega_call_count)^" invocations ") in ()
    end

(*
  - in: input channel
  - out: receiving msg
  - Desc: read from the channel, return the msg
*)
let read_from_in_channel chn : string =
  let res = ref "" in
  let quitloop = ref false in
  while not !quitloop do
	let line = input_line chn in
    let n = String.length line in
    if n > 0 then begin
		(* print_string (line^"\n"); flush stdout;*)
        (if !log_all_flag then
              output_string log_all ("[omega.ml]: >> "^line^"\n") );
        if line.[0] != '#' then
		  begin
              res := !res ^ line;
              if (line.[n-1] == '}') then
		        quitloop := true;
          end;
    end;
  done;
  !res

(*
  - in: input channel
  - out: last non-comment line of the input channel
  - Desc: read from the channel, return the last line
*)	
let read_last_line_from_in_channel chn : string =
  let line = ref "" in
  let quitloop = ref false in
  while not !quitloop do
	line := (input_line chn);
      let n = String.length !line in
      if n > 0 then begin
		  (* print_string (line^"\n"); flush stdout;*)
          (if !log_all_flag then 
                output_string log_all ("[omega.ml]: >> "^(!line)^"\n") );
          if !line.[0] != '#' then
		    begin
                if(!line.[n-1] == '}') then
		          quitloop := true;
            end;
      end;
  done;
  !line

(* send formula to omega and receive result -true/false*)
let check_formula f timeout =
  (*  try*)
  begin
      if not !is_omega_running then start ()
      else if (!omega_call_count = !omega_restart_interval) then
        begin
	        restart("Regularly restart:1 ");
	        omega_call_count := 0;
        end;
      let fnc f = 
        (*let _ = print_endline "check" in*)
        let _ = incr omega_call_count in
        let new_f = Gen.break_lines_1024 f
        (*  if ((String.length f) > 1024) then
	        (Gen.break_lines_1024 f)
          else
	        f *)
        in
        output_string (!process.outchannel) new_f;
        flush (!process.outchannel);
        
        let result = ref true in
        let str = read_last_line_from_in_channel (!process.inchannel) in
        (* An Hoa : set original output *)
        let _ = !set_prover_original_output str in
        let n = String.length str in
        if n > 7 then
          begin
	          let lastchars = String.sub str (n - 7) 7 in
	          if lastchars = "FALSE }" then
	            begin
                    result := false;
	            end;
          end;
        !result
      in
      let fail_with_timeout () = 
        restart ("[omega.ml]Timeout when checking sat!" ^ (string_of_float timeout));
        true (* it was checking for sat*) in
      if not (!dis_provers_timeout) then 
        let res = Procutils.PrvComms.maybe_raise_and_catch_timeout_string_bool fnc f timeout fail_with_timeout in 
        res
      else fnc f
  end

(*
let check_formula f timeout =
  Gen.Profiling.push_time ("stat_omega [check_formula]");
  let r = check_formula f timeout in
  Gen.Profiling.pop_time ("stat_omega [check_formula]");
  r
*)

let check_formula i f timeout =
  Debug.no_2 "[omega.ml]check_formula" (fun x->x) string_of_float string_of_bool
      check_formula f timeout

(* linear optimization with omega *)
let rec send_and_receive f timeout =
  begin
      if not !is_omega_running then
        start (); 
      if (!omega_call_count = !omega_restart_interval) then
        begin
            restart ("Regularly restart:2");
	        omega_call_count := 0;
	    end;
      let fnc () =
        let _ = incr omega_call_count in
        let new_f = Gen.break_lines_1024 f
        (*  if ((String.length f) > 1024) then
            (Gen.break_lines_1024 f)
          else
            f *)
        in
        output_string (!process.outchannel) new_f;
        flush (!process.outchannel);
	    let str = read_from_in_channel (!process.inchannel) in
	    
        let lex_buf = Lexing.from_string str in
	  (*print_string (line^"\n"); flush stdout;*)
        let rel = Ocparser.oc_output (Oclexer.tokenizer "interactive") lex_buf in
        rel
      in
      let answ = Procutils.PrvComms.maybe_raise_timeout_num 3 fnc () timeout in
      answ
          
  end

(*
let send_and_receive f timeout =
  Gen.Profiling.push_time ("stat_omega [send_end_receive]");
  let r = send_and_receive f timeout in
  Gen.Profiling.pop_time ("stat_omega [send_end_receive]");
  r
*)

let send_and_receive f timeout =
  let pr x = x in
  let pr2 = Cpure.string_of_relation in
  Debug.no_2 "Omega:send_and_receive" pr string_of_float pr2 send_and_receive f timeout 

(********************************************************************)
let rec omega_of_var_list (vars : ident list) : string = match vars with
  | [] -> ""
  | [v] -> v
  | v :: rest -> v ^ ", " ^ (omega_of_var_list rest)

let get_vars_formula (p : formula):(string list) =
  let svars = fv p in
  (*if List.length svars >= !oc_maxVars then (false, []) else*)
  List.map omega_of_spec_var svars

(*
  Use Omega Calculator to test if a formula is valid -- some other
  tool may probably be used ...
*)

let is_sat_ops pr_weak pr_strong (pe : formula)  (sat_no : string): bool =
  (*print_endline (Gen.new_line_str^"#is_sat " ^ sat_no ^ Gen.new_line_str);*)
  incr test_number;
  begin
        (*  Cvclite.write_CVCLite pe; *)
        (*  Lash.write pe; *)
    let pvars = get_vars_formula pe in
    (*if not safe then true else*)
      begin
          omega_subst_lst := [];
          let vstr = omega_of_var_list (Gen.BList.remove_dups_eq (=) pvars) in
          (* let obj_vars = CP.collect_obj_var pe in
          let inv = List.fold_left (fun a v -> CP.mkAnd a (CP.mkInv_obj_var v) no_pos) (CP.mkTrue no_pos) obj_vars in
          let pe = CP.mkAnd pe inv no_pos in *)
          let fstr = omega_of_formula 1 pr_weak pr_strong pe in
          let fomega =  "{[" ^ vstr ^ "] : (" ^ fstr ^ ")};" ^ Gen.new_line_str in

          if !log_all_flag then begin
              output_string log_all (Gen.new_line_str^"#is_sat " ^ sat_no ^ Gen.new_line_str);
              output_string log_all (Gen.break_lines_1024 fomega);
              flush log_all;
          end;

	      let sat =
            try
                check_formula 1 fomega !in_timeout
            with
              | End_of_file ->
                  (*let _ = print_endline "SAT: End_of_file" in*)
                  restart ("End_of_file when checking #SAT \n");
                  true
              | exc ->
                  begin
                      Printf.eprintf "SAT Unexpected exception : %s" (Printexc.to_string exc);
                      stop (); raise exc
                      (* restart ("Unexpected exception when doing IMPLY "); *)
                      (* true *)
                  end
          in
  (*   let post_time = Unix.gettimeofday () in *)
  (*   let time = (post_time -. pre_time) *. 1000. in *)

          if !log_all_flag = true then begin
              if sat then output_string log_all ("[omega.ml]: unsat "^sat_no ^(string_of_int !test_number)^" --> FAIL\n") 
              else output_string log_all ("[omega.ml]: sat "^sat_no^(string_of_int !test_number)^" --> SUCCESS\n");
          end else ();
          sat
      end
  end

let is_sat (pe : formula)  (sat_no : string): bool =
  let pr x = None in
  is_sat_ops pr pr pe sat_no

let is_sat (pe : formula)  (sat_no : string): bool =
  let pf = !print_pure in
  Debug.no_1 "Omega.is_sat" pf (string_of_bool) (fun _ -> is_sat pe sat_no) pe

let is_sat_weaken (pe : formula)  (sat_no : string): bool =
  let pe = drop_rel_formula pe in
  is_sat pe sat_no

let is_sat_with_check pr_weak pr_strong (pe : formula) sat_no : bool option =
  do_with_check "" (fun x -> is_sat_ops pr_weak pr_strong x sat_no) pe

let is_sat_with_check pr_weak pr_strong (pe : formula) sat_no : bool option =
  let pf = !print_pure in
  Debug.no_1 "Omega.is_sat_with_check" pf (pr_option string_of_bool) 
  (fun _ -> is_sat_with_check pr_weak pr_strong pe sat_no) pe

let is_sat (pe : formula) sat_no : bool =
  try
    is_sat pe sat_no
  with Illegal_Prover_Format s -> 
      begin
        print_endline ("\nWARNING : Illegal_Prover_Format for :"^s);
        print_endline ("Apply Omega.is_sat on formula :"^(!print_pure pe));
        flush stdout;
        failwith s
      end

let is_valid_ops_x pr_weak pr_strong (pe : formula) timeout: bool =
  (*print_endline "LOCLE: is_valid";*)
  begin
      let pvars = get_vars_formula pe in
      (*if not safe then true else*)
        begin
	          omega_subst_lst := [];
            let fstr = omega_of_formula 2 pr_strong pr_weak pe in
            let vstr = omega_of_var_list (Gen.BList.remove_dups_eq (=) pvars) in
            let fomega =  "complement {[" ^ vstr ^ "] : (" ^ fstr ^ ")}" ^ ";" ^ Gen.new_line_str in
    (*test*)
	(*print_endline (Gen.break_lines fomega);*)
			(* An Hoa : set generated input *)
			let _ = !set_generated_prover_input fomega in
            if !log_all_flag then begin
                (*output_string log_all ("YYY" ^ (Cprinter.string_of_pure_formula pe) ^ "\n");*)
                output_string log_all (Gen.new_line_str^"#is_valid" ^Gen.new_line_str);
                output_string log_all (Gen.break_lines_1024 fomega);
                flush log_all;
            end;

	        let sat =
              try
                  not (check_formula 2 (fomega ^ "\n") !in_timeout)
              with
                | End_of_file ->
                    (*let _ = print_endline "IMPLY: End_of_file" in*)
                    restart ("IMPLY : End_of_file when checking \n");
                    false
                | exc ->
                    begin
                        Printf.eprintf "IMPLY : Unexpected exception : %s" (Printexc.to_string exc);
                        stop (); raise exc
          (* restart ("Unexpected exception when doing IMPLY "); *)
            (* false *)
                    end
            in
  (*   let post_time = Unix.gettimeofday () in *)
  (*   let time = (post_time -. pre_time) *. 1000. in *)

            sat
        end
  end

(* let is_valid (pe : formula) timeout: bool = *)
(*   let pr x = None in *)
(*   is_valid_ops pr pr pe timeout *)

let is_valid_ops pr_weak pr_strong (pe : formula) timeout: bool =
  let pf = !print_pure in
  Debug.no_1 "Omega.is_valid" pf (string_of_bool) (fun _ -> is_valid_ops_x pr_weak pr_strong pe timeout) pe

let is_valid_with_check_ops pr_w pr_s (pe : formula) timeout : bool option =
  do_with_check "" (fun x -> is_valid_ops pr_w pr_s x timeout) pe

let is_valid_with_default_ops pr_w pr_s (pe : formula) timeout : bool =
  do_with_check_default "" (fun x -> is_valid_ops pr_w pr_s x timeout) pe false


(* let is_valid (pe : formula) timeout : bool = *)
(*   do_with_check_default "Omega is_valid"  *)
(*       (fun x -> is_valid x timeout) pe false *)

let imply_ops pr_weak pr_strong (ante : formula) (conseq : formula) (imp_no : string) timeout : bool =
  (*print_endline "LOCLE: imply";*)
  incr test_number;
  (*
    let tmp1 = mkAnd ante (mkNot conseq no_pos) no_pos in
    let fvars = fv tmp1 in
    let tmp2 = mkExists fvars tmp1 no_pos in
    not (is_valid tmp2)
   *)
  (* 
  let obj_vars = CP.collect_obj_var ante in
  let inv = List.fold_left (fun a v -> CP.mkAnd a (CP.mkInv_obj_var v) no_pos) (CP.mkTrue no_pos) obj_vars in
  let ante = CP.mkAnd ante inv no_pos in
  *)
  let tmp_form = mkOr (mkNot ante None no_pos) conseq None no_pos in
  	
  let result = is_valid_ops pr_weak pr_strong tmp_form !in_timeout in
  if !log_all_flag = true then begin
    if result then 
      output_string log_all ("[omega.ml]: imp #" ^ imp_no ^ "-- test #" ^(string_of_int !test_number)^" --> SUCCESS\n") 
    else 
      output_string log_all ("[omega.ml]: imp "^imp_no^(string_of_int !test_number)^" --> FAIL\n");
  end else ();
  result

let imply (ante : formula) (conseq : formula) (imp_no : string) timeout : bool =
  let (pr_w,pr_s) = drop_complex_ops in
  imply_ops pr_w pr_s (ante : formula) (conseq : formula) (imp_no : string) timeout 

let imply_with_check pr_weak pr_strong (ante : formula) (conseq : formula) (imp_no : string) timeout: bool option =
  do_with_check2 "" (fun a c -> imply_ops pr_weak pr_strong a c imp_no timeout) ante conseq

let imply_ops pr_weak pr_strong (ante : formula) (conseq : formula) (imp_no : string) timeout: bool =
  try
    imply_ops pr_weak pr_strong ante conseq imp_no timeout
  with Illegal_Prover_Format s -> 
      begin
        print_endline ("\nWARNING : Illegal_Prover_Format for :"^s);
        print_endline ("Apply Omega.imply on ante Formula :"^(!print_pure ante));
		print_endline ("and conseq Formula :"^(!print_pure conseq));
        flush stdout;
        failwith s
      end

let is_valid (pe : formula) timeout : bool =
  let (pr_w,pr_s) = drop_complex_ops in
  try
    is_valid_ops pr_w pr_s pe timeout
  with Illegal_Prover_Format s -> 
      begin
        print_endline ("\nWARNING : Illegal_Prover_Format for :"^s);
        print_endline ("Apply Omega.is_valid on Formula :"^(!print_pure pe));
        flush stdout;
        failwith s
      end

let rec match_vars (vars_list0 : spec_var list) rel =
  (* let vars_list0 = vars_list0 in *)
  match rel with
| ConstRel b ->
    if b then
      mkTrue no_pos
    else
      mkFalse no_pos
| BaseRel (aelist0, f0) ->
    let rec match_helper vlist aelist f  = match aelist with
    | [] -> f
    | ae :: rest ->
        let v = List.hd vlist in
        let restvars = List.tl vlist in
        let restf = match_helper restvars rest f in
        let tmp1 = mkEqExp (Var (v, no_pos)) ae no_pos in
        let tmp2 = mkAnd tmp1 restf no_pos in
        tmp2
    in
    if List.length aelist0 != List.length vars_list0 then
      illegal_format ("match_var: numbers of arguments do not match")
    else
      match_helper vars_list0 aelist0 f0
| UnionRel (r1, r2) ->
    let f1 = match_vars vars_list0 r1 in
    let f2 = match_vars vars_list0 r2 in
    let tmp = mkOr f1 f2 None no_pos in
    tmp


let simplify_ops pr_weak pr_strong (pe : formula) : formula =
  (* print_endline "LOCLE: simplify";*)
  (* let _ = print_string ("\nomega_simplify: f before"^(!print_formula pe)) in *)
  begin
    let v = try 
      (* Debug.info_pprint "here1" no_pos; *)
      Some (omega_of_formula 8 pr_weak pr_strong pe)
    with | Illegal_Prover_Format s -> 
        (* Debug.info_pprint "here1a" no_pos;  *)
        None
    in
    match v with
      | None -> pe
      | Some fstr ->
            (* Debug.info_pprint "here2" no_pos; *)
          omega_subst_lst := [];
            let vars_list = get_vars_formula pe in
            (*todo: should fix in code of OC: done*)
            (*if not safe then pe else*)
            begin
              try
                  let vstr = omega_of_var_list (Gen.BList.remove_dups_eq (=) vars_list) in
                  let fomega =  "{[" ^ vstr ^ "] : (" ^ fstr ^ ")};" ^ Gen.new_line_str in
	              (*test*)
	              (*print_endline (Gen.break_lines fomega);*)
                  if !log_all_flag then begin
                    (*                output_string log_all ("YYY" ^ (Cprinter.string_of_pure_formula pe) ^ "\n");*)
                    output_string log_all ("#simplify" ^ Gen.new_line_str ^ Gen.new_line_str);
                    output_string log_all ((Gen.break_lines_1024 fomega) ^ Gen.new_line_str ^ Gen.new_line_str);
                    flush log_all;
                  end;
                  let simp_f =
	                try
                      begin
	                    let rel = send_and_receive fomega !in_timeout (* 0.0  *)in
                        (* let _ = print_endline ("after simplification: " ^ (Cpure.string_of_relation rel)) in *)
	                    match_vars (fv pe) rel
	                  end
	                with
                      | Procutils.PrvComms.Timeout ->
                            (*log ERROR ("TIMEOUT");*)
                            restart ("Timeout when checking #simplify ");
                            pe
                      | End_of_file ->
                            restart ("End_of_file when checking #simplify \n");
                            pe
                      | exc -> (* stop (); raise exc  *)
                            begin
                              Printf.eprintf "Unexpected exception : %s" (Printexc.to_string exc);
                              restart ("Unexpected exception when checking #simplify\n ");
                              pe
                            end
                  in
                  (*   let post_time = Unix.gettimeofday () in *)
                  (*   let time = (post_time -. pre_time) *. 1000. in *)
                  (*let _ = print_string ("\nomega_simplify: f after"^(omega_of_formula simp_f)) in*)
                  simp_f
              with _ -> pe (* not simplified *)
            end
  end

let simplify (pe : formula) : formula =
  let pr x = None in 
  simplify_ops pr pr pe

let simplify (pe : formula) : formula =
  let pf = !print_pure in
  Debug.no_1 "Omega.simplify" pf pf simplify pe


(* let simplify_ho is_complex (orig_pe : formula) : formula = *)
(*  (\* print_endline "LOCLE: simplify";*\) *)
(*   (\*let _ = print_string ("\nomega_simplify: f before"^(omega_of_formula pe)) in*\) *)
(*   begin *)
(*     let (pe,subs,bvars) = memoise_formula_ho is_complex orig_pe in *)
(*     let (pr_weak,pr_strong) = no_drop_ops in *)
(*     let vars_list = get_vars_formula pe in *)
(*     (\*todo: should fix in code of OC: done*\) *)
(*     (\*if not safe then pe else*\) *)
(*     begin *)
(*       try *)
(*         omega_subst_lst := []; *)
(*         let fstr = omega_of_formula pr_weak pr_strong pe in *)
(*         let vstr = omega_of_var_list (Gen.BList.remove_dups_eq (=) vars_list) in *)
(*         let fomega =  "{[" ^ vstr ^ "] : (" ^ fstr ^ ")};" ^ Gen.new_line_str in *)
(* 	(\*test*\) *)
(* 	(\*print_endline (Gen.break_lines fomega);*\) *)
(*         if !log_all_flag then begin *)
(* (\*                output_string log_all ("YYY" ^ (Cprinter.string_of_pure_formula pe) ^ "\n");*\) *)
(*             output_string log_all ("#simplify" ^ Gen.new_line_str ^ Gen.new_line_str); *)
(*             output_string log_all ((Gen.break_lines_1024 fomega) ^ Gen.new_line_str ^ Gen.new_line_str); *)
(*             flush log_all; *)
(*         end; *)
(*         let simp_f = *)
(* 	      try *)
(*               begin *)
(* 	              let rel = send_and_receive fomega !in_timeout (\* 0.0  *\)in *)
(* 	              let new_pe = match_vars (fv pe) rel in *)
(*                   restore_memo_formula subs bvars new_pe  *)
(*                   (\* restore the extracted term and bool vars*\) *)
(* 	          end *)
(* 	      with *)
(*             | Procutils.PrvComms.Timeout -> *)
(*           (\*log ERROR ("TIMEOUT");*\) *)
(*                 restart ("Timeout when checking #simplify "); *)
(*                 orig_pe *)
(*             | End_of_file -> *)
(*                 restart ("End_of_file when checking #simplify \n"); *)
(*                 orig_pe *)
(*             | exc -> (\* stop (); raise exc  *\) *)
(*                 begin *)
(*                     Printf.eprintf "Unexpected exception : %s" (Printexc.to_string exc); *)
(*                     restart ("Unexpected exception when checking #simplify\n "); *)
(*                     orig_pe *)
(*                 end *)
(*         in *)
(*     (\*   let post_time = Unix.gettimeofday () in *\) *)
(*     (\*   let time = (post_time -. pre_time) *. 1000. in *\) *)
(*     (\*let _ = print_string ("\nomega_simplify: f after"^(omega_of_formula simp_f)) in*\) *)
(*         simp_f *)
(*       with _ -> orig_pe (\* not simplified *\) *)
(*     end *)
(*   end *)

(* (\* does not work since complex term may be *)
(*    inside quantifers, subst may involve name capture *\) *)
(* let simplify_clever (pe : formula) : formula = *)
(*   let is_complex b = match b with *)
(*     | LexVar _  *)
(*     | RelForm _ -> true *)
(*     | _ -> false *)
(*   in simplify_ho is_complex pe *)

(* (\* let simplify_with_check (pe : formula) : formula option = *\) *)
(* (\*   do_with_check "Omega simplify" simplify pe *\) *)


(* let simplify_memo (pe : formula) : formula = *)
(*   match (do_with_check "" simplify_clever pe) *)
(*   with  *)
(*     | None -> pe *)
(*     | Some f -> f *)

(* let simplify_memo (pe : formula) : formula = *)
(*   let pf = !print_pure in *)
(*   Debug.no_1 "Omega.simplify_memo" pf pf simplify_memo pe *)

let simplify (pe : formula) : formula =
  match (do_with_check "" simplify pe)
  with 
    | None -> pe
    | Some f -> f

let pairwisecheck (pe : formula) : formula =
  (* print_endline "LOCLE: pairwisecheck"; *)
  begin
	omega_subst_lst := [];
    match (omega_of_formula_old pe) with
      | None -> pe
      | Some fstr ->
            let vars_list = get_vars_formula pe in
            let vstr = omega_of_var_list (Gen.BList.remove_dups_eq (=) vars_list) in
            let fomega =  "pairwisecheck {[" ^ vstr ^ "] : (" ^ fstr ^ ")};" ^ Gen.new_line_str in
	        
	        (*test*)
	        (*print_endline (Gen.break_lines fomega);*)
	        
            if !log_all_flag then begin
              output_string log_all ("#pairwisecheck" ^ Gen.new_line_str ^ Gen.new_line_str);
              output_string log_all ((Gen.break_lines_1024 fomega) ^ Gen.new_line_str ^ Gen.new_line_str);
              flush log_all;
            end;
            let rel = send_and_receive fomega !in_timeout (* 0. *) in
	        match_vars (fv pe) rel 
  end

let hull (pe : formula) : formula =
  (*print_endline "LOCLE: hull";*)
  begin
	omega_subst_lst := [];
    match omega_of_formula_old pe with
      | None -> pe
      | Some fstr ->
            let vars_list = get_vars_formula pe in
            let vstr = omega_of_var_list (Gen.BList.remove_dups_eq (=) vars_list) in
            let fomega =  "hull {[" ^ vstr ^ "] : (" ^ fstr ^ ")};" ^ Gen.new_line_str in

	        (*test*)
	        (*print_endline (Gen.break_lines fomega);*)
	        
            if !log_all_flag then begin
              output_string log_all ("#hull" ^ Gen.new_line_str ^ Gen.new_line_str);
              output_string log_all ((Gen.break_lines_1024 fomega) ^ Gen.new_line_str ^ Gen.new_line_str);
              flush log_all;
            end;
            let rel = send_and_receive fomega !in_timeout (* 0. *) in
	        match_vars (fv pe) rel
  end

let gist (pe1 : formula) (pe2 : formula) : formula =
  (*print_endline "LOCLE: gist";*)
  begin
	omega_subst_lst := [];
    let fstr1 = omega_of_formula_old pe1 in
    let fstr2 = omega_of_formula_old pe2 in
    match fstr1,fstr2 with
      | Some fstr1, Some fstr2 ->
            begin
              let vars_list = remove_dups_svl (fv pe1 @ fv pe2) in
			  let l1 = List.map omega_of_spec_var vars_list  in
              let vstr = String.concat "," l1  in
              let fomega =  "gist {[" ^ vstr ^ "] : (" ^ fstr1
                ^ ")} given {[" ^ vstr ^ "] : (" ^ fstr2 ^ ")};" ^ Gen.new_line_str
              in
              if !log_all_flag then begin
                output_string log_all ("#gist" ^ Gen.new_line_str ^ Gen.new_line_str);
                output_string log_all ((Gen.break_lines_1024 fomega) ^ Gen.new_line_str ^ Gen.new_line_str);
                flush log_all;
              end;
              let rel = send_and_receive fomega !in_timeout (* 0.  *)in
	          match_vars vars_list rel
            end
      | _, _ -> pe1
  end

let log_mark (mark : string) =
  if !log_all_flag then begin
    output_string log_all ("#mark: " ^ mark ^ Gen.new_line_str ^ Gen.new_line_str);
    flush log_all;
  end;

