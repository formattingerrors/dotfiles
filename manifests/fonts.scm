(use-modules (gnu packages))
(use-modules (guix profiles))
(define-public fonts-packages
(list
        (specification->package "fontconfig")
        (specification->package "font-fira-code")
        (specification->package "font-inconsolata")
        (specification->package "font-google-roboto")
        (specification->package "font-sun-misc")
        (specification->package "font-awesome")
        (specification->package "font-dejavu")
        (specification->package
          "font-adobe-source-han-sans")
        (specification->package "font-iosevka-term")
        (specification->package "font-iosevka")
))

(packages->manifest fonts-packages)
