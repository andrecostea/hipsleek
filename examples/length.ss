data node {
	int val;
	node next;
}

ll<n> == self=null & n=0
	or self::node<_, r> * r::ll<n-1>
	inv n>=0;


int length(node x)
	requires x::ll<n>
	ensures x::ll<n> & res = n;
{
	if (x==null) return 0;
	else return 1 + length(x.next);
}
