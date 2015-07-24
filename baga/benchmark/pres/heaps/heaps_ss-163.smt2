(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun d_primed () Int)
(declare-fun d_2435 () Int)
(declare-fun m2_primed () Int)
(declare-fun l_primed () Int)
(declare-fun l () Int)
(declare-fun r_primed () Int)
(declare-fun v () Int)
(declare-fun d () Int)
(declare-fun m1 () Int)
(declare-fun m2 () Int)
(declare-fun m1_primed () Int)
(declare-fun v_bool_132_1567_primed () Int)
(declare-fun v_bool_141_1566_primed () Int)
(declare-fun m3_2419 () Int)
(declare-fun mx1 () Int)
(declare-fun mx1_2423 () Int)
(declare-fun m1_2364 () Int)
(declare-fun v_primed () Int)
(declare-fun v_bool_144_1438_primed () Int)
(declare-fun d_2681 () Int)
(declare-fun d_2420 () Int)
(declare-fun m1_2683 () Int)
(declare-fun m1_2422 () Int)
(declare-fun m2_2686 () Int)
(declare-fun m2_2425 () Int)
(declare-fun l_2682 () Int)
(declare-fun r_2685 () Int)
(declare-fun m1_2417 () Int)
(declare-fun l_2421 () Int)
(declare-fun mx2_2426 () Int)
(declare-fun m2_2418 () Int)
(declare-fun r_2424 () Int)
(declare-fun mx2 () Int)
(declare-fun m2_2365 () Int)
(declare-fun r () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< l_2421 1))
(assert (= m1_2417 0))
(assert (= mx1_2423 0))
(assert (= d_primed v_primed))
(assert (= m2_primed 0))
(assert (= d_2435 d))
(assert (= v_primed v))
(assert (= m1_primed m1))
(assert (= m2_primed m2))
(assert (= l_primed l))
(assert (= r_primed r))
(assert (<= (+ 0 m2) m1))
(assert (<= m1 (+ 1 m2)))
(assert (<= mx1 d))
(assert (<= mx2 d))
(assert (<= 0 v))
(assert (<= v d))
(assert (= m1_2364 m1))
(assert (= m2_2365 m2))
(assert (not (= m1_primed 0)))
(assert (not (> v_bool_132_1567_primed 0)))
(assert (> v_bool_141_1566_primed 0))
(assert (= m2_2418 m2_2425))
(assert (= m1_2417 m1_2422))
(assert (<= m3_2419 1))
(assert (<= 0 m3_2419))
(assert (= (+ m3_2419 m2_2425) m1_2422))
(assert (<= d_2420 mx1))
(assert (<= mx2_2426 d_2420))
(assert (<= mx1_2423 d_2420))
(assert (<= 0 d_2420))
(assert (= m1_2364 (+ (+ m2_2425 1) m1_2422)))
(assert (<= d_2420 v_primed))
(assert (> v_bool_144_1438_primed 0))
(assert (= d_2681 d_2420))
(assert (= m1_2683 m1_2422))
(assert (= m2_2686 m2_2425))
(assert (= l_2682 l_2421))
(assert (= r_2685 r_2424))
(assert (or (= m1_2417 0) (< l_2421 1)))
(assert (or (and (and (< r_2424 1) (= m2_2418 0)) (= mx2_2426 0)) (and (and (<= 0 mx2_2426) (<= 1 m2_2418)) (> r_2424 0))))
(assert (or (and (and (< r 1) (= m2_2365 0)) (= mx2 0)) (and (and (<= 0 mx2) (<= 1 m2_2365)) (> r 0))))
;Negation of Consequence
(assert (not false))
(check-sat)