(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_4610 () Int)
(declare-fun n2_4609 () Int)
(declare-fun m2_4608 () Int)
(declare-fun Anon_4606 () Int)
(declare-fun n1_4605 () Int)
(declare-fun m1_4604 () Int)
(declare-fun q_4607 () Int)
(declare-fun resrr_4421 () Int)
(declare-fun p_4603 () Int)
(declare-fun resrl_4419 () Int)
(declare-fun Anon_4602 () Int)
(declare-fun Anon_4418 () Int)
(declare-fun v_bool_90_2131_primed () Int)
(declare-fun v_bool_89_2132_primed () Int)
(declare-fun v_bool_86_2211_primed () Int)
(declare-fun tm () Int)
(declare-fun b () Int)
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
(declare-fun m2_3920 () Int)
(declare-fun n2_3921 () Int)
(declare-fun Anon_3922 () Int)
(declare-fun Anon_44 () Int)
(declare-fun Anon_3751 () Int)
(declare-fun Anon_45 () Int)
(declare-fun n_3750 () Int)
(declare-fun l () Int)
(declare-fun r () Int)
(declare-fun q_3756 () Int)
(declare-fun Anon_47 () Int)
(declare-fun Anon_3914 () Int)
(declare-fun Anon_48 () Int)
(declare-fun n_3913 () Int)
(declare-fun ll () Int)
(declare-fun p_3915 () Int)
(declare-fun lr () Int)
(declare-fun q_3919 () Int)
(declare-fun m_3944 () Int)
(declare-fun n_3945 () Int)
(declare-fun b_3946 () Int)
(declare-fun m_3925 () Int)
(declare-fun n_3926 () Int)
(declare-fun b_3927 () Int)
(declare-fun v_node_87_3808 () Int)
(declare-fun m_3833 () Int)
(declare-fun n_3834 () Int)
(declare-fun b_3835 () Int)
(declare-fun t_3988 () Int)
(declare-fun tmp1_4423 () Int)
(declare-fun resn_4424 () Int)
(declare-fun tmp2_4425 () Int)
(declare-fun resrn_4426 () Int)
(declare-fun Anon_46 () Int)
(declare-fun Anon_49 () Int)
(declare-fun Anon_50 () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun Anon_4416 () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun Anon_4422 () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun Anon_4420 () Int)
(declare-fun res () Int)
(declare-fun v_int_118_2232_primed () Int)
(declare-fun v_int_118_2231_primed () Int)
(declare-fun t_primed () Int)
(declare-fun n_4487 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun resl_4415 () Int)
(declare-fun n_4598 () Int)
(declare-fun b_4599 () Int)
(declare-fun m_4597 () Int)
(declare-fun resr_4417 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m_4597 (+ (+ m2_4608 1) m1_4604)))
(assert (exists ((max_79 Int)) (and (= n_4598 (+ max_79 1)) (or (and (= max_79 n1_4605) (>= n1_4605 n2_4609)) (and (= max_79 n2_4609) (< n1_4605 n2_4609))))))
(assert (= (+ b_4599 n2_4609) (+ 1 n1_4605)))
(assert (= resrn_4426 n_4598))
(assert (or (and (= resrn_4426 (+ n1_4605 1)) (<= n2_4609 n1_4605)) (and (= resrn_4426 (+ n2_4609 1)) (< n1_4605 n2_4609))))
(assert (<= (+ 0 n2_4609) (+ n1_4605 1)))
(assert (<= n1_4605 (+ 1 n2_4609)))
(assert (= Anon_4610 Anon_4422))
(assert (= n2_4609 cn))
(assert (= m2_4608 cm))
(assert (= Anon_4606 Anon_4420))
(assert (= n1_4605 bn))
(assert (= m1_4604 bm))
(assert (= q_4607 resrr_4421))
(assert (= p_4603 resrl_4419))
(assert (= Anon_4602 Anon_4418))
(assert (> v_bool_90_2131_primed 0))
(assert (< n_3945 n_3926))
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
(assert (< tmp_primed 1))
(assert (= x_primed x))
(assert (= t_3988 t))
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
(assert (= (+ 2 n_3834) n))
(assert (= m_3925 m1_3916))
(assert (= n_3926 n1_3917))
(assert (= b_3927 Anon_3918))
(assert (<= 0 m1_3916))
(assert (<= 0 n1_3917))
(assert (<= 0 Anon_3918))
(assert (<= Anon_3918 2))
(assert (= m_3944 m2_3920))
(assert (= n_3945 n2_3921))
(assert (= b_3946 Anon_3922))
(assert (<= 0 m2_3920))
(assert (<= 0 n2_3921))
(assert (<= 0 Anon_3922))
(assert (<= Anon_3922 2))
(assert (= Anon_44 Anon_3751))
(assert (= Anon_45 n_3750))
(assert (= l v_node_87_3808))
(assert (= r q_3756))
(assert (= cm m_3833))
(assert (= cn n_3834))
(assert (= Anon_46 b_3835))
(assert (= Anon_47 Anon_3914))
(assert (= Anon_48 n_3913))
(assert (= ll p_3915))
(assert (= lr q_3919))
(assert (= am m_3925))
(assert (= an n_3926))
(assert (= Anon_49 b_3927))
(assert (= bm m_3944))
(assert (= bn n_3945))
(assert (= Anon_50 b_3946))
(assert (<= 0 m_3944))
(assert (<= 0 n_3945))
(assert (<= 0 b_3946))
(assert (<= b_3946 2))
(assert (<= 0 m_3925))
(assert (<= 0 n_3926))
(assert (<= 0 b_3927))
(assert (<= b_3927 2))
(assert (> v_node_87_3808 0))
(assert (<= 0 m_3833))
(assert (<= 0 n_3834))
(assert (<= 0 b_3835))
(assert (<= b_3835 2))
(assert (> t_3988 0))
(assert (= resrn_4426 (+ 1 tmp1_4423)))
(assert (or (and (= tmp1_4423 cn) (>= cn bn)) (and (= tmp1_4423 bn) (< cn bn))))
(assert (= resn_4424 (+ 1 tmp2_4425)))
(assert (or (and (= tmp2_4425 an) (>= an resrn_4426)) (and (= tmp2_4425 resrn_4426) (< an resrn_4426))))
(assert (<= 0 Anon_46))
(assert (<= Anon_46 2))
(assert (<= 0 Anon_49))
(assert (<= Anon_49 2))
(assert (<= 0 Anon_50))
(assert (<= Anon_50 2))
(assert (= m_4486 am))
(assert (= n_4487 an))
(assert (= b_4488 Anon_4416))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (<= 0 Anon_4416))
(assert (<= Anon_4416 2))
(assert (= v_int_118_2232_primed n_4487))
(assert (<= 0 m_4486))
(assert (<= 0 n_4487))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (<= 0 Anon_4422))
(assert (<= Anon_4422 2))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 Anon_4420))
(assert (<= Anon_4420 2))
(assert (> resr_4417 0))
(assert (= v_int_118_2231_primed n_4598))
(assert (<= 0 m_4597))
(assert (<= 0 n_4598))
(assert (<= 0 b_4599))
(assert (<= b_4599 2))
(assert (= res v_int_118_2231_primed))
(assert (< v_int_118_2232_primed v_int_118_2231_primed))
(assert (= t_primed 1))
(assert (or (and (and (and (< resl_4415 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> resl_4415 0))))
(assert (or (and (and (and (< resr_4417 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> resr_4417 0))))
;Negation of Consequence
(assert (not false))
(check-sat)