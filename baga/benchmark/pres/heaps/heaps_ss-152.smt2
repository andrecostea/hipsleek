(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_172_1547_primed () Int)
(declare-fun left_172_1546_primed () Int)
(declare-fun nright_172_1545_primed () Int)
(declare-fun nleft_172_1544_primed () Int)
(declare-fun val_172_1543_primed () Int)
(declare-fun v_int_172_1561_primed () Int)
(declare-fun v_int_172_1562_primed () Int)
(declare-fun v_int_172_1563_primed () Int)
(declare-fun d_primed () Int)
(declare-fun d_2617 () Int)
(declare-fun l () Int)
(declare-fun r_primed () Int)
(declare-fun r () Int)
(declare-fun v () Int)
(declare-fun d () Int)
(declare-fun m1 () Int)
(declare-fun m2 () Int)
(declare-fun m1_primed () Int)
(declare-fun v_bool_132_1567_primed () Int)
(declare-fun m2_primed () Int)
(declare-fun v_bool_141_1566_primed () Int)
(declare-fun m3_2480 () Int)
(declare-fun mx1 () Int)
(declare-fun m1_2364 () Int)
(declare-fun m2_2486 () Int)
(declare-fun m1_2483 () Int)
(declare-fun m3_2527 () Int)
(declare-fun mx2 () Int)
(declare-fun m2_2365 () Int)
(declare-fun m2_2533 () Int)
(declare-fun m1_2530 () Int)
(declare-fun d_2481 () Int)
(declare-fun v_bool_154_1565_primed () Int)
(declare-fun v_primed () Int)
(declare-fun d_2528 () Int)
(declare-fun v_bool_166_1564_primed () Int)
(declare-fun l_primed () Int)
(declare-fun mx1_2484 () Int)
(declare-fun m1_2478 () Int)
(declare-fun l_2482 () Int)
(declare-fun mx2_2487 () Int)
(declare-fun m2_2479 () Int)
(declare-fun r_2485 () Int)
(declare-fun mx1_2531 () Int)
(declare-fun m1_2525 () Int)
(declare-fun l_2529 () Int)
(declare-fun mx2_2534 () Int)
(declare-fun m2_2526 () Int)
(declare-fun r_2532 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_172_1547_primed r_2532))
(assert (= left_172_1546_primed l_2529))
(assert (= nright_172_1545_primed m2_2533))
(assert (= nleft_172_1544_primed m1_2530))
(assert (= val_172_1543_primed d_2528))
(assert (= v_int_172_1561_primed m2_2533))
(assert (= v_int_172_1562_primed m1_2530))
(assert (= v_int_172_1563_primed d_2528))
(assert (= d_primed d_2528))
(assert (= d_2617 d))
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
(assert (not (= m2_primed 0)))
(assert (not (> v_bool_141_1566_primed 0)))
(assert (= m2_2479 m2_2486))
(assert (= m1_2478 m1_2483))
(assert (<= m3_2480 1))
(assert (<= 0 m3_2480))
(assert (= (+ m3_2480 m2_2486) m1_2483))
(assert (<= d_2481 mx1))
(assert (<= mx2_2487 d_2481))
(assert (<= mx1_2484 d_2481))
(assert (<= 0 d_2481))
(assert (= m1_2364 (+ (+ m2_2486 1) m1_2483)))
(assert (= m2_2526 m2_2533))
(assert (= m1_2525 m1_2530))
(assert (<= m3_2527 1))
(assert (<= 0 m3_2527))
(assert (= (+ m3_2527 m2_2533) m1_2530))
(assert (<= d_2528 mx2))
(assert (<= mx2_2534 d_2528))
(assert (<= mx1_2531 d_2528))
(assert (<= 0 d_2528))
(assert (= m2_2365 (+ (+ m2_2533 1) m1_2530)))
(assert (< d_2481 d_2528))
(assert (not (> v_bool_154_1565_primed 0)))
(assert (< v_primed d_2528))
(assert (not (> v_bool_166_1564_primed 0)))
(assert (= l_primed 1))
(assert (or (and (and (< l_2482 1) (= m1_2478 0)) (= mx1_2484 0)) (and (and (<= 0 mx1_2484) (<= 1 m1_2478)) (> l_2482 0))))
(assert (or (and (and (< r_2485 1) (= m2_2479 0)) (= mx2_2487 0)) (and (and (<= 0 mx2_2487) (<= 1 m2_2479)) (> r_2485 0))))
(assert (or (and (and (< l_2529 1) (= m1_2525 0)) (= mx1_2531 0)) (and (and (<= 0 mx1_2531) (<= 1 m1_2525)) (> l_2529 0))))
(assert (or (and (and (< r_2532 1) (= m2_2526 0)) (= mx2_2534 0)) (and (and (<= 0 mx2_2534) (<= 1 m2_2526)) (> r_2532 0))))
;Negation of Consequence
(assert (not false))
(check-sat)