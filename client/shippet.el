(require 'yasnippet)
(require 'deferred)
(require 'url)
(require 'json)

(defvar shippet:url "http://localhost:9393/")

;; get snippet
;; (shippet:get-snippet snippet_id)
(defun shippet:upload-snippet ()
  (interactive)
  (deferred:$
    (deferred:url-post (concat shippet:url "snippet/create")
      `((mode . "test-mode") (code . ,(buffer-string)))) ;; get major mode
    (deferred:nextc it
      (lambda (buf)
        (message (shippet:string-from-buffer buf))))))

(defun shippet:get-snippet (id)
  (deferred:$
    (deferred:url-get (concat shippet:url "snippet/json?snippet_id=" id))
    (deferred:nextc it
      #'shippet:download-handler)))

(defun shippet:download-handler (buf)
  (let* ((ret (json-read-from-string (shippet:string-from-buffer buf)))
         (mode (cdr (assoc 'mode ret)))
         (snippet (cdr (assoc 'snippet ret)))
         (file (shippet:create-buffer-from-mode mode)))
    (shippet:snippet-string-to-buffer snippet file)))

(defun shippet:string-from-buffer (buf)
  (with-current-buffer buf (buffer-string)))

(defun shippet:create-buffer-from-mode (mode)
  (get-buffer-create mode))

(defun shippet:snippet-string-to-buffer (str buf)
  (let* ((snippet-list (split-string str "#[ \t]*--[ \t]*\n"))
         (header (car snippet-list))
         (body (concat "# --\n" (cadr snippet-list))))
    (switch-to-buffer-other-window buf)
    (snippet-mode)
    (insert body)
    (goto-char (point-min))
    (yas/expand-snippet header)))

(provide 'shippet)
