(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_17 () Int)
(declare-fun nb_7283 () Int)
(declare-fun na_7282 () Int)
(declare-fun a_primed () Int)
(declare-fun b_primed () Int)
(declare-fun r_7321 () Int)
(declare-fun d_primed () Int)
(declare-fun nr_7322 () Int)
(declare-fun Anon_7323 () Int)
(declare-fun flted_153_7297 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_153_7296 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_153_7294 () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun bhr_7324 () Int)
(declare-fun h_7285 () Int)
(declare-fun l_7317 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_153_7295 () Int)
(declare-fun h () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_17 flted_153_7296))
(assert (= nb_7283 nb))
(assert (= na_7282 na))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= d_primed d))
(assert (= flted_153_7297 0))
(assert (= flted_153_7296 0))
(assert (= flted_153_7294 0))
(assert (= r_7321 d_primed))
(assert (= nr_7322 nd))
(assert (= Anon_7323 flted_153_7294))
(assert (or (and (and (and (= flted_153_7297 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_153_7297 0)) (and (and (and (= flted_153_7297 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_153_7296 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_153_7296 0)) (and (and (and (= flted_153_7296 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_153_7294 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_153_7294 0)) (and (and (and (= flted_153_7294 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
(assert (= bhr_7324 h))
(assert (= flted_153_7295 0))
(assert (= h_7285 h))
(assert (= c_primed c))
(assert (= l_7317 c_primed))
(assert (or (and (and (and (= flted_153_7295 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_153_7295 0)) (and (and (and (= flted_153_7295 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not (or (= nc 0) (< c 1))))
(check-sat)