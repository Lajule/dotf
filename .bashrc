eval "$(mise activate bash)"
eval "$(starship init bash --print-full-init)"
eval "$(zoxide init bash)"
eval "$(try init ~/Work/tries)"

export EDITOR='emacs -nw'
export BAT_THEME='ansi'
export MANPAGER='bat -plman'

alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias eff='${EDITOR} $(fzf -m)'
alias cd='zd'
alias bat='batcat'
alias cat='bat --paging=never'
alias fd='fdfind'
alias rm~='fd -H '.*~' -tf -X rm -i'
alias timestamp='date "+%s"'
alias size='du -sh'

e() { if (( $# == 0 )); then emacs -nw . ; else emacs -nw "$@"; fi; }
chall() { chgrp "$@" && chown "$@"; }
uuid() { cat /proc/sys/kernel/random/uuid; }
www() { (cd "${2:-${PWD}}" && python -m 'http.server' "${1:-8080}"); }

convert2() {
	local script

	while [[ "$1" = -* ]]; do
		case "$1" in
			-u | --unix) script='s/\r//' ;;
			-d | --dos) script='s/$/\r/' ;;
			*) echo 'Unknown format' >&2; return 1 ;;
		esac
		shift
	done

	if [[ -z "${script}" ]]; then
		script='s/\r//'
	fi

	if (( $# == 0 )); then
		sed "${script}"
	else
		sed -i "${script}" "$@"
	fi
}

crpt() {
	local rm

	declare -a options
	options+=('aes-256-cbc')

	while [[ "$1" = -* ]]; do
		case "$1" in
			-r | --rm) rm='yes' ;;
			-d | --decrypt) options+=('-d') ;;
			*) echo 'Unknown option' >&2; return 1 ;;
		esac
		shift
	done

	if (( $# < 2 )); then
		echo 'Missing arguments' >&2
		return 1
	fi

	if [[ "$1" == "$2" ]]; then
		echo 'Source and destination file names are the same' >&2
		return 1
	fi

	options+=('-salt')
	options+=('-pbkdf2')
	options+=('-in')
	options+=("$1")
	options+=('-out')
	options+=("$2")

	if [[ -n "${CRPT_PASSWORD}" ]]; then
		options+=('-pass')
		options+=('env:CRPT_PASSWORD')
	fi

	if openssl "${options[@]}" && [[ -n "${rm}" ]]; then
		rm -f "$1"
	fi
}

dice() {
	[[ "$1" =~ ([0-9]+)d([0-9]+)((\+|-)([0-9]+|-[0-9]+))? ]]
	if (( ${#BASH_REMATCH[@]} >= 3 )); then
 		local -i random
		random=$(( 1 + RANDOM % BASH_REMATCH[2] ))
		local -i result
		result=$(( BASH_REMATCH[1] * random ))

		if (( ${#BASH_REMATCH[@]} == 6 )); then
			case "${BASH_REMATCH[4]}" in
				+) (( result += BASH_REMATCH[5] )) ;;
				-) (( result -= BASH_REMATCH[5] )) ;;
			esac
		fi

		echo "${result}"
	else
		echo 'Invalid dice' >&2
		return 1
	fi
}

dl3() {
	if (( $# < 4 )); then
		echo 'Missing arguments' >&2
		return 1
	fi

	local utc
	utc="$(date -R --utc)"

	local password
	password="$(printf "GET\n\n\n%s\n/%s" "${utc}" "$2" | openssl sha1 -hmac "$4" -binary | base64)"

	curl -o "${2##*/}" -H "Host:$1" -H "Date:${utc}" -H "Authorization:AWS $3:${password}" "$1/$2"
}

extract() {
	local archive
	archive="${1:-tarball.tar.gz}"
	case "${archive}" in
		*.tar.bz2 | *.tbz2) tar xjf "${archive}" ;;
		*.tar.gz | *.tgz) tar xzf "${archive}" ;;
		*.tar.Z) tar xZf "${archive}" ;;
		*.bz2) bunzip2 "${archive}" ;;
		*.gz) gunzip "${archive}" ;;
		*.Z) uncompress "${archive}" ;;
		*.zip) unzip "${archive}" ;;
		*.rar) unrar x "${archive}" ;;
		*.7z) 7z x "${archive}" ;;
		*.tar) tar xf "${archive}" ;;
 		*) echo 'Unknown extension' >&2; return 1 ;;
	esac
}

tabs() {
	local script

	local spaces
	spaces='    '

	while [[ "$1" = -* ]]; do
		case "$1" in
			-2) spaces='  ' ;;
			-4) spaces='    ' ;;
			-t) script="s/${spaces}/\t/" ;;
			-s) script="s/\t/${spaces}/" ;;
			*) echo 'Unknown format' >&2; return 1 ;;
		esac
		shift
	done

	if [[ -z "${script}" ]]; then
		script="s/${spaces}/\t/"
	fi

	if (( $# == 0 )); then
		sed "${script}"
	else
		sed -i "${script}" "$@"
	fi
}
