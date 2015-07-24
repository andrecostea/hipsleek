(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_118_4737 () Int)
(declare-fun n_3750 () Int)
(declare-fun Anon_5426 () Int)
(declare-fun n2_5425 () Int)
(declare-fun m2_5424 () Int)
(declare-fun Anon_5422 () Int)
(declare-fun n1_5421 () Int)
(declare-fun m1_5420 () Int)
(declare-fun q_5423 () Int)
(declare-fun p_5419 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n1_3754 () Int)
(declare-fun tn_3773 () Int)
(declare-fun resn_3797 () Int)
(declare-fun resb_3798 () Int)
(declare-fun n2_3758 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun v_int_89_4442 () Int)
(declare-fun n () Int)
(declare-fun b_3814 () Int)
(declare-fun n_3834 () Int)
(declare-fun b_3835 () Int)
(declare-fun v_int_118_5414 () Int)
(declare-fun n_4487 () Int)
(declare-fun b_4488 () Int)
(declare-fun v_node_87_3808 () Int)
(declare-fun n_4598 () Int)
(declare-fun b_4599 () Int)
(declare-fun q_3756 () Int)
(declare-fun m_4597 () Int)
(declare-fun m_4486 () Int)
(declare-fun m_3833 () Int)
(declare-fun m () Int)
(declare-fun flted_74_3796 () Int)
(declare-fun tm_3772 () Int)
(declare-fun m2_3757 () Int)
(declare-fun m1_3753 () Int)
(declare-fun tm () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= height_118_4737 n_3750))
(assert (<= b_3835 2))
(assert (<= 0 b_3835))
(assert (<= 0 n_3834))
(assert (<= b_3814 2))
(assert (<= 0 b_3814))
(assert (<= 0 n))
(assert (<= Anon_3759 2))
(assert (<= 0 Anon_3759))
(assert (<= 0 n2_3758))
(assert (<= resb_3798 2))
(assert (<= 0 resb_3798))
(assert (<= 0 resn_3797))
(assert (<= 0 tn_3773))
(assert (<= 0 n1_3754))
(assert (= n_3750 tn))
(assert (exists ((flted_76_5462 Int)) (= (+ flted_76_5462 n2_5425) (+ 1 n1_5421))))
(assert (exists ((max_5461 Int)) (and (= v_int_118_5414 (+ max_5461 1)) (or (and (= max_5461 n1_5421) (>= n1_5421 n2_5425)) (and (= max_5461 n2_5425) (< n1_5421 n2_5425))))))
(assert (= Anon_5426 b_4599))
(assert (= n2_5425 n_4598))
(assert (= m2_5424 m_4597))
(assert (= Anon_5422 b_4488))
(assert (= n1_5421 n_4487))
(assert (= m1_5420 m_4486))
(assert (= q_5423 q_3756))
(assert (= p_5419 v_node_87_3808))
(assert (not (= v_int_89_4442 2)))
(assert (exists ((max_5460 Int)) (and (= tn (+ max_5460 1)) (or (and (= max_5460 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5460 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= tn_3773 n1_3754))
(assert (< 0 tn_3773))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (= n resn_3797))
(assert (= b_3814 resb_3798))
(assert (= n_3834 n2_3758))
(assert (= b_3835 Anon_3759))
(assert (= (+ v_int_89_4442 n_3834) n))
(assert (= n_4487 n))
(assert (= b_4488 b_3814))
(assert (<= 0 n_4487))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (= n_4598 n_3834))
(assert (= b_4599 b_3835))
(assert (<= 0 n_4598))
(assert (<= 0 b_4599))
(assert (<= b_4599 2))
(assert (< n_4487 n_4598))
(assert (= v_int_118_5414 (+ 1 n_4598)))
(assert (or (and (and (and (< v_node_87_3808 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> v_node_87_3808 0))))
(assert (or (and (and (and (< q_3756 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> q_3756 0))))
(assert (<= 0 m_4597))
(assert (<= 0 m_3833))
(assert (= m_4597 m_3833))
(assert (<= 0 m_4486))
(assert (<= 0 m))
(assert (= m_4486 m))
(assert (<= 0 m2_3757))
(assert (= m_3833 m2_3757))
(assert (<= 0 flted_74_3796))
(assert (= m flted_74_3796))
(assert (<= 0 tm_3772))
(assert (< 0 tm_3772))
(assert (= flted_74_3796 (+ 1 tm_3772)))
(assert (<= 0 m1_3753))
(assert (= tm_3772 m1_3753))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
;Negation of Consequence
(assert (not (<= 0 tm)))
(check-sat)