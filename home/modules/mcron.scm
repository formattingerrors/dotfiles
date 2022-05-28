(define-module (modules mcron)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services mcron)
  #:use-module (gnu services)
  #:use-module (gnu packages)
  #:use-module (mcron job-specifier)
  #:use-module (mcron base))

(define-public mcron-service
  (list
   (service home-mcron-service-type
            (home-mcron-configuration
             (jobs (list
                    #~(job '(next-minute
                             (range 0 60 5))
                           (lambda ()
                             (display "Isync job -- ")
                             (system* "mbsync" "--all"))
                           "Mail synchronization")

                    #~(job '(next-minute
                             (range 0 60 30))
                           (lambda ()
                             (display "I HATE ELFEED")
                             (system* "$HOME/dotfiles/home/scripts/backupelfeed.sh"))
                           "vanity of vanities saith the preacher")
                    ))))))
