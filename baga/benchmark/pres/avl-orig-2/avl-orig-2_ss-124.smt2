(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_240_1522_primed () Int)
(declare-fun v_int_240_1523_primed () Int)
(declare-fun Anon_62 () Int)
(declare-fun cn () Int)
(declare-fun cm () Int)
(declare-fun height_239_2948 () Int)
(declare-fun Anon_57 () Int)
(declare-fun v_int_239_2953 () Int)
(declare-fun Anon_61 () Int)
(declare-fun bn () Int)
(declare-fun bm () Int)
(declare-fun Anon_58 () Int)
(declare-fun an () Int)
(declare-fun am () Int)
(declare-fun left_238_2907 () Int)
(declare-fun right_237_2904 () Int)
(declare-fun r () Int)
(declare-fun k1 () Int)
(declare-fun n () Int)
(declare-fun b () Int)
(declare-fun m () Int)
(declare-fun l () Int)
(declare-fun n_2923 () Int)
(declare-fun b_2924 () Int)
(declare-fun m_2922 () Int)
(declare-fun rl () Int)
(declare-fun n_2960 () Int)
(declare-fun b_2961 () Int)
(declare-fun m_2959 () Int)
(declare-fun rr () Int)
(declare-fun k2_primed () Int)
(declare-fun k1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_int_240_1522_primed 1))
(assert (<= v_int_239_2953 n_2960))
(assert (= v_int_240_1523_primed n_2960))
(assert (<= b_2961 2))
(assert (<= 0 b_2961))
(assert (<= 0 n_2960))
(assert (<= 0 m_2959))
(assert (<= Anon_62 2))
(assert (<= 0 Anon_62))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (= b_2961 Anon_62))
(assert (= n_2960 cn))
(assert (= m_2959 cm))
(assert (= height_239_2948 Anon_57))
(assert (= v_int_239_2953 (+ 1 n)))
(assert (<= n_2923 n))
(assert (<= b_2924 2))
(assert (<= 0 b_2924))
(assert (<= 0 n_2923))
(assert (<= 0 m_2922))
(assert (<= Anon_61 2))
(assert (<= 0 Anon_61))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= b_2924 Anon_61))
(assert (= n_2923 bn))
(assert (= m_2922 bm))
(assert (<= b 2))
(assert (<= 0 b))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (<= Anon_58 2))
(assert (<= 0 Anon_58))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (= b Anon_58))
(assert (= n an))
(assert (= m am))
(assert (= left_238_2907 rl))
(assert (= right_237_2904 r))
(assert (= k2_primed r))
(assert (= k1_primed k1))
(assert (= k2_primed 1))
(assert (or (and (and (and (< l 1) (= m 0)) (= n 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 n) 2) b)) (<= b n)) (<= b 2)) (<= 1 m)) (> l 0))))
(assert (or (and (and (and (< rl 1) (= m_2922 0)) (= n_2923 0)) (= b_2924 1)) (and (and (and (and (and (<= 0 b_2924) (<= (+ (- 0 n_2923) 2) b_2924)) (<= b_2924 n_2923)) (<= b_2924 2)) (<= 1 m_2922)) (> rl 0))))
(assert (= k1_primed 2))
(assert (or (and (and (and (< rr 1) (= m_2959 0)) (= n_2960 0)) (= b_2961 1)) (and (and (and (and (and (<= 0 b_2961) (<= (+ (- 0 n_2960) 2) b_2961)) (<= b_2961 n_2960)) (<= b_2961 2)) (<= 1 m_2959)) (> rr 0))))
(assert (not (= k2_primed k1_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)