(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nc_10928 () Int)
(declare-fun Anon_19 () Int)
(declare-fun nb_10927 () Int)
(declare-fun c_primed () Int)
(declare-fun d_primed () Int)
(declare-fun l_11269 () Int)
(declare-fun a_primed () Int)
(declare-fun flted_169_11174 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_169_11173 () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun flted_169_11176 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun r_11273 () Int)
(declare-fun b_primed () Int)
(declare-fun flted_169_11175 () Int)
(declare-fun h () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nc_10928 nd))
(assert (= Anon_19 flted_169_11174))
(assert (= nb_10927 nc))
(assert (= a_primed a))
(assert (= c_primed c))
(assert (= d_primed d))
(assert (= flted_169_11176 0))
(assert (= flted_169_11174 0))
(assert (= flted_169_11173 0))
(assert (= l_11269 a_primed))
(assert (or (and (and (and (= flted_169_11174 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_169_11174 0)) (and (and (and (= flted_169_11174 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_169_11173 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_169_11173 0)) (and (and (and (= flted_169_11173 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
(assert (or (and (and (and (= flted_169_11176 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_169_11176 0)) (and (and (and (= flted_169_11176 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (= flted_169_11175 0))
(assert (= b_primed b))
(assert (= r_11273 b_primed))
(assert (or (and (and (and (= flted_169_11175 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_169_11175 0)) (and (and (and (= flted_169_11175 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
;Negation of Consequence
(assert (not (or (= nb 0) (< b 1))))
(check-sat)