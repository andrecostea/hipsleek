(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_7488 () Int)
(declare-fun nr_7487 () Int)
(declare-fun nd () Int)
(declare-fun bhl_7485 () Int)
(declare-fun nl_7484 () Int)
(declare-fun nc () Int)
(declare-fun r_7486 () Int)
(declare-fun l_7483 () Int)
(declare-fun v_7482 () Int)
(declare-fun v_int_161_7343 () Int)
(declare-fun v_int_161_7342 () Int)
(declare-fun flted_153_7338 () Int)
(declare-fun flted_153_7339 () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun d_primed () Int)
(declare-fun d () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun b_primed () Int)
(declare-fun a_primed () Int)
(declare-fun flted_153_7341 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_153_7340 () Int)
(declare-fun h () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_7488 h))
(assert (= nr_7487 nd))
(assert (= bhl_7485 h))
(assert (= nl_7484 nc))
(assert (= r_7486 d_primed))
(assert (= l_7483 c_primed))
(assert (= v_7482 v_int_161_7342))
(assert (= v_int_161_7343 1))
(assert (= v_int_161_7342 0))
(assert (= color 0))
(assert (= flted_153_7338 0))
(assert (= flted_153_7339 0))
(assert (= flted_153_7340 0))
(assert (= flted_153_7341 0))
(assert (= color_primed color))
(assert (= d_primed d))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (or (and (and (and (= flted_153_7341 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_153_7341 0)) (and (and (and (= flted_153_7341 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_153_7340 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_153_7340 0)) (and (and (and (= flted_153_7340 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)