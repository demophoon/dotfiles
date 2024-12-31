{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    baseIndex = 1;
    keyMode = "vi";
    aggressiveResize = true;

    extraConfig = ''
      set-option -g escape-time 50
      set-option -g status on
      set-option -g status-interval 2
      set-option -g status-justify "centre"
      set-option -g status-bg "colour27"
      set-option -g status-fg colour255

      setw -g monitor-activity off
      setw -g aggressive-resize on
      set-window-option -g window-status-current-format "  #I:#W  "

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind e setw synchronize-panes on
      bind E setw synchronize-panes off

      bind -r C-h resize-pane -L
      bind -r C-j resize-pane -D
      bind -r C-k resize-pane -U
      bind -r C-l resize-pane -R

      set-option -g display-time 500
      set-option -g repeat-time 200

      set -g mouse off

      set-option -g status-keys vi
      unbind [
      #bind Escape copy-mode
      unbind p
      bind-key p paste-buffer
      bind-key v copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      bind-key -T copy-mode-vi V send-keys -X rectangle-toggle
      bind-key ] paste-buffer
      bind-key [ copy-mode

      set-option -g bell-action any
      set-option -g set-titles on
      set-option -g set-titles-string '#H:#S.#I.#P #W #T' # window number,program name,active (or not)
      set-option -g visual-bell on
      set-option -g escape-time 0
    '';

    plugins = [
      pkgs.tmuxPlugins.sensible
    ];
  };
}
