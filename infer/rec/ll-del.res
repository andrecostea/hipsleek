
Processing file "ll-del.ss"
Parsing ll-del.ss ...
Parsing /home2/loris/hg/sl_infer/prelude.ss ...
Starting Reduce... 
Starting Omega...oc
Translating global variables to procedure parameters...

Checking procedure delete$node~int... 
!!! >>>>>> HIP gather infer pre <<<<<<
!!! Inferred Heap :[]
!!! Inferred Pure :[ n!=1 | a!=1, n!=0 | a!=1, n!=0 | a<=1, n!=0 | 1<=a]
!!! REL :  B(n,a,m)
!!! POST:  a>=1 & m>=a & m+1=n
!!! PRE :  1<=a & a<n
!!! NEW RELS:[ (exists(flted_12_569:exists(flted_12_548:(m=1 & n=2 | -1+n=m & 1+
  flted_12_569=m & flted_12_548=m & 2<=m) & a=1))) --> B(n,a,m),
 ((1+m_622=m & 1<=m & 1<=v_int_46_623 | 1+m_622=m & v_int_46_623<=-1 & 
  1<=m) & B(n_601,v_int_46_623,m_622) & 1<=n & 1+n_601=n & -1+
  a=v_int_46_623) --> B(n,a,m)]
!!! NEW ASSUME:[]
!!! NEW RANK:[]
Procedure delete$node~int SUCCESS

Termination checking result:

Stop Omega... 157 invocations 
0 false contexts at: ()

Total verification time: 0.224012 second(s)
	Time spent in main process: 0.060003 second(s)
	Time spent in child processes: 0.164009 second(s)
