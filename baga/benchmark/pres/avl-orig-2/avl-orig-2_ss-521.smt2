(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun b_4599 () Int)
(declare-fun Anon_4466 () Int)
(declare-fun n_4598 () Int)
(declare-fun m_4597 () Int)
(declare-fun v_node_118_2227_primed () Int)
(declare-fun ss3_4465 () Int)
(declare-fun v_int_118_2232_primed () Int)
(declare-fun Anon_4464 () Int)
(declare-fun t2_4472 () Int)
(declare-fun t1_4470 () Int)
(declare-fun h1_4469 () Int)
(declare-fun h2_4471 () Int)
(declare-fun h_4467 () Int)
(declare-fun t_4468 () Int)
(declare-fun flted_175_4460 () Int)
(declare-fun flted_174_4461 () Int)
(declare-fun Anon_40 () Int)
(declare-fun Anon_4323 () Int)
(declare-fun cn () Int)
(declare-fun cm () Int)
(declare-fun Anon_39 () Int)
(declare-fun Anon_4319 () Int)
(declare-fun bn () Int)
(declare-fun bm () Int)
(declare-fun c () Int)
(declare-fun q_4320 () Int)
(declare-fun b_4283 () Int)
(declare-fun p_4316 () Int)
(declare-fun Anon_38 () Int)
(declare-fun Anon_37 () Int)
(declare-fun Anon_4315 () Int)
(declare-fun m2_4321 () Int)
(declare-fun m1_4317 () Int)
(declare-fun n2_4322 () Int)
(declare-fun n1_4318 () Int)
(declare-fun n_4314 () Int)
(declare-fun v_bool_109_2209_primed () Int)
(declare-fun v_bool_108_2210_primed () Int)
(declare-fun v_bool_86_2211_primed () Int)
(declare-fun tm () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun v_bool_80_2243_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun t_4355 () Int)
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
(declare-fun m () Int)
(declare-fun b_4108 () Int)
(declare-fun m1_3753 () Int)
(declare-fun n1_3754 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun n () Int)
(declare-fun m2_4214 () Int)
(declare-fun n2_4215 () Int)
(declare-fun Anon_4216 () Int)
(declare-fun m1_4210 () Int)
(declare-fun n1_4211 () Int)
(declare-fun Anon_4212 () Int)
(declare-fun m_4238 () Int)
(declare-fun n_4239 () Int)
(declare-fun b_4240 () Int)
(declare-fun Anon_31 () Int)
(declare-fun Anon_3751 () Int)
(declare-fun Anon_32 () Int)
(declare-fun n_3750 () Int)
(declare-fun a () Int)
(declare-fun p_3752 () Int)
(declare-fun k2 () Int)
(declare-fun v_node_107_4102 () Int)
(declare-fun am () Int)
(declare-fun m_4127 () Int)
(declare-fun an () Int)
(declare-fun n_4128 () Int)
(declare-fun Anon_33 () Int)
(declare-fun b_4129 () Int)
(declare-fun Anon_34 () Int)
(declare-fun Anon_4208 () Int)
(declare-fun Anon_35 () Int)
(declare-fun n_4207 () Int)
(declare-fun k3 () Int)
(declare-fun p_4209 () Int)
(declare-fun d () Int)
(declare-fun q_4213 () Int)
(declare-fun dm () Int)
(declare-fun m_4219 () Int)
(declare-fun dn () Int)
(declare-fun n_4220 () Int)
(declare-fun Anon_36 () Int)
(declare-fun b_4221 () Int)
(declare-fun t_primed () Int)
(declare-fun n_4487 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun ss1_4463 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= b_4599 Anon_4466))
(assert (= n_4598 h2_4471))
(assert (= m_4597 flted_175_4460))
(assert (= v_node_118_2227_primed ss3_4465))
(assert (<= b_4488 2))
(assert (<= 0 b_4488))
(assert (<= 0 n_4487))
(assert (<= 0 m_4486))
(assert (= v_int_118_2232_primed n_4487))
(assert (<= Anon_4464 2))
(assert (<= 0 Anon_4464))
(assert (<= 0 h1_4469))
(assert (<= 0 flted_174_4461))
(assert (= b_4488 Anon_4464))
(assert (= n_4487 h1_4469))
(assert (= m_4486 flted_174_4461))
(assert (<= Anon_40 2))
(assert (<= 0 Anon_40))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (<= Anon_39 2))
(assert (<= 0 Anon_39))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (<= Anon_36 2))
(assert (<= 0 Anon_36))
(assert (<= 0 dn))
(assert (<= 0 dm))
(assert (<= Anon_33 2))
(assert (<= 0 Anon_33))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (or (and (= t2_4472 cn) (>= cn dn)) (and (= t2_4472 dn) (< cn dn))))
(assert (= h2_4471 (+ t2_4472 1)))
(assert (or (and (= t1_4470 an) (>= an bn)) (and (= t1_4470 bn) (< an bn))))
(assert (= h1_4469 (+ t1_4470 1)))
(assert (or (and (= t_4468 h1_4469) (>= h1_4469 h2_4471)) (and (= t_4468 h2_4471) (< h1_4469 h2_4471))))
(assert (= h_4467 (+ t_4468 1)))
(assert (= flted_175_4460 (+ (+ 1 cm) dm)))
(assert (= flted_174_4461 (+ (+ 1 am) bm)))
(assert (> t_4355 0))
(assert (<= b_4129 2))
(assert (<= 0 b_4129))
(assert (<= 0 n_4128))
(assert (<= 0 m_4127))
(assert (> v_node_107_4102 0))
(assert (<= b_4221 2))
(assert (<= 0 b_4221))
(assert (<= 0 n_4220))
(assert (<= 0 m_4219))
(assert (> p_4209 0))
(assert (<= Anon_4319 2))
(assert (<= 0 Anon_4319))
(assert (<= 0 n1_4318))
(assert (<= 0 m1_4317))
(assert (<= Anon_4323 2))
(assert (<= 0 Anon_4323))
(assert (<= 0 n2_4322))
(assert (<= 0 m2_4321))
(assert (= Anon_40 Anon_4323))
(assert (= cn n2_4322))
(assert (= cm m2_4321))
(assert (= Anon_39 Anon_4319))
(assert (= bn n1_4318))
(assert (= bm m1_4317))
(assert (= c q_4320))
(assert (= b_4283 p_4316))
(assert (= Anon_38 n_4314))
(assert (= Anon_37 Anon_4315))
(assert (= m_4238 (+ (+ m2_4321 1) m1_4317)))
(assert (exists ((max_79 Int)) (and (= n_4239 (+ max_79 1)) (or (and (= max_79 n1_4318) (>= n1_4318 n2_4322)) (and (= max_79 n2_4322) (< n1_4318 n2_4322))))))
(assert (<= (+ 0 n2_4322) (+ n1_4318 1)))
(assert (<= n1_4318 (+ 1 n2_4322)))
(assert (= (+ b_4240 n2_4322) (+ 1 n1_4318)))
(assert (= n_4314 n_4239))
(assert (not (> v_bool_109_2209_primed 0)))
(assert (<= n_4220 n_4239))
(assert (= m (+ (+ m2_4214 1) m1_4210)))
(assert (exists ((max_79 Int)) (and (= n (+ max_79 1)) (or (and (= max_79 n1_4211) (>= n1_4211 n2_4215)) (and (= max_79 n2_4215) (< n1_4211 n2_4215))))))
(assert (<= (+ 0 n2_4215) (+ n1_4211 1)))
(assert (<= n1_4211 (+ 1 n2_4215)))
(assert (= (+ b_4108 n2_4215) (+ 1 n1_4211)))
(assert (= n_4207 n))
(assert (> v_bool_108_2210_primed 0))
(assert (not (> v_bool_86_2211_primed 0)))
(assert (<= Anon_3751 x_primed))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (exists ((max_79 Int)) (and (= tn (+ max_79 1)) (or (and (= max_79 n1_3754) (>= n1_3754 n2_3758)) (and (= max_79 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= n_3750 tn))
(assert (not (> v_bool_80_2243_primed 0)))
(assert (< tmp_primed 1))
(assert (= x_primed x))
(assert (= t_4355 t))
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
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b_4108))
(assert (<= b_4108 2))
(assert (= m_4127 m1_3753))
(assert (= n_4128 n1_3754))
(assert (= b_4129 Anon_3755))
(assert (<= 0 m1_3753))
(assert (<= 0 n1_3754))
(assert (<= 0 Anon_3755))
(assert (<= Anon_3755 2))
(assert (= (+ 2 n_4128) n))
(assert (= m_4219 m2_4214))
(assert (= n_4220 n2_4215))
(assert (= b_4221 Anon_4216))
(assert (<= 0 m2_4214))
(assert (<= 0 n2_4215))
(assert (<= 0 Anon_4216))
(assert (<= Anon_4216 2))
(assert (= m_4238 m1_4210))
(assert (= n_4239 n1_4211))
(assert (= b_4240 Anon_4212))
(assert (<= 0 m1_4210))
(assert (<= 0 n1_4211))
(assert (<= 0 Anon_4212))
(assert (<= Anon_4212 2))
(assert (<= 0 m_4238))
(assert (<= 0 n_4239))
(assert (<= 0 b_4240))
(assert (<= b_4240 2))
(assert (= Anon_31 Anon_3751))
(assert (= Anon_32 n_3750))
(assert (= a p_3752))
(assert (= k2 v_node_107_4102))
(assert (= am m_4127))
(assert (= an n_4128))
(assert (= Anon_33 b_4129))
(assert (= Anon_34 Anon_4208))
(assert (= Anon_35 n_4207))
(assert (= k3 p_4209))
(assert (= d q_4213))
(assert (= dm m_4219))
(assert (= dn n_4220))
(assert (= Anon_36 b_4221))
(assert (= t_primed 1))
(assert (or (and (and (and (< ss1_4463 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> ss1_4463 0))))
;Negation of Consequence
(assert (not false))
(check-sat)