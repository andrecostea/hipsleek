(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nl_8912 () Int)
(declare-fun bhl_8496 () Int)
(declare-fun bhr_8499 () Int)
(declare-fun bh_8378 () Int)
(declare-fun n_8376 () Int)
(declare-fun nb () Int)
(declare-fun nl_8348 () Int)
(declare-fun nr_8352 () Int)
(declare-fun na () Int)
(declare-fun nl_8495 () Int)
(declare-fun nr_8498 () Int)
(declare-fun n () Int)
(declare-fun flted_156_8901 () Int)
(declare-fun na_8515 () Int)
(declare-fun nb_8516 () Int)
(declare-fun nc_8517 () Int)
(declare-fun nd () Int)
(declare-fun h_8518 () Int)
(declare-fun bh () Int)
(declare-fun bhr_8354 () Int)
(declare-fun bhl_8350 () Int)
(declare-fun flted_238_8357 () Int)
(declare-fun h () Int)
(declare-fun flted_156_8903 () Int)
(declare-fun flted_238_8355 () Int)
(declare-fun bhl_8913 () Int)
(declare-fun bhr_8916 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 flted_156_8901))
(assert (= nl_8912 flted_156_8901))
(assert (<= 0 na))
(assert (<= 1 bhl_8496))
(assert (<= 0 nl_8495))
(assert (<= 1 bhr_8499))
(assert (<= 0 nr_8498))
(assert (<= 0 n))
(assert (<= 0 nr_8352))
(assert (= n_8376 (+ (+ nr_8498 1) nl_8495)))
(assert (= bhl_8496 bh_8378))
(assert (= bhr_8499 bh_8378))
(assert (<= 1 bh_8378))
(assert (<= 0 n_8376))
(assert (<= 1 bhl_8350))
(assert (<= 0 nl_8348))
(assert (= bh_8378 bhl_8350))
(assert (= n_8376 nl_8348))
(assert (= nb (+ (+ nr_8352 1) nl_8348)))
(assert (= n nr_8352))
(assert (= na_8515 na))
(assert (= nb_8516 nl_8495))
(assert (= nc_8517 nr_8498))
(assert (= nd n))
(assert (= flted_156_8901 (+ (+ (+ (+ 3 nc_8517) na_8515) nb_8516) nd)))
(assert (<= 1 flted_238_8355))
(assert (<= 1 flted_156_8903))
(assert (or (and (and (and (and (and (and (and (and (and (and (and (exists ((flted_153_326 Int)) (and (<= 0 flted_153_326) (<= flted_153_326 1))) (exists ((flted_153_325 Int)) (and (<= 0 flted_153_325) (<= flted_153_325 1)))) (exists ((flted_153_324 Int)) (and (<= 0 flted_153_324) (<= flted_153_324 1)))) (exists ((flted_153_323 Int)) (and (<= 0 flted_153_323) (<= flted_153_323 1)))) (exists ((h_329 Int)) (<= 1 h_329))) (exists ((h_328 Int)) (<= 1 h_328))) (exists ((h_327 Int)) (<= 1 h_327))) (<= 0 na_8515)) (<= 1 h_8518)) (<= 0 nb_8516)) (<= 0 nc_8517)) (<= 0 nd)) (and (and (and (and (and (and (and (and (and (and (and (exists ((flted_154_322 Int)) (and (<= 0 flted_154_322) (<= flted_154_322 1))) (exists ((flted_154_321 Int)) (and (<= 0 flted_154_321) (<= flted_154_321 1)))) (exists ((flted_154_320 Int)) (and (<= 0 flted_154_320) (<= flted_154_320 1)))) (exists ((flted_154_319 Int)) (and (<= 0 flted_154_319) (<= flted_154_319 1)))) (exists ((h_332 Int)) (<= 1 h_332))) (exists ((h_331 Int)) (<= 1 h_331))) (exists ((h_330 Int)) (<= 1 h_330))) (<= 0 na_8515)) (<= 1 h_8518)) (<= 0 nb_8516)) (<= 0 nc_8517)) (<= 0 nd))))
(assert (= flted_156_8903 (+ 1 h_8518)))
(assert (<= 1 h))
(assert (<= 1 bh))
(assert (= h_8518 h))
(assert (<= 1 bhr_8354))
(assert (= bh bhr_8354))
(assert (= bhl_8350 bhr_8354))
(assert (= flted_238_8357 (+ bhl_8350 1)))
(assert (= flted_238_8357 (+ 1 h)))
(assert (= flted_238_8355 (+ 1 h)))
(assert (= bhl_8913 flted_156_8903))
(assert (= bhr_8916 flted_238_8355))
(assert (not (= bhl_8913 bhr_8916)))
;Negation of Consequence
(assert (not false))
(check-sat)