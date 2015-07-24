(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun na_7282 () Int)
(declare-fun a_primed () Int)
(declare-fun b_primed () Int)
(declare-fun l_7569 () Int)
(declare-fun c_primed () Int)
(declare-fun nl_7570 () Int)
(declare-fun flted_154_7527 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_154_7525 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_154_7526 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun bhl_7571 () Int)
(declare-fun h_7285 () Int)
(declare-fun r_7572 () Int)
(declare-fun d_primed () Int)
(declare-fun flted_154_7524 () Int)
(declare-fun h () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= na_7282 na))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_154_7527 0))
(assert (= flted_154_7526 0))
(assert (= flted_154_7525 0))
(assert (= l_7569 c_primed))
(assert (= nl_7570 nc))
(assert (or (and (and (and (= flted_154_7527 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_154_7527 0)) (and (and (and (= flted_154_7527 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_154_7525 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_154_7525 0)) (and (and (and (= flted_154_7525 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_154_7526 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_154_7526 0)) (and (and (and (= flted_154_7526 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (= bhl_7571 h))
(assert (= flted_154_7524 0))
(assert (= h_7285 h))
(assert (= d_primed d))
(assert (= r_7572 d_primed))
(assert (or (and (and (and (= flted_154_7524 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_154_7524 0)) (and (and (and (= flted_154_7524 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
;Negation of Consequence
(assert (not (or (= nd 0) (< d 1))))
(check-sat)