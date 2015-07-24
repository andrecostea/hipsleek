(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_95_1428_primed () Int)
(declare-fun v_bool_88_1429_primed () Int)
(declare-fun v_bool_83_1430_primed () Int)
(declare-fun nmin () Int)
(declare-fun n () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun t () Int)
(declare-fun nmin1_2126 () Int)
(declare-fun flted_26_2123 () Int)
(declare-fun nmin_2133 () Int)
(declare-fun n_2132 () Int)
(declare-fun nmin2_2128 () Int)
(declare-fun flted_26_2122 () Int)
(declare-fun nmin_2217 () Int)
(declare-fun n_2216 () Int)
(declare-fun aux_2278 () Int)
(declare-fun r_2127 () Int)
(declare-fun nmin_2235 () Int)
(declare-fun n_2234 () Int)
(declare-fun nmin_2260 () Int)
(declare-fun n_2259 () Int)
(declare-fun t_primed () Int)
(declare-fun nmin_2151 () Int)
(declare-fun n_2150 () Int)
(declare-fun l_2125 () Int)
(declare-fun nmin1_2280 () Int)
(declare-fun n_2279 () Int)
(declare-fun aux_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_95_1428_primed 0))
(assert (< nmin_2217 n_2234))
(assert (not (> v_bool_88_1429_primed 0)))
(assert (<= n_2150 nmin_2133))
(assert (= (+ flted_26_2123 1) n))
(assert (= (+ flted_26_2122 1) n))
(assert (exists ((min_32 Int)) (and (= nmin (+ 1 min_32)) (or (and (= min_32 nmin1_2126) (< nmin1_2126 nmin2_2128)) (and (= min_32 nmin2_2128) (>= nmin1_2126 nmin2_2128))))))
(assert (not (> v_bool_83_1430_primed 0)))
(assert (> t_primed 0))
(assert (< nmin n))
(assert (= v_primed v))
(assert (= t_primed t))
(assert (= n_2132 flted_26_2123))
(assert (= nmin_2133 nmin1_2126))
(assert (<= 0 nmin1_2126))
(assert (<= nmin1_2126 flted_26_2123))
(assert (= n_2150 n_2132))
(assert (= nmin_2151 nmin_2133))
(assert (<= 0 nmin_2133))
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2151))
(assert (<= nmin_2151 n_2150))
(assert (= n_2216 flted_26_2122))
(assert (= nmin_2217 nmin2_2128))
(assert (<= 0 nmin2_2128))
(assert (<= nmin2_2128 flted_26_2122))
(assert (= n_2234 n_2216))
(assert (= nmin_2235 nmin_2217))
(assert (<= 0 nmin_2217))
(assert (<= nmin_2217 n_2216))
(assert (= aux_2278 r_2127))
(assert (= n_2259 n_2234))
(assert (= nmin_2260 nmin_2235))
(assert (<= 0 nmin_2235))
(assert (<= nmin_2235 n_2234))
(assert (or (= nmin1_2280 nmin_2260) (= nmin1_2280 (+ 1 nmin_2260))))
(assert (= n_2279 n_2259))
(assert (<= 0 nmin_2260))
(assert (<= nmin_2260 n_2259))
(assert (= t_primed 1))
(assert (or (and (and (<= 1 nmin_2151) (<= nmin_2151 n_2150)) (> l_2125 0)) (or (and (and (< l_2125 1) (= n_2150 0)) (= nmin_2151 0)) (and (and (<= 1 nmin_2151) (< nmin_2151 n_2150)) (> l_2125 0)))))
(assert (or (and (and (<= 1 nmin1_2280) (<= nmin1_2280 n_2279)) (> aux_primed 0)) (or (and (and (< aux_primed 1) (= n_2279 0)) (= nmin1_2280 0)) (and (and (<= 1 nmin1_2280) (< nmin1_2280 n_2279)) (> aux_primed 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)