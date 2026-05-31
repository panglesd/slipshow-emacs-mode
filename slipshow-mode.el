;;; slipshow.el --- Main mode for Slipshow -*- coding: utf-8; lexical-binding: t -*-

(require 'slipshow-eglot)

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.slp\\'" . slipshow-mode))

;;;###autoload
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(slipshow-mode . "slipshow lsp")))

;;;###autoload
(define-derived-mode slipshow-mode
  markdown-mode "Slipshow"
  "Major mode for editing slipshow files"
  (eglot-ensure))
