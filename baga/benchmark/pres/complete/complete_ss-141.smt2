(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_2132 () Int)
(declare-fun t () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun v_bool_83_1430_primed () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_2118 () Int)
(declare-fun flted_25_2115 () Int)
(declare-fun n () Int)
(declare-fun nmin_2133 () Int)
(declare-fun v_bool_88_1429_primed () Int)
(declare-fun t_primed () Int)
(declare-fun nmin2_2120 () Int)
(declare-fun flted_25_2114 () Int)
(declare-fun r_2119 () Int)
(declare-fun nmin_2151 () Int)
(declare-fun n_2150 () Int)
(declare-fun l_2117 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= nmin_2151 n_2150))
(assert (<= 0 nmin_2151))
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2133))
(assert (= nmin_2151 nmin_2133))
(assert (= n_2150 n_2132))
(assert (<= nmin1_2118 flted_25_2115))
(assert (<= 0 nmin1_2118))
(assert (= nmin_2133 nmin1_2118))
(assert (= n_2132 flted_25_2115))
(assert (= t_primed t))
(assert (= v_primed v))
(assert (< nmin n))
(assert (> t_primed 0))
(assert (not (> v_bool_83_1430_primed 0)))
(assert (exists ((min_30 Int)) (and (= nmin (+ 1 min_30)) (or (and (= min_30 nmin1_2118) (< nmin1_2118 nmin2_2120)) (and (= min_30 nmin2_2120) (>= nmin1_2118 nmin2_2120))))))
(assert (= (+ flted_25_2114 2) n))
(assert (= (+ flted_25_2115 1) n))
(assert (< nmin_2133 n_2150))
(assert (> v_bool_88_1429_primed 0))
(assert (= t_primed 1))
(assert (or (and (and (<= 1 nmin2_2120) (<= nmin2_2120 flted_25_2114)) (> r_2119 0)) (or (and (and (< r_2119 1) (= flted_25_2114 0)) (= nmin2_2120 0)) (and (and (<= 1 nmin2_2120) (< nmin2_2120 flted_25_2114)) (> r_2119 0)))))
(assert (or (and (and (<= 1 nmin_2151) (<= nmin_2151 n_2150)) (> l_2117 0)) (or (and (and (< l_2117 1) (= n_2150 0)) (= nmin_2151 0)) (and (and (<= 1 nmin_2151) (< nmin_2151 n_2150)) (> l_2117 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)