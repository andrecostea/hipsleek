

void foo(int x, int y)
{
  x=0;y=0
  while(x<10){
    y++;
  }
  //unreachable
  assert (x<10);
}
