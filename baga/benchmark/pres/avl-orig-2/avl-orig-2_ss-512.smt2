(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_76_3801 () Int)
(declare-fun flted_76_3799 () Int)
(declare-fun m () Int)
(declare-fun b_3814 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun v_node_87_3810 () Int)
(declare-fun v_int_118_2232_primed () Int)
(declare-fun n_4487 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun flted_76_3800 () Int)
(declare-fun tn_3773 () Int)
(declare-fun tm_3772 () Int)
(declare-fun n_3750 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3754 () Int)
(declare-fun tm () Int)
(declare-fun m1_3753 () Int)
(declare-fun m2_3757 () Int)
(declare-fun n2_3758 () Int)
(declare-fun v_int_89_4444 () Int)
(declare-fun n () Int)
(declare-fun v_node_118_2227_primed () Int)
(declare-fun b_3835 () Int)
(declare-fun m_3833 () Int)
(declare-fun n_3834 () Int)
(declare-fun q_3756 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_3814 2))
(assert (<= 0 b_3814))
(assert (<= 0 m))
(assert (<= flted_76_3799 2))
(assert (<= 0 flted_76_3799))
(assert (<= 0 flted_76_3801))
(assert (= flted_76_3801 1))
(assert (= flted_76_3800 1))
(assert (= flted_76_3799 1))
(assert (= m flted_76_3801))
(assert (= b_3814 flted_76_3799))
(assert (= m_4486 m))
(assert (= b_4488 b_3814))
(assert (<= 0 m_4486))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (or (and (and (and (< v_node_87_3810 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> v_node_87_3810 0))))
(assert (<= 0 n_4487))
(assert (= v_int_118_2232_primed n_4487))
(assert (<= 0 n))
(assert (= n_4487 n))
(assert (<= b_3835 2))
(assert (<= 0 b_3835))
(assert (<= Anon_3759 2))
(assert (<= 0 Anon_3759))
(assert (<= 0 n2_3758))
(assert (<= 0 m2_3757))
(assert (= b_3835 Anon_3759))
(assert (<= 0 flted_76_3800))
(assert (= n flted_76_3800))
(assert (<= 0 tn_3773))
(assert (<= 0 tm_3772))
(assert (= tm_3772 0))
(assert (= tn_3773 0))
(assert (<= 0 n1_3754))
(assert (<= 0 m1_3753))
(assert (= tn_3773 n1_3754))
(assert (= tm_3772 m1_3753))
(assert (= n_3750 tn))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_4659 Int)) (and (= tn (+ max_4659 1)) (or (and (= max_4659 n1_3754) (>= n1_3754 n2_3758)) (and (= max_4659 n2_3758) (< n1_3754 n2_3758))))))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (not (= v_int_89_4444 2)))
(assert (= m_3833 m2_3757))
(assert (= n_3834 n2_3758))
(assert (<= 0 m_3833))
(assert (<= 0 n_3834))
(assert (= (+ v_int_89_4444 n_3834) n))
(assert (= v_node_118_2227_primed q_3756))
(assert (or (and (and (and (< q_3756 1) (= m_3833 0)) (= n_3834 0)) (= b_3835 1)) (and (and (and (and (and (<= 0 b_3835) (<= (+ (- 0 n_3834) 2) b_3835)) (<= b_3835 n_3834)) (<= b_3835 2)) (<= 1 m_3833)) (> q_3756 0))))
;Negation of Consequence
(assert (not (or (= m_3833 0) (or (= n_3834 0) (< q_3756 1)))))
(check-sat)