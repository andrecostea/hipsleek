(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_108_2210_primed () Int)
(declare-fun v_bool_86_2211_primed () Int)
(declare-fun Anon_3751 () Int)
(declare-fun tm () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun v_bool_80_2243_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun t () Int)
(declare-fun m2_3757 () Int)
(declare-fun n2_3758 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun tm_4066 () Int)
(declare-fun tn_4067 () Int)
(declare-fun b_4068 () Int)
(declare-fun right_107_4097 () Int)
(declare-fun q_3756 () Int)
(declare-fun flted_74_4090 () Int)
(declare-fun resn_4091 () Int)
(declare-fun resb_4092 () Int)
(declare-fun m1_3753 () Int)
(declare-fun n1_3754 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun v_int_108_4474 () Int)
(declare-fun m_4127 () Int)
(declare-fun n_4128 () Int)
(declare-fun b_4129 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun b_4108 () Int)
(declare-fun v_int_118_5980 () Int)
(declare-fun height_118_4744 () Int)
(declare-fun n_3750 () Int)
(declare-fun res () Int)
(declare-fun n_4487 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun p_3752 () Int)
(declare-fun n_4598 () Int)
(declare-fun b_4599 () Int)
(declare-fun m_4597 () Int)
(declare-fun v_node_107_4102 () Int)
(declare-fun t_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_108_2210_primed 0)))
(assert (not (= v_int_108_4474 2)))
(assert (not (> v_bool_86_2211_primed 0)))
(assert (<= Anon_3751 x_primed))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (exists ((max_79 Int)) (and (= tn (+ max_79 1)) (or (and (= max_79 n1_3754) (>= n1_3754 n2_3758)) (and (= max_79 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= n_3750 tn))
(assert (not (> v_bool_80_2243_primed 0)))
(assert (> t_primed 0))
(assert (= x_primed x))
(assert (= t_primed t))
(assert (= tm_4066 m2_3757))
(assert (= tn_4067 n2_3758))
(assert (= b_4068 Anon_3759))
(assert (<= 0 m2_3757))
(assert (<= 0 n2_3758))
(assert (<= 0 Anon_3759))
(assert (<= Anon_3759 2))
(assert (= flted_74_4090 (+ 1 tm_4066)))
(assert (> q_3756 0))
(assert (< 0 tm_4066))
(assert (< 0 tn_4067))
(assert (or (= tn_4067 resn_4091) (and (= resn_4091 (+ 1 tn_4067)) (not (= resb_4092 1)))))
(assert (<= 0 tm_4066))
(assert (<= 0 tn_4067))
(assert (<= 0 b_4068))
(assert (<= b_4068 2))
(assert (= right_107_4097 q_3756))
(assert (= m flted_74_4090))
(assert (= n resn_4091))
(assert (= b_4108 resb_4092))
(assert (<= 0 flted_74_4090))
(assert (<= 0 resn_4091))
(assert (<= 0 resb_4092))
(assert (<= resb_4092 2))
(assert (= m_4127 m1_3753))
(assert (= n_4128 n1_3754))
(assert (= b_4129 Anon_3755))
(assert (<= 0 m1_3753))
(assert (<= 0 n1_3754))
(assert (<= 0 Anon_3755))
(assert (<= Anon_3755 2))
(assert (= (+ v_int_108_4474 n_4128) n))
(assert (= m_4486 m_4127))
(assert (= n_4487 n_4128))
(assert (= b_4488 b_4129))
(assert (<= 0 m_4127))
(assert (<= 0 n_4128))
(assert (<= 0 b_4129))
(assert (<= b_4129 2))
(assert (<= 0 m_4486))
(assert (<= 0 n_4487))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (= m_4597 m))
(assert (= n_4598 n))
(assert (= b_4599 b_4108))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b_4108))
(assert (<= b_4108 2))
(assert (<= 0 m_4597))
(assert (<= 0 n_4598))
(assert (<= 0 b_4599))
(assert (<= b_4599 2))
(assert (<= n_4598 n_4487))
(assert (= v_int_118_5980 (+ 1 n_4487)))
(assert (= height_118_4744 n_3750))
(assert (= res t_primed))
(assert (or (and (and (and (< p_3752 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> p_3752 0))))
(assert (or (and (and (and (< v_node_107_4102 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> v_node_107_4102 0))))
(assert (= t_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)