(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_334_2396_primed () Int)
(declare-fun height_327_6331 () Int)
(declare-fun height_5421 () Int)
(declare-fun n_6361 () Int)
(declare-fun height2_6370 () Int)
(declare-fun height1_6367 () Int)
(declare-fun n () Int)
(declare-fun height2_5428 () Int)
(declare-fun n_5916 () Int)
(declare-fun height1_5425 () Int)
(declare-fun height_332_6359 () Int)
(declare-fun h_6350 () Int)
(declare-fun h_6328 () Int)
(declare-fun hl_primed () Int)
(declare-fun n_6309 () Int)
(declare-fun hr_6345 () Int)
(declare-fun n_6275 () Int)
(declare-fun n_5951 () Int)
(declare-fun n1_5930 () Int)
(declare-fun height_6011 () Int)
(declare-fun height1_6254 () Int)
(declare-fun height_6250 () Int)
(declare-fun n_5939 () Int)
(declare-fun height2_6018 () Int)
(declare-fun height1_6015 () Int)
(declare-fun n_6035 () Int)
(declare-fun n_6176 () Int)
(declare-fun n_6022 () Int)
(declare-fun h_6356 () Int)
(declare-fun hr_primed () Int)
(declare-fun n_6195 () Int)
(declare-fun hlt_primed () Int)
(declare-fun height2_6257 () Int)
(declare-fun h_primed () Int)
(declare-fun n_6337 () Int)
(declare-fun n_6292 () Int)
(declare-fun n_6417 () Int)
(declare-fun height1_6423 () Int)
(declare-fun height2_6426 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_6361))
(assert (= v_int_334_2396_primed n_6361))
(assert (= height_327_6331 height_5421))
(assert (<= 0 height1_5425))
(assert (<= 0 n_5916))
(assert (<= 0 height2_5428))
(assert (= height_5421 n))
(assert (exists ((max_6473 Int)) (and (= n_6361 (+ 1 max_6473)) (or (and (= max_6473 height1_6367) (>= height1_6367 height2_6370)) (and (= max_6473 height2_6370) (< height1_6367 height2_6370))))))
(assert (= h_6350 n_6361))
(assert (or (and (= h_6350 (+ height1_6367 1)) (<= height2_6370 height1_6367)) (and (= h_6350 (+ height2_6370 1)) (< height1_6367 height2_6370))))
(assert (<= height2_6370 (+ 1 height1_6367)))
(assert (<= height1_6367 (+ 1 height2_6370)))
(assert (= height2_6370 n_6275))
(assert (= height1_6367 n_6309))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (exists ((max_6470 Int)) (and (= n (+ 1 max_6470)) (or (and (= max_6470 height1_5425) (>= height1_5425 height2_5428)) (and (= max_6470 height2_5428) (< height1_5425 height2_5428))))))
(assert (= n_5916 height2_5428))
(assert (<= n_5916 n1_5930))
(assert (<= n1_5930 (+ 1 n_5916)))
(assert (= n_5951 height1_5425))
(assert (<= 0 n_6309))
(assert (<= 0 n_6275))
(assert (= height_332_6359 height_6011))
(assert (= h_6350 (+ 1 h_6328)))
(assert (or (and (= h_6328 hl_primed) (>= hl_primed hr_6345)) (and (= h_6328 hr_6345) (< hl_primed hr_6345))))
(assert (= hl_primed n_6309))
(assert (<= 0 n_5951))
(assert (= n_6309 n_5951))
(assert (= hr_6345 n_6275))
(assert (<= 0 height1_6254))
(assert (= n_6275 height1_6254))
(assert (<= 0 n_6022))
(assert (<= 0 n_6035))
(assert (<= 0 height1_6015))
(assert (<= 0 height2_6018))
(assert (= (+ 2 n_5951) n_5939))
(assert (<= 0 n_5939))
(assert (<= 0 n1_5930))
(assert (= n_5939 n1_5930))
(assert (= height_6011 n_5939))
(assert (<= height2_6257 (+ 1 height1_6254)))
(assert (<= height1_6254 (+ 1 height2_6257)))
(assert (exists ((max_6472 Int)) (and (= n_6176 (+ 1 max_6472)) (or (and (= max_6472 height1_6254) (>= height1_6254 height2_6257)) (and (= max_6472 height2_6257) (< height1_6254 height2_6257))))))
(assert (= height_6250 n_6176))
(assert (<= n_6022 n_6035))
(assert (<= height2_6018 (+ 1 height1_6015)))
(assert (<= height1_6015 (+ 1 height2_6018)))
(assert (exists ((max_6471 Int)) (and (= n_5939 (+ 1 max_6471)) (or (and (= max_6471 height1_6015) (>= height1_6015 height2_6018)) (and (= max_6471 height2_6018) (< height1_6015 height2_6018))))))
(assert (= n_6022 height2_6018))
(assert (= n_6035 height1_6015))
(assert (= n_6176 n_6035))
(assert (<= 0 n_6176))
(assert (= (+ n_6195 1) n_6176))
(assert (= n_6195 n_6022))
(assert (<= 0 n_6292))
(assert (<= 0 n_6337))
(assert (= h_primed (+ 1 h_6356)))
(assert (or (and (= h_6356 hlt_primed) (>= hlt_primed hr_primed)) (and (= h_6356 hr_primed) (< hlt_primed hr_primed))))
(assert (= hr_primed n_6337))
(assert (<= 0 n_6195))
(assert (= n_6337 n_6195))
(assert (= hlt_primed n_6292))
(assert (<= 0 height2_6257))
(assert (= n_6292 height2_6257))
(assert (exists ((max_6474 Int)) (and (= n_6417 (+ 1 max_6474)) (or (and (= max_6474 height1_6423) (>= height1_6423 height2_6426)) (and (= max_6474 height2_6426) (< height1_6423 height2_6426))))))
(assert (= h_primed n_6417))
(assert (or (and (= h_primed (+ height1_6423 1)) (<= height2_6426 height1_6423)) (and (= h_primed (+ height2_6426 1)) (< height1_6423 height2_6426))))
(assert (<= height2_6426 (+ 1 height1_6423)))
(assert (<= height1_6423 (+ 1 height2_6426)))
(assert (= height2_6426 n_6337))
(assert (= height1_6423 n_6292))
;Negation of Consequence
(assert (not (or (and (= n_6417 (+ height1_6423 1)) (<= height2_6426 height1_6423)) (and (= n_6417 (+ height2_6426 1)) (< height1_6423 height2_6426)))))
(check-sat)