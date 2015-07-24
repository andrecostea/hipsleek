(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin2_2427 () Int)
(declare-fun nmin1_2425 () Int)
(declare-fun r_2426 () Int)
(declare-fun l_2424 () Int)
(declare-fun nmin () Int)
(declare-fun flted_26_2123 () Int)
(declare-fun nmin1_2126 () Int)
(declare-fun n_2132 () Int)
(declare-fun nmin_2133 () Int)
(declare-fun nmin_2151 () Int)
(declare-fun nmin_2177 () Int)
(declare-fun n_2150 () Int)
(declare-fun n () Int)
(declare-fun nmin2_2128 () Int)
(declare-fun r_2127 () Int)
(declare-fun nmin1_2207 () Int)
(declare-fun aux_2420 () Int)
(declare-fun n_2176 () Int)
(declare-fun flted_26_2122 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2133))
(assert (<= nmin1_2126 flted_26_2123))
(assert (<= 0 nmin1_2126))
(assert (= nmin2_2427 nmin2_2128))
(assert (= nmin1_2425 nmin1_2207))
(assert (= r_2426 r_2127))
(assert (= l_2424 aux_2420))
(assert (< nmin_2133 n_2150))
(assert (= (+ flted_26_2123 1) n))
(assert (exists ((min_2450 Int)) (and (= nmin (+ 1 min_2450)) (or (and (= min_2450 nmin1_2126) (< nmin1_2126 nmin2_2128)) (and (= min_2450 nmin2_2128) (>= nmin1_2126 nmin2_2128))))))
(assert (< nmin n))
(assert (= n_2132 flted_26_2123))
(assert (= nmin_2133 nmin1_2126))
(assert (= n_2150 n_2132))
(assert (= nmin_2151 nmin_2133))
(assert (= nmin_2177 nmin_2151))
(assert (<= 0 nmin_2151))
(assert (<= nmin_2151 n_2150))
(assert (or (= nmin1_2207 nmin_2177) (= nmin1_2207 (+ 1 nmin_2177))))
(assert (<= 0 nmin_2177))
(assert (<= nmin_2177 n_2176))
(assert (= n_2176 n_2150))
(assert (= (+ flted_26_2122 1) n))
(assert (or (and (and (<= 1 nmin2_2128) (<= nmin2_2128 flted_26_2122)) (> r_2127 0)) (or (and (and (< r_2127 1) (= flted_26_2122 0)) (= nmin2_2128 0)) (and (and (<= 1 nmin2_2128) (< nmin2_2128 flted_26_2122)) (> r_2127 0)))))
(assert (or (and (and (<= 1 nmin1_2207) (<= nmin1_2207 n_2176)) (> aux_2420 0)) (or (and (and (< aux_2420 1) (= n_2176 0)) (= nmin1_2207 0)) (and (and (<= 1 nmin1_2207) (< nmin1_2207 n_2176)) (> aux_2420 0)))))
;Negation of Consequence
(assert (not (= (+ 1 n_2176) (+ 2 flted_26_2122))))
(check-sat)