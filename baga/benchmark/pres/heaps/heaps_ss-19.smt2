(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun t () Int)
(declare-fun m3_2046 () Int)
(declare-fun mx () Int)
(declare-fun d_2047 () Int)
(declare-fun n () Int)
(declare-fun m2_2052 () Int)
(declare-fun m1_2049 () Int)
(declare-fun v_boolean_82_1710_primed () Int)
(declare-fun v_boolean_82_1711_primed () Int)
(declare-fun v_bool_82_1725_primed () Int)
(declare-fun t_primed () Int)
(declare-fun mx1_2050 () Int)
(declare-fun m1_2044 () Int)
(declare-fun l_2048 () Int)
(declare-fun mx2_2053 () Int)
(declare-fun m2_2045 () Int)
(declare-fun r_2051 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m2_2052 0))
(assert (not (= m1_2049 0)))
(assert (< 0 n))
(assert (= t_primed t))
(assert (= m2_2045 m2_2052))
(assert (= m1_2044 m1_2049))
(assert (<= m3_2046 1))
(assert (<= 0 m3_2046))
(assert (= (+ m3_2046 m2_2052) m1_2049))
(assert (<= d_2047 mx))
(assert (<= mx2_2053 d_2047))
(assert (<= mx1_2050 d_2047))
(assert (<= 0 d_2047))
(assert (= n (+ (+ m2_2052 1) m1_2049)))
(assert (> v_boolean_82_1710_primed 0))
(assert (not (> v_boolean_82_1711_primed 0)))
(assert (not (> v_bool_82_1725_primed 0)))
(assert (= t_primed 1))
(assert (or (and (and (< l_2048 1) (= m1_2044 0)) (= mx1_2050 0)) (and (and (<= 0 mx1_2050) (<= 1 m1_2044)) (> l_2048 0))))
(assert (or (and (and (< r_2051 1) (= m2_2045 0)) (= mx2_2053 0)) (and (and (<= 0 mx2_2053) (<= 1 m2_2045)) (> r_2051 0))))
;Negation of Consequence
(assert (not false))
(check-sat)