(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_169_11359 () Int)
(declare-fun Anon_19 () Int)
(declare-fun Anon_20 () Int)
(declare-fun bhr_11374 () Int)
(declare-fun nr_11373 () Int)
(declare-fun bhl_11371 () Int)
(declare-fun nl_11370 () Int)
(declare-fun h () Int)
(declare-fun nb_10927 () Int)
(declare-fun na_10926 () Int)
(declare-fun nc_10928 () Int)
(declare-fun flted_139_11525 () Int)
(declare-fun ha () Int)
(declare-fun flted_139_11527 () Int)
(declare-fun nd () Int)
(declare-fun na () Int)
(declare-fun nc () Int)
(declare-fun nb () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= flted_169_11359 1))
(assert (<= 0 flted_169_11359))
(assert (= na_10926 (+ (+ nr_11373 1) nl_11370)))
(assert (= bhl_11371 ha))
(assert (= bhr_11374 ha))
(assert (= bhr_11374 bhl_11371))
(assert (= flted_169_11359 0))
(assert (= Anon_20 flted_169_11359))
(assert (or (and (and (and (and (and (and (and (and (and (exists ((flted_136_364 Int)) (and (<= 0 flted_136_364) (<= flted_136_364 1))) (exists ((flted_136_363 Int)) (and (<= 0 flted_136_363) (<= flted_136_363 1)))) (exists ((ha_366 Int)) (<= 1 ha_366))) (exists ((ha_365 Int)) (<= 1 ha_365))) (<= 0 na_10926)) (<= 1 ha)) (<= 0 nb_10927)) (<= 0 Anon_19)) (<= Anon_19 1)) (<= 0 nc_10928)) (and (and (and (and (and (and (and (and (and (exists ((flted_137_362 Int)) (and (<= 0 flted_137_362) (<= flted_137_362 1))) (exists ((flted_137_361 Int)) (and (<= 0 flted_137_361) (<= flted_137_361 1)))) (exists ((ha_368 Int)) (<= 1 ha_368))) (exists ((ha_367 Int)) (<= 1 ha_367))) (<= 0 na_10926)) (<= 1 ha)) (<= 0 nb_10927)) (<= 0 Anon_20)) (<= Anon_20 1)) (<= 0 nc_10928))))
(assert (<= 1 flted_139_11525))
(assert (<= 0 flted_139_11527))
(assert (= bhr_11374 h))
(assert (= nr_11373 nb))
(assert (= bhl_11371 h))
(assert (= nl_11370 na))
(assert (= nb_10927 nc))
(assert (= nc_10928 nd))
(assert (<= 0 nd))
(assert (<= 0 nc))
(assert (<= 0 nb))
(assert (<= 0 na))
(assert (<= 1 h))
(assert (= flted_139_11527 (+ (+ (+ 2 nb_10927) na_10926) nc_10928)))
(assert (= flted_139_11525 (+ 1 ha)))
(assert (= flted_139_11527 (+ (+ (+ (+ nd na) 3) nc) nb)))
;Negation of Consequence
(assert (not false))
(check-sat)