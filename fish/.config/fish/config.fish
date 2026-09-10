set -g fish_greeting
set -gx VISUAL nvim
set -gx EDITOR nvim

if not set -q STARSHIP_PALETTE
    set -gx STARSHIP_PALETTE catppuccin_mocha
end

function _set_starship_config_from_palette
    set -l config_source ~/.config/starship.toml
    set -l config_target ~/.cache/starship/generated.toml

    mkdir -p ~/.cache/starship
    string replace -r '^palette = ".*"$' "palette = \"$STARSHIP_PALETTE\"" <$config_source >$config_target
    set -gx STARSHIP_CONFIG $config_target
end

if status is-interactive
    _set_starship_config_from_palette
    starship init fish | source
    zoxide init fish | source
end

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

alias update="yay -Syu --noconfirm --editmenu=false && flatpak update -y"
alias ls="eza"

function last_history_item
    echo $history[1]
end

abbr -a !! --position anywhere --function last_history_item
abbr mkdir 'mkdir -p'
abbr v nvim

function sshf
    # Gather all ssh config files
    set config_files ~/.ssh/config (ls ~/.ssh/config.d 2>/dev/null | sed 's|^|~/.ssh/config.d/|')

    # Let user pick a host with fzf
    set host (grep "^Host " $config_files | awk '{print $2}' | sort -u | fzf)

    if test -n "$host"
        ssh $host
    end
end

function ytd
    if test -f $argv[1]
        set urls (cat $argv[1])
    else
        set urls $argv
    end

    for url in $urls
        set filename (yt-dlp --get-filename -o "$HOME/Music/%(title)s.%(ext)s" $url)

        if test -e $filename
            echo "Already downloaded: (basename $filename)"
        else
            echo "Downloading: $url"
            yt-dlp -xo "$HOME/Music/%(title)s.%(ext)s" $url
        end
    end
end
function generate_zellij_config
    set theme_file ~/.config/zellij/config.kdl

    if test $THEME = light
        set z_theme catppuccin-latte
    else if test $THEME = dark
        set z_theme catppuccin-mocha
    end

    # Write config safely in Fish
    echo "themes {" >$theme_file
    echo "  catppuccin-latte {" >>$theme_file
    echo "    bg \"#acb0be\"" >>$theme_file
    echo "    fg \"#4c4f69\"" >>$theme_file
    echo "    red \"#d20f39\"" >>$theme_file
    echo "    green \"#40a02b\"" >>$theme_file
    echo "    blue \"#1e66f5\"" >>$theme_file
    echo "    yellow \"#df8e1d\"" >>$theme_file
    echo "    magenta \"#ea76cb\"" >>$theme_file
    echo "    orange \"#fe640b\"" >>$theme_file
    echo "    cyan \"#04a5e5\"" >>$theme_file
    echo "    black \"#e6e9ef\"" >>$theme_file
    echo "    white \"#4c4f69\"" >>$theme_file
    echo "  }" >>$theme_file

    echo "  catppuccin-mocha {" >>$theme_file
    echo "    bg \"#585b70\"" >>$theme_file
    echo "    fg \"#cdd6f4\"" >>$theme_file
    echo "    red \"#f38ba8\"" >>$theme_file
    echo "    green \"#a6e3a1\"" >>$theme_file
    echo "    blue \"#89b4fa\"" >>$theme_file
    echo "    yellow \"#f9e2af\"" >>$theme_file
    echo "    magenta \"#f5c2e7\"" >>$theme_file
    echo "    orange \"#fab387\"" >>$theme_file
    echo "    cyan \"#89dceb\"" >>$theme_file
    echo "    black \"#181825\"" >>$theme_file
    echo "    white \"#cdd6f4\"" >>$theme_file
    echo "  }" >>$theme_file

    echo "}" >>$theme_file

    # Set the theme
    echo "theme \"$z_theme\"" >>$theme_file
end

function theme_switch
    if test (count $argv) -ne 1
        echo "Usage: theme_switch [light|dark]"
        return 1
    end

    switch $argv[1]
        case light
            set -gx THEME light
            set -gx STARSHIP_PALETTE catppuccin_latte
            set -gx NVIM_THEME catppuccin-latte
        case dark
            set -gx THEME dark
            set -gx STARSHIP_PALETTE catppuccin_mocha
            set -gx NVIM_THEME catppuccin-mocha
        case '*'
            echo "Unknown theme. Use 'light' or 'dark'."
            return 1
    end

    _set_starship_config_from_palette

    # Generate Zellij config dynamically
    generate_zellij_config

    # Reload Fish to refresh Starship immediately
    exec fish
end
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# opencode
fish_add_path /home/johannes/.opencode/bin

# pnpm
set -gx PNPM_HOME "/home/johannes/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

function nvm
    bass source $HOME/.nvm/nvm.sh --no-use ';' nvm $argv
end

# opencode
fish_add_path /home/johannes/.opencode/bin
export PATH="$HOME/.local/bin:$PATH"
