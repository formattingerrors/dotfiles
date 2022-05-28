(define-module (modules video)
#:use-module (gnu)
#:use-module (gnu home services)
#:use-module (gnu home-services wm)
#:use-module (gnu home-services base)
#:use-module (gnu home-services emacs)
#:use-module (gnu home-services video)
#:use-module (gnu packages web)
#:use-module (gnu packages base)
#:use-module (gnu packages video)
#:use-module (guix packages))

(define-public video-services
           (list
         (service
           home-mpv-service-type
           (home-mpv-configuration
           (default-options
             `(
           (ytdl-format . "\"bestvideo[height<=?720][vcodec!=?vp9]+bestaudio/best[height<=720][vcodec!=?vp9]\"")
               (sub-auto . "fuzzy")
               (alang . "\"jpn,jp,eng,en\"")
               (slang . "\"eng,en,enUS\"")
               (screenshot-directory . "~/Pictures/mpv")
               (cache . "yes")))
           (bindings
             `(("Alt+-" . "add video-zoom -0.05")
               ("shift+s" . "screenshot each-frame")
               ("Alt+=" . "add video-zoom 0.05")))))))
