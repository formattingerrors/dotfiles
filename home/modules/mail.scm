(define-module (modules mail)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (gnu home-services-utils)
  #:use-module (gnu home-services mail)
  #:use-module (gnu packages)
  #:use-module (secrets mail-secrets)
  #:use-module (gnu packages mail)
  #:use-module (guix gexp)
  )

(define-public
  mail-services
  (list
   (service
    home-isync-service-type
    (home-isync-configuration
     (config
      `(
        (CopyArrivalDate yes)
        (Sync Pull)
        (IMAPAccount work-gmail)
        (Host imap.gmail.com)
        (User ,(mail-username work-mail))
        (Pass ,(mail-password work-mail))
        (SSLType IMAPS)
        (AuthMechs LOGIN)
        (Pipelinedepth 1)
        ,#~""
        (IMAPStore work-gmail-remote)
        (Account work-gmail)
        ,#~""
        (MaildirStore work-gmail-local)
        (Subfolders Verbatim)
        (Path "~/mail/work-gmail/")
        (Inbox "~/mail/work-gmail/[Gmail]/Inbox")
        ,#~""
        (Channel work-gmail)
        (Far :work-gmail-remote:)
        (Near :work-gmail-local:)
        (Patterns *)
        (Create Both)
        (SyncState *)
        ,#~""
        (IMAPAccount rec-gmail)
        (Host imap.gmail.com)
        (User ,(mail-username rec-mail))
        (Pass ,(mail-password rec-mail))
        (SSLType IMAPS)
        (AuthMechs LOGIN)
        (Pipelinedepth 1)
        ,#~""
        (IMAPStore rec-gmail-remote)
        (Account rec-gmail)
        ,#~""
        (MaildirStore rec-gmail-local)
        (Subfolders Verbatim)
        (Path "~/mail/rec-gmail/")
        (Inbox "~/mail/rec-gmail/[Gmail]/Inbox")
        ,#~""
        (Channel rec-gmail)
        (Far :rec-gmail-remote:)
        (Near :rec-gmail-local:)
        (Patterns *)
        (Create Both)
        (SyncState *)
        ,#~""

        (IMAPAccount spam-gmail)
        (Host imap.gmail.com)
        (User ,(mail-username spam-mail))
        (Pass ,(mail-password spam-mail))
        (SSLType IMAPS)
        (AuthMechs LOGIN)
        (Pipelinedepth 1)
        ,#~""
        (IMAPStore spam-gmail-remote)
        (Account spam-gmail)
        ,#~""
        (MaildirStore spam-gmail-local)
        (Subfolders Verbatim)
        (Path "~/mail/spam-gmail/")
        (Inbox "~/mail/spam-gmail/[Gmail]/Inbox")
        ,#~""
        (Channel spam-gmail)
        (Far :spam-gmail-remote:)
        (Near :spam-gmail-local:)
        (Patterns *)
        (Create Both)
        (SyncState *)
        ,#~""
        ,#~"")
      )))))
