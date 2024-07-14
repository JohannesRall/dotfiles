set -g fish_greeting

if status is-interactive
    starship init fish | source
end

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'
abbr ytd 'yt-dlp -xo "$HOME/Music/%(title)s.%(ext)s"'
abbr z zoxide
abbr g git

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

zoxide init fish | source
