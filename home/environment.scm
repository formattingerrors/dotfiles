;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(define-module (environment)
  #:use-module  (gnu home)
  #:use-module  (gnu packages)
  #:use-module  (gnu packages xorg)
  #:use-module  (gnu packages emacs)
  #:use-module  (gnu packages gnome-xyz)
  #:use-module  (gnu packages shellutils)
  #:use-module (gnu home services)
  #:use-module (gnu home services xdg)
  #:use-module  (gnu services)
  #:use-module  (guix transformations)
  #:use-module  (guix gexp)
  #:use-module  (gnu home-services shells)
  #:use-module  (gnu home-services shellutils)
  #:use-module  (gnu home-services-utils)
  #:use-module  (guix build-system copy)
  #:use-module  (modules emacs)
  #:use-module  (modules wm)
  #:use-module  (modules video)
  #:use-module  (modules redshift)
  #:use-module  (modules shell)
  #:use-module  (modules xdg)
  #:use-module  (modules mcron)
  #:use-module  (modules mail)
  #:use-module  (modules herd)
  #:use-module  (modules gtk)
  )
(define home-packages
  `(,@gtk-packages
    ,@shell-packages
    ,@wm-packages
    ,@mail-packages))

(home-environment
 (packages home-packages)
 (services
  `(,@xdg-services
    ,@video-services
    ,@herd-services
    ,@redshift-services
    ,@mail-services
    ,@emacs-services
    ,@shell-services
    ,@wm-service
    ,@mcron-service
    ,@gtk-services
    )))
