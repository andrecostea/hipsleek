(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_139_12322 () Int)
(declare-fun tmp_primed () Int)
(declare-fun bhr_11751 () Int)
(declare-fun bhl_11747 () Int)
(declare-fun bh () Int)
(declare-fun Anon_11750 () Int)
(declare-fun nc () Int)
(declare-fun flted_139_12323 () Int)
(declare-fun Anon_19 () Int)
(declare-fun ha () Int)
(declare-fun Anon_20 () Int)
(declare-fun flted_139_12321 () Int)
(declare-fun nc_12077 () Int)
(declare-fun na_12075 () Int)
(declare-fun flted_262_11753 () Int)
(declare-fun h () Int)
(declare-fun a_primed () Int)
(declare-fun hb () Int)
(declare-fun flted_262_11756 () Int)
(declare-fun flted_262_11755 () Int)
(declare-fun a () Int)
(declare-fun n () Int)
(declare-fun nb_12076 () Int)
(declare-fun nr_11749 () Int)
(declare-fun nl_11745 () Int)
(declare-fun na () Int)
(declare-fun n_1 () Int)
(declare-fun nb () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_139_12322 1))
(assert (<= 1 bh))
(assert (<= Anon_11750 1))
(assert (<= 0 Anon_11750))
(assert (<= 1 bhr_11751))
(assert (<= 0 nc))
(assert (or (and (and (and (= flted_139_12322 0) (<= 2 flted_139_12323)) (<= 1 flted_139_12321)) (> tmp_primed 0)) (or (and (and (and (< tmp_primed 1) (= flted_139_12321 0)) (= flted_139_12323 1)) (= flted_139_12322 0)) (and (and (and (= flted_139_12322 1) (<= 1 flted_139_12323)) (<= 1 flted_139_12321)) (> tmp_primed 0)))))
(assert (<= 1 bhl_11747))
(assert (= bh bhl_11747))
(assert (= bhl_11747 bhr_11751))
(assert (= flted_262_11753 (+ bhl_11747 1)))
(assert (= ha bh))
(assert (= Anon_20 Anon_11750))
(assert (= nc_12077 nc))
(assert (= flted_139_12323 (+ 1 ha)))
(assert (or (and (and (and (and (and (and (and (and (and (exists ((flted_136_12357 Int)) (and (<= 0 flted_136_12357) (<= flted_136_12357 1))) (exists ((flted_136_12356 Int)) (and (<= 0 flted_136_12356) (<= flted_136_12356 1)))) (exists ((ha_12355 Int)) (<= 1 ha_12355))) (exists ((ha_12354 Int)) (<= 1 ha_12354))) (<= 0 na_12075)) (<= 1 ha)) (<= 0 nb_12076)) (<= 0 Anon_19)) (<= Anon_19 1)) (<= 0 nc_12077)) (and (and (and (and (and (and (and (and (and (exists ((flted_137_12353 Int)) (and (<= 0 flted_137_12353) (<= flted_137_12353 1))) (exists ((flted_137_12352 Int)) (and (<= 0 flted_137_12352) (<= flted_137_12352 1)))) (exists ((ha_12351 Int)) (<= 1 ha_12351))) (exists ((ha_12350 Int)) (<= 1 ha_12350))) (<= 0 na_12075)) (<= 1 ha)) (<= 0 nb_12076)) (<= 0 Anon_20)) (<= Anon_20 1)) (<= 0 nc_12077))))
(assert (= flted_139_12321 (+ (+ (+ 2 nb_12076) na_12075) nc_12077)))
(assert (<= 0 n))
(assert (<= 1 h))
(assert (= na_12075 n))
(assert (= flted_262_11753 (+ 1 h)))
(assert (= flted_262_11755 (+ 1 h)))
(assert (= flted_262_11756 0))
(assert (= a_primed a))
(assert (= hb flted_262_11755))
(assert (or (and (and (and (= flted_262_11756 0) (<= 2 flted_262_11755)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= flted_262_11755 1)) (= flted_262_11756 0)) (and (and (and (= flted_262_11756 1) (<= 1 flted_262_11755)) (<= 1 na)) (> a 0)))))
(assert (<= 0 nl_11745))
(assert (= n nl_11745))
(assert (= nb_12076 nr_11749))
(assert (<= 0 nr_11749))
(assert (= nb (+ (+ nr_11749 1) nl_11745)))
(assert (= n_1 na))
;Negation of Consequence
(assert (not (= n_1 nb)))
(check-sat)