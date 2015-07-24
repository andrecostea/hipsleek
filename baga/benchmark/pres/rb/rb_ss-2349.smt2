(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_399_2621_primed () Int)
(declare-fun v_bool_397_3171_primed () Int)
(declare-fun flted_13_14914 () Int)
(declare-fun n () Int)
(declare-fun bh () Int)
(declare-fun v_bool_395_3172_primed () Int)
(declare-fun cl () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun a_primed () Int)
(declare-fun v_14915 () Int)
(declare-fun nl_14917 () Int)
(declare-fun bhl_14919 () Int)
(declare-fun Anon_14918 () Int)
(declare-fun v_bool_401_2346_primed () Int)
(declare-fun x_primed () Int)
(declare-fun Anon_14922 () Int)
(declare-fun bhr_14923 () Int)
(declare-fun nr_14921 () Int)
(declare-fun r_14920 () Int)
(declare-fun cl_14954 () Int)
(declare-fun bh_14955 () Int)
(declare-fun n_14953 () Int)
(declare-fun l_14916 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_399_2621_primed 0))
(assert (< r_14920 1))
(assert (> v_bool_397_3171_primed 0))
(assert (= flted_13_14914 0))
(assert (= cl 0))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= bhl_14919 bhr_14923))
(assert (= bh (+ bhl_14919 1)))
(assert (> v_bool_395_3172_primed 0))
(assert (> x_primed 0))
(assert (<= cl 1))
(assert (<= 0 cl))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= a_primed v_14915))
(assert (= n_14953 nl_14917))
(assert (= cl_14954 Anon_14918))
(assert (= bh_14955 bhl_14919))
(assert (<= 0 nl_14917))
(assert (<= 1 bhl_14919))
(assert (<= 0 Anon_14918))
(assert (<= Anon_14918 1))
(assert (= cl_14954 0))
(assert (not (> v_bool_401_2346_primed 0)))
(assert (<= 0 n_14953))
(assert (<= 1 bh_14955))
(assert (<= 0 cl_14954))
(assert (<= cl_14954 1))
(assert (> v_bool_401_2346_primed 0))
(assert (= x_primed 1))
(assert (or (and (and (and (= Anon_14922 0) (<= 2 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)) (or (and (and (and (< r_14920 1) (= nr_14921 0)) (= bhr_14923 1)) (= Anon_14922 0)) (and (and (and (= Anon_14922 1) (<= 1 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)))))
(assert (or (and (and (and (= cl_14954 0) (<= 2 bh_14955)) (<= 1 n_14953)) (> l_14916 0)) (or (and (and (and (< l_14916 1) (= n_14953 0)) (= bh_14955 1)) (= cl_14954 0)) (and (and (and (= cl_14954 1) (<= 1 bh_14955)) (<= 1 n_14953)) (> l_14916 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)