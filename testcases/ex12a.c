//Ex.12 - potential double free

int *malloc(int size)
/*@
  case {
    size <= 0 -> requires true ensures res = null;
    size >  0 ->
      requires true
      ensures res::int_star<_>;
  }
*/;

int main() {
   int x, *a;
   int *p = malloc(sizeof(int));
   for (x = 10; x > 0; x--)
     /*@
       case {

       }
     */
   {
       a = p;
       if (x == 1) {
           free(p);
       }
   }
   return 0;
}
