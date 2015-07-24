(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun s1 () Int)
(declare-fun height_6994 () Int)
(declare-fun h1 () Int)
(declare-fun v_bool_465_1388_primed () Int)
(declare-fun t2_primed () Int)
(declare-fun t2 () Int)
(declare-fun t1 () Int)
(declare-fun s2 () Int)
(declare-fun h2 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun v_node_468_1377_primed () Int)
(declare-fun t1_primed () Int)
(declare-fun height1_6998 () Int)
(declare-fun size1_6997 () Int)
(declare-fun p_6996 () Int)
(declare-fun height2_7001 () Int)
(declare-fun size2_7000 () Int)
(declare-fun q_6999 () Int)
(declare-fun Anon_7017 () Int)
(declare-fun flted_161_7016 () Int)
(declare-fun tmp_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= s1 (+ (+ size2_7000 1) size1_6997)))
(assert (<= height2_7001 (+ 1 height1_6998)))
(assert (<= height1_6998 (+ 1 height2_7001)))
(assert (exists ((max_33 Int)) (and (= h1 (+ 1 max_33)) (or (and (= max_33 height1_6998) (>= height1_6998 height2_7001)) (and (= max_33 height2_7001) (< height1_6998 height2_7001))))))
(assert (= height_6994 h1))
(assert (not (> v_bool_465_1388_primed 0)))
(assert (> t1_primed 0))
(assert (> t1 0))
(assert (= t2_primed t2))
(assert (= t1_primed t1))
(assert (= m s2))
(assert (= n h2))
(assert (<= 0 s2))
(assert (<= 0 h2))
(assert (= flted_161_7016 (+ 1 m)))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (= v_node_468_1377_primed p_6996))
(assert (> tmp_primed 0))
(assert (= t1_primed 1))
(assert (or (and (and (< p_6996 1) (= size1_6997 0)) (= height1_6998 0)) (and (and (<= 1 height1_6998) (<= 1 size1_6997)) (> p_6996 0))))
(assert (or (and (and (< q_6999 1) (= size2_7000 0)) (= height2_7001 0)) (and (and (<= 1 height2_7001) (<= 1 size2_7000)) (> q_6999 0))))
(assert (or (and (and (< tmp_primed 1) (= flted_161_7016 0)) (= Anon_7017 0)) (and (and (<= 1 Anon_7017) (<= 1 flted_161_7016)) (> tmp_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)