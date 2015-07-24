(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun na () Int)
(declare-fun l_10575 () Int)
(declare-fun b_primed () Int)
(declare-fun nl_10576 () Int)
(declare-fun Anon_20 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_12_9866 () Int)
(declare-fun nr_9874 () Int)
(declare-fun r_9873 () Int)
(declare-fun flted_12_9867 () Int)
(declare-fun nl_9871 () Int)
(declare-fun l_9870 () Int)
(declare-fun bhl_10577 () Int)
(declare-fun bhl_9872 () Int)
(declare-fun bhr_9875 () Int)
(declare-fun ha_9876 () Int)
(declare-fun ha () Int)
(declare-fun r_10578 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_137_9878 () Int)
(declare-fun ha_9877 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= b_primed b))
(assert (= na (+ (+ nr_9874 1) nl_9871)))
(assert (= flted_12_9866 0))
(assert (= flted_12_9867 0))
(assert (= l_10575 b_primed))
(assert (= nl_10576 nb))
(assert (or (and (and (and (= Anon_20 0) (<= 2 ha_9876)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha_9876 1)) (= Anon_20 0)) (and (and (and (= Anon_20 1) (<= 1 ha_9876)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_12_9866 0) (<= 2 bhr_9875)) (<= 1 nr_9874)) (> r_9873 0)) (or (and (and (and (< r_9873 1) (= nr_9874 0)) (= bhr_9875 1)) (= flted_12_9866 0)) (and (and (and (= flted_12_9866 1) (<= 1 bhr_9875)) (<= 1 nr_9874)) (> r_9873 0)))))
(assert (or (and (and (and (= flted_12_9867 0) (<= 2 bhl_9872)) (<= 1 nl_9871)) (> l_9870 0)) (or (and (and (and (< l_9870 1) (= nl_9871 0)) (= bhl_9872 1)) (= flted_12_9867 0)) (and (and (and (= flted_12_9867 1) (<= 1 bhl_9872)) (<= 1 nl_9871)) (> l_9870 0)))))
(assert (= bhl_10577 ha_9876))
(assert (= bhl_9872 ha))
(assert (= bhr_9875 ha))
(assert (= flted_137_9878 0))
(assert (= ha_9876 ha))
(assert (= ha_9877 ha))
(assert (= c_primed c))
(assert (= r_10578 c_primed))
(assert (or (and (and (and (= flted_137_9878 0) (<= 2 ha_9877)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha_9877 1)) (= flted_137_9878 0)) (and (and (and (= flted_137_9878 1) (<= 1 ha_9877)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not (or (= nc 0) (< c 1))))
(check-sat)