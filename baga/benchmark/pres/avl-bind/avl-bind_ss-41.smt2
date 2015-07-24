(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v3_primed () Int)
(declare-fun v3 () Int)
(declare-fun v2_primed () Int)
(declare-fun v2 () Int)
(declare-fun v1_primed () Int)
(declare-fun v1 () Int)
(declare-fun d_primed () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun a () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun res () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun bn () Int)
(declare-fun bm () Int)
(declare-fun b () Int)
(declare-fun cn () Int)
(declare-fun cm () Int)
(declare-fun c () Int)
(declare-fun an_2810 () Int)
(declare-fun dm () Int)
(declare-fun d () Int)
(declare-fun n_2812 () Int)
(declare-fun m_2811 () Int)
(declare-fun a_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= an_2810 an))
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
(assert (= res n))
(assert (= m_2811 m))
(assert (= n_2812 n))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (or (and (and (< b 1) (= bm 0)) (= bn 0)) (and (and (<= 1 bn) (<= 1 bm)) (> b 0))))
(assert (or (and (and (< c 1) (= cm 0)) (= cn 0)) (and (and (<= 1 cn) (<= 1 cm)) (> c 0))))
(assert (or (and (and (< d 1) (= dm 0)) (= an_2810 0)) (and (and (<= 1 an_2810) (<= 1 dm)) (> d 0))))
(assert (or (and (and (< a_primed 1) (= m_2811 0)) (= n_2812 0)) (and (and (<= 1 n_2812) (<= 1 m_2811)) (> a_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)