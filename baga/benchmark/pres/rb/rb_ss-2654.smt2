(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhl_15073 () Int)
(declare-fun Anon_14922 () Int)
(declare-fun r_14920 () Int)
(declare-fun n () Int)
(declare-fun nr_14921 () Int)
(declare-fun bhr_14923 () Int)
(declare-fun bh () Int)
(declare-fun nl_14917 () Int)
(declare-fun bhl_14919 () Int)
(declare-fun bh_14955 () Int)
(declare-fun n_14953 () Int)
(declare-fun nl_15072 () Int)
(declare-fun bhr_15076 () Int)
(declare-fun nr_15075 () Int)
(declare-fun l_15071 () Int)
(declare-fun v_int_402_15081 () Int)
(declare-fun flted_381_16315 () Int)
(declare-fun flted_381_16316 () Int)
(declare-fun nr_16324 () Int)
(declare-fun bhr_16325 () Int)
(declare-fun bh2_16317 () Int)
(declare-fun flted_12_16344 () Int)
(declare-fun bhl_16322 () Int)
(declare-fun nl_16321 () Int)
(declare-fun l_16320 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhl_15073 1))
(assert (= bhl_15073 bh_14955))
(assert (<= 1 bhl_14919))
(assert (<= 0 nl_14917))
(assert (< r_14920 1))
(assert (or (and (and (and (= Anon_14922 0) (<= 2 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)) (or (and (and (and (< r_14920 1) (= nr_14921 0)) (= bhr_14923 1)) (= Anon_14922 0)) (and (and (and (= Anon_14922 1) (<= 1 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)))))
(assert (< l_15071 1))
(assert (= nl_15072 0))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= bhl_14919 bhr_14923))
(assert (= bh (+ bhl_14919 1)))
(assert (= n_14953 nl_14917))
(assert (= bh_14955 bhl_14919))
(assert (<= 0 n_14953))
(assert (<= 1 bh_14955))
(assert (= bhr_15076 bh_14955))
(assert (= n_14953 (+ (+ nr_15075 1) nl_15072)))
(assert (or (= nl_15072 0) (< l_15071 1)))
(assert (= bhr_16325 bhr_15076))
(assert (= nr_16324 nr_15075))
(assert (= l_16320 l_15071))
(assert (= v_int_402_15081 0))
(assert (= v_int_402_15081 1))
(assert (= flted_12_16344 0))
(assert (= flted_381_16315 1))
(assert (= flted_381_16316 (+ (+ nr_16324 1) nl_16321)))
(assert (= bhl_16322 bh2_16317))
(assert (= bhr_16325 bh2_16317))
(assert (or (and (and (and (= flted_12_16344 0) (<= 2 bhl_16322)) (<= 1 nl_16321)) (> l_16320 0)) (or (and (and (and (< l_16320 1) (= nl_16321 0)) (= bhl_16322 1)) (= flted_12_16344 0)) (and (and (and (= flted_12_16344 1) (<= 1 bhl_16322)) (<= 1 nl_16321)) (> l_16320 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)