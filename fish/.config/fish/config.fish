set -g fish_greeting
set -g VISUAL nvim
set -g EDITOR nvim

if status is-interactive
    starship init fish | source
end

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

alias y="yay -Syu --noconfirm --editmenu=false && flatpak update -y"
alias z="zoxide"
alias ls="eza"

function last_history_item
    echo $history[1]
end

abbr -a !! --position anywhere --function last_history_item
abbr mkdir 'mkdir -p'
abbr v nvim
abbr gacp 'git add . && git commit && git push origin'

zoxide init fish | source

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
