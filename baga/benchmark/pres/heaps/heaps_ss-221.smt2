(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun mx2_2791 () Int)
(declare-fun mx1_2788 () Int)
(declare-fun mx2_2773 () Int)
(declare-fun mx1_2770 () Int)
(declare-fun d_2767 () Int)
(declare-fun mx2_2487 () Int)
(declare-fun mx1_2484 () Int)
(declare-fun mx2_2534 () Int)
(declare-fun mx1_2531 () Int)
(declare-fun d_2481 () Int)
(declare-fun d_2528 () Int)
(declare-fun v () Int)
(declare-fun mx2 () Int)
(declare-fun mx1 () Int)
(declare-fun d_2553 () Int)
(declare-fun d () Int)
(declare-fun v_primed () Int)
(declare-fun d_2785 () Int)
(declare-fun d_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= mx2_2791 mx2_2534))
(assert (= mx1_2788 mx1_2531))
(assert (exists ((mx3_2821 Int)) (<= d_2767 mx3_2821)))
(assert (= mx2_2773 mx2_2487))
(assert (= mx1_2770 mx1_2484))
(assert (= d_2767 d_2481))
(assert (<= 0 mx1_2484))
(assert (<= 0 mx2_2487))
(assert (<= 0 mx1_2531))
(assert (<= 0 mx2_2534))
(assert (= v_primed v))
(assert (<= 0 v))
(assert (<= d_2481 mx1))
(assert (<= mx2_2487 d_2481))
(assert (<= mx1_2484 d_2481))
(assert (<= 0 d_2481))
(assert (<= d_2528 mx2))
(assert (<= mx2_2534 d_2528))
(assert (<= mx1_2531 d_2528))
(assert (<= 0 d_2528))
(assert (<= d_2528 d_2481))
(assert (<= d_2481 v_primed))
(assert (exists ((mx4_2822 Int)) (<= d_2785 mx4_2822)))
(assert (= d_2785 d_2528))
(assert (<= v d))
(assert (<= mx2 d))
(assert (<= mx1 d))
(assert (= d_2553 d))
(assert (= d_primed v_primed))
;Negation of Consequence
(assert (not (<= d_2785 d_primed)))
(check-sat)