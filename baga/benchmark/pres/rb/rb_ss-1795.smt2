(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhl_11897 () Int)
(declare-fun bhr_11900 () Int)
(declare-fun bh_11775 () Int)
(declare-fun n_11773 () Int)
(declare-fun nb () Int)
(declare-fun nr_11749 () Int)
(declare-fun nl_11745 () Int)
(declare-fun n () Int)
(declare-fun nl_11896 () Int)
(declare-fun nr_11899 () Int)
(declare-fun nc () Int)
(declare-fun r_12666 () Int)
(declare-fun flted_171_12654 () Int)
(declare-fun flted_171_12653 () Int)
(declare-fun tmp_12658 () Int)
(declare-fun na_11912 () Int)
(declare-fun nb_11913 () Int)
(declare-fun nc_11914 () Int)
(declare-fun nd () Int)
(declare-fun flted_171_12655 () Int)
(declare-fun h_11915 () Int)
(declare-fun bh () Int)
(declare-fun bhr_11751 () Int)
(declare-fun bhl_11747 () Int)
(declare-fun flted_262_11753 () Int)
(declare-fun h () Int)
(declare-fun l_12663 () Int)
(declare-fun a_primed () Int)
(declare-fun flted_262_11756 () Int)
(declare-fun flted_262_11755 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n))
(assert (<= 1 bhl_11897))
(assert (<= 0 nl_11896))
(assert (<= 1 bhr_11900))
(assert (<= 0 nr_11899))
(assert (<= 0 nc))
(assert (<= 0 nl_11745))
(assert (= n_11773 (+ (+ nr_11899 1) nl_11896)))
(assert (= bhl_11897 bh_11775))
(assert (= bhr_11900 bh_11775))
(assert (<= 1 bh_11775))
(assert (<= 0 n_11773))
(assert (<= 1 bhr_11751))
(assert (<= 0 nr_11749))
(assert (= bh_11775 bhr_11751))
(assert (= n_11773 nr_11749))
(assert (= nb (+ (+ nr_11749 1) nl_11745)))
(assert (= n nl_11745))
(assert (= na_11912 n))
(assert (= nb_11913 nl_11896))
(assert (= nc_11914 nr_11899))
(assert (= nd nc))
(assert (= flted_171_12653 (+ (+ (+ (+ 3 nc_11914) na_11912) nb_11913) nd)))
(assert (= flted_171_12654 1))
(assert (= r_12666 tmp_12658))
(assert (or (and (and (and (= flted_171_12654 0) (<= 2 flted_171_12655)) (<= 1 flted_171_12653)) (> tmp_12658 0)) (or (and (and (and (< tmp_12658 1) (= flted_171_12653 0)) (= flted_171_12655 1)) (= flted_171_12654 0)) (and (and (and (= flted_171_12654 1) (<= 1 flted_171_12655)) (<= 1 flted_171_12653)) (> tmp_12658 0)))))
(assert (or (and (and (and (and (and (and (and (and (and (and (and (exists ((flted_168_12745 Int)) (and (<= 0 flted_168_12745) (<= flted_168_12745 1))) (exists ((flted_168_12744 Int)) (and (<= 0 flted_168_12744) (<= flted_168_12744 1)))) (exists ((flted_168_12743 Int)) (and (<= 0 flted_168_12743) (<= flted_168_12743 1)))) (exists ((flted_168_12742 Int)) (and (<= 0 flted_168_12742) (<= flted_168_12742 1)))) (exists ((h_12741 Int)) (<= 1 h_12741))) (exists ((h_12740 Int)) (<= 1 h_12740))) (exists ((h_12739 Int)) (<= 1 h_12739))) (<= 0 na_11912)) (<= 1 h_11915)) (<= 0 nb_11913)) (<= 0 nc_11914)) (<= 0 nd)) (and (and (and (and (and (and (and (and (and (and (and (exists ((flted_169_12738 Int)) (and (<= 0 flted_169_12738) (<= flted_169_12738 1))) (exists ((flted_169_12737 Int)) (and (<= 0 flted_169_12737) (<= flted_169_12737 1)))) (exists ((flted_169_12736 Int)) (and (<= 0 flted_169_12736) (<= flted_169_12736 1)))) (exists ((flted_169_12735 Int)) (and (<= 0 flted_169_12735) (<= flted_169_12735 1)))) (exists ((h_12734 Int)) (<= 1 h_12734))) (exists ((h_12733 Int)) (<= 1 h_12733))) (exists ((h_12732 Int)) (<= 1 h_12732))) (<= 0 na_11912)) (<= 1 h_11915)) (<= 0 nb_11913)) (<= 0 nc_11914)) (<= 0 nd))))
(assert (= flted_171_12655 (+ 1 h_11915)))
(assert (<= 1 bh))
(assert (= h_11915 bh))
(assert (<= 1 bhl_11747))
(assert (= bh bhl_11747))
(assert (= bhl_11747 bhr_11751))
(assert (= flted_262_11753 (+ bhl_11747 1)))
(assert (= flted_262_11753 (+ 1 h)))
(assert (<= 1 h))
(assert (= flted_262_11756 0))
(assert (= flted_262_11755 (+ 1 h)))
(assert (= a_primed a))
(assert (= l_12663 a_primed))
(assert (or (and (and (and (= flted_262_11756 0) (<= 2 flted_262_11755)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= flted_262_11755 1)) (= flted_262_11756 0)) (and (and (and (= flted_262_11756 1) (<= 1 flted_262_11755)) (<= 1 na)) (> a 0)))))
;Negation of Consequence
(assert (not (or (= na 0) (< a 1))))
(check-sat)