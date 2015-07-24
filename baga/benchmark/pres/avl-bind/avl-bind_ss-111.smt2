(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun h_2857 () Int)
(declare-fun h_2920 () Int)
(declare-fun n2_2892 () Int)
(declare-fun n1_2889 () Int)
(declare-fun h_2851 () Int)
(declare-fun n2_2869 () Int)
(declare-fun n1_2866 () Int)
(declare-fun h_2831 () Int)
(declare-fun n_2815 () Int)
(declare-fun n_2834 () Int)
(declare-fun n_2841 () Int)
(declare-fun n_2860 () Int)
(declare-fun n_2883 () Int)
(declare-fun n1_2936 () Int)
(declare-fun n2_2939 () Int)
(declare-fun h_2926 () Int)
(declare-fun n () Int)
(declare-fun bn () Int)
(declare-fun cn () Int)
(declare-fun an_2810 () Int)
(declare-fun h_2930 () Int)
(declare-fun an () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_2834))
(assert (<= 0 n_2841))
(assert (<= 0 n_2815))
(assert (= h_2920 (+ 1 h_2857)))
(assert (or (and (= h_2857 n_2834) (>= n_2834 n_2841)) (and (= h_2857 n_2841) (< n_2834 n_2841))))
(assert (= h_2851 (+ 1 h_2831)))
(assert (<= 0 n_2860))
(assert (<= 0 n_2883))
(assert (exists ((max_2989 Int)) (and (= n_2883 (+ 1 max_2989)) (or (and (= max_2989 n1_2889) (>= n1_2889 n2_2892)) (and (= max_2989 n2_2892) (< n1_2889 n2_2892))))))
(assert (= h_2920 n_2883))
(assert (or (and (= h_2920 (+ n1_2889 1)) (<= n2_2892 n1_2889)) (and (= h_2920 (+ n2_2892 1)) (< n1_2889 n2_2892))))
(assert (<= (+ 0 n2_2892) (+ n1_2889 1)))
(assert (<= n1_2889 (+ 1 n2_2892)))
(assert (= n2_2892 n_2841))
(assert (= n1_2889 n_2834))
(assert (exists ((max_2990 Int)) (and (= n_2860 (+ 1 max_2990)) (or (and (= max_2990 n1_2866) (>= n1_2866 n2_2869)) (and (= max_2990 n2_2869) (< n1_2866 n2_2869))))))
(assert (= h_2851 n_2860))
(assert (or (and (= h_2851 (+ n1_2866 1)) (<= n2_2869 n1_2866)) (and (= h_2851 (+ n2_2869 1)) (< n1_2866 n2_2869))))
(assert (<= (+ 0 n2_2869) (+ n1_2866 1)))
(assert (<= n1_2866 (+ 1 n2_2869)))
(assert (= n2_2869 n_2815))
(assert (= n1_2866 n))
(assert (<= bn (+ 1 cn)))
(assert (<= (+ 0 cn) (+ bn 1)))
(assert (= n_2815 bn))
(assert (<= 0 bn))
(assert (or (and (= h_2831 n) (>= n n_2815)) (and (= h_2831 n_2815) (< n n_2815))))
(assert (= n_2834 cn))
(assert (<= 0 cn))
(assert (= n_2841 an_2810))
(assert (<= 0 an_2810))
(assert (<= 0 n))
(assert (or (and (= h_2926 n_2860) (>= n_2860 n_2883)) (and (= h_2926 n_2883) (< n_2860 n_2883))))
(assert (= n1_2936 n_2860))
(assert (= n2_2939 n_2883))
(assert (exists ((max_2991 Int)) (and (= h_2930 (+ 1 max_2991)) (or (and (= max_2991 n1_2936) (>= n1_2936 n2_2939)) (and (= max_2991 n2_2939) (< n1_2936 n2_2939))))))
(assert (= h_2930 (+ 1 h_2926)))
(assert (<= 0 an))
(assert (= n an))
(assert (or (and (= an bn) (>= bn cn)) (and (= an cn) (< bn cn))))
(assert (= an_2810 an))
;Negation of Consequence
(assert (not (= h_2930 (+ an 2))))
(check-sat)