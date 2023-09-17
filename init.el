;;; Below are fragments from my Emacs configuration file
;;; (`~/.emacs.d/init.el`) using
;;; [straight.el](https://github.com/radian-software/straight.el) instead of
;;; Emacs builtin `package.el`.  (For old `package.el` based version
;;; see [here](/dotemacs/2022-02-15/)).

;;; The newest version of this config is available from a [github
;;; repo](https://github.com/lukpank/.emacs.d).

;; My default font size
(defvar davidemacs/default-font-size 148)


;;; ---------------------

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil
      straight-use-package-by-default t)
(straight-use-package 'use-package)


;;; [dsc] Key binding
(when (eq system-type 'darwin)
  ;; set keys for Apple keyboard, for emacs in OS X
  ;;(setq mac-command-modifier 'super) ; make cmd key do Meta
  (setq mac-option-modifier 'meta)	 ; make opt key do Meta
  (setq mac-right-option-modifier 'none) ; keep for accents
  (setq mac-control-modifier 'control)	 ; make Control key do Control
  (setq mac-command-modifier 'super)	 ; make Command key do Super
  (setq mac-right-command-modifier 'none) ; Keep for mac command stuffs
  (setq mac-function-modifier 'hyper)	  ; make Fn key do Hyper
  )

;;; [dsc] Backup files in backup directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )


;;; [dsc] line number
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;; Productivity
;;; ------------

;;; ### Key discoverability ###

(use-package which-key
  :init
  (setq which-key-idle-delay 2.0
	which-key-idle-secondary-delay 1.0)
  :config
  (which-key-mode))

;;; ### More efficient buffer/file selection ###

;;; Requires: [fzf](https://github.com/junegunn/fzf) and
;;; [ripgrep](https://github.com/BurntSushi/ripgrep) (rg), and git.

(setq recentf-max-saved-items 100)

(global-set-key "\C-cq" #'bury-buffer)

(use-package prescient
  :config
  (prescient-persist-mode))

(use-package ivy-prescient
  :after counsel
  :config
  (ivy-prescient-mode))

(use-package counsel
  :demand
  :bind (("C-c a" . swiper-all)
	 ("C-c e" . counsel-flycheck)
	 ("C-c f" . counsel-fzf)
	 ("C-c g" . counsel-git)
	 ("C-c i" . counsel-imenu)
	 ("C-c j" . counsel-git-grep)
	 ("C-c L" . counsel-locate)
	 ("C-c o" . counsel-outline)
	 ("C-c r" . counsel-rg)
	 ("C-c R" . counsel-register)
	 ("C-c T" . counsel-load-theme)
	 ("C-S-s" . swiper)
	 ([remap dired] . counsel-dired))
  :init
  (setq ivy-use-virtual-buffers t)
  :config
  (ivy-mode 1)
  (counsel-mode 1))

(use-package ivy-rich
  :after ivy
  :config
  (ivy-rich-mode 1))

(use-package helpful
  :init
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable))


;;; ### File explorer sidebar ###

;;; Install fonts with `M-x all-the-icons-install-fonts`.

(use-package dired-sidebar
  :bind ("C-c s" . dired-sidebar-toggle-sidebar))

(use-package all-the-icons
  :defer)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package all-the-icons-ivy-rich
  :after ivy-rich
  :config (all-the-icons-ivy-rich-mode 1))

(use-package treemacs
  :bind ("C-c S" . treemacs))


;;; ### Window selection enhancements ###

(use-package windmove
  :bind (("H-w j" . windmove-down)
	 ("H-w k" . windmove-up)
	 ("H-w h" . windmove-left)
	 ("H-w l" . windmove-right)))

(use-package windswap
  :bind (("H-w J" . windswap-down)
	 ("H-w K" . windswap-up)
	 ("H-w H" . windswap-left)
	 ("H-w L" . windswap-right)))


;;; ### In buffer movement enhancements ###

;;; Search

(use-package ctrlf
  :config
  (ctrlf-mode))

;;; Improved in buffer search

(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode))

;;; Go to last change in the current buffer

(use-package goto-chg
  :bind ("C-c G" . goto-last-change))


;;; ### Editing enhancements ###

;;; Context aware insertion of pairs of parenthesis

(use-package smartparens
  :hook ((prog-mode . smartparens-mode)
	 (emacs-lisp-mode . smartparens-strict-mode))
  :init
  (setq sp-base-key-bindings 'sp)
  :config
  (define-key smartparens-mode-map [M-backspace] #'backward-kill-word)
  (define-key smartparens-mode-map [M-S-backspace] #'sp-backward-unwrap-sexp)
  (require 'smartparens-config))

;;; Edit with multiple cursors

(use-package multiple-cursors
  :bind (("C-c n" . mc/mark-next-like-this)
	 ("C-c p" . mc/mark-previous-like-this)))

;;; Fix trailing spaces but only in modified lines

(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))


;;; ### Switching buffers ###

;;; Bind keys from `H-r a` to `H-r z` to switch to buffers from a
;;; register from `a` to `z`.

(defalias 'pr #'point-to-register)

(defun my-switch-to-register ()
  "Switch to buffer given by key binding last character."
  (interactive)
  (let* ((v (this-command-keys-vector))
	 (c (aref v (1- (length v))))
	 (r (get-register c)))
    (if (and (markerp r) (marker-buffer r))
	(switch-to-buffer (marker-buffer r))
      (jump-to-register c))))

(setq my-switch-to-register-map (make-sparse-keymap))

(dolist (character (number-sequence ?a ?z))
  (define-key my-switch-to-register-map
    (char-to-string character) #'my-switch-to-register))

(global-set-key (kbd "H-r") my-switch-to-register-map)


;;; ### Switching tabs ###

(dolist (i (number-sequence 1 9))
  (global-set-key (format "\C-c%d" i) `(lambda () (interactive) (tab-select ,i))))

(tab-bar-mode 1)


;;; ### Yasnippet and abbrev mode ###

(setq-default abbrev-mode 1)

(use-package yasnippet
  :defer 2
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :defer)

(use-package ivy-yasnippet
  :bind ("C-c y" . ivy-yasnippet))

;;; [dsc] Org Mode
;;; --------------

(use-package org)


(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)


;; (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "☯" "○" "☯" "✸" "☯" "✿" "☯" "✜" "☯" "◆" "☯" "▶"))
  (org-ellipsis "⤵")
  )



(set-face-attribute 'default nil :font "Fira Code Retina" :height davidemacs/default-font-size)




;; Files
(setq org-directory "~/Documents/org")
(setq org-agenda-files (list "inbox.org" "agenda.org"
                             "notes.org" "projects.org"))

;; Capture
(setq org-capture-templates
      `(("i" "Inbox" entry  (file "inbox.org")
        ,(concat "* TODO %?\n"
                 "/Entered on/ %U"))
        ("m" "Meeting" entry  (file+headline "agenda.org" "Future")
        ,(concat "* %? :meeting:\n"
                 "<%<%Y-%m-%d %a %H:00>>"))
        ("n" "Note" entry  (file "notes.org")
        ,(concat "* Note (%a)\n"
                 "/Entered on/ %U\n" "\n" "%?"))
        ("@" "Inbox [mu4e]" entry (file "inbox.org")
        ,(concat "* TODO Reply to \"%a\" %?\n"
                 "/Entered on/ %U"))))

(defun org-capture-inbox ()
     (interactive)
     (call-interactively 'org-store-link)
     (org-capture nil "i"))

(defun org-capture-mail ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "@"))

;; Use full window for org-capture
(add-hook 'org-capture-mode-hook 'delete-other-windows)

;; Key bindings
(define-key global-map            (kbd "C-c a") 'org-agenda)
(define-key global-map            (kbd "C-c c") 'org-capture)
(define-key global-map            (kbd "C-c i") 'org-capture-inbox)

;; Only if you use mu4e
;; (require 'mu4e)
;; (define-key mu4e-headers-mode-map (kbd "C-c i") 'org-capture-mail)
;; (define-key mu4e-view-mode-map    (kbd "C-c i") 'org-capture-mail)

;; Refile
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets
      '(("projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")))

;; TODO
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d)")))
(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

;; Agenda
(setq org-agenda-custom-commands
      '(("g" "Get Things Done (GTD)"
         ((agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                   (org-deadline-warning-days 0)))
          (todo "NEXT"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                 (org-agenda-prefix-format "  %i %-12:c [%e] ")
                 (org-agenda-overriding-header "\nTasks\n")))
          (agenda nil
                  ((org-agenda-entry-types '(:deadline))
                   (org-agenda-format-date "")
                   (org-deadline-warning-days 7)
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                   (org-agenda-overriding-header "\nDeadlines")))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format "  %?-12t% s")
                      (org-agenda-overriding-header "\nInbox\n")))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today\n")))))))


;; Only if you use mu4e
;; (require 'mu4e)
;; (define-key mu4e-headers-mode-map (kbd "C-c i") 'org-capture-mail)
;; (define-key mu4e-view-mode-map    (kbd "C-c i") 'org-capture-mail)


;;; Programming modes
;;; -----------------

;;; ### company and lsp-mode ###

;;; For modes using [company](https://company-mode.github.io/) for tab
;;; completion add

(use-package company
  :bind (:map prog-mode-map
	      ("C-i" . company-indent-or-complete-common)
	      ("C-M-i" . counsel-company))
  :hook (emacs-lisp-mode . company-mode))

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode))

;;; For modes that also use Language Server Protocol from [lsp-mode]
;;; add

(use-package lsp-mode
  :hook ((c-mode c++-mode d-mode elm-mode go-mode js-mode kotlin-mode python-mode
	  typescript-mode vala-mode web-mode)
	 . lsp)
  :init
  (setq lsp-keymap-prefix "H-l"
	lsp-rust-analyzer-proc-macro-enable t)
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :init
  (setq lsp-ui-doc-position 'at-point
	lsp-ui-doc-show-with-mouse nil
	lsp-ui-sideline-show-code-actions t)
  :bind (("C-c A" . lsp-execute-code-action)
	 ("C-c d" . lsp-ui-doc-show)
	 ("C-c I" . lsp-ui-imenu)))

(use-package flycheck
  :defer)

;;; [lsp-mode]: https://emacs-lsp.github.io/lsp-mode/

;;; Compilation

(global-set-key "\C-ck" #'compile)

;;; [company and lsp-mode]: #company-and-lsp-mode


;;; ### C and C++ ###

;;; Requires: [company and lsp-mode],
;;; [clangd](https://clangd.llvm.org/).

(use-package cc-mode
  :straight nil
  :bind (:map c-mode-map
	 ("C-i" . company-indent-or-complete-common)
	 :map c++-mode-map
	 ("C-i" . company-indent-or-complete-common))
  :init
  (setq-default c-basic-offset 8))


;;; ### D ###

;;; Requires: [company and lsp-mode], `dmd`, `dub`,
;;; [dcd](https://code.dlang.org/packages/dcd), and
;;; [dtools](https://code.dlang.org/packages/dtools) (for `rdmd`) to
;;; build [serve-d](https://code.dlang.org/packages/serve-d) (but
;;; first check for newer version) with

;;;     $ dub fetch serve-d@0.7.4
;;;     $ dub run serve-d --build=release
;;;     $ ln -s ~/.dub/packages/serve-d-0.7.4/serve-d/serve-d ~/.local/bin/

(use-package d-mode
  :bind (:map d-mode-map
	 ("C-i" . company-indent-or-complete-common)))


;;; ### Dart ###

;;; Requires: [company and lsp-mode], `flutter` in `PATH`,
;;; `flutter doctor` should be OK, and `M-x lsp-dart-dap-setup`.

(use-package dart-mode)

(use-package lsp-dart
  :hook (dart-mode . lsp)
  :bind (:map lsp-mode
         ("C-M-x" . lsp-dart-dap-flutter-hot-reload)))


;;; ### Elm ###

;;; Requires: [company and lsp-mode].
(use-package elm-mode
  :hook (elm-mode . elm-indent-mode))


;;; ### Emacs lisp ###

;;; Requires: [company and lsp-mode] (actually just `company`) and
;;; [smartparens](#editing-enhancements).


;;; ### Go ###

;;; Requires: [company and lsp-mode],
;;; [gopls](https://github.com/golang/tools/blob/master/gopls/README.md#installation).

(defun my-go-before-save ()
  "Format buffer and organize imports in Go mode."
  (when (eq major-mode 'go-mode)
    (lsp-organize-imports)
    (lsp-format-buffer)))

(use-package go-mode
  :hook (before-save . my-go-before-save))


;;; ### JavaScript ###

;;; Requires: [company and lsp-mode] `ts-ls` (proposed by [lsp-mode]
;;; when missing).

(use-package js
  :straight nil
  :bind (:map js-mode-map
	 ([remap js-find-symbol] . xref-find-definitions))
  :init
  (setq js-indent-level 4))


;;; ### Kotlin ###

;;; Requires:
;;; [kotlin-language-server](https://github.com/fwcd/kotlin-language-server).

(use-package kotlin-mode)

;;; ### Lisp ###

(use-package sly
  :defer
  :config
  (setq inferior-lisp-program "sbcl"
	sly-mrepl-pop-sylvester nil)
  :custom-face
  (sly-mrepl-output-face ((t (:foreground "sienna")))))

(use-package paren-face
  :defer)

(use-package paredit
  :defer)

(use-package highlight-parentheses
  :defer)

(defun my-lisp-mode-hook-fn ()
  (smartparens-mode 0)
  (paredit-mode 1)
  (paren-face-mode 1)
  (highlight-parentheses-mode 1)
  (company-mode 1))

(add-hook 'lisp-mode-hook 'my-lisp-mode-hook-fn)
(add-hook 'emacs-lisp-mode-hook 'my-lisp-mode-hook-fn)

;;; ### Meson build system ###

(use-package meson-mode
  :defer
  :init
  (setq meson-indent-basic 4))


;;; ### Python ###

;;; Requires: [company and lsp-mode],
;;; [pylsp](https://pypi.org/project/python-lsp-server/).


;;; ### Rust ###

;;; Requires: [company and lsp-mode], `rust-src` from [Rustup]
;;; and [rust-analyzer].

;;; [Rustup]: https://www.rust-lang.org/learn/get-started
;;; [rust-analyzer]: https://rust-analyzer.github.io/manual.html#installation

(use-package rustic
  :defer)


;;; ### TypeScript ###

;;; Requires: [company and lsp-mode], [web-mode settings] (for tsx),
;;; `ts-ls` (proposed by [lsp-mode] when missing),
;;; [tsconfig.json](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html).

(use-package typescript-mode
  :defer)


;;; ### Vala ###

;;; Requires: [company and lsp-mode],
;;; [vala-language-server](https://github.com/Prince781/vala-language-server#installation).

(use-package vala-mode
  :defer)


;;; ### Web mode ###

;;; Requires: [company and lsp-mode].

(use-package web-mode
  :mode "\\.\\([jt]sx\\)\\'")

;;; [web-mode settings]: #web-mode


;;; Other modes
;;; -----------

(use-package ansible
  :straight (:nonrecursive t))

(use-package devdocs
  :bind ("C-c D" . devdocs-lookup))

(use-package diff-hl
  :defer)

(use-package htmlize
  :defer)

(use-package rainbow-mode
  :hook css-mode)

(use-package restclient
  :defer)

(use-package vterm
  :defer
  :init
  (dolist (i (number-sequence 0 9))
    (global-set-key (kbd (format "H-%d" i)) `(lambda () (interactive) (vterm ,i)))))

(use-package yaml-mode
  :defer)


;;; ### Git ###

(use-package magit
  :bind (("C-x g" . magit-status)
	 ("C-x M-g" . magit-dispatch))
  :init
  (setq project-switch-commands nil)) ; avoid magit error on C-n/C-p

(use-package git-messenger
  :bind ("C-x G" . git-messenger:popup-message)
  :config
  (setq git-messenger:show-detail t
	git-messenger:use-magit-popup t))

(use-package git-timemachine
  :bind ("C-c t" . git-timemachine))


;;; Appearance
;;; ----------

;;; ### Minimalistic look ###

(setq inhibit-startup-screen t)
(set-scroll-bar-mode 'right)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)


;;; ### Mode line ###

(use-package smart-mode-line
  :config
  (setq sml/no-confirm-load-theme t
	sml/shorten-directory t
	sml/shorten-modes t
	sml/name-width 50
	sml/mode-width 'full
	sml/theme 'respectful)
  (sml/setup))


;;; ### Switching themes ###

(use-package base16-theme
  :defer)

(use-package faff-theme
  :defer)

;; [dsc] adding solarized theme
(use-package solarized-theme
  :defer)

(setq my-dark-theme 'solarized-dark
      my-light-theme 'solarized-light)

(defun my-select-theme (theme)
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme (cond
	       ((eq theme 'dark) my-dark-theme)
	       ((eq theme 'light) my-light-theme)
	       (t theme))
	      t)
  (sml/setup))

(defun my-select-theme-if-none-selected (frame)
  (if (and (eq 'x (window-system frame))
	   (null (seq-filter (lambda (theme)
			       (not (string-prefix-p "smart-mode-line-"
						     (symbol-name theme))))
			     custom-enabled-themes)))
      (my-select-theme 'dark)))

(my-select-theme-if-none-selected nil)
(add-to-list 'after-make-frame-functions #'my-select-theme-if-none-selected)

(defun my-toggle-theme ()
  "Toggle between dark and light themes."
  (interactive)
  (my-select-theme (if (custom-theme-enabled-p my-dark-theme)
		       my-light-theme
		     my-dark-theme)))

(my-select-theme 'dark)

(global-set-key (kbd "C-x C-t") #'my-toggle-theme)

;; [dsc] change font size
;;(set-face-attribute 'default nil :height 180)
