(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_268_3692_primed () Int)
(declare-fun Anon_11746 () Int)
(declare-fun flted_13_11742 () Int)
(declare-fun flted_262_11754 () Int)
(declare-fun nb () Int)
(declare-fun nl_11745 () Int)
(declare-fun bhl_11747 () Int)
(declare-fun a () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun flted_262_11753 () Int)
(declare-fun b () Int)
(declare-fun nc () Int)
(declare-fun h () Int)
(declare-fun flted_262_11752 () Int)
(declare-fun nr_11749 () Int)
(declare-fun bhr_11751 () Int)
(declare-fun Anon_11750 () Int)
(declare-fun n () Int)
(declare-fun bh () Int)
(declare-fun cl () Int)
(declare-fun Anon_19 () Int)
(declare-fun na_12075 () Int)
(declare-fun ha () Int)
(declare-fun nb_12076 () Int)
(declare-fun Anon_20 () Int)
(declare-fun nc_12077 () Int)
(declare-fun v_int_280_13036 () Int)
(declare-fun v_13051 () Int)
(declare-fun v_int_280_13035 () Int)
(declare-fun l_13052 () Int)
(declare-fun a_primed () Int)
(declare-fun r_13056 () Int)
(declare-fun tmp_13037 () Int)
(declare-fun nl_13053 () Int)
(declare-fun na () Int)
(declare-fun Anon_13054 () Int)
(declare-fun flted_262_11756 () Int)
(declare-fun bhl_13055 () Int)
(declare-fun flted_262_11755 () Int)
(declare-fun nr_13057 () Int)
(declare-fun flted_139_13032 () Int)
(declare-fun Anon_13058 () Int)
(declare-fun flted_139_13033 () Int)
(declare-fun bhr_13059 () Int)
(declare-fun flted_139_13034 () Int)
(declare-fun b_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_268_3692_primed 0)))
(assert (= cl 1))
(assert (<= Anon_11746 1))
(assert (<= 0 Anon_11746))
(assert (<= 1 bhl_11747))
(assert (<= 0 nl_11745))
(assert (= bh bhl_11747))
(assert (= cl Anon_11746))
(assert (= n nl_11745))
(assert (= flted_13_11742 0))
(assert (= flted_262_11754 0))
(assert (= nb (+ (+ nr_11749 1) nl_11745)))
(assert (= bhl_11747 bhr_11751))
(assert (= flted_262_11753 (+ bhl_11747 1)))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_262_11756 0))
(assert (= flted_262_11755 (+ 1 h)))
(assert (= flted_262_11753 (+ 1 h)))
(assert (= flted_262_11752 0))
(assert (> b 0))
(assert (= na_12075 n))
(assert (= ha bh))
(assert (= nb_12076 nr_11749))
(assert (= Anon_20 Anon_11750))
(assert (= nc_12077 nc))
(assert (<= 0 nc))
(assert (<= 1 h))
(assert (<= 0 flted_262_11752))
(assert (<= flted_262_11752 1))
(assert (<= 0 nr_11749))
(assert (<= 1 bhr_11751))
(assert (<= 0 Anon_11750))
(assert (<= Anon_11750 1))
(assert (<= 0 n))
(assert (<= 1 bh))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (= flted_139_13032 (+ (+ (+ 2 nb_12076) na_12075) nc_12077)))
(assert (= flted_139_13033 1))
(assert (= flted_139_13034 (+ 1 ha)))
(assert (or (and (and (and (and (and (and (and (and (and (exists ((flted_136_364 Int)) (and (<= 0 flted_136_364) (<= flted_136_364 1))) (exists ((flted_136_363 Int)) (and (<= 0 flted_136_363) (<= flted_136_363 1)))) (exists ((ha_366 Int)) (<= 1 ha_366))) (exists ((ha_365 Int)) (<= 1 ha_365))) (<= 0 na_12075)) (<= 1 ha)) (<= 0 nb_12076)) (<= 0 Anon_19)) (<= Anon_19 1)) (<= 0 nc_12077)) (and (and (and (and (and (and (and (and (and (exists ((flted_137_362 Int)) (and (<= 0 flted_137_362) (<= flted_137_362 1))) (exists ((flted_137_361 Int)) (and (<= 0 flted_137_361) (<= flted_137_361 1)))) (exists ((ha_368 Int)) (<= 1 ha_368))) (exists ((ha_367 Int)) (<= 1 ha_367))) (<= 0 na_12075)) (<= 1 ha)) (<= 0 nb_12076)) (<= 0 Anon_20)) (<= Anon_20 1)) (<= 0 nc_12077))))
(assert (= v_int_280_13035 0))
(assert (= v_int_280_13036 0))
(assert (= v_13051 v_int_280_13035))
(assert (= l_13052 a_primed))
(assert (= r_13056 tmp_13037))
(assert (= nl_13053 na))
(assert (= Anon_13054 flted_262_11756))
(assert (= bhl_13055 flted_262_11755))
(assert (= nr_13057 flted_139_13032))
(assert (= Anon_13058 flted_139_13033))
(assert (= bhr_13059 flted_139_13034))
(assert (= b_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)