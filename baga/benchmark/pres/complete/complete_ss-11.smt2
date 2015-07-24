(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_62_1517_primed () Int)
(declare-fun v_int_62_1518_primed () Int)
(declare-fun t () Int)
(declare-fun v_bool_61_1524_primed () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_1668 () Int)
(declare-fun nmin2_1670 () Int)
(declare-fun flted_26_1664 () Int)
(declare-fun flted_26_1665 () Int)
(declare-fun n () Int)
(declare-fun t_primed () Int)
(declare-fun nmin_1675 () Int)
(declare-fun n_1674 () Int)
(declare-fun l_1667 () Int)
(declare-fun nmin_1693 () Int)
(declare-fun n_1692 () Int)
(declare-fun r_1669 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= nmin_1693 n_1692))
(assert (<= 0 nmin_1693))
(assert (= v_int_62_1517_primed n_1692))
(assert (<= nmin2_1670 flted_26_1664))
(assert (<= 0 nmin2_1670))
(assert (= nmin_1693 nmin2_1670))
(assert (= n_1692 flted_26_1664))
(assert (<= nmin_1675 n_1674))
(assert (<= 0 nmin_1675))
(assert (= v_int_62_1518_primed n_1674))
(assert (<= nmin1_1668 flted_26_1665))
(assert (<= 0 nmin1_1668))
(assert (= nmin_1675 nmin1_1668))
(assert (= n_1674 flted_26_1665))
(assert (= t_primed t))
(assert (> t_primed 0))
(assert (> v_bool_61_1524_primed 0))
(assert (exists ((min_32 Int)) (and (= nmin (+ 1 min_32)) (or (and (= min_32 nmin1_1668) (< nmin1_1668 nmin2_1670)) (and (= min_32 nmin2_1670) (>= nmin1_1668 nmin2_1670))))))
(assert (= (+ flted_26_1664 1) n))
(assert (= (+ flted_26_1665 1) n))
(assert (= t_primed 1))
(assert (or (and (and (<= 1 nmin_1675) (<= nmin_1675 n_1674)) (> l_1667 0)) (or (and (and (< l_1667 1) (= n_1674 0)) (= nmin_1675 0)) (and (and (<= 1 nmin_1675) (< nmin_1675 n_1674)) (> l_1667 0)))))
(assert (or (and (and (<= 1 nmin_1693) (<= nmin_1693 n_1692)) (> r_1669 0)) (or (and (and (< r_1669 1) (= n_1692 0)) (= nmin_1693 0)) (and (and (<= 1 nmin_1693) (< nmin_1693 n_1692)) (> r_1669 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)