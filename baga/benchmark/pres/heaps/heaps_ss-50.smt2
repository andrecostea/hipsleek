(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_2160 () Int)
(declare-fun l_2157 () Int)
(declare-fun m2_2161 () Int)
(declare-fun m1_2158 () Int)
(declare-fun d_2156 () Int)
(declare-fun res () Int)
(declare-fun maxi_2149 () Int)
(declare-fun mx4_2148 () Int)
(declare-fun v_bool_82_1725_primed () Int)
(declare-fun v_boolean_82_2100 () Int)
(declare-fun v_boolean_82_2101 () Int)
(declare-fun mx2_2053 () Int)
(declare-fun d_2047 () Int)
(declare-fun mx () Int)
(declare-fun m3_2046 () Int)
(declare-fun m1_2044 () Int)
(declare-fun t_primed () Int)
(declare-fun t () Int)
(declare-fun n () Int)
(declare-fun m1_2049 () Int)
(declare-fun m2_2052 () Int)
(declare-fun mx1 () Int)
(declare-fun mx1_2050 () Int)
(declare-fun m2_2045 () Int)
(declare-fun r_2051 () Int)
(declare-fun mx2 () Int)
(declare-fun mx3_2147 () Int)
(declare-fun tnleft_2150 () Int)
(declare-fun tleft_2152 () Int)
(declare-fun tnright_2151 () Int)
(declare-fun tright_2153 () Int)
(declare-fun mx1_2159 () Int)
(declare-fun mx2_2162 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< tright_2153 1))
(assert (= tnright_2151 0))
(assert (= mx4_2148 0))
(assert (or (= tnleft_2150 0) (< tleft_2152 1)))
(assert (= r_2160 tright_2153))
(assert (= l_2157 tleft_2152))
(assert (= m2_2161 tnright_2151))
(assert (= m1_2158 tnleft_2150))
(assert (= d_2156 d_2047))
(assert (<= 0 mx2))
(assert (<= 0 mx1))
(assert (exists ((m1_70 Int)) (<= 0 m1_70)))
(assert (exists ((m2_71 Int)) (<= 0 m2_71)))
(assert (<= res maxi_2149))
(assert (<= 0 res))
(assert (or (and (= maxi_2149 mx1) (>= mx1 mx2)) (and (= maxi_2149 mx2) (< mx1 mx2))))
(assert (<= mx4_2148 mx2))
(assert (<= mx3_2147 mx1))
(assert (<= tnleft_2150 (+ 1 tnright_2151)))
(assert (<= (+ 0 tnright_2151) tnleft_2150))
(assert (= (+ (+ 1 tnleft_2150) tnright_2151) (+ m2_2052 m1_2049)))
(assert (<= 0 mx1_2050))
(assert (<= 0 m1_2044))
(assert (< r_2051 1))
(assert (= m2_2045 0))
(assert (= mx2_2053 0))
(assert (not (> v_bool_82_1725_primed 0)))
(assert (not (> v_boolean_82_2100 0)))
(assert (> v_boolean_82_2101 0))
(assert (= n (+ (+ m2_2052 1) m1_2049)))
(assert (<= 0 d_2047))
(assert (<= mx1_2050 d_2047))
(assert (<= mx2_2053 d_2047))
(assert (<= d_2047 mx))
(assert (= (+ m3_2046 m2_2052) m1_2049))
(assert (<= 0 m3_2046))
(assert (<= m3_2046 1))
(assert (= m1_2044 m1_2049))
(assert (= m2_2045 m2_2052))
(assert (= t_primed t))
(assert (< 0 n))
(assert (not (= m1_2049 0)))
(assert (= m2_2052 0))
(assert (= mx1 mx1_2050))
(assert (or (= m2_2045 0) (< r_2051 1)))
(assert (= mx2 0))
(assert (= mx3_2147 0))
(assert (= tnleft_2150 0))
(assert (< tleft_2152 1))
(assert (or (= tnright_2151 0) (< tright_2153 1)))
(assert (= mx1_2159 0))
(assert (= mx2_2162 0))
;Negation of Consequence
(assert (not false))
(check-sat)