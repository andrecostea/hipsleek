(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_13_9753 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun b_primed () Int)
(declare-fun c_primed () Int)
(declare-fun color_primed () Int)
(declare-fun flted_137_9678 () Int)
(declare-fun color () Int)
(declare-fun ha () Int)
(declare-fun v_int_144_4585_primed () Int)
(declare-fun a_primed () Int)
(declare-fun Anon_9757 () Int)
(declare-fun bhl_9758 () Int)
(declare-fun nl_9756 () Int)
(declare-fun l_9755 () Int)
(declare-fun Anon_9761 () Int)
(declare-fun bhr_9762 () Int)
(declare-fun nr_9760 () Int)
(declare-fun r_9759 () Int)
(declare-fun Anon_20 () Int)
(declare-fun ha_9675 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_137_9677 () Int)
(declare-fun ha_9676 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_13_9753 0))
(assert (= flted_137_9678 0))
(assert (= na (+ (+ nr_9760 1) nl_9756)))
(assert (= bhl_9758 bhr_9762))
(assert (= ha (+ bhl_9758 1)))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= color_primed color))
(assert (= flted_137_9678 1))
(assert (= flted_137_9677 0))
(assert (= color 1))
(assert (= ha_9675 ha))
(assert (= ha_9676 ha))
(assert true)
(assert (= v_int_144_4585_primed 0))
(assert (= a_primed 1))
(assert (or (and (and (and (= Anon_9757 0) (<= 2 bhl_9758)) (<= 1 nl_9756)) (> l_9755 0)) (or (and (and (and (< l_9755 1) (= nl_9756 0)) (= bhl_9758 1)) (= Anon_9757 0)) (and (and (and (= Anon_9757 1) (<= 1 bhl_9758)) (<= 1 nl_9756)) (> l_9755 0)))))
(assert (or (and (and (and (= Anon_9761 0) (<= 2 bhr_9762)) (<= 1 nr_9760)) (> r_9759 0)) (or (and (and (and (< r_9759 1) (= nr_9760 0)) (= bhr_9762 1)) (= Anon_9761 0)) (and (and (and (= Anon_9761 1) (<= 1 bhr_9762)) (<= 1 nr_9760)) (> r_9759 0)))))
(assert (or (and (and (and (= Anon_20 0) (<= 2 ha_9675)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha_9675 1)) (= Anon_20 0)) (and (and (and (= Anon_20 1) (<= 1 ha_9675)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_137_9677 0) (<= 2 ha_9676)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha_9676 1)) (= flted_137_9677 0)) (and (and (and (= flted_137_9677 1) (<= 1 ha_9676)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)