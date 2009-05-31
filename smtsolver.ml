(*
 * Author           : Wong Choon Teng Justin
 * Last modified    : Fri May 29 22:03:13 SGT 2009
 *
 * TODO:
 * Error checking(runProver)
 * Bag/Set constraints not handled
 * Check renaming of ?vars in exists
 *)

open Globals
module CP = Cpure

type smtlogic =
    | QF_LIA    (* Linear Integer Arithmetic *)
    | AUFLIA    (* LIA with quantifiers *)

let logic = ref QF_LIA

let string_of_logic arg =
    match arg with
        | QF_LIA -> "QF_LIA"
        | AUFLIA -> "AUFLIA"

(*
 * Temp files used to feed input and capture output from z3
 *)
let infile = "/tmp/in" ^ (string_of_int (Unix.getpid ())) ^ ".smt"
let outfile = "/tmp/out" ^ (string_of_int (Unix.getpid ()))


(*
 * Command used with Windows version of Z3
 * Ensure wine is installed and z3 and Microsoft.VC90.CRT is in path and linked with their respective files
 *)
let command = "z3 `winepath -w " ^ infile ^ "` | tr -d '\r' > " ^ outfile


(*
 * z3 of spec_var
 *)
let z3_of_spec_var (sv : CP.spec_var) =(*{{{{*)
    match sv with
        | CP.SpecVar (_, var, p) -> var ^ (if p=Primed then "'" else "")(*}}}*)

(*
 * z3 of spec_var
 *)
let rec z3_of_exp a =(*{{{*)
    match a with
        | CP.Null _               -> "0"
        | CP.Var (sv, _)          -> z3_of_spec_var sv
        | CP.IConst (i, _)        -> string_of_int i
        | CP.Add (a1, a2, _)      -> "(+ " ^(z3_of_exp a1)^ " " ^ (z3_of_exp a2)^")"
        | CP.Subtract (a1, a2, _) -> "(- " ^(z3_of_exp a1)^ " " ^ (z3_of_exp a2)^")"
        | CP.Mult (c, a, _)       -> "( * " ^(z3_of_exp a)^ " " ^ (string_of_int c)^")"
        (* UNHANDLED *)
        | CP.Bag ([], _) -> "0"
        | CP.Max _
        | CP.Min _ -> failwith ("Z3.z3_of_exp: min/max should not appear here")
        | CP.Bag _
        | CP.BagUnion _
        | CP.BagIntersect _
        | CP.BagDiff _ -> failwith ("[z3.ml]: ERROR in constraints (set should not appear here)")(*}}}*)

(*
 * z3 of spec_var
 *)
let rec z3_of_b_formula b (*{{{*)=
    match b with
        | CP.BConst (c, _)    -> if c then "true" else "false"
        | CP.BVar (sv, _)     -> "(= 1 " ^(z3_of_spec_var sv) ^ ")"
        | CP.Lt (a1, a2, _)   -> "(< " ^(z3_of_exp a1) ^ " " ^ (z3_of_exp a2) ^ ")"
        | CP.Lte (a1, a2, _)  -> "(<= " ^(z3_of_exp a1) ^ " " ^ (z3_of_exp a2) ^ ")"
        | CP.Gt (a1, a2, _)   -> "(> " ^(z3_of_exp a1) ^ " " ^ (z3_of_exp a2) ^ ")"
        | CP.Gte (a1, a2, _)  -> "(>= " ^(z3_of_exp a1) ^ " " ^ (z3_of_exp a2) ^ ")"
        | CP.Eq (a1, a2, _)   -> "(= " ^(z3_of_exp a1) ^ " " ^ (z3_of_exp a2) ^ ")"
        | CP.Neq (a1, a2, _)  ->
              if CP.is_null a2 then
                  "(> " ^(z3_of_exp a1)^ " 0)"
              else if CP.is_null a1 then
                  "(> " ^(z3_of_exp a2)^ " 0)"
              else
                  "(not (= " ^(z3_of_exp a1) ^ " " ^ (z3_of_exp a2) ^ "))"
        | CP.EqMax (a1, a2, a3, _) ->
              let a1str = z3_of_exp a1 in
              let a2str = z3_of_exp a2 in
              let a3str = z3_of_exp a3 in
                  "(or (and (= " ^ a1str ^ " " ^ a2str ^ ") (>= "^a2str^" "^a3str^")) (and (= " ^ a1str ^ " " ^ a3str ^ ") (< "^a2str^" "^a3str^")))"
        | CP.EqMin (a1, a2, a3, _) ->
              let a1str = z3_of_exp a1 in
              let a2str = z3_of_exp a2 in
              let a3str = z3_of_exp a3 in
                  "(or (and (= " ^ a1str ^ " " ^ a2str ^ ") (< "^a2str^" "^a3str^")) (and (= " ^ a1str ^ " " ^ a3str ^ ") (>= "^a2str^" "^a3str^")))"
        (* UNHANDLED *)
        | CP.BagIn (v, e, l)    -> " in(" ^ (z3_of_spec_var v) ^ ", " ^ (z3_of_exp e) ^ ")"
        | CP.BagNotIn (v, e, l) -> " NOT(in(" ^ (z3_of_spec_var v) ^ ", " ^ (z3_of_exp e) ^"))"
        | CP.BagSub (e1, e2, l) -> " subset(" ^ z3_of_exp e1 ^ ", " ^ z3_of_exp e2 ^ ")"
        | CP.BagMax _ | CP.BagMin _ -> failwith ("z3_of_b_formula: BagMax/BagMin should not appear here.\n")(*}}}*)


(*
 * z3 of spec_var
 *)
let rec z3_of_formula f =(*{{{*)
    match f with
        | CP.BForm b -> (z3_of_b_formula b)
        | CP.And (p1, p2, _) -> "(and " ^ (z3_of_formula p1) ^ " " ^ (z3_of_formula p2) ^ ")"
        | CP.Or (p1, p2, _) -> "(or " ^ (z3_of_formula p1) ^ " " ^ (z3_of_formula p2) ^ ")"
        | CP.Not (p, _) ->
              (match p with
                   | CP.BForm (CP.BVar (bv, _)) -> "(= 0 " ^ (z3_of_spec_var bv) ^ ")"
                   | _ -> "(not " ^ (z3_of_formula p) ^ ")")
        | CP.Forall (sv, p, _) ->
              logic := AUFLIA;
              "(forall (" ^ (z3_of_spec_var sv) ^ " Int) " ^ (z3_of_formula p) ^ ")"
        | CP.Exists (sv, p, _) ->
              logic := AUFLIA;
              "(exists (" ^ (z3_of_spec_var sv) ^ " Int) " ^ (z3_of_formula p) ^ ")"(*}}}*)

(* UNUSED *)
(*
 and z3_of_sv_type sv = match sv with(*{{{*)
 (*| CP.SpecVar (CP.Prim Bag, _, _) -> "SET" (*UNKNOWN*)*)
 | CP.SpecVar (CP.Prim Bool, _, _) -> "INT" (* "BOOLEAN" *)
 | _ -> "INT"(*}}}*)
 *)

(*
 * Converts a core pure formula into SMT-LIB format which can be run through various SMT provers.
 *)
let toSMT (ante : CP.formula) (conseq : CP.formula) : string =(*{{{*)
    logic := QF_LIA;
    let ante_fv = CP.fv ante in
    let conseq_fv = CP.fv conseq in
    let all_fv = CP.remove_dups (ante_fv @ conseq_fv) in

    let ante_str = (z3_of_formula ante) in
    let conseq_str = (z3_of_formula conseq) in

    let extrafuns =
        if (all_fv = []) then ""
        else ":extrafuns (" ^ (List.fold_left (fun x y -> x ^ "(" ^ y ^ " Int)") "" (List.map z3_of_spec_var all_fv)) ^")\n" in
    let test_out = (
        "(benchmark in.smt\n" ^
        ":logic " ^ (string_of_logic !logic) ^ "\n" ^
        extrafuns ^
        ":assumption\n" ^ ante_str ^ "\n" ^
        ":formula\n" ^ conseq_str ^ "\n"
    ) in
        test_out(*}}}*)


(*
 * Runs the specified prover and returns output
 *)
let runProver (inString : string) : string =(*{{{*)
    let outStream = open_out infile in
        output_string outStream inString;
        close_out outStream;
        ignore (Sys.command command);
        let inStream = open_in outfile in
        let result = input_line inStream in
            close_in inStream;
            Sys.remove infile;
            Sys.remove outfile;
            result(*}}}*)


(*
 * Test for validity
 *)
let imply (ante : Cpure.formula) (conseq : Cpure.formula) : bool =(*{{{*)
    (*
     print_string ("imply\n");
     print_string ("ante:: " ^ (Cprinter.string_of_pure_formula ante) ^ "\n");
     print_string ("conseq:: " ^ (Cprinter.string_of_pure_formula conseq) ^ "\n\n");
     *)
    let inString = (toSMT ante (Cpure.mkNot conseq no_pos)) in
    let outString = (runProver inString) in
        (*
         if !Logging.isLogging then (
         let outChannel = open_out_gen [Open_creat; Open_append; Open_wronly] 0o644 !Logging.logFile in
         output_string outChannel "\n%%% imply\n";
         output_string outChannel inString;
         output_string outChannel ("\tRESULT: " ^ outString ^ "\n");
         flush outChannel;
         close_out outChannel
         );
         *)
        if outString = "unsat" then (
            true
        ) else if outString = "sat" then (
            false
        ) else ( (* res_str = "unknown" *)
            false
        )(*}}}*)


(*
 * Test for satisfiability
 *)
let is_sat (f : Cpure.formula) (sat_no : string) : bool =(*{{{*)
    (*
     print_string ("is_sat " ^ sat_no ^ "\n");
     print_string ("f:: " ^ (Cprinter.string_of_pure_formula f) ^ "\n\n");
     *)
    let inString = (toSMT (Cpure.mkTrue no_pos) f) in
    let outString = (runProver inString) in
        (*
         if !Logging.isLogging then (
         let outChannel = open_out_gen [Open_creat; Open_append; Open_wronly] 0o644 !Logging.logFile in
         output_string outChannel ("\n%%% is_sat " ^ sat_no ^ "\n");
         output_string outChannel inString;
         output_string outChannel ("\tRESULT: " ^ outString ^ "\n");
         flush outChannel;
         close_out outChannel
         );
         *)
        if outString = "sat" then (
            true
        ) else if outString = "unsat" then (
            false
        ) else ( (* res_str = "unknown" *)
            false
        )(*}}}*)
