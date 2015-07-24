(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_177_2538_primed () Int)
(declare-fun left_177_2537_primed () Int)
(declare-fun height_177_2536_primed () Int)
(declare-fun val_177_2535_primed () Int)
(declare-fun Anon_4662 () Int)
(declare-fun v_node_177_2534_primed () Int)
(declare-fun v_node_173_4585 () Int)
(declare-fun v_int_177_2549_primed () Int)
(declare-fun Anon_4580 () Int)
(declare-fun left_173_4581 () Int)
(declare-fun flted_161_4579 () Int)
(declare-fun n_4566 () Int)
(declare-fun m_4565 () Int)
(declare-fun tmp_primed () Int)
(declare-fun p_4547 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v_bool_166_2900_primed () Int)
(declare-fun height_4545 () Int)
(declare-fun n () Int)
(declare-fun height2_4552 () Int)
(declare-fun height1_4549 () Int)
(declare-fun m () Int)
(declare-fun size2_4551 () Int)
(declare-fun size1_4548 () Int)
(declare-fun a_primed () Int)
(declare-fun Anon_4546 () Int)
(declare-fun v_bool_170_2899_primed () Int)
(declare-fun v_bool_175_2685_primed () Int)
(declare-fun height_4661 () Int)
(declare-fun n_4589 () Int)
(declare-fun height1_4665 () Int)
(declare-fun m_4588 () Int)
(declare-fun size1_4664 () Int)
(declare-fun x_primed () Int)
(declare-fun height2_4668 () Int)
(declare-fun size2_4667 () Int)
(declare-fun q_4666 () Int)
(declare-fun n_4601 () Int)
(declare-fun m_4600 () Int)
(declare-fun q_4550 () Int)
(declare-fun n_4672 () Int)
(declare-fun m_4671 () Int)
(declare-fun p_4663 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_177_2538_primed q_4666))
(assert (= left_177_2537_primed p_4663))
(assert (= height_177_2536_primed height_4661))
(assert (= val_177_2535_primed Anon_4662))
(assert (= v_node_177_2534_primed v_node_173_4585))
(assert (<= 0 n_4672))
(assert (<= 0 m_4671))
(assert (= v_int_177_2549_primed n_4672))
(assert (<= 0 height1_4665))
(assert (<= 0 size1_4664))
(assert (= n_4672 height1_4665))
(assert (= m_4671 size1_4664))
(assert (= (+ 2 n_4601) n_4589))
(assert (<= 0 n_4601))
(assert (<= 0 m_4600))
(assert (<= 0 height2_4552))
(assert (<= 0 size2_4551))
(assert (= n_4601 height2_4552))
(assert (= m_4600 size2_4551))
(assert (<= 0 n_4589))
(assert (<= 0 m_4588))
(assert (<= 0 Anon_4580))
(assert (<= 0 flted_161_4579))
(assert (= n_4589 Anon_4580))
(assert (= m_4588 flted_161_4579))
(assert (= left_173_4581 p_4547))
(assert (<= 0 n_4566))
(assert (<= 0 m_4565))
(assert (= flted_161_4579 (+ 1 m_4565)))
(assert (<= 0 height1_4549))
(assert (<= 0 size1_4548))
(assert (= n_4566 height1_4549))
(assert (= m_4565 size1_4548))
(assert (= tmp_primed p_4547))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< tmp_null_primed 1))
(assert (> x_primed 0))
(assert (not (> v_bool_166_2900_primed 0)))
(assert (= height_4545 n))
(assert (exists ((max_33 Int)) (and (= n (+ 1 max_33)) (or (and (= max_33 height1_4549) (>= height1_4549 height2_4552)) (and (= max_33 height2_4552) (< height1_4549 height2_4552))))))
(assert (<= height1_4549 (+ 1 height2_4552)))
(assert (<= height2_4552 (+ 1 height1_4549)))
(assert (= m (+ (+ size2_4551 1) size1_4548)))
(assert (<= a_primed Anon_4546))
(assert (> v_bool_170_2899_primed 0))
(assert (> v_bool_175_2685_primed 0))
(assert (= height_4661 n_4589))
(assert (exists ((max_33 Int)) (and (= n_4589 (+ 1 max_33)) (or (and (= max_33 height1_4665) (>= height1_4665 height2_4668)) (and (= max_33 height2_4668) (< height1_4665 height2_4668))))))
(assert (<= height1_4665 (+ 1 height2_4668)))
(assert (<= height2_4668 (+ 1 height1_4665)))
(assert (= m_4588 (+ (+ size2_4667 1) size1_4664)))
(assert (= x_primed 1))
(assert (or (and (and (< q_4666 1) (= size2_4667 0)) (= height2_4668 0)) (and (and (<= 1 height2_4668) (<= 1 size2_4667)) (> q_4666 0))))
(assert (or (and (and (< q_4550 1) (= m_4600 0)) (= n_4601 0)) (and (and (<= 1 n_4601) (<= 1 m_4600)) (> q_4550 0))))
(assert (or (and (and (< p_4663 1) (= m_4671 0)) (= n_4672 0)) (and (and (<= 1 n_4672) (<= 1 m_4671)) (> p_4663 0))))
;Negation of Consequence
(assert (not false))
(check-sat)