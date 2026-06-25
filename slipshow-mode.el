;;; slipshow.el --- Main mode for Slipshow -*- coding: utf-8; lexical-binding: t -*-

(require 'slipshow-eglot)

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

(defun slipshow-config ()
  "Compute the config for slipshow from the custom variables."
  `(:slipshow
    (:refreshOn
     ,(pcase slipshow-refresh-on
        ('on-key-stroke "Key stroke")
        ('on-save "Save")))))

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
