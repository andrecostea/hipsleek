(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nr_9905 () Int)
(declare-fun bhr_9906 () Int)
(declare-fun bhr_10014 () Int)
(declare-fun Anon_10013 () Int)
(declare-fun nr_10012 () Int)
(declare-fun nc () Int)
(declare-fun bhl_10010 () Int)
(declare-fun Anon_10009 () Int)
(declare-fun Anon_19 () Int)
(declare-fun nl_10008 () Int)
(declare-fun nb () Int)
(declare-fun r_10011 () Int)
(declare-fun l_10007 () Int)
(declare-fun v_10006 () Int)
(declare-fun res () Int)
(declare-fun v_node_147_4593_primed () Int)
(declare-fun v_int_145_9894 () Int)
(declare-fun v_int_145_9893 () Int)
(declare-fun color_144_9881 () Int)
(declare-fun flted_12_9854 () Int)
(declare-fun flted_136_9865 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun color_primed () Int)
(declare-fun flted_136_9864 () Int)
(declare-fun color () Int)
(declare-fun ha_9862 () Int)
(declare-fun ha_9863 () Int)
(declare-fun ha () Int)
(declare-fun v_int_144_9892 () Int)
(declare-fun v_9900 () Int)
(declare-fun v_int_147_9895 () Int)
(declare-fun l_9901 () Int)
(declare-fun r_9904 () Int)
(declare-fun tmp_9896 () Int)
(declare-fun flted_12_9853 () Int)
(declare-fun bhl_9858 () Int)
(declare-fun nl_9857 () Int)
(declare-fun l_9856 () Int)
(declare-fun flted_12_9852 () Int)
(declare-fun bhr_9861 () Int)
(declare-fun nr_9860 () Int)
(declare-fun r_9859 () Int)
(declare-fun a_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nr_9905 (+ (+ nr_10012 1) nl_10008)))
(assert (= bhr_9906 (+ bhl_10010 1)))
(assert (= bhl_10010 bhr_10014))
(assert (= bhr_10014 ha_9863))
(assert (= Anon_10013 flted_136_9864))
(assert (= nr_10012 nc))
(assert (= bhl_10010 ha_9862))
(assert (= Anon_10009 Anon_19))
(assert (= nl_10008 nb))
(assert (= r_10011 c_primed))
(assert (= l_10007 b_primed))
(assert (= v_10006 v_int_145_9893))
(assert (= res v_node_147_4593_primed))
(assert (= v_int_147_9895 0))
(assert (= v_int_145_9894 0))
(assert (= v_int_145_9893 0))
(assert (= color_144_9881 flted_12_9854))
(assert (= flted_12_9854 1))
(assert (= flted_12_9853 0))
(assert (= flted_12_9852 0))
(assert (= flted_136_9865 1))
(assert (= na (+ (+ nr_9860 1) nl_9857)))
(assert (= bhl_9858 ha))
(assert (= bhr_9861 ha))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= color_primed color))
(assert (= flted_136_9864 0))
(assert (= color 0))
(assert (= ha_9862 ha))
(assert (= ha_9863 ha))
(assert (= v_int_144_9892 0))
(assert (= v_9900 v_int_147_9895))
(assert (= l_9901 a_primed))
(assert (= r_9904 tmp_9896))
(assert (or (and (and (and (= flted_12_9853 0) (<= 2 bhl_9858)) (<= 1 nl_9857)) (> l_9856 0)) (or (and (and (and (< l_9856 1) (= nl_9857 0)) (= bhl_9858 1)) (= flted_12_9853 0)) (and (and (and (= flted_12_9853 1) (<= 1 bhl_9858)) (<= 1 nl_9857)) (> l_9856 0)))))
(assert (or (and (and (and (= flted_12_9852 0) (<= 2 bhr_9861)) (<= 1 nr_9860)) (> r_9859 0)) (or (and (and (and (< r_9859 1) (= nr_9860 0)) (= bhr_9861 1)) (= flted_12_9852 0)) (and (and (and (= flted_12_9852 1) (<= 1 bhr_9861)) (<= 1 nr_9860)) (> r_9859 0)))))
(assert (= a_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)