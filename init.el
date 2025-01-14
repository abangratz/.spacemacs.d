;;; Setup -*- lexical-binding: t; -*-
;;;; Commentary

;; -- Eric Kaschalk's Spacemacs Configuration --
;; -- Contact: ekaschalk@gmail.com --
;; -- MIT License --
;; -- Emacs 26.1 ~ Spacemacs Dev Branch 0.300.0.x ~ pkgs updated: 1/21/19 --
;; -- http://modernemacs.com --
;;
;; Personal layers host most of my configuration - see README.
;; Ligatures and icons require installation - see README.
;;
;; Layers are declared in `layers/config/layers.el'.
;;
;; Set `redo-bindings?' to true if you - want my aggressive rebindings.
;; Set `server?'        to true if you - use emacs as a daemon.
;;
;; `init.el' sets spacemacs up, defining required `dotspacemacs/..' funcs & vars.

;;;; Constants

(defconst eric?    (string= "Eric Kaschalk" (user-full-name)) "Am I Eric?")
(defconst tony?    (string= "Anton Bangratz" (user-full-name)) "Am I me?")
(defconst linux?   (eq system-type 'gnu/linux) "Are we on a linux machine?")
(defconst mac?     (eq system-type 'darwin)    "Are we on a macOS machine?")
(defconst windows? (not (or linux? mac?))      "Are we on windows machine?")

;;;; Configuration

(defvar server? (if tony? t nil)
  "Alias `dotspacemacs-enable-server'. Defaults to nil for non-tony users.")

(defvar redo-bindings? (if eric? t nil)
  "Redo spacemacs bindings? Defaults to, and I recommend, nil to non-tony users.

See the commentary in the config layer's local pkg `redo-spacemacs'.")

;;; Spacemacs/
;;;; Spacemacs/init

(defun dotspacemacs/init ()
  "Instantiate Spacemacs core settings.

All `dotspacemacs-' variables with values set different than their defaults.

They are all defined in `~/.emacs.d/core/core-dotspacemacs.el'.
Check `dotspacemacs/get-variable-string-list' for all vars you can configure."
  (setq-default
   dotspacemacs-default-font '(("Fira Code"
                                :size 32
                                :weight normal
                                :width normal
                                :powerline-scale 1.1)
                               ("Fira Code Symbol"
                                :size 32
                                :weight normal
                                :width normal
                                :powerline-scale 1.1))
   dotspacemacs-themes       '(solarized-dark
                               zenburn)

   ;; General
   dotspacemacs-auto-generate-layout-names t
   dotspacemacs-editing-style              '(vim :variables
                                                 vim-style-visual-feedback t
                                                 vim-style-remap-Y-to-y$ t)
   dotspacemacs-elpa-https                 nil
   dotspacemacs-elpa-subdirectory          nil
   dotspacemacs-enable-server              server?
   dotspacemacs-fullscreen-at-startup      nil
   dotspacemacs-folding-method             'origami
   dotspacemacs-large-file-size            5
   dotspacemacs-persistent-server          server?
   dotspacemacs-pretty-docs                t
   dotspacemacs-search-tools               '("ag" "rg" "pt" "ack" "grep")
   dotspacemacs-scratch-mode               'org-mode
   dotspacemacs-startup-lists              '((recents . 10))
   dotspacemacs-whitespace-cleanup         'trailing

   ;; The following are unchanged but are still required for reloading via
   ;; 'SPC f e R' `dotspacemacs/sync-configuration-layers' to not throw warnings
   dotspacemacs-emacs-leader-key  "M-m"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-leader-key        "SPC"
   dotspacemacs-mode-line-theme   'all-the-icons
   dotspacemacs-install-packages  'used-but-keep-unused
   ))

;;;; Spacemacs/layers

(defun dotspacemacs/layers ()
  "Instantiate Spacemacs layers declarations and package configurations."
  (setq-default
   dotspacemacs-configuration-layers     '(javascript
                                           (config   :location local)
                                           (display  :location local)
                                           (personal :location local))
   dotspacemacs-configuration-layer-path '("~/.spacemacs.d/layers/")
   dotspacemacs-additional-packages      '(buttercup fira-code-mode polymode)
   dotspacemacs-frozen-packages          '()
   dotspacemacs-excluded-packages
   '(;; Must Exclude (for styling, functionality, bug-fixing reasons)
     fringe importmagic vi-tilde-fringe

     ;; Packages I don't use (non-exhaustive)
     anzu centered-cursor-mode column-enforce-mode company-statistics
     doom-modeline eshell-prompt-extras evil-anzu evil-mc evil-tutor
     fancy-battery fill-column-indicator gnuplot golden-ratio
     live-py-mode multi-term multiple-cursors mwim neotree paradox py-isort
     yapfify)))

;;;; Spacemacs/user-init

(defun dotspacemacs/user-init ()
  "Package independent settings to run before `dotspacemacs/user-config'."
  (fringe-mode 0)
  (setq custom-file "~/.spacemacs.d/.custom-settings.el"))

;;;; Spacemacs/user-config
;;;;; Post Layer Load

(defun dotspacemacs/user-config/post-layer-load-config ()
  "Configuration to take place *after all* layers/pkgs are instantiated."
  (when (and (boundp 'redo-bindings?) redo-bindings?
             (configuration-layer/package-used-p 'redo-spacemacs))
    (redo-spacemacs-bindings))
  )

;;;;; Core

(defun dotspacemacs/user-config ()
  "Configuration that cannot be delegated to layers."
  (dotspacemacs/user-config/post-layer-load-config)
  (defalias 'forward-evil-word 'forward-evil-symbol)
  ;; Drop-in whatever config here, experiment!
  ;; Prevent undo tree files from polluting your git repo
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (define-hostmode poly-elixir-hostmode :mode 'elixir-mode)
  (define-innermode poly-surface-expr-elixir-innermode
    :mode 'web-mode
    :head-matcher (rx line-start (* space) "~H" (= 3 (char "\"'")) line-end)
    :tail-matcher (rx line-start (* space) (= 3 (char "\"'")) line-end)
    :head-mode 'host
    :tail-mode 'host
    :allow-nested nil
    :keep-in-mode 'host
    :fallback-mode 'host)
  (define-polymode poly-elixir-web-mode
    :hostmode 'poly-elixir-hostmode
    :innermodes '(poly-surface-expr-elixir-innermode))
  (setq web-mode-engines-alist
        '(("elixir" . "\\.heex\\'") ("elixir" . "\\.ex\\'")))
  (add-to-list 'auto-mode-alist '("\\.ex" . poly-elixir-web-mode))
  (add-to-list 'auto-mode-alist '("\\.heex" . web-mode))
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)
  ;; Set Elixir LSP hooks (in this case, format on save).
  (add-hook 'elixir-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'lsp-format-buffer nil t)))

  ;; Disable Dialyzer in `elixir-ls`.
  (defvar lsp-elixir--config-options (make-hash-table))
  (puthash "dialyzerEnabled" :json-false lsp-elixir--config-options)
  (add-hook 'lsp-after-initialize-hook
            (lambda ()
              (lsp--set-configuration `(:elixirLS, lsp-elixir--config-options))))
  )
