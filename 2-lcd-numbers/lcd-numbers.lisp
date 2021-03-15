(defvar *nums* (make-hash-table))

(setf (gethash 1 *nums*) '((" ") (" " "|") (" ") (" " "|") (" "))
      (gethash 2 *nums*) '(("-") (" " "|") ("-") ("|" " ") ("-"))
      (gethash 3 *nums*) '(("-") (" " "|") ("-") (" " "|") ("-"))
      (gethash 4 *nums*) '((" ") ("|" "|") ("-") (" " "|") (" "))
      (gethash 5 *nums*) '(("-") ("|" " ") ("-") (" " "|") ("-"))
      (gethash 6 *nums*) '(("-") ("|" " ") ("-") ("|" "|") ("-"))
      (gethash 7 *nums*) '(("-") (" " "|") (" ") (" " "|") (" "))
      (gethash 8 *nums*) '(("-") ("|" "|") ("-") ("|" "|") ("-"))
      (gethash 9 *nums*) '(("-") ("|" "|") ("-") (" " "|") ("-"))
      (gethash 0 *nums*) '(("-") ("|" "|") (" ") ("|" "|") ("-")))

(defun p (char &optional (scale 1))
  "Print a char SCALE times."
  (format t "~v@{~A~:*~}" scale char))

(defun print-odd (lst scale)
  (dolist (l lst)
    (p #\space)
    (p (car l) scale)
    (p #\space)
    (p #\space))
  (p #\newline))

(defun print-even (lst scale)
  (do ((i 0 (1+ i)))
      ((= i scale))
    (dolist (l lst)
      (destructuring-bind (left right) l
	(p left)
	(p #\space scale)
	(p right)
	(p #\space)))
    (p #\newline)))

(defun -lcd-numbers (args scale)
  (let ((i 1))
    (apply #'mapc
	   #'(lambda (&rest slice)
	       (if (oddp i)
		   (print-odd slice scale)
		   (print-even slice scale))
	       (incf i))
	   args)))

(defun lcd-numbers (nums-lookup str scale)
  (-lcd-numbers
   (remove-if #'null
	      (map 'list
		   #'(lambda (c)
		       (gethash (digit-char-p c) nums-lookup))
		   str))
   scale))

(defun main ()
  (let ((str (or (fourth *posix-argv*)
		 (second *posix-argv*)))
	(scale (or (third *posix-argv*)
		   "1")))
    (lcd-numbers *nums* str (parse-integer scale))))
