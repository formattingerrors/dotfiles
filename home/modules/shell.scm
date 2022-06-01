(define-module (modules shell)
  #:use-module  (gnu home)
  #:use-module  (gnu packages)
  #:use-module  (gnu packages emacs)
  #:use-module  (gnu packages shellutils)
  #:use-module (gnu home services)
  #:use-module  (gnu services)
  #:use-module  (guix gexp)
  #:use-module  (gnu home-services shells)
  #:use-module  (gnu home-services shellutils)
  #:use-module  (gnu home-services-utils)
  )

(define-public shell-packages
  (map specification->package
       `(
         "sicp"
         "neovim"
         "mit-scheme"
         "mpd-mpc"
         "glibc-locales"
         "strace"
         "dash"
         "ncurses"
         "desktop-file-utils"
         "lm-sensors"
         "jq"
         "git"
         "unoconv"
         "cpupower"
         "edid-decode"
         "netcat"
         "neofetch"
         "pulsemixer"
         "tree"
         "file"
         "alsa-utils"
         "powertop"
         "htop"
         "zip"
         "ncmpcpp"
         "curl"
         "wol"
         "nmap"
         "unzip"
         "fzf"
         "zlib"
         "smartmontools")))

(define home-zsh-syntax-highlighting-service-type
  (service-type
   (name 'home-zsh-syntax-highlighting)
   (extensions
    (list
     (service-extension home-zsh-plugin-manager-service-type list)
     (service-extension
      home-zsh-service-type
      (const
       (home-zsh-extension
        (zshrc '("# Improve highlighting")))))))
   (default-value zsh-syntax-highlighting)
   (description #f)))

(define-public shell-services (list ;;(service home-zsh-syntax-highlighting-service-type)
                               (service home-zsh-service-type
                                        (home-zsh-configuration
                                         (zprofile (list (slurp-file-gexp (local-file "../files/profile"))))
                                         (environment-variables `(("GUIX_EXTRA_PROFILES" . "$HOME/.guix-extra-profiles")))
                                         (zshrc
                                          (list (slurp-file-gexp (local-file "../files/zshrc"))))))))
