(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_13543 () Int)
(declare-fun nr_13542 () Int)
(declare-fun nb () Int)
(declare-fun bhl_13540 () Int)
(declare-fun nl_13539 () Int)
(declare-fun na () Int)
(declare-fun r_13541 () Int)
(declare-fun l_13538 () Int)
(declare-fun v_13537 () Int)
(declare-fun res () Int)
(declare-fun v_node_232_3952_primed () Int)
(declare-fun v_int_232_13436 () Int)
(declare-fun v_int_230_13434 () Int)
(declare-fun v_int_230_13433 () Int)
(declare-fun flted_224_13431 () Int)
(declare-fun flted_224_13432 () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun v_13451 () Int)
(declare-fun v_int_232_13435 () Int)
(declare-fun l_13452 () Int)
(declare-fun tmp_13437 () Int)
(declare-fun r_13456 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_224_13430 () Int)
(declare-fun ha () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_13543 ha))
(assert (= nr_13542 nb))
(assert (= bhl_13540 ha))
(assert (= nl_13539 na))
(assert (= r_13541 b_primed))
(assert (= l_13538 a_primed))
(assert (= v_13537 v_int_230_13433))
(assert (= res v_node_232_3952_primed))
(assert (= v_int_232_13436 0))
(assert (= v_int_232_13435 0))
(assert (= v_int_230_13434 1))
(assert (= v_int_230_13433 0))
(assert (= flted_224_13430 0))
(assert (= flted_224_13431 0))
(assert (= flted_224_13432 0))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= v_13451 v_int_232_13435))
(assert (= l_13452 tmp_13437))
(assert (= r_13456 c_primed))
(assert (or (and (and (and (= flted_224_13430 0) (<= 2 ha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha 1)) (= flted_224_13430 0)) (and (and (and (= flted_224_13430 1) (<= 1 ha)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)