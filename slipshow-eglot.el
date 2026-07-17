;;; slipshow-eglot.el --- Eglot extensions for slipshow -*- coding: utf-8; lexical-binding: t -*-

(require 'eglot)

;; Without the :extra keyword, the new method replaces any other method with the
;; same level of specificity. From the docs:
;;
;;   The optional EXTRA element, expressed as ‘:extra STRING’, allows
;;   you to add more methods, distinguished by STRING, for the same
;;   specializers and qualifiers.
;;
;; Because we don't want to replace, eg ocaml-eglot one's, we use it.
;; Another option would be to define a specificity.
(cl-defmethod eglot-client-capabilities :extra "slipshow" :around (_)
  "Add client capabilities to Eglot for Slipshow server."
  (let* ((slipshow-capabilities '(:move_from_editor (:version 1)))
         (capabilities (copy-tree (cl-call-next-method)))
         (experimental (plist-get capabilities :experimental))
         (experimental
          (cond
           ;; Eglot mainly uses plists to represent json, but some (I'm looking
           ;; at you, ocaml-eglot!) uses hashtables. This is supported by emacs
           ;; (through jsonrpc). So we distinguish by (dynamic...) type.
           ((hash-table-p experimental)
            (puthash "slipshow" slipshow-capabilities experimental)
            experimental)
           ((plistp experimental)
            (plist-put
                        experimental
                        :slipshow
                        slipshow-capabilities))
           ((t) '()))))
    (plist-put capabilities :experimental experimental)))

(defun slipshow--execute-command (cmd args)
  "Make a request to the server"
  (eglot-execute
   (eglot-current-server)
   `(:command ,cmd :arguments ,args)))

;; Could be a function but earlier versions made sense as a macro (I wanted to
;; exercise my macro writing)
(defmacro slipshow--check-capability (capability check command-name payload error-msg)
  "Check if the capability exists with the right value, and if so, make an execute-command request with given name and payload"
  `(let* ((capability-v (eglot-server-capable :experimental :slipshow ,@capability)))
    (if (funcall ,check capability-v)
        (slipshow--execute-command ,command-name ,payload)
      (message ,error-msg))))

(defconst slipshow--move-error-message
  "The version of the Slipshow you have does not support editor-controlled movements. You need at least version 0.12.0.")

(defun slipshow-preview-go-next ()
  "Go forward one step in the preview"
  (interactive)
  (slipshow--check-capability
      (:move_from_editor :version)
      #'identity
      "slipshow.go_next"
      (vector (eglot-path-to-uri (buffer-file-name)))
    slipshow--move-error-message))

(defun slipshow-preview-go-previous ()
  "Go backward one step in the preview"
  (interactive)
  (slipshow--check-capability
      (:move_from_editor :version)
      #'identity
      "slipshow.go_previous"
      (vector (eglot-path-to-uri (buffer-file-name)))
    slipshow--move-error-message))

(provide 'slipshow-eglot)
