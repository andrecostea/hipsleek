multi_buy(B1,S,B2) ==
   B1 -> S : string ;
   S  -> B1 : int ; 
   S  -> B2 : int ;
   B1 -> B2 : int;
   (B2 -> S : 1 ; B2 -> S : Addr ; S -> B2 : Date 
    \/ B2 -> S : 0)

multi_buy(B1,S,B2) ==
   B1 -> S : string ;
   (S  -> B1 : int ; B1 -> B2 : int) 
   * S  -> B2 : int ;
   (B2 -> S : 1 ; B2 -> S : Addr ; S -> B2 : Date 
    \/ B2 -> S : 0)

// project on B1
multi_buy(B1,S,B2) == 
   B1 -> S : string ;
   S  -> B1 : int ;
   B1 -> B2 : int) 

// project on S
multi_buy(B1,S,B2) == 
   B1 -> S : string ;
   S  -> B1 : int ;  // Andreea: why not use * instead of ;, since multi_buy contains *
   S  -> B2 : int ;  
   (B2 -> S : 1 ; B2 -> S : Addr ; S -> B2 : Date 
    \/ B2 -> S : 0)

// project on B2
multi_buy(B1,S,B2) ==
   B1 -> B2 : int * S  -> B2 : int ;
   (B2 -> S : 1 ; B2 -> S : Addr ; S -> B2 : Date 
    \/ B2 -> S : 0)

Due to ambiguity with presence of *, we see that
there is a need for 2-channels for B2

===============================================

We use ; to denote sequencing 
and * to denote concurrency
and \/ for disjunction.
=======================================
// project on B1
multi_buy(B1,S,B2) ==
   B1 -> S : string ;
   S  -> B1 : int ;
   B1 -> B2 : int) 

==> B1::C{S!String;S?Int;B2!Int}

// project on S
multi_buy(B1,S,B2) ==
   B1 -> S : string ;
   S  -> B1 : int ; 
   S  -> B2 : int ;
   (B2 -> S : 1 ; B2 -> S : Addr ; S -> B2 : Date 
    \/ B2 -> S : 0)
 
==> S::C{B1?String;B1!Int;B2!Int;(B2?1;B2?Addr;B2!Date \/ B2?0)}

// project on B2
multi_buy(B1,S,B2) ==
   B1 -> B2 : int * S  -> B2 : int ;
   (B2 -> S : 1 ; B2 -> S : Addr ; S -> B2 : Date 
    \/ B2 -> S : 0)
 
==> B2::C{B1?int * S?int ; 
          (S!1; S!Addr ; S?Date
           \/ S!0)}
==================================================

multi_buy(B1,S,B2) ==
   B1 -> S : string ;
   S  -> B1 : int ; 
   B1 -> B2 : int;
   S  -> B2 : int ;
   (B2 -> S : 1 ; B2 -> S : Addr ; S -> B2 : Date 
    \/ B2 -> S : 0)
 
|- multi_buy(B1,S,B2)
  B1::C{!string ; ? : int ; !B1 -> B2 : int) 
  ]

---------------------------------------------------------------- 
pred_prim ChanP <id: string, prot: formula>

pred_prim Sess <id: string, prot: formula>

pred_prim ChanP <id: string, sess: formula>


msg has form k /\ \pi
1   ~  emp /\ r:int /\ r=1
int ~  emp /\ r:int 
 
  multi_buy(B1,S,B2) == 
   B1 -> S : string ;
   (S  -> B1 : int ; B1 -> B2 : int) 
   * S  -> B2 : int ;
   (B2 -> S : 1 ; B2 -> S : Addr ; S -> B2 : Date 
    \/ B2 -> S : 0)
 
  pred_msess sell = B1?String;B1!Int;B2!Int;(B2?1;B2?Addr;B2!Date \/ B2?0)
  pred_msess buy1 = S!String;S?Int;B2!Int
  pred_msess buy2 = B1?int * S?int ; (S!1; S!Addr ; S?Date \/ S!0).

void Buyer1(Chan s, Chan b1, Chan b2')
requires Chan(s, !string;;?int) * Chan(b1
ensures
{
	string book = getTitle();
	send(s, book);
	int y1 = receive(b1);
	send(b2', contrib(y1));
}

void Buyer2(Chan s, Chan b2, Chan b2')
{
	int budget = getBudget();
	string address = getAddress();
	int z1 = receive(b2);
	int z2 = receive(b2');
	if (z1 - z2 <= budget){
		send (s,ok)
		send(s, address);
		receive(b2, date);
	} else {
		send(s, quit);
	}
}

void Seller(Chan s, Chan b1, Chan b2)
{
	string x1 = receive(s);
	send(b1,quote(x1));
	send(b2,quote(x1))
	int answer = receive(s);
	if (s == ok) {
		string x2 = receive(s);
		send(b2, getDate(x2,x1)); 
	}
}

void main (Chan s, Chan b1, Chan b2, Chan b2')
{
	Channel s,b1,b2,b2';
	s = new Channel(); b1 = new Channel(); 
	b2 = new Channel(); b2' = new Channel();
	Buyer1(s,b1,b2') | Buyer2(s,b2,b2') | Seller(s,b1,b2) 
}