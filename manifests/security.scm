(use-modules (gnu packages))
(use-modules (guix profiles))
(define-public security-packages
(list
        (specification->package "openssl")
        (specification->package "pinentry")
        (specification->package "gnupg")
))
(packages->manifest security-packages)
