;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules
  (gnu)
  (gnu packages admin)
  (gnu packages shells)
  (gnu packages gnome)
  (gnu packages linux)
  (gnu system nss)
  (gnu services shepherd)
  (ice-9 match)
  (srfi srfi-1)
  (guix transformations)
  (guix records)
  (guix gexp)
  (nongnu system linux-initrd)
  (gnu system locale))
(use-service-modules audio pm avahi cups sddm desktop nix xorg
                     networking ssh)
(use-package-modules 
  networking package-management xorg
             nss avahi cups linux certs display-managers wm )

(operating-system
 (locale "en_GB.utf8")
 (timezone "Europe/London")
 (keyboard-layout (keyboard-layout "gb"))
 (host-name "navi")
 (hosts-file (plain-file "hosts" "127.0.0.1 localhost navi
::1       localhost navi
127.0.0.1 discord.com
"))
 (name-service-switch %mdns-host-lookup-nss)
 (users (cons* (user-account
                (name "main")
                (shell (file-append zsh "/bin/zsh"))
                (comment "")
                (group "users")
                (home-directory "/home/main")
                (supplementary-groups
                 '("wheel" "lp" "lpadmin" "netdev" "audio" "video")))
               %base-user-accounts))
 (packages
  (append
   (list light guix-simplyblack-sddm-theme
         nss-mdns
         tlp
         (specification->package "sway")
         (specification->package "nss-certs"))
   %base-packages))
 (services
  (cons*
   (service nix-service-type)
   (service sddm-service-type
            (sddm-configuration
             (display-server "wayland")
             (theme "guix-simplyblack-sddm")))
   (service openssh-service-type)
   (service cups-service-type
            (cups-configuration
             (extensions (list cups-filters brlaser))
             (web-interface? #t)))
   (service network-manager-service-type)
   (service mpd-service-type
            (mpd-configuration
             (user "main")
             (port "6600")
             (address "localhost")
             (outputs (list (mpd-output
                             (name "MPD")
                             (type "pulse")
                             (enabled? #t)
                             )))))
   (service tlp-service-type
            (tlp-configuration
             (cpu-scaling-governor-on-ac (list "performance"))
             (cpu-scaling-governor-on-bat (list "powersave"))
             (cpu-boost-on-ac? #t)
             (sched-powersave-on-ac? #f)
             (sched-powersave-on-bat? #t)))
   (modify-services %desktop-services
                    (delete gdm-service-type)
                    (delete sddm-service-type)
                    (delete network-manager-service-type)
                    (guix-service-type config =>
                                       (guix-configuration
                                        (inherit config)
                                        (substitute-urls (append (list

                                                                  ;;These seem to not work
                                                                  ;;"https://guix.bordeaux.inria.fr"

                                                                  ;;"https://substitutes.guix.psychnotebook.org"
                                                                  "https://substitutes.nonguix.org"
                                                                  )
                                                                 %default-substitute-urls))
                                        (authorized-keys
                                         (append (list (plain-file "nonguix.pub"
                                                                   "(public-key
 (ecc
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)
  )
 )")
                                                       (plain-file "psychnotebook.pub"
                                                                   "(public-key
 (ecc
  (curve Ed25519)
  (q #D4E1CAFAB105581122B326E89804E3546EF905C0D9B39F161BBD8ABB4B11D14A#)
  )
 )")
                                                       (plain-file "inira.pub"
                                                                   "(public-key
 (ecc
  (curve Ed25519)
  (q #89FBA276A976A8DE2A69774771A92C8C879E0F24614AAAAE23119608707B3F06#)))
")
                                                       (local-file "gaming-pc.pub")
                                                       )
                                                 %default-authorized-guix-keys))
                                        (discover? #t)
                                        (extra-options '("--max-jobs=2" "--cores=0"))))) ))
 ;;(initrd microcode-initrd)
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets '("/dev/sda"))
   (keyboard-layout keyboard-layout)))
 (file-systems
  (cons* (file-system
          (mount-point "/")
          (device
           (uuid "6e9abe76-b77d-4553-90f2-b5444ed8219f"
                 'ext4))
          (type "ext4"))
         %base-file-systems))
 (swap-devices (list (swap-space (target "/swapfile") (dependencies (filter (file-system-mount-point-predicate "/") file-systems)))))
 )
