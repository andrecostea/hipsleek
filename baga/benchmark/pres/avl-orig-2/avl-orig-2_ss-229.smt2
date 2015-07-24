(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_60 () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun bn_3462 () Int)
(declare-fun cn_3458 () Int)
(declare-fun Anon_62 () Int)
(declare-fun n1_3528 () Int)
(declare-fun n2_3532 () Int)
(declare-fun tmp1_3509 () Int)
(declare-fun resn_3510 () Int)
(declare-fun tmp2_3511 () Int)
(declare-fun resrn_3512 () Int)
(declare-fun resn_3575 () Int)
(declare-fun bn_3519 () Int)
(declare-fun n1_3598 () Int)
(declare-fun n2_3602 () Int)
(declare-fun tmp2_3576 () Int)
(declare-fun cn_3521 () Int)
(declare-fun tmp1_3574 () Int)
(declare-fun an_3516 () Int)
(declare-fun an_3460 () Int)
(declare-fun resln_3577 () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (<= Anon_62 2))
(assert (<= 0 Anon_62))
(assert (<= 0 bn_3462))
(assert (<= 0 cn_3458))
(assert (= Anon_60 resn_3510))
(assert (or (and (= tmp1_3509 cn_3458) (>= cn_3458 bn_3462)) (and (= tmp1_3509 bn_3462) (< cn_3458 bn_3462))))
(assert (<= 0 dn))
(assert (<= 0 cn))
(assert (= bn_3462 cn))
(assert (= cn_3458 dn))
(assert (= n1_3528 bn_3462))
(assert (= n2_3532 cn_3458))
(assert (<= n1_3528 (+ 1 n2_3532)))
(assert (<= (+ 0 n2_3532) (+ n1_3528 1)))
(assert (<= 0 an_3516))
(assert (<= 0 bn_3519))
(assert (<= 0 cn_3521))
(assert (exists ((max_3679 Int)) (and (= cn_3521 (+ max_3679 1)) (or (and (= max_3679 n1_3528) (>= n1_3528 n2_3532)) (and (= max_3679 n2_3532) (< n1_3528 n2_3532))))))
(assert (= (+ Anon_62 n2_3532) (+ 1 n1_3528)))
(assert (= resrn_3512 cn_3521))
(assert (or (and (= resrn_3512 (+ n1_3528 1)) (<= n2_3532 n1_3528)) (and (= resrn_3512 (+ n2_3532 1)) (< n1_3528 n2_3532))))
(assert (= resrn_3512 (+ 1 tmp1_3509)))
(assert (= resn_3510 (+ 1 tmp2_3511)))
(assert (or (and (= tmp2_3511 an_3460) (>= an_3460 resrn_3512)) (and (= tmp2_3511 resrn_3512) (< an_3460 resrn_3512))))
(assert (= bn_3519 an_3460))
(assert (<= 0 an_3460))
(assert (or (and (= tmp1_3574 an_3516) (>= an_3516 bn_3519)) (and (= tmp1_3574 bn_3519) (< an_3516 bn_3519))))
(assert (= resn_3575 (+ 1 tmp2_3576)))
(assert (= n1_3598 an_3516))
(assert (= n2_3602 bn_3519))
(assert (exists ((Anon_3681 Int)) (= (+ Anon_3681 n2_3602) (+ 1 n1_3598))))
(assert (exists ((max_3680 Int)) (and (= resln_3577 (+ max_3680 1)) (or (and (= max_3680 n1_3598) (>= n1_3598 n2_3602)) (and (= max_3680 n2_3602) (< n1_3598 n2_3602))))))
(assert (or (and (= tmp2_3576 resln_3577) (>= resln_3577 cn_3521)) (and (= tmp2_3576 cn_3521) (< resln_3577 cn_3521))))
(assert (= resln_3577 (+ 1 tmp1_3574)))
(assert (<= 0 an))
(assert (= an_3516 an))
(assert (<= 0 bn))
(assert (= an_3460 bn))
(assert (<= bn (+ an 1)))
(assert (<= an (+ bn 1)))
;Negation of Consequence
(assert (not (or (and (= resln_3577 (+ 1 an)) (<= bn an)) (and (= resln_3577 (+ 1 bn)) (< an bn)))))
(check-sat)