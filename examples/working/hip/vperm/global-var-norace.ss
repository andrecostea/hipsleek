/*
  Simple examples of variable permissions
 */
global int g;

//increase 'i' with an amount 'g'
void inc(ref int i,int g)
  requires true //@full[i]
  ensures  i'=i+g; //& @full[i]; //'
{
  i = i + g;
}

//race in "g" --> fail
void func()
requires true
  ensures true;
{
  int x,y;
  x=0;y=0;
  thrd id1 = fork(inc,x,g);
  inc(y,g); // each thread accesses a copy of "g" --> SAFE
  join(id1);
  assert x'=g & y'=g;
}
