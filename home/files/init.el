;; Below: a lot of code i have stolen and not sourced
;; presented in an unorganised manner

(require 'mu4e)
(setq native-comp-async-report-warnings-errors 'silent)
(setq straight-check-for-modifications nil)
(setq url-http-attempt-keepalives nil)
(setq guix-default-user-profile "~/.guix-extra-profiles/desktop")

(with-eval-after-load 'org-roam
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  (setq org-roam-node-display-template
        (concat "${title:80} " (propertize "${tags:*}" 'face 'org-tag)))
  )

(global-set-key (kbd "<escape>") 'keyboard-quit)

(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(setq pdf-view-use-scaling t)
(url-handler-mode)
(defun open-ocr-chem-data-sheet ()
  (interactive)
  (find-file "~/Downloads/247605-unit-h432-data-sheet-specimen.pdf"))
(defun open-ocr-phys-data-sheet ()
  (interactive)
  (find-file
   "~/Downloads/363796-units-h156-and-h556\
-data-formulae-and-relationships-booklet.pdf"))

;; weirdly broken right now
;; has to be run twice to work
(defun open-arxiv ()
  (interactive)
  (setq url (thing-at-point-url-at-point))
  (setq pdf-name (concat "/tmp/" (car (last (split-string url "/"))) ".pdf"))
  (if (file-exists-p pdf-name)
      (find-file pdf-name)
    (setq pdf (concat (replace-regexp-in-string
                       "http://"
                       "https://" (replace-regexp-in-string "/abs/"
                                                            "/pdf/"
                                                            url)) ".pdf"))
    (async-start-process "pdf-dl" "curl" (lambda (x) (interactive)
                                           (find-file pdf-name)) pdf
                                           "--output" pdf-name))
  )
;;(find-file pdf))

(setq evil-overriding-maps nil)
(setq evil-intercept-maps nil)
(setq evil-want-keybinding nil)
;;(setq evil-want-minibuffer t)
(evil-mode 1)
(global-undo-tree-mode)
(setq evil-undo-system 'undo-tree)
(evil-collection-init)
;;(load-file "~/nano-minibuffer/nano-minibuffer.el")

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el\
/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; NANO splash
(straight-use-package
 '(nano-splash :type git :host github :repo "rougier/nano-splash"))

;;NANO theme
(straight-use-package
 '(nano-theme :type git :host github :repo "rougier/nano-theme")
 )

;;NANO modeline
(straight-use-package
 '(nano-modeline :type git :host github :repo "rougier/nano-modeline"))

;; NANO agenda
(straight-use-package
 '(nano-agenda :type git :host github :repo "rougier/nano-agenda"))

;; SVG tags, progress bars & icons
(use-package svg-lib
  :straight (:type git :host github :repo "rougier/svg-lib")
  :config
  (setq svg-lib-style-default (svg-lib-style-compute-default)))


(with-eval-after-load 'svg-lib
  (setq svg-lib-style-default (svg-lib-style-compute-default)))
;; Replace keywords with SVG tags
(require 'svg-lib)
(use-package svg-tag-mode
  :straight (:type git :host github :repo "rougier/svg-tag-mode")
  :config
  (setq svg-lib-style-default (svg-lib-style-compute-default)))


(with-eval-after-load 'svg-tag-mode
  (setq svg-lib-style-default (svg-lib-style-compute-default)))
(require 'svg-tag-mode)
(setq svg-lib-style-default (svg-lib-style-compute-default))
;; Dashboard for mu4e
(straight-use-package
 '(mu4e-dashboard :type git :host github :repo "rougier/mu4e-dashboard"))

;; Folding mode for mu4e
(straight-use-package
 '(mu4e-folding :type git :host github :repo "rougier/mu4e-folding"))


(setq-default
 inhibit-startup-screen t
 inhibit-startup-message t
 inhibit-startup-echo-area-message t
 initial-buffer-choice t)               ;


(set-default-coding-systems 'utf-8)
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "English")

(setq auto-save-list-file-prefix
      (expand-file-name ".auto-save-list/.saves-" user-emacs-directory)
      auto-save-default t
      auto-save-timeout 20
      auto-save-interval 200)

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      make-backup-files t
      vc-make-backup-files nil
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-old-versions 6
      kept-new-versions 9
      delete-by-moving-to-trash t)

(defun my/string-pad-right (len s)
  "If S is shorter than LEN, pad it on the right,
if S is longer than LEN, truncate it on the right."

  (if (> (length s) len)
      (concat (substring s 0 (- len 1)) "…")
    (concat s (make-string (max 0 (- len (length s))) ?\ ))))

(defun my/string-pad-left (len s)
  "If S is shorter than LEN, pad it on the left,
if S is longer than LEN, truncate it on the left."

  (if (> (length s) len)
      (concat  "…" (substring s (- (length s) len -1)))
    (concat (make-string (max 0 (- len (length s))) ?\ ) s)))

(defun my/string-join (len left right &optional spacing)
  "Join LEFT and RIGHT strings to fit LEN\
characters with at least SPACING characters
between them. If len is negative, it is retrieved from current window width."
  (let* ((spacing (or spacing 3))
         (len (or len (window-body-width)))
         (len (if (< len 0)
                  (+ (window-body-width) len)
                len)))
    (cond ((> (length right) len)
           (my/string-pad-left len right))

          ((> (length right) (- len spacing))
           (my/string-pad-left len (concat (make-string spacing ?\ )
                                           right)))

          ((> (length left) (- len spacing (length right)))
           (concat (my/string-pad-right (- len spacing (length right)) left)
                   (concat (make-string spacing ?\ )
                           right)))
          (t
           (concat left
                   (make-string (- len (length right) (length left)) ?\ )
                   right)))))

(defun my/date-day (date)
  "Return DATE day of month (1-31)."

  (nth 3 (decode-time date)))

(defun my/date-month (date)
  "Return DATE month number (1-12)."

  (nth 4 (decode-time date)))


(defun my/date-year (date)
  "Return DATE year."

  (nth 5 (decode-time date)))


(defun my/date-equal (date1 date2)
  "Check if DATE1 is equal to DATE2."

  (and (eq (my/date-day date1)
           (my/date-day date2))
       (eq (my/date-month date1)
           (my/date-month date2))
       (eq (my/date-year date1)
           (my/date-year date2))))


(defun my/date-inc (date &optional days months years)
  "Return DATE + DAYS day & MONTH months & YEARS years"

  (let ((days (or days 0))
        (months (or months 0))
        (years (or years 0))
        (day (my/date-day date))
        (month (my/date-month date))
        (year (my/date-year date)))
    (encode-time 0 0 0 (+ day days) (+ month months) (+ year years))))


(defun my/date-dec (date &optional days months years)
  "Return DATE - DAYS day & MONTH months & YEARS years"

  (let ((days (or days 0))
        (months (or months 0))
        (years (or years 0)))
    (my/date-inc date (- days) (- months) (- years))))


(defun my/date-today ()
  "Return today date."

  (current-time))

(defun my/date-is-today (date)
  "Check if DATE is today."

  (my/date-equal (current-time) date))

(defun my/date-is-yesterday (date)
  "Check if DATE is today."

  (my/date-equal (my/date-dec (my/date-today) 1) date))

(defun my/date-relative (date)
  "Return a string with a relative date format."

  (let ((delta (float-time (time-subtract (current-time) date)))
        (days (- (my/date-day (current-time)) (my/date-day date))))
    (cond ((< delta (*       3 60))     "now")
          ((< delta (*      60 60))
           (format "%d minutes ago" (/ delta   60)))
          ;;  ((< delta (*    6 60 60))
          ;;(format "%d hours ago"   (/ delta 3600)))
          ((my/date-is-today date)      (format-time-string "%H:%M" date))
          ((my/date-is-yesterday date)  (format "Yesterday"))
          ((< delta (* 4 24 60 60))     (format "%d days ago" (+ days 1)))
          (t                            (format-time-string "%d %b %Y" date)))))


(defun my/mu4e-get-account (msg)
  "Get MSG related account."

  (let* ((maildir (mu4e-message-field msg :maildir))
         (maildir (substring maildir 1)))
    (nth 0 (split-string maildir "/"))))


(defun my/mu4e-get-maildir (msg)
  "Get MSG related maildir."

  (let* ((maildir (mu4e-message-field msg :maildir))
         (maildir (substring maildir 1)))
    (nth 0 (reverse (split-string maildir "/")))))

(defun my/mu4e-get-mailbox (msg)
  "Get MSG related mailbox as 'account - maildir' "

  (format "%s - %s" (mu4e-get-account msg) (mu4e-get-maildir msg)))

(require 'frame)

;; Default frame settings
(setq default-frame-alist '((min-height . 1)  '(height . 45)
                            (min-width  . 1)  '(width  . 81)
                            (vertical-scroll-bars . nil)
                            (internal-border-width . 24)
                            (left-fringe . 0)
                            (right-fringe . 0)
                            (tool-bar-lines . 0)
                            (menu-bar-lines . 0)))

;; Default frame settings
(setq initial-frame-alist default-frame-alist)

(with-eval-after-load 'org
  (bind-key "<M-return>" #'toggle-frame-maximized 'org-mode-map))

(setq-default show-help-function nil    ; No help text
              use-file-dialog nil       ; No file dialog
              use-dialog-box nil        ; No dialog box
              pop-up-windows nil)       ; No popup windows

(tooltip-mode -1)                       ; No tooltips
(scroll-bar-mode -1)                    ; No scroll bars
(tool-bar-mode -1)                      ; No toolbar

(require 'which-key)

(which-key-mode)

(setq-default use-short-answers t
              confirm-nonexistent-file-or-buffer nil)
;;(setq-default mouse-yank-at-point t) ; Yank at point rather than pointer
;;(mouse-avoidance-mode 'exile)        ; Avoid collision of mouse with point


(setq-default scroll-conservatively 101
              scroll-margin 2
              recenter-positions '(5 bottom)) ; Set re-centering positions


(setq-default select-enable-clipboard t) ; Merge system's and Emacs' clipboard

;;(setq help-window-select t)             ; Focus new help windows when opened


(require 'nano-theme)
;;(setq nano-fonts-use t) ; Use theme font stack
(nano-dark)
(nano-mode)
(setq svg-lib-style-default (svg-lib-style-compute-default))
(load-theme 'nano-dark t)
(setq svg-lib-style-default (svg-lib-style-compute-default))

(set-face-attribute 'default nil
                    :family "Roboto Mono"
                    :weight 'light
                    :height 80)

(set-face-attribute 'variable-pitch nil
                    :family "Roboto"
                    :weight 'light
                    :height 110)

(set-face-attribute 'bold nil
                    :family "Roboto Mono"
                    :weight 'regular)

(set-face-attribute 'italic nil
                    :family "Victor Mono"
                    :height 90
                    :weight 'semilight
                    :slant 'italic)

(set-fontset-font t 'unicode
                  (font-spec :name "Inconsolata Light"
                             :size 16) nil)

(set-fontset-font t '(#xe000 . #xffdd)
                  (font-spec :name "RobotoMono Nerd Font"
                             :size 12) nil)

(setq-default fill-column 80
              sentence-end-double-space nil
              bidi-paragraph-direction 'left-to-right
              truncate-string-ellipsis "…")

;; Nicer glyphs for continuation and wrap
(set-display-table-slot standard-display-table
                        'truncation (make-glyph-code ?… 'nano-faded))

(defface wrap-symbol-face
  '((t (:family "Fira Code"
                :inherit nano-faded)))
  "Specific face for wrap symbol")

(set-display-table-slot standard-display-table
                        'wrap (make-glyph-code ?↩ 'wrap-symbol-face))

(setq x-underline-at-descent-line nil
      x-use-underline-position-properties t
      underline-minimum-offset 10)

(with-eval-after-load 'corfu
  (setq corfu-cycle t                ; Enable cycling for `corfu-next/previous'
        corfu-auto t                 ; Enable auto completion
        corfu-separator ?\s          ; Orderless field separator
        corfu-quit-at-boundary nil   ; Never quit at completion boundary
        corfu-quit-no-match nil      ; Never quit, even if there is no match
        corfu-preview-current nil    ; Disable current candidate preview
        corfu-preselect-first nil    ; Disable candidate preselection
        corfu-on-exact-match nil     ; Configure handling of exact matches
        corfu-echo-documentation nil ; Disable documentation in the echo area
        corfu-scroll-margin 5)       ; Use scroll margin
  )
(global-corfu-mode)

;; TAB cycle if there are only few candidates
(setq completion-cycle-threshold 3)

;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
;; Corfu commands are hidden, since they are not supposed to be used via M-x.
(setq read-extended-command-predicate
      #'command-completion-default-include-p)

;; Enable indentation+completion using the TAB key.
;; completion-at-point is often bound to M-TAB.
(setq tab-always-indent 'complete)

;; Completion in source blocks
(require 'cape)

(add-to-list 'completion-at-point-functions 'cape-symbol)

(with-eval-after-load 'orderless
  (setq completion-styles '(substrinc orderless basic)
        orderless-component-separator 'orderless-escapable-split-on-space
        read-file-name-completion-ignore-case t
        read-buffer-completion-ignore-case t
        completion-ignore-case t))


(with-eval-after-load 'consult
  (setq consult-preview-key nil) ; No live preview

  (bind-key "C-x C-r" #'consult-recent-file)
  (bind-key "C-x h"   #'consult-outline)
  (bind-key "C-x b"   #'consult-buffer)
  (bind-key "M-:"     #'consult-complex-command))

(defun my/consult-line ()
  "Consult line with live preview"

  (interactive)
  (let ((consult-preview-key 'any))
    (consult-line)))

(bind-key "C-s"   #'my/consult-line)

(defun my/consult-goto-line ()
  "Consult goto line with live preview"

  (interactive)
  (let ((consult-preview-key 'any))
    (consult-goto-line)))

(bind-key "M-g g"   #'my/consult-goto-line)
(bind-key "M-g M-g" #'my/consult-goto-line)

(with-eval-after-load 'vertico
  (setq vertico-resize nil        ; How to resize the Vertico minibuffer window.
        vertico-count 10          ; Maximal number of candidates to show.
        vertico-count-format nil) ; No prefix with number of entries

  (setq vertico-grid-separator
        #("  |  " 2 3 (display (space :width (1))
                               face (:background "#ECEFF1")))

        vertico-group-format
        (concat #(" " 0 1 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator))
                #(" %s " 0 4 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator
                                display (space
                                         :align-to
                                         (- right (-1 . right-margin)
                                            (- +1)))))))

  (set-face-attribute 'vertico-group-separator nil
                      :strike-through t)
  (set-face-attribute 'vertico-current nil
                      :inherit '(nano-strong nano-subtle))
  (set-face-attribute 'completions-first-difference nil
                      :inherit '(nano-default))

  (set-face-attribute 'vertico-group-separator nil
                      :strike-through t)
  (set-face-attribute 'vertico-current nil
                      :inherit '(nano-strong nano-subtle))
  (set-face-attribute 'completions-first-difference nil
                      :inherit '(nano-default))


  (bind-key "<backtab>" #'minibuffer-complete vertico-map)
  )
(vertico-mode)

;;(require 'exwm)
;;(require 'exwm-config)
;;(exwm-config-example)

(setq ivy-posframe-display-functions-alist
      '((t . ivy-posframe-display-at-frame-top-center)))
(ivy-posframe-mode 1)
;;(setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))

(require 'nano-modeline)

(setq nano-modeline-prefix 'status)
(setq nano-modeline-prefix-padding 1)

(set-face-attribute 'header-line nil)
(set-face-attribute 'mode-line nil
                    :foreground (face-foreground 'nano-subtle-i)
                    :background (face-foreground 'nano-subtle-i)
                    :inherit nil
                    :box nil)
(set-face-attribute 'mode-line-inactive nil
                    :foreground (face-foreground 'nano-subtle-i)
                    :background (face-foreground 'nano-subtle-i)
                    :inherit nil
                    :box nil)

(set-face-attribute 'nano-modeline-active nil
                    :underline (face-foreground 'nano-default-i)
                    :background (face-background 'nano-subtle)
                    :inherit '(nano-default-)
                    :box nil)
(set-face-attribute 'nano-modeline-inactive nil
                    :foreground 'unspecified
                    :underline (face-foreground 'nano-default-i)
                    :background (face-background 'nano-subtle)
                    :box nil)

(set-face-attribute 'nano-modeline-active-name nil
                    :foreground "black"
                    :inherit '(nano-modeline-active nano-strong))
(set-face-attribute 'nano-modeline-active-primary nil
                    :inherit '(nano-modeline-active))
(set-face-attribute 'nano-modeline-active-secondary nil
                    :inherit '(nano-faded nano-modeline-active))

(set-face-attribute 'nano-modeline-active-status-RW nil
                    :inherit '(nano-faded-i nano-strong nano-modeline-active))
(set-face-attribute 'nano-modeline-active-status-** nil
                    :inherit '(nano-popout-i nano-strong nano-modeline-active))
(set-face-attribute 'nano-modeline-active-status-RO nil
                    :inherit '(nano-default-i nano-strong nano-modeline-active))

(set-face-attribute 'nano-modeline-inactive-name nil
                    :inherit '(nano-faded nano-strong
                                          nano-modeline-inactive))
(set-face-attribute 'nano-modeline-inactive-primary nil
                    :inherit '(nano-faded nano-modeline-inactive))

(set-face-attribute 'nano-modeline-inactive-secondary nil
                    :inherit '(nano-faded nano-modeline-inactive))
(set-face-attribute 'nano-modeline-inactive-status-RW nil
                    :inherit '(nano-modeline-inactive-secondary))
(set-face-attribute 'nano-modeline-inactive-status-** nil
                    :inherit '(nano-modeline-inactive-secondary))
(set-face-attribute 'nano-modeline-inactive-status-RO nil
                    :inherit '(nano-modeline-inactive-secondary))


(defun my/thin-modeline ()
  "Transform the modeline in a thin faded line"

  (nano-modeline-face-clear 'mode-line)
  (nano-modeline-face-clear 'mode-line-inactive)
  (setq mode-line-format (list ""))
  (setq-default mode-line-format (list ""))
  (set-face-attribute 'mode-line nil
                      :inherit 'nano-modeline-inactive
                      :height 0.1)
  (set-face-attribute 'mode-line-inactive nil
                      :inherit 'nano-modeline-inactive
                      :height 0.1))
(add-hook 'nano-modeline-mode-hook #'my/thin-modeline)

(nano-modeline-mode 1)
;; on OSX, type the line below (in terminal) to get a 1 pixel border
;; defaults write com.apple.universalaccess increaseContrast -bool YES

;; To control anti-aliasing on OSX:
;; defaults write org.gnu.Emacs AppleFontSmoothing -int 0 (none)
;; defaults write org.gnu.Emacs AppleFontSmoothing -int 1 (light)
;; defaults write org.gnu.Emacs AppleFontSmoothing -int 2 (medium)
;; defaults write org.gnu.Emacs AppleFontSmoothing -int 3 (strong)

;; Fall back font for glyph missing in Roboto
(defface fallback '((t :family "Fira Code"
                       :inherit 'nano-face-faded))
  "Fallback")
(set-display-table-slot standard-display-table 'truncation
                        (make-glyph-code ?… 'fallback))
(set-display-table-slot standard-display-table 'wrap
                        (make-glyph-code ?↩ 'fallback))

;; (set-fontset-font t nil "Fira Code" nil 'append)

;; Fix bug on OSX in term mode & zsh (spurious % after each command)
(add-hook 'term-mode-hook
          (lambda () (setq buffer-display-table (make-display-table))))

(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)
;;(if (fboundp 'tool-bar-mode) (tool-bar-mode nil))
(menu-bar-mode 0)
;; (global-hl-line-mode 1)
(setq x-underline-at-descent-line t)

;; Vertical window divider
(setq window-divider-default-right-width 24)
(setq window-divider-default-places 'right-only)
(window-divider-mode 1)

;; No ugly button for checkboxes
(setq widget-image-enable nil)

;; Hide org markup for README
(setq org-hide-emphasis-markers t)

;;(setq FONT "Iosevka 10")
;;(setq THEME 'doom-gruvbox-light)
(setq org-roam-ui-open-on-start nil)
(require 'seq)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(setq inferior-octave-startup-args '("-i" "--traditional" "--line-editing"))
(nano-modeline-mode)


(require 'mu4e-folding)

(set-face-background 'mu4e-folding-child-folded-face
                     (face-background 'highlight))

(set-face-background 'mu4e-folding-child-unfolded-face
                     (face-background 'highlight))

(set-face-background 'mu4e-folding-root-folded-face
                     (face-background 'default))

(set-face-background 'mu4e-folding-root-unfolded-face
                     (face-background 'highlight))


(defun my/mu4e-headers-multiline (msg)
  "A multiline headers mode."

  (let* ((sender  (my/mu4e-get-sender msg))
         (date (mu4e-message-field msg :date))
         (date (my/date-relative date))
         (subject (mu4e-message-field msg :subject))
         (subject (truncate-string-to-width subject
                                            (- (window-width) 16) nil nil "…"))
         (flagged   (memq 'flagged   (mu4e-message-field msg :flags)))
         (attach    (memq 'attach    (mu4e-message-field msg :flags)))
         (unread    (memq 'unread    (mu4e-message-field msg :flags)))
         (replied   (memq 'replied   (mu4e-message-field msg :flags)))
         (encrypted (memq 'encrypted (mu4e-message-field msg :flags)))
         (draft     (memq 'draft     (mu4e-message-field msg :flags)))
         (thread (mu4e-message-field msg :thread))
         (related (and thread (plist-get thread :related)))
         (prefix (mu4e~headers-thread-prefix thread))
         (root (plist-get thread :root))
         (orphan (plist-get thread :orphan))
         (first-child (plist-get thread :first-child))
         (has-child (plist-get thread :has-child))
         (level (plist-get thread :level))
         (root (or root (and orphan (or first-child has-child))))
         (child (and thread (not root)))
         (tags      (mu4e-message-field msg :tags))
         (top-spacing (if child                +0.000 -0.250))
         (bot-spacing (if (and root has-child) +0.250 +0.250))
         (unread-mark (propertize (cond (unread               " ●")
                                        ((and root has-child) " ")
                                        (t                    "  "))
                                  'display `(raise ,top-spacing)))
         (one-line (and child mu4e-headers-include-related))

         (face-sender (cond ((and root related)   '(nano-strong nano-faded))
                            (root                '(nano-strong nano-default))
                            ((and child related)
                             '(:inherit nano-faded :height 140))
                            (child
                             '(:inherit nano-default :height 140))
                            (t                   '(nano-default))))
         (face-subject (cond (related '(:inherit nano-faded))
                             (t       '(:inherit nano-default))))
         (face-tags (cond (related '(
                                     :inherit (nano-faded)
                                     :height 120))
                          (t       '(
                                     :inherit (nano-popout nano-strong)
                                     :height 120))))
         (face-date    (cond (t '(:inherit nano-faded :height 140))))

         (icons (string-join
                 `(,@(if draft   `( ,(propertize "" 'face 'nano-faded)))
                   ,@(if attach  `( ,(propertize "" 'face 'nano-faded)))
                   ,@(if flagged `( ,(propertize "" 'face 'nano-salient)))
                   ) " ")))

    (concat

     ;; Separaction line between threads
     (when root
       (concat
        (propertize " "
                    'mu4e-root t
                    'display `((margin left-margin) "  "))
        (propertize "-" 'display "\n"
                    'face '(:extend t
                                    :strike-through t
                                    :inherit nano-subtle-i))
        "  "))

     ;; Children are always indented (relatively to root)
     (when (and child one-line)
       (concat
        (propertize "-" 'face face-sender)))

     ;; Unread mark appears in the left margin
     (propertize " " 'face (if unread 'nano-default face-sender)
                 'display `((margin left-margin) ,unread-mark))

     ;; Sender
     (cond (one-line     (propertize (concat prefix sender)
                                     'face face-sender
                                     'display `(raise ,top-spacing)))
           ((and root has-child) (propertize (concat " " sender)
                                             'face face-sender
                                             'display `(raise ,top-spacing)))
           (t (propertize sender 'face face-sender
                          'display `(raise ,top-spacing))))

     " "
     ;; Replied
     (when replied
       (propertize " " 'face face-sender
                   'display `(raise ,top-spacing)))

     ;; In one line mode (children), icons are displayed next to sender
     (when one-line
       (concat (propertize icons 'display `(raise ,top-spacing)) " "))

     ;; Tags next to sender
     (when tags
       (concat
        (propertize " " 'face face-tags
                    'display `(raise ,top-spacing))
        (mapconcat #'(lambda (tag)
                       (propertize tag 'face face-tags
                                   'display `(raise ,top-spacing)))
                   tags (propertize "," 'face face-tags
                                    'display `(raise ,top-spacing)))))

     ;; Spacing to have date aligned on the right
     (propertize " " 'display
                 `(space :align-to (- right 1 ,(* 1.0 (length date)))))

     ;; Date
     (propertize date 'face face-date
                 'display `(raise ,top-spacing))

     ;; When not a child
     (when (or root (not mu4e-headers-include-related))
       (concat

        ;; Second line. We use a display property such that
        ;;hl-line-mode works correctly.
        (propertize " " 'display "\n")

        ;; Blank spaces in the margin (for nice hl-line-mode)
        (propertize " " 'face '(nano-strong nano-salient)
                    'display `((margin left-margin) "  "))

        ;; Indentation (to compensate for the virtual "\n" we introduced before)
        (propertize "  ")

        ;; Align subject and sender when this is a child
        (when (and one-line child)
          (propertize "  " 'face 'nano-faded))

        ;; Subject
        (propertize subject 'display `(raise ,bot-spacing)
                    'face face-subject)
        ;; Spacing to have icons aligned on the right
        (propertize " " 'display `(space :align-to (- right ,(length icons) 1)))

        ;; Icons on the right
        (propertize icons 'display `(raise ,bot-spacing)))))))


(add-to-list 'mu4e-header-info-custom
             '(:empty . (:name "Empty"
                               :shortname ""
                               :function (lambda (msg) "  "))))
(setq mu4e-headers-fields '((:empty         .    2)
                            (:human-date    .   12)
                            (:flags         .    6)
                            (:mailing-list  .   10)
                            (:from          .   22)
                            (:subject       .   nil)))
(define-key mu4e-headers-mode-map (kbd "<tab>")
            'mu4e-headers-toggle-at-point)
(define-key mu4e-headers-mode-map (kbd "<left>")
            'mu4e-headers-fold-at-point)
(define-key mu4e-headers-mode-map (kbd "<S-left>")
            'mu4e-headers-fold-all)
(define-key mu4e-headers-mode-map (kbd "<right>")
            'mu4e-headers-unfold-at-point)
(define-key mu4e-headers-mode-map (kbd "<S-right>")
            'mu4e-headers-unfold-all)

(defun concatenate-authors (authors-list)
  "Given AUTHORS-LIST, list of plists; return string of all authors
concatenated."
  (mapconcat
   (lambda (author) (plist-get author :name))
   authors-list ", "))

(defun my/elfeed-search-print-entry (entry)
  "Alternative printing of elfeed entries using SVG tags."

  (let* ((date (elfeed-search-format-date (elfeed-entry-date entry)))
         (title (or (elfeed-meta entry :title)
                    (elfeed-entry-title entry) ""))
         (unread (member 'unread (elfeed-entry-tags entry)))
         (feed (elfeed-entry-feed entry))
         (feed-title (when feed
                       (or (elfeed-meta feed :title)
                           (elfeed-feed-title feed))))
         (title-face (if unread 'nano-default 'nano-faded))
         (date-face (if unread 'nano-salient 'nano-faded))
         (feed-title-face (if unread 'nano-strong '(nano-strong nano-faded)))
         (tag-face (if unread 'nano-popout 'nano-faded))
         (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
         (tags (delete "unread" tags))
         (tags-svg (mapconcat
                    (lambda (s)
                      (propertize (concat (upcase s) " ")
                                  'display (svg-tag-make (upcase s)
                                                         :margin 0
                                                         :padding 1
                                                         :inverse 1
                                                         :face tag-face)))
                    tags " "))
         (left (concat
                (when feed-title
                  (propertize feed-title 'face feed-title-face))
                " " tags-svg " "
                (propertize title 'face title-face 'kbd-help title)))
         (right (propertize date 'face date-face)))
    (insert (my/string-join -1 left right))))
;;(when (daemonp)
;; (exec-path-from-shell-initialize))

;;(add-hook 'org-capture-mode-hook 'make-frame)
(flycheck-define-checker proselint
  "A linter for prose."
  :command ("proselint" source-inplace)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ": "
            (id (one-or-more (not (any " "))))
            (message) line-end))
  :modes (text-mode org-mode org-roam-mode markdown-mode gfm-mode))

(add-to-list 'flycheck-checkers 'proselint)
(require 's)
(require 'esxml)
(require 'request)
(require 'dash)
(setq pdf-continuous-suppress-introduction t)

;;(frames-only-mode)
(if (daemonp) (org-roam-ui-mode))
(ivy-mode 1)
(counsel-mode 1)
(ace-link-setup-default)
(setq org-roam-db-gc-threshold most-positive-fixnum)

(defun xah-rename-eww-hook ()
  "Rename eww browser's buffer so sites open in new page."
  (rename-buffer "eww" t))

(add-hook 'eww-mode-hook #'xah-rename-eww-hook)
(add-hook 'eww-mode-hook (lambda () (setq-local global-hl-line-mode nil)
                           (display-line-numbers-mode -1)))

(setq org-roam-directory (file-truename "~/org-roam"))
(org-roam-db-autosync-mode)

(setq org-roam-dailies-directory "daily/")

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))))

(require 'svg-lib)
(require 'svg-tag-mode)

(setq svg-tag-tags
      (mapcar (lambda (x) `(,(format ":%s:" x)
                       . ((lambda (tag)
                            (svg-tag-make ,(s-upcase x)
                                          :inverse 1
                                          :margin 1
                                          :alignment 0.0
                                          :face 'nano-faded)))))
              tag-list))

(add-hook 'org-roam-mode-hook 'svg-tag-mode-on)
(add-hook 'org-mode-hook 'svg-tag-mode-on)
(add-hook 'org-roam-mode-hook 'variable-pitch-mode)
(add-hook 'org-mode-hook 'variable-pitch-mode)

(defun my/svg-tag-timestamp (&rest args)
  "Create a timestamp SVG tag for the time at point."

  (interactive)
  (let ((inhibit-read-only t))

    (goto-char (point-min))
    (while (search-forward-regexp
            "\\(\([0-9]/[0-9]\):\\)" nil t)
      (set-text-properties (match-beginning 1) (match-end 1)
                           `(display ,(svg-tag-make "ANYTIME"
                                                    :face 'nano-faded
                                                    :inverse nil
                                                    :padding 3
                                                    :alignment 0))))

    (goto-char (point-min))
    (while (search-forward-regexp
            "\\([0-9]+:[0-9]+\\)\\(\\.+\\)" nil t)

      (set-text-properties (match-beginning 1) (match-end 2)
                           `(display ,(svg-tag-make (match-string 1)
                                                    :face 'nano-faded
                                                    :margin 4
                                                    :alignment 0))))

    (goto-char (point-min))
    (while (search-forward-regexp
            "\\([0-9]+:[0-9]+\\)\\(\\.*\\)" nil t)

      (set-text-properties (match-beginning 1) (match-end 2)
                           `(display ,(svg-tag-make (match-string 1)
                                                    :face 'nano-default
                                                    :inverse t
                                                    :margin 4 :alignment 0))))
    (goto-char (point-min))
    (while (search-forward-regexp
            "\\([0-9]+:[0-9]+\\)\\(-[0-9]+:[0-9]+\\)" nil t)
      (let* ((t1 (parse-time-string (match-string 1)))
             (t2 (parse-time-string (substring (match-string 2) 1)))
             (t1 (+ (* (nth 2 t1) 60) (nth 1 t1)))
             (t2 (+ (* (nth 2 t2) 60) (nth 1 t2)))
             (d  (- t2 t1)))

        (set-text-properties (match-beginning 1) (match-end 1)
                             `(display ,(svg-tag-make (match-string 1)
                                                      :face 'nano-faded
                                                      :crop-right t)))
        ;; 15m: ¼, 30m:½, 45m:¾
        (if (< d 60)
            (set-text-properties (match-beginning 2) (match-end 2)
                                 `(display ,(svg-tag-make (format "%2dm" d)
                                                          :face 'nano-faded
                                                          :crop-left t
                                                          :inverse t)))
          (set-text-properties (match-beginning 2) (match-end 2)
                               `(display ,(svg-tag-make (format "%1dH" (/ d 60))
                                                        :face 'nano-faded
                                                        :crop-left t :inverse t
                                                        :padding 2
                                                        :alignment 0))))))))
(add-hook 'org-agenda-mode-hook #'my/svg-tag-timestamp)
(advice-add 'org-agenda-redo :after #'my/svg-tag-timestamp)

(defun my/org-agenda-custom-date ()
  (interactive)
  (let* ((timestamp (org-entry-get nil "TIMESTAMP"))
         (timestamp (or timestamp (org-entry-get nil "DEADLINE"))))
    (if timestamp
        (let* ((delta (- (org-time-string-to-absolute
                          (org-read-date nil nil timestamp))
                         (org-time-string-to-absolute
                          (org-read-date nil nil ""))))
               (delta (/ (+ 1 delta) 30.0))
               (face (cond ;; ((< delta 0.25) 'nano-popout)
                      ;; ((< delta 0.50) 'nano-salient)
                      ((< delta 1.00) 'nano-default)
                      (t 'nano-faded))))
          (concat
           (propertize " " 'face nil
                       'display (svg-lib-progress-pie
                                 delta nil
                                 :background (face-background face nil 'default)
                                 :foreground (face-foreground face)
                                 :margin 0 :stroke 2 :padding 1))
           " "
           (propertize
            (format-time-string "%d/%m" (org-time-string-to-time timestamp))
            'face 'nano-popout)))
      "     ")))

(defvar my/org-agenda-update-delay 60)
(defvar my/org-agenda-update-timer nil)

(defun my/org-agenda-update ()
  "Refresh daily agenda view"

  (when my/org-agenda-update-timer
    (cancel-timer my/org-agenda-update-timer))

  (let ((window (get-buffer-window "*Org Agenda(a)*" t)))
    (when window
      (with-selected-window window
        (let ((inhibit-message t))
          (org-agenda-redo)))))

  (setq my/org-agenda-update-timer
        (run-with-idle-timer
         (time-add (current-idle-time) my/org-agenda-update-delay)
         nil
         'my/org-agenda-update)))

(run-with-idle-timer my/org-agenda-update-delay t 'my/org-agenda-update)

(require 'nano-agenda)

(bind-key "C-n" #'nano-agenda)

(with-eval-after-load 'org

  (setq org-agenda-use-time-grid nil)
  (setq org-archive-location "~/dotfiles/home/secrets/archive.org::* From %s")
  (setq org-latex-create-formula-image-program 'dvisvgm)

  (setq org-image-actual-width nil)
  (setq org-startup-indented t)
  (setq org-bullets-bullet-list '(" ") )
  (setq org-pretty-entities t)
  (setq org-ellipsis "  ")
  (setq org-hide-emphasis-markers t)
  (setq org-agenda-block-separator "")
  (setq org-fontify-whole-heading-line t)
  (setq org-fontify-done-headline t)
  (setq org-fontify-quote-and-verse-blocks t)
  (push '(scheme . t) org-babel-load-languages)
  (push '(python . t) org-babel-load-languages)
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((scheme . t) (python . t))))

(with-eval-after-load 'ob-core
  (setq geiser-active-implementations '(guile))
  (setq geiser-default-implementation 'guile)
  (setq org-confirm-babel-evaluate nil)
  (setq org-babel-python-command "python3"))

;;(setq geiser-repl-send-on-return-p nil)
;;(setq scheme-program-name "guile")

(when (fboundp 'native-compile-async)
  (setq comp-deferred-compilation t
        comp-deferred-compilation-black-list '("/mu4e.*\\.el$")))

(when (eq window-system 'pgtk)
  (pgtk-use-im-context t))
(add-to-list 'load-path "~/.config/emacs/site-lisp/")
;;(load-theme THEME t)
(setq org-agenda-window-setup 'current-window)
(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(setq read-process-output-max (* 1024 1024))
(setq lsp-idle-delay 0.500)
(setq large-file-warning-threshold 100000000)
(add-hook 'before-save-hook 'whitespace-cleanup)
;;(add-hook 'eww-mode-hook (lambda () (setq mode-line-format nil)))
(setq eww-header-line-format nil)
(add-hook 'eshell-mode-hook (lambda ()
                              (setq-local global-hl-line-mode nil)
                              (display-line-numbers-mode -1)))
;;(add-hook 'eshell-mode-hook (lambda () (setq mode-line-format nil)))
;;(add-hook 'term-mode-hook (lambda () (setq mode-line-format nil)))
;;(add-hook 'vterm-mode-hook (lambda () (setq mode-line-format nil)))

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(setq-default tab-width 4
              indent-tabs-mode nil)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(evil-set-leader '(normal visual replace operator motion emacs) (kbd "SPC"))
(evil-define-key 'normal 'global (kbd "<leader>oal") 'org-agenda-list)
(evil-define-key 'normal 'global (kbd "<leader>orl") 'org-roam-buffer-toggle)
(evil-define-key 'normal 'global (kbd "<leader>orf") 'org-roam-node-find)
(evil-define-key 'normal 'global (kbd "<leader>ort") 'org-roam-tag-add)
(evil-define-key 'normal 'global (kbd "<leader>ff") 'counsel-find-file)
(evil-define-key 'normal 'global (kbd "<leader>oo") 'org-open-at-point)
(evil-define-key 'normal 'global (kbd "<leader>ou") 'org-mark-ring-goto)
(evil-define-key 'normal 'global (kbd "<leader>eob") 'emms-browser)
(evil-define-key 'normal 'global (kbd "<leader>eop") 'emms)
(evil-define-key 'normal 'global (kbd "<leader>en") 'emms-next)
(evil-define-key 'normal 'global (kbd "<leader>eN") 'emms-previous)
(evil-define-key 'normal 'global (kbd "<leader>ep") 'emms-pause)
(evil-define-key 'normal 'global (kbd "<leader>ori") 'org-roam-node-insert)
(evil-define-key 'normal 'org-mode-map (kbd "DEL") 'org-latex-preview)
(evil-define-key 'normal 'global (kbd "<leader>cc") 'kill-current-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bb") 'counsel-switch-buffer)
;;(evil-define-key 'normal 'global (kbd "<leader>cr") 'reload-init-file)
(evil-define-key 'normal 'global (kbd "<leader>pp") 'projectile-find-file)
(evil-define-key 'normal 'global (kbd "<leader>v") '(lambda () (interactive)
                                                      (split-window-right)
                                                      (evil-window-right 1)))
(evil-define-key 'normal 'global (kbd "<leader>g") '(lambda () (interactive)
                                                      (split-window-below)
                                                      (evil-window-down 1)))
(evil-define-key 'normal 'global (kbd "<leader>h") 'evil-window-left)
(evil-define-key 'normal 'global (kbd "<leader>j") 'evil-window-down)
(evil-define-key 'normal 'global (kbd "<leader>k") 'evil-window-up)
(evil-define-key 'normal 'global (kbd "<leader>l") 'evil-window-right)
(evil-define-key 'normal 'global (kbd "<leader>\\") 'ivy-latex)
(global-set-key (kbd "M-\\") 'ivy-latex)
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

(evil-define-key 'normal 'global (kbd "<leader>qq") 'evil-quit)

;;(setq evil-collection-calendar-want-org-bindings t)
(setq inhibit-startup-screen 1)
;;(setq doom-themes-enable-bold t
;;doom-themes-enable-italic t)

;;(doom-themes-visual-bell-config)

;;(doom-themes-neotree-config)
;;(setq doom-themes-treemacs-theme "doom-colors")
;;(doom-themes-treemacs-config)

;;(doom-themes-org-config)
(electric-indent-mode -1)
(global-aggressive-indent-mode 1)

;;(add-hook 'org-mode-hook 'org-indent-mode)
(set-default 'truncate-lines nil)
(add-hook 'org-mode-hook (lambda () (setq evil-auto-indent nil)))
;;(add-hook 'org-mode-hook (lambda () (flyspell-mode)))
(add-hook 'org-mode-hook 'rainbow-delimiters-mode)
;;(add-hook 'org-mode-hook (lambda ()
;;(setq-local global-hl-line-mode nil) (display-line-numbers-mode -1)
                                        ;))
(add-hook 'org-mode-hook (lambda () (setq-local global-hl-line-mode nil)))
;;(add-hook 'org-mode-hook (lambda () (setq mode-line-format nil)))
(add-hook 'term-mode-hook (lambda ()
                            (setq-local global-hl-line-mode nil)
                            (display-line-numbers-mode -1)))
(add-hook 'vterm-mode-hook (lambda ()
                             (setq-local global-hl-line-mode nil)
                             (display-line-numbers-mode -1)))
(add-hook 'Buffer-menu-mode-hook (lambda ()
                                   (setq-local global-hl-line-mode nil)
                                   (display-line-numbers-mode -1)))
(add-hook 'pdf-tools-enabled-hook (lambda ()
                                    (setq-local global-hl-line-mode nil)
                                    (display-line-numbers-mode -1)))
(global-visual-line-mode)
(add-hook 'post-command-hook (rainbow-delimiters-mode))
(global-display-line-numbers-mode)
(global-hl-line-mode)
(global-prettify-symbols-mode)
;;(add-hook 'org-mode-hook '(lambda () evil-org-mode))
;;(add-hook 'org-mode-hook 'org-bullets-mode)
(add-hook 'org-mode-hook 'org-superstar-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
               '("report"
                 "\\documentclass[11pt]{report}"
                 ;; ("\\part{%s}" . "\\part*{%s}")
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
;;(defun er-reinstall-package (pkg)
;;(interactive (list (intern (completing-read "Reinstall package: "
;;(mapcar #'car package-alist)
;;))))
;;(unload-feature pkg)
;;(package-reinstall pkg)
;;(require pkg))

;;(defun reload-init-file ()
;;        "Reload init.el."
;;(interactive)
;;(load-file (expand-file-name (concat user-emacs-directory "init.el"))))
;;(require 'evil-org-agenda)
;;(evil-org-agenda-set-keys)
(defun org-mode-export-hook()
  (interactive)
  (if (eq major-mode 'org-mode) (org-latex-export-to-pdf t)))
(add-hook 'after-save-hook 'org-mode-export-hook)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-indexing-method 'alien)
(pdf-tools-install)
(setq-default pdf-view-display-size 'fit-width)
(define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
;;(pdf-annot-activate-created-annotations t "automatically annotate highlights")
(setq pdf-view-resize-factor 1.1)
(add-hook 'pdf-view-mode-hook 'auto-revert-mode)
(add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)))
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)


;;(progn
;;  (defun use-variable-width-font ()
;;    "Set current buffer to use variable-width font."
;;    (variable-pitch-mode 1)
;;   (text-scale-increase 1 )
;;    ))
;;(add-hook 'org-mode-hook 'use-variable-width-font)
;;(set-face-attribute 'org-table nil :inherit 'fixed-pitch)
;;(set-face-attribute 'org-code nil :inherit 'fixed-pitch)
;;(set-face-attribute 'org-block nil :inherit 'fixed-pitch)
;;        (font-lock-add-keywords 'org-mode
;;                               '(("^ *\\([-]\\) "
;;                                 (0 (prog1 ()
;;(compose-region (match-beginning 1) (match-end 1) "•")
                                        ;)))))
;;     (font-lock-add-keywords 'org-mode
;;                            '(("^ *\\([+]\\) "
;;                              (0 (prog1 ()
                                        ;(compose-region (match-beginning 1) (match-end 1) "•"))))))



(setq org-odt-preferred-output-format "docx")

(fset 'yes-or-no-p 'y-or-n-p)
;;(require 'exwm)
;;(require 'xelb)
;;(require 'exwm-config)
;;(setq exwm-manage-configurations '((t char-mode t)))
;;    (setq mouse-autoselect-window t
;;        focus-follows-mouse t)
;;                (exwm-config-default)
;; Make buffer name more meaningful
;;(add-hook 'exwm-update-class-hook
;;           (lambda ()
;;          (exwm-workspace-rename-buffer exwm-class-name)))

;;    (require 'exwm-randr)
;;    (setq exwm-randr-workspace-monitor-plist '(0 "LVDS-1"
;;                                                1 "VGA-1"))
;;    (add-hook 'exwm-randr-screen-change-hook
;;             (lambda ()
;;                  (start-process-shell-command
;;                   "xrandr" nil
;;"xrandr --output LVDS-1 --left-of VGA-1 --auto"
;;)))
;;  (exwm-randr-enable)

;;                (setq exwm-input-global-keys
;;               `(
;;              (,(kbd "s-h") . windmove-left)
;;             (,(kbd "s-j") . windmove-down)
;;            (,(kbd "s-k") . windmove-up)
;;           (,(kbd "s-l") . windmove-right)
;;          (,(kbd "s-v") . (lambda () (interactive) (split-window-horizontally) (windmove-right));;)
;;            (,(kbd "s-g") . (lambda () (interactive) (split-window-vertically) (windmove-down)))
;;                (,(kbd "s-q") . delete-window)
;;               (,(kbd "s-Q") . (lambda () (interactive) (kill-this-buffer) (delete-window)))
;;              (,(kbd "s-c") . kill-this-buffer)
;;             (,(kbd "s-<return>") . eshell-new)
;;            (,(kbd "s-H") . windower-swap-left)
;;           (,(kbd "s-J") . windower-swap-below)
;;          (,(kbd "s-K") . windower-swap-above)
;;         (,(kbd "s-L") . windower-swap-right)
;;        (,(kbd "s-L") . windower-swap-right)
;;       (,(kbd "s-m") . exwm-workspace-move-window)
;;      (,(kbd "s-i") . exwm-input-toggle-keyboard)
;;     (,(kbd "s-w") . exwm-workspace-switch)
;;    (,(kbd "s-R") . exwm-reset)
;;   (,(kbd "s-b") . buffer-menu)
;;  (,(kbd "s-o") . execute-extended-command)
;;                ([?\s-d] . (lambda (command)
;;                   (interactive (list (read-shell-command "$ ")))
;;                  (start-process-shell-command command nil command)))
;;
;;                 ,@(mapcar (lambda (i)
;;                            `(,(kbd (format "s-%d" i)) .
;;                           (lambda ()
;;                              (interactive)
;;                             (exwm-workspace-switch-create ,i))))
;;                    (number-sequence 0 9))
;;
;;               (,(kbd "s-f") . exwm-layout-toggle-fullscreen)
;;              (,(kbd "s-F") . exwm-floating-toggle-floating)))
;;(exwm-enable)

(defun maybe-delete-frame-buffer (frame)
  "When a dedicated FRAME is deleted, also kill its buffer.
A dedicated frame contains a single window whose buffer is not
displayed anywhere else."
  (let ((windows (window-list frame)))
    (when (eq 1 (length windows))
      (let ((buffer (window-buffer (car windows))))
        (when (eq 1 (length (get-buffer-window-list buffer nil t)))
          (kill-buffer buffer))))))
(add-to-list 'delete-frame-functions #'maybe-delete-frame-buffer)

(setq circe-use-cycle-completion t)
(setq circe-server-send-unknown-command-p t)
(enable-circe-display-images)
(setq org-agenda-files '("/home/main/.local/bin/timetable.org"
                         "/home/main/.local/bin/agenda.org"))
;;(add-hook 'window-configuration-change-hook
;;          (lambda () (progn
;;  (setq left-margin-width 2)
;;  (setq right-margin-width 2)
;;  (set-window-buffer nil (current-buffer)))))
;;(pixel-scroll-precision-mode 1)
(setq redisplay-dont-pause t)
;;(doom-modeline-mode)
(set-face-attribute 'fringe nil
                    :foreground (face-foreground 'default)
                    :background (face-background 'default))
(setq lui-time-stamp-position nil)

(defun org-babel-scheme-execute-with-geiser (code output impl repl)
  "Execute code in specified REPL.
If the REPL doesn't exist, create it using the given scheme
implementation.

Returns the output of executing the code if the OUTPUT parameter
is true; otherwise returns the last value."
  (let ((result nil))
    (with-temp-buffer
      (insert (format ";; -*- geiser-scheme-implementation: %s -*-" impl))
      (newline)
      (insert code)
      (geiser-mode)
      (let ((geiser-repl-window-allow-split nil)
            (geiser-repl-use-other-window nil))
        (let ((repl-buffer (save-current-buffer
                             (org-babel-scheme-get-repl impl repl))))
          (when (not (eq impl (org-babel-scheme-get-buffer-impl
                               (current-buffer))))
            (message "Implementation mismatch: %s (%s) %s (%s)"
                     impl (symbolp impl)
                     (org-babel-scheme-get-buffer-impl (current-buffer))
                     (symbolp (org-babel-scheme-get-buffer-impl
                               (current-buffer)))))
          (setq geiser-repl--repl repl-buffer)
          (setq geiser-impl--implementation nil)
          (let ((geiser-debug-jump-to-debug-p nil)
                (geiser-debug-show-debug-p nil))
            (let ((ret (geiser-eval-region/wait (point-min) (point-max))))
              (setq result (if output
                               (or (geiser-eval--retort-output ret)
                                   "Geiser Interpreter produced no output")
                             (geiser-eval--retort-result-str ret "")))))
          (when (not repl)
            (save-current-buffer (set-buffer repl-buffer)
                                 (geiser-repl-exit))
            (set-process-query-on-exit-flag
             (get-buffer-process repl-buffer) nil)
            (kill-buffer repl-buffer)))))
    result))

;;(add-hook 'elfeed-new-entry-hook
;;(elfeed-make-tagger :feed-url "youtube\\.com"
;;:remove 'youtube))
;;

(add-to-list 'display-buffer-alist '("*Async Shell Command*" display-buffer-no-window (nil)))

(add-hook 'elfeed-new-entry-hook
          (lambda () async-shell-command "~/dotfiles/home/scripts/backupelfeed.sh"))
;;
;;(add-hook 'elfeed-new-entry-hook
;;(elfeed-make-tagger :feed-url "nitter\\.net"
;;:add '(twitter)))
(defun sk/elfeed-db-remove-entry (id)
  "Removes the entry for ID"
  (avl-tree-delete elfeed-db-index id)
  (remhash id elfeed-db-entries))

(defun sk/elfeed-search-remove-selected ()
  "Remove selected entries from database"
  (interactive)
  (let* ((entries (elfeed-search-selected))
         (count (length entries)))
    (when (y-or-n-p (format "Delete %d entires?" count))
      (cl-loop for entry in entries
               do (sk/elfeed-db-remove-entry (elfeed-entry-id entry)))))
  (elfeed-search-update--force))

;;(setq-default elfeed-search-filter "-entertainment ")
(setq-default elfeed-search-filter "")
(with-eval-after-load 'elfeed

  (setq elfeed-search-title-max-width 80    ; Maximum titles width
        elfeed-search-title-min-width 40    ; Minimum titles width
        elfeed-search-trailing-width 24     ; Space reserved for feed & tag
        elfeed-search-filter                ; Default filter
        "@1-weeks-ago +unread"
        elfeed-search-print-entry-function  ; Alternative print function
        #'my/elfeed-search-print-entry)


  (bind-key "U" #'elfeed-update elfeed-search-mode-map)


  (setq-default elfeed-search-filter "-entertainment "))
(with-eval-after-load 'elfeed-search
  (setq-default elfeed-search-filter "-entertainment "))

;;(defun browse-url-mpv (url &optional new-window)
;;   (start-process "mpv" "*mpv*" "mpv" url))

;;(setq browse-url-browser-function 'browse-url-default-browser)
;;(setq browse-url-handlers '(("https://www.youtube.com/\.*" . browse-url-mpv)
;;("https://odysee.\*" . browse-url-mpv)
;;("." . eww-browse-url)))
(setq inspirations '(

                     ";; The following text is either a product of the browser\
 or is the product of another operating system.
;; It is a work of fiction.

"

                     ";; life is a sine wave that varies in intensity

"

                     ";; it can't get much worse from here

"

                     ";; The god of the world, Pseudo-Dionysius.

"

                     ";; Good morning, Anon!
;; Don't forget to take your heart meds.

"

                     ";; Rather than a warrior beneath the walls of the State,
;; a political activist is a patient watchman of the void\
instructed by the event.

"))

;; If the *scratch* buffer is killed, recreate it automatically
;; FROM: Morten Welind
;;http://www.geocrawler.com/archives/3/338/1994/6/0/1877802/
(save-excursion
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer))

(defun kill-scratch-buffer ()
  ;; The next line is just in case someone calls this manually
  (set-buffer (get-buffer-create "*scratch*"))
  ;; Kill the current (*scratch*) buffer
  (remove-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
  (kill-buffer (current-buffer))
  ;; Make a brand new *scratch* buffer
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
  (setq initial-scratch-message
        (nth (random (length inspirations)) inspirations))
  (insert initial-scratch-message)
  ;; Since we killed it, don't let caller do that.
  nil)
(setq initial-scratch-message (nth (random (length inspirations)) inspirations))
(with-eval-after-load 'mu4e
  (setq message-send-mail-function 'smtpmail-send-it)

  ;;(setq mu4e-headers-thread-root-prefix          '(""    . "")
  ;;mu4e-headers-thread-first-child-prefix   '(" "   . " ")
  ;;mu4e-headers-thread-child-prefix         '(" "   . " ")
  ;;mu4e-headers-thread-last-child-prefix    '(" "   . " ")
  ;;mu4e-headers-thread-connection-prefix    '(" |"  . "  ")
  ;;mu4e-headers-thread-blank-prefix         '(""    . "")
  ;;mu4e-headers-thread-orphan-prefix        '(" "   . "")
  ;;mu4e-headers-thread-single-orphan-prefix '(""    . "")
  ;;mu4e-headers-thread-duplicate-prefix     '("="   . "="))

                                        ;
  ;;(add-to-list 'mu4e-header-info-custom
  ;;'(:multiline . (:name "multiline"
  ;;:shortname ""
  ;;:function my/mu4e-headers-multiline)))
  ;;(setq mu4e-headers-fields  '((:multiline . nil)))
  ;;
  ;;(defun my/mu4e-headers-mode-setup ()
  ;;
  ;;(with-current-buffer "*mu4e-headers*"
  ;;(set-face-attribute 'mu4e-header-highlight-face nil
  ;;:inherit 'nano-salient-i)
  ;;(setq-local left-margin-width 2)
  ;;(set-window-buffer nil "*mu4e-headers*")))
  ;;
  ;;(add-hook 'mu4e-headers-found-hook #'my/mu4e-headers-mode-setup)
  ;;(add-hook 'mu4e-headers-mode-hook  #'my/mu4e-headers-mode-setup)
  ;;
  ;;(bind-key [remap next-line] #'mu4e-headers-next mu4e-headers-mode-map)
  ;;(bind-key [remap previous-line] #'mu4e-headers-prev mu4e-headers-mode-map)
  ;;
  ;;(setq hl-line-range-function #'my/mu4e-hl-line-move)
  ;;(defun mu4e-folding--make-root-overlay (beg end)
  ;;"Create the root overlay."
  ;;
  ;;(let ((root (get-text-property
  ;;(min (point-max) (+ (line-beginning-position) 9))
  ;;'mu4e-root)))
  ;;(if root
  ;;(make-overlay (+ (line-beginning-position) 11) end)
  ;;(make-overlay beg end))))
  ;;
  ;;(defun my/mu4e-hl-line-move ()
  ;;(let ((root (get-text-property
  ;;(min (point-max) (+ (line-beginning-position) 9))
  ;;'mu4e-root)))
  ;;(if root
  ;;(cons (+ (line-beginning-position) 11)
  ;;(line-beginning-position 2))
  ;;(cons (line-beginning-position)
  ;;(line-beginning-position 2)))))
  (setq
   mu4e-maildir "~/mail"
   mu4e-attachment-dir "~/Downloads"
   mu4e-get-mail-command "mbsync -a"

   ;;mu4e-update-interval 300            ; Update interval (seconds)
   mu4e-index-cleanup t                ; Cleanup after indexing
   mu4e-index-update-error-warning t   ; Warnings during update
   mu4e-hide-index-messages t          ; Hide indexing messages
   mu4e-index-update-in-background t   ; Background update
   mu4e-change-filenames-when-moving t ; Needed for mbsync
   mu4e-index-lazy-check nil           ; Don't be lazy, index everything

   mu4e-confirm-quit nil
   mu4e-split-view 'single-window

   mu4e-headers-auto-update nil
   mu4e-headers-date-format "%d-%m"
   mu4e-headers-time-format "%H:%M"
   mu4e-headers-from-or-to-prefix '("" . "To ")
   mu4e-headers-include-related t
   mu4e-headers-skip-duplicates t)

  (setq mu4e-context-policy 'pick-first  ; How to determine context when entering headers view
        mu4e-compose-context-policy nil) ; Do not modify context when composing

  (setq mu4e-show-images t
        mu4e-use-fancy-chars nil
        mu4e-view-html-plaintext-ratio-heuristic  most-positive-fixnum
        mu4e-html2text-command 'mu4e-shr2text
        shr-use-fonts nil   ; Simple HTML Renderer / no font
        shr-use-colors nil) ; Simple HTML Renderer / no color

  )



(defun my/mu4e-get-account (msg)
  "Get MSG related account."

  (let* ((maildir (mu4e-message-field msg :maildir))
         (maildir (substring maildir 1)))
    (nth 0 (split-string maildir "/"))))


(defun my/mu4e-get-maildir (msg)
  "Get MSG related maildir."

  (let* ((maildir (mu4e-message-field msg :maildir))
         (maildir (substring maildir 1)))
    (nth 0 (reverse (split-string maildir "/")))))


(defun my/mu4e-get-mailbox (msg)
  "Get MSG related mailbox as 'account - maildir' "

  (format "%s - %s" (mu4e-get-account msg) (mu4e-get-maildir msg)))


(defun my/mu4e-get-sender (msg)
  "Get MSG sender."

  (let ((addr (cdr-safe (car-safe (mu4e-message-field msg :from)))))
    (mu4e~headers-contact-str (mu4e-message-field msg :from))))



(add-to-list 'org-agenda-custom-commands
             '("x" "Tasks"
               ((todo "TODO"  "PROJECT"
                      ( (org-agenda-todo-keyword-format ":%s:")
                        (org-agenda-prefix-format '((todo   . " ")))
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp))
                        (org-agenda-overriding-header (propertize " Todo \n" 'face 'nano-strong))))

                (tags "+TALK+TIMESTAMP>=\"<now>\""
                      ((org-agenda-span 90)
                       (org-agenda-max-tags 5)
                       (org-agenda-prefix-format
                        '((tags   . " %(my/org-agenda-custom-date) ")))
                       (org-agenda-overriding-header "\n Upcoming talks\n")))

                (tags "TEACHING+TIMESTAMP>=\"<now>\""
                      ((org-agenda-span 90)
                       (org-agenda-max-tags 5)
                       (org-agenda-prefix-format
                        '((tags   . " %(my/org-agenda-custom-date) ")))
                       (org-agenda-overriding-header "\n Upcoming lessons\n")))

                (tags "TRAVEL+TIMESTAMP>=\"<now>\""
                      ((org-agenda-span 90)
                       (org-agenda-max-tags 5)
                       (org-agenda-prefix-format
                        '((tags .  " %(my/org-agenda-custom-date) ")))
                       (org-agenda-overriding-header "\n Upcoming travels\n")))

                (tags "DEADLINE>=\"<today>\""
                      ((org-agenda-span 90)
                       (org-agenda-max-tags 5)
                       (org-agenda-prefix-format
                        '((tags .  " %(my/org-agenda-custom-date) ")))
                       (org-agenda-overriding-header
                        "\n Upcoming deadlines\n"))))))

(require 'mu4e-dashboard)
(require 'svg-lib)

(defun mu4e-dashboard ()
  "Open the mu4e dashboard on the left side."

  (interactive)
  ;;(with-selected-window
  ;;(split-window (selected-window) -34 'left)

  (find-file "~/dotfiles/home/secrets/dashboard.org")
  (mu4e-dashboard-mode)
  (hl-line-mode)
  ;;(set-window-dedicated-p nil t)
  (defvar svg-font-lock-keywords
    `(("\\!\\([\\ 0-9]+\\)\\!"
       (0 (list 'face nil 'display (svg-font-lock-tag (match-string 1)))))))
  (defun svg-font-lock-tag (label)
    (svg-lib-tag label nil
                 :stroke 0 :margin 1 :font-weight 'bold
                 :padding (max 0 (- 3 (length label)))
                 :foreground (face-foreground 'nano-popout-i)
                 :background (face-background 'nano-popout-i)))
  (push 'display font-lock-extra-managed-props)
  (font-lock-add-keywords nil svg-font-lock-keywords)
  (font-lock-flush (point-min) (point-max)));)
(add-hook 'mu4e-dashboard-mode-hook 'evil-normalize-keymaps)

(setq svg-lib-style-default (svg-lib-style-compute-default))
