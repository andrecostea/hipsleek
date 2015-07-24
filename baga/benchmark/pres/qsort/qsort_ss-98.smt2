(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n () Int)
(declare-fun flted_9_1944 () Int)
(declare-fun v_node_94_1365_primed () Int)
(declare-fun xsnext_2118 () Int)
(declare-fun bgres_2117 () Int)
(declare-fun smres_2116 () Int)
(declare-fun sm_2092 () Int)
(declare-fun n_2091 () Int)
(declare-fun n_1951 () Int)
(declare-fun a_1971 () Int)
(declare-fun bg_1953 () Int)
(declare-fun sm_1952 () Int)
(declare-fun bg_1943 () Int)
(declare-fun sm_1942 () Int)
(declare-fun bg () Int)
(declare-fun sm () Int)
(declare-fun b_1972 () Int)
(declare-fun tmp_2079 () Int)
(declare-fun d_1945 () Int)
(declare-fun bg_2093 () Int)
(declare-fun m () Int)
(declare-fun v_primed () Int)
(declare-fun s2 () Int)
(declare-fun b2 () Int)
(declare-fun qs_2170 () Int)
(declare-fun lg_2181 () Int)
(declare-fun flted_14_2182 () Int)
(declare-fun q_2169 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 flted_9_1944))
(assert (< 0 n))
(assert (= (+ flted_9_1944 1) n))
(assert (= n_1951 flted_9_1944))
(assert (= v_node_94_1365_primed xsnext_2118))
(assert (or (and (and (= bgres_2117 smres_2116) (= n_2091 1)) (> xsnext_2118 0)) (and (and (<= smres_2116 bgres_2117) (<= 2 n_2091)) (> xsnext_2118 0))))
(assert (= b_1972 0))
(assert (<= 0 n_2091))
(assert (< bgres_2117 bg_2093))
(assert (<= sm_2092 smres_2116))
(assert (<= 0 a_1971))
(assert (= sm_2092 sm_1952))
(assert (= n_2091 a_1971))
(assert (< tmp_2079 1))
(assert (<= 0 n_1951))
(assert (= n_1951 (+ b_1972 a_1971)))
(assert (= bg_1953 bg_1943))
(assert (= sm_1952 sm_1942))
(assert (= bg_1943 bg))
(assert (= sm_1942 sm))
(assert (< d_1945 bg))
(assert (<= sm d_1945))
(assert (or (= b_1972 0) (< tmp_2079 1)))
(assert (= q_2169 tmp_2079))
(assert (= v_primed d_1945))
(assert (= bg_2093 v_primed))
(assert (= (+ flted_14_2182 1) m))
(assert (<= s2 qs_2170))
(assert (= v_primed s2))
(assert (= lg_2181 b2))
(assert (or (and (and (= lg_2181 qs_2170) (= flted_14_2182 1)) (> q_2169 0)) (and (and (<= qs_2170 lg_2181) (<= 2 flted_14_2182)) (> q_2169 0))))
;Negation of Consequence
(assert (not false))
(check-sat)