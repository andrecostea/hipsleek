
Processing file "ll-app.ss"
Parsing ll-app.ss ...
Parsing /home2/loris/hg/sl_infer/prelude.ss ...
Starting Reduce... 
Starting Omega...oc
Translating global variables to procedure parameters...

Checking procedure append$node~node... 
!!! >>>>>> HIP gather infer pre <<<<<<
!!! Inferred Heap :[]
!!! Inferred Pure :[ n!=0, n!=0]
!!! REL :  A(z,m,n)
!!! POST:  m>=0 & z>=(1+m) & z=n+m
!!! PRE :  0<=m & 1<=n
!!! NEW RELS:[ (1+m=z & 1<=z & n=1) --> A(z,m,n),
 (1<=z_580 & 1+n_557=n & m_558=m & -1+z=z_580 & 0<=m & 1<=n & 
  A(z_580,m_558,n_557)) --> A(z,m,n)]
!!! NEW ASSUME:[]
!!! NEW RANK:[]
Procedure append$node~node SUCCESS

Termination checking result:

Stop Omega... 140 invocations 
0 false contexts at: ()

Total verification time: 0.148008 second(s)
	Time spent in main process: 0.060003 second(s)
	Time spent in child processes: 0.088005 second(s)
