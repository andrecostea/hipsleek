Starting Omega...oc
Translating global variables to procedure parameters...

Checking procedure loop$int... 
Procedure loop$int SUCCESS

Termination checking result:

Termination Inference for loop$int

!!! ROUND 1
!!! SUBST:[
UNK_526#loop$int -> [ true -> Term_528]]
!!! Termination Spec:[
 x<=0 -> Term_525,
 1<=x -> UNK_526#loop$int]
!!! 

!!! Inferred Termination Spec:[
 x<=0 -> Term_525,
 1<=x -> Term_528]
!!! 
Stop Omega... 38 invocations 
0 false contexts at: ()

Total verification time: 0.068002 second(s)
	Time spent in main process: 0.052002 second(s)
	Time spent in child processes: 0.016 second(s)
