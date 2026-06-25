;;; slipshow-eglot.el --- Eglot extensions for slipshow -*- coding: utf-8; lexical-binding: t -*-

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

(defun slipshow-config ()
  "Compute the config for slipshow from the custom variables."
  `(:slipshow
    (:refreshOn
     ,(pcase slipshow-refresh-on
        ('on-key-stroke "Key stroke")
        ('on-save "Save")))))

(defgroup slipshow nil
  "Major mode for interacting with Slipshow."
  :link '(url-link "https://slipshow.org")
  :group 'languages
  :prefix "slipshow-")

(defun slipshow--set-and-resend-conf (symbol value)
  "Set a config symbol and send the new conf to all slipshow eglot servers."
  (set-default symbol value)
  (slipshow-resend-conf))

(defcustom slipshow-refresh-on 'on-key-stroke
  "When to refresh the slipshow preview"
  :group 'slipshow
  :set #'slipshow--set-and-resend-conf
  :type '(choice (const :tag "Refresh on every key stroke" on-key-stroke)
                 (const :tag "Refresh on save" on-save)))

(defun slipshow--set-dir-locals-var ()
  "Sets the dir locals variables"
  (dir-locals-set-class-variables
   'slipshow-class
   `((slipshow-mode
     . ((eglot-workspace-configuration
         . ,(slipshow-config))))))
  (let ((dir
         (if-let*
             ((p-cur (project-current)))
             (project-root p-cur)
           default-directory)))
    (dir-locals-set-directory-class dir 'slipshow-class)))

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
                (slipshow--set-dir-locals-var)
                (eglot-signal-didChangeConfiguration server))))))))) ; So many closing parenthesis...

(provide 'slipshow-eglot)
