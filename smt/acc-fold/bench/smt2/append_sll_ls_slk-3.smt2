(set-logic QF_S)

(declare-sort node 0)
(declare-fun next () (Field node node))

(define-fun ll ((?in node))
Space (tospace
(or
(and 
(= ?in nil)

)(exists ((?q_20 node))(and 
(tobool (ssep 
(pto ?in  (ref next ?q_20))
(ll ?q_20)
) )
)))))

(define-fun lseg ((?in node) (?p node))
Space (tospace
(or
(and 
(= ?in ?p)

)(exists ((?p_19 node)(?q_18 node))(and 
(= ?p_19 ?p)
(tobool (ssep 
(pto ?in  (ref next ?q_18))
(lseg ?q_18 ?p_19)
) )
)))))










(declare-fun xprm () node)
(declare-fun vprm () node)
(declare-fun yprm () Int)
(declare-fun y () Int)
(declare-fun x () node)
(declare-fun q () node)


(assert 
(and 
(distinct vprm nil)
(= vprm q)
(= xprm x)
(= yprm y)
(distinct x nil)
(tobool (ssep 
(ll q)
(pto xprm  (ref next q))
emp
) )
)
)

(assert (not 
(and 
(distinct vprm nil)
(= vprm q)
(= xprm x)
(= yprm y)
(distinct x nil)
(tobool (ssep 
(ll q)
(pto xprm  (ref next q))
emp
) )
)
))

(check-sat)