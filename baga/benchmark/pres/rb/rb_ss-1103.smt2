(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_10196 () Int)
(declare-fun Anon_10195 () Int)
(declare-fun nr_10194 () Int)
(declare-fun bhl_10192 () Int)
(declare-fun Anon_10191 () Int)
(declare-fun nl_10190 () Int)
(declare-fun r_10193 () Int)
(declare-fun r_9859 () Int)
(declare-fun l_10189 () Int)
(declare-fun l_9856 () Int)
(declare-fun v_10188 () Int)
(declare-fun v_9855 () Int)
(declare-fun res () Int)
(declare-fun v_node_147_4593_primed () Int)
(declare-fun v_int_145_10144 () Int)
(declare-fun v_int_145_10143 () Int)
(declare-fun color_144_9881 () Int)
(declare-fun flted_12_9854 () Int)
(declare-fun flted_12_9853 () Int)
(declare-fun flted_12_9852 () Int)
(declare-fun flted_136_9865 () Int)
(declare-fun na () Int)
(declare-fun nr_9860 () Int)
(declare-fun nl_9857 () Int)
(declare-fun bhl_9858 () Int)
(declare-fun bhr_9861 () Int)
(declare-fun a () Int)
(declare-fun b_primed () Int)
(declare-fun c_primed () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun ha () Int)
(declare-fun v_int_144_10142 () Int)
(declare-fun v_10150 () Int)
(declare-fun v_int_147_10145 () Int)
(declare-fun l_10151 () Int)
(declare-fun a_primed () Int)
(declare-fun r_10154 () Int)
(declare-fun Anon_19 () Int)
(declare-fun ha_9862 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_136_9864 () Int)
(declare-fun ha_9863 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun tmp_10146 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_10196 bhr_9861))
(assert (= Anon_10195 flted_12_9852))
(assert (= nr_10194 nr_9860))
(assert (= bhl_10192 bhl_9858))
(assert (= Anon_10191 flted_12_9853))
(assert (= nl_10190 nl_9857))
(assert (= r_10193 r_9859))
(assert (= l_10189 l_9856))
(assert (= v_10188 v_9855))
(assert (= res v_node_147_4593_primed))
(assert (= v_int_147_10145 0))
(assert (= v_int_145_10144 0))
(assert (= v_int_145_10143 0))
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
(assert (= v_int_144_10142 0))
(assert (= v_10150 v_int_147_10145))
(assert (= l_10151 a_primed))
(assert (= r_10154 tmp_10146))
(assert (or (and (and (and (= Anon_19 0) (<= 2 ha_9862)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha_9862 1)) (= Anon_19 0)) (and (and (and (= Anon_19 1) (<= 1 ha_9862)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_136_9864 0) (<= 2 ha_9863)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha_9863 1)) (= flted_136_9864 0)) (and (and (and (= flted_136_9864 1) (<= 1 ha_9863)) (<= 1 nc)) (> c 0)))))
(assert (= tmp_10146 1))
;Negation of Consequence
(assert (not false))
(check-sat)