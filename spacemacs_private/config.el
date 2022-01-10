(delete-selection-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Windows Settings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (eq system-type 'windows-nt)
  (setq w32-pass-rwindow-to-system nil)
  (setq w32-rwindow-modifier 'super)
  (setq tramp-default-method "plink")
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; macOS Setting ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (eq system-type 'darwin) 
  (setq ns-right-alternate-modifier nil)
  (setq mac-right-option-modifier nil)
  ;;Make option work as meta (as it would be on Linux)
  (setq mac-option-modifier 'meta)
)

;; TRAMP
;;(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;;(add-to-list 'tramp-remote-process-environment (format "PYENV_VERSION=%s" "3.7.11"))
;;(add-to-list 'tramp-remote-process-environmefeRnt (format "PYENV_ROOT=%s" "$HOME/.pyenv"))

;;(setq python-shell-interpreter "c:/Users/korbinian.schweiger/AppData/Local/Programs/Python/Python37/python.exe")

;; Treemacs config
;;(setq treemacs-python-executable "c:/Users/korbinian.schweiger/AppData/Local/Programs/Python/Python37/python.exe")
(setq treemacs-no-png-images "")
(setq treemacs-show-cursor "")

(with-eval-after-load 'treemacs
  (defun treemacs-ignore-example (filename absolute-path)
    (or (string-suffix-p "log"  absolute-path)
	      (string-suffix-p "pyc"  absolute-path)
        (string-suffix-p "pdf" absolute-path)))

  (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-example))


;; ORG
(setq org-agenda-files '("~/org"))

;; Perspectives
;;(add-hook 'kill-emacs-hook #'persp-state-save)
(setq layouts-enable-autosave t)


;;
(setq spaceline-minor-modes-p nil)
(setq spaceline-buffer-size-p nil)

(setq lsp-pyright-venv-path (substitute-in-file-name "$HOME/.pyenv/versions"))
(setq lsp-pyright-venv-directory (substitute-in-file-name "$HOME/.pyenv/versions"))
