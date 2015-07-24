(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_5547 () Int)
(declare-fun nr_5546 () Int)
(declare-fun nb () Int)
(declare-fun bhl_5544 () Int)
(declare-fun nl_5543 () Int)
(declare-fun na () Int)
(declare-fun r_5545 () Int)
(declare-fun l_5542 () Int)
(declare-fun v_5541 () Int)
(declare-fun v_int_42_5535 () Int)
(declare-fun v_int_42_5534 () Int)
(declare-fun flted_36_5532 () Int)
(declare-fun flted_36_5533 () Int)
(declare-fun d_primed () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun flted_36_5531 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_36_5530 () Int)
(declare-fun bha () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_5547 bha))
(assert (= nr_5546 nb))
(assert (= bhl_5544 bha))
(assert (= nl_5543 na))
(assert (= r_5545 b_primed))
(assert (= l_5542 a_primed))
(assert (= v_5541 v_int_42_5534))
(assert (= v_int_42_5535 1))
(assert (= v_int_42_5534 0))
(assert (= flted_36_5530 0))
(assert (= flted_36_5531 0))
(assert (= flted_36_5532 0))
(assert (= flted_36_5533 0))
(assert (= d_primed d))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (or (and (and (and (= flted_36_5531 0) (<= 2 bha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= bha 1)) (= flted_36_5531 0)) (and (and (and (= flted_36_5531 1) (<= 1 bha)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_36_5530 0) (<= 2 bha)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= bha 1)) (= flted_36_5530 0)) (and (and (and (= flted_36_5530 1) (<= 1 bha)) (<= 1 nd)) (> d 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)