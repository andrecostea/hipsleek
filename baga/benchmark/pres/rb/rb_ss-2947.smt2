(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_13_17105 () Int)
(declare-fun v_bool_597_2192_primed () Int)
(declare-fun bh_17035 () Int)
(declare-fun cl () Int)
(declare-fun Anon_17008 () Int)
(declare-fun n_17034 () Int)
(declare-fun right_592_17010 () Int)
(declare-fun bh1_17009 () Int)
(declare-fun flted_529_17007 () Int)
(declare-fun bh_16983 () Int)
(declare-fun Anon_16982 () Int)
(declare-fun Anon_16676 () Int)
(declare-fun n_16981 () Int)
(declare-fun tmp_primed () Int)
(declare-fun r_16674 () Int)
(declare-fun x () Int)
(declare-fun v () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v_bool_534_2200_primed () Int)
(declare-fun bh () Int)
(declare-fun bhr_16677 () Int)
(declare-fun n () Int)
(declare-fun nr_16675 () Int)
(declare-fun Anon_22 () Int)
(declare-fun flted_13_16668 () Int)
(declare-fun v_16669 () Int)
(declare-fun v_primed () Int)
(declare-fun v_bool_539_2199_primed () Int)
(declare-fun v_bool_595_2198_primed () Int)
(declare-fun v_node_592_17018 () Int)
(declare-fun Anon_16672 () Int)
(declare-fun bhl_16673 () Int)
(declare-fun nl_16671 () Int)
(declare-fun l_16670 () Int)
(declare-fun Anon_17109 () Int)
(declare-fun bhl_17110 () Int)
(declare-fun nl_17108 () Int)
(declare-fun l_17107 () Int)
(declare-fun Anon_17113 () Int)
(declare-fun bhr_17114 () Int)
(declare-fun nr_17112 () Int)
(declare-fun r_17111 () Int)
(declare-fun x_primed () Int)
(declare-fun v_node_599_2018_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_13_17105 0))
(assert (= cl 0))
(assert (= n_17034 (+ (+ nr_17112 1) nl_17108)))
(assert (= bhl_17110 bhr_17114))
(assert (= bh_17035 (+ bhl_17110 1)))
(assert (> v_bool_597_2192_primed 0))
(assert (<= cl 1))
(assert (<= 0 cl))
(assert (<= 1 bh_17035))
(assert (<= 0 n_17034))
(assert (= cl 1))
(assert (<= Anon_17008 1))
(assert (<= 0 Anon_17008))
(assert (<= 1 bh1_17009))
(assert (<= 0 flted_529_17007))
(assert (= bh_17035 bh1_17009))
(assert (= cl Anon_17008))
(assert (= n_17034 flted_529_17007))
(assert (= right_592_17010 r_16674))
(assert (<= Anon_16982 1))
(assert (<= 0 Anon_16982))
(assert (<= 1 bh_16983))
(assert (<= 0 n_16981))
(assert (<= bh1_17009 bh_16983))
(assert (<= bh_16983 bh1_17009))
(assert (> v_node_592_17018 0))
(assert (= flted_529_17007 (+ 1 n_16981)))
(assert (<= Anon_16676 1))
(assert (<= 0 Anon_16676))
(assert (<= 1 bhr_16677))
(assert (<= 0 nr_16675))
(assert (= bh_16983 bhr_16677))
(assert (= Anon_16982 Anon_16676))
(assert (= n_16981 nr_16675))
(assert (= tmp_primed r_16674))
(assert (= x_primed x))
(assert (= v_primed v))
(assert (< tmp_null_primed 1))
(assert (> x_primed 0))
(assert (not (> v_bool_534_2200_primed 0)))
(assert (= bh (+ bhl_16673 1)))
(assert (= bhl_16673 bhr_16677))
(assert (= n (+ (+ nr_16675 1) nl_16671)))
(assert (= Anon_22 0))
(assert (= flted_13_16668 0))
(assert (< v_16669 v_primed))
(assert (not (> v_bool_539_2199_primed 0)))
(assert (> v_bool_595_2198_primed 0))
(assert (= v_node_599_2018_primed v_node_592_17018))
(assert (or (and (and (and (= Anon_16672 0) (<= 2 bhl_16673)) (<= 1 nl_16671)) (> l_16670 0)) (or (and (and (and (< l_16670 1) (= nl_16671 0)) (= bhl_16673 1)) (= Anon_16672 0)) (and (and (and (= Anon_16672 1) (<= 1 bhl_16673)) (<= 1 nl_16671)) (> l_16670 0)))))
(assert (= x_primed 1))
(assert (= v_node_599_2018_primed 2))
(assert (or (and (and (and (= Anon_17109 0) (<= 2 bhl_17110)) (<= 1 nl_17108)) (> l_17107 0)) (or (and (and (and (< l_17107 1) (= nl_17108 0)) (= bhl_17110 1)) (= Anon_17109 0)) (and (and (and (= Anon_17109 1) (<= 1 bhl_17110)) (<= 1 nl_17108)) (> l_17107 0)))))
(assert (or (and (and (and (= Anon_17113 0) (<= 2 bhr_17114)) (<= 1 nr_17112)) (> r_17111 0)) (or (and (and (and (< r_17111 1) (= nr_17112 0)) (= bhr_17114 1)) (= Anon_17113 0)) (and (and (and (= Anon_17113 1) (<= 1 bhr_17114)) (<= 1 nr_17112)) (> r_17111 0)))))
(assert (not (= x_primed v_node_599_2018_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)