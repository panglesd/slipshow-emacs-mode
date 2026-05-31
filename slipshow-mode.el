;;; slipshow.el --- Main mode for Slipshow -*- coding: utf-8; lexical-binding: t -*-

(require 'markdown-mode)
(require 'slipshow-eglot)

;;;###autoload
(define-derived-mode slipshow-mode
  markdown-mode "Slipshow"
  "Major mode for editing slipshow files"
  (slipshow-minor))
