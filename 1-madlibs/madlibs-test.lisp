(in-package #:madlibs-test)

;; simple test
(let ((in (make-string-input-stream "Petunia"))
      (out (make-string-output-stream))
      (template "Her name is ((your dog's name))")
      (ex1 "Her name is Petunia")
      (ex2 "Enter your dog's name: "))
  (subtest "#run-template - simple"
    (is ex1 (madlibs:run-template template in out))
    (is ex2 (get-output-stream-string out))))

;; test w/ lookup
(let ((in (make-string-input-stream "Petunia"))
      (out (make-string-output-stream))
      (template "Her ((dog:your dog's name)) is ((dog))!")
      (ex1 "Her Petunia is Petunia!"))
  (subtest "#run-template - w/ lookup"
    (is ex1 (madlibs:run-template template in out))))
