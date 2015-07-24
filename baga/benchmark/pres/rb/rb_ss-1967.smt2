(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nr_13794 () Int)
(declare-fun nl_13791 () Int)
(declare-fun r_13793 () Int)
(declare-fun l_13790 () Int)
(declare-fun n () Int)
(declare-fun flted_12_13627 () Int)
(declare-fun nl_13631 () Int)
(declare-fun l_13630 () Int)
(declare-fun flted_12_13626 () Int)
(declare-fun nr_13634 () Int)
(declare-fun r_13633 () Int)
(declare-fun bhl_13792 () Int)
(declare-fun bhr_13795 () Int)
(declare-fun bhl_13632 () Int)
(declare-fun bhr_13635 () Int)
(declare-fun bh () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhl_13792 bhr_13795))
(assert (= nr_13794 nr_13634))
(assert (= nl_13791 nl_13631))
(assert (= r_13793 r_13633))
(assert (= l_13790 l_13630))
(assert (= flted_12_13627 0))
(assert (= flted_12_13626 0))
(assert (= n (+ (+ nr_13634 1) nl_13631)))
(assert (or (and (and (and (= flted_12_13627 0) (<= 2 bhl_13632)) (<= 1 nl_13631)) (> l_13630 0)) (or (and (and (and (< l_13630 1) (= nl_13631 0)) (= bhl_13632 1)) (= flted_12_13627 0)) (and (and (and (= flted_12_13627 1) (<= 1 bhl_13632)) (<= 1 nl_13631)) (> l_13630 0)))))
(assert (or (and (and (and (= flted_12_13626 0) (<= 2 bhr_13635)) (<= 1 nr_13634)) (> r_13633 0)) (or (and (and (and (< r_13633 1) (= nr_13634 0)) (= bhr_13635 1)) (= flted_12_13626 0)) (and (and (and (= flted_12_13626 1) (<= 1 bhr_13635)) (<= 1 nr_13634)) (> r_13633 0)))))
(assert (= bhl_13792 bhl_13632))
(assert (= bhr_13795 bhr_13635))
(assert (= bhl_13632 bh))
(assert (= bhr_13635 bh))
;Negation of Consequence
(assert (not (<= 1 bh)))
(check-sat)