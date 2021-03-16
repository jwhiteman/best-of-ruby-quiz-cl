# Ruby Quiz - GEDCOM Parser (#6)

http://rubyquiz.com/quiz6.html

## To run...

```
// from slime, using quicklisp...
(ql:quickload :gedcom-parser)
(in-package :gedcom-parser)

(main "royal.ged" "royal.xml" *scanner*)
```
