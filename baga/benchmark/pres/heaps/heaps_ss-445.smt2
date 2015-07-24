(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_44_1853_primed () Int)
(declare-fun left_44_1852_primed () Int)
(declare-fun nright_44_1851_primed () Int)
(declare-fun nleft_44_1850_primed () Int)
(declare-fun val_44_1849_primed () Int)
(declare-fun mx_3926 () Int)
(declare-fun n_3925 () Int)
(declare-fun tmpv_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun r_3853 () Int)
(declare-fun t () Int)
(declare-fun v () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun t_primed () Int)
(declare-fun v_bool_27_1962_primed () Int)
(declare-fun m2_3847 () Int)
(declare-fun m3_3848 () Int)
(declare-fun mx () Int)
(declare-fun mx2_3855 () Int)
(declare-fun n () Int)
(declare-fun d_3849 () Int)
(declare-fun v_primed () Int)
(declare-fun v_bool_30_1961_primed () Int)
(declare-fun m2_3854 () Int)
(declare-fun m1_3851 () Int)
(declare-fun v_bool_32_1871_primed () Int)
(declare-fun mx1_3852 () Int)
(declare-fun m1_3846 () Int)
(declare-fun l_3850 () Int)
(declare-fun ma_3939 () Int)
(declare-fun n1_3938 () Int)
(declare-fun v_node_44_1848_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_44_1853_primed r_3853))
(assert (= left_44_1852_primed l_3850))
(assert (= nright_44_1851_primed m2_3854))
(assert (= nleft_44_1850_primed m1_3851))
(assert (= val_44_1849_primed d_3849))
(assert (<= 0 mx_3926))
(assert (<= 0 n_3925))
(assert (or (and (<= mx_3926 tmpv_primed) (= ma_3939 tmpv_primed)) (= ma_3939 mx_3926)))
(assert (= n1_3938 (+ 1 n_3925)))
(assert (<= 0 mx2_3855))
(assert (<= 0 m2_3847))
(assert (= mx_3926 mx2_3855))
(assert (= n_3925 m2_3847))
(assert (= tmpv_primed d_3849))
(assert (= tmp_primed r_3853))
(assert (= t_primed t))
(assert (= v_primed v))
(assert (<= 0 v))
(assert (< tmp_null_primed 1))
(assert (> t_primed 0))
(assert (not (> v_bool_27_1962_primed 0)))
(assert (= m2_3847 m2_3854))
(assert (= m1_3846 m1_3851))
(assert (<= m3_3848 1))
(assert (<= 0 m3_3848))
(assert (= (+ m3_3848 m2_3854) m1_3851))
(assert (<= d_3849 mx))
(assert (<= mx2_3855 d_3849))
(assert (<= mx1_3852 d_3849))
(assert (<= 0 d_3849))
(assert (= n (+ (+ m2_3854 1) m1_3851)))
(assert (< d_3849 v_primed))
(assert (> v_bool_30_1961_primed 0))
(assert (< m2_3854 m1_3851))
(assert (not (> v_bool_32_1871_primed 0)))
(assert (or (and (and (< l_3850 1) (= m1_3846 0)) (= mx1_3852 0)) (and (and (<= 0 mx1_3852) (<= 1 m1_3846)) (> l_3850 0))))
(assert (or (and (and (< v_node_44_1848_primed 1) (= n1_3938 0)) (= ma_3939 0)) (and (and (<= 0 ma_3939) (<= 1 n1_3938)) (> v_node_44_1848_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)