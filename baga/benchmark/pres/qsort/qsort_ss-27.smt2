(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun d_2048 () Int)
(declare-fun tmp_primed () Int)
(declare-fun b_primed () Int)
(declare-fun sm () Int)
(declare-fun bg () Int)
(declare-fun v_bool_74_1366_primed () Int)
(declare-fun n () Int)
(declare-fun xs () Int)
(declare-fun v_primed () Int)
(declare-fun d_1945 () Int)
(declare-fun sm_1952 () Int)
(declare-fun sm_1942 () Int)
(declare-fun bg_1953 () Int)
(declare-fun bg_1943 () Int)
(declare-fun flted_9_1944 () Int)
(declare-fun b_1972 () Int)
(declare-fun a_1971 () Int)
(declare-fun n_1951 () Int)
(declare-fun sm_2045 () Int)
(declare-fun bg_2046 () Int)
(declare-fun flted_9_2047 () Int)
(declare-fun p_2049 () Int)
(declare-fun xsnext_1973 () Int)
(declare-fun xs_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_9_2047 1) a_1971))
(assert (<= sm_1952 d_2048))
(assert (< d_2048 v_primed))
(assert (= sm_2045 sm_1952))
(assert (= bg_2046 v_primed))
(assert (= b_1972 0))
(assert (< tmp_primed 1))
(assert (< xsnext_1973 1))
(assert (> b_primed 0))
(assert (= (+ flted_9_1944 1) n))
(assert (<= sm d_1945))
(assert (< d_1945 bg))
(assert (= sm_1942 sm))
(assert (= bg_1943 bg))
(assert (> v_bool_74_1366_primed 0))
(assert (> xs_primed 0))
(assert (< 0 n))
(assert (= xs_primed xs))
(assert (= v_primed d_1945))
(assert (= n_1951 flted_9_1944))
(assert (= sm_1952 sm_1942))
(assert (= bg_1953 bg_1943))
(assert (<= 0 flted_9_1944))
(assert (= n_1951 (+ b_1972 a_1971)))
(assert (<= 0 n_1951))
(assert (= xsnext_1973 1))
(assert (or (and (< p_2049 1) (= flted_9_2047 0)) (and (and (< sm_2045 bg_2046) (<= 1 flted_9_2047)) (> p_2049 0))))
(assert (= xs_primed 2))
(assert (not (= xsnext_1973 xs_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)