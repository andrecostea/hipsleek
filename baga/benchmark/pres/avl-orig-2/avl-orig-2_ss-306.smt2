(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_3913 () Int)
(declare-fun v_bool_89_2132_primed () Int)
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
(declare-fun m1_3753 () Int)
(declare-fun n1_3754 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun tm_3772 () Int)
(declare-fun tn_3773 () Int)
(declare-fun b_3774 () Int)
(declare-fun left_87_3803 () Int)
(declare-fun p_3752 () Int)
(declare-fun flted_74_3796 () Int)
(declare-fun resn_3797 () Int)
(declare-fun resb_3798 () Int)
(declare-fun m () Int)
(declare-fun b_3814 () Int)
(declare-fun m2_3757 () Int)
(declare-fun n2_3758 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun n () Int)
(declare-fun m1_3916 () Int)
(declare-fun n1_3917 () Int)
(declare-fun Anon_3918 () Int)
(declare-fun v_int_90_2124_primed () Int)
(declare-fun q_3919 () Int)
(declare-fun m2_3920 () Int)
(declare-fun n2_3921 () Int)
(declare-fun Anon_3922 () Int)
(declare-fun res () Int)
(declare-fun m_3944 () Int)
(declare-fun n_3945 () Int)
(declare-fun b_3946 () Int)
(declare-fun n_3834 () Int)
(declare-fun b_3835 () Int)
(declare-fun m_3833 () Int)
(declare-fun q_3756 () Int)
(declare-fun n_3926 () Int)
(declare-fun b_3927 () Int)
(declare-fun m_3925 () Int)
(declare-fun p_3915 () Int)
(declare-fun n_3952 () Int)
(declare-fun b_3953 () Int)
(declare-fun m_3951 () Int)
(declare-fun v_node_90_2119_primed () Int)
(declare-fun t_primed () Int)
(declare-fun v_node_87_3808 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m (+ (+ m2_3920 1) m1_3916)))
(assert (exists ((max_79 Int)) (and (= n (+ max_79 1)) (or (and (= max_79 n1_3917) (>= n1_3917 n2_3921)) (and (= max_79 n2_3921) (< n1_3917 n2_3921))))))
(assert (<= (+ 0 n2_3921) (+ n1_3917 1)))
(assert (<= n1_3917 (+ 1 n2_3921)))
(assert (= (+ b_3814 n2_3921) (+ 1 n1_3917)))
(assert (= n_3913 n))
(assert (> v_bool_89_2132_primed 0))
(assert (> v_bool_86_2211_primed 0))
(assert (< x_primed Anon_3751))
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
(assert (= tm_3772 m1_3753))
(assert (= tn_3773 n1_3754))
(assert (= b_3774 Anon_3755))
(assert (<= 0 m1_3753))
(assert (<= 0 n1_3754))
(assert (<= 0 Anon_3755))
(assert (<= Anon_3755 2))
(assert (= flted_74_3796 (+ 1 tm_3772)))
(assert (> p_3752 0))
(assert (< 0 tm_3772))
(assert (< 0 tn_3773))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (<= 0 tm_3772))
(assert (<= 0 tn_3773))
(assert (<= 0 b_3774))
(assert (<= b_3774 2))
(assert (= left_87_3803 p_3752))
(assert (= m flted_74_3796))
(assert (= n resn_3797))
(assert (= b_3814 resb_3798))
(assert (<= 0 flted_74_3796))
(assert (<= 0 resn_3797))
(assert (<= 0 resb_3798))
(assert (<= resb_3798 2))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b_3814))
(assert (<= b_3814 2))
(assert (= m_3833 m2_3757))
(assert (= n_3834 n2_3758))
(assert (= b_3835 Anon_3759))
(assert (<= 0 m2_3757))
(assert (<= 0 n2_3758))
(assert (<= 0 Anon_3759))
(assert (<= Anon_3759 2))
(assert (<= 0 m_3833))
(assert (<= 0 n_3834))
(assert (<= 0 b_3835))
(assert (<= b_3835 2))
(assert (= (+ 2 n_3834) n))
(assert (= m_3925 m1_3916))
(assert (= n_3926 n1_3917))
(assert (= b_3927 Anon_3918))
(assert (<= 0 m1_3916))
(assert (<= 0 n1_3917))
(assert (<= 0 Anon_3918))
(assert (<= Anon_3918 2))
(assert (= v_int_90_2124_primed n_3926))
(assert (<= 0 m_3925))
(assert (<= 0 n_3926))
(assert (<= 0 b_3927))
(assert (<= b_3927 2))
(assert (= v_node_90_2119_primed q_3919))
(assert (= m_3944 m2_3920))
(assert (= n_3945 n2_3921))
(assert (= b_3946 Anon_3922))
(assert (<= 0 m2_3920))
(assert (<= 0 n2_3921))
(assert (<= 0 Anon_3922))
(assert (<= Anon_3922 2))
(assert (= res n_3945))
(assert (= m_3951 m_3944))
(assert (= n_3952 n_3945))
(assert (= b_3953 b_3946))
(assert (<= 0 m_3944))
(assert (<= 0 n_3945))
(assert (<= 0 b_3946))
(assert (<= b_3946 2))
(assert (= t_primed 1))
(assert (= v_node_87_3808 2))
(assert (or (and (and (and (< q_3756 1) (= m_3833 0)) (= n_3834 0)) (= b_3835 1)) (and (and (and (and (and (<= 0 b_3835) (<= (+ (- 0 n_3834) 2) b_3835)) (<= b_3835 n_3834)) (<= b_3835 2)) (<= 1 m_3833)) (> q_3756 0))))
(assert (or (and (and (and (< p_3915 1) (= m_3925 0)) (= n_3926 0)) (= b_3927 1)) (and (and (and (and (and (<= 0 b_3927) (<= (+ (- 0 n_3926) 2) b_3927)) (<= b_3927 n_3926)) (<= b_3927 2)) (<= 1 m_3925)) (> p_3915 0))))
(assert (or (and (and (and (< v_node_90_2119_primed 1) (= m_3951 0)) (= n_3952 0)) (= b_3953 1)) (and (and (and (and (and (<= 0 b_3953) (<= (+ (- 0 n_3952) 2) b_3953)) (<= b_3953 n_3952)) (<= b_3953 2)) (<= 1 m_3951)) (> v_node_90_2119_primed 0))))
(assert (not (= t_primed v_node_87_3808)))
;Negation of Consequence
(assert (not false))
(check-sat)