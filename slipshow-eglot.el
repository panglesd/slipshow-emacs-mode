(require 'eglot)

(defun slipshow--execute-command (cmd args)
  "Make a request to the server"
  (eglot-execute
   (eglot-current-server)
   `(:command ,cmd :arguments ,args)))

(defun slipshow-preview-go-next ()
  "Go forward one step in the preview"
  (interactive)
  (slipshow--execute-command
   "slipshow.go_next"
   (vector (eglot-path-to-uri (buffer-file-name)))))

(defun slipshow-preview-go-previous ()
  "Go backward one step in the preview"
  (interactive)
  (slipshow--execute-command
   "slipshow.go_previous"
   (vector (eglot-path-to-uri (buffer-file-name)))))

;; Create a variable containing the servers that were already notified
;; For every buffer
;;   If the buffer has an eglot server (eglot-current-server) and has the slipshow major mode
;;   Then call eglot-signal-didChangeConfiguration
(defun slipshow-resend-conf ()
  "Resend the configuration to all open slipshow eglot servers."
  (when (fboundp 'eglot-current-server)
    (let ((signaled-servers nil))
      (dolist (buf (buffer-list))
        (with-current-buffer buf
          (when (derived-mode-p 'slipshow-mode)
            (when-let* ((server (eglot-current-server)))
              (unless (memq server signaled-servers)
                (push server signaled-servers)
                (eglot-signal-didChangeConfiguration server))))))))) ; So many closing parenthesis...

(provide 'slipshow-eglot)
