(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nr_6261 () Int)
(declare-fun nc () Int)
(declare-fun l_6363 () Int)
(declare-fun r_6367 () Int)
(declare-fun nl_6364 () Int)
(declare-fun Anon_6365 () Int)
(declare-fun nr_6368 () Int)
(declare-fun Anon_6369 () Int)
(declare-fun flted_12_6209 () Int)
(declare-fun nl_6213 () Int)
(declare-fun l_6212 () Int)
(declare-fun flted_12_6208 () Int)
(declare-fun nr_6216 () Int)
(declare-fun r_6215 () Int)
(declare-fun bhr_6262 () Int)
(declare-fun bhr_6370 () Int)
(declare-fun bhl_6366 () Int)
(declare-fun bhl_6214 () Int)
(declare-fun bhr_6217 () Int)
(declare-fun h_6219 () Int)
(declare-fun l_6397 () Int)
(declare-fun a_primed () Int)
(declare-fun nl_6398 () Int)
(declare-fun Anon_6399 () Int)
(declare-fun flted_119_6221 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun bhl_6400 () Int)
(declare-fun h () Int)
(declare-fun r_6401 () Int)
(declare-fun b_primed () Int)
(declare-fun Anon_17 () Int)
(declare-fun h_6218 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nr_6261 (+ (+ nr_6368 1) nl_6364)))
(assert (= nc (+ (+ nr_6216 1) nl_6213)))
(assert (= flted_12_6208 0))
(assert (= flted_12_6209 0))
(assert (= l_6363 l_6212))
(assert (= r_6367 r_6215))
(assert (= nl_6364 nl_6213))
(assert (= Anon_6365 flted_12_6209))
(assert (= nr_6368 nr_6216))
(assert (= Anon_6369 flted_12_6208))
(assert (or (and (and (and (= flted_12_6209 0) (<= 2 bhl_6214)) (<= 1 nl_6213)) (> l_6212 0)) (or (and (and (and (< l_6212 1) (= nl_6213 0)) (= bhl_6214 1)) (= flted_12_6209 0)) (and (and (and (= flted_12_6209 1) (<= 1 bhl_6214)) (<= 1 nl_6213)) (> l_6212 0)))))
(assert (or (and (and (and (= flted_12_6208 0) (<= 2 bhr_6217)) (<= 1 nr_6216)) (> r_6215 0)) (or (and (and (and (< r_6215 1) (= nr_6216 0)) (= bhr_6217 1)) (= flted_12_6208 0)) (and (and (and (= flted_12_6208 1) (<= 1 bhr_6217)) (<= 1 nr_6216)) (> r_6215 0)))))
(assert (= bhr_6262 (+ bhl_6366 1)))
(assert (= bhl_6366 bhr_6370))
(assert (= bhr_6370 bhr_6217))
(assert (= bhl_6366 bhl_6214))
(assert (= bhl_6214 h_6219))
(assert (= bhr_6217 h_6219))
(assert (= h_6219 h))
(assert (= flted_119_6221 0))
(assert (= a_primed a))
(assert (= l_6397 a_primed))
(assert (= nl_6398 na))
(assert (= Anon_6399 flted_119_6221))
(assert (or (and (and (and (= flted_119_6221 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_119_6221 0)) (and (and (and (= flted_119_6221 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (= bhl_6400 h))
(assert (= h_6218 h))
(assert (= b_primed b))
(assert (= r_6401 b_primed))
(assert (or (and (and (and (= Anon_17 0) (<= 2 h_6218)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h_6218 1)) (= Anon_17 0)) (and (and (and (= Anon_17 1) (<= 1 h_6218)) (<= 1 nb)) (> b 0)))))
;Negation of Consequence
(assert (not (or (= nb 0) (< b 1))))
(check-sat)