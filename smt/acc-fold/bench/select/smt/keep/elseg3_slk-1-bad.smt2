(set-logic QF_S)

(declare-sort node 0)
(declare-fun nxt () (Field node node))

(define-fun elseg ((?in node) (?p node))
Space (tospace
(or
(= ?in ?p)
(exists ((?a node)(?b node))(and 
(tobool (ssep 
(pto ?in  (ref nxt ?a))
(pto ?a  (ref nxt ?b))
(elseg ?b ?p)
) )
)))))














(declare-fun a () node)
(declare-fun b () node)
(declare-fun x () node)
(declare-fun p () node)


(assert 
(and 
(tobool (ssep 
(pto x  (ref nxt a))
(pto a  (ref nxt b))
(elseg b p)
emp // remove ()
) )
)
)

(assert (not 
(and 
(tobool (ssep 
(elseg x p)
emp // remove ()
) )
)
))

(check-sat)