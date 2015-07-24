(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun cn_3253 () Int)
(declare-fun dn () Int)
(declare-fun bn_3258 () Int)
(declare-fun Anon_48 () Int)
(declare-fun resn_3247 () Int)
(declare-fun cn () Int)
(declare-fun bn () Int)
(declare-fun an () Int)
(declare-fun an_3195 () Int)
(declare-fun bn_3197 () Int)
(declare-fun Anon_49 () Int)
(declare-fun n1_3265 () Int)
(declare-fun n2_3269 () Int)
(declare-fun tmp1_3246 () Int)
(declare-fun tmp2_3248 () Int)
(declare-fun cn_3199 () Int)
(declare-fun resln_3249 () Int)
(declare-fun an_3256 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 dn))
(assert (= cn_3253 dn))
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (<= 0 an_3195))
(assert (<= 0 bn_3197))
(assert (<= 0 cn_3199))
(assert (= bn_3258 cn_3199))
(assert (= Anon_48 resn_3247))
(assert (= resn_3247 (+ 1 tmp2_3248)))
(assert (or (and (= tmp1_3246 an_3195) (>= an_3195 bn_3197)) (and (= tmp1_3246 bn_3197) (< an_3195 bn_3197))))
(assert (<= 0 an))
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (= cn_3199 cn))
(assert (= bn_3197 bn))
(assert (= an_3195 an))
(assert (= n1_3265 an_3195))
(assert (= n2_3269 bn_3197))
(assert (<= n1_3265 (+ 1 n2_3269)))
(assert (<= (+ 0 n2_3269) (+ n1_3265 1)))
(assert (= (+ Anon_49 n2_3269) (+ 1 n1_3265)))
(assert (exists ((max_3282 Int)) (and (= an_3256 (+ max_3282 1)) (or (and (= max_3282 n1_3265) (>= n1_3265 n2_3269)) (and (= max_3282 n2_3269) (< n1_3265 n2_3269))))))
(assert (= resln_3249 an_3256))
(assert (or (and (= resln_3249 (+ n1_3265 1)) (<= n2_3269 n1_3265)) (and (= resln_3249 (+ n2_3269 1)) (< n1_3265 n2_3269))))
(assert (= resln_3249 (+ 1 tmp1_3246)))
(assert (or (and (= tmp2_3248 resln_3249) (>= resln_3249 cn_3199)) (and (= tmp2_3248 cn_3199) (< resln_3249 cn_3199))))
;Negation of Consequence
(assert (not (= resln_3249 an_3256)))
(check-sat)