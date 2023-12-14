# -*- mode: sh; tab-width: 2; -*-

# Source code url.
readonly BASH_FUNCTIONS_URL='https://gist.githubusercontent.com/Lajule/1839331f43eabb9d38e1933f337e96bc/raw/.bash_functions'

#######################################
# Display banner for scripts.
# Arguments:
#   Given script name.
#   Given template (optional).
# Outputs:
#   Writes banner to stdout.
#######################################
ban() {
	if (( $# == 0 )); then
		echo 'Missing argument' >&2
		return 1
	fi

	IFS=' ' read -r -a mem <<< "$(free -h --si 2>/dev/null | grep Mem)"

	local banner
	banner="${2:-"Name: @NAME@
Hostname: @HOSTNAME@
OS: @OS@
Cores: @CORES@
Memory: @MEM@
Time: @TIME@"}"
	banner="${banner//@NAME@/${1##*/}}"
	banner="${banner//@HOSTNAME@/$(hostname)}"
	banner="${banner//@OS@/$(uname -o)}"
	banner="${banner//@CORES@/$(grep -c processor /proc/cpuinfo)}"
	banner="${banner//@MEM@/${mem[6]}/${mem[1]}}"
	banner="${banner//@TIME@/$(date +'%Y-%m-%dT%H:%M:%S%z')}"
	echo "${banner}"
}

#######################################
# Execute a command in subdirectories.
# Globals:
#   PWD
# Arguments:
#   A command.
# Returns:
#   0 if command is executed successfully, non-zero on error.
#######################################
call() {
	while read -r dir; do
		(cd "${dir}" \
			&& echo "Entering in « ${dir} »" \
			&& "$@" \
			&& echo "Leaving « ${dir} »") || return $?
	done < <(find "${PWD}" -mindepth 1 -maxdepth 1 -type d)
}

#######################################
# Open code editor.
# Globals:
#   EDITOR
#   VISUAL
# Returns:
#   0 if editor is openned, non-zero on error.
#######################################
code() {
	if [[ "$1" = "-v" ]]; then
		shift
		${VISUAL} "${1:-.}" &
	else
		${EDITOR} "${1:-.}"
	fi
}

#######################################
# Convert a file to Unix or DOS format.
# Arguments:
#   Format option (default -u).
#   Given inupt files (optional).
# Returns:
#   0 if files are converted, non-zero on error.
#######################################
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

#######################################
# Create a random password.
# Arguments:
#   The password length (default 32).
# Outputs:
#   Writes password to stdout.
#######################################
create_password() {
	date '+%s' | shasum | base64 | head -c"${1:-32}"
}

#######################################
# Parse CSV lines.
# Arguments:
#   Given separator (default ,).
#   Given filter (optional).
# Returns:
#   0 if lines are parsed, non-zero on error.
#######################################
csv() {
	cut -d "${1:-,}" -f "${2:-1-}" | column -s "${1:-,}" -t
}

#######################################
# Roll a dice.
# Arguments:
#   Given dice (1d6+2).
# Outputs:
#   Writes result to stdout.
#######################################
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

#######################################
# Start Adminer database manager.
# Arguments:
#   Given port (default 8080).
#   Given container name (default dba).
#   Given container tag (default latest).
# Returns:
#   0 if container is started, non-zero on error.
#######################################
dba() {
	docker run -d --rm --name "${2:-dba}" -p "${1:-8080}:8080" "adminer:${3:-latest}"
}

#######################################
# Remove one or more images.
# Arguments:
#   Given query (optional).
# Returns:
#   0 if containers are removed, non-zero on error.
#######################################
drm() {
	local fmt
	fmt='{{.Repository}} {{.Tag}} {{.ID}} {{.Size}}'

	readarray -t images < <(docker images --format "${fmt}" \
		| column -t \
		| fzf -m ${1:+-1 -q "$1"})

	for image in "${images[@]}"; do
		IFS=' ' read -r -a columns <<< "${image}"
		docker image rm "${columns[2]}" || return 1
	done
}

#######################################
# Stop one or more containers.
# Arguments:
#   Containers to stop (optional).
# Returns:
#   0 if containers are stopped, non-zero on error.
#######################################
dstop() {
	if (( $# > 0 )); then
		docker stop "$@"
	else
		readarray -t names < <(docker ps --format '{{.Names}}')
		if (( ${#names[@]} > 0 )); then
			docker stop "${names[@]}"
		fi
	fi
}

#######################################
# Display a message on standard error.
# Arguments:
#   Messages to display.
# Outputs:
#   Writes message to stderr.
#######################################
err() {
	echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] : $*" >&2
}

#######################################
# Extract files from an archive.
# Arguments:
#   Archive file.
# Returns:
#   0 if files are extracted, non-zero on error.
#######################################
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

#######################################
# Change current directory.
# Globals:
#   FCDPATH
# Arguments:
#   Given query (optional).
# Returns:
#   0 if directory is changed, non-zero on error.
#######################################
fcd() {
	IFS=':' read -r -a dirs <<< "${FCDPATH}"
	cd "$(find "${dirs[@]}" -type d | fzf ${1:+-1 -q "$1"})" \
		|| return 1
}

#######################################
# Edit one or more files in Emacs (console).
# Arguments:
#   Given query (optional).
# Returns:
#   0 if files are edited, non-zero on error.
#######################################
fe() {
	readarray -t files < <(find . -type f | fzf -m ${1:+-1 -q "$1"})
	if (( ${#files[@]} > 0 )); then
		emacs -nw "${files[@]}"
	fi
}

#######################################
# Kill one process.
# Arguments:
#   Given query (optional).
# Returns:
#   0 if process is killed, non-zero on error.
#######################################
fk() {
	readarray -t processes < <(ps -efa --no-header \
		| fzf -m ${1:+-1 -q "$1"})

	for process in "${processes[@]}"; do
		IFS=' ' read -r -a columns <<< "${process}"
		kill -9 "${columns[1]}" || return 1
	done
}

#######################################
# Display log file.
# Arguments:
#   Grep options (optional).
#   Filename pattern (default *).
#   Grep pattern. (optional).
# Returns:
#   0 if log is displayed successfully, non-zero on error.
#######################################
log() {
	declare -a options
	options+=('--color=auto')

	while [[ "$1" = -* ]]; do
		options+=("$1")
		shift
	done

	readarray -t files < <(find . -maxdepth 1 -type f -name "${1:-*}")

	if (( $# == 1 )); then
		tail -f "${files[@]}"
	else
		tail -f "${files[@]}" | grep "${options[@]}" "$2"
	fi
}

#######################################
# Open or close a port with iptables.
# Arguments:
#   A iptables command (default status).
#   A port (default 8080).
# Returns:
#   0 if command is executed successfully, non-zero on error.
#######################################
port_ctrl() {
	case "${1:-status}" in
		o | open) iptables -A INPUT -p tcp --dport "${2:-8080}" -j ACCEPT ;;
		c | close) iptables -D INPUT -p tcp --dport "${2:-8080}" -j ACCEPT ;;
		s | status) iptables -L -v ;;
 		*) echo 'Unknown command' >&2; return 1 ;;
	esac
}

#######################################
# Set PS1 variable.
# Globals:
#   SHLVL
#   VIRTUAL_ENV
# Arguments:
#   Last command error code.
#######################################
prompt() {
	declare -a ps1

	if (( SHLVL > 1 )); then
		ps1+=(${SHLVL})
	fi

	if [[ -n "${VIRTUAL_ENV}" ]]; then
		ps1+=("${VIRTUAL_ENV##*/}")
	fi

	if (( $1 != 0 )); then
		ps1+=("$1")
	fi

	ps1+=('\[\e[1;34m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]')

	if git rev-parse --git-dir >&/dev/null; then
		ps1+=("$(git rev-parse --abbrev-ref HEAD)")
	fi

	ps1+=('\$')

	PS1="${ps1[*]} "
}

#######################################
# Send REST requests.
# Arguments:
#   Curl arguments.
# Outputs:
#   Formatted JSON object.
#######################################
req() {
	declare -a arguments
	arguments+=('-s')

	for arg in "$@"; do
		if [[ "${arg}" = :* || "${arg}" = /* ]]; then
			arguments+=("localhost${arg}")
		else
			arguments+=("${arg}")
		fi
	done

	local rep
	rep="$(curl "${arguments[@]}")"

	if [[ "${rep}" =~ ^(\{.*\}|\[.*\])$ ]]; then
		echo "${rep}" | jq
	else
		echo -n "${rep}"
	fi
}

#######################################
# Search a pattern in file recursively.
# Arguments:
#   Grep options (optional).
#   Grep pattern.
#   Filename pattern (default *).
#   Base directory (default .).
# Outputs:
#   Files that contains given pattern.
#######################################
rg() {
	declare -a options
	options+=('-H')
	options+=('--color=auto')

	while [[ "$1" = -* ]]; do
		options+=("$1")
		shift
	done

	if (( $# == 0 )); then
		echo 'Missing arguments' >&2
		return 1
	fi

	find "${3:-.}" -type f -name "${2:-*}" -exec grep "${options[@]}" "$1" {} \;
}

#######################################
# ROT13 encryption algorithm.
# Arguments:
#   Given string (optional).
# Outputs:
#   Ciphered string.
#######################################
rot13() {
	local from
	from='[a-m][n-z][A-M][N-Z]'
	local to
	to='[n-z][a-m][N-Z][A-M]'

	if (( $# == 0 )); then
		tr "${from}" "${to}"
	else
		echo -n "$*" | tr "${from}" "${to}"
	fi
}

#######################################
# Start ssh agent.
# Globals:
#   SSH_ENV
# Returns:
#   0 if agent is started successfully, non-zero on error.
#######################################
ssh_agent() {
	ssh-agent >"${SSH_ENV}" \
		&& chmod 600 "${SSH_ENV}" \
		&& . "${SSH_ENV}" \
		&& ssh-add
}

#######################################
# Change tabs to spaces or spaces to tabs.
# Arguments:
#   Format option (default -t).
#   Given inupt files (optional).
# Returns:
#   0 if files are converted, non-zero on error.
#######################################
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

#######################################
# Trim leading and trailing spaces.
# Outputs:
#   Trimmed string.
#######################################
trim() {
	local s

	s="$*"
	s="${s#"${s%%[![:space:]]*}"}"
	s="${s%"${s##*[![:space:]]}"}"

	echo -n "${s}"
}

#######################################
# Get an universal uniq identifier.
# Outputs:
#   Universal uniq identifier.
#######################################
uuid() {
	cat /proc/sys/kernel/random/uuid
}

#######################################
# Start virtualenv.
# Arguments:
#   Environment file (optional).
# Returns:
#   0 if env is activated successfully, non-zero on error.
#######################################
venv() {
	local dir

	if [[ -f 'Pipfile' ]]; then
		dir="$(pipenv --venv)"
	else
		dir="${1:-venv}"
	fi

	. "${dir}/bin/activate"
}

#######################################
# Start a web server.
# Arguments:
#   Given port (default 8080).
#   Given directory (default PWD).
# Returns:
#   0 if server has runned successfully, non-zero on error.
#######################################
www() {
	local port
	port="${1:-8080}"
	local dir
	dir="${2:-${PWD}}"

	if hash python >&/dev/null; then
		local module

		case "$(python --version 2>&1)" in
			Python\ 2.*) module='SimpleHTTPServer' ;;
			*) module='http.server' ;;
		esac

		(cd "${dir}" && python -m "${module}" "${port}")
	elif hash php >&/dev/null; then
		php -S "localhost:${port}" -t "${dir}"
	elif hash ruby >&/dev/null; then
		ruby -run -e httpd "${dir}" -p "${port}"
	elif hash erl >&/dev/null; then
		erl -noinput -s inets -eval "inets:start(httpd, [
	{port, ${port}},
	{server_name, \"httpd\"},
	{server_root, \"${dir}\"},
	{document_root, \"${dir}\"},
	{directory_index, [\"index.html\"]}
])."
	else
		echo 'No web server available' >&2
		return 1
	fi
}

# Private.
_check_for_update() {
	local script
	script="${1:-${HOME}/.bash_functions}"

	local patch
	if ! patch="$(diff "${script}" <(curl -s "${BASH_FUNCTIONS_URL}"))"; then
		while true; do
			read -r -p 'Apply changes (y/n)? ' answer
			case "${answer}" in
				y) patch "${script}" <(echo "${patch}"); return $? ;;
				n) echo 'Unapplied changes' >&2; return 1 ;;
			esac
		done
	else
		echo 'Up to date'
	fi
}
