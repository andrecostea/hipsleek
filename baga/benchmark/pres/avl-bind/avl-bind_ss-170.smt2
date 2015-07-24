(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_120_2035_primed () Int)
(declare-fun h_primed () Int)
(declare-fun h_3045 () Int)
(declare-fun dm () Int)
(declare-fun cm () Int)
(declare-fun h_3019 () Int)
(declare-fun bm () Int)
(declare-fun am () Int)
(declare-fun a () Int)
(declare-fun b () Int)
(declare-fun c () Int)
(declare-fun d () Int)
(declare-fun v1 () Int)
(declare-fun v2_primed () Int)
(declare-fun v2 () Int)
(declare-fun v3 () Int)
(declare-fun cn () Int)
(declare-fun bn () Int)
(declare-fun an_2998 () Int)
(declare-fun an () Int)
(declare-fun Anon_3051 () Int)
(declare-fun v3_primed () Int)
(declare-fun p_3052 () Int)
(declare-fun a_primed () Int)
(declare-fun q_3055 () Int)
(declare-fun b_primed () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun m_3002 () Int)
(declare-fun n_3003 () Int)
(declare-fun h_3039 () Int)
(declare-fun n1_3054 () Int)
(declare-fun n2_3057 () Int)
(declare-fun m2_3056 () Int)
(declare-fun m1_3053 () Int)
(declare-fun Anon_3074 () Int)
(declare-fun v1_primed () Int)
(declare-fun p_3075 () Int)
(declare-fun c_primed () Int)
(declare-fun q_3078 () Int)
(declare-fun d_primed () Int)
(declare-fun m_3021 () Int)
(declare-fun n_3022 () Int)
(declare-fun m_3028 () Int)
(declare-fun n_3029 () Int)
(declare-fun h_3108 () Int)
(declare-fun n1_3077 () Int)
(declare-fun n2_3080 () Int)
(declare-fun m2_3079 () Int)
(declare-fun m1_3076 () Int)
(declare-fun n_3048 () Int)
(declare-fun m_3047 () Int)
(declare-fun tmp1_primed () Int)
(declare-fun n_3071 () Int)
(declare-fun m_3070 () Int)
(declare-fun tmp2_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_int_120_2035_primed 1))
(assert (or (and (= h_primed n_3048) (>= n_3048 n_3071)) (and (= h_primed n_3071) (< n_3048 n_3071))))
(assert (<= 0 n_3071))
(assert (<= 0 m_3070))
(assert (> tmp2_primed 0))
(assert (<= 0 n_3022))
(assert (<= 0 m_3021))
(assert (<= 0 n_3029))
(assert (<= 0 m_3028))
(assert (<= 0 n_3048))
(assert (<= 0 m_3047))
(assert (> tmp1_primed 0))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (<= 0 n_3003))
(assert (<= 0 m_3002))
(assert (= h_3108 (+ 1 h_3045)))
(assert (or (and (= h_3045 n_3022) (>= n_3022 n_3029)) (and (= h_3045 n_3029) (< n_3022 n_3029))))
(assert (<= 0 an_2998))
(assert (<= 0 dm))
(assert (= n_3029 an_2998))
(assert (= m_3028 dm))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (= n_3022 cn))
(assert (= m_3021 cm))
(assert (= h_3039 (+ 1 h_3019)))
(assert (or (and (= h_3019 n) (>= n n_3003)) (and (= h_3019 n_3003) (< n n_3003))))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= n_3003 bn))
(assert (= m_3002 bm))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (= n an))
(assert (= m am))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= d_primed d))
(assert (= v1_primed v1))
(assert (= v2_primed v2))
(assert (= v3_primed v3))
(assert (or (and (= an bn) (>= bn cn)) (and (= an cn) (< bn cn))))
(assert (<= (+ 0 bn) (+ cn 1)))
(assert (<= cn (+ 1 bn)))
(assert (= an_2998 an))
(assert (= Anon_3051 v3_primed))
(assert (= p_3052 a_primed))
(assert (= q_3055 b_primed))
(assert (= m1_3053 m))
(assert (= n1_3054 n))
(assert (= m2_3056 m_3002))
(assert (= n2_3057 n_3003))
(assert (<= n1_3054 (+ 1 n2_3057)))
(assert (<= (+ 0 n2_3057) (+ n1_3054 1)))
(assert (or (and (= h_3039 (+ n1_3054 1)) (<= n2_3057 n1_3054)) (and (= h_3039 (+ n2_3057 1)) (< n1_3054 n2_3057))))
(assert (= h_3039 n_3048))
(assert (exists ((max_32 Int)) (and (= n_3048 (+ 1 max_32)) (or (and (= max_32 n1_3054) (>= n1_3054 n2_3057)) (and (= max_32 n2_3057) (< n1_3054 n2_3057))))))
(assert (= m_3047 (+ (+ m2_3056 1) m1_3053)))
(assert (= Anon_3074 v1_primed))
(assert (= p_3075 c_primed))
(assert (= q_3078 d_primed))
(assert (= m1_3076 m_3021))
(assert (= n1_3077 n_3022))
(assert (= m2_3079 m_3028))
(assert (= n2_3080 n_3029))
(assert (<= n1_3077 (+ 1 n2_3080)))
(assert (<= (+ 0 n2_3080) (+ n1_3077 1)))
(assert (or (and (= h_3108 (+ n1_3077 1)) (<= n2_3080 n1_3077)) (and (= h_3108 (+ n2_3080 1)) (< n1_3077 n2_3080))))
(assert (= h_3108 n_3071))
(assert (exists ((max_32 Int)) (and (= n_3071 (+ 1 max_32)) (or (and (= max_32 n1_3077) (>= n1_3077 n2_3080)) (and (= max_32 n2_3080) (< n1_3077 n2_3080))))))
(assert (= m_3070 (+ (+ m2_3079 1) m1_3076)))
(assert (or (and (and (< tmp1_primed 1) (= m_3047 0)) (= n_3048 0)) (and (and (<= 1 n_3048) (<= 1 m_3047)) (> tmp1_primed 0))))
(assert (or (and (and (< tmp2_primed 1) (= m_3070 0)) (= n_3071 0)) (and (and (<= 1 n_3071) (<= 1 m_3070)) (> tmp2_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)