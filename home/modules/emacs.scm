(define-module (modules emacs)
  #:use-module (guix gexp)
  #:use-module (guix transformations)
  #:use-module (gnu home)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (gnu packages emacs)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)

  #:use-module (rde packages emacs)
  #:use-module (rde packages emacs-xyz)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (gnu home-services emacs)
  #:use-module (gnu home-services-utils)
  )

(define transform
  (options->transformation
   '(
     (without-tests . "emacs-deferred")
     (with-branch . "emacs-list-utils=master")
     )))


;; TODO: source this from emacs.scm manifest
(define emacs-packages-2
  (map (compose transform specification->package)
       '(
         "emacs-org-roam-ui"
         "emacs-svg-lib"
         "emacs-svg-tag-mode"
         "emacs-nano-theme"
         "emacs-nano-modeline"
         "emacs-mu4e-folding"
         "emacs-mu4e-dashboard"
         "emacs-nano-agenda"
         "emacs-nov-el"
         "emacs-aggressive-indent"
         "emacs-elfeed"
         "emacs-guix"
         "emacs-exwm"
         "emacs-geiser-guile"
         "emacs-mini-frame"
         "emacs-vertico"
         "emacs-orderless"
         ;;"emacs-svg-tag-mode"
         ;;"emacs-pdf-continuous-scroll"
         "emacs-counsel"
         ;;"emacs-helpful"
         "emacs-corfu"
         "emacs-cape"
         "emacs-consult"
         "emacs-org"
         "emacs-org-download"
         "emacs-which-key"
         ;;"emacs-mu4e-alert"
         ;;"emacs-nano-modeline"
         "emacs-org-msg"
         "emacs-flycheck"
         "emacs-org-roam"
         "emacs-use-package"
         "emacs-ivy-posframe"
         "emacs-ace-link"
         "emacs-geiser-racket"
         "emacs-sudo-edit"
         ;;"emacs-guix"
         "emacs-emacsql"
         "emacs-simple-httpd"
         "emacs-websocket"
         "emacs-pdf-tools"
         "emacs-ob-async"
         "emacs-evil-collection"
         ;;"emacs-exec-path-from-shell"
         "emacs-frames-only-mode"
         "emacs-request"
         "emacs-esxml"
         "emacs-transient"
         "emacs-multi-vterm"
         ;;"emacs-chess"
         "emacs-circe"
         ;;"emacs-exwm"
         "emacs-all-the-icons"
         "emacs-annalist"
         ;;"emacs-auto-indent-mode"
         "emacs-bui"
         "emacs-doom-modeline"
         "emacs-all-the-icons-completion"
         "emacs-doom-themes"
         "emacs-edit-indirect"
         ;;"emacs-elisp-format"
         ;;"emacs-emms"
         ;;"emacs-erc-image"
         ;;"emacs-evil-org"
         "emacs-org-superstar"
         "emacs-org-bullets"
         "emacs-undo-tree"
         "emacs-evil"
         "emacs-goto-chg"
         ;;"emacs-magit-popup"
         ;;"emacs-mini-modeline"
         ;;"emacs-multi-term"
         ;;"emacs-native-complete"
         ;;"emacs-org-babel-eval-in-repl"
         "emacs-ess"
         ;;"emacs-matlab-mode"
         ;;"emacs-eval-in-repl"
         "emacs-ace-window"
         "emacs-avy"
         "emacs-paredit"
         "emacs-projectile"
         "emacs-rainbow-delimiters"
         "emacs-shrink-path"
         "emacs-f"
         "emacs-dash"
         ;;"emacs-libmpdel"
         ;;"emacs-mpdel"
         "emacs-s"
         "emacs-tablist"
         "emacs-alect-themes"
         ;;"emacs-texfrag"
         "emacs-auctex"
         ;;"emacs-transmission"
         "emacs-windower"
         "emacs-writeroom"
         "emacs-visual-fill-column"
         ;;"emacs-xelb"
         "emacs-geiser"
         )))

(define-public emacs-services
  (list
   (service home-emacs-service-type
            (home-emacs-configuration
             (package emacs-next-pgtk-latest)
             (init-el `(,(slurp-file-gexp (local-file "../secrets/emacs-secrets.el")) ,(slurp-file-gexp (local-file "../files/init.el"))))
             (early-init-el `(,(slurp-file-gexp (local-file "../files/early-init.el"))))
             (rebuild-elisp-packages? #f)
             ;; Emacs is unable to open any packages requiring a display
             ;; when ran as a daemon through guix
             (server-mode? #f)
             (elisp-packages emacs-packages-2)
             ))))
