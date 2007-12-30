
;;;### (autoloads (compile-dwim-run compile-dwim-compile) "compile-dwim"
;;;;;;  "compile-dwim.el" (18289 36270))
;;; Generated autoloads from compile-dwim.el

(autoload (quote compile-dwim-compile) "compile-dwim" "\
Not documented

\(fn FORCE &optional SENTINEL)" t nil)

(autoload (quote compile-dwim-run) "compile-dwim" "\
Not documented

\(fn)" t nil)

;;;***

;;;### (autoloads (help-dwim-active-type help-dwim) "help-dwim" "help-dwim.el"
;;;;;;  (18290 57471))
;;; Generated autoloads from help-dwim.el

(autoload (quote help-dwim) "help-dwim" "\
Show help info for NAME.
TYPE is one of `help-dwim-active-types'.

\(fn NAME &optional TYPE)" t nil)

(autoload (quote help-dwim-active-type) "help-dwim" "\
Active type for current buffer.
If APPEND is non-nil, that mean the TYPE is an additional help command.
Use `help-dwim-customize-type' for active or deactive type globally.

\(fn TYPE &optional APPEND)" t nil)

;;;***

;;;### (autoloads (imenu-tree) "imenu-tree" "imenu-tree.el" (18293
;;;;;;  9245))
;;; Generated autoloads from imenu-tree.el

(autoload (quote imenu-tree) "imenu-tree" "\
Display tree view of imenu.
With prefix argument, select imenu tree buffer window.

\(fn ARG)" t nil)

;;;***

;;;### (autoloads (inf-perl-start) "inf-perl" "inf-perl.el" (18289
;;;;;;  44219))
;;; Generated autoloads from inf-perl.el

(defalias (quote run-perl) (quote inf-perl-start))

