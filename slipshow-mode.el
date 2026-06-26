;;; slipshow-mode.el --- Major mode for Slipshow -*- lexical-binding: t -*-

;; Copyright (C) 2026 Paul-Elliot Anglès d'Auriac

;; Author: Paul-Elliot <peada@free.fr>
;; Version: 0.1
;; Package-Requires: ((markdown-mode "0") (emacs "29.1"))
;; Keywords: slipshow, presentation
;; URL: https://slipshow.org

;;; Commentary:

;; This package provides support to slipshow. It defines a major mode for
;; editing .slp files, start the preview server and communicate with it.

(require 'slipshow-eglot)
(require 'slipshow-config)
(require 'markdown-mode)

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.slp\\'" . slipshow-mode))

;;;###autoload
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(slipshow-mode . ("slipshow" "lsp"))))

;;;###autoload
(define-derived-mode slipshow-mode
  markdown-mode "Slipshow"
  "Major mode for editing slipshow files"
  (slipshow--set-dir-locals-var)
  (eglot-ensure))

(provide 'slipshow-mode)
