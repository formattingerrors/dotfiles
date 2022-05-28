(use-modules (gnu packages))
(use-modules (guix profiles))
(define-public science-packages
(list
        (specification->package "octave")
        (specification->package "python-notebook")
        (specification->package "python-sympy")
        (specification->package "python-scipy")
        (specification->package "lean")
        (specification->package "less")
        (specification->package "ghostscript")
        (specification->package "gnuplot")
))

(packages->manifest science-packages)
