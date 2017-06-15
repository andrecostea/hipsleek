hip_include 'msess/notes/node.ss'
hip_include 'msess/notes/hodef.ss'
hip_include 'msess/notes/commprimitives.ss'

/* pred_sess_prot G1<C1,C2,S,k,val> == (exists x,y: ((C1->S:k(int) ;; S->C1:k(v#v=x)) *
                                    (C2->S:j(int) ;; S->C2:j(v#v=y & y=x))) ;;
                                    ((C1->C2:l(v#v=1 & x=val ) ;; C2->C1:l(1)) or
                                    (C1->C2:l(0)))).
*/

/*
pr C1: k!(int) ;; k?(v#v=x) ;; ((l!(v#v=1 & x=val) ;; l?(1)) or l!(v#v=0 & x!=val)).
pr C1#k: !(int) ;; ?(v#v=x)
pr C1#l: ((!(v#v=1 & x=val) ;; ?(1)) or (!0))
*/
void C1(Channel k, Channel l, int val)
   requires [x]  k::Chan{@S !v#v>0;;?v#v=x}<> * l::Chan{@S ((!v#(v=1 & x=val) ;; ?1) or (?v#(v=0 & x!=val) ))}<>
   ensures       k::Chan{emp}<> * l::Chan{emp}<>; 
  
{
  send(k,10);
  int price = receive(k);
  dprint;

  if(price == val) {
  assume (price'=val);
  dprint;
       send(l,1);
       int mm = receive(l);
  } else {
       send(l,0);
  }
}