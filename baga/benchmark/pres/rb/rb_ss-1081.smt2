(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nl_9912 () Int)
(declare-fun na () Int)
(declare-fun l_10077 () Int)
(declare-fun r_10081 () Int)
(declare-fun nl_10078 () Int)
(declare-fun Anon_10079 () Int)
(declare-fun nr_10082 () Int)
(declare-fun Anon_10083 () Int)
(declare-fun l_10101 () Int)
(declare-fun b_primed () Int)
(declare-fun flted_12_9853 () Int)
(declare-fun nl_9857 () Int)
(declare-fun l_9856 () Int)
(declare-fun flted_12_9852 () Int)
(declare-fun nr_9860 () Int)
(declare-fun r_9859 () Int)
(declare-fun Anon_19 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun bhl_9914 () Int)
(declare-fun bhr_10084 () Int)
(declare-fun bhl_10080 () Int)
(declare-fun bhl_9858 () Int)
(declare-fun bhr_9861 () Int)
(declare-fun ha_9862 () Int)
(declare-fun ha () Int)
(declare-fun r_10104 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_136_9864 () Int)
(declare-fun ha_9863 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nl_9912 (+ (+ nr_10082 1) nl_10078)))
(assert (= b_primed b))
(assert (= na (+ (+ nr_9860 1) nl_9857)))
(assert (= flted_12_9852 0))
(assert (= flted_12_9853 0))
(assert (= l_10077 l_9856))
(assert (= r_10081 r_9859))
(assert (= nl_10078 nl_9857))
(assert (= Anon_10079 flted_12_9853))
(assert (= nr_10082 nr_9860))
(assert (= Anon_10083 flted_12_9852))
(assert (= l_10101 b_primed))
(assert (or (and (and (and (= flted_12_9853 0) (<= 2 bhl_9858)) (<= 1 nl_9857)) (> l_9856 0)) (or (and (and (and (< l_9856 1) (= nl_9857 0)) (= bhl_9858 1)) (= flted_12_9853 0)) (and (and (and (= flted_12_9853 1) (<= 1 bhl_9858)) (<= 1 nl_9857)) (> l_9856 0)))))
(assert (or (and (and (and (= flted_12_9852 0) (<= 2 bhr_9861)) (<= 1 nr_9860)) (> r_9859 0)) (or (and (and (and (< r_9859 1) (= nr_9860 0)) (= bhr_9861 1)) (= flted_12_9852 0)) (and (and (and (= flted_12_9852 1) (<= 1 bhr_9861)) (<= 1 nr_9860)) (> r_9859 0)))))
(assert (or (and (and (and (= Anon_19 0) (<= 2 ha_9862)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha_9862 1)) (= Anon_19 0)) (and (and (and (= Anon_19 1) (<= 1 ha_9862)) (<= 1 nb)) (> b 0)))))
(assert (= bhl_9914 (+ bhl_10080 1)))
(assert (= bhl_10080 bhr_10084))
(assert (= bhr_10084 bhr_9861))
(assert (= bhl_10080 bhl_9858))
(assert (= bhl_9858 ha))
(assert (= bhr_9861 ha))
(assert (= flted_136_9864 0))
(assert (= ha_9862 ha))
(assert (= ha_9863 ha))
(assert (= c_primed c))
(assert (= r_10104 c_primed))
(assert (or (and (and (and (= flted_136_9864 0) (<= 2 ha_9863)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha_9863 1)) (= flted_136_9864 0)) (and (and (and (= flted_136_9864 1) (<= 1 ha_9863)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not (or (= nc 0) (< c 1))))
(check-sat)