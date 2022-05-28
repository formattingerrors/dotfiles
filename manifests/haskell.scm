(use-modules (gnu packages))
(use-modules (guix profiles))
(define-public haskell-packages
(list
  (specification->package "ghc")
))

(packages->manifest haskell-packages)
