(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun x_15394 () Int)
(declare-fun x () Int)
(declare-fun Anon_14922 () Int)
(declare-fun r_14920 () Int)
(declare-fun x_primed () Int)
(declare-fun n () Int)
(declare-fun nr_14921 () Int)
(declare-fun bhr_14923 () Int)
(declare-fun nl_14917 () Int)
(declare-fun Anon_14918 () Int)
(declare-fun bhl_14919 () Int)
(declare-fun cl_14954 () Int)
(declare-fun n_14953 () Int)
(declare-fun l_14916 () Int)
(declare-fun bh_14955 () Int)
(declare-fun bh () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> x_15394 0))
(assert (<= Anon_14918 1))
(assert (<= 0 Anon_14918))
(assert (<= 0 nl_14917))
(assert (= x_15394 x))
(assert (< r_14920 1))
(assert (or (and (and (and (= Anon_14922 0) (<= 2 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)) (or (and (and (and (< r_14920 1) (= nr_14921 0)) (= bhr_14923 1)) (= Anon_14922 0)) (and (and (and (= Anon_14922 1) (<= 1 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)))))
(assert (= x_primed l_14916))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= bhl_14919 bhr_14923))
(assert (= n_14953 nl_14917))
(assert (= cl_14954 Anon_14918))
(assert (<= 1 bhl_14919))
(assert (= cl_14954 0))
(assert (<= 0 n_14953))
(assert (<= 0 cl_14954))
(assert (<= cl_14954 1))
(assert (<= 1 bh_14955))
(assert (= bh_14955 bhl_14919))
(assert (= bh (+ bhl_14919 1)))
(assert (or (and (and (and (= cl_14954 0) (<= 2 bh_14955)) (<= 1 n_14953)) (> l_14916 0)) (or (and (and (and (< l_14916 1) (= n_14953 0)) (= bh_14955 1)) (= cl_14954 0)) (and (and (and (= cl_14954 1) (<= 1 bh_14955)) (<= 1 n_14953)) (> l_14916 0)))))
;Negation of Consequence
(assert (not (= bh_14955 bh)))
(check-sat)