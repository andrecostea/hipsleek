(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_1499 () Int)
(declare-fun tmp_primed () Int)
(declare-fun flted_19_1498 () Int)
(declare-fun xs () Int)
(declare-fun n () Int)
(declare-fun v_bool_62_1389_primed () Int)
(declare-fun l_1526 () Int)
(declare-fun sm_1578 () Int)
(declare-fun s_1525 () Int)
(declare-fun n_1512 () Int)
(declare-fun xv_primed () Int)
(declare-fun xnv_primed () Int)
(declare-fun v_bool_69_1380_primed () Int)
(declare-fun qs_1582 () Int)
(declare-fun lg_1579 () Int)
(declare-fun flted_10_1580 () Int)
(declare-fun xs_primed () Int)
(declare-fun r_1500 () Int)
(declare-fun q_1581 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= xnv_primed sm_1578))
(assert (= xv_primed Anon_1499))
(assert (<= 0 n_1512))
(assert (not (> tmp_primed 0)))
(assert (<= 0 flted_19_1498))
(assert (= n_1512 flted_19_1498))
(assert (= (+ flted_19_1498 1) n))
(assert (= xs_primed xs))
(assert (< 0 n))
(assert (> r_1500 0))
(assert (not (> v_bool_62_1389_primed 0)))
(assert (= lg_1579 l_1526))
(assert (= sm_1578 s_1525))
(assert (<= s_1525 qs_1582))
(assert (> q_1581 0))
(assert (= (+ flted_10_1580 1) n_1512))
(assert (<= xv_primed xnv_primed))
(assert (> v_bool_69_1380_primed 0))
(assert (= xs_primed 1))
(assert (= r_1500 2))
(assert (or (and (and (= lg_1579 qs_1582) (= flted_10_1580 1)) (> q_1581 0)) (and (and (<= qs_1582 lg_1579) (<= 2 flted_10_1580)) (> q_1581 0))))
(assert (not (= xs_primed q_1581)))
(assert (not (= xs_primed r_1500)))
(assert (not (= r_1500 q_1581)))
;Negation of Consequence
(assert (not false))
(check-sat)