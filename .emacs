
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq package-list '(auto-complete base16-theme company-anaconda anaconda-mode company csv-mode highlight-indentation ibuffer-sidebar ibuffer-tramp ibuffer-vc markdown-mode))

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(setq tramp-default-method "ssh")

(show-paren-mode 1)

(add-hook 'after-init-hook 'global-company-mode)
;;(add-to-list 'company-backends 'company-jedi)
(defun python-lisp-hook()
  (anaconda-mode 1)
  (highlight-indentation-mode 1))

(add-hook 'python-mode-hook 'python-lisp-hook)
;(add-hook 'python-mode-hook 'anaconda-mode)

(autoload 'markdown-mode "markdown-mode.el" 
	"Major mode for editing Markdown files" t) 
	(setq auto-mode-alist 
		(cons '("\\.md" . markdown-mode) auto-mode-alist)
	)

(eval-after-load "company"
 '(add-to-list 'company-backends 'company-anaconda))


(setq ns-right-alternate-modifier nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(ansi-term-color-vector
   [unspecified "#181818" "#ab4642" "#a1b56c" "#f7ca88" "#7cafc2" "#ba8baf" "#7cafc2" "#d8d8d8"])
 '(custom-enabled-themes (quote (adwaita)))
 '(custom-safe-themes
   (quote
    ("87d46d0ad89557c616d04bef34afd191234992c4eb955ff3c60c6aa3afc2e5cc" "2a998a3b66a0a6068bcb8b53cd3b519d230dd1527b07232e54c8b9d84061d48d" default)))
 '(package-selected-packages
   (quote
    (base16-theme csv-mode ibuffer-vc highlight-indentation company-anaconda anaconda-mode markdown-mode company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'base16-solarflare t)

(delete-selection-mode 1)
(setq csv-separators '(";" "\t"))
(setq csv-field-quotes '("\"" "'"))
(setq csv-align-padding 2)
(setq csv-header-lines 1)
(require 'csv-mode)
(provide 'init-csv-mode)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)
(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*")
;;(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-vc-skip-if-remote nil)
(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     ;;(ibuffer-vc-set-filter-groups-by-vc-root)
	     ;;(ibuffer-switch-to-saved-filter-groups "default")
	   )
	  )
;(setq ibuffer-saved-filter-groups
;      (quote (("default"
;	       ("dired" (mode . dired-mode))
;	       )
;	      )
;	     )
;      )
