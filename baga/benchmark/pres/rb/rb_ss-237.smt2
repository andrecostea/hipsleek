(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_6510 () Int)
(declare-fun l_6507 () Int)
(declare-fun tmp_6502 () Int)
(declare-fun v_6506 () Int)
(declare-fun v_int_127_6498 () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun c () Int)
(declare-fun b () Int)
(declare-fun a () Int)
(declare-fun h_6219 () Int)
(declare-fun nc () Int)
(declare-fun flted_119_6220 () Int)
(declare-fun color_127_6237 () Int)
(declare-fun flted_12_6210 () Int)
(declare-fun v_int_128_6500 () Int)
(declare-fun v_int_130_6501 () Int)
(declare-fun res () Int)
(declare-fun v_node_130_4726_primed () Int)
(declare-fun v_6544 () Int)
(declare-fun v_int_128_6499 () Int)
(declare-fun l_6545 () Int)
(declare-fun a_primed () Int)
(declare-fun r_6549 () Int)
(declare-fun b_primed () Int)
(declare-fun na () Int)
(declare-fun Anon_6547 () Int)
(declare-fun flted_119_6221 () Int)
(declare-fun h () Int)
(declare-fun nb () Int)
(declare-fun Anon_6551 () Int)
(declare-fun Anon_17 () Int)
(declare-fun h_6218 () Int)
(declare-fun bhr_6552 () Int)
(declare-fun bhl_6509 () Int)
(declare-fun bhl_6548 () Int)
(declare-fun nl_6508 () Int)
(declare-fun nr_6550 () Int)
(declare-fun nl_6546 () Int)
(declare-fun flted_12_6209 () Int)
(declare-fun bhl_6214 () Int)
(declare-fun nl_6213 () Int)
(declare-fun l_6212 () Int)
(declare-fun flted_12_6208 () Int)
(declare-fun bhr_6217 () Int)
(declare-fun nr_6216 () Int)
(declare-fun r_6215 () Int)
(declare-fun c_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_6510 c_primed))
(assert (= l_6507 tmp_6502))
(assert (= v_6506 v_int_130_6501))
(assert (= v_int_127_6498 0))
(assert (= h_6219 h))
(assert (= h_6218 h))
(assert (= color 0))
(assert (= flted_119_6221 0))
(assert (= color_primed color))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= bhr_6217 h_6219))
(assert (= bhl_6214 h_6219))
(assert (= nc (+ (+ nr_6216 1) nl_6213)))
(assert (= flted_119_6220 1))
(assert (= flted_12_6208 0))
(assert (= flted_12_6209 0))
(assert (= flted_12_6210 1))
(assert (= color_127_6237 flted_12_6210))
(assert (= v_int_128_6499 0))
(assert (= v_int_128_6500 0))
(assert (= v_int_130_6501 0))
(assert (= res v_node_130_4726_primed))
(assert (= v_6544 v_int_128_6499))
(assert (= l_6545 a_primed))
(assert (= r_6549 b_primed))
(assert (= nl_6546 na))
(assert (= Anon_6547 flted_119_6221))
(assert (= bhl_6548 h))
(assert (= nr_6550 nb))
(assert (= Anon_6551 Anon_17))
(assert (= bhr_6552 h_6218))
(assert (= bhl_6548 bhr_6552))
(assert (= bhl_6509 (+ bhl_6548 1)))
(assert (= nl_6508 (+ (+ nr_6550 1) nl_6546)))
(assert (or (and (and (and (= flted_12_6209 0) (<= 2 bhl_6214)) (<= 1 nl_6213)) (> l_6212 0)) (or (and (and (and (< l_6212 1) (= nl_6213 0)) (= bhl_6214 1)) (= flted_12_6209 0)) (and (and (and (= flted_12_6209 1) (<= 1 bhl_6214)) (<= 1 nl_6213)) (> l_6212 0)))))
(assert (or (and (and (and (= flted_12_6208 0) (<= 2 bhr_6217)) (<= 1 nr_6216)) (> r_6215 0)) (or (and (and (and (< r_6215 1) (= nr_6216 0)) (= bhr_6217 1)) (= flted_12_6208 0)) (and (and (and (= flted_12_6208 1) (<= 1 bhr_6217)) (<= 1 nr_6216)) (> r_6215 0)))))
(assert (= c_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)