(autoload (quote inf-perl-start) "inf-perl" "\
Run an inferior perl process, input and output via buffer *perl*.
If there is a process already running in `*perl*', switch to that buffer.

\(fn &optional BUFFER)" t nil)

;;;***

;;;### (autoloads (pde-generate-loaddefs pde-list-core-modules pde-list-module-shadows)
;;;;;;  "pde-util" "pde-util.el" (18295 20846))
;;; Generated autoloads from pde-util.el

(autoload (quote pde-list-module-shadows) "pde-util" "\
Display a list of modules that shadow other modules.

\(fn)" t nil)

(autoload (quote pde-list-core-modules) "pde-util" "\
Display a list of core modules.

\(fn)" t nil)

(autoload (quote pde-generate-loaddefs) "pde-util" "\
Create pde-loaddefs.el

\(fn LISP-DIR)" t nil)

;;;***

;;;### (autoloads (pde-perl-mode-hook pde-indent-dwim pde-ido-imenu-completion
;;;;;;  pde-compilation-buffer-name pde-ffap-locate pde-tabbar-register)
;;;;;;  "pde" "pde.el" (18295 20593))
;;; Generated autoloads from pde.el

(autoload (quote pde-tabbar-register) "pde" "\
Add tabbar and register current buffer to group Perl.

\(fn)" nil nil)

(autoload (quote pde-ffap-locate) "pde" "\
Return cperl module for ffap.

\(fn NAME &optional FORCE)" nil nil)

(autoload (quote pde-compilation-buffer-name) "pde" "\
Enable running multiple compilations.

\(fn MODE)" nil nil)

(autoload (quote pde-ido-imenu-completion) "pde" "\
Not documented

\(fn INDEX-ALIST &optional PROMPT)" nil nil)

(autoload (quote pde-indent-dwim) "pde" "\
Indent the region between paren.
If region selected, indent the region.
If character before is a parenthesis(such as \"]})>\"), indent the
region between the parentheses. Useful when you finish a subroutine or
a block.
Otherwise indent current subroutine. Selected by `beginning-of-defun'
and `end-of-defun'.

\(fn)" t nil)

(autoload (quote pde-perl-mode-hook) "pde" "\
Hooks run when enter perl-mode

\(fn)" nil nil)

;;;***

;;;### (autoloads (perldb-ui) "perldb-ui" "perldb-ui.el" (18290 12388))
;;; Generated autoloads from perldb-ui.el

(autoload (quote perldb-ui) "perldb-ui" "\
Run perldb on program FILE in buffer *gud-FILE*.
The directory containing FILE becomes the initial working directory
and source-file directory for your debugger.

\(fn COMMAND-LINE)" t nil)

;;;***

;;;### (autoloads (perldoc-tree perldoc) "perldoc" "perldoc.el" (18293
;;;;;;  53265))
;;; Generated autoloads from perldoc.el

(autoload (quote perldoc) "perldoc" "\
Display perldoc using woman.
The SYMBOL can be a module name or a function. If the module and
function is the same, add \".pod\" for the module name. For example,
\"open.pod\" for the progma open and \"open\" for function open.

\(fn SYMBOL)" t nil)

(autoload (quote perldoc-tree) "perldoc" "\
Create pod tree.

\(fn)" t nil)

;;;***

;;;### (autoloads (perltidy-dwim perltidy-subroutine perltidy-buffer
;;;;;;  perltidy-region) "perltidy" "perltidy.el" (18284 41846))
;;; Generated autoloads from perltidy.el

(autoload (quote perltidy-region) "perltidy" "\
Tidy perl code in the region.

\(fn BEG END)" t nil)

(autoload (quote perltidy-buffer) "perltidy" "\
Call perltidy for whole buffer.

\(fn)" t nil)

(autoload (quote perltidy-subroutine) "perltidy" "\
Call perltidy for subroutine at point.

\(fn)" t nil)

(autoload (quote perltidy-dwim) "perltidy" "\
Perltidy Do What I Mean.
If with prefix argument, just show the result of perltidy.
You can use C-x C-s to save the tidy result.
If region is active call perltidy on the region. If inside
subroutine, call perltidy on the subroutine, otherwise call
perltidy for whole buffer.

\(fn ARG)" t nil)

;;;***

;;;### (autoloads (tags-tree) "tags-tree" "tags-tree.el" (18290 6069))
;;; Generated autoloads from tags-tree.el

(autoload (quote tags-tree) "tags-tree" "\
Not documented

\(fn ARG)" t nil)

;;;***

;;;### (autoloads (template-simple-expand template-simple-expand-template)
;;;;;;  "template-simple" "template-simple.el" (18292 61898))
;;; Generated autoloads from template-simple.el

(define-template-expander skeleton template-skeleton-alist (skeleton-insert (cons nil template)))

(define-template-expander tempo template-tempo-alist (let ((tempo-template template)) (tempo-insert-template (quote tempo-template) nil)))

(autoload (quote template-simple-expand-template) "template-simple" "\
Expand template in file.
Parse the template to parsed templates with `template-compile'.
Use `template-expand-function' to expand the parsed template.

\(fn FILE)" t nil)

(autoload (quote template-simple-expand) "template-simple" "\
Expand string TEMPLATE.
Parse the template to parsed templates with `template-compile'.
Use `template-expand-function' to expand the parsed template.

\(fn TEMPLATE)" nil nil)

;;;***

;;;### (autoloads (tempo-x-space) "tempo-x" "tempo-x.el" (18295 10614))
;;; Generated autoloads from tempo-x.el

(autoload (quote tempo-x-space) "tempo-x" "\
Expand tempo if complete in `tempo-local-tags' or insert space.

\(fn)" t nil)

;;;***

;;;### (autoloads (tree-minor-mode) "tree-mode" "tree-mode.el" (18295
;;;;;;  13961))
;;; Generated autoloads from tree-mode.el

(autoload (quote tree-minor-mode) "tree-mode" "\
More keybindings for tree-widget.

\\{tree-mode-map}

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (windata-display-buffer windata-restore-named-winconf
;;;;;;  windata-name-winconf) "windata" "windata.el" (18289 15438))
;;; Generated autoloads from windata.el

(autoload (quote windata-name-winconf) "windata" "\
Save window configuration with NAME.
After save the window configuration you can restore it by NAME using
`windata-restore-named-winconf'.

\(fn NAME)" t nil)

(autoload (quote windata-restore-named-winconf) "windata" "\
Restore saved window configuration.

\(fn NAME)" t nil)

(autoload (quote windata-display-buffer) "windata" "\
Display buffer more precisely.
FRAME-P is non-nil and not window, the displayed buffer affect
the whole frame, that is to say, if DIR is right or left, the
displayed buffer will show on the right or left in the frame. If
it is nil, the buf will share space with current window.

DIR can be one of member of (right left top bottom).

SIZE is the displayed windowed size in width(if DIR is left or
right) or height(DIR is top or bottom). It can be a decimal which
will stand for percentage of window(frame) width(heigth)

DELETE-P is non-nil, the other window will be deleted before
display the BUF.

\(fn BUF FRAME-P DIR SIZE &optional DELETE-P)" nil nil)

;;;***