(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_12_13881 () Int)
(declare-fun flted_12_13880 () Int)
(declare-fun flted_12_13879 () Int)
(declare-fun n () Int)
(declare-fun bh () Int)
(declare-fun x () Int)
(declare-fun cl () Int)
(declare-fun l_13883 () Int)
(declare-fun v_bool_310_3540_primed () Int)
(declare-fun bhr_13888 () Int)
(declare-fun nr_13887 () Int)
(declare-fun n_13921 () Int)
(declare-fun bh_13923 () Int)
(declare-fun cl_13922 () Int)
(declare-fun v_bool_314_3280_primed () Int)
(declare-fun bhl_13885 () Int)
(declare-fun nl_13884 () Int)
(declare-fun x_primed () Int)
(declare-fun r_13886 () Int)
(declare-fun res () Int)
(declare-fun v_13882 () Int)
(declare-fun x_14363 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= n_13921 0))
(assert (= bh_13923 1))
(assert (or (= nr_13887 0) (< r_13886 1)))
(assert (= flted_12_13881 1))
(assert (= flted_12_13880 0))
(assert (= flted_12_13879 0))
(assert (= cl 1))
(assert (= n (+ (+ nr_13887 1) nl_13884)))
(assert (= bhl_13885 bh))
(assert (= bhr_13888 bh))
(assert (= x_14363 x))
(assert (> x 0))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (< l_13883 1))
(assert (> v_bool_310_3540_primed 0))
(assert (= bhr_13888 1))
(assert (= nr_13887 0))
(assert (< r_13886 1))
(assert (= cl_13922 0))
(assert (<= 0 n_13921))
(assert (<= 1 bh_13923))
(assert (<= 0 cl_13922))
(assert (<= cl_13922 1))
(assert (not (> v_bool_314_3280_primed 0)))
(assert (= bhl_13885 1))
(assert (= nl_13884 0))
(assert (= x_primed r_13886))
(assert (= res v_13882))
(assert (= x_14363 1))
;Negation of Consequence
(assert (not false))
(check-sat)