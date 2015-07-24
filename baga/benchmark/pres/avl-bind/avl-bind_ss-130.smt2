(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v3_primed () Int)
(declare-fun v3 () Int)
(declare-fun v2_primed () Int)
(declare-fun v2 () Int)
(declare-fun v1_primed () Int)
(declare-fun v1 () Int)
(declare-fun d_primed () Int)
(declare-fun c () Int)
(declare-fun b () Int)
(declare-fun a () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun h_primed () Int)
(declare-fun h_3019 () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun res () Int)
(declare-fun m_3021 () Int)
(declare-fun n_3022 () Int)
(declare-fun an_2998 () Int)
(declare-fun dm () Int)
(declare-fun d () Int)
(declare-fun n () Int)
(declare-fun m () Int)
(declare-fun a_primed () Int)
(declare-fun n_3003 () Int)
(declare-fun m_3002 () Int)
(declare-fun b_primed () Int)
(declare-fun tmp1_primed () Int)
(declare-fun n_3026 () Int)
(declare-fun m_3025 () Int)
(declare-fun c_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= an_2998 an))
(assert (<= cn (+ 1 bn)))
(assert (<= (+ 0 bn) (+ cn 1)))
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
(assert (= m_3002 bm))
(assert (= n_3003 bn))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 m_3002))
(assert (<= 0 n_3003))
(assert (or (and (= h_3019 n) (>= n n_3003)) (and (= h_3019 n_3003) (< n n_3003))))
(assert (= h_primed (+ 1 h_3019)))
(assert (= m_3021 cm))
(assert (= n_3022 cn))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (= res n_3022))
(assert (= m_3025 m_3021))
(assert (= n_3026 n_3022))
(assert (<= 0 m_3021))
(assert (<= 0 n_3022))
(assert (or (and (and (< d 1) (= dm 0)) (= an_2998 0)) (and (and (<= 1 an_2998) (<= 1 dm)) (> d 0))))
(assert (or (and (and (< a_primed 1) (= m 0)) (= n 0)) (and (and (<= 1 n) (<= 1 m)) (> a_primed 0))))
(assert (or (and (and (< b_primed 1) (= m_3002 0)) (= n_3003 0)) (and (and (<= 1 n_3003) (<= 1 m_3002)) (> b_primed 0))))
(assert (= tmp1_primed 1))
(assert (or (and (and (< c_primed 1) (= m_3025 0)) (= n_3026 0)) (and (and (<= 1 n_3026) (<= 1 m_3025)) (> c_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)