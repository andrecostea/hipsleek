(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun ty_primed () Int)
(declare-fun ty () Int)
(declare-fun ty_1403 () Int)
(declare-fun y_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun y () Int)
(declare-fun tx_1619 () Int)
(declare-fun r_1622 () Int)
(declare-fun flted_23_1636 () Int)
(declare-fun tx_primed () Int)
(declare-fun tx () Int)
(declare-fun tx_1402 () Int)
(declare-fun r_1513 () Int)
(declare-fun flted_19_1620 () Int)
(declare-fun flted_19_1428 () Int)
(declare-fun tx_1427 () Int)
(declare-fun r_1430 () Int)
(declare-fun flted_23_1444 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= ty_primed ty))
(assert (= ty_1403 ty))
(assert (> r_1622 0))
(assert (= tx_1619 ty_1403))
(assert (= y_primed y))
(assert (= x_primed x))
(assert (= y 1))
(assert (= x 4))
(assert (not (= y x)))
(assert (not (= tx_1619 x)))
(assert (not (= tx_primed tx_1619)))
(assert (not (= tx_primed x)))
(assert (not (= y tx_primed)))
(assert (not (= y tx_1619)))
(assert (= tx_1619 3))
(assert (= tx_primed 2))
(assert (or (and (= tx_1619 r_1622) (= flted_23_1636 0)) (and (<= 1 flted_23_1636) (> r_1622 0))))
(assert (= (+ flted_23_1636 1) flted_19_1620))
(assert (= tx_primed tx))
(assert (= tx_1402 tx))
(assert (= tx_1427 tx_1402))
(assert (> r_1430 0))
(assert (= r_1513 r_1430))
(assert (= (+ flted_19_1620 1) m))
(assert (= (+ flted_19_1428 1) n))
(assert (= (+ flted_23_1444 1) flted_19_1428))
(assert (or (and (= tx_1427 r_1430) (= flted_23_1444 0)) (and (<= 1 flted_23_1444) (> r_1430 0))))
;Negation of Consequence
(assert (not (= (+ (+ 1 flted_23_1444) 1) (+ m n))))
(check-sat)