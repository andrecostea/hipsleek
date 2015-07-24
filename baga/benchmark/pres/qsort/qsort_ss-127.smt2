(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun b_primed () Int)
(declare-fun xsnext_1973 () Int)
(declare-fun sm () Int)
(declare-fun bg () Int)
(declare-fun v_bool_74_1366_primed () Int)
(declare-fun n () Int)
(declare-fun xs () Int)
(declare-fun d_1945 () Int)
(declare-fun sm_1942 () Int)
(declare-fun bg_1943 () Int)
(declare-fun flted_9_1944 () Int)
(declare-fun n_1951 () Int)
(declare-fun v_bool_81_1352_primed () Int)
(declare-fun sm_1952 () Int)
(declare-fun a_1971 () Int)
(declare-fun sm_2092 () Int)
(declare-fun bg_2093 () Int)
(declare-fun n_2091 () Int)
(declare-fun smres_2116 () Int)
(declare-fun bgres_2117 () Int)
(declare-fun nn () Int)
(declare-fun b0 () Int)
(declare-fun xsnext_2118 () Int)
(declare-fun m () Int)
(declare-fun s2 () Int)
(declare-fun tmp_primed () Int)
(declare-fun qmin_2184 () Int)
(declare-fun bg_1953 () Int)
(declare-fun b_1972 () Int)
(declare-fun tmp_2079 () Int)
(declare-fun s0 () Int)
(declare-fun b2 () Int)
(declare-fun flted_51_2203 () Int)
(declare-fun xs_2205 () Int)
(declare-fun xs_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= qmin_2184 s2))
(assert (= qmin_2184 b2))
(assert (= m 1))
(assert (not (> b_primed 0)))
(assert (> xsnext_1973 0))
(assert (= (+ flted_9_1944 1) n))
(assert (<= sm d_1945))
(assert (< d_1945 bg))
(assert (= sm_1942 sm))
(assert (= bg_1943 bg))
(assert (> v_bool_74_1366_primed 0))
(assert (> xs_2205 0))
(assert (< 0 n))
(assert (= xs_2205 xs))
(assert (= qmin_2184 d_1945))
(assert (= n_1951 flted_9_1944))
(assert (= sm_1952 sm_1942))
(assert (= bg_1953 bg_1943))
(assert (<= 0 flted_9_1944))
(assert (= n_1951 (+ b_1972 a_1971)))
(assert (<= 0 n_1951))
(assert (< tmp_2079 1))
(assert (not (> v_bool_81_1352_primed 0)))
(assert (= n_2091 a_1971))
(assert (= sm_2092 sm_1952))
(assert (= bg_2093 qmin_2184))
(assert (<= 0 a_1971))
(assert (<= sm_2092 smres_2116))
(assert (< bgres_2117 bg_2093))
(assert (<= 0 n_2091))
(assert (= nn n_2091))
(assert (= s0 smres_2116))
(assert (= b0 bgres_2117))
(assert (<= 1 n_2091))
(assert (<= smres_2116 bgres_2117))
(assert (= flted_51_2203 (+ m nn)))
(assert (<= 1 nn))
(assert (<= s0 b0))
(assert (> xsnext_2118 0))
(assert (<= 1 m))
(assert (<= s2 b2))
(assert (> tmp_primed 0))
(assert (or (and (< tmp_2079 1) (= b_1972 0)) (and (and (< qmin_2184 bg_1953) (<= 1 b_1972)) (> tmp_2079 0))))
(assert (= xs_2205 1))
(assert (or (and (and (= b2 s0) (= flted_51_2203 1)) (> xs_primed 0)) (and (and (<= s0 b2) (<= 2 flted_51_2203)) (> xs_primed 0))))
(assert (not (= xs_2205 xs_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)