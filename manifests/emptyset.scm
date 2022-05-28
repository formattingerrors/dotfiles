(use-modules (gnu packages))
(use-modules (guix profiles))
;; Ø represents the default configuration for the default profile.
;; Every so often, the default profile will be reset to this manifest.
;; nss-certs is necessary for packages like curl to work correctly.
(define-public Ø-packages
(list
  (specification->package "nss-certs")))

(packages->manifest Ø-packages)
;;(specifications->manifest
;;  '("nss-certs"))
