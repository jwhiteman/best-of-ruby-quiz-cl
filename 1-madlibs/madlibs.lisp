(in-package #:madlibs)

(defun read-file (infile)
  (with-open-file (instream infile)
    (when instream
      (let ((string (make-string (file-length instream))))
        (read-sequence string instream)
        string))))

(defun ask (thing in out)
  (format out "Enter ~a: " thing)
  (read-line in))

(defun squish (str)
  (string-trim '(#\space)
               (cl-ppcre:regex-replace-all "\\s+"
                                           str
                                           " ")))

(defun do-replacement (lookup register in out)
  (destructuring-bind (x . y) (cl-ppcre:split ":" register)
    (if y
      (let* ((key x)
             (des (car y))
             (val (ask des in out)))
        (setf (gethash key lookup) val))
      (or (gethash x lookup)
          (ask x in out)))))

(defun run-template (template in out)
  (let ((lookup (make-hash-table :test 'equalp)))
    (cl-ppcre:regex-replace-all
      "\\(\\(([^)]+)\\)\\)"
      template
      #'(lambda (match &rest registers)
          (declare (ignore match))
          (do-replacement lookup (car registers) in out))
      :simple-calls t)))

;; display which templates are avail
;; take the input
;; loop to play another game
(defun play-game (n &optional (in *standard-input*)
                    (out *standard-output*))
  (let* ((template-name (format nil "templates/~a.madlibs" n))
         (template (squish
                     (read-file template-name))))
    (run-template template in out)))
