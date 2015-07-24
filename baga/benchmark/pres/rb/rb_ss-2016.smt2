(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_310_3540_primed () Int)
(declare-fun x () Int)
(declare-fun bh () Int)
(declare-fun n () Int)
(declare-fun cl () Int)
(declare-fun flted_13_13890 () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_13891 () Int)
(declare-fun nr_13897 () Int)
(declare-fun bhr_13899 () Int)
(declare-fun Anon_13898 () Int)
(declare-fun v_bool_314_3280_primed () Int)
(declare-fun x_primed () Int)
(declare-fun Anon_13894 () Int)
(declare-fun bhl_13895 () Int)
(declare-fun nl_13893 () Int)
(declare-fun l_13892 () Int)
(declare-fun cl_13922 () Int)
(declare-fun bh_13923 () Int)
(declare-fun n_13921 () Int)
(declare-fun r_13896 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_310_3540_primed 0))
(assert (< l_13892 1))
(assert (<= cl 1))
(assert (<= 0 cl))
(assert (> x 0))
(assert (= x_primed x))
(assert (= bh (+ bhl_13895 1)))
(assert (= bhl_13895 bhr_13899))
(assert (= n (+ (+ nr_13897 1) nl_13893)))
(assert (= cl 0))
(assert (= flted_13_13890 0))
(assert (= tmp_primed v_13891))
(assert (= n_13921 nr_13897))
(assert (= cl_13922 Anon_13898))
(assert (= bh_13923 bhr_13899))
(assert (<= 0 nr_13897))
(assert (<= 1 bhr_13899))
(assert (<= 0 Anon_13898))
(assert (<= Anon_13898 1))
(assert (= cl_13922 1))
(assert (> v_bool_314_3280_primed 0))
(assert (<= 0 n_13921))
(assert (<= 1 bh_13923))
(assert (<= 0 cl_13922))
(assert (<= cl_13922 1))
(assert (not (> v_bool_314_3280_primed 0)))
(assert (= x_primed 1))
(assert (or (and (and (and (= Anon_13894 0) (<= 2 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)) (or (and (and (and (< l_13892 1) (= nl_13893 0)) (= bhl_13895 1)) (= Anon_13894 0)) (and (and (and (= Anon_13894 1) (<= 1 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)))))
(assert (or (and (and (and (= cl_13922 0) (<= 2 bh_13923)) (<= 1 n_13921)) (> r_13896 0)) (or (and (and (and (< r_13896 1) (= n_13921 0)) (= bh_13923 1)) (= cl_13922 0)) (and (and (and (= cl_13922 1) (<= 1 bh_13923)) (<= 1 n_13921)) (> r_13896 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)