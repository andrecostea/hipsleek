(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_13_15341 () Int)
(declare-fun v_bool_401_2346_primed () Int)
(declare-fun cl_14954 () Int)
(declare-fun v_bool_399_2621_primed () Int)
(declare-fun v_bool_397_3171_primed () Int)
(declare-fun flted_12_14905 () Int)
(declare-fun flted_12_14904 () Int)
(declare-fun flted_12_14903 () Int)
(declare-fun n () Int)
(declare-fun nr_14911 () Int)
(declare-fun bhl_14909 () Int)
(declare-fun bhr_14912 () Int)
(declare-fun bh () Int)
(declare-fun v_bool_395_3172_primed () Int)
(declare-fun cl () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun a_primed () Int)
(declare-fun v_14906 () Int)
(declare-fun nl_14908 () Int)
(declare-fun l_14907 () Int)
(declare-fun bh_14955 () Int)
(declare-fun n_14953 () Int)
(declare-fun Anon_15345 () Int)
(declare-fun bhl_15346 () Int)
(declare-fun nl_15344 () Int)
(declare-fun l_15343 () Int)
(declare-fun Anon_15349 () Int)
(declare-fun bhr_15350 () Int)
(declare-fun nr_15348 () Int)
(declare-fun r_15347 () Int)
(declare-fun x_primed () Int)
(declare-fun r_14910 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_13_15341 0))
(assert (= nr_14911 (+ (+ nr_15348 1) nl_15344)))
(assert (= bhl_15346 bhr_15350))
(assert (= bhr_14912 (+ bhl_15346 1)))
(assert (not (> v_bool_401_2346_primed 0)))
(assert (<= cl_14954 1))
(assert (<= 0 cl_14954))
(assert (<= 1 bh_14955))
(assert (<= 0 n_14953))
(assert (= cl_14954 0))
(assert (< l_14907 1))
(assert (= nl_14908 0))
(assert (= bhl_14909 1))
(assert (> v_bool_399_2621_primed 0))
(assert (< r_14910 1))
(assert (> v_bool_397_3171_primed 0))
(assert (= flted_12_14905 1))
(assert (= flted_12_14904 0))
(assert (= flted_12_14903 0))
(assert (= cl 1))
(assert (= n (+ (+ nr_14911 1) nl_14908)))
(assert (= bhl_14909 bh))
(assert (= bhr_14912 bh))
(assert (> v_bool_395_3172_primed 0))
(assert (> x_primed 0))
(assert (<= cl 1))
(assert (<= 0 cl))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= a_primed v_14906))
(assert (or (= nl_14908 0) (< l_14907 1)))
(assert (= bh_14955 1))
(assert (= n_14953 0))
(assert (= x_primed 1))
(assert (= r_14910 2))
(assert (or (and (and (and (= Anon_15345 0) (<= 2 bhl_15346)) (<= 1 nl_15344)) (> l_15343 0)) (or (and (and (and (< l_15343 1) (= nl_15344 0)) (= bhl_15346 1)) (= Anon_15345 0)) (and (and (and (= Anon_15345 1) (<= 1 bhl_15346)) (<= 1 nl_15344)) (> l_15343 0)))))
(assert (or (and (and (and (= Anon_15349 0) (<= 2 bhr_15350)) (<= 1 nr_15348)) (> r_15347 0)) (or (and (and (and (< r_15347 1) (= nr_15348 0)) (= bhr_15350 1)) (= Anon_15349 0)) (and (and (and (= Anon_15349 1) (<= 1 bhr_15350)) (<= 1 nr_15348)) (> r_15347 0)))))
(assert (not (= x_primed r_14910)))
;Negation of Consequence
(assert (not false))
(check-sat)