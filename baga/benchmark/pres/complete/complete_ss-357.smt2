(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin_2151 () Int)
(declare-fun n_2150 () Int)
(declare-fun nmin_2133 () Int)
(declare-fun n_2132 () Int)
(declare-fun l_2592 () Int)
(declare-fun nmin1_2593 () Int)
(declare-fun nmin_2302 () Int)
(declare-fun l_2117 () Int)
(declare-fun n_2301 () Int)
(declare-fun flted_25_2115 () Int)
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_2118 () Int)
(declare-fun flted_25_2114 () Int)
(declare-fun nmin2_2120 () Int)
(declare-fun n_2216 () Int)
(declare-fun nmin_2217 () Int)
(declare-fun n_2234 () Int)
(declare-fun nmin_2235 () Int)
(declare-fun n_2313 () Int)
(declare-fun nmin_2314 () Int)
(declare-fun nmin_2343 () Int)
(declare-fun n_2342 () Int)
(declare-fun r_2594 () Int)
(declare-fun flted_79_2361 () Int)
(declare-fun nmin1_2362 () Int)
(declare-fun aux_2588 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= n_2150 nmin_2133))
(assert (<= nmin_2314 n_2313))
(assert (<= 0 nmin_2314))
(assert (<= nmin_2235 n_2234))
(assert (<= 0 nmin_2235))
(assert (<= nmin_2302 n_2301))
(assert (<= 0 nmin_2302))
(assert (<= nmin_2151 n_2150))
(assert (<= 0 nmin_2151))
(assert (= nmin_2302 nmin_2151))
(assert (= n_2301 n_2150))
(assert (<= nmin_2217 n_2216))
(assert (<= 0 nmin_2217))
(assert (<= nmin2_2120 flted_25_2114))
(assert (<= 0 nmin2_2120))
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2133))
(assert (= nmin_2151 nmin_2133))
(assert (= n_2150 n_2132))
(assert (<= nmin1_2118 flted_25_2115))
(assert (<= 0 nmin1_2118))
(assert (= nmin_2133 nmin1_2118))
(assert (= n_2132 flted_25_2115))
(assert (< nmin n))
(assert (= l_2592 l_2117))
(assert (= nmin1_2593 nmin_2302))
(assert (or (and (and (<= 1 nmin_2302) (<= nmin_2302 n_2301)) (> l_2117 0)) (or (and (and (< l_2117 1) (= n_2301 0)) (= nmin_2302 0)) (and (and (<= 1 nmin_2302) (< nmin_2302 n_2301)) (> l_2117 0)))))
(assert (not (= n_2301 n_2313)))
(assert (<= n_2234 nmin_2217))
(assert (= (+ flted_25_2115 1) n))
(assert (= (+ flted_25_2114 2) n))
(assert (exists ((min_2615 Int)) (and (= nmin (+ 1 min_2615)) (or (and (= min_2615 nmin1_2118) (< nmin1_2118 nmin2_2120)) (and (= min_2615 nmin2_2120) (>= nmin1_2118 nmin2_2120))))))
(assert (= n_2216 flted_25_2114))
(assert (= nmin_2217 nmin2_2120))
(assert (= n_2234 n_2216))
(assert (= nmin_2235 nmin_2217))
(assert (= n_2313 n_2234))
(assert (= nmin_2314 nmin_2235))
(assert (= n_2342 n_2313))
(assert (= nmin_2343 nmin_2314))
(assert (<= 0 nmin_2343))
(assert (<= nmin_2343 n_2342))
(assert (or (= nmin1_2362 nmin_2343) (= nmin1_2362 (+ 1 nmin_2343))))
(assert (= flted_79_2361 (+ 1 n_2342)))
(assert (= r_2594 aux_2588))
(assert (or (and (and (<= 1 nmin1_2362) (<= nmin1_2362 flted_79_2361)) (> aux_2588 0)) (or (and (and (< aux_2588 1) (= flted_79_2361 0)) (= nmin1_2362 0)) (and (and (<= 1 nmin1_2362) (< nmin1_2362 flted_79_2361)) (> aux_2588 0)))))
;Negation of Consequence
(assert (not (or (= flted_79_2361 0) (or (= nmin1_2362 0) (< aux_2588 1)))))
(check-sat)