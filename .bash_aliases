# -*- mode: sh; tab-width: 2; -*-

# One letter aliases.
alias c='clear'
alias e='emacs -nw'
alias h='history'
alias j='jobs'
alias k='kill'
alias m='make -k'
alias q='exit'

# Change directories.
alias cd..='cd ..'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Use colors.
alias cat='bat --color=auto --decorations=never --paging=never'
alias diff='diff --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias ls='ls --color=auto'

# ls aliases.
alias l1='ls -1'
alias la='ls -la'
alias lr='ls -lrt'
alias lR='ls -R'

# Emacs files.
alias rm~='find . -type f -name "*~" -exec rm -i {} \;'

# Misc.
alias path='echo -e ${PATH//:/"\n"}'
alias timestamp='date "+%s"'
alias clock='while true; do clear; date +"%r"; sleep 1; done'
alias year='cal -y'
alias calc='bc -l'
alias size='du -sh'

# HTTP calls.
alias myip='curl ipinfo.io/ip'
alias weather='curl wttr.in/paris?m1'

# Docker aliases.
alias dps='docker ps'

# Git aliases.
alias gl='git log --all --decorate --oneline --graph'

# Golang aliases.
alias gob='go build'
alias gor='go run'
alias got='go test'

# Containers aliases.
alias shellcheck='docker run --rm -v "${PWD}:/src" -w /src koalaman/shellcheck'
alias conan='docker run --rm -v "${PWD}:/src" -w /src conanio/gcc7 conan'
alias erlang='docker run --rm -v "${PWD}:/src" -w /src erlang'
alias sqlpad='docker run -d --rm --name sqlpad -u "$(id -u):$(id -g)" -p 3000:3000 -v "${HOME}/.sqlpad:/db" -v "${HOME}/Documents:/Documents" -e SQLPAD_AUTH_DISABLED=true -e SQLPAD_AUTH_DISABLED_DEFAULT_ROLE=admin -e SQLPAD_DB_PATH=/db sqlpad/sqlpad'

# Typos.
alias eamcs=emacs
