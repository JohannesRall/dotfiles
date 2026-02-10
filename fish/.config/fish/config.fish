set -g fish_greeting
set -g VISUAL nvim
set -g EDITOR nvim

if status is-interactive
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

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
export PATH="$HOME/.local/bin:$PATH"

# opencode
fish_add_path /home/johannes/.opencode/bin

# pnpm
set -gx PNPM_HOME "/home/johannes/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
