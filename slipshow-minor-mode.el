;;; slipshow.el --- A Slipshow companion for Eglot   -*- coding: utf-8; lexical-binding: t -*-

(defun slipshow-show ()
  (interactive)
  (message "show from slipshow"))

;;;###autoload
(define-minor-mode
  slipshow-minor
  "Integration with the Slipshow compiler"
  :lighter " SLIP")

