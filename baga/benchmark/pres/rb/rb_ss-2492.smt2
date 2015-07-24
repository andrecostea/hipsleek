(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhl_15073 () Int)
(declare-fun bhr_15076 () Int)
(declare-fun bh_14955 () Int)
(declare-fun bh () Int)
(declare-fun bhl_14919 () Int)
(declare-fun Anon_14922 () Int)
(declare-fun bhr_14923 () Int)
(declare-fun r_14920 () Int)
(declare-fun r_16227 () Int)
(declare-fun r_15074 () Int)
(declare-fun n () Int)
(declare-fun nr_14921 () Int)
(declare-fun nl_14917 () Int)
(declare-fun n_14953 () Int)
(declare-fun nr_15075 () Int)
(declare-fun nl_15072 () Int)
(declare-fun l_15071 () Int)
(declare-fun v_int_402_15081 () Int)
(declare-fun cl2_16222 () Int)
(declare-fun flted_380_16221 () Int)
(declare-fun nr_16228 () Int)
(declare-fun bhr_16229 () Int)
(declare-fun bh_16220 () Int)
(declare-fun flted_12_16247 () Int)
(declare-fun flted_12_16248 () Int)
(declare-fun bhl_16226 () Int)
(declare-fun nl_16225 () Int)
(declare-fun l_16224 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhl_15073 1))
(assert (= bhr_15076 1))
(assert (= bhl_15073 bh_14955))
(assert (= bhr_15076 bh_14955))
(assert (<= 1 bh_14955))
(assert (<= 1 bhl_14919))
(assert (= bh_14955 bhl_14919))
(assert (= bh (+ bhl_14919 1)))
(assert (< r_14920 1))
(assert (= bhl_14919 bhr_14923))
(assert (or (and (and (and (= Anon_14922 0) (<= 2 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)) (or (and (and (and (< r_14920 1) (= nr_14921 0)) (= bhr_14923 1)) (= Anon_14922 0)) (and (and (and (= Anon_14922 1) (<= 1 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)))))
(assert (< r_15074 1))
(assert (= nr_15075 0))
(assert (= r_16227 r_15074))
(assert (<= 0 nl_14917))
(assert (or (= nr_15075 0) (< r_15074 1)))
(assert (= nl_15072 0))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= n_14953 nl_14917))
(assert (<= 0 n_14953))
(assert (= n_14953 (+ (+ nr_15075 1) nl_15072)))
(assert (or (= nl_15072 0) (< l_15071 1)))
(assert (< l_15071 1))
(assert (= nr_16228 0))
(assert (= bhr_16229 1))
(assert (= v_int_402_15081 0))
(assert (= l_16224 l_15071))
(assert (= v_int_402_15081 1))
(assert (= flted_12_16248 0))
(assert (= cl2_16222 1))
(assert (= flted_380_16221 (+ (+ nr_16228 1) nl_16225)))
(assert (= bhl_16226 bh_16220))
(assert (= bhr_16229 bh_16220))
(assert (= flted_12_16247 0))
(assert (or (and (and (and (= flted_12_16248 0) (<= 2 bhl_16226)) (<= 1 nl_16225)) (> l_16224 0)) (or (and (and (and (< l_16224 1) (= nl_16225 0)) (= bhl_16226 1)) (= flted_12_16248 0)) (and (and (and (= flted_12_16248 1) (<= 1 bhl_16226)) (<= 1 nl_16225)) (> l_16224 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)