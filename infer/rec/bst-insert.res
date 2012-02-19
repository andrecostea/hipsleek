
Processing file "bst-insert.ss"
Parsing bst-insert.ss ...
Parsing ../../prelude.ss ...
Starting Reduce... 
Starting Omega...oc
Translating global variables to procedure parameters...

Checking procedure insert$node2~int... 
!!! REL :  C(mi,sm,ma,lg,a,res)
!!! POST:  sm>=mi & lg>=sm & ma>=lg & a>=mi & ma>=a & res!=null
!!! PRE :  sm<=lg
!!! NEW RELS:[ ((lg=ma & mi=a & a<=sm & sm<=ma | ma=a & sm=mi & mi<=lg & (1+lg)<=a | 
  lg=ma & sm=mi & (1+mi)<=a & a<=ma) & res!=null) --> C(mi,sm,ma,lg,a,res),
 (C(mi_649,sm_621,ma_650,lg_622,a,v_node2_43_716) & ma=lg & mi=mi_649 & 
  sm_621=sm & mi_649<=ma_650 & res!=null & sm<=lg_622 & 
  exists(v_606:exists(qs_605:a<=v_606 & qs_605<=lg & lg_622<=v_606 & 
  v_606<=qs_605))) --> C(mi,sm,ma,lg,a,res),
 (C(mi_684,sm_656,ma_685,lg_657,a,v_node2_48_775) & ma=ma_685 & mi=sm & 
  lg_657=lg & mi_684<=ma_685 & res!=null & sm_656<=lg & exists(v_606:(1+
  v_606)<=a & v_606<=sm_656 & exists(pl_604:sm<=pl_604 & 
  pl_604<=v_606))) --> C(mi,sm,ma,lg,a,res)]
!!! NEW ASSUME:[ RELASS [C]: ( C(mi_649,sm_621,ma_650,lg_622,a,v_node2_43_716)) -->  lg_622<sm_621 | sm_621<=lg_622 & ma_650<=a | a<ma_650 & ma_650<mi_649 & 
sm_621<=lg_622 | (a+1)<=ma_650 & mi_649<=ma_650 & ma_650<=lg_622 & 
sm_621<=lg_622,
 RELASS [C]: ( C(mi_684,sm_656,ma_685,lg_657,a,v_node2_48_775)) -->  a<=(mi_684+1) | sm_656<=mi_684 & mi_684<=(a-2) | ma_685<mi_684 & mi_684<=(a-
2) & mi_684<=(sm_656-1) | mi_684<=(a-2) & mi_684<=(sm_656-1) & 
mi_684<=ma_685 & lg_657<sm_656]
!!! NEW RANK:[]
Procedure insert$node2~int SUCCESS

Termination checking result:

Stop Omega... 246 invocations 
0 false contexts at: ()

Total verification time: 1.83 second(s)
	Time spent in main process: 0.54 second(s)
	Time spent in child processes: 1.29 second(s)
