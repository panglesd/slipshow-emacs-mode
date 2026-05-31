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

(provide 'slipshow-eglot)
