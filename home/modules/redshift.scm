(define-module (modules redshift)
  #:use-module (gnu services)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu home services desktop))
;; Currently broken
(define-public redshift-services
  (list (service home-redshift-service-type
                 (home-redshift-configuration
                  (redshift redshift-wayland)
                  (location-provider 'manual)
                  (latitude 51.47)
                  (longitude -0.39)
                  ))))
