;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq package-list '(auto-complete base16-theme company-anaconda anaconda-mode company csv-mode highlight-indentation ibuffer-sidebar ibuffer-tramp ibuffer-vc markdown-mode multiple-cursors))

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

;;(setq tramp-default-method "ssh")
;;(setq tramp-verbose 10)
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
    ("fede08d0f23fc0612a8354e0cf800c9ecae47ec8f32c5f29da841fe090dfc450" "fec45178b55ad0258c5f68f61c9c8fd1a47d73b08fb7a51c15558d42c376083d" "60e09d2e58343186a59d9ed52a9b13d822a174b33f20bdc1d4abb86e6b17f45b" "87d46d0ad89557c616d04bef34afd191234992c4eb955ff3c60c6aa3afc2e5cc" "2a998a3b66a0a6068bcb8b53cd3b519d230dd1527b07232e54c8b9d84061d48d" default)))
 '(package-selected-packages
   (quote
    ((\, multiple-cursors)
     (\, multiple-cursors)
     multiple-cursors yaml-mode json-mode base16-theme csv-mode ibuffer-vc highlight-indentation company-anaconda anaconda-mode markdown-mode company))))
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
(global-set-key (kbd "C-x C-r") 'revert-buffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)
(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*")
(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-vc-skip-if-remote nil)
(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     ;;(ibuffer-vc-set-filter-groups-by-vc-root)
	     (ibuffer-switch-to-saved-filter-groups "default")
	   )
	  )
(setq ibuffer-saved-filter-groups
          (quote (("default"
		   ("python" (mode . python-mode))
		   ("C++" (mode . c++-mode))
		   ("C" (mode . c-mode))	    
		   ("Markdown" (mode . markdown-mode))
		   ("shell" (name . "\\.sh$"))
		   ("configs" ( or (name . "\\.conf$")
				   (name . "\\.cfg$")))
		   ("CSV" (mode . csv-mode))
		   ("JSON" (name . "\\.json$"))
		   ("dired" (mode . dired-mode))
		   ))))
;; nearly all of this is the default layout
(setq ibuffer-formats 
      '((mark modified read-only " "
              (name 35 35 :left :elide) ; change: 30s were originally 18s
              " "
              (mode 16 16 :left :elide)
              " " filename-and-process)
        (mark " "
              (name 16 -1)
              " " filename)))

(require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
