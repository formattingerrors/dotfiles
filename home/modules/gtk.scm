(define-module (modules gtk)
  #:use-module (gnu)
  #:use-module (gnu home services)
  #:use-module (gnu home-services base)
  #:use-module (gnu home-services-utils)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (ice-9 match)
  #:export (gtk3-service))

;; Shamelessly stolen from akagi
;; https://git.sr.ht/~akagi/guixrc/

;; TODO: rewrite this into a cleaner service that takes guix packages as input
(define-public gtk-packages
  (map specification->package
       `("arc-theme"
         "nordic-theme"
         "moka-icon-theme")))

(define* (serialize-css-config config #:optional (newline "\n"))
  (define serialize-rules
    (match-lambda
      ((attribute . value)
       (format #f "~a: ~a;" attribute value))))
  (define serialize-block
    (match-lambda
      ((selector (? list? rules))
       (string-append
        (symbol->string selector)
        " { "
        (string-join (map serialize-rules rules) " ")
        " }"))))
  (string-join (map serialize-block config) newline))

(define (make-gtk3-css config)
  (mixed-text-file "gtk3.css" #~(begin #$(serialize-css-config config))))

(define (make-gtk3-ini config)
  (mixed-text-file
   "settings.ini"
   #~(begin
       #$(generic-serialize-ini-config
          #:serialize-field (lambda (a b) (format #f "~a = ~a\n" a b))
          #:format-section (compose string-capitalize symbol->string)
          #:fields config))))

(define-public gtk-services
  (list (simple-service
         'gtk-settings-service
         home-xdg-configuration-files-service-type
         `(("gtk-3.0/settings.ini"
            ,(make-gtk3-ini
              '((settings
                 ((gtk-icon-theme-name . Moka)
                  (gtk-theme-name . Nordic)
                  (gtk-xft-antialias . 1)
                  (gtk-xft-hinting . 1)
                  (gtk-xft-hintstyle . hintfull)))))))
         )))
