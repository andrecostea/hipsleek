(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun next_58_1442_primed () Int)
(declare-fun val_58_1441_primed () Int)
(declare-fun q_1634 () Int)
(declare-fun b2 () Int)
(declare-fun s2_1646 () Int)
(declare-fun m_1645 () Int)
(declare-fun m () Int)
(declare-fun b0_1644 () Int)
(declare-fun nn_1642 () Int)
(declare-fun x () Int)
(declare-fun y_primed () Int)
(declare-fun y () Int)
(declare-fun s2 () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_55_1443_primed () Int)
(declare-fun lg_1632 () Int)
(declare-fun b0 () Int)
(declare-fun sm_1631 () Int)
(declare-fun s0 () Int)
(declare-fun qs_1635 () Int)
(declare-fun flted_14_1633 () Int)
(declare-fun nn () Int)
(declare-fun s0_1643 () Int)
(declare-fun b2_1647 () Int)
(declare-fun flted_51_1663 () Int)
(declare-fun xn_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= next_58_1442_primed q_1634))
(assert (= val_58_1441_primed sm_1631))
(assert (> y_primed 0))
(assert (<= s2_1646 b2_1647))
(assert (<= 1 m_1645))
(assert (> q_1634 0))
(assert (<= s0_1643 b0_1644))
(assert (<= 1 nn_1642))
(assert (= flted_51_1663 (+ m_1645 nn_1642)))
(assert (<= qs_1635 lg_1632))
(assert (<= 1 flted_14_1633))
(assert (> y 0))
(assert (<= s2 b2))
(assert (<= 1 m))
(assert (= b2_1647 b2))
(assert (= s2_1646 s2))
(assert (= m_1645 m))
(assert (= b0_1644 lg_1632))
(assert (= s0_1643 qs_1635))
(assert (= nn_1642 flted_14_1633))
(assert (= x_primed x))
(assert (= y_primed y))
(assert (<= b0 s2))
(assert (> x_primed 0))
(assert (not (> v_bool_55_1443_primed 0)))
(assert (= lg_1632 b0))
(assert (= sm_1631 s0))
(assert (<= s0 qs_1635))
(assert (= (+ flted_14_1633 1) nn))
(assert (or (and (and (= b2_1647 s0_1643) (= flted_51_1663 1)) (> xn_primed 0)) (and (and (<= s0_1643 b2_1647) (<= 2 flted_51_1663)) (> xn_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)