(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun resn_4424 () Int)
(declare-fun v_int_118_2232_primed () Int)
(declare-fun n_4487 () Int)
(declare-fun tmp2_4425 () Int)
(declare-fun an () Int)
(declare-fun Anon_48 () Int)
(declare-fun Anon_45 () Int)
(declare-fun n_3750 () Int)
(declare-fun n_3926 () Int)
(declare-fun b_3814 () Int)
(declare-fun n1_3917 () Int)
(declare-fun n_3913 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n1_3754 () Int)
(declare-fun tn_3773 () Int)
(declare-fun resb_3798 () Int)
(declare-fun resn_3797 () Int)
(declare-fun n2_3758 () Int)
(declare-fun n () Int)
(declare-fun n2_3921 () Int)
(declare-fun n_3834 () Int)
(declare-fun n_3945 () Int)
(declare-fun resrn_4426 () Int)
(declare-fun tmp1_4423 () Int)
(declare-fun bn () Int)
(declare-fun cn () Int)
(declare-fun n2_4609 () Int)
(declare-fun n1_4605 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_4487))
(assert (= resn_4424 (+ 1 tmp2_4425)))
(assert (= v_int_118_2232_primed n_4487))
(assert (<= 0 an))
(assert (= n_4487 an))
(assert (or (and (= tmp2_4425 an) (>= an resrn_4426)) (and (= tmp2_4425 resrn_4426) (< an resrn_4426))))
(assert (<= 0 n_3834))
(assert (<= 0 n_3926))
(assert (<= 0 n_3945))
(assert (= an n_3926))
(assert (= Anon_48 n_3913))
(assert (= Anon_45 n_3750))
(assert (<= 0 n2_3921))
(assert (<= 0 n1_3917))
(assert (= n_3926 n1_3917))
(assert (<= 0 n2_3758))
(assert (<= b_3814 2))
(assert (<= 0 b_3814))
(assert (<= resb_3798 2))
(assert (<= 0 resb_3798))
(assert (<= 0 resn_3797))
(assert (= b_3814 resb_3798))
(assert (<= 0 tn_3773))
(assert (<= 0 n1_3754))
(assert (= n_3750 tn))
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (< n_3945 n_3926))
(assert (exists ((max_4628 Int)) (and (= n (+ max_4628 1)) (or (and (= max_4628 n1_3917) (>= n1_3917 n2_3921)) (and (= max_4628 n2_3921) (< n1_3917 n2_3921))))))
(assert (<= (+ 0 n2_3921) (+ n1_3917 1)))
(assert (<= n1_3917 (+ 1 n2_3921)))
(assert (= (+ b_3814 n2_3921) (+ 1 n1_3917)))
(assert (= n_3913 n))
(assert (exists ((max_4629 Int)) (and (= tn (+ max_4629 1)) (or (and (= max_4629 n1_3754) (>= n1_3754 n2_3758)) (and (= max_4629 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= tn_3773 n1_3754))
(assert (< 0 tn_3773))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (= n resn_3797))
(assert (<= 0 n))
(assert (= n_3834 n2_3758))
(assert (= (+ 2 n_3834) n))
(assert (= n_3945 n2_3921))
(assert (= cn n_3834))
(assert (= bn n_3945))
(assert (= resrn_4426 (+ 1 tmp1_4423)))
(assert (or (and (= tmp1_4423 cn) (>= cn bn)) (and (= tmp1_4423 bn) (< cn bn))))
(assert (= n1_4605 bn))
(assert (= n2_4609 cn))
;Negation of Consequence
(assert (not (<= (+ n2_4609 0) (+ 1 n1_4605))))
(check-sat)