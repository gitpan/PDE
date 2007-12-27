;;; pde-project.el --- Project management for Perl

;; Copyright (C) 2007 Free Software Foundation, Inc.
;;
;; Author: Ye Wenbin <wenbinye@gmail.com>
;; Maintainer: Ye Wenbin <wenbinye@gmail.com>
;; Created: 24 Dec 2007
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
;;   (require 'pde-project)

;;; Code:

(eval-when-compile
  (require 'cl))
(require 'pde-vars)

(defvar pde-project-mark-files '("Makefile.PL" "Build.PL")
  "*The files tell the current directory should be project root.")

(defvar pde-project-root nil)

(defun pde-detect-project-root ()
  (let ((dir (expand-file-name default-directory))
        found)
    (catch 'marked
      (while
          (progn
            ;; find Makefile.PL or Build.PL, set project root to current
            (mapc (lambda (f)
                    (when (file-exists-p (concat (file-name-as-directory dir) f))
                      (setq found dir)
                      (throw 'marked nil)))
                  pde-project-mark-files)
            ;; if dir is root, last and set project root to nil
            (cond ((string= dir (directory-file-name dir))
                   nil)
                  ;; if dir is in @INC, last and set project root to current
                  ((member dir pde-perl-inc)
                   (setq found dir)
                   nil)
                  ;; otherwise goes up
                  (t (setq dir (file-name-directory (directory-file-name dir))))))))
    (or found default-directory)))

(defun pde-set-project-root ()
  (unless pde-project-root
    (set (make-local-variable 'pde-project-root)
         (pde-detect-project-root))))

(defun pde-file-package ()
  "Get the package name of current buffer."
  (let ((root (or pde-project-root (pde-detect-project-root)))
        package)
    (when (and buffer-file-name
               (string-match "\\.\\(pm\\|pod\\)$" buffer-file-name))
      (setq package (file-relative-name buffer-file-name root))
      (if (string-match (concat "^" (regexp-opt '("blib" "lib")) "/")
                        package)
          (setq package (substring package (match-end 0))))
      (replace-regexp-in-string
       "/" "::"
       (replace-regexp-in-string "\\.\\(pm\\|pod\\)" "" package)))))

(provide 'pde-project)
;;; pde-project.el ends here
