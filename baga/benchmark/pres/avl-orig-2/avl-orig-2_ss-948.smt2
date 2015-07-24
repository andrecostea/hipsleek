(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_35 () Int)
(declare-fun Anon_32 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n1_3754 () Int)
(declare-fun n2_3758 () Int)
(declare-fun tn_4067 () Int)
(declare-fun resn_4091 () Int)
(declare-fun resb_4092 () Int)
(declare-fun n_4128 () Int)
(declare-fun n_4207 () Int)
(declare-fun b_4108 () Int)
(declare-fun n () Int)
(declare-fun Anon_38 () Int)
(declare-fun Anon_4212 () Int)
(declare-fun n1_4211 () Int)
(declare-fun n2_4215 () Int)
(declare-fun n_4220 () Int)
(declare-fun n_4314 () Int)
(declare-fun b_4240 () Int)
(declare-fun n_4239 () Int)
(declare-fun n1_4318 () Int)
(declare-fun n2_4322 () Int)
(declare-fun height_118_4740 () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun h_4467 () Int)
(declare-fun t_4468 () Int)
(declare-fun t1_4470 () Int)
(declare-fun t2_4472 () Int)
(declare-fun h2_4471 () Int)
(declare-fun h1_4469 () Int)
(declare-fun n_4487 () Int)
(declare-fun n_4598 () Int)
(declare-fun v_int_118_5881 () Int)
(declare-fun n2_5892 () Int)
(declare-fun n1_5888 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_35 n_4207))
(assert (<= resb_4092 2))
(assert (<= 0 resb_4092))
(assert (<= 0 resn_4091))
(assert (<= 0 tn_4067))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= Anon_32 n_3750))
(assert (= n_3750 tn))
(assert (exists ((max_79 Int)) (and (= tn (+ max_79 1)) (or (and (= max_79 n1_3754) (>= n1_3754 n2_3758)) (and (= max_79 n2_3758) (< n1_3754 n2_3758))))))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= 0 n1_3754))
(assert (= n_4128 n1_3754))
(assert (<= 0 n2_3758))
(assert (= tn_4067 n2_3758))
(assert (<= 0 n_4128))
(assert (< 0 tn_4067))
(assert (or (= tn_4067 resn_4091) (and (= resn_4091 (+ 1 tn_4067)) (not (= resb_4092 1)))))
(assert (= n resn_4091))
(assert (= b_4108 resb_4092))
(assert (<= 0 n))
(assert (<= 0 b_4108))
(assert (<= b_4108 2))
(assert (= (+ 2 n_4128) n))
(assert (= an n_4128))
(assert (= n_4207 n))
(assert (= (+ b_4108 n2_4215) (+ 1 n1_4211)))
(assert (<= n1_4211 (+ 1 n2_4215)))
(assert (<= (+ 0 n2_4215) (+ n1_4211 1)))
(assert (exists ((max_79 Int)) (and (= n (+ max_79 1)) (or (and (= max_79 n1_4211) (>= n1_4211 n2_4215)) (and (= max_79 n2_4215) (< n1_4211 n2_4215))))))
(assert (<= 0 n_4220))
(assert (<= 0 n1_4318))
(assert (<= 0 n2_4322))
(assert (= Anon_38 n_4314))
(assert (= dn n_4220))
(assert (<= b_4240 2))
(assert (<= 0 b_4240))
(assert (<= 0 n_4239))
(assert (<= Anon_4212 2))
(assert (<= 0 Anon_4212))
(assert (<= 0 n1_4211))
(assert (= b_4240 Anon_4212))
(assert (= n_4239 n1_4211))
(assert (<= 0 n2_4215))
(assert (= n_4220 n2_4215))
(assert (<= n_4220 n_4239))
(assert (= n_4314 n_4239))
(assert (= (+ b_4240 n2_4322) (+ 1 n1_4318)))
(assert (<= n1_4318 (+ 1 n2_4322)))
(assert (<= (+ 0 n2_4322) (+ n1_4318 1)))
(assert (exists ((max_79 Int)) (and (= n_4239 (+ max_79 1)) (or (and (= max_79 n1_4318) (>= n1_4318 n2_4322)) (and (= max_79 n2_4322) (< n1_4318 n2_4322))))))
(assert (= bn n1_4318))
(assert (= cn n2_4322))
(assert (= height_118_4740 h_4467))
(assert (<= 0 cn))
(assert (<= 0 bn))
(assert (<= 0 dn))
(assert (<= 0 an))
(assert (or (and (= t2_4472 cn) (>= cn dn)) (and (= t2_4472 dn) (< cn dn))))
(assert (or (and (= t1_4470 an) (>= an bn)) (and (= t1_4470 bn) (< an bn))))
(assert (= h_4467 (+ t_4468 1)))
(assert (or (and (= t_4468 h1_4469) (>= h1_4469 h2_4471)) (and (= t_4468 h2_4471) (< h1_4469 h2_4471))))
(assert (= h1_4469 (+ t1_4470 1)))
(assert (= h2_4471 (+ t2_4472 1)))
(assert (<= n_4598 n_4487))
(assert (<= 0 n_4598))
(assert (<= 0 h2_4471))
(assert (= n_4598 h2_4471))
(assert (<= 0 n_4487))
(assert (<= 0 h1_4469))
(assert (= n_4487 h1_4469))
(assert (= v_int_118_5881 (+ 1 n_4487)))
(assert (= n1_5888 n_4487))
(assert (= n2_5892 n_4598))
(assert (exists ((max_79 Int)) (and (= v_int_118_5881 (+ max_79 1)) (or (and (= max_79 n1_5888) (>= n1_5888 n2_5892)) (and (= max_79 n2_5892) (< n1_5888 n2_5892))))))
(assert (exists ((flted_76_5882 Int)) (= (+ flted_76_5882 n2_5892) (+ 1 n1_5888))))
(assert (= (+ n2_5892 1) (+ n1_5888 1)))
;Negation of Consequence
(assert (not false))
(check-sat)