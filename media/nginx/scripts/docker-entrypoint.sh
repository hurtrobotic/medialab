#!/bin/sh -eu

###
### Variables
###
DEBUG_COMMANDS=0

###
### Functions
###
run() {
	_cmd="${1}"
	_debug="0"

	_red="\033[0;31m"
	_green="\033[0;32m"
	_reset="\033[0m"
	_user="$(whoami)"


	# If 2nd argument is set and enabled, allow debug command
	if [ "${#}" = "2" ]; then
		if [ "${2}" = "1" ]; then
			_debug="1"
		fi
	fi


	if [ "${DEBUG_COMMANDS}" = "1" ] || [ "${_debug}" = "1" ]; then
		printf "${_red}%s \$ ${_green}${_cmd}${_reset}\n" "${_user}"
	fi
	sh -c "LANG=C LC_ALL=C ${_cmd}"
}

print_headline() {
	_txt="${1}"
	_blue="\033[0;34m"
	_reset="\033[0m"

	printf "${_blue}\n%s\n${_reset}" "--------------------------------------------------------------------------------"
	printf "${_blue}- %s\n${_reset}" "${_txt}"
	printf "${_blue}%s\n\n${_reset}" "--------------------------------------------------------------------------------"
}

log() {
	_lvl="${1}"
	_msg="${2}"

	_clr_ok="\033[0;32m"
	_clr_info="\033[0;34m"
	_clr_warn="\033[0;33m"
	_clr_err="\033[0;31m"
	_clr_rst="\033[0m"

	if [ "${_lvl}" = "ok" ]; then
		printf "${_clr_ok}[OK]   %s${_clr_rst}\n" "${_msg}"
	elif [ "${_lvl}" = "info" ]; then
		printf "${_clr_info}[INFO] %s${_clr_rst}\n" "${_msg}"
	elif [ "${_lvl}" = "warn" ]; then
		printf "${_clr_warn}[WARN] %s${_clr_rst}\n" "${_msg}" 1>&2	# stdout -> stderr
	elif [ "${_lvl}" = "err" ]; then
		printf "${_clr_err}[ERR]  %s${_clr_rst}\n" "${_msg}" 1>&2	# stdout -> stderr
	else
		printf "${_clr_err}[???]  %s${_clr_rst}\n" "${_msg}" 1>&2	# stdout -> stderr
	fi
}

# Test if argument is an integer.
#
# @param  mixed
# @return integer	0: is int | 1: not an int
isint() {
	echo "${1}" | grep -Eq '^([0-9]|[1-9][0-9]*)$'
}

isip() {
	# IP is not in correct format
	if ! echo "${1}" | grep -Eq '^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$'; then
		return 1
	fi

	# Get each octet
	o1="$( echo "${1}" | awk -F'.' '{print $1}' )"
	o2="$( echo "${1}" | awk -F'.' '{print $2}' )"
	o3="$( echo "${1}" | awk -F'.' '{print $3}' )"
	o4="$( echo "${1}" | awk -F'.' '{print $4}' )"

	# Cannot start with 0 and all must be below 256
	if [ "${o1}" -lt "1" ] || \
		[ "${o1}" -gt "255" ] || \
		[ "${o2}" -gt "255" ] || \
		[ "${o3}" -gt "255" ] || \
		[ "${o4}" -gt "255" ]; then
		return 1
	fi

	# All tests passed
	return 0
}

ishostname() {
	# Does not have correct character class
	if ! echo "${1}" | grep -Eq '^[-.0-9a-zA-Z]+$'; then
		return 1
	fi

	# first and last character
	f_char="$( echo "${1}" | cut -c1-1 )"
	l_char="$( echo "${1}" | sed -e 's/.*\(.\)$/\1/' )"

	# Dot at beginning or end
	if [ "${f_char}" = "." ] || [ "${l_char}" = "." ]; then
		return 1
	fi
	# Dash at beginning or end
	if [ "${f_char}" = "-" ] || [ "${l_char}" = "-" ]; then
		return 1
	fi
	# Multiple dots next to each other
	if echo "${1}" | grep -Eq '[.]{2,}'; then
		return 1
	fi
	# Dash next to dot
	if echo "${1}" | grep -Eq '(\.-)|(-\.)'; then
		return 1
	fi

	# All tests passed
	return 0
}


################################################################################
# MAIN ENTRY POINT
################################################################################
log "info" "### Parameters passed to entrypoint : $@"
#run "[ -f /etc/nginx/nginx.conf ] && cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.ori";
#run "sed -e 's/{MY_HOST_NAME}/${MY_HOST_NAME}/g' /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf";

