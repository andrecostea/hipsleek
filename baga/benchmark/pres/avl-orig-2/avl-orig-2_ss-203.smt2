(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_61 () Int)
(declare-fun bm_3518 () Int)
(declare-fun rl () Int)
(declare-fun Anon_60 () Int)
(declare-fun Anon_58 () Int)
(declare-fun an_3516 () Int)
(declare-fun am_3515 () Int)
(declare-fun l_3514 () Int)
(declare-fun bm () Int)
(declare-fun Anon_33 () Int)
(declare-fun am () Int)
(declare-fun a () Int)
(declare-fun Anon_3502 () Int)
(declare-fun am_3459 () Int)
(declare-fun resl_3501 () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun resn_3510 () Int)
(declare-fun bn_3519 () Int)
(declare-fun tmp2_3511 () Int)
(declare-fun an_3460 () Int)
(declare-fun dm () Int)
(declare-fun q_3530 () Int)
(declare-fun Anon_3508 () Int)
(declare-fun cm_3457 () Int)
(declare-fun resrr_3507 () Int)
(declare-fun dn () Int)
(declare-fun resrn_3512 () Int)
(declare-fun tmp1_3509 () Int)
(declare-fun cn_3458 () Int)
(declare-fun cn () Int)
(declare-fun cm () Int)
(declare-fun p_3526 () Int)
(declare-fun Anon_3506 () Int)
(declare-fun bm_3461 () Int)
(declare-fun bn_3462 () Int)
(declare-fun resrl_3505 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_61 Anon_3502))
(assert (= bm_3518 am_3459))
(assert (= rl resl_3501))
(assert (= Anon_60 resn_3510))
(assert (= Anon_58 Anon_33))
(assert (= an_3516 an))
(assert (= am_3515 am))
(assert (= l_3514 a))
(assert (<= 0 am_3459))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= am_3459 bm))
(assert (or (and (and (and (< a 1) (= am 0)) (= an 0)) (= Anon_33 1)) (and (and (and (and (and (<= 0 Anon_33) (<= (+ (- 0 an) 2) Anon_33)) (<= Anon_33 an)) (<= Anon_33 2)) (<= 1 am)) (> a 0))))
(assert (or (and (and (and (< resl_3501 1) (= am_3459 0)) (= an_3460 0)) (= Anon_3502 1)) (and (and (and (and (and (<= 0 Anon_3502) (<= (+ (- 0 an_3460) 2) Anon_3502)) (<= Anon_3502 an_3460)) (<= Anon_3502 2)) (<= 1 am_3459)) (> resl_3501 0))))
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (= an_3460 bn))
(assert (= resn_3510 (+ 1 tmp2_3511)))
(assert (= bn_3519 an_3460))
(assert (<= 0 an_3460))
(assert (<= 0 cm_3457))
(assert (or (and (= tmp2_3511 an_3460) (>= an_3460 resrn_3512)) (and (= tmp2_3511 resrn_3512) (< an_3460 resrn_3512))))
(assert (<= 0 dn))
(assert (<= 0 dm))
(assert (= cm_3457 dm))
(assert (= q_3530 resrr_3507))
(assert (or (and (and (and (< resrr_3507 1) (= cm_3457 0)) (= cn_3458 0)) (= Anon_3508 1)) (and (and (and (and (and (<= 0 Anon_3508) (<= (+ (- 0 cn_3458) 2) Anon_3508)) (<= Anon_3508 cn_3458)) (<= Anon_3508 2)) (<= 1 cm_3457)) (> resrr_3507 0))))
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (= cn_3458 dn))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (= resrn_3512 (+ 1 tmp1_3509)))
(assert (<= 0 cn_3458))
(assert (<= 0 bn_3462))
(assert (<= 0 bm_3461))
(assert (or (and (= tmp1_3509 cn_3458) (>= cn_3458 bn_3462)) (and (= tmp1_3509 bn_3462) (< cn_3458 bn_3462))))
(assert (= bn_3462 cn))
(assert (= bm_3461 cm))
(assert (= p_3526 resrl_3505))
(assert (or (and (and (and (< resrl_3505 1) (= bm_3461 0)) (= bn_3462 0)) (= Anon_3506 1)) (and (and (and (and (and (<= 0 Anon_3506) (<= (+ (- 0 bn_3462) 2) Anon_3506)) (<= Anon_3506 bn_3462)) (<= Anon_3506 2)) (<= 1 bm_3461)) (> resrl_3505 0))))
;Negation of Consequence
(assert (not (or (= bm_3461 0) (or (= bn_3462 0) (< resrl_3505 1)))))
(check-sat)