(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhl_13055 () Int)
(declare-fun flted_262_11755 () Int)
(declare-fun bhr_13059 () Int)
(declare-fun h () Int)
(declare-fun flted_262_11753 () Int)
(declare-fun bhr_11751 () Int)
(declare-fun bhl_11747 () Int)
(declare-fun n () Int)
(declare-fun bh () Int)
(declare-fun Anon_11750 () Int)
(declare-fun flted_139_13034 () Int)
(declare-fun Anon_19 () Int)
(declare-fun na_12075 () Int)
(declare-fun ha () Int)
(declare-fun nb_12076 () Int)
(declare-fun Anon_20 () Int)
(declare-fun flted_139_13032 () Int)
(declare-fun nc_12077 () Int)
(declare-fun nr_11749 () Int)
(declare-fun nl_11745 () Int)
(declare-fun nl_13053 () Int)
(declare-fun nr_13057 () Int)
(declare-fun nc () Int)
(declare-fun nb () Int)
(declare-fun na () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhl_13055 flted_262_11755))
(assert (<= 1 flted_262_11755))
(assert (= flted_262_11755 (+ 1 h)))
(assert (= bhr_13059 flted_139_13034))
(assert (<= 1 bh))
(assert (<= 0 n))
(assert (<= Anon_11750 1))
(assert (<= 0 Anon_11750))
(assert (<= 1 bhr_11751))
(assert (<= 1 h))
(assert (= flted_262_11753 (+ 1 h)))
(assert (= flted_262_11753 (+ bhl_11747 1)))
(assert (= bhl_11747 bhr_11751))
(assert (<= 1 flted_139_13034))
(assert (<= 0 flted_139_13032))
(assert (<= 1 bhl_11747))
(assert (<= 0 nl_11745))
(assert (= bh bhl_11747))
(assert (= n nl_11745))
(assert (= na_12075 n))
(assert (= ha bh))
(assert (= nb_12076 nr_11749))
(assert (= Anon_20 Anon_11750))
(assert (<= 0 nr_11749))
(assert (= flted_139_13032 (+ (+ (+ 2 nb_12076) na_12075) nc_12077)))
(assert (= flted_139_13034 (+ 1 ha)))
(assert (or (and (and (and (and (and (and (and (and (and (exists ((flted_136_13250 Int)) (and (<= 0 flted_136_13250) (<= flted_136_13250 1))) (exists ((flted_136_13249 Int)) (and (<= 0 flted_136_13249) (<= flted_136_13249 1)))) (exists ((ha_13248 Int)) (<= 1 ha_13248))) (exists ((ha_13247 Int)) (<= 1 ha_13247))) (<= 0 na_12075)) (<= 1 ha)) (<= 0 nb_12076)) (<= 0 Anon_19)) (<= Anon_19 1)) (<= 0 nc_12077)) (and (and (and (and (and (and (and (and (and (exists ((flted_137_13246 Int)) (and (<= 0 flted_137_13246) (<= flted_137_13246 1))) (exists ((flted_137_13245 Int)) (and (<= 0 flted_137_13245) (<= flted_137_13245 1)))) (exists ((ha_13244 Int)) (<= 1 ha_13244))) (exists ((ha_13243 Int)) (<= 1 ha_13243))) (<= 0 na_12075)) (<= 1 ha)) (<= 0 nb_12076)) (<= 0 Anon_20)) (<= Anon_20 1)) (<= 0 nc_12077))))
(assert (= nr_13057 flted_139_13032))
(assert (= nl_13053 na))
(assert (<= 0 nc))
(assert (= nc_12077 nc))
(assert (= nb (+ (+ nr_11749 1) nl_11745)))
(assert (<= 0 na))
;Negation of Consequence
(assert (not (= (+ (+ nl_13053 nr_13057) 1) (+ (+ (+ nc nb) 2) na))))
(check-sat)