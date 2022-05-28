(define-module (modules xdg)
#:use-module  (gnu home)
#:use-module  (gnu packages)
#:use-module  (gnu packages emacs)
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
)

(define-public xdg-services (list
                             (service home-xdg-mime-applications-service-type
                                      (home-xdg-mime-applications-configuration
                                       (default
                                         '((x-scheme-handler/http . chromium.desktop)
                                           (text/html . chromium.desktop)
                                           (x-scheme-handler/https://yewtu.be . mpv.desktop)
                                           (text/plain . emacsclient.desktop)
                                           ;;(application/pdf . org.pwmt.zathura-pdf-poppler.desktop)
                                           (application/pdf . emacsclient.desktop)
                                           (x-scheme-handler/https . chromium.desktop)))

                                       (desktop-entries (list
                                                         (xdg-desktop-entry
                                                          (file "emacsclient.desktop")
                                                          (name "Emacs Client (but opens emacs if server isn't running)")
                                                          (type 'application)
                                                          (config
                                                           '((exec . "emacsclient -c -a emacs %u"))))))


                                       ))

                             (service home-xdg-user-directories-service-type
                                      (home-xdg-user-directories-configuration
                                       (download "$HOME/Downloads")
                                       (videos "$HOME/Videos")
                                       (music "$HOME/Music")
                                       (pictures "$HOME/Pictures")
                                       (documents "$HOME/Documents")
                                       (publicshare "$HOME")
                                       (templates "$HOME")
                                       (desktop "$HOME/Desktop")))))
