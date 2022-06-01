(define-module (modules wm)
  #:use-module (srfi srfi-1)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu home-services wm)
  )

(define-public wm-packages
  (map specification->package
       `("kanshi"
         "rofi-wayland"
         "slurp"
         "waybar"
         "grim"
         "xorg-server-xwayland"
         "wl-clipboard"
         "xkill"
         "xset"
         "xdot"
         "qtwayland"
         "brightnessctl"
         "pamixer"
         "xmodmap"
         "setxkbmap")))

(define ws-bindings
  (map (lambda (ws)
         `(,(string->symbol (format #f "$mod+~d" (modulo ws 10)))
           workspace number ,ws))
       (iota 10 1)))

(define cantor-bindings
  (map (lambda (num)
         `(,(string->symbol (string-concatenate (list (format #f "$mod+Alt+~d " (modulo num 10)) (format #f "exec /home/main/dotfiles/home/scripts/ord.sh ~d | wl-copy" num ))))
           ))
       (iota 10 1)))

(define ws-move-bindings
  (map (lambda (ws)
         `(,(string->symbol (format #f "$mod+Shift+~d" (modulo ws 10)))
           move container to workspace number ,ws))
       (iota 10 1)))

(define-public wm-service
  (list
   (service
    home-sway-service-type
    (home-sway-configuration
     (config `(
               (set $mod Mod4)
               (set $left h)
               (set $down j)
               (set $up k)
               (set $right l)
               (set $term foot)
               (set $menu "zsh -c 'rofi -show drun | xargs swaymsg exec --'")
               (mode resize (
                             (bindsym $left resize shrink width 10px)
                             (bindsym $down resize grow height 10px)
                             (bindsym $up resize shrink height 10px)
                             (bindsym $right resize grow width 10px)
                             (bindsym Escape mode default)
                             ))
               (bindsym --to-code (
                                   ($mod+Shift+Return exec $term)
                                   ($mod+Return exec "emacsclient -c -n -e \"(multi-vterm)\"")
                                   ($mod+o exec "emacsclient -c -n -e \"(switch-to-buffer nil)\"")
                                   ($mod+Shift+o exec "chromium --app=http://127.0.0.1:35901 --new-window")
                                   ($mod+b exec "emacsclient -c -n -e \"(buffer-menu)\"")
                                   ($mod+Shift+q kill)
                                   ($mod+d exec $menu)
                                   ($mod+Shift+c reload)
                                   ($mod+Shift+e exec swaynag -t warning -m "You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session." -b "Yes, exit sway" swaymsg exit)
                                   ($mod+$left focus left)
                                   ($mod+$down focus down)
                                   ($mod+$up focus up)
                                   ($mod+$right focus right)
                                   ($mod+Shift+$left move left)
                                   ($mod+Shift+$down move down)
                                   ($mod+Shift+$up move up)
                                   ($mod+Shift+$right move right)
                                   ($mod+g splith)
                                   ($mod+v splitv)
                                   ($mod+s layout stacking)
                                   ($mod+w layout tabbed)
                                   ($mod+e layout toggle split)
                                   ($mod+f fullscreen)
                                   ($mod+Shift+space floating toggle)
                                   ($mod+space focus mode_toggle)
                                   ($mod+r mode resize)
                                   ($mod+a focus parent)
                                   (XF86AudioRaiseVolume exec "pamixer -i 5")
                                   (XF86AudioLowerVolume exec "pamixer -d 5")
                                   (XF86AudioMute exec "pamixer -t")
                                   (XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle)
                                   (XF86MonBrightnessDown exec brightnessctl set 5%-)
                                   (XF86MonBrightnessUp exec brightnessctl set +5%)
                                   (XF86AudioPlay exec playerctl play-pause)
                                   (XF86AudioNext exec playerctl next)
                                   (XF86AudioPrev exec playerctl previous)
                                   (Print exec "grim -t png -g \"$(slurp -d)\" - | wl-copy")
                                   ($mod+Shift+minus move scratchpad)
                                   ($mod+minus scratchpad show)
                                   ,@ws-bindings
                                   ,@cantor-bindings
                                   ,@ws-move-bindings))
               (gaps inner 10)
               (gaps outer 0)
               (floating_modifier $mod normal)
               (output * bg /home/main/dotfiles/home/secrets/background.jpg fill)
               (default_border pixel 0)
               (client.focused "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7")
               (client.focused_inactive "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7")
               (client.unfocused "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7")
               (client.urgent "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7")
               (client.placeholder "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7")

               (input "type:keyboard"
                      ((xkb_options "caps:escape,compose:altgr")
                       (xkb_layout gb)
                       (repeat_delay 300)
                       (repeat_rate 40))
                      )
               ;; TODO: manage these configs through guix
               (exec waybar)
               (exec dunst)
               (exec kanshi)
               (exec udiskie)
               ))))))
