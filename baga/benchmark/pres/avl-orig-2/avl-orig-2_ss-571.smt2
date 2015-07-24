(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_118_2236_primed () Int)
(declare-fun v_int_118_2237_primed () Int)
(declare-fun b_3835 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun n_3834 () Int)
(declare-fun m_3833 () Int)
(declare-fun b_3814 () Int)
(declare-fun n () Int)
(declare-fun m () Int)
(declare-fun left_87_3803 () Int)
(declare-fun resn_3797 () Int)
(declare-fun resb_3798 () Int)
(declare-fun p_3752 () Int)
(declare-fun flted_74_3796 () Int)
(declare-fun b_3774 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun tn_3773 () Int)
(declare-fun tm_3772 () Int)
(declare-fun t () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_bool_80_2243_primed () Int)
(declare-fun n_3750 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3754 () Int)
(declare-fun n2_3758 () Int)
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun m1_3753 () Int)
(declare-fun x_primed () Int)
(declare-fun Anon_3751 () Int)
(declare-fun v_bool_86_2211_primed () Int)
(declare-fun v_int_89_4442 () Int)
(declare-fun v_bool_89_2132_primed () Int)
(declare-fun t_primed () Int)
(declare-fun n_4487 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun v_node_87_3808 () Int)
(declare-fun n_4598 () Int)
(declare-fun b_4599 () Int)
(declare-fun m_4597 () Int)
(declare-fun q_3756 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_int_118_2236_primed 1))
(assert (<= n_4598 n_4487))
(assert (= v_int_118_2237_primed n_4487))
(assert (<= b_4599 2))
(assert (<= 0 b_4599))
(assert (<= 0 n_4598))
(assert (<= 0 m_4597))
(assert (<= b_3835 2))
(assert (<= 0 b_3835))
(assert (<= 0 n_3834))
(assert (<= 0 m_3833))
(assert (= b_4599 b_3835))
(assert (= n_4598 n_3834))
(assert (= m_4597 m_3833))
(assert (<= b_4488 2))
(assert (<= 0 b_4488))
(assert (<= 0 n_4487))
(assert (<= 0 m_4486))
(assert (<= b_3814 2))
(assert (<= 0 b_3814))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (= b_4488 b_3814))
(assert (= n_4487 n))
(assert (= m_4486 m))
(assert (= (+ v_int_89_4442 n_3834) n))
(assert (<= Anon_3759 2))
(assert (<= 0 Anon_3759))
(assert (<= 0 n2_3758))
(assert (<= 0 m2_3757))
(assert (= b_3835 Anon_3759))
(assert (= n_3834 n2_3758))
(assert (= m_3833 m2_3757))
(assert (<= resb_3798 2))
(assert (<= 0 resb_3798))
(assert (<= 0 resn_3797))
(assert (<= 0 flted_74_3796))
(assert (= b_3814 resb_3798))
(assert (= n resn_3797))
(assert (= m flted_74_3796))
(assert (= left_87_3803 p_3752))
(assert (<= b_3774 2))
(assert (<= 0 b_3774))
(assert (<= 0 tn_3773))
(assert (<= 0 tm_3772))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (< 0 tn_3773))
(assert (< 0 tm_3772))
(assert (> p_3752 0))
(assert (= flted_74_3796 (+ 1 tm_3772)))
(assert (<= Anon_3755 2))
(assert (<= 0 Anon_3755))
(assert (<= 0 n1_3754))
(assert (<= 0 m1_3753))
(assert (= b_3774 Anon_3755))
(assert (= tn_3773 n1_3754))
(assert (= tm_3772 m1_3753))
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
(assert (< x_primed Anon_3751))
(assert (> v_bool_86_2211_primed 0))
(assert (not (= v_int_89_4442 2)))
(assert (not (> v_bool_89_2132_primed 0)))
(assert (= t_primed 1))
(assert (or (and (and (and (< v_node_87_3808 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> v_node_87_3808 0))))
(assert (or (and (and (and (< q_3756 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> q_3756 0))))
;Negation of Consequence
(assert (not false))
(check-sat)