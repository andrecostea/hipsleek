(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nc_7284 () Int)
(declare-fun nr_7541 () Int)
(declare-fun nl_7538 () Int)
(declare-fun r_7540 () Int)
(declare-fun l_7537 () Int)
(declare-fun d_primed () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun nb_7283 () Int)
(declare-fun Anon_17 () Int)
(declare-fun flted_154_7526 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_154_7525 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_154_7524 () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun h_7285 () Int)
(declare-fun na_7282 () Int)
(declare-fun a_primed () Int)
(declare-fun bhl_7539 () Int)
(declare-fun bhr_7542 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_154_7527 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nc_7284 (+ (+ nr_7541 1) nl_7538)))
(assert (= bhl_7539 bhr_7542))
(assert (= nr_7541 nd))
(assert (= nl_7538 nc))
(assert (= r_7540 d_primed))
(assert (= l_7537 c_primed))
(assert (= flted_154_7524 0))
(assert (= flted_154_7525 0))
(assert (= flted_154_7526 0))
(assert (= d_primed d))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= nb_7283 nb))
(assert (= Anon_17 flted_154_7526))
(assert (or (and (and (and (= flted_154_7526 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_154_7526 0)) (and (and (and (= flted_154_7526 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_154_7525 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_154_7525 0)) (and (and (and (= flted_154_7525 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_154_7524 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_154_7524 0)) (and (and (and (= flted_154_7524 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
(assert (= h_7285 h))
(assert (= na_7282 na))
(assert (= a_primed a))
(assert (= bhl_7539 h))
(assert (= bhr_7542 h))
(assert (= flted_154_7527 0))
(assert (or (and (and (and (= flted_154_7527 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_154_7527 0)) (and (and (and (= flted_154_7527 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
;Negation of Consequence
(assert (not (= flted_154_7527 0)))
(check-sat)