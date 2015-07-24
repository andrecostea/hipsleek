(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhl_14041 () Int)
(declare-fun bhr_14044 () Int)
(declare-fun bh_13923 () Int)
(declare-fun bh () Int)
(declare-fun bhr_13899 () Int)
(declare-fun Anon_13894 () Int)
(declare-fun bhl_13895 () Int)
(declare-fun l_13892 () Int)
(declare-fun r_14722 () Int)
(declare-fun r_14042 () Int)
(declare-fun n () Int)
(declare-fun nl_13893 () Int)
(declare-fun nr_13897 () Int)
(declare-fun n_13921 () Int)
(declare-fun nr_14043 () Int)
(declare-fun nl_14040 () Int)
(declare-fun l_14039 () Int)
(declare-fun v_int_315_14049 () Int)
(declare-fun flted_299_14715 () Int)
(declare-fun flted_299_14716 () Int)
(declare-fun nr_14723 () Int)
(declare-fun bhr_14724 () Int)
(declare-fun bh2_14717 () Int)
(declare-fun flted_12_14742 () Int)
(declare-fun flted_12_14743 () Int)
(declare-fun bhl_14721 () Int)
(declare-fun nl_14720 () Int)
(declare-fun l_14719 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhl_14041 1))
(assert (= bhr_14044 1))
(assert (= bhl_14041 bh_13923))
(assert (= bhr_14044 bh_13923))
(assert (<= 1 bh_13923))
(assert (<= 1 bhr_13899))
(assert (= bh_13923 bhr_13899))
(assert (< l_13892 1))
(assert (= bh (+ bhl_13895 1)))
(assert (= bhl_13895 bhr_13899))
(assert (or (and (and (and (= Anon_13894 0) (<= 2 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)) (or (and (and (and (< l_13892 1) (= nl_13893 0)) (= bhl_13895 1)) (= Anon_13894 0)) (and (and (and (= Anon_13894 1) (<= 1 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)))))
(assert (< r_14042 1))
(assert (= nr_14043 0))
(assert (= r_14722 r_14042))
(assert (<= 0 nr_13897))
(assert (or (= nr_14043 0) (< r_14042 1)))
(assert (= nl_14040 0))
(assert (= n (+ (+ nr_13897 1) nl_13893)))
(assert (= n_13921 nr_13897))
(assert (<= 0 n_13921))
(assert (= n_13921 (+ (+ nr_14043 1) nl_14040)))
(assert (or (= nl_14040 0) (< l_14039 1)))
(assert (< l_14039 1))
(assert (= nr_14723 0))
(assert (= bhr_14724 1))
(assert (= v_int_315_14049 0))
(assert (= l_14719 l_14039))
(assert (= v_int_315_14049 1))
(assert (= flted_12_14743 0))
(assert (= flted_299_14715 1))
(assert (= flted_299_14716 (+ (+ nr_14723 1) nl_14720)))
(assert (= bhl_14721 bh2_14717))
(assert (= bhr_14724 bh2_14717))
(assert (= flted_12_14742 0))
(assert (or (and (and (and (= flted_12_14743 0) (<= 2 bhl_14721)) (<= 1 nl_14720)) (> l_14719 0)) (or (and (and (and (< l_14719 1) (= nl_14720 0)) (= bhl_14721 1)) (= flted_12_14743 0)) (and (and (and (= flted_12_14743 1) (<= 1 bhl_14721)) (<= 1 nl_14720)) (> l_14719 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)