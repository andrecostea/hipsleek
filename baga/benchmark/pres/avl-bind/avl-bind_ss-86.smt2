(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_94_2210_primed () Int)
(declare-fun n_2860 () Int)
(declare-fun n2_2869 () Int)
(declare-fun n1_2866 () Int)
(declare-fun h_2851 () Int)
(declare-fun h_2831 () Int)
(declare-fun n_2815 () Int)
(declare-fun n () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun h_2857 () Int)
(declare-fun an_2810 () Int)
(declare-fun cn () Int)
(declare-fun h_primed () Int)
(declare-fun n_2841 () Int)
(declare-fun n_2834 () Int)
(declare-fun n_2883 () Int)
(declare-fun n1_2889 () Int)
(declare-fun n2_2892 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_2860))
(assert (= v_int_94_2210_primed n_2860))
(assert (exists ((max_2909 Int)) (and (= n_2860 (+ 1 max_2909)) (or (and (= max_2909 n1_2866) (>= n1_2866 n2_2869)) (and (= max_2909 n2_2869) (< n1_2866 n2_2869))))))
(assert (= h_2851 n_2860))
(assert (or (and (= h_2851 (+ n1_2866 1)) (<= n2_2869 n1_2866)) (and (= h_2851 (+ n2_2869 1)) (< n1_2866 n2_2869))))
(assert (<= (+ 0 n2_2869) (+ n1_2866 1)))
(assert (<= n1_2866 (+ 1 n2_2869)))
(assert (= n2_2869 n_2815))
(assert (= n1_2866 n))
(assert (<= 0 n))
(assert (<= 0 n_2815))
(assert (= h_2851 (+ 1 h_2831)))
(assert (or (and (= h_2831 n) (>= n n_2815)) (and (= h_2831 n_2815) (< n n_2815))))
(assert (<= 0 bn))
(assert (= n_2815 bn))
(assert (<= 0 an))
(assert (= n an))
(assert (= an_2810 an))
(assert (<= bn (+ 1 cn)))
(assert (<= (+ 0 cn) (+ bn 1)))
(assert (or (and (= an bn) (>= bn cn)) (and (= an cn) (< bn cn))))
(assert (<= 0 n_2834))
(assert (<= 0 n_2841))
(assert (= h_primed (+ 1 h_2857)))
(assert (or (and (= h_2857 n_2834) (>= n_2834 n_2841)) (and (= h_2857 n_2841) (< n_2834 n_2841))))
(assert (<= 0 an_2810))
(assert (= n_2841 an_2810))
(assert (<= 0 cn))
(assert (= n_2834 cn))
(assert (exists ((max_2910 Int)) (and (= n_2883 (+ 1 max_2910)) (or (and (= max_2910 n1_2889) (>= n1_2889 n2_2892)) (and (= max_2910 n2_2892) (< n1_2889 n2_2892))))))
(assert (= h_primed n_2883))
(assert (or (and (= h_primed (+ n1_2889 1)) (<= n2_2892 n1_2889)) (and (= h_primed (+ n2_2892 1)) (< n1_2889 n2_2892))))
(assert (<= (+ 0 n2_2892) (+ n1_2889 1)))
(assert (<= n1_2889 (+ 1 n2_2892)))
(assert (= n2_2892 n_2841))
(assert (= n1_2889 n_2834))
;Negation of Consequence
(assert (not (or (and (= n_2883 (+ n1_2889 1)) (<= n2_2892 n1_2889)) (and (= n_2883 (+ n2_2892 1)) (< n1_2889 n2_2892)))))
(check-sat)