;;; slipshow-eglot.el --- Eglot extensions for slipshow -*- coding: utf-8; lexical-binding: t -*-

(require 'eglot)

(defun slipshow--execute-command (cmd args)
  "Make a request to the server"
  (eglot-execute
   (eglot-current-server)
   `(:command ,cmd :arguments ,args)))

;; Could be a function but earlier versions made sense as a macro (I wanted to
;; exercise my macro writing)
(defmacro slipshow--check-capability (capability expected-value command-name payload error-msg)
  "Check if the capability exists with the right value, and if so, make an execute-command request with given name and payload"
  `(let* ((capability-v (eglot-server-capable ,@capability)))
    (if (equal capability-v ,expected-value)
        (slipshow--execute-command ,command-name ,payload)
      (message ,error-msg))))

(defun slipshow-preview-go-next ()
  "Go forward one step in the preview"
  (interactive)
  (slipshow--check-capability
      (:experimental :move_from_editor :version)
      1
      "slipshow.go_next"
      (vector (eglot-path-to-uri (buffer-file-name)))
    "The version of the Slipshow you have does not support editor-controlled movements. You need at least version 0.12.0."))

(defun slipshow-preview-go-previous ()
  "Go backward one step in the preview"
  (interactive)
  (slipshow--check-capability
      (:experimental :move_from_editor :version)
      1
      "slipshow.go_previous"
      (vector (eglot-path-to-uri (buffer-file-name)))
    "The version of the Slipshow you have does not support editor-controlled movements. You need at least version 0.12.0."))

(provide 'slipshow-eglot)
