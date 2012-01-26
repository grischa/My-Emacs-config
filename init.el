(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(appmenu-mode t)
 '(column-number-mode t)
 '(inhibit-startup-screen t)
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
(global-hl-line-mode 1)
(set-face-background 'hl-line "#330")

(add-to-list 'load-path "~/.emacs.d/")
(require 'color-theme)
(color-theme-initialize)
(load-file "~/.emacs.d/themes/color-theme-blackboard.el")
(color-theme-blackboard)
;;(load "~/.emacs.d/js2.el")
(add-to-list 'auto-mode-alist '("\\.json\\'" . javascript-mode))
;;    (autoload 'javascript-mode "javascript" nil t)
(load "~/.emacs.d/nxhtml/autostart.el")

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)
(global-auto-complete-mode t)


(require 'ibuffer)
(setq ibuffer-saved-filter-groups
  (quote (("default"
            ("Python"
	     (mode . python-mode))
            ("Programming" ;; prog stuff not already in MyProjectX
             (or
              (mode . c-mode)
              (mode . perl-mode)
	      (mode . emacs-lisp-mode)
	      ;; etc
	      ))
            ;;("ERC"   (mode . erc-mode))
	    ))))
(add-hook 'ibuffer-mode-hook
  (lambda ()
    (ibuffer-switch-to-saved-filter-groups "default")))
(global-set-key (kbd "C-x C-b") 'ibuffer)


(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)

(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)


;; Flymake Python
(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list "~/.emacs.d/pycheckers" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-pyflakes-init)))
(load-library "flymake-cursor")
(global-set-key [f10] 'flymake-goto-prev-error)
(global-set-key [f11] 'flymake-goto-next-error)

(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-m" 'newline-and-indent)))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'python-mode-hook
          (lambda ()
            (flyspell-prog-mode)))

(when (load "flymake" t)
  (defun flymake-closure-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "~/.emacs.d/closure.sh" (list local-file))))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.js\\'" flymake-closure-init)))

(add-hook 'javascript-mode-hook
	      (lambda () (flymake-mode t)))

;; (when (load "flymake" t)
;;   (defun flymake-html-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;  		       'flymake-create-temp-inplace))
;;  	   (local-file (file-relative-name
;;  			temp-file
;;  			(file-name-directory buffer-file-name))))
;;       (list "tidy" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;  	       '("\\.html$\\|\\.ctp" flymake-html-init))
;;   (add-to-list 'flymake-err-line-patterns
;;  	       '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
;;  		 nil 1 2 4)))


(defconst css-validator "java -jar ~/.emacs.d/css-validator/css-validator.jar")

(defun flymake-css-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list css-validator (list "-output gnu" (concat "file:" local-file)))))

(push '(".+\\.css$" flymake-css-init) flymake-allowed-file-name-masks)
(push '("^file:\\([^:]+\\):\\([^:]+\\):\\(.*\\)" 1 2 nil 3) flymake-err-line-patterns)

(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

(add-hook 'python-mode-hook
	      (lambda () (highlight-changes-mode t)))
;;(global-highlight-changes t)

(set-face-foreground 'highlight-changes nil)
(set-face-background 'highlight-changes "#382f2f")
(set-face-foreground 'highlight-changes-delete nil)
(set-face-background 'highlight-changes-delete "#916868")

(defun highlight-changes-remove-after-save ()
  "Remove previous changes after save."
  (make-local-variable 'after-save-hook)
  (add-hook 'after-save-hook
	    (lambda ()
		(highlight-changes-remove-highlight (point-min) (point-max)))))

(add-hook 'after-save-hook 'highlight-changes-remove-after-save)
(set-face-background 'default "black")
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)