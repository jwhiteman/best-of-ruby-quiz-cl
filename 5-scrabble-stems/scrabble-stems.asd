(asdf:defsystem #:scrabble-stems
  :description "scrabble stems"
  :author "jim w."
  :depends-on (#:cl-ppcre)
  :components ((:file "package")
               (:file "scrabble-stems")))
