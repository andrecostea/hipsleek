/*
  example of deadlocks due to interractions of fork/join
  and acquire/release
*/

//define lock invariant with name LOCK and empty list of args
LOCK<> == self::lock<>
  inv self!=null
  inv_lock true; //describe protected shared heap

lemma "splitLock" self::LOCK(f)<> & f=f1+f2 & f1>0.0 & f2>0.0  -> self::LOCK(f1)<> * self::LOCK(f2)<> & 0.0<f<=1.0;

void func(lock l1)
  requires l1::LOCK(0.6)<> & [waitlevel<l1.mu # l1 notin LS]
  ensures l1::LOCK(0.6)<> & LS'=LS;//'
{
  acquire[LOCK](l1);
  release[LOCK](l1);
}

void main()
  requires LS={}
  ensures LS'={}; //'
{
   lock l1 = new lock();
   //initialization
   init[LOCK](l1);
   release(l1);
   //
   acquire(l1);
   //LS={l1}
   thrd id = fork(func,l1); //DELAYED
   release(l1);
   //LS={}

   acquire(l1);
   //LS={l1}
   join(id); // CHECK, Delayed checking failure
   release(l1);
   
}

