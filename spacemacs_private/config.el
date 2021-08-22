;; Windows stuff
(setq w32-pass-rwindow-to-system nil)
(setq w32-rwindow-modifier 'super)


(setq treemacs-no-png-images "")
(setq treemacs-show-cursor "")

(with-eval-after-load 'treemacs
  (defun treemacs-ignore-example (filename absolute-path)
    (or (string-suffix-p "log"  absolute-path)
	      (string-suffix-p "pyc"  absolute-path)
        (string-suffix-p "pdf" absolute-path)))

  (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-example))
