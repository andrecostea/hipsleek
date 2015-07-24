(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bg_2093 () Int)
(declare-fun sm_2092 () Int)
(declare-fun n_2091 () Int)
(declare-fun xsnext_primed () Int)
(declare-fun xsval_primed () Int)
(declare-fun v_bool_81_1352_primed () Int)
(declare-fun tmp_2090 () Int)
(declare-fun a_1971 () Int)
(declare-fun sm_1952 () Int)
(declare-fun n_1951 () Int)
(declare-fun xs () Int)
(declare-fun xs_primed () Int)
(declare-fun v_bool_74_1366_primed () Int)
(declare-fun bg_1943 () Int)
(declare-fun sm_1942 () Int)
(declare-fun bg () Int)
(declare-fun sm () Int)
(declare-fun d_1945 () Int)
(declare-fun flted_9_1944 () Int)
(declare-fun n () Int)
(declare-fun xsnext_1973 () Int)
(declare-fun v_primed () Int)
(declare-fun bg_1953 () Int)
(declare-fun b_1972 () Int)
(declare-fun sm_2065 () Int)
(declare-fun bg_2066 () Int)
(declare-fun b_primed () Int)
(declare-fun smres_2088 () Int)
(declare-fun bgres_2089 () Int)
(declare-fun n_2064 () Int)
(declare-fun tmp_2077 () Int)
(declare-fun tmp_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bg_2093 v_primed))
(assert (= sm_2092 sm_1952))
(assert (= n_2091 a_1971))
(assert (= xsnext_primed xsnext_1973))
(assert (= xsval_primed d_1945))
(assert (> v_bool_81_1352_primed 0))
(assert (> tmp_2090 0))
(assert (<= 0 n_1951))
(assert (= n_1951 (+ b_1972 a_1971)))
(assert (<= 0 flted_9_1944))
(assert (= bg_1953 bg_1943))
(assert (= sm_1952 sm_1942))
(assert (= n_1951 flted_9_1944))
(assert (= v_primed d_1945))
(assert (= xs_primed xs))
(assert (< 0 n))
(assert (> xs_primed 0))
(assert (> v_bool_74_1366_primed 0))
(assert (= bg_1943 bg))
(assert (= sm_1942 sm))
(assert (< d_1945 bg))
(assert (<= sm d_1945))
(assert (= (+ flted_9_1944 1) n))
(assert (> xsnext_1973 0))
(assert (= n_2064 b_1972))
(assert (= sm_2065 v_primed))
(assert (= bg_2066 bg_1953))
(assert (<= 0 b_1972))
(assert (<= sm_2065 smres_2088))
(assert (< bgres_2089 bg_2066))
(assert (<= 0 n_2064))
(assert (not (> b_primed 0)))
(assert (or (and (and (= bgres_2089 smres_2088) (= n_2064 1)) (> tmp_2077 0)) (and (and (<= smres_2088 bgres_2089) (<= 2 n_2064)) (> tmp_2077 0))))
(assert (= tmp_primed 1))
(assert (not (= tmp_2077 tmp_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)