(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_35 () Int)
(declare-fun Anon_32 () Int)
(declare-fun n_3750 () Int)
(declare-fun Anon_38 () Int)
(declare-fun b_4108 () Int)
(declare-fun n_4207 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n2_3758 () Int)
(declare-fun tn_4067 () Int)
(declare-fun resb_4092 () Int)
(declare-fun resn_4091 () Int)
(declare-fun n1_3754 () Int)
(declare-fun n () Int)
(declare-fun n_4128 () Int)
(declare-fun Anon_4212 () Int)
(declare-fun n1_4211 () Int)
(declare-fun n2_4215 () Int)
(declare-fun m_4219 () Int)
(declare-fun flted_74_4090 () Int)
(declare-fun tm_4066 () Int)
(declare-fun n_4220 () Int)
(declare-fun n_4314 () Int)
(declare-fun b_4240 () Int)
(declare-fun n_4239 () Int)
(declare-fun n1_4318 () Int)
(declare-fun n2_4322 () Int)
(declare-fun height_118_4740 () Int)
(declare-fun Anon_4466 () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun flted_175_4460 () Int)
(declare-fun dm () Int)
(declare-fun cm () Int)
(declare-fun m () Int)
(declare-fun m2_4214 () Int)
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun m1_3753 () Int)
(declare-fun q_5796 () Int)
(declare-fun b_4599 () Int)
(declare-fun m_4597 () Int)
(declare-fun ss3_4465 () Int)
(declare-fun m_4127 () Int)
(declare-fun m1_4210 () Int)
(declare-fun m_4238 () Int)
(declare-fun m2_4321 () Int)
(declare-fun m1_4317 () Int)
(declare-fun am () Int)
(declare-fun bm () Int)
(declare-fun h_4467 () Int)
(declare-fun t_4468 () Int)
(declare-fun t1_4470 () Int)
(declare-fun t2_4472 () Int)
(declare-fun Anon_4464 () Int)
(declare-fun h2_4471 () Int)
(declare-fun v_int_118_5787 () Int)
(declare-fun n_4598 () Int)
(declare-fun h1_4469 () Int)
(declare-fun flted_174_4461 () Int)
(declare-fun p_5792 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun n_4487 () Int)
(declare-fun ss1_4463 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_35 n_4207))
(assert (= Anon_32 n_3750))
(assert (<= 0 n1_3754))
(assert (<= b_4108 2))
(assert (<= 0 b_4108))
(assert (<= resb_4092 2))
(assert (<= 0 resb_4092))
(assert (<= 0 resn_4091))
(assert (= b_4108 resb_4092))
(assert (<= 0 tn_4067))
(assert (<= 0 n2_3758))
(assert (= n_3750 tn))
(assert (<= 0 n_4128))
(assert (<= 0 n_4220))
(assert (<= 0 m_4219))
(assert (<= 0 n1_4318))
(assert (<= 0 n2_4322))
(assert (= Anon_38 n_4314))
(assert (exists ((max_5817 Int)) (and (= n (+ max_5817 1)) (or (and (= max_5817 n1_4211) (>= n1_4211 n2_4215)) (and (= max_5817 n2_4215) (< n1_4211 n2_4215))))))
(assert (<= (+ 0 n2_4215) (+ n1_4211 1)))
(assert (<= n1_4211 (+ 1 n2_4215)))
(assert (= (+ b_4108 n2_4215) (+ 1 n1_4211)))
(assert (= n_4207 n))
(assert (exists ((max_5816 Int)) (and (= tn (+ max_5816 1)) (or (and (= max_5816 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5816 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= tn_4067 n2_3758))
(assert (< 0 tn_4067))
(assert (or (= tn_4067 resn_4091) (and (= resn_4091 (+ 1 tn_4067)) (not (= resb_4092 1)))))
(assert (= n resn_4091))
(assert (<= 0 n))
(assert (= n_4128 n1_3754))
(assert (= (+ 2 n_4128) n))
(assert (= dn n_4220))
(assert (= dm m_4219))
(assert (= an n_4128))
(assert (<= b_4240 2))
(assert (<= 0 b_4240))
(assert (<= 0 n_4239))
(assert (<= Anon_4212 2))
(assert (<= 0 Anon_4212))
(assert (<= 0 n1_4211))
(assert (= b_4240 Anon_4212))
(assert (= n_4239 n1_4211))
(assert (<= 0 n2_4215))
(assert (<= 0 m2_4214))
(assert (= n_4220 n2_4215))
(assert (= m_4219 m2_4214))
(assert (<= 0 m1_3753))
(assert (<= 0 m))
(assert (<= 0 flted_74_4090))
(assert (= m flted_74_4090))
(assert (<= 0 tm_4066))
(assert (< 0 tm_4066))
(assert (= flted_74_4090 (+ 1 tm_4066)))
(assert (<= 0 m2_3757))
(assert (= tm_4066 m2_3757))
(assert (<= n_4220 n_4239))
(assert (= n_4314 n_4239))
(assert (= (+ b_4240 n2_4322) (+ 1 n1_4318)))
(assert (<= n1_4318 (+ 1 n2_4322)))
(assert (<= (+ 0 n2_4322) (+ n1_4318 1)))
(assert (exists ((max_5818 Int)) (and (= n_4239 (+ max_5818 1)) (or (and (= max_5818 n1_4318) (>= n1_4318 n2_4322)) (and (= max_5818 n2_4322) (< n1_4318 n2_4322))))))
(assert (= bn n1_4318))
(assert (= cn n2_4322))
(assert (= height_118_4740 h_4467))
(assert (<= b_4599 2))
(assert (<= 0 b_4599))
(assert (<= 0 m_4597))
(assert (<= Anon_4466 2))
(assert (<= 0 Anon_4466))
(assert (<= 0 h2_4471))
(assert (<= 0 flted_175_4460))
(assert (= b_4599 Anon_4466))
(assert (= m_4597 flted_175_4460))
(assert (<= Anon_4464 2))
(assert (<= 0 Anon_4464))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (<= 0 dn))
(assert (<= 0 dm))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (or (and (= t2_4472 cn) (>= cn dn)) (and (= t2_4472 dn) (< cn dn))))
(assert (or (and (= t1_4470 an) (>= an bn)) (and (= t1_4470 bn) (< an bn))))
(assert (= flted_175_4460 (+ (+ 1 cm) dm)))
(assert (<= 0 m_4127))
(assert (<= 0 m1_4317))
(assert (<= 0 m2_4321))
(assert (= cm m2_4321))
(assert (= m (+ (+ m2_4214 1) m1_4210)))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (= m_4127 m1_3753))
(assert (= q_5796 ss3_4465))
(assert (or (and (and (and (< ss3_4465 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> ss3_4465 0))))
(assert (= am m_4127))
(assert (<= 0 m_4238))
(assert (<= 0 m1_4210))
(assert (= m_4238 m1_4210))
(assert (= m_4238 (+ (+ m2_4321 1) m1_4317)))
(assert (= bm m1_4317))
(assert (= flted_174_4461 (+ (+ 1 am) bm)))
(assert (= h_4467 (+ t_4468 1)))
(assert (or (and (= t_4468 h1_4469) (>= h1_4469 h2_4471)) (and (= t_4468 h2_4471) (< h1_4469 h2_4471))))
(assert (= h1_4469 (+ t1_4470 1)))
(assert (= h2_4471 (+ t2_4472 1)))
(assert (= b_4488 Anon_4464))
(assert (<= 0 flted_174_4461))
(assert (<= 0 h1_4469))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (= n_4598 h2_4471))
(assert (<= 0 n_4598))
(assert (= v_int_118_5787 (+ 1 n_4487)))
(assert (<= n_4598 n_4487))
(assert (<= 0 n_4487))
(assert (<= 0 m_4486))
(assert (= n_4487 h1_4469))
(assert (= m_4486 flted_174_4461))
(assert (= p_5792 ss1_4463))
(assert (or (and (and (and (< ss1_4463 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> ss1_4463 0))))
;Negation of Consequence
(assert (not (or (= m_4486 0) (or (= n_4487 0) (< ss1_4463 1)))))
(check-sat)