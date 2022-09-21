;;; -*- lexical-binding: t; -*-

(configuration-layer/declare-layers
 '(;; Core
   (auto-completion :variables
                    auto-completion-return-key-behavior 'complete
                    auto-completion-tab-key-behavior 'complete
                    auto-completion-enable-snippets-in-popup t)
   better-defaults
   (git :variables
        git-enable-magit-gitflow-plugin t)
   (ivy :variables
        ivy-extra-directories nil)
   (org :variables
        org-want-todo-bindings t)
   (shell :variables
          shell-default-shell 'eshell)
   syntax-checking
   (version-control :variables
                    version-control-global-margin t
                    version-control-diff-tool 'git-gutter+)

   ;; Misc
   graphviz
   ranger
   (ibuffer :variables
            ibuffer-group-buffers-by 'projects)
   xkcd

   ;; Markups
   csv
   html
   markdown
   yaml

   ;; Languages
   ( lsp :variables
     lsp-lens-enable t
     lsp-elixir-suggest-specs t
     lsp-elixir-fetch-deps nil
     lsp-elixir-mix-env "dev"
     lsp-solargraph-use-bundler t)
   clojure
   (elixir :variables elixir-backend 'lsp elixir-ls-path "/home/anton/.emacs.d/.cache/lsp/elixir-ls")
   ;; elixir
   emacs-lisp
   haskell
   ruby
   ruby-on-rails
   sql
   hy  ; I wrote this mode/layer

   (c-c++ :variables
          ;; c-c++-backend 'lsp-ccls
          c-c++-backend 'lsp-cquery
          c-c++-enable-google-style t
          c-c++-enable-google-newline t)

   (python :variables

           python-backend 'lsp
           python-lsp-server 'pyls
           ;; python-lsp-server 'mspyls
           python-pipenv-activate t

           python-test-runner 'pytest
           python-spacemacs-indent-guess nil)



   ;; Experimental/in-flux
   ))
