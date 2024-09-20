set -g fish_greeting

if status is-interactive
    starship init fish | source
    fastfetch --config hypr
end

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'
abbr ytd 'yt-dlp -xo "$HOME/Music/%(title)s.%(ext)s" 
'
alias z="zoxide"
alias ls="eza"

function last_history_item
    echo $history[1]
end

abbr -a !! --position anywhere --function last_history_item
abbr mkdir 'mkdir -p'

zoxide init fish | source
