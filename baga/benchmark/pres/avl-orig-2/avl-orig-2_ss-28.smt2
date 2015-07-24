(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun k2 () Int)
(declare-fun left_200_2608 () Int)
(declare-fun l () Int)
(declare-fun right_201_2611 () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun Anon_50 () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun Anon_46 () Int)
(declare-fun res () Int)
(declare-fun v_int_202_1669_primed () Int)
(declare-fun v_int_202_1670_primed () Int)
(declare-fun an () Int)
(declare-fun Anon_49 () Int)
(declare-fun am () Int)
(declare-fun ll () Int)
(declare-fun n () Int)
(declare-fun b () Int)
(declare-fun m () Int)
(declare-fun lr () Int)
(declare-fun n_2627 () Int)
(declare-fun b_2628 () Int)
(declare-fun m_2626 () Int)
(declare-fun r () Int)
(declare-fun k2_primed () Int)
(declare-fun k1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= k2_primed k2))
(assert (= k1_primed l))
(assert (= left_200_2608 l))
(assert (= right_201_2611 lr))
(assert (= m bm))
(assert (= n bn))
(assert (= b Anon_50))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 Anon_50))
(assert (<= Anon_50 2))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b))
(assert (<= b 2))
(assert (= m_2626 cm))
(assert (= n_2627 cn))
(assert (= b_2628 Anon_46))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (<= 0 Anon_46))
(assert (<= Anon_46 2))
(assert (<= 0 m_2626))
(assert (<= 0 n_2627))
(assert (<= 0 b_2628))
(assert (<= b_2628 2))
(assert (= v_int_202_1670_primed n_2627))
(assert (< n n_2627))
(assert (= v_int_202_1669_primed 1))
(assert (= res (+ v_int_202_1669_primed v_int_202_1670_primed)))
(assert (or (and (and (and (< ll 1) (= am 0)) (= an 0)) (= Anon_49 1)) (and (and (and (and (and (<= 0 Anon_49) (<= (+ (- 0 an) 2) Anon_49)) (<= Anon_49 an)) (<= Anon_49 2)) (<= 1 am)) (> ll 0))))
(assert (= k2_primed 1))
(assert (= k1_primed 2))
(assert (or (and (and (and (< lr 1) (= m 0)) (= n 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 n) 2) b)) (<= b n)) (<= b 2)) (<= 1 m)) (> lr 0))))
(assert (or (and (and (and (< r 1) (= m_2626 0)) (= n_2627 0)) (= b_2628 1)) (and (and (and (and (and (<= 0 b_2628) (<= (+ (- 0 n_2627) 2) b_2628)) (<= b_2628 n_2627)) (<= b_2628 2)) (<= 1 m_2626)) (> r 0))))
(assert (not (= k2_primed k1_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)