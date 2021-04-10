(defparameter *numerals-to-digits* '((1000 . M)
                                     (900 . CM)
                                     (500 . D)
                                     (400 . CD)
                                     (100 . C)
                                     (90 . XC)
                                     (50 . L)
                                     (40 . XL)
                                     (10 . X)
                                     (9 . IX)
                                     (5 . V)
                                     (4 . IV)
                                     (1 . I)))

(defparameter *digits-to-numerals*
  (mapcar #'(lambda (pair)
              (cons (cdr pair) (car pair)))
          *numerals-to-digits*))

(defun arabic-to-roman (arabic)
  (reduce #'(lambda (acc e)
              (destructuring-bind (val . numeral) e
                (multiple-value-bind (quo rem) (floor acc val)
                  (unless (zerop quo)
                    (format t "~v@{~a~:*~}" quo numeral))
                  rem)))
          *numerals-to-digits*
          :initial-value arabic)
  (terpri))

(defun roman-to-arabic (l &optional (sum 0))
  (if (null l)
    (format t "~A~%" sum)
    (let* ((cur (first l))
           (nxt (second l))
           (special-case-key
             (if nxt
               (read-from-string
                 (coerce (list cur nxt) 'string))
               nil))
           (special-case-value
             (if special-case-key
               (assoc special-case-key *digits-to-numerals*)
               nil)))
      (if special-case-value
        (roman-to-arabic (cddr l)
                         (+ sum (cdr special-case-value)))
        (let* ((key (intern (string-upcase (string cur))))
               (val (assoc key *digits-to-numerals*)))
          (roman-to-arabic (cdr l)
                           (+ sum (cdr val))))))))

;; TEST:
#|
(mapc #'arabic-to-roman '(1 3 4 29 38 1999))
(roman-to-arabic '(#\i #\I #\i))
(roman-to-arabic '(#\M #\C #\M #\X #\C #\I #\X))
(roman-to-arabic '(#\C #\c #\x #\C #\i))
(roman-to-arabic '(#\X #\X #\i #\X))
|#
