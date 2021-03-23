(defstruct node
  qst (y nil) (n nil))

(defun win (bst)
  (format t "I win!~%")
  bst)

(defun learn (bst)
  (let ((animal) (distinguishing-question))
    (format t "You win!~%")
    (format t "What were you thinking of?: ")
    (setf animal (read-line))
    (format t "What should I have asked?: ")
    (setf distinguishing-question (read-line))
    (if (y-or-n-p
	 (format nil "For a ~a, what is the answer?"
		 animal))
	(make-node :qst distinguishing-question
		   :y (make-node :qst
				 (format nil "Is it ~a?"
					 animal))
		   :n bst)
	(make-node :qst distinguishing-question
		   :y bst
		   :n (make-node :qst
				 (format nil "Is it ~a?"
					 animal))))))

(defun walk (bst)
  (let ((res (y-or-n-p (node-qst bst))))
    (if (and (null (node-y bst))
	     (null (node-n bst)))
	(if res (win bst) (learn bst))
	(if res
	    (make-node :qst (node-qst bst)
			     :y (walk (node-y bst))
			     :n (node-n bst))
	    (make-node :qst (node-qst bst)
			     :y (node-y bst)
			     :n (walk (node-n bst)))))))

(defun main ()
  (let ((bst (make-node :qst "Is it an elephant?")))
    (do ((play-again t))
	((null play-again))
      (format t "Think of an animal...~%")
      (setf bst (walk bst))
      (setf play-again (y-or-n-p "Play again?")))))
