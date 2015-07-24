(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun x2 () Int)
(declare-fun x1_2055 () Int)
(declare-fun n1 () Int)
(declare-fun s1 () Int)
(declare-fun b1 () Int)
(declare-fun x1 () Int)
(declare-fun n () Int)
(declare-fun n1_2083 () Int)
(declare-fun x2_primed () Int)
(declare-fun flted_117_2069 () Int)
(declare-fun x1_primed () Int)
(declare-fun b1_2085 () Int)
(declare-fun s1_2084 () Int)
(declare-fun v_node_103_1401_primed () Int)
(declare-fun lres_2071 () Int)
(declare-fun xl () Int)
(declare-fun sres_2070 () Int)
(declare-fun xs () Int)
(declare-fun b2 () Int)
(declare-fun sm_2037 () Int)
(declare-fun s2 () Int)
(declare-fun n2 () Int)
(declare-fun qs_2041 () Int)
(declare-fun lg_2038 () Int)
(declare-fun q_2040 () Int)
(declare-fun flted_22_2039 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> x1_2055 0))
(assert (<= 1 n))
(assert (<= s1 b1))
(assert (<= 1 n1))
(assert (> x2_primed 0))
(assert (= x2_primed x2))
(assert (= x1_2055 x1))
(assert (= n n1))
(assert (= xs s1))
(assert (= xl b1))
(assert (> x1 0))
(assert (= flted_117_2069 (+ 1 n)))
(assert (= n1_2083 flted_117_2069))
(assert (= x2_primed 1))
(assert (not (= q_2040 x1_primed)))
(assert (not (= x2_primed q_2040)))
(assert (not (= x2_primed x1_primed)))
(assert (or (and (and (= lres_2071 sres_2070) (= flted_117_2069 1)) (> x1_primed 0)) (and (and (<= sres_2070 lres_2071) (<= 2 flted_117_2069)) (> x1_primed 0))))
(assert (= b1_2085 lres_2071))
(assert (= s1_2084 sres_2070))
(assert (= v_node_103_1401_primed q_2040))
(assert (<= xs xl))
(assert (or (and (= lres_2071 sm_2037) (>= sm_2037 xl)) (and (= lres_2071 xl) (< sm_2037 xl))))
(assert (or (and (= sres_2070 sm_2037) (< sm_2037 xs)) (and (= sres_2070 xs) (>= sm_2037 xs))))
(assert (= lg_2038 b2))
(assert (= sm_2037 s2))
(assert (<= s2 qs_2041))
(assert (> q_2040 0))
(assert (= (+ flted_22_2039 1) n2))
(assert (or (and (and (= lg_2038 qs_2041) (= flted_22_2039 1)) (> q_2040 0)) (and (and (<= qs_2041 lg_2038) (<= 2 flted_22_2039)) (> q_2040 0))))
;Negation of Consequence
(assert (not (= flted_22_2039 1)))
(check-sat)