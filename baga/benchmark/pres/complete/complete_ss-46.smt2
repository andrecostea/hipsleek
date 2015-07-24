(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_1783 () Int)
(declare-fun r_1669 () Int)
(declare-fun nmin2_1784 () Int)
(declare-fun res () Int)
(declare-fun v_int_62_1522_primed () Int)
(declare-fun nmin_1693 () Int)
(declare-fun nmin () Int)
(declare-fun nmin2_1670 () Int)
(declare-fun flted_26_1664 () Int)
(declare-fun n () Int)
(declare-fun flted_26_1665 () Int)
(declare-fun nmin1_1668 () Int)
(declare-fun v_int_62_1777 () Int)
(declare-fun n_1692 () Int)
(declare-fun l_1781 () Int)
(declare-fun n_1674 () Int)
(declare-fun nmin_1675 () Int)
(declare-fun l_1667 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_1783 r_1669))
(assert (or (and (and (<= 1 nmin_1693) (<= nmin_1693 n_1692)) (> r_1669 0)) (or (and (and (< r_1669 1) (= n_1692 0)) (= nmin_1693 0)) (and (and (<= 1 nmin_1693) (< nmin_1693 n_1692)) (> r_1669 0)))))
(assert (= nmin2_1784 nmin_1693))
(assert (= res v_int_62_1522_primed))
(assert (= v_int_62_1522_primed (+ 1 v_int_62_1777)))
(assert (<= nmin_1693 n_1692))
(assert (<= 0 nmin_1693))
(assert (<= nmin2_1670 flted_26_1664))
(assert (<= 0 nmin2_1670))
(assert (= nmin_1693 nmin2_1670))
(assert (= n_1692 flted_26_1664))
(assert (<= nmin1_1668 flted_26_1665))
(assert (<= 0 nmin1_1668))
(assert (exists ((min_1811 Int)) (and (= nmin (+ 1 min_1811)) (or (and (= min_1811 nmin1_1668) (< nmin1_1668 nmin2_1670)) (and (= min_1811 nmin2_1670) (>= nmin1_1668 nmin2_1670))))))
(assert (= (+ flted_26_1664 1) n))
(assert (= (+ flted_26_1665 1) n))
(assert (= n_1674 flted_26_1665))
(assert (= nmin_1675 nmin1_1668))
(assert (<= 0 nmin_1675))
(assert (<= nmin_1675 n_1674))
(assert (or (< n_1674 n_1692) (= v_int_62_1777 n_1674)))
(assert (or (<= n_1692 n_1674) (= v_int_62_1777 n_1692)))
(assert (= l_1781 l_1667))
(assert (or (and (and (<= 1 nmin_1675) (<= nmin_1675 n_1674)) (> l_1667 0)) (or (and (and (< l_1667 1) (= n_1674 0)) (= nmin_1675 0)) (and (and (<= 1 nmin_1675) (< nmin_1675 n_1674)) (> l_1667 0)))))
;Negation of Consequence
(assert (not (or (= n_1674 0) (or (= nmin_1675 0) (< l_1667 1)))))
(check-sat)