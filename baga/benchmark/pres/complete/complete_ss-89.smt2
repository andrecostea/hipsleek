(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin () Int)
(declare-fun nmin1_1962 () Int)
(declare-fun nmin2_1964 () Int)
(declare-fun r_1963 () Int)
(declare-fun l_1961 () Int)
(declare-fun res () Int)
(declare-fun v_int_71_1475_primed () Int)
(declare-fun v_int_71_1950 () Int)
(declare-fun nmin2_1893 () Int)
(declare-fun nmin1_1891 () Int)
(declare-fun n () Int)
(declare-fun flted_25_1888 () Int)
(declare-fun flted_25_1887 () Int)
(declare-fun nmin_1906 () Int)
(declare-fun l_1890 () Int)
(declare-fun nmin_1924 () Int)
(declare-fun r_1892 () Int)
(declare-fun n_1905 () Int)
(declare-fun n_1923 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((min_1994 Int)) (and (= nmin (+ 1 min_1994)) (or (and (= min_1994 nmin1_1891) (< nmin1_1891 nmin2_1893)) (and (= min_1994 nmin2_1893) (>= nmin1_1891 nmin2_1893))))))
(assert (= nmin1_1962 nmin_1906))
(assert (= nmin2_1964 nmin_1924))
(assert (= r_1963 r_1892))
(assert (= l_1961 l_1890))
(assert (= res v_int_71_1475_primed))
(assert (= v_int_71_1475_primed (+ 1 v_int_71_1950)))
(assert (or (<= nmin_1924 nmin_1906) (= v_int_71_1950 nmin_1906)))
(assert (or (< nmin_1906 nmin_1924) (= v_int_71_1950 nmin_1924)))
(assert (<= 0 nmin_1924))
(assert (<= nmin2_1893 flted_25_1887))
(assert (<= 0 nmin2_1893))
(assert (= nmin_1924 nmin2_1893))
(assert (<= 0 nmin_1906))
(assert (<= nmin1_1891 flted_25_1888))
(assert (<= 0 nmin1_1891))
(assert (= nmin_1906 nmin1_1891))
(assert (= (+ flted_25_1887 2) n))
(assert (= (+ flted_25_1888 1) n))
(assert (= n_1905 flted_25_1888))
(assert (<= nmin_1906 n_1905))
(assert (= n_1923 flted_25_1887))
(assert (<= nmin_1924 n_1923))
(assert (or (and (and (<= 1 nmin_1906) (<= nmin_1906 n_1905)) (> l_1890 0)) (or (and (and (< l_1890 1) (= n_1905 0)) (= nmin_1906 0)) (and (and (<= 1 nmin_1906) (< nmin_1906 n_1905)) (> l_1890 0)))))
(assert (or (and (and (<= 1 nmin_1924) (<= nmin_1924 n_1923)) (> r_1892 0)) (or (and (and (< r_1892 1) (= n_1923 0)) (= nmin_1924 0)) (and (and (<= 1 nmin_1924) (< nmin_1924 n_1923)) (> r_1892 0)))))
;Negation of Consequence
(assert (not (= (+ 1 n_1905) (+ 1 n_1923))))
(check-sat)