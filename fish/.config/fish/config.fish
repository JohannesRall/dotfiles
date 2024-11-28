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
abbr ytd 'yt-dlp -xo "$HOME/Music/%(title)s.%(ext)s" 
'
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
