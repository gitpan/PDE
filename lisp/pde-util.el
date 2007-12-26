;;; pde-util.el --- Utils for misc commands

;; Copyright (C) 2007 Free Software Foundation, Inc.
;;
;; Author: Ye Wenbin <wenbinye@gmail.com>
;; Maintainer: Ye Wenbin <wenbinye@gmail.com>
;; Created: 26 Dec 2007
;; Version: 0.01
;; Keywords: tools

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
;;   (require 'pde-util)

;;; Code:

(eval-when-compile
  (require 'cl))
(require 'pde-vars)

;; fix for don't install perl module
(defvar pde-module-location
  (when (file-exists-p (expand-file-name "../lib/" pde-load-path))
    (expand-file-name "../lib/" pde-load-path))
  "*Location for PDE perl module if not install them to @INC.")

;;;###autoload 
(defun pde-list-module-shadows ()
  "Display a list of modules that shadow other modules."
  (interactive)
  (let* ((buf (get-buffer-create "*Module Shadows*"))
         (args (if pde-module-location
                   (list (concat "-I" pde-module-location))))
         proc)
    (with-current-buffer buf
      (erase-buffer)
      (outline-mode)
      (setq proc
            (apply 'start-process "list-shadow" buf pde-perl-program
                   "-MPDE::Util" "-e" "list_shadows" args))
      (set-process-sentinel proc
                            (lambda (proc event)
                              (if (y-or-n-p "Module shadows generated, See now? ")
                                  (switch-to-buffer (process-buffer proc)))))
      (message "Wait for a while..."))))

;;;###autoload 
(defun pde-list-core-modules ()
  "Display a list of core modules."
  (interactive)
  (require 'button)
  (let (( inhibit-read-only t)
        (bufname "*Perl Core Modules*"))
    (if (get-buffer bufname)
        (switch-to-buffer bufname)
      (switch-to-buffer (get-buffer-create bufname))
      (apply 'call-process pde-perl-program nil t nil
             "-MPDE::Util" "-e" "list_core_modules"
             (if pde-module-location
                 (list (concat "-I" pde-module-location))))
      (goto-char (point-min))
      (while (not (eobp))
        (make-text-button (point)
                          (progn (forward-line 1)
                                 (1- (point)))
                          'action (lambda (but)
                                    (perldoc (intern
                                              (button-label but)
                                              perldoc-obarray)))))
      (goto-char (point-min))
      (message "Push button to show the pod."))))

;;;###autoload 
(defun pde-generate-loaddefs ()
  "Create pde-loaddefs.el"
  (interactive)
  (require 'autoload)
  (with-temp-buffer
    (dolist (file (directory-files pde-load-path t "\\.el$"))
      (generate-file-autoloads file))
    (write-region (point-min) (point-max)
                  (concat pde-load-path "/" "pde-loaddefs.el"))))
(provide 'pde-util)
;;; pde-util.el ends here
