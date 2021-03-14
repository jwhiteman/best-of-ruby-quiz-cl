(asdf:defsystem #:madlibs
  :description "madlibs"
  :author "jim w."
  :depends-on (
               #:prove
	             #:cl-ppcre
	             )
  :components ((:file "package")
               (:file "madlibs")
               (:file "madlibs-test")))
