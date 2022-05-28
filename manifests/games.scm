(use-modules (gnu packages))
(use-modules (guix profiles))
(define-public games-packages
(list
        (specification->package "wine64")
        (specification->package "bastet")
        (specification->package "dwarf-fortress")
        (specification->package "minetest-mineclone")
        (specification->package "minetest")
        (specification->package "easyrpg-player")
        (specification->package "wine")
))

(packages->manifest games-packages)
