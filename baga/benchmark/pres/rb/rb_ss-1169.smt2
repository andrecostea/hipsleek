(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_10168 () Int)
(declare-fun bhr_10368 () Int)
(declare-fun bhl_10364 () Int)
(declare-fun bhr_10334 () Int)
(declare-fun nr_10166 () Int)
(declare-fun nr_10366 () Int)
(declare-fun Anon_10363 () Int)
(declare-fun nl_10362 () Int)
(declare-fun nl_10162 () Int)
(declare-fun nr_10332 () Int)
(declare-fun nl_10328 () Int)
(declare-fun bhl_10164 () Int)
(declare-fun bhl_10330 () Int)
(declare-fun nr_9860 () Int)
(declare-fun nl_9857 () Int)
(declare-fun bhl_9858 () Int)
(declare-fun bhr_9861 () Int)
(declare-fun ha_9862 () Int)
(declare-fun ha_9863 () Int)
(declare-fun Anon_19 () Int)
(declare-fun na () Int)
(declare-fun ha () Int)
(declare-fun nb () Int)
(declare-fun Anon_20 () Int)
(declare-fun nc () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 1 bhl_9858))
(assert (<= 0 nl_9857))
(assert (<= 1 bhr_9861))
(assert (<= 0 nr_9860))
(assert (<= 1 ha_9862))
(assert (<= 1 ha_9863))
(assert (= bhr_10168 (+ bhl_10364 1)))
(assert (= bhl_10364 bhr_10368))
(assert (= bhr_10368 ha_9863))
(assert (= bhl_10364 ha_9862))
(assert (= bhl_10330 bhr_10334))
(assert (= bhr_10334 bhr_9861))
(assert (= nr_10332 nr_9860))
(assert (= bhl_10330 bhl_9858))
(assert (= nl_10328 nl_9857))
(assert (<= Anon_19 1))
(assert (<= 0 Anon_19))
(assert (<= 0 nb))
(assert (<= 0 nc))
(assert (= nr_10166 (+ (+ nr_10366 1) nl_10362)))
(assert (= nr_10366 nc))
(assert (= Anon_10363 Anon_19))
(assert (= nl_10362 nb))
(assert (= nl_10162 (+ (+ nr_10332 1) nl_10328)))
(assert (= bhl_10164 (+ bhl_10330 1)))
(assert (= na (+ (+ nr_9860 1) nl_9857)))
(assert (= bhl_9858 ha))
(assert (= bhr_9861 ha))
(assert (= ha_9862 ha))
(assert (= ha_9863 ha))
(assert (or (and (and (and (and (and (and (and (and (and (exists ((flted_136_364 Int)) (and (<= 0 flted_136_364) (<= flted_136_364 1))) (exists ((flted_136_363 Int)) (and (<= 0 flted_136_363) (<= flted_136_363 1)))) (exists ((ha_366 Int)) (<= 1 ha_366))) (exists ((ha_365 Int)) (<= 1 ha_365))) (<= 0 na)) (<= 1 ha)) (<= 0 nb)) (<= 0 Anon_19)) (<= Anon_19 1)) (<= 0 nc)) (and (and (and (and (and (and (and (and (and (exists ((flted_137_362 Int)) (and (<= 0 flted_137_362) (<= flted_137_362 1))) (exists ((flted_137_361 Int)) (and (<= 0 flted_137_361) (<= flted_137_361 1)))) (exists ((ha_368 Int)) (<= 1 ha_368))) (exists ((ha_367 Int)) (<= 1 ha_367))) (<= 0 na)) (<= 1 ha)) (<= 0 nb)) (<= 0 Anon_20)) (<= Anon_20 1)) (<= 0 nc))))
;Negation of Consequence
(assert (not false))
(check-sat)