(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: fn?
                : quoted?
                : quoted->fn
                : quoted->str} :themis.lib.compile-time)

(deftest macro/expr->str
  (testing "works properly with an addition expression"
    (assert-eq (expr->str (+ 1 2))
               "(+ 1 2)"))
  (testing "works properly with a quoted expression"
    (assert-eq (expr->str '(+ 1 2))
               "(quote (+ 1 2))")))

(deftest fn/fn?
  (testing "works properly with a anonymous function"
    (assert-is (fn? (fn [x] x))))
  (testing "works properly with a non-anonymous function"
    (assert-is (fn? (fn non-anonymous [x] x))))
  (testing "works properly with a hash function"
    (assert-is (fn? (hashfn 1))))
  (testing "works properly with a hash function shorthand"
    (assert-is (fn? #1)))
  (testing "works properly with a lambda function"
    (assert-is (fn? (lambda [x] x))))
  (testing "works properly with a partial application"
    (assert-is (fn? (partial (fn [x y] (+ x y)) 1))))
  (testing "works properly with nil"
    (assert-not (fn? nil)))
  (testing "works properly with (+ 1 1)"
    (assert-not (fn? (+ 1 1)))))

(deftest fn/quoted?
  (testing "works properly with a quoted expression"
    (assert-is (quoted? '(+ 1 2))))
  (testing "works properly with a quoted symbol"
    (assert-is (quoted? 'symbol)))
  (testing "works properly with a quoted number"
    (assert-is (quoted? '1999)))
  (testing "works properly with a quoted string"
    (assert-is (quoted? '"something")))
  (testing "works properly with a non-quoted expression"
    (assert-not (quoted? (+ 1 2))))
  (testing "works properly with a non-quoted symbol"
    (assert-not (quoted? symbol)))
  (testing "works properly with a non-quoted number"
    (assert-not (quoted? 1999)))
  (testing "works properly with a non-quoted string"
    (assert-not (quoted? "something"))))

(deftest macro/quoted->fn
  (testing "works properly with a quoted expression"
    (assert-eq (expr->str (quoted->fn '(+ 1 2)))
               (expr->str (fn [] (+ 1 2)))))
  (testing "works properly with a quoted symbol"
    (assert-eq (expr->str (quoted->fn 'symbol))
               (expr->str (fn [] symbol))))
  (testing "works properly with a quoted number"
    (assert-eq (expr->str (quoted->fn '1999))
               (expr->str (fn [] 1999))))
  (testing "works properly with a quoted string"
    (assert-eq (expr->str (quoted->fn '"something"))
               (expr->str (fn [] "something")))))

(deftest fn/quoted->str
  (testing "works properly with a quoted expression"
    (assert-eq (quoted->str '(+ 1 2))
               "'(+ 1 2)"))
  (testing "works properly with a quoted symbol"
    (assert-eq (quoted->str 'symbol)
               "'symbol"))
  (testing "works properly with a quoted number"
    (assert-eq (quoted->str '1999)
               "'1999"))
  (testing "works properly with a quoted string"
    (assert-eq (quoted->str '"something")
               "'\"something\"")))
