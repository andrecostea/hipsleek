(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_2728 () Int)
(declare-fun r_primed () Int)
(declare-fun r () Int)
(declare-fun r_2424 () Int)
(declare-fun l_2725 () Int)
(declare-fun l_2421 () Int)
(declare-fun m3_2419 () Int)
(declare-fun m1_2417 () Int)
(declare-fun m2_2418 () Int)
(declare-fun m2_2365 () Int)
(declare-fun m2_primed () Int)
(declare-fun m2 () Int)
(declare-fun m1_2364 () Int)
(declare-fun m1_primed () Int)
(declare-fun m1_2422 () Int)
(declare-fun m2_2425 () Int)
(declare-fun m1_2726 () Int)
(declare-fun m2_2729 () Int)
(declare-fun m1 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< r 1))
(assert (< r_2424 1))
(assert (= r_2728 r_2424))
(assert (= r_primed r))
(assert (or (= m2_2365 0) (< r 1)))
(assert (or (= m2_2418 0) (< r_2424 1)))
(assert (< l_2421 1))
(assert (= m1_2417 0))
(assert (<= m3_2419 1))
(assert (<= 0 m3_2419))
(assert (= l_2725 l_2421))
(assert (= m2_2365 0))
(assert (= m2_2418 0))
(assert (or (= m1_2417 0) (< l_2421 1)))
(assert (= m1_2364 (+ (+ m2_2425 1) m1_2422)))
(assert (= (+ m3_2419 m2_2425) m1_2422))
(assert (= m1_2417 m1_2422))
(assert (= m2_2418 m2_2425))
(assert (= m2_2365 m2))
(assert (= m2_primed m2))
(assert (= m2_primed 0))
(assert (= m1_primed m1))
(assert (<= (+ 0 m2) m1))
(assert (<= m1 (+ 1 m2)))
(assert (= m1_2364 m1))
(assert (not (= m1_primed 0)))
(assert (= m1_2726 m1_2422))
(assert (= m2_2729 m2_2425))
;Negation of Consequence
(assert (not (= (+ (+ m1_2726 m2_2729) 1) m1)))
(check-sat)