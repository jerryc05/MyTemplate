# Color! More color! But not all on MacOS!
[ "$(uname -s)" = "Linux" ] && alias ls='ls --color=auto' || alias ls='ls -G'
[ "$(uname -s)" = "Linux" ] && alias dir='dir --color=auto'
[ "$(uname -s)" = "Linux" ] && alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Prevent unintended file overwrite
alias cp="cp -i"

# Show 256 colors
alias show-256-colors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'

# valgrind
alias vg="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"

# git-delta w/ exit code
# install git-delta via one of these:
#   1) brew install git-delta
#   2) cargo install --git https://github.com/dandavison/delta.git
command -v delta >/dev/null && function xdelta {
  out__=$(delta --width $(tput cols) -ns $*) && echo $out__ && [ -z $out__ ]
}

# Fix button functionality for zsh
command -v bindkey >/dev/null && {
  bindkey  "^[[H"   beginning-of-line;
  bindkey  "^[[F"   end-of-line;
  bindkey  "^[[3~"  delete-char;
}

# Show hidden files in iFinder
[ "$(uname -s)" = "Darwin" ] && defaults write com.apple.finder AppleShowAllFiles YES

# More helpful tar/untar
command -v tar >/dev/null && function xtar {
  echo "XZ_OPT=-8 tar acvf $* \n"
        XZ_OPT=-8 tar acvf $*
} && function xuntar {
  echo "tar xvf $* \n"
        tar xvf $*
}