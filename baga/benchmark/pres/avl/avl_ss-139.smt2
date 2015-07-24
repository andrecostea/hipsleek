(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_117_3158_primed () Int)
(declare-fun h_primed () Int)
(declare-fun dm () Int)
(declare-fun cm () Int)
(declare-fun h_4217 () Int)
(declare-fun h_4197 () Int)
(declare-fun bm () Int)
(declare-fun am () Int)
(declare-fun a () Int)
(declare-fun b () Int)
(declare-fun c () Int)
(declare-fun d () Int)
(declare-fun v1_primed () Int)
(declare-fun v1 () Int)
(declare-fun v2_primed () Int)
(declare-fun v2 () Int)
(declare-fun v3_primed () Int)
(declare-fun v3 () Int)
(declare-fun cn () Int)
(declare-fun bn () Int)
(declare-fun an_4176 () Int)
(declare-fun an () Int)
(declare-fun n () Int)
(declare-fun m () Int)
(declare-fun a_primed () Int)
(declare-fun n_4181 () Int)
(declare-fun m_4180 () Int)
(declare-fun b_primed () Int)
(declare-fun tmp1_primed () Int)
(declare-fun n_4200 () Int)
(declare-fun m_4199 () Int)
(declare-fun c_primed () Int)
(declare-fun n_4207 () Int)
(declare-fun m_4206 () Int)
(declare-fun d_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_int_117_3158_primed 1))
(assert (or (and (= h_primed n_4200) (>= n_4200 n_4207)) (and (= h_primed n_4207) (< n_4200 n_4207))))
(assert (<= 0 n_4207))
(assert (<= 0 m_4206))
(assert (<= 0 an_4176))
(assert (<= 0 dm))
(assert (= n_4207 an_4176))
(assert (= m_4206 dm))
(assert (<= 0 n_4200))
(assert (<= 0 m_4199))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (= n_4200 cn))
(assert (= m_4199 cm))
(assert (= h_4217 (+ 1 h_4197)))
(assert (or (and (= h_4197 n) (>= n n_4181)) (and (= h_4197 n_4181) (< n n_4181))))
(assert (<= 0 n_4181))
(assert (<= 0 m_4180))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= n_4181 bn))
(assert (= m_4180 bm))
(assert (<= 0 n))
(assert (<= 0 m))
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
(assert (= an_4176 an))
(assert (or (and (and (< a_primed 1) (= m 0)) (= n 0)) (and (and (<= 1 n) (<= 1 m)) (> a_primed 0))))
(assert (or (and (and (< b_primed 1) (= m_4180 0)) (= n_4181 0)) (and (and (<= 1 n_4181) (<= 1 m_4180)) (> b_primed 0))))
(assert (= tmp1_primed 1))
(assert (or (and (and (< c_primed 1) (= m_4199 0)) (= n_4200 0)) (and (and (<= 1 n_4200) (<= 1 m_4199)) (> c_primed 0))))
(assert (or (and (and (< d_primed 1) (= m_4206 0)) (= n_4207 0)) (and (and (<= 1 n_4207) (<= 1 m_4206)) (> d_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)