(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_9304 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_238_8356 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun bh () Int)
(declare-fun nb () Int)
(declare-fun nr_8352 () Int)
(declare-fun bhr_8354 () Int)
(declare-fun bhl_8350 () Int)
(declare-fun flted_238_8357 () Int)
(declare-fun flted_238_8355 () Int)
(declare-fun h () Int)
(declare-fun Anon_8349 () Int)
(declare-fun Anon_17 () Int)
(declare-fun Anon_18 () Int)
(declare-fun h_8681 () Int)
(declare-fun n () Int)
(declare-fun nl_8348 () Int)
(declare-fun na () Int)
(declare-fun nb_8679 () Int)
(declare-fun na_8678 () Int)
(declare-fun nc_8680 () Int)
(declare-fun l_9300 () Int)
(declare-fun flted_122_9281 () Int)
(declare-fun flted_122_9282 () Int)
(declare-fun flted_122_9280 () Int)
(declare-fun tmp_9285 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= c_primed c))
(assert (= flted_238_8356 0))
(assert (> c 0))
(assert (= r_9304 c_primed))
(assert (or (and (and (and (= flted_238_8356 0) (<= 2 flted_238_8355)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= flted_238_8355 1)) (= flted_238_8356 0)) (and (and (and (= flted_238_8356 1) (<= 1 flted_238_8355)) (<= 1 nc)) (> c 0)))))
(assert (<= 1 h))
(assert (<= Anon_8349 1))
(assert (<= 0 Anon_8349))
(assert (<= 1 bhl_8350))
(assert (<= 1 bh))
(assert (<= 1 bhr_8354))
(assert (<= 0 nr_8352))
(assert (= bh bhr_8354))
(assert (= n nr_8352))
(assert (= nb (+ (+ nr_8352 1) nl_8348)))
(assert (= bhl_8350 bhr_8354))
(assert (= flted_238_8357 (+ bhl_8350 1)))
(assert (= flted_238_8357 (+ 1 h)))
(assert (= flted_238_8355 (+ 1 h)))
(assert (= h_8681 h))
(assert (= Anon_18 Anon_8349))
(assert (or (and (and (and (and (and (and (and (and (and (exists ((flted_119_9434 Int)) (and (<= 0 flted_119_9434) (<= flted_119_9434 1))) (exists ((flted_119_9433 Int)) (and (<= 0 flted_119_9433) (<= flted_119_9433 1)))) (exists ((h_9432 Int)) (<= 1 h_9432))) (exists ((h_9431 Int)) (<= 1 h_9431))) (<= 0 na_8678)) (<= 1 h_8681)) (<= 0 nb_8679)) (<= 0 Anon_17)) (<= Anon_17 1)) (<= 0 nc_8680)) (and (and (and (and (and (and (and (and (and (exists ((flted_120_9430 Int)) (and (<= 0 flted_120_9430) (<= flted_120_9430 1))) (exists ((flted_120_9429 Int)) (and (<= 0 flted_120_9429) (<= flted_120_9429 1)))) (exists ((h_9428 Int)) (<= 1 h_9428))) (exists ((h_9427 Int)) (<= 1 h_9427))) (<= 0 na_8678)) (<= 1 h_8681)) (<= 0 nb_8679)) (<= 0 Anon_18)) (<= Anon_18 1)) (<= 0 nc_8680))))
(assert (= flted_122_9282 (+ 1 h_8681)))
(assert (= flted_122_9281 1))
(assert (<= 0 na))
(assert (<= 0 nl_8348))
(assert (<= 0 n))
(assert (= nc_8680 n))
(assert (= nb_8679 nl_8348))
(assert (= na_8678 na))
(assert (= flted_122_9280 (+ (+ (+ 2 nb_8679) na_8678) nc_8680)))
(assert (= l_9300 tmp_9285))
(assert (or (and (and (and (= flted_122_9281 0) (<= 2 flted_122_9282)) (<= 1 flted_122_9280)) (> tmp_9285 0)) (or (and (and (and (< tmp_9285 1) (= flted_122_9280 0)) (= flted_122_9282 1)) (= flted_122_9281 0)) (and (and (and (= flted_122_9281 1) (<= 1 flted_122_9282)) (<= 1 flted_122_9280)) (> tmp_9285 0)))))
;Negation of Consequence
(assert (not (or (= flted_122_9280 0) (< tmp_9285 1))))
(check-sat)