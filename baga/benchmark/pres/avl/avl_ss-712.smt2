(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_299_2083_primed () Int)
(declare-fun left_299_2082_primed () Int)
(declare-fun height_299_2081_primed () Int)
(declare-fun val_299_2080_primed () Int)
(declare-fun left_297_6071 () Int)
(declare-fun hr_primed () Int)
(declare-fun right_295_6055 () Int)
(declare-fun m_6034 () Int)
(declare-fun v_node_289_5935 () Int)
(declare-fun right_289_5931 () Int)
(declare-fun n1_5930 () Int)
(declare-fun flted_220_5929 () Int)
(declare-fun n_5916 () Int)
(declare-fun m_5915 () Int)
(declare-fun tmp_primed () Int)
(declare-fun q_5426 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_226_2439_primed () Int)
(declare-fun height_5421 () Int)
(declare-fun n () Int)
(declare-fun height2_5428 () Int)
(declare-fun height1_5425 () Int)
(declare-fun m () Int)
(declare-fun size2_5427 () Int)
(declare-fun size1_5424 () Int)
(declare-fun Anon_5422 () Int)
(declare-fun a_primed () Int)
(declare-fun v_bool_230_2438_primed () Int)
(declare-fun v_bool_290_2437_primed () Int)
(declare-fun height_6011 () Int)
(declare-fun n_5939 () Int)
(declare-fun height2_6018 () Int)
(declare-fun height1_6015 () Int)
(declare-fun m_5938 () Int)
(declare-fun size2_6017 () Int)
(declare-fun size1_6014 () Int)
(declare-fun n_6035 () Int)
(declare-fun v_bool_293_2425_primed () Int)
(declare-fun n_5951 () Int)
(declare-fun m_5950 () Int)
(declare-fun p_5423 () Int)
(declare-fun n_6022 () Int)
(declare-fun m_6021 () Int)
(declare-fun q_6016 () Int)
(declare-fun n_6061 () Int)
(declare-fun m_6060 () Int)
(declare-fun p_6013 () Int)
(declare-fun k1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_299_2083_primed p_6013))
(assert (= left_299_2082_primed p_5423))
(assert (= height_299_2081_primed height_5421))
(assert (= val_299_2080_primed Anon_5422))
(assert (= left_297_6071 p_6013))
(assert (<= 0 n_6061))
(assert (<= 0 m_6060))
(assert (= hr_primed n_6061))
(assert (<= 0 n_6035))
(assert (<= 0 m_6034))
(assert (= n_6061 n_6035))
(assert (= m_6060 m_6034))
(assert (= right_295_6055 v_node_289_5935))
(assert (<= 0 height1_6015))
(assert (<= 0 size1_6014))
(assert (= n_6035 height1_6015))
(assert (= m_6034 size1_6014))
(assert (<= 0 n_6022))
(assert (<= 0 m_6021))
(assert (<= 0 height2_6018))
(assert (<= 0 size2_6017))
(assert (= n_6022 height2_6018))
(assert (= m_6021 size2_6017))
(assert (= k1_primed v_node_289_5935))
(assert (= (+ 2 n_5951) n_5939))
(assert (<= 0 n_5951))
(assert (<= 0 m_5950))
(assert (<= 0 height1_5425))
(assert (<= 0 size1_5424))
(assert (= n_5951 height1_5425))
(assert (= m_5950 size1_5424))
(assert (<= 0 n_5939))
(assert (<= 0 m_5938))
(assert (<= 0 n1_5930))
(assert (<= 0 flted_220_5929))
(assert (= n_5939 n1_5930))
(assert (= m_5938 flted_220_5929))
(assert (= right_289_5931 q_5426))
(assert (<= 0 n_5916))
(assert (<= 0 m_5915))
(assert (<= n1_5930 (+ 1 n_5916)))
(assert (<= n_5916 n1_5930))
(assert (= flted_220_5929 (+ 1 m_5915)))
(assert (<= 0 height2_5428))
(assert (<= 0 size2_5427))
(assert (= n_5916 height2_5428))
(assert (= m_5915 size2_5427))
(assert (= tmp_primed q_5426))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< tmp_null_primed 1))
(assert (> x_primed 0))
(assert (not (> v_bool_226_2439_primed 0)))
(assert (= height_5421 n))
(assert (exists ((max_33 Int)) (and (= n (+ 1 max_33)) (or (and (= max_33 height1_5425) (>= height1_5425 height2_5428)) (and (= max_33 height2_5428) (< height1_5425 height2_5428))))))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
(assert (< Anon_5422 a_primed))
(assert (not (> v_bool_230_2438_primed 0)))
(assert (> v_bool_290_2437_primed 0))
(assert (= height_6011 n_5939))
(assert (exists ((max_33 Int)) (and (= n_5939 (+ 1 max_33)) (or (and (= max_33 height1_6015) (>= height1_6015 height2_6018)) (and (= max_33 height2_6018) (< height1_6015 height2_6018))))))
(assert (<= height1_6015 (+ 1 height2_6018)))
(assert (<= height2_6018 (+ 1 height1_6015)))
(assert (= m_5938 (+ (+ size2_6017 1) size1_6014)))
(assert (< n_6035 n_6022))
(assert (> v_bool_293_2425_primed 0))
(assert (or (and (and (< p_5423 1) (= m_5950 0)) (= n_5951 0)) (and (and (<= 1 n_5951) (<= 1 m_5950)) (> p_5423 0))))
(assert (or (and (and (< q_6016 1) (= m_6021 0)) (= n_6022 0)) (and (and (<= 1 n_6022) (<= 1 m_6021)) (> q_6016 0))))
(assert (or (and (and (< p_6013 1) (= m_6060 0)) (= n_6061 0)) (and (and (<= 1 n_6061) (<= 1 m_6060)) (> p_6013 0))))
(assert (= k1_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)