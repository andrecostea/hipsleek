(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v3_primed () Int)
(declare-fun v3 () Int)
(declare-fun v2_primed () Int)
(declare-fun v2 () Int)
(declare-fun v1_primed () Int)
(declare-fun v1 () Int)
(declare-fun d () Int)
(declare-fun c () Int)
(declare-fun b () Int)
(declare-fun a () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun h_primed () Int)
(declare-fun h_4009 () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun dm () Int)
(declare-fun an_3988 () Int)
(declare-fun res () Int)
(declare-fun v_int_91_3333_primed () Int)
(declare-fun v_int_91_3332_primed () Int)
(declare-fun n () Int)
(declare-fun m () Int)
(declare-fun a_primed () Int)
(declare-fun n_3993 () Int)
(declare-fun m_3992 () Int)
(declare-fun b_primed () Int)
(declare-fun tmp1_primed () Int)
(declare-fun n_4012 () Int)
(declare-fun m_4011 () Int)
(declare-fun c_primed () Int)
(declare-fun n_4019 () Int)
(declare-fun m_4018 () Int)
(declare-fun d_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= an_3988 an))
(assert (<= bn (+ 1 cn)))
(assert (<= (+ 0 cn) (+ bn 1)))
(assert (or (and (= an bn) (>= bn cn)) (and (= an cn) (< bn cn))))
(assert (= v3_primed v3))
(assert (= v2_primed v2))
(assert (= v1_primed v1))
(assert (= d_primed d))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= m am))
(assert (= n an))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (= m_3992 bm))
(assert (= n_3993 bn))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 m_3992))
(assert (<= 0 n_3993))
(assert (or (and (= h_4009 n) (>= n n_3993)) (and (= h_4009 n_3993) (< n n_3993))))
(assert (= h_primed (+ 1 h_4009)))
(assert (= m_4011 cm))
(assert (= n_4012 cn))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (= v_int_91_3333_primed n_4012))
(assert (<= 0 m_4011))
(assert (<= 0 n_4012))
(assert (= m_4018 dm))
(assert (= n_4019 an_3988))
(assert (<= 0 dm))
(assert (<= 0 an_3988))
(assert (= v_int_91_3332_primed n_4019))
(assert (<= 0 m_4018))
(assert (<= 0 n_4019))
(assert (or (and (= res v_int_91_3333_primed) (>= v_int_91_3333_primed v_int_91_3332_primed)) (and (= res v_int_91_3332_primed) (< v_int_91_3333_primed v_int_91_3332_primed))))
(assert (or (and (and (< a_primed 1) (= m 0)) (= n 0)) (and (and (<= 1 n) (<= 1 m)) (> a_primed 0))))
(assert (or (and (and (< b_primed 1) (= m_3992 0)) (= n_3993 0)) (and (and (<= 1 n_3993) (<= 1 m_3992)) (> b_primed 0))))
(assert (= tmp1_primed 1))
(assert (or (and (and (< c_primed 1) (= m_4011 0)) (= n_4012 0)) (and (and (<= 1 n_4012) (<= 1 m_4011)) (> c_primed 0))))
(assert (or (and (and (< d_primed 1) (= m_4018 0)) (= n_4019 0)) (and (and (<= 1 n_4019) (<= 1 m_4018)) (> d_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)