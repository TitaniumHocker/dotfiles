(setq inhibit-startup-message t) ; Disable startup message

(tool-bar-mode -1) ; Disable toolbar
(menu-bar-mode -1) ; Disable menubar
(scroll-bar-mode -1) ; Disable scrollbar
(setq use-dialog-box nil) ; Disable popup dialogs

(setq redisplay-dont-pause t
      scroll-margin 5
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)
(setq mouse-wheel-scroll-amount '(0.10))
(setq mouse-wheel-progressive-speed nil)

(setq redisplay-dont-pause t)

(setq ring-bell-function 'ignore)

(setq user-emacs-directory (expand-file-name "~/.cache/emacs"))

(setq no-littering-etc-directory
      (expand-file-name "config/" user-emacs-directory))
(setq no-littering-var-directory
      (expand-file-name "data/" user-emacs-directory))
(use-package no-littering)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

(global-display-line-numbers-mode 1)

(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq-default indent-tabs-mode nil)
(setq c-basic-indent 4)
(setq tab-width 4)

(electric-pair-mode t)

(recentf-mode 1)

(add-to-list 'recentf-exclude
             (recentf-expand-file-name no-littering-var-directory))
(add-to-list 'recentf-exclude
             (recentf-expand-file-name no-littering-etc-directory))

(savehist-mode 1)

(setq history-length 50)

(save-place-mode 1)

(global-auto-revert-mode 1)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(set-fringe-mode 10)

(set-frame-parameter nil 'alpha-background 95)
(add-to-list 'default-frame-alist '(alpha-background . 95))

(set-frame-font "JetBrains Mono 12" nil t)

(use-package gruvbox-theme)
(load-theme
 'gruvbox-dark-soft
 :no-confirm)

(use-package all-the-icons)

(use-package evil)
(evil-mode 1)

(use-package tree-sitter)
(use-package tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))

(use-package minimap)

(use-package treemacs
  :defer t
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package lsp-mode
  :hook (c-mode . lsp)
  :custom
  (lsp-diagnostics-clean-after-change t)
  (lsp-diagnostics-flycheck-default-level 'info))
(setq lsp-keymap-prefix "C-l")
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))
(use-package flycheck
  :init (global-flycheck-mode))

(setq gc-cons-threshold 100000000) ; 100mb
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-sideline-show-diagnostics t))

(use-package company
  :init (global-company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-select-next)
              ("<backtab>" . company-select-previous))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.01))
