(use-modules (gnu packages))
(use-modules (guix profiles))
(define-public python-packages
(list
        (specification->package "python")
        (specification->package "python-xlib")
))

(packages->manifest python-packages)
