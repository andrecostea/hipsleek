(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_5547 () Int)
(declare-fun nr_5546 () Int)
(declare-fun bhl_5544 () Int)
(declare-fun nl_5543 () Int)
(declare-fun r_5545 () Int)
(declare-fun l_5542 () Int)
(declare-fun v_5541 () Int)
(declare-fun v_int_42_5535 () Int)
(declare-fun v_int_42_5534 () Int)
(declare-fun d_primed () Int)
(declare-fun d () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun nd () Int)
(declare-fun flted_36_5530 () Int)
(declare-fun nc () Int)
(declare-fun flted_36_5531 () Int)
(declare-fun nb () Int)
(declare-fun flted_36_5532 () Int)
(declare-fun na () Int)
(declare-fun bha () Int)
(declare-fun flted_36_5533 () Int)
(declare-fun tmp_5584 () Int)
(declare-fun flted_22_5583 () Int)
(declare-fun flted_22_5582 () Int)
(declare-fun flted_22_5581 () Int)
(declare-fun na_5520 () Int)
(declare-fun bha_5523 () Int)
(declare-fun nb_5521 () Int)
(declare-fun nc_5522 () Int)
(declare-fun res () Int)
(declare-fun v_node_44_5107_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= na_5520 (+ (+ nr_5546 1) nl_5543)))
(assert (= bhl_5544 bha_5523))
(assert (= bhr_5547 bha_5523))
(assert (= bhr_5547 bhl_5544))
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
(assert (= nb_5521 nc))
(assert (= nc_5522 nd))
(assert (<= 0 nd))
(assert (<= 0 flted_36_5530))
(assert (<= flted_36_5530 1))
(assert (<= 0 nc))
(assert (<= 0 flted_36_5531))
(assert (<= flted_36_5531 1))
(assert (<= 0 nb))
(assert (<= 0 flted_36_5532))
(assert (<= flted_36_5532 1))
(assert (<= 0 na))
(assert (<= 1 bha))
(assert (<= 0 flted_36_5533))
(assert (<= flted_36_5533 1))
(assert (> tmp_5584 0))
(assert (= flted_22_5583 (+ (+ (+ 2 nb_5521) na_5520) nc_5522)))
(assert (= flted_22_5582 0))
(assert (= flted_22_5581 (+ 1 bha_5523)))
(assert (exists ((flted_21_512 Int)) (and (<= 0 flted_21_512) (<= flted_21_512 1))))
(assert (exists ((flted_21_511 Int)) (and (<= 0 flted_21_511) (<= flted_21_511 1))))
(assert (exists ((flted_21_510 Int)) (and (<= 0 flted_21_510) (<= flted_21_510 1))))
(assert (exists ((bha_514 Int)) (<= 1 bha_514)))
(assert (exists ((bha_513 Int)) (<= 1 bha_513)))
(assert (<= 0 na_5520))
(assert (<= 1 bha_5523))
(assert (<= 0 nb_5521))
(assert (<= 0 nc_5522))
(assert (= res v_node_44_5107_primed))
;Negation of Consequence
(assert (not false))
(check-sat)