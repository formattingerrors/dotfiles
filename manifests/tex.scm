(use-modules (gnu packages))
(use-modules (guix profiles))
(define-public tex-packages
(list
  ;; N.B. Plan to move to a list of texlive- packages instead
        (specification->package "texlive")
))
(packages->manifest tex-packages)
