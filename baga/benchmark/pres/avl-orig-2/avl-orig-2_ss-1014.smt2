(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_6111 () Int)
(declare-fun n2_6110 () Int)
(declare-fun n1_6106 () Int)
(declare-fun height_118_4743 () Int)
(declare-fun v_int_118_6099 () Int)
(declare-fun b_4599 () Int)
(declare-fun n_4598 () Int)
(declare-fun n_4487 () Int)
(declare-fun v_int_108_4474 () Int)
(declare-fun n_4128 () Int)
(declare-fun b_4108 () Int)
(declare-fun n () Int)
(declare-fun resn_4091 () Int)
(declare-fun resb_4092 () Int)
(declare-fun tn_4067 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
(declare-fun n2_3758 () Int)
(declare-fun n1_3754 () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((resb_6138 Int)) (= (+ resb_6138 n2_6110) (+ 1 n1_6106))))
(assert (exists ((max_6137 Int)) (and (= v_int_118_6099 (+ max_6137 1)) (or (and (= max_6137 n1_6106) (>= n1_6106 n2_6110)) (and (= max_6137 n2_6110) (< n1_6106 n2_6110))))))
(assert (= Anon_6111 b_4599))
(assert (= n2_6110 n_4598))
(assert (= n1_6106 n_4487))
(assert (not (= v_int_108_4474 2)))
(assert (<= 0 n_4487))
(assert (<= b_4599 2))
(assert (<= 0 b_4599))
(assert (<= 0 n_4598))
(assert (= height_118_4743 n_3750))
(assert (= v_int_118_6099 (+ 1 n_4598)))
(assert (< n_4487 n_4598))
(assert (<= b_4108 2))
(assert (<= 0 b_4108))
(assert (<= 0 n))
(assert (= b_4599 b_4108))
(assert (= n_4598 n))
(assert (<= 0 n_4128))
(assert (= n_4487 n_4128))
(assert (= (+ v_int_108_4474 n_4128) n))
(assert (<= 0 n1_3754))
(assert (= n_4128 n1_3754))
(assert (<= resb_4092 2))
(assert (<= 0 resb_4092))
(assert (<= 0 resn_4091))
(assert (= b_4108 resb_4092))
(assert (= n resn_4091))
(assert (<= 0 tn_4067))
(assert (or (= tn_4067 resn_4091) (and (= resn_4091 (+ 1 tn_4067)) (not (= resb_4092 1)))))
(assert (< 0 tn_4067))
(assert (<= 0 n2_3758))
(assert (= tn_4067 n2_3758))
(assert (= n_3750 tn))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_6136 Int)) (and (= tn (+ max_6136 1)) (or (and (= max_6136 n1_3754) (>= n1_3754 n2_3758)) (and (= max_6136 n2_3758) (< n1_3754 n2_3758))))))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
;Negation of Consequence
(assert (not (<= b 2)))
(check-sat)