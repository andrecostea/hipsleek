(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bh () Int)
(declare-fun l_8139 () Int)
(declare-fun Anon_8062 () Int)
(declare-fun l_8060 () Int)
(declare-fun bhl_8063 () Int)
(declare-fun n () Int)
(declare-fun nl_8061 () Int)
(declare-fun r_8142 () Int)
(declare-fun Anon_8066 () Int)
(declare-fun bhr_8067 () Int)
(declare-fun nr_8065 () Int)
(declare-fun r_8064 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bh (+ bhl_8063 1)))
(assert (= l_8139 l_8060))
(assert (or (and (and (and (= Anon_8062 0) (<= 2 bhl_8063)) (<= 1 nl_8061)) (> l_8060 0)) (or (and (and (and (< l_8060 1) (= nl_8061 0)) (= bhl_8063 1)) (= Anon_8062 0)) (and (and (and (= Anon_8062 1) (<= 1 bhl_8063)) (<= 1 nl_8061)) (> l_8060 0)))))
(assert (= bhl_8063 bhr_8067))
(assert (= n (+ (+ nr_8065 1) nl_8061)))
(assert (= r_8142 r_8064))
(assert (or (and (and (and (= Anon_8066 0) (<= 2 bhr_8067)) (<= 1 nr_8065)) (> r_8064 0)) (or (and (and (and (< r_8064 1) (= nr_8065 0)) (= bhr_8067 1)) (= Anon_8066 0)) (and (and (and (= Anon_8066 1) (<= 1 bhr_8067)) (<= 1 nr_8065)) (> r_8064 0)))))
;Negation of Consequence
(assert (not (or (= nr_8065 0) (< r_8064 1))))
(check-sat)