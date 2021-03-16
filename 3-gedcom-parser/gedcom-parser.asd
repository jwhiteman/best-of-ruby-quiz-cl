(asdf:defsystem #:gedcom-parser
  :description "gedcom-parser"
  :author "jim w."
  :depends-on (#:cl-ppcre)
  :components ((:file "package")
               (:file "gedcom-parser")))
