(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun a_primed () Int)
(declare-fun c_primed () Int)
(declare-fun v_node_252_3883_primed () Int)
(declare-fun Anon_17 () Int)
(declare-fun na_8678 () Int)
(declare-fun Anon_8349 () Int)
(declare-fun l_8347 () Int)
(declare-fun flted_238_8359 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_238_8356 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun h_8681 () Int)
(declare-fun nb_8679 () Int)
(declare-fun flted_238_8355 () Int)
(declare-fun h () Int)
(declare-fun flted_238_8357 () Int)
(declare-fun bhl_8350 () Int)
(declare-fun nb () Int)
(declare-fun nl_8348 () Int)
(declare-fun Anon_8353 () Int)
(declare-fun bhr_8354 () Int)
(declare-fun nr_8352 () Int)
(declare-fun v_node_252_3882_primed () Int)
(declare-fun cl () Int)
(declare-fun bh () Int)
(declare-fun n () Int)
(declare-fun r_8351 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= Anon_8353 1))
(assert (<= 0 Anon_8353))
(assert (<= 1 bhr_8354))
(assert (= a_primed a))
(assert (= c_primed c))
(assert (= flted_238_8359 0))
(assert (= flted_238_8356 0))
(assert (> c 0))
(assert (= v_node_252_3883_primed l_8347))
(assert (= Anon_17 Anon_8349))
(assert (= na_8678 na))
(assert (or (and (and (and (= Anon_8349 0) (<= 2 bhl_8350)) (<= 1 nl_8348)) (> l_8347 0)) (or (and (and (and (< l_8347 1) (= nl_8348 0)) (= bhl_8350 1)) (= Anon_8349 0)) (and (and (and (= Anon_8349 1) (<= 1 bhl_8350)) (<= 1 nl_8348)) (> l_8347 0)))))
(assert (or (and (and (and (= flted_238_8359 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_238_8359 0)) (and (and (and (= flted_238_8359 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_238_8356 0) (<= 2 flted_238_8355)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= flted_238_8355 1)) (= flted_238_8356 0)) (and (and (and (= flted_238_8356 1) (<= 1 flted_238_8355)) (<= 1 nc)) (> c 0)))))
(assert (= h_8681 h))
(assert (= nb_8679 nl_8348))
(assert (= flted_238_8355 (+ 1 h)))
(assert (= flted_238_8357 (+ 1 h)))
(assert (= flted_238_8357 (+ bhl_8350 1)))
(assert (= bhl_8350 bhr_8354))
(assert (= nb (+ (+ nr_8352 1) nl_8348)))
(assert (= cl Anon_8353))
(assert (= bh bhr_8354))
(assert (<= 0 nr_8352))
(assert (= cl 1))
(assert (<= 1 bh))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (<= 0 n))
(assert (= n nr_8352))
(assert (= v_node_252_3882_primed r_8351))
(assert (or (and (and (and (= cl 0) (<= 2 bh)) (<= 1 n)) (> r_8351 0)) (or (and (and (and (< r_8351 1) (= n 0)) (= bh 1)) (= cl 0)) (and (and (and (= cl 1) (<= 1 bh)) (<= 1 n)) (> r_8351 0)))))
;Negation of Consequence
(assert (not (or (= n 0) (< r_8351 1))))
(check-sat)