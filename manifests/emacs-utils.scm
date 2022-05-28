(use-modules (gnu packages))
(use-modules (guix profiles))
;(use-modules (home packages emacs-better))
(define-public emacs-utils-packages
(list
        ;; Spelling
        (specification->package "ispell")
        (specification->package "aspell")
        (specification->package "python-proselint")
        (specification->package "aspell-dict-en")
        (specification->package "aspell-dict-uk")
        ;;(specification->package "emacs-next")
        (specification->package "emacs-next-pgtk-latest")
        ;; Manage mail.
        (specification->package "mu")
        (specification->package "smtpmail")
        (specification->package "isync")
        (specification->package "offlineimap3")
))
(packages->manifest emacs-utils-packages)
