;;; pde.el --- Perl Development Environment

;; Copyright (C) 2007 Free Software Foundation, Inc.
;;
;; Author: Ye Wenbin <wenbinye@gmail.com>
;; Maintainer: Ye Wenbin <wenbinye@gmail.com>
;; Created: 23 Dec 2007
;; Version: 0.01
;; Keywords: languages, tools, convenience, unix

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; 

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'pde)

;;; Code:

(eval-when-compile
  (require 'cl))
(require 'pde-project)
(require 'imenu-tree)
(require 'perldoc)

(defvar pde-initialized nil
  "Indicate whether PDE has been initialized.")

(defvar pde-perl-menu nil
  "*PDE Menu")

;;{{{  Key bindings
(defvar pde-cperl-prefix "\C-c\C-c"
  "*prefix key for cperl commands that maybe not used often.")

(defvar pde-cperl-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-e" 'cperl-toggle-electric)
    (define-key map "\C-j" 'cperl-linefeed)
    (define-key map "\C-n" 'cperl-narrow-to-here-doc)
    (define-key map "\C-p" 'cperl-pod-spell)
    (define-key map "\C-t" 'cperl-invert-if-unless)
    (define-key map "\C-v" 'cperl-next-interpolated-REx)
    (define-key map "\C-x" 'cperl-next-interpolated-REx-0)
    (define-key map "\C-y" 'cperl-next-interpolated-REx-1)
    map)
  "*keymap for cperl commands that maybe not used often.")

(defvar pde-view-prefix "\C-c\C-v"
  "*prefix for view commands")

(defvar pde-view-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-i" 'pde-imenu-tree)
    (define-key map "\C-p" 'pde-perldoc-tree)
    (define-key map "\C-m" 'pde-pod-to-manpage)
    map)
  "*Keymap for view commands")

(defvar pde-perltidy-prefix "\C-c\C-t"
  "*prefix key for perltidy commands")

(defvar pde-perltidy-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-r" 'perltidy-region)
    (define-key map "\C-b" 'perltidy-buffer)
    (define-key map "\C-s" 'perltidy-subroutine)
    (define-key map "\C-t" 'perltidy-dwim)
    map)
  "*Keymap for perltidy commands.")

(defvar pde-inf-perl-prefix "\C-c\C-e"
  "*prefix key for inf-perl commands")

(defvar pde-inf-perl-map
  (let ((map (make-sparse-keymap)))
    ;; Install the process communication commands in the cperl-mode keymap
    (define-key map "\C-e" 'inf-perl-send)
    (define-key map "\C-j" 'inf-perl-send-line)
    (define-key map "\C-r" 'inf-perl-send-region)
    (define-key map "\C-s" 'inf-perl-set-cwd)
    (define-key map "\M-r" 'inf-perl-send-region-and-go)
    (define-key map "\C-l" 'inf-perl-load-file)
    (define-key map "\C-y" 'inf-perl-switch-to-perl)
    (define-key map "\C-z" 'inf-perl-switch-to-end-perl)
    map)
  "*Keymap for inf-perl commands")
;;}}}

(defvar pde-imenu-tree-buffer "*PDE Imenu*"
  "*Buffer names for perl `imenu-tree'.")

(defvar pde-buffer-tabbar-label
  `((,perldoc-tree-buffer . "Pod Tree")
    (,pde-imenu-tree-buffer . "Imenu"))
  "*Labels for buffers")

(defvar pde-scheduler-timer nil
  "Timer used to schedule tasks in idle time.")

;;{{{  Add tabbar for perldoc-tree and imenu-tree
(defun pde-tabbar-label (tab)
  (if tabbar-buffer-group-mode
      (format "[%s]" (tabbar-tab-tabset tab))
    (let ((name (tabbar-tab-value tab)))
      (format " %s "
              (or (assoc-default name pde-buffer-tabbar-label)
                  name)))))

(defun pde-tabbar-register ()
  "Add tabbar and register current buffer to group Perl."
  (require 'tabbar-x)
  (tabbar-x-register "Perl" (current-buffer))
  (set (make-local-variable 'tabbar-home-function) nil)
  (set (make-local-variable 'tabbar-tab-label-function) 'pde-tabbar-label)
  (set (make-local-variable 'tabbar-home-button-disabled) ""))

(defun pde-imenu-tree-create-buffer (&rest ignore)
  (get-buffer-create pde-imenu-tree-buffer))

(defun pde-imenu-tree-hook ()
  (when (string= pde-imenu-tree-buffer (buffer-name))
    (pde-tabbar-register)))

;; for future extension
(defalias 'pde-perldoc-tree 'perldoc-tree)
(defalias 'pde-imenu-tree 'imenu-tree)
;;}}}

(defun pde-ffap-locate (name &optional force)
  "Return cperl module for ffap."
  (let ((mod (perldoc-module-ap)))
    (if mod
        (perldoc-locate-module mod))))
(require 'ffap)
(add-to-list 'ffap-alist  '(cperl-mode . pde-ffap-locate))

;;;###autoload 
(defun pde-compilation-buffer-name (mode)
  "Enable running multiple compilations."
  (let (bufs)
    ;; remove finished buffer
    (mapc
     (lambda (buf)
       (when (string-match "^\*compilation" (buffer-name buf))
         (if (get-buffer-process buf)
             (setq bufs (cons buf bufs))
           (kill-buffer buf))))
     (buffer-list))
    (concat "*compilation"
            (if (> (length bufs) 1)
                (format "<%d>" (length bufs)))
            "*")))

;;;###autoload 
(defun pde-ido-imenu-completion (index-alist &optional prompt)
  ;; Create a list for this buffer only when needed.
  (let ((name (thing-at-point 'symbol))
        choice
        (prepared-index-alist
         (if (not imenu-space-replacement) index-alist
           (mapcar
            (lambda (item)
              (cons (subst-char-in-string ?\s (aref imenu-space-replacement 0)
                                          (car item))
                    (cdr item)))
            index-alist))))
    (when (stringp name)
      (setq name (or (imenu-find-default name prepared-index-alist) name)))
    (setq name (funcall (if ido-mode
                            'ido-completing-read
                          'completing-read)
                        "Index item: "
                        (mapcar 'car prepared-index-alist)
                        nil t nil 'imenu--history-list
                        (and name (imenu--in-alist name prepared-index-alist) name)))
    (when (stringp name)
      (setq choice (assoc name prepared-index-alist))
      (if (imenu--subalist-p choice)
          (imenu--completion-buffer (cdr choice) prompt)
        choice))))

(defun pde-template-expand (template)
  "Setup varable for perl template."
  (let ((template-default-alist template-default-alist)
        template-expand-function
        package)
    (if (stringp template)
        (setq template (template-compile-string template)))
    (with-current-buffer (get-file-buffer template-file-name)
      (setq package (or (pde-file-package) "None")))
    (push (list "perl-module-name" package) template-default-alist)
    (push (list "minimum-perl-version" pde-perl-version)
          template-default-alist)
    (template-skeleton-expand template)))

;;;###autoload 
(defun pde-indent-dwim ()
  "Indent the region between paren.
If region selected, indent the region.
If character before is a parenthesis(such as \"]})>\"), indent the
region between the parentheses. Useful when you finish a subroutine or
a block.
Otherwise indent current subroutine. Selected by `beginning-of-defun'
and `end-of-defun'."
  (interactive)
  (let ((prev-char (char-to-string (preceding-char)))
        (next-char (char-to-string (following-char)))
        start end)
    (save-excursion
      (cond ((and transient-mark-mode mark-active)
             (setq start (region-beginning)
                   end (region-end)))
            ((string-match "[[{(<]" next-char)
             (setq start (point)
                   end (progn (forward-sexp 1) (point))))
            ((string-match "[\]})>]" prev-char)
             (setq end (point)
                   start (progn (backward-sexp 1) (point))))
            (t (setq start (progn (beginning-of-defun) (point))
                     end (progn (end-of-defun) (point)))))
      (indent-region start end))))

(defun pde-pod-to-manpage (arg)
  "View pod in current buffer using woman.
With prefix argument, reflesh the formated manpage."
  (interactive "P")
  ;; make sure there is some pods, otherwise woman will signal error
  (if (re-search-forward "^=\\sw+" nil t)
      (let* ((mod
              (if buffer-file-name
                  (file-name-sans-extension
                   (file-name-nondirectory
                    buffer-file-name))
                (file-name-sans-extension (buffer-name))))
             (buf (format "*Woman 3pm %s*" mod)))
        (if (and arg (get-buffer buf))
            (kill-buffer buf))
        (unless (buffer-live-p (get-buffer buf))
          (call-process-region (point-min) (point-max)
                               "pod2man" nil (get-buffer-create buf)
                               nil "-n" mod)
          (with-current-buffer buf
            (woman-process-buffer)
            (setq buffer-read-only t)))
        (display-buffer buf))
    (message "No pod found in current buffer")))

;;;###autoload 
(defun pde-perl-mode-hook ()
  "Hooks run when enter perl-mode"
  ;; initialize with key binding and so one
  (unless pde-initialized
    (add-to-list 'cperl-style-alist
                 '("PDE"
                   (cperl-auto-newline                         . t)
                   (cperl-brace-offset                         . 0)
                   (cperl-close-paren-offset                   . -4)
                   (cperl-continued-brace-offset               . 0)
                   (cperl-continued-statement-offset           . 4)
                   (cperl-extra-newline-before-brace           . nil)
                   (cperl-extra-newline-before-brace-multiline . nil)
                   (cperl-indent-level                         . 4)
                   (cperl-indent-parens-as-block               . t)
                   (cperl-label-offset                         . -4)
                   (cperl-merge-trailing-else                  . t)
                   (cperl-tab-always-indent                    . t)))
    (let ((map (current-local-map)))
      (easy-menu-define pde-perl-menu map
        "Menu used when PDE is enable."
        (cons "PDE"
              '(["Check syntax" compile-dwim-compile t]
                ["Run" compile-dwim-run t]
                ["Debugger" perldb-ui t]
                ["Toggle Flymake" flymake-mode t]
                "-----"
                ["Run shell" run-perl t]
                ["Perldoc Tree" pde-perldoc-tree t]
                ["Imenu Tree" pde-imenu-tree t]
                ["View Pod" pde-pod-to-manpage t]
                ("Perltidy"
                 ["Perltidy DWIM" perltidy-dwim t]
                 ["Perltidy Region" perltidy-region t]
                 ["Perltidy Buffer" perltidy-buffer t]
                 ["Perltidy Sub" perltidy-subroutine t]))))
      (define-key map pde-cperl-prefix pde-cperl-map)
      (define-key map pde-perltidy-prefix pde-perltidy-map)
      (define-key map pde-inf-perl-prefix pde-inf-perl-map)
      (define-key map pde-view-prefix pde-view-map)
      (define-key map "\C-c\C-f" 'flymake-mode)
      (define-key map "\C-c\C-z" 'run-perl)
      (define-key map "\C-c\C-d" 'perldb-ui))
    ;; with help-dwim, show prefix key bindings is more helpful
    (local-set-key "\C-c\C-h" 'describe-prefix-bindings)
    (cperl-lazy-install)
    (setq pde-initialized t))
  
  (cperl-set-style "PDE")
  (abbrev-mode t)
  (help-dwim-active-type 'perldoc)
  (set (make-local-variable 'imenu-tree-create-buffer-function)
       'pde-imenu-tree-create-buffer)
  (set (make-local-variable 'compile-dwim-check-tools) nil)
  (when (and buffer-file-name
             (not (string-match "\\.\\(pm\\|pod\\)$" (buffer-file-name))))
    (add-hook 'after-save-hook 'executable-chmod nil t)))

(provide 'pde)
;;; pde.el ends here
