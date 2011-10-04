/**
 * inverting the indices
 * 
 */

relation dom(int[] a, int low, int high) == 
	(dom(a,low-1,high) | dom(a,low,high+1)).

 relation bnd(int[] a, int i, int j, int low, int high) == 
 	(i > j | i<=j & forall ( k : (k < i | k > j | low <= a[k] <= high))).


void invert(ref int[] a, int i, int j) 
	requires dom(a,i,j) 
	ensures dom(a',i,j);
{
	if (i<j) {
        swap(a,i,j);
        invert(a,i+1,j-1);
    }
}


void swap (ref int[] a, int i, int j) 
	requires [t,k,low,high] dom(a,t,k) & t <= i &  i <= k & t <= j & j <= k 
             & bnd(a,t,k,low,high) 
            /* the allocation is from a[i..j] */
	ensures dom(a',t,k) & a'[i]=a[j] & a'[j]=a[i] & 
       forall(m: m=i | m=j | a'[m]=a[m] ) //'
              & bnd(a',t,k,low,high)//'
       ;
{
    int t = a[i];
    a[i] = a[j];
    a[j] = t;
}
