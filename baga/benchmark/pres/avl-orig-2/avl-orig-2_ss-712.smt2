(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun m1_3753 () Int)
(declare-fun tm_3772 () Int)
(declare-fun flted_74_3796 () Int)
(declare-fun m () Int)
(declare-fun m1_3916 () Int)
(declare-fun m_3925 () Int)
(declare-fun m_3833 () Int)
(declare-fun m2_3920 () Int)
(declare-fun m_3944 () Int)
(declare-fun m1_4023 () Int)
(declare-fun m2_4027 () Int)
(declare-fun am () Int)
(declare-fun bm () Int)
(declare-fun cm () Int)
(declare-fun dm () Int)
(declare-fun flted_138_4428 () Int)
(declare-fun flted_137_4429 () Int)
(declare-fun m_4486 () Int)
(declare-fun m_4597 () Int)
(declare-fun m1_5144 () Int)
(declare-fun m2_5148 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 flted_74_3796))
(assert (<= 0 tm_3772))
(assert (< 0 tm_3772))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (<= 0 m2_3757))
(assert (= m_3833 m2_3757))
(assert (<= 0 m1_3753))
(assert (= tm_3772 m1_3753))
(assert (<= 0 m_3833))
(assert (= flted_74_3796 (+ 1 tm_3772)))
(assert (= m flted_74_3796))
(assert (<= 0 m))
(assert (<= 0 m1_3916))
(assert (<= 0 cm))
(assert (<= 0 bm))
(assert (<= 0 am))
(assert (<= 0 dm))
(assert (<= 0 m_3925))
(assert (<= 0 m1_4023))
(assert (<= 0 m2_4027))
(assert (= m (+ (+ m2_3920 1) m1_3916)))
(assert (= m_3925 m1_3916))
(assert (= am m_3925))
(assert (= dm m_3833))
(assert (<= 0 m_3944))
(assert (<= 0 m2_3920))
(assert (= m_3944 m2_3920))
(assert (= m_3944 (+ (+ m2_4027 1) m1_4023)))
(assert (= bm m1_4023))
(assert (= cm m2_4027))
(assert (= flted_137_4429 (+ (+ 1 am) bm)))
(assert (= flted_138_4428 (+ (+ 1 cm) dm)))
(assert (<= 0 m_4597))
(assert (<= 0 flted_138_4428))
(assert (= m_4597 flted_138_4428))
(assert (<= 0 m_4486))
(assert (<= 0 flted_137_4429))
(assert (= m_4486 flted_137_4429))
(assert (= m1_5144 m_4486))
(assert (= m2_5148 m_4597))
(assert (= (+ (+ m1_5144 m2_5148) 1) 1))
;Negation of Consequence
(assert (not false))
(check-sat)