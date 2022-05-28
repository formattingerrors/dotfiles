(setq
 gc-cons-threshold most-positive-fixnum
 package-enable-at-startup nil)

(add-hook 'after-init-hook
          #'(lambda () (setq gc-cons-threshold (* 8 1024 1024))))

(setq package-native-compile t)
(setq native-comp-eln-load-path
      (list (expand-file-name "eln-cache" user-emacs-directory)))
(setq load-prefer-newer t)
