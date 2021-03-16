(in-package #:gedcom-parser)

;; cases:
;; 1. aref 1 contains "@"  => aref 2
;; t                       => aref 1
(defun tag (vec)
  (if (search "@" (aref vec 1))
    (aref vec 2)
    (aref vec 1)))

;; cases:
;; 1. aref 2 is nil        => (values nil nil)
;; 2. aref 1 contains "@"  => (vaules "id" aref 1)
;; 3. t                    => (values "value" aref 2)
(defun data (vec)
  (cond ((null (aref vec 2))
         (values nil nil))
        ((search "@" (aref vec 1))
         (values "id" (aref vec 1)))
        (t
          (values "value" (aref vec 2)))))

(defun level (vec)
  (parse-integer (aref vec 0)))

(defun prev-level (stack)
  (caar stack))

;; I'm sure there is a nicer way to do this...
(defun indent (ostream str n)
  (format ostream "~a~a~%"
          (format nil "~v@{~a~:*~}" (1+ (* 2 n)) #\space)
          str))

(defun print-close-node (ostream pair)
  (destructuring-bind (scale . tag) pair
    (indent ostream (format nil "</~a>" tag) scale)))

(defun print-node-elt (ostream tag key val scale)
  (if (and key val)
    (indent ostream (format nil "<~a ~a='~a'>" tag key val) scale)
    (indent ostream (format nil "<~a>" tag) scale)))

(defun print-leaf-elt (ostream tag val scale)
  (if val
    (indent ostream (format nil "<~a>~a</~a>" tag val tag)
            scale)
    (indent ostream (format nil "<~a/>" tag) scale)))

;; meh...
(defun -gedcom-to-xml (ostream stack current next rest)
  (let ((current-tag (tag current))
        (current-level (level current)))
    (when (and stack (>= (prev-level stack) current-level))
      (do ((i (prev-level stack) (1- i)))
          ((< i current-level))
        (print-close-node ostream (pop stack))))
    (multiple-value-bind (key val) (data current)
      (if next
        (progn
          (if (> (level next) current-level)
            (progn
              (push (cons current-level current-tag)
                    stack)
              (print-node-elt ostream current-tag key
                              val current-level))
            (print-leaf-elt ostream current-tag val
                            current-level))
          (-gedcom-to-xml ostream stack next
                          (car rest) (cdr rest)))
        (progn
          (print-leaf-elt ostream current-tag val
                          current-level)
          (do ()
              ((null stack))
            (print-close-node ostream (pop stack))))))))

(defun gedcom-to-xml (lot target-file)
  (with-open-file (ostream target-file :direction :output
                           :if-does-not-exist :create
                           :if-exists :overwrite)
    (-gedcom-to-xml ostream
                    nil
                    #("-1" "GEDCOM" nil)
                    (car lot)
                    (cdr lot))))

(defun main (gedcom-file target-file scanner)
  (format t "Converting ~a to ~a...~%" gedcom-file
          target-file)
  (let (acc)
    (with-open-file (instream gedcom-file)
      (when instream
        (do ((line (read-line instream nil)
                   (read-line instream nil)))
          ((null line) (gedcom-to-xml (reverse acc)
                                      target-file))
          (multiple-value-bind (str matches)
            (progn
              (cl-ppcre:scan-to-strings scanner line))
            (if str
              (push matches acc)))))))
  t)

(defvar *scanner* "(\\d+)\\s+([\\S]+)(?:\\s+(.*))?")
