(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_6781 () Int)
(declare-fun nr_6780 () Int)
(declare-fun bhr_6782 () Int)
(declare-fun bhr_6948 () Int)
(declare-fun Anon_6947 () Int)
(declare-fun nr_6946 () Int)
(declare-fun bhl_6944 () Int)
(declare-fun Anon_6943 () Int)
(declare-fun nl_6942 () Int)
(declare-fun r_6945 () Int)
(declare-fun r_6229 () Int)
(declare-fun l_6941 () Int)
(declare-fun l_6226 () Int)
(declare-fun v_6940 () Int)
(declare-fun v_6225 () Int)
(declare-fun res () Int)
(declare-fun v_node_130_4726_primed () Int)
(declare-fun v_int_128_6758 () Int)
(declare-fun v_int_128_6757 () Int)
(declare-fun color_127_6236 () Int)
(declare-fun flted_12_6224 () Int)
(declare-fun flted_12_6223 () Int)
(declare-fun flted_12_6222 () Int)
(declare-fun flted_120_6234 () Int)
(declare-fun nc () Int)
(declare-fun nr_6230 () Int)
(declare-fun nl_6227 () Int)
(declare-fun bhl_6228 () Int)
(declare-fun bhr_6231 () Int)
(declare-fun a_primed () Int)
(declare-fun b_primed () Int)
(declare-fun c () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun h_6233 () Int)
(declare-fun v_int_127_6756 () Int)
(declare-fun v_6774 () Int)
(declare-fun v_int_130_6759 () Int)
(declare-fun l_6775 () Int)
(declare-fun r_6779 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_120_6235 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun Anon_18 () Int)
(declare-fun h_6232 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun tmp_6760 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_6781 0))
(assert (= nr_6780 (+ (+ nr_6946 1) nl_6942)))
(assert (= bhr_6782 (+ bhl_6944 1)))
(assert (= bhl_6944 bhr_6948))
(assert (= bhr_6948 bhr_6231))
(assert (= Anon_6947 flted_12_6222))
(assert (= nr_6946 nr_6230))
(assert (= bhl_6944 bhl_6228))
(assert (= Anon_6943 flted_12_6223))
(assert (= nl_6942 nl_6227))
(assert (= r_6945 r_6229))
(assert (= l_6941 l_6226))
(assert (= v_6940 v_6225))
(assert (= res v_node_130_4726_primed))
(assert (= v_int_130_6759 0))
(assert (= v_int_128_6758 0))
(assert (= v_int_128_6757 0))
(assert (= color_127_6236 flted_12_6224))
(assert (= flted_12_6224 1))
(assert (= flted_12_6223 0))
(assert (= flted_12_6222 0))
(assert (= flted_120_6234 1))
(assert (= nc (+ (+ nr_6230 1) nl_6227)))
(assert (= bhl_6228 h_6233))
(assert (= bhr_6231 h_6233))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= color_primed color))
(assert (= flted_120_6235 0))
(assert (= color 1))
(assert (= h_6232 h))
(assert (= h_6233 h))
(assert (= v_int_127_6756 0))
(assert (= v_6774 v_int_130_6759))
(assert (= l_6775 tmp_6760))
(assert (= r_6779 c_primed))
(assert (or (and (and (and (= flted_120_6235 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_120_6235 0)) (and (and (and (= flted_120_6235 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= Anon_18 0) (<= 2 h_6232)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h_6232 1)) (= Anon_18 0)) (and (and (and (= Anon_18 1) (<= 1 h_6232)) (<= 1 nb)) (> b 0)))))
(assert (= tmp_6760 1))
;Negation of Consequence
(assert (not false))
(check-sat)