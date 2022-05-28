(use-modules (gnu packages))
(use-modules (guix profiles))
(define-public guile-packages
(list
        (specification->package "guile-gcrypt")
        (specification->package "guile")
))

(packages->manifest guile-packages)
