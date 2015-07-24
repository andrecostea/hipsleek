(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nl_9902 () Int)
(declare-fun na () Int)
(declare-fun l_9939 () Int)
(declare-fun r_9943 () Int)
(declare-fun nl_9940 () Int)
(declare-fun Anon_9941 () Int)
(declare-fun nr_9944 () Int)
(declare-fun Anon_9945 () Int)
(declare-fun l_9963 () Int)
(declare-fun b_primed () Int)
(declare-fun nl_9964 () Int)
(declare-fun flted_12_9853 () Int)
(declare-fun nl_9857 () Int)
(declare-fun l_9856 () Int)
(declare-fun flted_12_9852 () Int)
(declare-fun nr_9860 () Int)
(declare-fun r_9859 () Int)
(declare-fun Anon_19 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun bhl_9965 () Int)
(declare-fun bhl_9903 () Int)
(declare-fun bhr_9946 () Int)
(declare-fun bhl_9942 () Int)
(declare-fun bhl_9858 () Int)
(declare-fun bhr_9861 () Int)
(declare-fun ha_9862 () Int)
(declare-fun ha () Int)
(declare-fun r_9966 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_136_9864 () Int)
(declare-fun ha_9863 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nl_9902 (+ (+ nr_9944 1) nl_9940)))
(assert (= b_primed b))
(assert (= na (+ (+ nr_9860 1) nl_9857)))
(assert (= flted_12_9852 0))
(assert (= flted_12_9853 0))
(assert (= l_9939 l_9856))
(assert (= r_9943 r_9859))
(assert (= nl_9940 nl_9857))
(assert (= Anon_9941 flted_12_9853))
(assert (= nr_9944 nr_9860))
(assert (= Anon_9945 flted_12_9852))
(assert (= l_9963 b_primed))
(assert (= nl_9964 nb))
(assert (or (and (and (and (= flted_12_9853 0) (<= 2 bhl_9858)) (<= 1 nl_9857)) (> l_9856 0)) (or (and (and (and (< l_9856 1) (= nl_9857 0)) (= bhl_9858 1)) (= flted_12_9853 0)) (and (and (and (= flted_12_9853 1) (<= 1 bhl_9858)) (<= 1 nl_9857)) (> l_9856 0)))))
(assert (or (and (and (and (= flted_12_9852 0) (<= 2 bhr_9861)) (<= 1 nr_9860)) (> r_9859 0)) (or (and (and (and (< r_9859 1) (= nr_9860 0)) (= bhr_9861 1)) (= flted_12_9852 0)) (and (and (and (= flted_12_9852 1) (<= 1 bhr_9861)) (<= 1 nr_9860)) (> r_9859 0)))))
(assert (or (and (and (and (= Anon_19 0) (<= 2 ha_9862)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha_9862 1)) (= Anon_19 0)) (and (and (and (= Anon_19 1) (<= 1 ha_9862)) (<= 1 nb)) (> b 0)))))
(assert (= bhl_9965 ha_9862))
(assert (= bhl_9903 (+ bhl_9942 1)))
(assert (= bhl_9942 bhr_9946))
(assert (= bhr_9946 bhr_9861))
(assert (= bhl_9942 bhl_9858))
(assert (= bhl_9858 ha))
(assert (= bhr_9861 ha))
(assert (= flted_136_9864 0))
(assert (= ha_9862 ha))
(assert (= ha_9863 ha))
(assert (= c_primed c))
(assert (= r_9966 c_primed))
(assert (or (and (and (and (= flted_136_9864 0) (<= 2 ha_9863)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha_9863 1)) (= flted_136_9864 0)) (and (and (and (= flted_136_9864 1) (<= 1 ha_9863)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not (or (= nc 0) (< c 1))))
(check-sat)