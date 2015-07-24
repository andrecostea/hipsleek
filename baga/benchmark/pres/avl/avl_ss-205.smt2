(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height2_4395 () Int)
(declare-fun size2_4394 () Int)
(declare-fun rrm () Int)
(declare-fun q_4393 () Int)
(declare-fun p_4390 () Int)
(declare-fun tmp_4385 () Int)
(declare-fun Anon_4389 () Int)
(declare-fun res () Int)
(declare-fun v_node_43_3531_primed () Int)
(declare-fun h_4386 () Int)
(declare-fun lm () Int)
(declare-fun l () Int)
(declare-fun rl () Int)
(declare-fun rr_primed () Int)
(declare-fun rr () Int)
(declare-fun flted_33_4366 () Int)
(declare-fun ln () Int)
(declare-fun Anon_4402 () Int)
(declare-fun v_4384 () Int)
(declare-fun p_4403 () Int)
(declare-fun l_primed () Int)
(declare-fun q_4406 () Int)
(declare-fun rl_primed () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun rlm () Int)
(declare-fun ln_4365 () Int)
(declare-fun h_4382 () Int)
(declare-fun height1_4392 () Int)
(declare-fun height1_4405 () Int)
(declare-fun height2_4408 () Int)
(declare-fun size1_4391 () Int)
(declare-fun size2_4407 () Int)
(declare-fun size1_4404 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= height2_4395 flted_33_4366))
(assert (= size2_4394 rrm))
(assert (= q_4393 rr_primed))
(assert (= p_4390 tmp_4385))
(assert (= Anon_4389 v_4384))
(assert (= res v_node_43_3531_primed))
(assert (= h_4386 (+ 1 h_4382)))
(assert (= h_4382 (+ 1 n)))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (<= 0 ln))
(assert (<= 0 lm))
(assert (= n ln))
(assert (= m lm))
(assert (= l_primed l))
(assert (= rl_primed rl))
(assert (= rr_primed rr))
(assert (= flted_33_4366 (+ 1 ln)))
(assert (= ln_4365 ln))
(assert (= v_4384 10))
(assert (= Anon_4402 v_4384))
(assert (= p_4403 l_primed))
(assert (= q_4406 rl_primed))
(assert (= size1_4404 m))
(assert (= height1_4405 n))
(assert (= size2_4407 rlm))
(assert (= height2_4408 ln_4365))
(assert (<= height1_4405 (+ 1 height2_4408)))
(assert (<= height2_4408 (+ 1 height1_4405)))
(assert (or (and (= h_4382 (+ height1_4405 1)) (<= height2_4408 height1_4405)) (and (= h_4382 (+ height2_4408 1)) (< height1_4405 height2_4408))))
(assert (= h_4382 height1_4392))
(assert (exists ((max_33 Int)) (and (= height1_4392 (+ 1 max_33)) (or (and (= max_33 height1_4405) (>= height1_4405 height2_4408)) (and (= max_33 height2_4408) (< height1_4405 height2_4408))))))
(assert (= size1_4391 (+ (+ size2_4407 1) size1_4404)))
;Negation of Consequence
(assert (not false))
(check-sat)