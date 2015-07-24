(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_5723 () Int)
(declare-fun v_bool_253_1919_primed () Int)
(declare-fun v_bool_237_1920_primed () Int)
(declare-fun height_5537 () Int)
(declare-fun v_bool_234_1932_primed () Int)
(declare-fun v_bool_230_2438_primed () Int)
(declare-fun Anon_5422 () Int)
(declare-fun m () Int)
(declare-fun height_5421 () Int)
(declare-fun n () Int)
(declare-fun v_bool_226_2439_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun size1_5424 () Int)
(declare-fun height1_5425 () Int)
(declare-fun m_5441 () Int)
(declare-fun n_5442 () Int)
(declare-fun left_233_5457 () Int)
(declare-fun p_5423 () Int)
(declare-fun flted_220_5455 () Int)
(declare-fun n1_5456 () Int)
(declare-fun m_5464 () Int)
(declare-fun size2_5427 () Int)
(declare-fun height2_5428 () Int)
(declare-fun n_5465 () Int)
(declare-fun size1_5540 () Int)
(declare-fun height1_5541 () Int)
(declare-fun size2_5543 () Int)
(declare-fun height2_5544 () Int)
(declare-fun m_5547 () Int)
(declare-fun n_5548 () Int)
(declare-fun m_5560 () Int)
(declare-fun n_5561 () Int)
(declare-fun m_5669 () Int)
(declare-fun n_5670 () Int)
(declare-fun left_256_5735 () Int)
(declare-fun v_node_233_5461 () Int)
(declare-fun right_257_5742 () Int)
(declare-fun q_5542 () Int)
(declare-fun p_5725 () Int)
(declare-fun size1_5726 () Int)
(declare-fun height1_5727 () Int)
(declare-fun res () Int)
(declare-fun m_5747 () Int)
(declare-fun n_5748 () Int)
(declare-fun n_5477 () Int)
(declare-fun m_5476 () Int)
(declare-fun q_5426 () Int)
(declare-fun n_5657 () Int)
(declare-fun m_5656 () Int)
(declare-fun p_5539 () Int)
(declare-fun height2_5730 () Int)
(declare-fun size2_5729 () Int)
(declare-fun q_5728 () Int)
(declare-fun n_5755 () Int)
(declare-fun m_5754 () Int)
(declare-fun v_node_258_1763_primed () Int)
(declare-fun k2_primed () Int)
(declare-fun x_primed () Int)
(declare-fun k1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m_5669 (+ (+ size2_5729 1) size1_5726)))
(assert (<= height2_5730 (+ 1 height1_5727)))
(assert (<= height1_5727 (+ 1 height2_5730)))
(assert (exists ((max_33 Int)) (and (= n_5670 (+ 1 max_33)) (or (and (= max_33 height1_5727) (>= height1_5727 height2_5730)) (and (= max_33 height2_5730) (< height1_5727 height2_5730))))))
(assert (= height_5723 n_5670))
(assert (> v_bool_253_1919_primed 0))
(assert (not (> v_bool_237_1920_primed 0)))
(assert (<= n_5548 n_5561))
(assert (= m_5464 (+ (+ size2_5543 1) size1_5540)))
(assert (<= height2_5544 (+ 1 height1_5541)))
(assert (<= height1_5541 (+ 1 height2_5544)))
(assert (exists ((max_33 Int)) (and (= n_5465 (+ 1 max_33)) (or (and (= max_33 height1_5541) (>= height1_5541 height2_5544)) (and (= max_33 height2_5544) (< height1_5541 height2_5544))))))
(assert (= height_5537 n_5465))
(assert (> v_bool_234_1932_primed 0))
(assert (> v_bool_230_2438_primed 0))
(assert (<= a_primed Anon_5422))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (exists ((max_33 Int)) (and (= n (+ 1 max_33)) (or (and (= max_33 height1_5425) (>= height1_5425 height2_5428)) (and (= max_33 height2_5428) (< height1_5425 height2_5428))))))
(assert (= height_5421 n))
(assert (not (> v_bool_226_2439_primed 0)))
(assert (> x_primed 0))
(assert (< tmp_null_primed 1))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= tmp_primed p_5423))
(assert (= m_5441 size1_5424))
(assert (= n_5442 height1_5425))
(assert (<= 0 size1_5424))
(assert (<= 0 height1_5425))
(assert (= flted_220_5455 (+ 1 m_5441)))
(assert (<= n_5442 n1_5456))
(assert (<= n1_5456 (+ 1 n_5442)))
(assert (<= 0 m_5441))
(assert (<= 0 n_5442))
(assert (= left_233_5457 p_5423))
(assert (= m_5464 flted_220_5455))
(assert (= n_5465 n1_5456))
(assert (<= 0 flted_220_5455))
(assert (<= 0 n1_5456))
(assert (<= 0 m_5464))
(assert (<= 0 n_5465))
(assert (= m_5476 size2_5427))
(assert (= n_5477 height2_5428))
(assert (<= 0 size2_5427))
(assert (<= 0 height2_5428))
(assert (<= 0 m_5476))
(assert (<= 0 n_5477))
(assert (= (+ 2 n_5477) n_5465))
(assert (= k1_primed v_node_233_5461))
(assert (= m_5547 size1_5540))
(assert (= n_5548 height1_5541))
(assert (<= 0 size1_5540))
(assert (<= 0 height1_5541))
(assert (= m_5560 size2_5543))
(assert (= n_5561 height2_5544))
(assert (<= 0 size2_5543))
(assert (<= 0 height2_5544))
(assert (= m_5656 m_5547))
(assert (= n_5657 n_5548))
(assert (<= 0 m_5547))
(assert (<= 0 n_5548))
(assert (<= 0 m_5656))
(assert (<= 0 n_5657))
(assert (= m_5669 m_5560))
(assert (= n_5670 n_5561))
(assert (<= 0 m_5560))
(assert (<= 0 n_5561))
(assert (<= 0 m_5669))
(assert (<= 0 n_5670))
(assert (= (+ n_5657 1) n_5670))
(assert (= k2_primed q_5542))
(assert (= left_256_5735 v_node_233_5461))
(assert (= right_257_5742 q_5542))
(assert (= v_node_258_1763_primed p_5725))
(assert (= m_5747 size1_5726))
(assert (= n_5748 height1_5727))
(assert (<= 0 size1_5726))
(assert (<= 0 height1_5727))
(assert (= res n_5748))
(assert (= m_5754 m_5747))
(assert (= n_5755 n_5748))
(assert (<= 0 m_5747))
(assert (<= 0 n_5748))
(assert (or (and (and (< q_5426 1) (= m_5476 0)) (= n_5477 0)) (and (and (<= 1 n_5477) (<= 1 m_5476)) (> q_5426 0))))
(assert (or (and (and (< p_5539 1) (= m_5656 0)) (= n_5657 0)) (and (and (<= 1 n_5657) (<= 1 m_5656)) (> p_5539 0))))
(assert (= k2_primed 1))
(assert (or (and (and (< q_5728 1) (= size2_5729 0)) (= height2_5730 0)) (and (and (<= 1 height2_5730) (<= 1 size2_5729)) (> q_5728 0))))
(assert (= x_primed 2))
(assert (= k1_primed 3))
(assert (or (and (and (< v_node_258_1763_primed 1) (= m_5754 0)) (= n_5755 0)) (and (and (<= 1 n_5755) (<= 1 m_5754)) (> v_node_258_1763_primed 0))))
(assert (not (= k2_primed k1_primed)))
(assert (not (= k2_primed x_primed)))
(assert (not (= x_primed k1_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)