
Processing file "ll-a2.ss"
Parsing ll-a2.ss ...
Parsing ../../prelude.ss ...
Starting Reduce... 
Starting Omega...oc
Translating global variables to procedure parameters...
Checking procedure append2$node~node... 
Inferred Heap:[]
Inferred Pure:[ n1!=0, n1!=0]
OLD SPECS:  EInfer [n1]
   EBase exists (Expl)(Impl)[n1; n2](ex)x::ll<n1>@M[Orig][LHSCase] * 
         y::ll<n2>@M[Orig][LHSCase]&true&{FLOW,(20,21)=__norm}
           EBase true&MayLoop&{FLOW,(1,23)=__flow}
                   EAssume 1::
                     EXISTS(m: x::ll<m>@M[Orig][LHSCase]&m=n2+n1&
                     {FLOW,(20,21)=__norm})
NEW SPECS:  EBase exists (Expl)(Impl)[n1; n2](ex)x::ll<n1>@M[Orig][LHSCase] * 
       y::ll<n2>@M[Orig][LHSCase]&true&{FLOW,(20,21)=__norm}
         EBase true&(1<=n1 | n1<=(0-1)) & MayLoop&{FLOW,(1,23)=__flow}
                 EAssume 1::
                   EXISTS(m_587: x::ll<m_587>@M[Orig][LHSCase]&m_587=n2+n1 & 
                   0<=n1 & 0<=n2&{FLOW,(20,21)=__norm})
NEW RELS: []

Procedure append2$node~node SUCCESS

Termination checking result:

Stop Omega... 89 invocations 
0 false contexts at: ()

Total verification time: 0.21 second(s)
	Time spent in main process: 0.19 second(s)
	Time spent in child processes: 0.02 second(s)
