;;; pde-vars.el --- Variables for PDE

;; Copyright (C) 2007 Free Software Foundation, Inc.
;;
;; Author: Ye Wenbin <wenbinye@gmail.com>
;; Maintainer: Ye Wenbin <wenbinye@gmail.com>
;; Created: 23 Dec 2007
;; Version: 0.01
;; Keywords: languages, tools

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

;;; Code:

(eval-when-compile
  (require 'cl))

(defvar pde-version "0.01"
  "Version of PDE")

(defvar pde-perl-program "perl"
  "*Name of perl")

(defvar pde-perl-version "5.8.8"
  "*Version of perl used")

(defvar pde-perldoc-program "perldoc"
  "*Name of perldoc")

(defvar pde-load-path (file-name-directory load-file-name)
  "*Directory name of pde")

(defvar pde-perl-inc
  (when pde-perl-program
    (let ((cmd (format "%s -e \"print join(';', grep { -d && /^[^.]/} @INC);\""
                       pde-perl-program)))
      (mapcar 'file-name-as-directory
              (split-string (shell-command-to-string cmd) ";"))))
  "*Include path of perl")

(provide 'pde-vars)
;;; pde-vars.el ends here
