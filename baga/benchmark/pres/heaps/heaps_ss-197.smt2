(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun l_2725 () Int)
(declare-fun l_2421 () Int)
(declare-fun r_2728 () Int)
(declare-fun r_2424 () Int)
(declare-fun m2_2418 () Int)
(declare-fun m1_2417 () Int)
(declare-fun m3_2419 () Int)
(declare-fun m2_2729 () Int)
(declare-fun m1_2726 () Int)
(declare-fun d_2724 () Int)
(declare-fun v_primed () Int)
(declare-fun m2_2425 () Int)
(declare-fun m1_2422 () Int)
(declare-fun mx1_2423 () Int)
(declare-fun mx2_2426 () Int)
(declare-fun m1_2364 () Int)
(declare-fun v () Int)
(declare-fun val_149_2442 () Int)
(declare-fun d_primed () Int)
(declare-fun d_2420 () Int)
(declare-fun d_2439 () Int)
(declare-fun m1_primed () Int)
(declare-fun m2_primed () Int)
(declare-fun m1 () Int)
(declare-fun mx1 () Int)
(declare-fun d () Int)
(declare-fun m2 () Int)
(declare-fun r_primed () Int)
(declare-fun mx2 () Int)
(declare-fun m2_2365 () Int)
(declare-fun r () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< l_2421 1))
(assert (= l_2725 l_2421))
(assert (< r_2424 1))
(assert (= m2_2418 0))
(assert (or (= m1_2417 0) (< l_2421 1)))
(assert (= r_2728 r_2424))
(assert (or (= m2_2418 0) (< r_2424 1)))
(assert (= m1_2417 0))
(assert (= mx1_2423 0))
(assert (= v_primed v))
(assert (<= 0 v))
(assert (= m2_2418 m2_2425))
(assert (= m1_2417 m1_2422))
(assert (<= m3_2419 1))
(assert (<= 0 m3_2419))
(assert (= (+ m3_2419 m2_2425) m1_2422))
(assert (exists ((mx3_2746 Int)) (<= d_2724 mx3_2746)))
(assert (= mx2_2426 0))
(assert (= m2_2729 m2_2425))
(assert (= m1_2726 m1_2422))
(assert (= d_2724 v_primed))
(assert (< v_primed d_2420))
(assert (= m1_2364 (+ (+ m2_2425 1) m1_2422)))
(assert (<= 0 d_2420))
(assert (<= mx1_2423 d_2420))
(assert (<= mx2_2426 d_2420))
(assert (<= d_2420 mx1))
(assert (not (= m1_primed 0)))
(assert (= m1_2364 m1))
(assert (<= v d))
(assert (= val_149_2442 d_2420))
(assert (= d_primed d_2420))
(assert (= m2_primed 0))
(assert (= d_2439 d))
(assert (= m1_primed m1))
(assert (= m2_primed m2))
(assert (<= (+ 0 m2) m1))
(assert (<= m1 (+ 1 m2)))
(assert (<= mx1 d))
(assert (<= mx2 d))
(assert (= m2_2365 m2))
(assert (= r_primed r))
(assert (or (and (and (< r 1) (= m2_2365 0)) (= mx2 0)) (and (and (<= 0 mx2) (<= 1 m2_2365)) (> r 0))))
;Negation of Consequence
(assert (not (or (= m2_2365 0) (< r 1))))
(check-sat)