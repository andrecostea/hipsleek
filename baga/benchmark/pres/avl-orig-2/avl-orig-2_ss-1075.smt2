(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tm_4066 () Int)
(declare-fun Anon_6288 () Int)
(declare-fun n2_6287 () Int)
(declare-fun m2_6286 () Int)
(declare-fun Anon_6284 () Int)
(declare-fun n1_6283 () Int)
(declare-fun m1_6282 () Int)
(declare-fun q_6285 () Int)
(declare-fun p_6281 () Int)
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun flted_76_4095 () Int)
(declare-fun flted_76_4094 () Int)
(declare-fun flted_76_4093 () Int)
(declare-fun m1_3753 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun m_4127 () Int)
(declare-fun b_4129 () Int)
(declare-fun m () Int)
(declare-fun b_4108 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun p_3752 () Int)
(declare-fun b_4599 () Int)
(declare-fun m_4597 () Int)
(declare-fun v_node_107_4104 () Int)
(declare-fun height_118_4742 () Int)
(declare-fun v_int_118_6276 () Int)
(declare-fun n_4598 () Int)
(declare-fun n_4487 () Int)
(declare-fun v_int_108_4476 () Int)
(declare-fun n () Int)
(declare-fun n_4128 () Int)
(declare-fun tn_4067 () Int)
(declare-fun b () Int)
(declare-fun n1_3754 () Int)
(declare-fun n2_3758 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_4108 2))
(assert (<= 0 b_4108))
(assert (<= 0 m))
(assert (<= b_4129 2))
(assert (<= 0 b_4129))
(assert (<= 0 m_4127))
(assert (<= Anon_3755 2))
(assert (<= 0 Anon_3755))
(assert (<= 0 m1_3753))
(assert (<= flted_76_4093 2))
(assert (<= 0 flted_76_4093))
(assert (<= 0 flted_76_4094))
(assert (<= 0 flted_76_4095))
(assert (<= 0 tm_4066))
(assert (= tm_4066 0))
(assert (<= 0 m2_3757))
(assert (= tm_4066 m2_3757))
(assert (exists ((flted_76_6327 Int)) (= (+ flted_76_6327 n2_6287) (+ 1 n1_6283))))
(assert (exists ((max_6326 Int)) (and (= v_int_118_6276 (+ max_6326 1)) (or (and (= max_6326 n1_6283) (>= n1_6283 n2_6287)) (and (= max_6326 n2_6287) (< n1_6283 n2_6287))))))
(assert (= Anon_6288 b_4599))
(assert (= n2_6287 n_4598))
(assert (= m2_6286 m_4597))
(assert (= Anon_6284 b_4488))
(assert (= n1_6283 n_4487))
(assert (= m1_6282 m_4486))
(assert (= q_6285 v_node_107_4104))
(assert (= p_6281 p_3752))
(assert (not (= v_int_108_4476 2)))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (= flted_76_4095 1))
(assert (= flted_76_4094 1))
(assert (= flted_76_4093 1))
(assert (= m flted_76_4095))
(assert (= n flted_76_4094))
(assert (= b_4108 flted_76_4093))
(assert (= m_4127 m1_3753))
(assert (= b_4129 Anon_3755))
(assert (= m_4486 m_4127))
(assert (= b_4488 b_4129))
(assert (<= 0 m_4486))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (= m_4597 m))
(assert (= b_4599 b_4108))
(assert (<= 0 m_4597))
(assert (<= 0 b_4599))
(assert (<= b_4599 2))
(assert (or (and (and (and (< p_3752 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> p_3752 0))))
(assert (or (and (and (and (< v_node_107_4104 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> v_node_107_4104 0))))
(assert (= height_118_4742 n_3750))
(assert (= v_int_118_6276 (+ 1 n_4487)))
(assert (<= n_4598 n_4487))
(assert (<= 0 n_4598))
(assert (<= 0 n))
(assert (= n_4598 n))
(assert (<= 0 n_4487))
(assert (<= 0 n_4128))
(assert (= n_4487 n_4128))
(assert (= (+ v_int_108_4476 n_4128) n))
(assert (<= 0 n1_3754))
(assert (= n_4128 n1_3754))
(assert (<= 0 tn_4067))
(assert (= tn_4067 0))
(assert (<= 0 n2_3758))
(assert (= tn_4067 n2_3758))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_6325 Int)) (and (= tn (+ max_6325 1)) (or (and (= max_6325 n1_3754) (>= n1_3754 n2_3758)) (and (= max_6325 n2_3758) (< n1_3754 n2_3758))))))
(assert (= n_3750 tn))
;Negation of Consequence
(assert (not (<= 0 tn)))
(check-sat)