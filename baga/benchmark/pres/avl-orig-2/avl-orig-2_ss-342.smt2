(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_86_2211_primed () Int)
(declare-fun Anon_3751 () Int)
(declare-fun tm () Int)
(declare-fun b () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
(declare-fun v_bool_80_2243_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun t () Int)
(declare-fun q_3756 () Int)
(declare-fun m2_3757 () Int)
(declare-fun n2_3758 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun v_node_107_2140_primed () Int)
(declare-fun tm_4066 () Int)
(declare-fun tn_4067 () Int)
(declare-fun b_4068 () Int)
(declare-fun t_primed () Int)
(declare-fun n1_3754 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun m1_3753 () Int)
(declare-fun p_3752 () Int)
(declare-fun resn_4075 () Int)
(declare-fun resb_4076 () Int)
(declare-fun flted_74_4074 () Int)
(declare-fun res () Int)
;Relations declarations
;Axioms assertions
;Antecedent
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
(assert (< tmp_primed 1))
(assert (= x_primed x))
(assert (= t_primed t))
(assert (= v_node_107_2140_primed q_3756))
(assert (= tm_4066 m2_3757))
(assert (= tn_4067 n2_3758))
(assert (= b_4068 Anon_3759))
(assert (<= 0 m2_3757))
(assert (<= 0 n2_3758))
(assert (<= 0 Anon_3759))
(assert (<= Anon_3759 2))
(assert (= flted_74_4074 (+ 1 tm_4066)))
(assert (> v_node_107_2140_primed 0))
(assert (< 0 tm_4066))
(assert (< 0 tn_4067))
(assert (or (= tn_4067 resn_4075) (and (= resn_4075 (+ 1 tn_4067)) (not (= resb_4076 1)))))
(assert (<= 0 tm_4066))
(assert (<= 0 tn_4067))
(assert (<= 0 b_4068))
(assert (<= b_4068 2))
(assert (= t_primed 1))
(assert (or (and (and (and (< p_3752 1) (= m1_3753 0)) (= n1_3754 0)) (= Anon_3755 1)) (and (and (and (and (and (<= 0 Anon_3755) (<= (+ (- 0 n1_3754) 2) Anon_3755)) (<= Anon_3755 n1_3754)) (<= Anon_3755 2)) (<= 1 m1_3753)) (> p_3752 0))))
(assert (or (and (and (and (< res 1) (= flted_74_4074 0)) (= resn_4075 0)) (= resb_4076 1)) (and (and (and (and (and (<= 0 resb_4076) (<= (+ (- 0 resn_4075) 2) resb_4076)) (<= resb_4076 resn_4075)) (<= resb_4076 2)) (<= 1 flted_74_4074)) (> res 0))))
;Negation of Consequence
(assert (not false))
(check-sat)