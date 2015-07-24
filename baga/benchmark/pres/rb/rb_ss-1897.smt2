(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nr_13446 () Int)
(declare-fun r_13445 () Int)
(declare-fun c_primed () Int)
(declare-fun l_13514 () Int)
(declare-fun a_primed () Int)
(declare-fun flted_224_13430 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_224_13432 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun bhr_13447 () Int)
(declare-fun r_13518 () Int)
(declare-fun b_primed () Int)
(declare-fun flted_224_13431 () Int)
(declare-fun ha () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nr_13446 nc))
(assert (= r_13445 c_primed))
(assert (= a_primed a))
(assert (= c_primed c))
(assert (= flted_224_13432 0))
(assert (= flted_224_13430 0))
(assert (= l_13514 a_primed))
(assert (or (and (and (and (= flted_224_13430 0) (<= 2 ha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha 1)) (= flted_224_13430 0)) (and (and (and (= flted_224_13430 1) (<= 1 ha)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_224_13432 0) (<= 2 ha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= ha 1)) (= flted_224_13432 0)) (and (and (and (= flted_224_13432 1) (<= 1 ha)) (<= 1 na)) (> a 0)))))
(assert (= flted_224_13431 0))
(assert (= bhr_13447 ha))
(assert (= b_primed b))
(assert (= r_13518 b_primed))
(assert (or (and (and (and (= flted_224_13431 0) (<= 2 ha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha 1)) (= flted_224_13431 0)) (and (and (and (= flted_224_13431 1) (<= 1 ha)) (<= 1 nb)) (> b 0)))))
;Negation of Consequence
(assert (not (or (= nb 0) (< b 1))))
(check-sat)