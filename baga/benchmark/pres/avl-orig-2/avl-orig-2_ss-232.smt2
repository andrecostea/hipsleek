(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_3533 () Int)
(declare-fun n2_3532 () Int)
(declare-fun m2_3531 () Int)
(declare-fun Anon_3529 () Int)
(declare-fun n1_3528 () Int)
(declare-fun m1_3527 () Int)
(declare-fun q_3530 () Int)
(declare-fun resrr_3507 () Int)
(declare-fun p_3526 () Int)
(declare-fun resrl_3505 () Int)
(declare-fun Anon_3525 () Int)
(declare-fun Anon_3504 () Int)
(declare-fun k1 () Int)
(declare-fun Anon_44 () Int)
(declare-fun Anon_34 () Int)
(declare-fun Anon_45 () Int)
(declare-fun Anon_35 () Int)
(declare-fun l () Int)
(declare-fun r () Int)
(declare-fun d () Int)
(declare-fun Anon_47 () Int)
(declare-fun Anon_37 () Int)
(declare-fun Anon_48 () Int)
(declare-fun Anon_38 () Int)
(declare-fun ll () Int)
(declare-fun b () Int)
(declare-fun lr () Int)
(declare-fun c () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun Anon_40 () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun Anon_39 () Int)
(declare-fun k3 () Int)
(declare-fun dm () Int)
(declare-fun dn () Int)
(declare-fun Anon_36 () Int)
(declare-fun tmp1_3509 () Int)
(declare-fun tmp2_3511 () Int)
(declare-fun resrn_3512 () Int)
(declare-fun Anon_46 () Int)
(declare-fun Anon_49 () Int)
(declare-fun Anon_50 () Int)
(declare-fun right_179_3513 () Int)
(declare-fun k2 () Int)
(declare-fun Anon_56 () Int)
(declare-fun Anon_31 () Int)
(declare-fun Anon_57 () Int)
(declare-fun Anon_32 () Int)
(declare-fun l_3514 () Int)
(declare-fun a () Int)
(declare-fun r_3517 () Int)
(declare-fun Anon_59 () Int)
(declare-fun Anon_3500 () Int)
(declare-fun Anon_60 () Int)
(declare-fun resn_3510 () Int)
(declare-fun rl () Int)
(declare-fun resl_3501 () Int)
(declare-fun rr () Int)
(declare-fun cm_3457 () Int)
(declare-fun cn_3458 () Int)
(declare-fun Anon_3508 () Int)
(declare-fun bm_3461 () Int)
(declare-fun bn_3462 () Int)
(declare-fun Anon_3506 () Int)
(declare-fun resr_3503 () Int)
(declare-fun am_3459 () Int)
(declare-fun an_3460 () Int)
(declare-fun Anon_3502 () Int)
(declare-fun v_node_179_3524 () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun Anon_33 () Int)
(declare-fun k1_primed () Int)
(declare-fun tmp1_3574 () Int)
(declare-fun resn_3575 () Int)
(declare-fun tmp2_3576 () Int)
(declare-fun Anon_58 () Int)
(declare-fun Anon_61 () Int)
(declare-fun cm_3520 () Int)
(declare-fun cn_3521 () Int)
(declare-fun Anon_62 () Int)
(declare-fun Anon_3595 () Int)
(declare-fun Anon_3567 () Int)
(declare-fun p_3596 () Int)
(declare-fun resll_3570 () Int)
(declare-fun q_3600 () Int)
(declare-fun reslr_3572 () Int)
(declare-fun m1_3597 () Int)
(declare-fun am_3515 () Int)
(declare-fun an_3516 () Int)
(declare-fun Anon_3599 () Int)
(declare-fun Anon_3571 () Int)
(declare-fun m2_3601 () Int)
(declare-fun bm_3518 () Int)
(declare-fun bn_3519 () Int)
(declare-fun Anon_3603 () Int)
(declare-fun Anon_3573 () Int)
(declare-fun resln_3577 () Int)
(declare-fun n2_3602 () Int)
(declare-fun n1_3598 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= cm_3520 (+ (+ m2_3531 1) m1_3527)))
(assert (exists ((max_79 Int)) (and (= cn_3521 (+ max_79 1)) (or (and (= max_79 n1_3528) (>= n1_3528 n2_3532)) (and (= max_79 n2_3532) (< n1_3528 n2_3532))))))
(assert (= (+ Anon_62 n2_3532) (+ 1 n1_3528)))
(assert (= resrn_3512 cn_3521))
(assert (or (and (= resrn_3512 (+ n1_3528 1)) (<= n2_3532 n1_3528)) (and (= resrn_3512 (+ n2_3532 1)) (< n1_3528 n2_3532))))
(assert (<= (+ 0 n2_3532) (+ n1_3528 1)))
(assert (<= n1_3528 (+ 1 n2_3532)))
(assert (= Anon_3533 Anon_3508))
(assert (= n2_3532 cn_3458))
(assert (= m2_3531 cm_3457))
(assert (= Anon_3529 Anon_3506))
(assert (= n1_3528 bn_3462))
(assert (= m1_3527 bm_3461))
(assert (= q_3530 resrr_3507))
(assert (= p_3526 resrl_3505))
(assert (= Anon_3525 Anon_3504))
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (= k1_primed k1))
(assert (= Anon_44 Anon_34))
(assert (= Anon_45 Anon_35))
(assert (= l k3))
(assert (= r d))
(assert (= cm_3457 dm))
(assert (= cn_3458 dn))
(assert (= Anon_46 Anon_36))
(assert (= Anon_47 Anon_37))
(assert (= Anon_48 Anon_38))
(assert (= ll b))
(assert (= lr c))
(assert (= am_3459 bm))
(assert (= an_3460 bn))
(assert (= Anon_49 Anon_39))
(assert (= bm_3461 cm))
(assert (= bn_3462 cn))
(assert (= Anon_50 Anon_40))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (<= 0 Anon_40))
(assert (<= Anon_40 2))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 Anon_39))
(assert (<= Anon_39 2))
(assert (> k3 0))
(assert (<= 0 dm))
(assert (<= 0 dn))
(assert (<= 0 Anon_36))
(assert (<= Anon_36 2))
(assert (> k2 0))
(assert (= resrn_3512 (+ 1 tmp1_3509)))
(assert (or (and (= tmp1_3509 cn_3458) (>= cn_3458 bn_3462)) (and (= tmp1_3509 bn_3462) (< cn_3458 bn_3462))))
(assert (= resn_3510 (+ 1 tmp2_3511)))
(assert (or (and (= tmp2_3511 an_3460) (>= an_3460 resrn_3512)) (and (= tmp2_3511 resrn_3512) (< an_3460 resrn_3512))))
(assert (<= 0 Anon_46))
(assert (<= Anon_46 2))
(assert (<= 0 Anon_49))
(assert (<= Anon_49 2))
(assert (<= 0 Anon_50))
(assert (<= Anon_50 2))
(assert (= right_179_3513 k2))
(assert (= Anon_56 Anon_31))
(assert (= Anon_57 Anon_32))
(assert (= l_3514 a))
(assert (= r_3517 v_node_179_3524))
(assert (= am_3515 am))
(assert (= an_3516 an))
(assert (= Anon_58 Anon_33))
(assert (= Anon_59 Anon_3500))
(assert (= Anon_60 resn_3510))
(assert (= rl resl_3501))
(assert (= rr resr_3503))
(assert (= bm_3518 am_3459))
(assert (= bn_3519 an_3460))
(assert (= Anon_61 Anon_3502))
(assert (<= 0 cm_3457))
(assert (<= 0 cn_3458))
(assert (<= 0 Anon_3508))
(assert (<= Anon_3508 2))
(assert (<= 0 bm_3461))
(assert (<= 0 bn_3462))
(assert (<= 0 Anon_3506))
(assert (<= Anon_3506 2))
(assert (> resr_3503 0))
(assert (<= 0 am_3459))
(assert (<= 0 an_3460))
(assert (<= 0 Anon_3502))
(assert (<= Anon_3502 2))
(assert (> v_node_179_3524 0))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (<= 0 Anon_33))
(assert (<= Anon_33 2))
(assert (> k1_primed 0))
(assert (= resln_3577 (+ 1 tmp1_3574)))
(assert (or (and (= tmp1_3574 an_3516) (>= an_3516 bn_3519)) (and (= tmp1_3574 bn_3519) (< an_3516 bn_3519))))
(assert (= resn_3575 (+ 1 tmp2_3576)))
(assert (or (and (= tmp2_3576 resln_3577) (>= resln_3577 cn_3521)) (and (= tmp2_3576 cn_3521) (< resln_3577 cn_3521))))
(assert (<= 0 am_3515))
(assert (<= 0 an_3516))
(assert (<= 0 Anon_58))
(assert (<= Anon_58 2))
(assert (<= 0 bm_3518))
(assert (<= 0 bn_3519))
(assert (<= 0 Anon_61))
(assert (<= Anon_61 2))
(assert (<= 0 cm_3520))
(assert (<= 0 cn_3521))
(assert (<= 0 Anon_62))
(assert (<= Anon_62 2))
(assert (= Anon_3595 Anon_3567))
(assert (= p_3596 resll_3570))
(assert (= q_3600 reslr_3572))
(assert (= m1_3597 am_3515))
(assert (= n1_3598 an_3516))
(assert (= Anon_3599 Anon_3571))
(assert (= m2_3601 bm_3518))
(assert (= n2_3602 bn_3519))
(assert (= Anon_3603 Anon_3573))
(assert (exists ((max_79 Int)) (and (= resln_3577 (+ max_79 1)) (or (and (= max_79 n1_3598) (>= n1_3598 n2_3602)) (and (= max_79 n2_3602) (< n1_3598 n2_3602))))))
(assert (exists ((Anon_3582 Int)) (= (+ Anon_3582 n2_3602) (+ 1 n1_3598))))
;Negation of Consequence
(assert (not false))
(check-sat)