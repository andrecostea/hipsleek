(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_409_2362_primed () Int)
(declare-fun left_409_2361_primed () Int)
(declare-fun color_409_2360_primed () Int)
(declare-fun val_409_2359_primed () Int)
(declare-fun bh_15404 () Int)
(declare-fun cl_15403 () Int)
(declare-fun Anon_14922 () Int)
(declare-fun n_15402 () Int)
(declare-fun v_14915 () Int)
(declare-fun x () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_395_3172_primed () Int)
(declare-fun bh () Int)
(declare-fun bhr_14923 () Int)
(declare-fun n () Int)
(declare-fun nr_14921 () Int)
(declare-fun cl () Int)
(declare-fun flted_13_14914 () Int)
(declare-fun v_bool_397_3171_primed () Int)
(declare-fun r_14920 () Int)
(declare-fun v_bool_399_2621_primed () Int)
(declare-fun Anon_14918 () Int)
(declare-fun bhl_14919 () Int)
(declare-fun nl_14917 () Int)
(declare-fun l_14916 () Int)
(declare-fun flted_299_15448 () Int)
(declare-fun bh2_15450 () Int)
(declare-fun flted_299_15449 () Int)
(declare-fun v_node_408_15451 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_409_2362_primed r_14920))
(assert (= left_409_2361_primed l_14916))
(assert (= color_409_2360_primed flted_13_14914))
(assert (= val_409_2359_primed v_14915))
(assert (<= cl_15403 1))
(assert (<= 0 cl_15403))
(assert (<= 1 bh_15404))
(assert (<= 0 n_15402))
(assert (= cl_15403 0))
(assert (<= bh2_15450 bh_15404))
(assert (<= bh_15404 (+ bh2_15450 1)))
(assert (= flted_299_15448 0))
(assert (= (+ flted_299_15449 1) n_15402))
(assert (<= Anon_14922 1))
(assert (<= 0 Anon_14922))
(assert (<= 1 bhr_14923))
(assert (<= 0 nr_14921))
(assert (= bh_15404 bhr_14923))
(assert (= cl_15403 Anon_14922))
(assert (= n_15402 nr_14921))
(assert (= a_primed v_14915))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (> x_primed 0))
(assert (> v_bool_395_3172_primed 0))
(assert (= bh (+ bhl_14919 1)))
(assert (= bhl_14919 bhr_14923))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= cl 0))
(assert (= flted_13_14914 0))
(assert (> v_bool_397_3171_primed 0))
(assert (> r_14920 0))
(assert (not (> v_bool_399_2621_primed 0)))
(assert (or (and (and (and (= Anon_14918 0) (<= 2 bhl_14919)) (<= 1 nl_14917)) (> l_14916 0)) (or (and (and (and (< l_14916 1) (= nl_14917 0)) (= bhl_14919 1)) (= Anon_14918 0)) (and (and (and (= Anon_14918 1) (<= 1 bhl_14919)) (<= 1 nl_14917)) (> l_14916 0)))))
(assert (or (and (and (and (= flted_299_15448 0) (<= 2 bh2_15450)) (<= 1 flted_299_15449)) (> v_node_408_15451 0)) (or (and (and (and (< v_node_408_15451 1) (= flted_299_15449 0)) (= bh2_15450 1)) (= flted_299_15448 0)) (and (and (and (= flted_299_15448 1) (<= 1 bh2_15450)) (<= 1 flted_299_15449)) (> v_node_408_15451 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)