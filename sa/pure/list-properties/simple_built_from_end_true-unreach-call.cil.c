extern void __VERIFIER_error() __attribute__ ((__noreturn__));

extern int __VERIFIER_nondet_int();
/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

#line 211 "/usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.5.2/include/stddef.h"
typedef unsigned long size_t;
#line 12 "simple_built_from_end.c"
struct node {
   int h ;
   struct node *n ;
};
#line 12 "simple_built_from_end.c"
typedef struct node *List;
#line 471 "/usr/include/stdlib.h"
extern  __attribute__((__nothrow__)) void *malloc(size_t __size )  __attribute__((__malloc__)) ;
#line 544
 __attribute__((__nothrow__, __noreturn__)) void exit(int s ) ;
#line 8 "simple_built_from_end.c"
 __attribute__((__nothrow__, __noreturn__)) void exit(int s ) ;
#line 8 "simple_built_from_end.c"
void exit(int s ) 
{ 

  {
  _EXIT: 
  goto _EXIT;
}
}
#line 21
extern int ( /* missing proto */  __VERIFIER_nondet_int)() ;
#line 17 "simple_built_from_end.c"
int main(void) 
{ List t ;
  List p ;
  void *tmp ;
  int tmp___0 ;
  unsigned long __cil_tmp5 ;
  List __cil_tmp6 ;
  unsigned int __cil_tmp7 ;
  unsigned int __cil_tmp8 ;
  unsigned int __cil_tmp9 ;
  unsigned int __cil_tmp10 ;
  List __cil_tmp11 ;
  unsigned int __cil_tmp12 ;
  unsigned int __cil_tmp13 ;
  int __cil_tmp14 ;
  unsigned int __cil_tmp15 ;
  unsigned int __cil_tmp16 ;

  {
#line 20
  p = (List )0;
  {
#line 21
  while (1) {
    while_0_continue: /* CIL Label */ ;
    {
#line 21
    tmp___0 = __VERIFIER_nondet_int();
    }
#line 21
    if (tmp___0) {

    } else {
      goto while_0_break;
    }
    {
#line 22
    __cil_tmp5 = (unsigned long )8U;
#line 22
    tmp = malloc(__cil_tmp5);
#line 22
    t = (struct node *)tmp;
    }
    {
#line 23
    __cil_tmp6 = (List )0;
#line 23
    __cil_tmp7 = (unsigned int )__cil_tmp6;
#line 23
    __cil_tmp8 = (unsigned int )t;
#line 23
    if (__cil_tmp8 == __cil_tmp7) {
      {
#line 23
      exit(1);
      }
    } else {

    }
    }
#line 24
    *((int *)t) = 1;
#line 25
    __cil_tmp9 = (unsigned int )t;
#line 25
    __cil_tmp10 = __cil_tmp9 + 4;
#line 25
    *((struct node **)__cil_tmp10) = p;
#line 26
    p = t;
  }
  while_0_break: /* CIL Label */ ;
  }
  {
#line 28
  while (1) {
    while_1_continue: /* CIL Label */ ;
    {
#line 28
    __cil_tmp11 = (List )0;
#line 28
    __cil_tmp12 = (unsigned int )__cil_tmp11;
#line 28
    __cil_tmp13 = (unsigned int )p;
#line 28
    if (__cil_tmp13 != __cil_tmp12) {

    } else {
      goto while_1_break;
    }
    }
    {
#line 29
    __cil_tmp14 = *((int *)p);
#line 29
    if (__cil_tmp14 != 1) {
      ERROR: __VERIFIER_error();
    } else {

    }
    }
#line 32
    __cil_tmp15 = (unsigned int )p;
#line 32
    __cil_tmp16 = __cil_tmp15 + 4;
#line 32
    p = *((struct node **)__cil_tmp16);
  }
  while_1_break: /* CIL Label */ ;
  }
#line 35
  return (0);
}
}
