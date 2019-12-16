;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Angad Singh's Emacs Config ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; I'm Angad Singh, a high school student from New Delhi, India. I mostly
;; use Emacs for writing code and taking notes with org-mode. I'm a member of
;; Delhi Public School, R.K. Puram's computer science club, Exun Clan where I
;; work with the quizzing and development departments. This mostly involves
;; PHP on the backend and a lot of frontend JavaScript. I also write a lot
;; of JavaScript on the backend with frameworks like Express and Koa.
;; I like to hack around with stuff that I might get to work with in
;; the future, this includes languages like Python and Go. This config is
;; highly inspired by Mike Zamansky's Using Emacs series. I've tried to
;; read documentation for and understand everything in this file, in case you
;; see my elisp-fu falter feel free to submit an issue on this repo
;; and tell me about it.


;;;;;;;;;;;;;;;;
;; The Basics ;;
;;;;;;;;;;;;;;;;

;; Set user details
(setq user-full-name "Angad Singh")
(setq user-mail-address "mail@angad.dev")

;; Setup package management with package.el and use-package
;; TODO: move to straight.el
(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/"))

(package-initialize)

;; Install use-package if it isn't already there
(unless (package-installed-p 'use-package)
        (package-refresh-contents)
        (package-install 'use-package))

;; Always :ensure
(setq use-package-always-ensure t)

;; Remove the startup message and change the message in the scratch buffer.
(setq start-message ";; dotangad")
(setq inhibit-startup-message t)
(setq initial-scratch-message start-message)
(setq inhibit-startup-echo-area-message start-message)

;; Use Emoji Font for Emojis
(set-fontset-font t 'symbol 
                  (font-spec :family "Apple Color Emoji") 
                  nil 'prepend)

;; Replace list-buffers with ibuffer
(defalias 'list-buffers 'ibuffer)

;; Line numbers
(setq linum-format "%4d ")
(add-hook 'prog-mode-hook (lambda () (linum-mode 1)))

;; Disable scrollbar and toolbar
(scroll-bar-mode 0)
(tool-bar-mode 0)

;; Use y-or-n instead of yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)

;; Show matching parens
(show-paren-mode 1)

;; Automatically revert buffer on changes
(global-auto-revert-mode t)

;; Record changes in the window configuration
(winner-mode 1)

;; Tell emacs to use visual-lines
(global-visual-line-mode 1)

;; Tabs are evil
(setq-default indent-tabs-mode 0)
(setq-default tab-width 2)
(setq c-basic-offset 2)
(setq cperl-indent-level 2)
(setq js2-basic-offset 2)
(setq css-indent-offset 2)
(setq sh-basic-offset 2)

;; Backup files: don't create them
(setq make-backup-files nil)
(setq auto-save-default nil)

;;;;;;;;;;;;;;;;;;;
;; Misc packages ;;
;;;;;;;;;;;;;;;;;;;

;; try a package before installing it
(use-package try)

;; Keep the emacs kill ring and the system clipboard separate
(use-package simpleclip
  :config
  (simpleclip-mode))

;; Dim windows which aren't in focus
(use-package dimmer
  :config
  (setq dimmer-fraction 0.2)
  (setq dimmer-exclusion-regexp "^\*helm.*\\|^ \*Minibuf-.*\\|^ \*Echo.*")
  (dimmer-mode))

;; Help with key-combinations
(use-package which-key
  :config (which-key-mode))

;; Easy way to select between delimeters
(use-package expand-region
  :config (global-set-key (kbd "C-s=") 'er/expand-region))

;; Maintain undo history
(use-package undo-tree
  :config (global-undo-tree-mode))

;; Make it easier to deal with parens
(use-package smartparens
  :config
  (require 'smartparens-config)
  (add-hook 'prog-mode-hook (lambda () (smartparens-mode))))

;; Highlight and navigate between todos
(use-package hl-todo
  :config
  (progn
    (global-set-key (kbd "C-c p") 'hl-todo-previous)
    (global-set-key (kbd "C-c n") 'hl-todo-next)
    (global-set-key (kbd "C-c o") 'hl-todo-occur)
    (add-hook 'prog-mode-hook hl-todo-mode)))

(use-package projectile
  :config
  (projectile-global-mode))

;; Install key-chord
(use-package key-chord)

;; Install evil mode
(use-package evil
  :requires (key-chord)
  :config
  (progn
    (evil-mode 1)
    ;; Enable emacs keys in insert mode
    (setcdr evil-insert-state-map nil)
    ;; Map jk to <esc>
    (setq key-chord-two-keys-delay 0.5)
    (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
    (key-chord-mode 1)))

;; surround.vim
(use-package evil-surround
  :requires (evil)
  :config
  (global-evil-surround-mode 1))

;; On the fly syntax checking
(use-package flycheck
  :config
  (global-flycheck-mode))

;; On the fly spell checking
(setq ispell-program-name "/usr/local/bin/aspell")
(add-hook 'text-mode-hook flyspell-mode)

;; Magit
(use-package magit
  :bind
  ("C-x m" . magit)
  ("C-x p" . magit-push-to-remote))

;;;;;;;;;;;;;;;;;;;;;
;; Ivy and friends ;;
;;;;;;;;;;;;;;;;;;;;;

(use-package ivy
  :diminish (ivy-mode)
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-display-style 'fancy))

(use-package counsel
  :bind
  (("M-y" . counsel-yank-pop)
  :map ivy-minibuffer-map
  ("M-y" . ivy-next-line)))

(use-package swiper
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)
	 ("C-c C-r" . ivy-resume)
	 ("M-x" . counsel-M-x)
	 ("C-x C-g" . counsel-ag)
	 ("C-x C-f" . counsel-find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)))

;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom minor modes ;;
;;;;;;;;;;;;;;;;;;;;;;;;

(defvar-local my/hidden-mode-line-mode nil)
(defvar-local hide-mode-line nil)
(define-minor-mode my/hidden-mode-line-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global nil
  :variable my/hidden-mode-line-mode
  :group 'editing-basics
  (if my/hidden-mode-line-mode
      (setq hide-mode-line mode-line-format
	    mode-line-format nil)
    (setq mode-line-format hide-mode-line
	  hide-mode-line nil))
  (force-mode-line-update)
  ;; Apparently force-mode-line-update is not always enough to
  ;; redisplay the mode-line
  (redraw-display)
  (when (and (called-interactively-p 'interactive)
	     my/hidden-mode-line-mode)
    (run-with-idle-timer
     0 nil 'message
     (concat "Hidden Mode Line Mode enabled.  "
	     "Use M-x my/hidden-mode-line-mode to make the mode-line appear."))))

(defvar my/big-fringe-mode nil)
(define-minor-mode my/big-fringe-mode
  "A small minor mode to use a big fringe."
  :init-value nil
  :global t
  :variable my/big-fringe-mode
  :group 'editing-basics
  (if (not my/big-fringe-mode)
      (set-fringe-style nil)
    (set-fringe-mode
     (/ (- (frame-pixel-width)
           (* 100 (frame-char-width)))
        2))))
;; Activate with
;; (my/big-fringe-mode 1)

;;;;;;;;;;;;;;;;
;; Aesthetics ;;
;;;;;;;;;;;;;;;;

;; Application top bar
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq frame-title-format "emacs@macbook")

;; Set the font
(add-to-list 'default-frame-alist '(font . "Ubuntu Mono derivative Powerline" ))
(set-face-attribute 'default nil
                    :family "Ubuntu Mono derivative Powerline"
                    :height 150
                    :weight 'normal
                    :width 'normal))

;; Theme
(use-package cyberpunk-theme
  :config
  (load-theme 'cyberpunk t))

;; Fancy icons
(use-package all-the-icons)

;; TODO: Try telephone-line
;; Fancy modeline
(use-package doom-modeline
      :hook (after-init . doom-modeline-mode))

;; Fix the fringe
(if (display-graphic-p)
    (set-face-attribute 'fringe nil :background "black")))

;; Set the cursor
(setq-default cursor-type '(bar . 2))
(blink-cursor-mode 0)
(set-face-attribute 'cursor nil :background "#2977f5")

;;;;;;;;;;;;;;;;;;
;; Eshell stuff ;;
;;;;;;;;;;;;;;;;;;

;; Help for opening eshell
(defun my/open-esh-to-side ()
"Open a new eshell window to the side."
(interactive)
(split-window-right)
(other-window 1)
(eshell))

(defun my/open-esh-below ()
"Open a new eshell window below the current one."
(interactive)
(split-window-below)
(other-window 1)
(eshell))


;; Bind eshell to a hotkey
(global-set-key (kbd "M-s e") 'my/open-esh-to-side)
(global-set-key (kbd "M-s M-e") 'my/open-esh-below)


;; Get PATH variable from shell
(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

;; Some aliases
(defalias 'ff 'find-file)
(defalias 'ffo 'find-file-other-window)

;; Nice prompt
(use-package eshell-git-prompt
  :ensure t
  :config (eshell-git-prompt-use-theme 'default))

;;;;;;;;;;;;;;;;
;; Completion ;;
;;;;;;;;;;;;;;;;

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-idle-delay 0)
  (global-set-key (kbd "C-c /") 'company-files))

;;;;;;;;;;;;
;; Python ;;
;;;;;;;;;;;;

;; Set python3 as the python shell interpreter and default python command.
(setq py-python-command "python3")
(setq python-shell-interpreter "python3")

(use-package company-jedi)

(use-package elpy
  :config (elpy-enable))

(defun my/python-mode-hook ()
"Settings for python mode."
(add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'my/python-mode-hook)

;;;;;;;;;;;;;;;;
;; JavaScript ;;
;;;;;;;;;;;;;;;;

(use-package js2-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (setq js2-strict-missing-semi-warning nil))
(add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2)))

(use-package indium)

(use-package rjsx-mode
  :config
  (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
  (define-key js2-mode-map [C-x x] 'rjsx-mode)
  (add-hook 'rjsx-mode-hook 'emmet-mode))

(use-package json-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
  (setq js-indent-level 2))

(use-package add-node-modules-path
  :config
  (add-hook 'js2-mode 'add-node-modules-path))

(use-package prettier-js
  :config
  (setq prettier-js-args '(
                           "--no-semi" "true"
                           ))
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'rjsx-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode))

(use-package yaml-mode)

;;;;;;;;;;;;;;;
;; Web stuff ;;
;;;;;;;;;;;;;;;

(use-package php-mode)
(add-hook 'php-mode-hook 'my-php-mode-hook)
(defun my-php-mode-hook ()
  "My PHP mode configuration."
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq c-basic-offset 2))

(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.ejs\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq indent-tabs-mode t))
(add-hook 'web-mode-hook  'my-web-mode-hook)

(use-package emmet-mode
  :config (add-hook 'web-mode-hook (lambda () (emmet-mode 1))))

(use-package less-css-mode)

(use-package markdown-mode)

(use-package pug-mode)

(use-package restclient)

(use-package css-eldoc
  :config
  (add-hook 'css-mode '(lambda ()
                         (eldoc-mode)
                         (css-eldoc-enable))))

;;;;;;;;;;;;;;;
;; Org stuff ;;
;;;;;;;;;;;;;;;


(use-package org
  :pin org)

;; Prettify inline code blocks 
(setq org-src-fontify-natively t)

;; Get nice bullets in org-mode
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook 'org-bullets-mode))

;; Capture stuff
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-agenda-files (list "~/code/scratchpad.org"))
(setq org-capture-templates
      '(("n" "Note" entry (file+headline "~/life/scratchpad.org" "Note")
	 "* %?\n%T")
	("t" "Exun" entry (file+headline "~/life/scratchpad.org" "Exun")
	 "* %?\n%T" :prepend t)))

;; Show inline images
(setq org-startup-with-inline-images 1)

