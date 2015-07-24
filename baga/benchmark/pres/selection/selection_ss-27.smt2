(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_28_1524_primed () Int)
(declare-fun v_bool_23_1525_primed () Int)
(declare-fun x () Int)
(declare-fun mi () Int)
(declare-fun l () Int)
(declare-fun s () Int)
(declare-fun n () Int)
(declare-fun flted_9_1772 () Int)
(declare-fun sm_1770 () Int)
(declare-fun tmi_1775 () Int)
(declare-fun bg_1771 () Int)
(declare-fun d_1773 () Int)
(declare-fun res () Int)
(declare-fun v_int_29_1523_primed () Int)
(declare-fun s_1792 () Int)
(declare-fun mi_1794 () Int)
(declare-fun l_1793 () Int)
(declare-fun n_1791 () Int)
(declare-fun x_primed () Int)
(declare-fun p_1774 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_28_1524_primed 0))
(assert (< d_1773 mi_1794))
(assert (not (> v_bool_23_1525_primed 0)))
(assert (< 0 n))
(assert (= x_primed x))
(assert (= bg_1771 l))
(assert (= sm_1770 s))
(assert (< mi l))
(assert (<= s mi))
(assert (or (and (= mi d_1773) (< d_1773 tmi_1775)) (and (= mi tmi_1775) (>= d_1773 tmi_1775))))
(assert (< d_1773 l))
(assert (<= s d_1773))
(assert (= (+ flted_9_1772 1) n))
(assert (= n_1791 flted_9_1772))
(assert (= s_1792 sm_1770))
(assert (= l_1793 bg_1771))
(assert (= mi_1794 tmi_1775))
(assert (<= 1 flted_9_1772))
(assert (<= sm_1770 tmi_1775))
(assert (< tmi_1775 bg_1771))
(assert (<= 1 n_1791))
(assert (<= s_1792 mi_1794))
(assert (< mi_1794 l_1793))
(assert (> p_1774 0))
(assert (= v_int_29_1523_primed d_1773))
(assert (= res v_int_29_1523_primed))
(assert (= x_primed 1))
(assert (or (and (and (and (= n_1791 1) (<= s_1792 mi_1794)) (< mi_1794 l_1793)) (> p_1774 0)) (and (and (and (<= s_1792 mi_1794) (< mi_1794 l_1793)) (<= 2 n_1791)) (> p_1774 0))))
(assert (not (= x_primed p_1774)))
;Negation of Consequence
(assert (not false))
(check-sat)