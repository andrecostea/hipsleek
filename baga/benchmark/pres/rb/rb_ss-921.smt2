(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun v_int_253_8742 () Int)
(declare-fun v_int_253_8741 () Int)
(declare-fun nc_8399 () Int)
(declare-fun nb_8398 () Int)
(declare-fun ha () Int)
(declare-fun na_8397 () Int)
(declare-fun na () Int)
(declare-fun v_bool_244_3884_primed () Int)
(declare-fun bh () Int)
(declare-fun cl () Int)
(declare-fun Anon_8353 () Int)
(declare-fun n () Int)
(declare-fun flted_13_8345 () Int)
(declare-fun flted_238_8358 () Int)
(declare-fun nb () Int)
(declare-fun nr_8352 () Int)
(declare-fun bhr_8354 () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun c_primed () Int)
(declare-fun flted_238_8359 () Int)
(declare-fun flted_238_8357 () Int)
(declare-fun h () Int)
(declare-fun b () Int)
(declare-fun n_8376 () Int)
(declare-fun bh_8378 () Int)
(declare-fun nl_8348 () Int)
(declare-fun bhl_8350 () Int)
(declare-fun Anon_8349 () Int)
(declare-fun cl_8377 () Int)
(declare-fun v_bool_246_3868_primed () Int)
(declare-fun flted_238_8356 () Int)
(declare-fun flted_238_8355 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_183_8739 () Int)
(declare-fun flted_183_8738 () Int)
(declare-fun flted_183_8740 () Int)
(declare-fun tmp_8743 () Int)
(declare-fun b_primed () Int)
(declare-fun v_node_253_3887_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res v_node_253_3887_primed))
(assert (= v_int_253_8742 0))
(assert (= v_int_253_8741 0))
(assert (<= 0 nc_8399))
(assert (<= 0 nb_8398))
(assert (<= 1 ha))
(assert (<= 0 na_8397))
(assert (exists ((ha_239 Int)) (<= 1 ha_239)))
(assert (exists ((ha_240 Int)) (<= 1 ha_240)))
(assert (exists ((flted_182_236 Int)) (and (<= 0 flted_182_236) (<= flted_182_236 1))))
(assert (exists ((flted_182_237 Int)) (and (<= 0 flted_182_237) (<= flted_182_237 1))))
(assert (exists ((flted_182_238 Int)) (and (<= 0 flted_182_238) (<= flted_182_238 1))))
(assert (= flted_183_8738 (+ 1 ha)))
(assert (= flted_183_8739 0))
(assert (= flted_183_8740 (+ (+ (+ 2 nb_8398) na_8397) nc_8399)))
(assert (<= flted_238_8359 1))
(assert (<= 0 flted_238_8359))
(assert (<= 1 h))
(assert (<= 0 na))
(assert (<= cl_8377 1))
(assert (<= 0 cl_8377))
(assert (<= 1 bh_8378))
(assert (<= 0 n_8376))
(assert (<= cl 1))
(assert (<= 0 cl))
(assert (<= 1 bh))
(assert (<= 0 n))
(assert (= nc_8399 n))
(assert (= nb_8398 n_8376))
(assert (= ha h))
(assert (= na_8397 na))
(assert (> v_bool_244_3884_primed 0))
(assert (= cl 0))
(assert (<= Anon_8353 1))
(assert (<= 0 Anon_8353))
(assert (<= 1 bhr_8354))
(assert (<= 0 nr_8352))
(assert (= bh bhr_8354))
(assert (= cl Anon_8353))
(assert (= n nr_8352))
(assert (= flted_13_8345 0))
(assert (= flted_238_8358 0))
(assert (= nb (+ (+ nr_8352 1) nl_8348)))
(assert (= bhl_8350 bhr_8354))
(assert (= flted_238_8357 (+ bhl_8350 1)))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_238_8359 0))
(assert (= flted_238_8357 (+ 1 h)))
(assert (= flted_238_8356 0))
(assert (= flted_238_8355 (+ 1 h)))
(assert (> b 0))
(assert (> c 0))
(assert (= n_8376 nl_8348))
(assert (= cl_8377 Anon_8349))
(assert (= bh_8378 bhl_8350))
(assert (<= 0 nl_8348))
(assert (<= 1 bhl_8350))
(assert (<= 0 Anon_8349))
(assert (<= Anon_8349 1))
(assert (= cl_8377 0))
(assert (> v_bool_246_3868_primed 0))
(assert (= b_primed 1))
(assert (or (and (and (and (= flted_238_8356 0) (<= 2 flted_238_8355)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= flted_238_8355 1)) (= flted_238_8356 0)) (and (and (and (= flted_238_8356 1) (<= 1 flted_238_8355)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_183_8739 0) (<= 2 flted_183_8738)) (<= 1 flted_183_8740)) (> tmp_8743 0)) (or (and (and (and (< tmp_8743 1) (= flted_183_8740 0)) (= flted_183_8738 1)) (= flted_183_8739 0)) (and (and (and (= flted_183_8739 1) (<= 1 flted_183_8738)) (<= 1 flted_183_8740)) (> tmp_8743 0)))))
(assert (= v_node_253_3887_primed 2))
(assert (not (= b_primed v_node_253_3887_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)