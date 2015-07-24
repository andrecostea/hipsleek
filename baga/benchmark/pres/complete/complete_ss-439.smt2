(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_103_1427_primed () Int)
(declare-fun v_bool_95_1428_primed () Int)
(declare-fun v_bool_88_1429_primed () Int)
(declare-fun v_bool_83_1430_primed () Int)
(declare-fun nmin () Int)
(declare-fun n () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun t () Int)
(declare-fun nmin1_2688 () Int)
(declare-fun flted_26_2685 () Int)
(declare-fun nmin_2694 () Int)
(declare-fun n_2693 () Int)
(declare-fun nmin2_2690 () Int)
(declare-fun flted_26_2684 () Int)
(declare-fun nmin_2733 () Int)
(declare-fun n_2732 () Int)
(declare-fun tmp_primed () Int)
(declare-fun nmin_2706 () Int)
(declare-fun n_2705 () Int)
(declare-fun nmin_2745 () Int)
(declare-fun n_2744 () Int)
(declare-fun aux_2818 () Int)
(declare-fun l_2687 () Int)
(declare-fun nmin_2776 () Int)
(declare-fun n_2775 () Int)
(declare-fun nmin_2807 () Int)
(declare-fun n_2806 () Int)
(declare-fun t_primed () Int)
(declare-fun nmin_2788 () Int)
(declare-fun n_2787 () Int)
(declare-fun r_2689 () Int)
(declare-fun nmin1_2820 () Int)
(declare-fun flted_79_2819 () Int)
(declare-fun aux_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_103_1427_primed 0))
(assert (not (> v_bool_95_1428_primed 0)))
(assert (<= n_2744 nmin_2733))
(assert (not (> v_bool_88_1429_primed 0)))
(assert (<= n_2705 nmin_2694))
(assert (= (+ flted_26_2685 1) n))
(assert (= (+ flted_26_2684 1) n))
(assert (exists ((min_32 Int)) (and (= nmin (+ 1 min_32)) (or (and (= min_32 nmin1_2688) (< nmin1_2688 nmin2_2690)) (and (= min_32 nmin2_2690) (>= nmin1_2688 nmin2_2690))))))
(assert (not (> v_bool_83_1430_primed 0)))
(assert (> t_primed 0))
(assert (= nmin n))
(assert (= v_primed v))
(assert (= t_primed t))
(assert (= n_2693 flted_26_2685))
(assert (= nmin_2694 nmin1_2688))
(assert (<= 0 nmin1_2688))
(assert (<= nmin1_2688 flted_26_2685))
(assert (= n_2705 n_2693))
(assert (= nmin_2706 nmin_2694))
(assert (<= 0 nmin_2694))
(assert (<= nmin_2694 n_2693))
(assert (= n_2732 flted_26_2684))
(assert (= nmin_2733 nmin2_2690))
(assert (<= 0 nmin2_2690))
(assert (<= nmin2_2690 flted_26_2684))
(assert (= n_2744 n_2732))
(assert (= nmin_2745 nmin_2733))
(assert (<= 0 nmin_2733))
(assert (<= nmin_2733 n_2732))
(assert (= tmp_primed r_2689))
(assert (= n_2775 n_2705))
(assert (= nmin_2776 nmin_2706))
(assert (<= 0 nmin_2706))
(assert (<= nmin_2706 n_2705))
(assert (= n_2787 n_2775))
(assert (= n_2787 n_2744))
(assert (= nmin_2788 nmin_2745))
(assert (<= 0 nmin_2745))
(assert (<= nmin_2745 n_2744))
(assert (<= 0 nmin_2788))
(assert (<= nmin_2788 n_2787))
(assert (= aux_2818 l_2687))
(assert (= n_2806 n_2775))
(assert (= nmin_2807 nmin_2776))
(assert (<= 0 nmin_2776))
(assert (<= nmin_2776 n_2775))
(assert (= flted_79_2819 (+ 1 n_2806)))
(assert (or (= nmin1_2820 nmin_2807) (= nmin1_2820 (+ 1 nmin_2807))))
(assert (<= 0 nmin_2807))
(assert (<= nmin_2807 n_2806))
(assert (= t_primed 1))
(assert (or (and (and (<= 1 nmin_2788) (<= nmin_2788 n_2787)) (> r_2689 0)) (or (and (and (< r_2689 1) (= n_2787 0)) (= nmin_2788 0)) (and (and (<= 1 nmin_2788) (< nmin_2788 n_2787)) (> r_2689 0)))))
(assert (or (and (and (<= 1 nmin1_2820) (<= nmin1_2820 flted_79_2819)) (> aux_primed 0)) (or (and (and (< aux_primed 1) (= flted_79_2819 0)) (= nmin1_2820 0)) (and (and (<= 1 nmin1_2820) (< nmin1_2820 flted_79_2819)) (> aux_primed 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)