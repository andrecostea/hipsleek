(set-logic QF_S)
(set-info :source |
A. Rybalchenko and J. A. Navarro Perez.
[Separation Logic + Superposition Calculus = Heap Theorem Prover]
[PLDI 2011]
http://navarroj.com/research/papers.html#pldi11
|)
(set-info :smt-lib-version 2.0)
(set-info :category "random") 
(set-info :status unknown)
(set-info :version "2014-05-28")

(declare-sort Sll_t 0)

(declare-fun next () (Field Sll_t Sll_t))

(define-fun ls ((?in Sll_t) (?out Sll_t)) Space
(tospace (or (= ?in ?out)
(exists ((?u Sll_t))
(and (distinct ?in ?out) (tobool
(ssep (pto ?in (ref next ?u)) (ls ?u ?out)
)))))))

(declare-fun x0 () Sll_t)
(declare-fun x1 () Sll_t)
(declare-fun x2 () Sll_t)
(declare-fun x3 () Sll_t)
(declare-fun x4 () Sll_t)
(declare-fun x5 () Sll_t)
(declare-fun x6 () Sll_t)
(declare-fun x7 () Sll_t)
(declare-fun x8 () Sll_t)
(declare-fun x9 () Sll_t)
(declare-fun x10 () Sll_t)
(declare-fun x11 () Sll_t)
(declare-fun x12 () Sll_t)
(declare-fun x13 () Sll_t)
(declare-fun x14 () Sll_t)
(declare-fun x15 () Sll_t)
(declare-fun x16 () Sll_t)
(declare-fun x17 () Sll_t)
(declare-fun x18 () Sll_t)
(declare-fun x19 () Sll_t)
(declare-fun x20 () Sll_t)
(declare-fun x21 () Sll_t)
(declare-fun x22 () Sll_t)
(declare-fun x23 () Sll_t)
(declare-fun x24 () Sll_t)
(assert
  (and 
    (= nil nil)
    (tobool 
	(ssep
		(pto x6 (ref next x12)) 
		
		(ls  x15 x7) 
		
		(ls  x10 x1) 
		
		(pto x14 (ref next x7)) 
		
		(pto x2 (ref next x1)) 
		
		(ls  x12 x7) 
		
		(pto x9 (ref next x19)) 
		
		(pto x13 (ref next x11)) 
		
		(pto x8 (ref next x17)) 
		
		(pto x16 (ref next x1)) 
		
		(pto x1 (ref next x18)) 
		
		(pto x4 (ref next x19)) 
		
		(pto x17 (ref next x11)) 
		
		(pto x3 (ref next x12)) 
		
		(pto x18 (ref next x4)) 
		
		(ls  x20 x12) 
		
		(pto x5 (ref next x17)) 
		
		(pto x11 (ref next x6)) 
		
		(pto x19 (ref next x1)) 
		
		(ls  x7 x12) 
		emp
	) )
  )
)
(assert
  (not
        (tobool 
	(ssep
		(ls  x15 x7) 
		
		(ls  x3 x12) 
		
		(ls  x8 x17) 
		
		(ls  x14 x7) 
		
		(ls  x5 x17) 
		
		(ls  x7 x12) 
		
		(ls  x10 x1) 
		
		(ls  x16 x1) 
		
		(ls  x20 x12) 
		
		(ls  x13 x11) 
		
		(ls  x17 x11) 
		
		(ls  x9 x1) 
		
		(ls  x11 x7) 
		
		(ls  x2 x19) 
		emp
	) )
  ))

(check-sat)
