(use-modules (gnu packages))
(use-modules (guix profiles))
(define-public desktop-packages
(list
        (specification->package "xdg-utils")
        (specification->package "dbus-glib")
	;; For gsettings
        (specification->package "glib:bin")
        (specification->package "dbus")
        (specification->package "imagemagick")
        (specification->package "pavucontrol")
        (specification->package "libreoffice")
        (specification->package "flatpak")
        (specification->package "foot")
        (specification->package "thunar")
        (specification->package
          "ungoogled-chromium-wayland")
        (specification->package "ublock-origin-chromium")
        (specification->package "lxappearance")
        (specification->package "zathura")
        (specification->package "zathura-djvu")
        ;;(specification->package "icecat")
        (specification->package "mpv")
        (specification->package "nyxt")
        (specification->package "yt-dlp")
        (specification->package "feh")
        (specification->package "mypaint")
        ;;(specification->package "poppler")
        (specification->package "zathura-pdf-poppler")
        (specification->package "gimp")
        (specification->package "udiskie")
        (specification->package "gammastep")
        (specification->package "ffmpeg")
        (specification->package "qbittorrent")
        (specification->package "inkscape")
))

(packages->manifest desktop-packages)
