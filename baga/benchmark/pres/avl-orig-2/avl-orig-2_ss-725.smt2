(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_5245 () Int)
(declare-fun height_118_4738 () Int)
(declare-fun b_4488 () Int)
(declare-fun b_3814 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n1_3754 () Int)
(declare-fun tn_3773 () Int)
(declare-fun resb_3798 () Int)
(declare-fun resn_3797 () Int)
(declare-fun n2_3758 () Int)
(declare-fun v_int_89_4442 () Int)
(declare-fun n () Int)
(declare-fun n_3834 () Int)
(declare-fun n_4487 () Int)
(declare-fun n_4598 () Int)
(declare-fun v_int_118_5237 () Int)
(declare-fun n1_5244 () Int)
(declare-fun n2_5248 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_4488 2))
(assert (<= 0 b_4488))
(assert (= Anon_5245 b_4488))
(assert (= height_118_4738 n_3750))
(assert (<= 0 n_3834))
(assert (<= b_3814 2))
(assert (<= 0 b_3814))
(assert (<= 0 n))
(assert (= b_4488 b_3814))
(assert (<= 0 n2_3758))
(assert (<= resb_3798 2))
(assert (<= 0 resb_3798))
(assert (<= 0 resn_3797))
(assert (= b_3814 resb_3798))
(assert (<= 0 tn_3773))
(assert (<= 0 n1_3754))
(assert (= n_3750 tn))
(assert (<= 0 n_4487))
(assert (<= 0 n_4598))
(assert (not (= v_int_89_4442 2)))
(assert (exists ((max_5264 Int)) (and (= tn (+ max_5264 1)) (or (and (= max_5264 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5264 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= tn_3773 n1_3754))
(assert (< 0 tn_3773))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (= n resn_3797))
(assert (= n_3834 n2_3758))
(assert (= (+ v_int_89_4442 n_3834) n))
(assert (= n_4487 n))
(assert (= n_4598 n_3834))
(assert (<= n_4598 n_4487))
(assert (= v_int_118_5237 (+ 1 n_4487)))
(assert (= n1_5244 n_4487))
(assert (= n2_5248 n_4598))
;Negation of Consequence
(assert (not (or (and (= v_int_118_5237 (+ 1 n1_5244)) (<= n2_5248 n1_5244)) (and (= v_int_118_5237 (+ 1 n2_5248)) (< n1_5244 n2_5248)))))
(check-sat)