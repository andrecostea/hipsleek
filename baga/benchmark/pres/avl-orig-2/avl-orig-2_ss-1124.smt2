(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tm_4066 () Int)
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun m1_3753 () Int)
(declare-fun height_118_4741 () Int)
(declare-fun m_4127 () Int)
(declare-fun tn_4067 () Int)
(declare-fun n_3750 () Int)
(declare-fun p_6408 () Int)
(declare-fun m_4486 () Int)
(declare-fun p_3752 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n2_3758 () Int)
(declare-fun flted_76_4094 () Int)
(declare-fun n1_3754 () Int)
(declare-fun v_int_108_4476 () Int)
(declare-fun n_4128 () Int)
(declare-fun n_4487 () Int)
(declare-fun n () Int)
(declare-fun n_4598 () Int)
(declare-fun v_int_118_6403 () Int)
(declare-fun n1_6410 () Int)
(declare-fun n2_6414 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m1_3753))
(assert (<= 0 tm_4066))
(assert (= tm_4066 0))
(assert (<= 0 m2_3757))
(assert (= tm_4066 m2_3757))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (= m_4127 m1_3753))
(assert (< p_3752 1))
(assert (= m_4486 0))
(assert (= height_118_4741 n_3750))
(assert (<= 0 m_4486))
(assert (<= 0 n_4128))
(assert (<= 0 m_4127))
(assert (= m_4486 m_4127))
(assert (<= 0 n1_3754))
(assert (<= 0 flted_76_4094))
(assert (<= 0 tn_4067))
(assert (= tn_4067 0))
(assert (<= 0 n2_3758))
(assert (= tn_4067 n2_3758))
(assert (= n_3750 tn))
(assert (= p_6408 p_3752))
(assert (or (= m_4486 0) (or (= n_4487 0) (< p_3752 1))))
(assert (not (= v_int_108_4476 2)))
(assert (exists ((max_6438 Int)) (and (= tn (+ max_6438 1)) (or (and (= max_6438 n1_3754) (>= n1_3754 n2_3758)) (and (= max_6438 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= flted_76_4094 1))
(assert (= n flted_76_4094))
(assert (= n_4128 n1_3754))
(assert (= (+ v_int_108_4476 n_4128) n))
(assert (= n_4487 n_4128))
(assert (<= 0 n_4487))
(assert (<= 0 n_4598))
(assert (= n_4487 0))
(assert (< n_4487 n_4598))
(assert (<= 0 n))
(assert (= n_4598 n))
(assert (= n1_6410 0))
(assert (= v_int_118_6403 (+ 1 n_4598)))
(assert (= n2_6414 n_4598))
;Negation of Consequence
(assert (not (or (and (= v_int_118_6403 (+ 1 n1_6410)) (<= n2_6414 n1_6410)) (and (= v_int_118_6403 (+ 1 n2_6414)) (< n1_6410 n2_6414)))))
(check-sat)