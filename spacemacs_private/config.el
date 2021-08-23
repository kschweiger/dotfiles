(delete-selection-mode 1)

;; Windows stuff
(setq w32-pass-rwindow-to-system nil)
(setq w32-rwindow-modifier 'super)
(setq tramp-default-method "plink")

;; TRAMP
;;(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;;(add-to-list 'tramp-remote-process-environment (format "PYENV_VERSION=%s" "3.7.11"))
;;(add-to-list 'tramp-remote-process-environment (format "PYENV_ROOT=%s" "$HOME/.pyenv"))

;;(setq python-shell-interpreter "c:/Users/korbinian.schweiger/AppData/Local/Programs/Python/Python37/python.exe")

;; Treemacs config
(setq treemacs-python-executable "c:/Users/korbinian.schweiger/AppData/Local/Programs/Python/Python37/python.exe")
(setq treemacs-no-png-images "")
(setq treemacs-show-cursor "")

(with-eval-after-load 'treemacs
  (defun treemacs-ignore-example (filename absolute-path)
    (or (string-suffix-p "log"  absolute-path)
	      (string-suffix-p "pyc"  absolute-path)
        (string-suffix-p "pdf" absolute-path)))

  (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-example))


;; ORG
(setq org-agenda-files
      (list "c:/Users/korbinian.schweiger/Documents/Notes/hgs.org"
	          "c:/Users/korbinian.schweiger/Documents/Notes/outlier_modes.org")
      )

;; Perspectives
;;(add-hook 'kill-emacs-hook #'persp-state-save)
(setq layouts-enable-autosave t)
