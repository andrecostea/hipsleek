(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun h () Int)
(declare-fun bhl_10950 () Int)
(declare-fun bhr_10953 () Int)
(declare-fun flted_168_10938 () Int)
(declare-fun flted_138_11411 () Int)
(declare-fun Anon_19 () Int)
(declare-fun ha () Int)
(declare-fun Anon_20 () Int)
(declare-fun na_10926 () Int)
(declare-fun nc_10928 () Int)
(declare-fun nb_10927 () Int)
(declare-fun nl_10949 () Int)
(declare-fun nr_10952 () Int)
(declare-fun flted_138_11413 () Int)
(declare-fun nd () Int)
(declare-fun na () Int)
(declare-fun nc () Int)
(declare-fun nb () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 1 h))
(assert (<= flted_168_10938 1))
(assert (<= 0 flted_168_10938))
(assert (= bhl_10950 h))
(assert (= bhr_10953 h))
(assert (= bhr_10953 bhl_10950))
(assert (<= 1 flted_138_11411))
(assert (= na_10926 (+ (+ nr_10952 1) nl_10949)))
(assert (= bhl_10950 ha))
(assert (= bhr_10953 ha))
(assert (= flted_168_10938 0))
(assert (= Anon_19 flted_168_10938))
(assert (= flted_138_11411 (+ 2 ha)))
(assert (or (and (and (and (and (and (and (and (and (and (exists ((flted_136_11460 Int)) (and (<= 0 flted_136_11460) (<= flted_136_11460 1))) (exists ((flted_136_11459 Int)) (and (<= 0 flted_136_11459) (<= flted_136_11459 1)))) (exists ((ha_11458 Int)) (<= 1 ha_11458))) (exists ((ha_11457 Int)) (<= 1 ha_11457))) (<= 0 na_10926)) (<= 1 ha)) (<= 0 nb_10927)) (<= 0 Anon_19)) (<= Anon_19 1)) (<= 0 nc_10928)) (and (and (and (and (and (and (and (and (and (exists ((flted_137_11456 Int)) (and (<= 0 flted_137_11456) (<= flted_137_11456 1))) (exists ((flted_137_11455 Int)) (and (<= 0 flted_137_11455) (<= flted_137_11455 1)))) (exists ((ha_11454 Int)) (<= 1 ha_11454))) (exists ((ha_11453 Int)) (<= 1 ha_11453))) (<= 0 na_10926)) (<= 1 ha)) (<= 0 nb_10927)) (<= 0 Anon_20)) (<= Anon_20 1)) (<= 0 nc_10928))))
(assert (= flted_138_11413 (+ (+ (+ 2 nb_10927) na_10926) nc_10928)))
(assert (<= 0 na))
(assert (<= 0 nb))
(assert (<= 0 nc))
(assert (<= 0 nd))
(assert (= nc_10928 nd))
(assert (= nb_10927 nc))
(assert (= nl_10949 na))
(assert (= nr_10952 nb))
(assert (<= 0 flted_138_11413))
;Negation of Consequence
(assert (not (= flted_138_11413 (+ (+ (+ (+ nd na) 3) nc) nb))))
(check-sat)