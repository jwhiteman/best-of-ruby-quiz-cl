(defpackage #:madlibs
  (:use #:cl)
  (:import-from :cl-ppcre :split
                          :regex-replace-all)
  (:export #:play-game
	   #:run-template
	   ))

(defpackage #:madlibs-test
  (:use #:cl #:prove #:madlibs))
