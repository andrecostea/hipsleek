(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_14906 () Int)
(declare-fun x () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun v_bool_395_3172_primed () Int)
(declare-fun bh () Int)
(declare-fun n () Int)
(declare-fun cl () Int)
(declare-fun flted_12_14905 () Int)
(declare-fun v_bool_397_3171_primed () Int)
(declare-fun v_bool_399_2621_primed () Int)
(declare-fun x_primed () Int)
(declare-fun flted_12_14904 () Int)
(declare-fun bhl_14909 () Int)
(declare-fun nl_14908 () Int)
(declare-fun l_14907 () Int)
(declare-fun flted_12_14903 () Int)
(declare-fun bhr_14912 () Int)
(declare-fun nr_14911 () Int)
(declare-fun r_14910 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= a_primed v_14906))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (> x_primed 0))
(assert (> v_bool_395_3172_primed 0))
(assert (= bhr_14912 bh))
(assert (= bhl_14909 bh))
(assert (= n (+ (+ nr_14911 1) nl_14908)))
(assert (= cl 1))
(assert (= flted_12_14903 0))
(assert (= flted_12_14904 0))
(assert (= flted_12_14905 1))
(assert (> v_bool_397_3171_primed 0))
(assert (< r_14910 1))
(assert (> v_bool_399_2621_primed 0))
(assert (= x_primed 1))
(assert (or (and (and (and (= flted_12_14904 0) (<= 2 bhl_14909)) (<= 1 nl_14908)) (> l_14907 0)) (or (and (and (and (< l_14907 1) (= nl_14908 0)) (= bhl_14909 1)) (= flted_12_14904 0)) (and (and (and (= flted_12_14904 1) (<= 1 bhl_14909)) (<= 1 nl_14908)) (> l_14907 0)))))
(assert (or (and (and (and (= flted_12_14903 0) (<= 2 bhr_14912)) (<= 1 nr_14911)) (> r_14910 0)) (or (and (and (and (< r_14910 1) (= nr_14911 0)) (= bhr_14912 1)) (= flted_12_14903 0)) (and (and (and (= flted_12_14903 1) (<= 1 bhr_14912)) (<= 1 nr_14911)) (> r_14910 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)