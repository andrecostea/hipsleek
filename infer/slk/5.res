Starting Reduce... 
Starting Omega...oc
Entail  (1): Valid. 

<1>EXISTS(q_48,flted_7_46: q_48::ll<flted_7_46>@M[Orig]&flted_7_46+1=n & n=1&{FLOW,(17,18)=__norm})
inferred pure: [n=1; n!=0 | y!=null]

Entail  (2): Valid. 

<1>EXISTS(q_76,flted_7_74: q_76::ll<flted_7_74>@M[Orig]&flted_7_74+1=n & n=1&{FLOW,(17,18)=__norm})
inferred pure: [n=1; n!=0]

Entail  (3): Valid. 

<1>EXISTS(flted_7_98: b::ll<flted_7_98>@M[Orig]&flted_7_98+1=n&{FLOW,(17,18)=__norm})
inferred pure: [n!=0]

Entail  (4): Valid. 

<1>true&y=null & n=0&{FLOW,(17,18)=__norm}
inferred pure: [n=0]

Entail  (5): Valid. 

<1>false&false&{FLOW,(17,18)=__norm}
inferred pure: [n!=1]

Entail  (6): Valid. 

<1>false&false&{FLOW,(17,18)=__norm}
inferred pure: [n!=1]

Entail  (7): Fail.(may) cause:(failure_code=213)  0<n & m<n |-  3<n (may-bug).


Entail  (8): Fail.(may) cause:(failure_code=213)  4<m & 0<n & m<n |-  8<n (may-bug).


Entail  (9): Valid. 

<1>false&false&{FLOW,(17,18)=__norm}
inferred pure: [n<=0]

Entail  (10): Valid. 

<1>false&false&{FLOW,(17,18)=__norm}
inferred pure: [n<=m | n<=0]

Entail  (11): Fail.(must) cause:(failure_code=213)  true |-  n=2 & n=1 (RHS: contradiction).

<1>true&true&{FLOW,(1,2)=__Error}

Entail  (12): Valid. 

<1>false&false&{FLOW,(17,18)=__norm}
inferred pure: [m!=2 | n<=0]

Entail  (13): Fail.(may) cause:(failure_code=213)  2<m & a=p |-  m<a (may-bug).


Entail  (14): Fail.(may) cause:(failure_code=213)  2<m |-  4<m;  2<m |-  m<p (may-bug).


Entail  (15): Fail.(may) cause:(failure_code=213)  2<m |-  4<m;  2<m |-  m<p (may-bug).


Entail  (16): Fail.(may) cause:(failure_code=213)  2<m |-  4<m;  2<m |-  m<p (may-bug).


Stop Omega... 187 invocations 
