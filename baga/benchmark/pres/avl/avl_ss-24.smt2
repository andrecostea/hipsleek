(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_152_2968_primed () Int)
(declare-fun left_152_2967_primed () Int)
(declare-fun height_152_2966_primed () Int)
(declare-fun Anon_17 () Int)
(declare-fun val_152_2965_primed () Int)
(declare-fun Anon_16 () Int)
(declare-fun v_int_152_2964_primed () Int)
(declare-fun right_151_3767 () Int)
(declare-fun Anon_19 () Int)
(declare-fun left_150_3764 () Int)
(declare-fun Anon_18 () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun z_primed () Int)
(declare-fun y () Int)
(declare-fun height_3805 () Int)
(declare-fun ny () Int)
(declare-fun my () Int)
(declare-fun y_primed () Int)
(declare-fun height1_3809 () Int)
(declare-fun size1_3808 () Int)
(declare-fun p_3807 () Int)
(declare-fun height2_3812 () Int)
(declare-fun size2_3811 () Int)
(declare-fun q_3810 () Int)
(declare-fun ny_3763 () Int)
(declare-fun mz () Int)
(declare-fun z () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_152_2968_primed z_primed))
(assert (= left_152_2967_primed y_primed))
(assert (= height_152_2966_primed Anon_17))
(assert (= val_152_2965_primed Anon_16))
(assert (= v_int_152_2964_primed (+ 1 height_3805)))
(assert (= right_151_3767 Anon_19))
(assert (= left_150_3764 Anon_18))
(assert (= x_primed x))
(assert (= y_primed y))
(assert (= z_primed z))
(assert (> y 0))
(assert (= ny_3763 ny))
(assert (= height_3805 ny))
(assert (exists ((max_33 Int)) (and (= ny (+ 1 max_33)) (or (and (= max_33 height1_3809) (>= height1_3809 height2_3812)) (and (= max_33 height2_3812) (< height1_3809 height2_3812))))))
(assert (<= height1_3809 (+ 1 height2_3812)))
(assert (<= height2_3812 (+ 1 height1_3809)))
(assert (= my (+ (+ size2_3811 1) size1_3808)))
(assert (= y_primed 1))
(assert (or (and (and (< p_3807 1) (= size1_3808 0)) (= height1_3809 0)) (and (and (<= 1 height1_3809) (<= 1 size1_3808)) (> p_3807 0))))
(assert (or (and (and (< q_3810 1) (= size2_3811 0)) (= height2_3812 0)) (and (and (<= 1 height2_3812) (<= 1 size2_3811)) (> q_3810 0))))
(assert (or (and (and (< z 1) (= mz 0)) (= ny_3763 0)) (and (and (<= 1 ny_3763) (<= 1 mz)) (> z 0))))
;Negation of Consequence
(assert (not false))
(check-sat)