data node {
	int val;
	node next;
}
ll-shape(a)[Base,Rec,Inv]= Base(a,self)
  or self::node<v,q>* q::ll-shape(aq) & Rec(a,aq,v,self,q)
  inv Inv(a);

lsegBase (a,self) = self=a 
lsegRec (a,aq,v,self,q) = aq=a 

ltailBase(a,self) = self::node<_, null> 
ltailRec (a,aq,v,self,q) = q!=null 

lsBase (a,self) = a=1 
lsRec (a,aq,v,self,q) = a=aq+1 

lseg<p> = ll-shape<> [Base=lsegBase, Rec=lsegRec: p]

ll_tail<tx>= llseg<tx> [ltailBase,ltailRec: tx]
 
ll_tail2<tx,n> = ll_tail<tx> [lsBase, lsRec: n]
	
lseg2<p,n> = lseg<p> [lsBase, lsRec: n]
  
/*
ll_tail<tx> == self::node<_, null> & tx=self
	or self::node<_, r> * r::ll_tail<tx> & r!=null;

lseg<p> == self=p
	or self::node<_, r> * r::lseg<p>;

ll_tail2<tx, n> == self::node<_, null> & tx=self & n=1
	or self::node<_, r> * r::ll_tail2<tx, n-1> & r!=null
	inv n>=1;

	
lseg2<p, n> == self=p & n=0
	or self::node<_, r> * r::lseg2<p, n-1>
	inv n>=0;
*/
coercion "lseg2" self::lseg2<p, n> <-> self::lseg2<q, n1> * q::lseg2<p, n2> & n=n1+n2;
coercion "ll_tail2" self::ll_tail2<t, n> <-> self::lseg2<t, n-1> * t::node<_, null>;
//coercion "ll_tail2_1" self::ll_tail2<t, n> <-> self::lseg2<q, a> * q::lseg2<t, b> * t::node<_, null> & n=a+b+1;


//coercion "composite" self::lseg2<y, n> * y::lseg2<ty, m-1> * ty::node<_, null> <-> self::ll_tail2<ty, m+n>;
//coercion self::lseg2<p, n> -> self::lseg2<q, n-1> * q::node<_, p>;
//coercion "lsegbreakmerge" self::lseg<p> <-> self::lseg<q> * q::lseg<p>;
//coercion "lltail2lseg" self::ll_tail<t> <-> self::lseg<t> * t::node<_, null>;
//coercion "ll_tail2" self::ll_tail2<t, n> <-> self::lseg2<q, a> * q::lseg2<t, b> * t::node<_, null> & n=a+b+1;

void append(node x, node tx, node y, node ty)
//	requires x::ll_tail<tx> * y::ll_tail<ty>
//	ensures x::ll_tail<ty>;
	requires x::ll_tail2<tx, n> * y::ll_tail2<ty, m>
	ensures x::ll_tail2<ty, m+n>;
	//ensures x::lseg2<q,a> * q::lseg2<ty,b> * ty::node<_,null> & a+b+1=m+n;
	//ensures x::lseg2<ty, m+n-1> * ty::node<_, null>;
{
	tx.next = y;
}
/*
****************************************************************************************************************************
 coercion "ll_tail2" self::ll_tail2<t, n>
   <-> self::lseg2<q, a> * q::lseg2<t, b> * t::node<_, null> & n=a+b+1;

This is a composite of lseg and ll_tail2 lemma. A hand-trace
looks like below. Please chekc if it works!

===============
x::ll_tail2<tx, n> * y::ll_tail2<ty, m> |- tx:node(_,_)

x::lseg2<tx, n-1> * tx:node<_,null> * y::ll_tail2<ty, m>

  {tx.nexy = y }

x::lseg2<tx, n-1> * tx:node<_,y> * y::ll_tail2<ty, m>
    |- x::ll_tail2<ty, m+n>

x::lseg2<tx, n-1> * tx:node<_,y> * y::ll_tail2<ty, m>
    |- x::lseg2<q,a> * q::lseg2<ty,b> * ty::node<_,null>
              & a+b+1=m+n

tx:node<_,y> * y::ll_tail2<ty, m>
    |- tx::lseg2<ty,b> * ty::node<_,null>
              & n-1+b+1=m+n

tx:node<_,y> * y::ll_tail2<ty, m>
    |- tx::node(_,q)*q::lseg2<ty,b-1> * ty::node<_,null>
              & n-1+b+1=m+n

y::ll_tail2<ty, m>
    |- y::lseg<ty,b-1> * ty::node<_,null>
              & n-1+b+1=m+n

y::lseg2<ty, m-1> * ty::node<_, null> 
	|- y::lseg<ty,b-1> * ty::node<_,null>
              & n-1+b+1=m+n	

ty::node<_, null>		
	|- ty::node<_,null>
              & n-1+b+1=b+n	
		  
*/
