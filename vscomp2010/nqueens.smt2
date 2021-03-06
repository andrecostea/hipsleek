(set-logic AUFNIA)
(declare-fun b () (Array Int Int))
(declare-fun c () (Array Int Int))
(declare-fun j () Int)
(declare-fun IsArray ((Array Int Int)) Bool)
(declare-fun AreNotAttackingQueens ((Array Int Int) Int Int) Bool)
(declare-fun IsSafeQueen ((Array Int Int) Int) Bool)
(declare-fun IsConsistent ((Array Int Int) Int) Bool)
(assert (forall (a (Array Int Int)) (= (IsArray a) true)))
(assert (forall (b (Array Int Int)) (i Int) (j Int) (= (AreNotAttackingQueens b i j) (or (= i j) (and (and (not (= (select b j) (select b i))) (not (= (- (select b j) (select b i)) (- j i)))) (not (= (- (select b j) (select b i)) (- i j))))))))
(assert (forall (b (Array Int Int)) (i Int) (= (IsSafeQueen b i) (forall (?j Int) (or (or (< ?j 1) (>= ?j i)) (AreNotAttackingQueens b i ?j))))))
(assert (forall (b (Array Int Int)) (n Int) (= (IsConsistent b n) (forall (?i Int) (or (or (< ?i 1) (> ?i n)) (IsSafeQueen b ?i))))))
(assert (IsArray b))
(assert (IsArray c))
(assert (forall (?i_40 Int) (or (or (< ?i_40 1) (< j ?i_40)) (= (select c ?i_40) (select b ?i_40)))))
(assert (IsConsistent b j))
(assert (not (IsConsistent c j)))
(check-sat)


