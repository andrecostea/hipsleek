
Processing file "dll-app-nn.ss"
Parsing dll-app-nn.ss ...
Parsing ../../../prelude.ss ...
Starting Reduce... 
Starting Omega...oc
Translating global variables to procedure parameters...

Checking procedure append2$node2~node2... 
!!! REL :  D(t,m,n,r,p,q)
!!! POST:  m>=1 & n>=0 & q=r & m+n=t
!!! PRE :  1<=m & 0<=n
!!! NEW RELS:[ (m=1 & n=0 & r=q & t=1) --> D(t,m,n,r,p,q),
 (exists(flted_12_623:(t=2 & n=1 | 2+flted_12_623=t & 1+n=t & 3<=t) & r=q & 
  m=1)) --> D(t,m,n,r,p,q),
 (m=1 & n=0 & r=q & t=1) --> D(t,m,n,r,p,q),
 (1<=t_709 & p=p_634 & 1+m_633=m & n_635=n & -1+t=t_709 & r=q & 1<=m & 
  0<=n & D(t_709,m_633,n_635,r_710,p_634,q_632) & 
  q_632!=null) --> D(t,m,n,r,p,q)]
!!! NEW ASSUME:[ RELASS [D]: ( D(t_709,m_633,n_635,r_710,p_634,q_632)) -->  r_710=q_632 | (r_710+1)<=q_632 & q_632=null | q_632<=(r_710-1) & q_632=null]
!!! NEW RANK:[]
Procedure append2$node2~node2 SUCCESS

Termination checking result:

Stop Omega... 191 invocations 
0 false contexts at: ()

Total verification time: 0.49 second(s)
	Time spent in main process: 0.31 second(s)
	Time spent in child processes: 0.18 second(s)
