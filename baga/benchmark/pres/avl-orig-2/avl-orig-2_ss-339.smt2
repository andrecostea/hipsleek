(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun b_4068 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun tn_4067 () Int)
(declare-fun tm_4066 () Int)
(declare-fun v_node_107_2140_primed () Int)
(declare-fun q_3756 () Int)
(declare-fun t () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_bool_80_2243_primed () Int)
(declare-fun n_3750 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n2_3758 () Int)
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun Anon_3751 () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_86_2211_primed () Int)
(declare-fun t_primed () Int)
(declare-fun n1_3754 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun m1_3753 () Int)
(declare-fun p_3752 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= b_4068 Anon_3759))
(assert (= tn_4067 n2_3758))
(assert (= tm_4066 m2_3757))
(assert (= v_node_107_2140_primed q_3756))
(assert (= t_primed t))
(assert (= x_primed x))
(assert (< tmp_primed 1))
(assert (> t_primed 0))
(assert (not (> v_bool_80_2243_primed 0)))
(assert (= n_3750 tn))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_79 Int)) (and (= tn (+ max_79 1)) (or (and (= max_79 n1_3754) (>= n1_3754 n2_3758)) (and (= max_79 n2_3758) (< n1_3754 n2_3758))))))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (<= Anon_3751 x_primed))
(assert (not (> v_bool_86_2211_primed 0)))
(assert (= t_primed 1))
(assert (or (and (and (and (< p_3752 1) (= m1_3753 0)) (= n1_3754 0)) (= Anon_3755 1)) (and (and (and (and (and (<= 0 Anon_3755) (<= (+ (- 0 n1_3754) 2) Anon_3755)) (<= Anon_3755 n1_3754)) (<= Anon_3755 2)) (<= 1 m1_3753)) (> p_3752 0))))
;Negation of Consequence
(assert (not false))
(check-sat)