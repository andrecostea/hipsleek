(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_188_5929 () Int)
(declare-fun v_int_187_5927 () Int)
(declare-fun v_int_187_5926 () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun v_5934 () Int)
(declare-fun v_int_188_5928 () Int)
(declare-fun l_5935 () Int)
(declare-fun a_primed () Int)
(declare-fun r_5938 () Int)
(declare-fun flted_182_5925 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_182_5924 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_182_5923 () Int)
(declare-fun ha () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun tmp1_5930 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_int_188_5929 0))
(assert (= v_int_188_5928 0))
(assert (= v_int_187_5927 1))
(assert (= v_int_187_5926 0))
(assert (= flted_182_5923 0))
(assert (= flted_182_5924 0))
(assert (= flted_182_5925 0))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= v_5934 v_int_188_5928))
(assert (= l_5935 a_primed))
(assert (= r_5938 tmp1_5930))
(assert (or (and (and (and (= flted_182_5925 0) (<= 2 ha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= ha 1)) (= flted_182_5925 0)) (and (and (and (= flted_182_5925 1) (<= 1 ha)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_182_5924 0) (<= 2 ha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha 1)) (= flted_182_5924 0)) (and (and (and (= flted_182_5924 1) (<= 1 ha)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_182_5923 0) (<= 2 ha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha 1)) (= flted_182_5923 0)) (and (and (and (= flted_182_5923 1) (<= 1 ha)) (<= 1 nc)) (> c 0)))))
(assert (= tmp1_5930 1))
;Negation of Consequence
(assert (not false))
(check-sat)