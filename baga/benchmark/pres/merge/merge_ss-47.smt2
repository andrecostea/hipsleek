(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun p_2318 () Int)
(declare-fun d_2317 () Int)
(declare-fun v_bool_74_1484_primed () Int)
(declare-fun p_2305 () Int)
(declare-fun bg_2302 () Int)
(declare-fun sm_2301 () Int)
(declare-fun bg () Int)
(declare-fun sm () Int)
(declare-fun d_2304 () Int)
(declare-fun n () Int)
(declare-fun flted_9_2303 () Int)
(declare-fun xs () Int)
(declare-fun c_primed () Int)
(declare-fun sm_2313 () Int)
(declare-fun bg_2314 () Int)
(declare-fun n_2312 () Int)
(declare-fun n_2339 () Int)
(declare-fun n2_2359 () Int)
(declare-fun sm_2355 () Int)
(declare-fun bg_2356 () Int)
(declare-fun sm_2340 () Int)
(declare-fun bg_2341 () Int)
(declare-fun middle_primed () Int)
(declare-fun sm_2365 () Int)
(declare-fun bg_2366 () Int)
(declare-fun n_2364 () Int)
(declare-fun smres_2369 () Int)
(declare-fun bgres_2370 () Int)
(declare-fun n_2354 () Int)
(declare-fun smres_2372 () Int)
(declare-fun bgres_2373 () Int)
(declare-fun n_2371 () Int)
(declare-fun s2_primed () Int)
(declare-fun res () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_9_2303 1) n_2312))
(assert (<= sm_2313 d_2317))
(assert (<= d_2317 bg_2314))
(assert (= sm_2301 sm_2313))
(assert (= bg_2302 bg_2314))
(assert (<= sm_2301 d_2317))
(assert (<= d_2317 bg_2302))
(assert (= p_2318 p_2305))
(assert (= d_2317 d_2304))
(assert (> v_bool_74_1484_primed 0))
(assert (> p_2305 0))
(assert (< 0 n))
(assert (= bg_2302 bg))
(assert (= sm_2301 sm))
(assert (<= d_2304 bg))
(assert (<= sm d_2304))
(assert (= (+ flted_9_2303 1) n))
(assert (<= 0 flted_9_2303))
(assert (> xs 0))
(assert (= c_primed n_2312))
(assert (= (+ middle_primed middle_primed) c_primed))
(assert (= n_2339 n_2312))
(assert (= sm_2340 sm_2313))
(assert (= bg_2341 bg_2314))
(assert (<= 0 n_2312))
(assert (= n_2339 (+ n2_2359 middle_primed)))
(assert (< 0 middle_primed))
(assert (< 0 n2_2359))
(assert (<= 0 n_2339))
(assert (= n_2354 n2_2359))
(assert (= sm_2355 sm_2340))
(assert (= bg_2356 bg_2341))
(assert (<= 0 n2_2359))
(assert (<= sm_2355 smres_2369))
(assert (<= bgres_2370 bg_2356))
(assert (<= 0 n_2354))
(assert (= n_2364 middle_primed))
(assert (= sm_2365 sm_2340))
(assert (= bg_2366 bg_2341))
(assert (<= 0 middle_primed))
(assert (<= sm_2365 smres_2372))
(assert (<= bgres_2373 bg_2366))
(assert (= n_2371 n_2364))
(assert (<= 0 n_2364))
(assert (or (and (and (= bgres_2370 smres_2369) (= n_2354 1)) (> s2_primed 0)) (and (and (<= smres_2369 bgres_2370) (<= 2 n_2354)) (> s2_primed 0))))
(assert (or (and (and (= bgres_2373 smres_2372) (= n_2371 1)) (> res 0)) (and (and (<= smres_2372 bgres_2373) (<= 2 n_2371)) (> res 0))))
(assert (not (= s2_primed res)))
;Negation of Consequence
(assert (not false))
(check-sat)