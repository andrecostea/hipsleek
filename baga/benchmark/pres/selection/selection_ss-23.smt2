(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_9_1772 () Int)
(declare-fun tmi_1775 () Int)
(declare-fun mi () Int)
(declare-fun sm_1770 () Int)
(declare-fun s () Int)
(declare-fun bg_1771 () Int)
(declare-fun l () Int)
(declare-fun x () Int)
(declare-fun n () Int)
(declare-fun v_bool_23_1525_primed () Int)
(declare-fun d_1773 () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_bool_28_1524_primed () Int)
(declare-fun s_1792 () Int)
(declare-fun mi_1794 () Int)
(declare-fun l_1793 () Int)
(declare-fun n_1791 () Int)
(declare-fun x_primed () Int)
(declare-fun p_1774 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> p_1774 0))
(assert (< mi_1794 l_1793))
(assert (<= s_1792 mi_1794))
(assert (<= 1 n_1791))
(assert (= tmp_primed mi_1794))
(assert (< tmi_1775 bg_1771))
(assert (<= sm_1770 tmi_1775))
(assert (<= 1 flted_9_1772))
(assert (= mi_1794 tmi_1775))
(assert (= l_1793 bg_1771))
(assert (= s_1792 sm_1770))
(assert (= n_1791 flted_9_1772))
(assert (= (+ flted_9_1772 1) n))
(assert (<= s d_1773))
(assert (< d_1773 l))
(assert (or (and (= mi d_1773) (< d_1773 tmi_1775)) (and (= mi tmi_1775) (>= d_1773 tmi_1775))))
(assert (<= s mi))
(assert (< mi l))
(assert (= sm_1770 s))
(assert (= bg_1771 l))
(assert (= x_primed x))
(assert (< 0 n))
(assert (not (> v_bool_23_1525_primed 0)))
(assert (< d_1773 tmp_primed))
(assert (> v_bool_28_1524_primed 0))
(assert (= x_primed 1))
(assert (or (and (and (and (= n_1791 1) (<= s_1792 mi_1794)) (< mi_1794 l_1793)) (> p_1774 0)) (and (and (and (<= s_1792 mi_1794) (< mi_1794 l_1793)) (<= 2 n_1791)) (> p_1774 0))))
(assert (not (= x_primed p_1774)))
;Negation of Consequence
(assert (not false))
(check-sat)