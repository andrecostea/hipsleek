(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun v_bool_105_1591_primed () Int)
(declare-fun x () Int)
(declare-fun m1_2211 () Int)
(declare-fun n1_2212 () Int)
(declare-fun n_2219 () Int)
(declare-fun m2_2214 () Int)
(declare-fun n2_2215 () Int)
(declare-fun n_2232 () Int)
(declare-fun Anon_18 () Int)
(declare-fun q_2228 () Int)
(declare-fun Anon_19 () Int)
(declare-fun q_2241 () Int)
(declare-fun m_2231 () Int)
(declare-fun m_2218 () Int)
(declare-fun m_2248 () Int)
(declare-fun n_2249 () Int)
(declare-fun v_null_type_110_2270 () Int)
(declare-fun left_110_2266 () Int)
(declare-fun p_2210 () Int)
(declare-fun right_111_2271 () Int)
(declare-fun q_2213 () Int)
(declare-fun flted_40_2264 () Int)
(declare-fun tmp_primed () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m (+ (+ m2_2214 1) m1_2211)))
(assert (exists ((max_42 Int)) (and (= n (+ max_42 1)) (or (and (= max_42 n1_2212) (>= n1_2212 n2_2215)) (and (= max_42 n2_2215) (< n1_2212 n2_2215))))))
(assert (> v_bool_105_1591_primed 0))
(assert (> x_primed 0))
(assert (= x_primed x))
(assert (= m_2218 m1_2211))
(assert (= n_2219 n1_2212))
(assert (<= 0 m1_2211))
(assert (<= 0 n1_2212))
(assert (< q_2228 1))
(assert (<= 0 n_2219))
(assert (= m_2231 m2_2214))
(assert (= n_2232 n2_2215))
(assert (<= 0 m2_2214))
(assert (<= 0 n2_2215))
(assert (< q_2241 1))
(assert (<= 0 n_2232))
(assert (= Anon_18 q_2228))
(assert (= m_2248 m_2218))
(assert (= Anon_19 q_2241))
(assert (= n_2249 m_2231))
(assert (<= 0 m_2231))
(assert (<= 0 m_2218))
(assert (= flted_40_2264 (+ n_2249 m_2248)))
(assert (<= 0 m_2248))
(assert (<= 0 n_2249))
(assert (< v_null_type_110_2270 1))
(assert (= left_110_2266 p_2210))
(assert (= right_111_2271 q_2213))
(assert (> tmp_primed 0))
(assert (or (and (< tmp_primed 1) (= flted_40_2264 0)) (and (<= 1 flted_40_2264) (> tmp_primed 0))))
(assert (= x_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)