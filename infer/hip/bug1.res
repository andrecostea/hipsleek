
Processing file "bug1.ss"
Parsing bug1.ss ...
Parsing ../../prelude.ss ...
Starting Reduce... 
Starting Omega...oc
Translating global variables to procedure parameters...

Checking procedure foo2$int... 
!!! >>>>>> HIP gather infer pre <<<<<<
!!! Inferred Heap :[]
!!! Inferred Pure :[ 2<=i]
!!! OLD SPECS: ((None,[]),EInfer [i]
              EBase true&true&{FLOW,(20,21)=__norm}
                      EBase true&MayLoop&{FLOW,(1,23)=__flow}
                              EAssume 1::ref [i]
                                true&true&{FLOW,(20,21)=__norm})
!!! NEW SPECS: ((None,[]),EBase true&2<=i & MayLoop&{FLOW,(1,23)=__flow}
                    EAssume 1::ref [i]
                      true&(i-2)<=i' & i'<i & 2<=i&{FLOW,(20,21)=__norm})
!!! NEW RELS:[]
!!! NEW ASSUME:[]
!!! NEW RANK:[]
Procedure foo2$int SUCCESS

Termination checking result:

Stop Omega... 55 invocations 
0 false contexts at: ()

Total verification time: 0.17 second(s)
	Time spent in main process: 0.15 second(s)
	Time spent in child processes: 0.02 second(s)
