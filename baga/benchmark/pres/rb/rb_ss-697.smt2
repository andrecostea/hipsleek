(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_13_8334 () Int)
(declare-fun nb () Int)
(declare-fun a_primed () Int)
(declare-fun c_primed () Int)
(declare-fun flted_238_8258 () Int)
(declare-fun flted_238_8257 () Int)
(declare-fun b () Int)
(declare-fun flted_238_8259 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun b_primed () Int)
(declare-fun Anon_8338 () Int)
(declare-fun bhl_8339 () Int)
(declare-fun nl_8337 () Int)
(declare-fun l_8336 () Int)
(declare-fun Anon_8342 () Int)
(declare-fun bhr_8343 () Int)
(declare-fun nr_8341 () Int)
(declare-fun r_8340 () Int)
(declare-fun flted_238_8256 () Int)
(declare-fun flted_238_8255 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_13_8334 0))
(assert (= nb (+ (+ nr_8341 1) nl_8337)))
(assert (= bhl_8339 bhr_8343))
(assert (= flted_238_8257 (+ bhl_8339 1)))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_238_8259 0))
(assert (= flted_238_8258 0))
(assert (= flted_238_8257 (+ 1 h)))
(assert (= flted_238_8256 0))
(assert (= flted_238_8255 (+ 1 h)))
(assert (> b 0))
(assert (> c 0))
(assert true)
(assert (or (and (and (and (= flted_238_8259 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_238_8259 0)) (and (and (and (= flted_238_8259 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (= b_primed 1))
(assert (or (and (and (and (= Anon_8338 0) (<= 2 bhl_8339)) (<= 1 nl_8337)) (> l_8336 0)) (or (and (and (and (< l_8336 1) (= nl_8337 0)) (= bhl_8339 1)) (= Anon_8338 0)) (and (and (and (= Anon_8338 1) (<= 1 bhl_8339)) (<= 1 nl_8337)) (> l_8336 0)))))
(assert (or (and (and (and (= Anon_8342 0) (<= 2 bhr_8343)) (<= 1 nr_8341)) (> r_8340 0)) (or (and (and (and (< r_8340 1) (= nr_8341 0)) (= bhr_8343 1)) (= Anon_8342 0)) (and (and (and (= Anon_8342 1) (<= 1 bhr_8343)) (<= 1 nr_8341)) (> r_8340 0)))))
(assert (or (and (and (and (= flted_238_8256 0) (<= 2 flted_238_8255)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= flted_238_8255 1)) (= flted_238_8256 0)) (and (and (and (= flted_238_8256 1) (<= 1 flted_238_8255)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)