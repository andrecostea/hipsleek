(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun tm_4066 () Int)
(declare-fun m1_3753 () Int)
(declare-fun height_118_4739 () Int)
(declare-fun m_4127 () Int)
(declare-fun m_4238 () Int)
(declare-fun flted_74_4090 () Int)
(declare-fun am () Int)
(declare-fun bm () Int)
(declare-fun Anon_5700 () Int)
(declare-fun m2_5698 () Int)
(declare-fun m1_5694 () Int)
(declare-fun q_5697 () Int)
(declare-fun p_5693 () Int)
(declare-fun m2_4516 () Int)
(declare-fun m1_4512 () Int)
(declare-fun m () Int)
(declare-fun m1_4210 () Int)
(declare-fun m2_4214 () Int)
(declare-fun m_4219 () Int)
(declare-fun resn_4456 () Int)
(declare-fun cm () Int)
(declare-fun Anon_4450 () Int)
(declare-fun m_4486 () Int)
(declare-fun resl_4447 () Int)
(declare-fun b_4599 () Int)
(declare-fun m_4597 () Int)
(declare-fun resr_4449 () Int)
(declare-fun tmp2_4457 () Int)
(declare-fun cn () Int)
(declare-fun Anon_60 () Int)
(declare-fun n_4598 () Int)
(declare-fun v_int_118_5688 () Int)
(declare-fun n2_5699 () Int)
(declare-fun Anon_5696 () Int)
(declare-fun n1_5695 () Int)
(declare-fun b_4488 () Int)
(declare-fun n_4487 () Int)
(declare-fun n2_4517 () Int)
(declare-fun n1_4513 () Int)
(declare-fun n_4220 () Int)
(declare-fun n2_4215 () Int)
(declare-fun n_4207 () Int)
(declare-fun n1_4211 () Int)
(declare-fun n_4239 () Int)
(declare-fun resln_4458 () Int)
(declare-fun tmp1_4455 () Int)
(declare-fun bn () Int)
(declare-fun an () Int)
(declare-fun Anon_57 () Int)
(declare-fun n_4128 () Int)
(declare-fun b_4108 () Int)
(declare-fun n () Int)
(declare-fun resn_4091 () Int)
(declare-fun resb_4092 () Int)
(declare-fun tn_4067 () Int)
(declare-fun b () Int)
(declare-fun n1_3754 () Int)
(declare-fun n2_3758 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m1_3753))
(assert (<= 0 tm_4066))
(assert (< 0 tm_4066))
(assert (<= 0 m2_3757))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (= tm_4066 m2_3757))
(assert (= flted_74_4090 (+ 1 tm_4066)))
(assert (= m_4127 m1_3753))
(assert (= height_118_4739 resn_4456))
(assert (<= Anon_4450 2))
(assert (<= 0 Anon_4450))
(assert (<= 0 cm))
(assert (<= 0 am))
(assert (<= 0 bm))
(assert (<= 0 m_4127))
(assert (<= 0 m_4238))
(assert (<= 0 m_4219))
(assert (= bm m_4238))
(assert (= am m_4127))
(assert (<= 0 m1_4210))
(assert (= m_4238 m1_4210))
(assert (<= 0 m2_4214))
(assert (<= 0 m))
(assert (<= 0 flted_74_4090))
(assert (= m flted_74_4090))
(assert (= m1_4512 am))
(assert (= m2_4516 bm))
(assert (= Anon_5700 b_4599))
(assert (= m2_5698 m_4597))
(assert (= m1_5694 m_4486))
(assert (= q_5697 resr_4449))
(assert (= p_5693 resl_4447))
(assert (= m_4486 (+ (+ m2_4516 1) m1_4512)))
(assert (= m (+ (+ m2_4214 1) m1_4210)))
(assert (= m_4219 m2_4214))
(assert (= cm m_4219))
(assert (= resn_4456 (+ 1 tmp2_4457)))
(assert (> resl_4447 0))
(assert (<= 0 m_4486))
(assert (= m_4597 cm))
(assert (= b_4599 Anon_4450))
(assert (<= 0 m_4597))
(assert (<= 0 b_4599))
(assert (<= b_4599 2))
(assert (or (and (and (and (< resl_4447 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> resl_4447 0))))
(assert (or (and (and (and (< resr_4449 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> resr_4449 0))))
(assert (= v_int_118_5688 (+ 1 n_4487)))
(assert (<= n_4598 n_4487))
(assert (<= 0 n_4598))
(assert (<= 0 cn))
(assert (= n_4598 cn))
(assert (<= b_4488 2))
(assert (<= 0 b_4488))
(assert (<= 0 n_4487))
(assert (or (and (= tmp2_4457 resln_4458) (>= resln_4458 cn)) (and (= tmp2_4457 cn) (< resln_4458 cn))))
(assert (<= 0 n_4239))
(assert (<= 0 n_4220))
(assert (= cn n_4220))
(assert (= Anon_60 n_4207))
(assert (<= 0 n1_4211))
(assert (<= 0 n2_4215))
(assert (= n_4220 n2_4215))
(assert (= n2_5699 n_4598))
(assert (exists ((flted_76_5786 Int)) (= (+ flted_76_5786 n2_5699) (+ 1 n1_5695))))
(assert (exists ((max_5785 Int)) (and (= v_int_118_5688 (+ max_5785 1)) (or (and (= max_5785 n1_5695) (>= n1_5695 n2_5699)) (and (= max_5785 n2_5699) (< n1_5695 n2_5699))))))
(assert (= Anon_5696 b_4488))
(assert (= n1_5695 n_4487))
(assert (exists ((max_5784 Int)) (and (= n_4487 (+ max_5784 1)) (or (and (= max_5784 n1_4513) (>= n1_4513 n2_4517)) (and (= max_5784 n2_4517) (< n1_4513 n2_4517))))))
(assert (= (+ b_4488 n2_4517) (+ 1 n1_4513)))
(assert (= resln_4458 n_4487))
(assert (or (and (= resln_4458 (+ n1_4513 1)) (<= n2_4517 n1_4513)) (and (= resln_4458 (+ n2_4517 1)) (< n1_4513 n2_4517))))
(assert (<= (+ 0 n2_4517) (+ n1_4513 1)))
(assert (<= n1_4513 (+ 1 n2_4517)))
(assert (= n2_4517 bn))
(assert (= n1_4513 an))
(assert (< n_4239 n_4220))
(assert (exists ((max_5783 Int)) (and (= n (+ max_5783 1)) (or (and (= max_5783 n1_4211) (>= n1_4211 n2_4215)) (and (= max_5783 n2_4215) (< n1_4211 n2_4215))))))
(assert (<= (+ 0 n2_4215) (+ n1_4211 1)))
(assert (<= n1_4211 (+ 1 n2_4215)))
(assert (= (+ b_4108 n2_4215) (+ 1 n1_4211)))
(assert (= n_4207 n))
(assert (= n_4239 n1_4211))
(assert (= bn n_4239))
(assert (= resln_4458 (+ 1 tmp1_4455)))
(assert (<= 0 an))
(assert (<= 0 bn))
(assert (or (and (= tmp1_4455 an) (>= an bn)) (and (= tmp1_4455 bn) (< an bn))))
(assert (<= 0 n_4128))
(assert (= an n_4128))
(assert (= Anon_57 n_3750))
(assert (= (+ 2 n_4128) n))
(assert (<= 0 n1_3754))
(assert (= n_4128 n1_3754))
(assert (<= b_4108 2))
(assert (<= 0 b_4108))
(assert (<= 0 n))
(assert (<= resb_4092 2))
(assert (<= 0 resb_4092))
(assert (<= 0 resn_4091))
(assert (= b_4108 resb_4092))
(assert (= n resn_4091))
(assert (<= 0 tn_4067))
(assert (or (= tn_4067 resn_4091) (and (= resn_4091 (+ 1 tn_4067)) (not (= resb_4092 1)))))
(assert (< 0 tn_4067))
(assert (<= 0 n2_3758))
(assert (= tn_4067 n2_3758))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_5782 Int)) (and (= tn (+ max_5782 1)) (or (and (= max_5782 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5782 n2_3758) (< n1_3754 n2_3758))))))
(assert (= n_3750 tn))
;Negation of Consequence
(assert (not (= tn 0)))
(check-sat)