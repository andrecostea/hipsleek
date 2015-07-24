(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_166_1564_primed () Int)
(declare-fun v_bool_154_1565_primed () Int)
(declare-fun m3_2527 () Int)
(declare-fun d_2481 () Int)
(declare-fun m3_2480 () Int)
(declare-fun m1_2483 () Int)
(declare-fun m2_2486 () Int)
(declare-fun v_bool_141_1566_primed () Int)
(declare-fun v_bool_132_1567_primed () Int)
(declare-fun m2_2365 () Int)
(declare-fun m1_2364 () Int)
(declare-fun mx2 () Int)
(declare-fun mx1 () Int)
(declare-fun r () Int)
(declare-fun l () Int)
(declare-fun m2_primed () Int)
(declare-fun m2 () Int)
(declare-fun m1_primed () Int)
(declare-fun m1 () Int)
(declare-fun v () Int)
(declare-fun d_2617 () Int)
(declare-fun d () Int)
(declare-fun d_primed () Int)
(declare-fun d_2528 () Int)
(declare-fun m2_2526 () Int)
(declare-fun mx2_2534 () Int)
(declare-fun m1_2525 () Int)
(declare-fun mx1_2531 () Int)
(declare-fun v_primed () Int)
(declare-fun max1_2659 () Int)
(declare-fun max2_2660 () Int)
(declare-fun v_int_172_1563_primed () Int)
(declare-fun mx1_2638 () Int)
(declare-fun mx2_2639 () Int)
(declare-fun mx1_2484 () Int)
(declare-fun m1_2478 () Int)
(declare-fun l_2482 () Int)
(declare-fun mx2_2487 () Int)
(declare-fun m2_2479 () Int)
(declare-fun r_2485 () Int)
(declare-fun mx3_2661 () Int)
(declare-fun m1_2530 () Int)
(declare-fun l_2529 () Int)
(declare-fun mx4_2662 () Int)
(declare-fun m2_2533 () Int)
(declare-fun r_2532 () Int)
(declare-fun l_primed () Int)
(declare-fun r_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_166_1564_primed 0)))
(assert (< v_primed d_2528))
(assert (not (> v_bool_154_1565_primed 0)))
(assert (< d_2481 d_2528))
(assert (= m2_2365 (+ (+ m2_2533 1) m1_2530)))
(assert (<= 0 d_2528))
(assert (<= mx1_2531 d_2528))
(assert (<= mx2_2534 d_2528))
(assert (<= d_2528 mx2))
(assert (= (+ m3_2527 m2_2533) m1_2530))
(assert (<= 0 m3_2527))
(assert (<= m3_2527 1))
(assert (= m1_2525 m1_2530))
(assert (= m2_2526 m2_2533))
(assert (= m1_2364 (+ (+ m2_2486 1) m1_2483)))
(assert (<= 0 d_2481))
(assert (<= mx1_2484 d_2481))
(assert (<= mx2_2487 d_2481))
(assert (<= d_2481 mx1))
(assert (= (+ m3_2480 m2_2486) m1_2483))
(assert (<= 0 m3_2480))
(assert (<= m3_2480 1))
(assert (= m1_2478 m1_2483))
(assert (= m2_2479 m2_2486))
(assert (not (> v_bool_141_1566_primed 0)))
(assert (not (= m2_primed 0)))
(assert (not (> v_bool_132_1567_primed 0)))
(assert (not (= m1_primed 0)))
(assert (= m2_2365 m2))
(assert (= m1_2364 m1))
(assert (<= v d))
(assert (<= 0 v))
(assert (<= mx2 d))
(assert (<= mx1 d))
(assert (<= m1 (+ 1 m2)))
(assert (<= (+ 0 m2) m1))
(assert (= r_primed r))
(assert (= l_primed l))
(assert (= m2_primed m2))
(assert (= m1_primed m1))
(assert (= v_primed v))
(assert (= d_2617 d))
(assert (= d_primed d_2528))
(assert (= mx1_2638 mx1_2531))
(assert (= mx2_2639 mx2_2534))
(assert (<= 0 m2_2526))
(assert (<= 0 mx2_2534))
(assert (<= 0 m1_2525))
(assert (<= 0 mx1_2531))
(assert (<= mx3_2661 mx1_2638))
(assert (<= mx4_2662 mx2_2639))
(assert (or (and (= max1_2659 mx1_2638) (>= mx1_2638 v_primed)) (and (= max1_2659 v_primed) (< mx1_2638 v_primed))))
(assert (or (and (= max2_2660 mx2_2639) (>= mx2_2639 max1_2659)) (and (= max2_2660 max1_2659) (< mx2_2639 max1_2659))))
(assert (<= v_int_172_1563_primed max2_2660))
(assert (<= mx3_2661 v_int_172_1563_primed))
(assert (<= mx4_2662 v_int_172_1563_primed))
(assert (<= 0 v_int_172_1563_primed))
(assert (exists ((m2_65 Int)) (<= 0 m2_65)))
(assert (exists ((m1_64 Int)) (<= 0 m1_64)))
(assert (<= 0 mx1_2638))
(assert (<= 0 mx2_2639))
(assert (= l_primed 1))
(assert (or (and (and (< l_2482 1) (= m1_2478 0)) (= mx1_2484 0)) (and (and (<= 0 mx1_2484) (<= 1 m1_2478)) (> l_2482 0))))
(assert (or (and (and (< r_2485 1) (= m2_2479 0)) (= mx2_2487 0)) (and (and (<= 0 mx2_2487) (<= 1 m2_2479)) (> r_2485 0))))
(assert (= r_primed 2))
(assert (or (and (and (< l_2529 1) (= m1_2530 0)) (= mx3_2661 0)) (and (and (<= 0 mx3_2661) (<= 1 m1_2530)) (> l_2529 0))))
(assert (or (and (and (< r_2532 1) (= m2_2533 0)) (= mx4_2662 0)) (and (and (<= 0 mx4_2662) (<= 1 m2_2533)) (> r_2532 0))))
(assert (not (= l_primed r_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)