(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun v_node_147_4593_primed () Int)
(declare-fun v_int_145_10402 () Int)
(declare-fun v_int_145_10401 () Int)
(declare-fun color_144_9880 () Int)
(declare-fun flted_12_9868 () Int)
(declare-fun flted_137_9879 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun b_primed () Int)
(declare-fun c_primed () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun ha () Int)
(declare-fun v_int_144_10400 () Int)
(declare-fun v_10418 () Int)
(declare-fun v_int_147_10403 () Int)
(declare-fun l_10419 () Int)
(declare-fun r_10423 () Int)
(declare-fun flted_12_9867 () Int)
(declare-fun bhl_9872 () Int)
(declare-fun nl_9871 () Int)
(declare-fun l_9870 () Int)
(declare-fun flted_12_9866 () Int)
(declare-fun bhr_9875 () Int)
(declare-fun nr_9874 () Int)
(declare-fun r_9873 () Int)
(declare-fun Anon_20 () Int)
(declare-fun ha_9876 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_137_9878 () Int)
(declare-fun ha_9877 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun a_primed () Int)
(declare-fun tmp_10404 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res v_node_147_4593_primed))
(assert (= v_int_147_10403 0))
(assert (= v_int_145_10402 0))
(assert (= v_int_145_10401 0))
(assert (= color_144_9880 flted_12_9868))
(assert (= flted_12_9868 1))
(assert (= flted_12_9867 0))
(assert (= flted_12_9866 0))
(assert (= flted_137_9879 1))
(assert (= na (+ (+ nr_9874 1) nl_9871)))
(assert (= bhl_9872 ha))
(assert (= bhr_9875 ha))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= color_primed color))
(assert (= flted_137_9878 0))
(assert (= color 1))
(assert (= ha_9876 ha))
(assert (= ha_9877 ha))
(assert (= v_int_144_10400 0))
(assert (= v_10418 v_int_147_10403))
(assert (= l_10419 a_primed))
(assert (= r_10423 tmp_10404))
(assert (or (and (and (and (= flted_12_9867 0) (<= 2 bhl_9872)) (<= 1 nl_9871)) (> l_9870 0)) (or (and (and (and (< l_9870 1) (= nl_9871 0)) (= bhl_9872 1)) (= flted_12_9867 0)) (and (and (and (= flted_12_9867 1) (<= 1 bhl_9872)) (<= 1 nl_9871)) (> l_9870 0)))))
(assert (or (and (and (and (= flted_12_9866 0) (<= 2 bhr_9875)) (<= 1 nr_9874)) (> r_9873 0)) (or (and (and (and (< r_9873 1) (= nr_9874 0)) (= bhr_9875 1)) (= flted_12_9866 0)) (and (and (and (= flted_12_9866 1) (<= 1 bhr_9875)) (<= 1 nr_9874)) (> r_9873 0)))))
(assert (or (and (and (and (= Anon_20 0) (<= 2 ha_9876)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha_9876 1)) (= Anon_20 0)) (and (and (and (= Anon_20 1) (<= 1 ha_9876)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_137_9878 0) (<= 2 ha_9877)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha_9877 1)) (= flted_137_9878 0)) (and (and (and (= flted_137_9878 1) (<= 1 ha_9877)) (<= 1 nc)) (> c 0)))))
(assert (= a_primed 1))
(assert (= tmp_10404 2))
(assert (not (= a_primed tmp_10404)))
;Negation of Consequence
(assert (not false))
(check-sat)