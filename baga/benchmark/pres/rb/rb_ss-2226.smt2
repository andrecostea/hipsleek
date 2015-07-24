(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nl_14720 () Int)
(declare-fun r_14722 () Int)
(declare-fun r_14042 () Int)
(declare-fun nr_14043 () Int)
(declare-fun nl_14040 () Int)
(declare-fun n_13921 () Int)
(declare-fun n () Int)
(declare-fun nr_13897 () Int)
(declare-fun Anon_13894 () Int)
(declare-fun nl_13893 () Int)
(declare-fun l_13892 () Int)
(declare-fun bh () Int)
(declare-fun bhl_13895 () Int)
(declare-fun bhr_13899 () Int)
(declare-fun bhr_14044 () Int)
(declare-fun bh_13923 () Int)
(declare-fun bhl_14041 () Int)
(declare-fun bhl_14721 () Int)
(declare-fun bh2_14717 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nl_14720 nl_14040))
(assert (< r_14042 1))
(assert (= nr_14043 0))
(assert (= r_14722 r_14042))
(assert (or (= nr_14043 0) (< r_14042 1)))
(assert (= n_13921 (+ (+ nr_14043 1) nl_14040)))
(assert (<= 0 n_13921))
(assert (<= 1 bhr_13899))
(assert (<= 0 nr_13897))
(assert (= n_13921 nr_13897))
(assert (= n (+ (+ nr_13897 1) nl_13893)))
(assert (< l_13892 1))
(assert (or (and (and (and (= Anon_13894 0) (<= 2 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)) (or (and (and (and (< l_13892 1) (= nl_13893 0)) (= bhl_13895 1)) (= Anon_13894 0)) (and (and (and (= Anon_13894 1) (<= 1 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)))))
(assert (= bhr_14044 1))
(assert (= bh (+ bhl_13895 1)))
(assert (= bhl_13895 bhr_13899))
(assert (= bh_13923 bhr_13899))
(assert (<= 1 bh_13923))
(assert (= bhr_14044 bh_13923))
(assert (= bhl_14041 bh_13923))
(assert (= bhl_14721 bhl_14041))
;Negation of Consequence
(assert (not (= bhl_14721 bh2_14717)))
(check-sat)