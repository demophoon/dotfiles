{ config, pkgs, ... }:

{
  home.file.".config/asciinema/config".source = pkgs.writeText "config" ''
[api]

; API server URL, default: https://asciinema.org
; If you run your own instance of asciinema server then set its address here
; It can also be overriden by setting ASCIINEMA_API_URL environment variable
url = https://term.brittg.com

[record]
; Limit recorded terminal inactivity to max n seconds, default: off
idle_time_limit = 1

; Define hotkey for pausing recording (suspending capture of output),
; default: C-\ (control + backslash)
pause_key = C-p

; Define hotkey for adding a marker, default: none
add_marker_key = C-x

; Define hotkey prefix key - when defined other recording hotkeys must
; be preceeded by it, default: no prefix
prefix_key = C-a
'';
}
