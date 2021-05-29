#!/usr/bin/env bash

# Mirage for Bash-it
# by Robin Pfeiffer
#
# Based on Brainy Bash by MunifTanjim

# Segment parsing

_____mirage_parse() {
    # printf "%s" "${info}"
    # OR
    # printf "%s|%s|%s" "${info}" "${box_color}" "box_name:[|]"
	ifs_old="${IFS}"
	IFS="|"
	read -r -a args <<< "$@"
	IFS="${ifs_old}"
    # Print box start if specified.
	if [ -n "${args[2]}" ]; then
		_LINE+="${args[1]}${args[2]}${reset}"
	fi
    # Print info
	_LINE+="${args[0]}"
    # Print box end 
	if [ -n "${args[3]}" ]; then
		_LINE+="${args[1]}${args[3]}${reset}"
	fi
	_LINE+=" "
}

____mirage() {
    _LINE=""

	for seg in ${___MIRAGE}; do
		info="$(___mirage_prompt_"${seg}")"
		[ -n "${info}" ] && _____mirage_parse "${info}"
	done

	printf "%s" "${_LINE}"
}

# Subsegments

___mirage_prompt_sub_venv_python() {
    info="$(virtualenv_prompt)"
    printf "%s" "${info}"
}

# Segments

___mirage_prompt_venv() {
    _LINE=""
    [ "${THEME_SHOW_VENV}" != true ] && return
    for seg in ${___MIRAGE_VENV}; do
        info="$(___mirage_prompt_sub_venv_"${seg}")"
		[ -n "${info}" ] && _____mirage_parse "${info}"
    done
    [ -z "${_LINE}" ] && return
    
    printf "%s|%s|%s" "${_LINE::${#_LINE}-1}" "${bold_white}" "venv:(|)"
}

___mirage_prompt_scm() {
    [ "${THEME_SHOW_SCM}" != true ] && return
    info="$(scm_prompt_info)"
    printf "%s" "${info}"
}

___mirage_prompt_user_info() {
    color=$bold_blue
    # Shows if sudo has a timestamp file (sudo has been used within 
    # this session and is still valid)
    # activate: sudo su
    # reset: sudo -k
    if [ "${THEME_SHOW_SUDO}" == true ]; then
        if sudo -vn 1> /dev/null 2>&1; then
            color=$bold_red
        fi
    fi

    info="${color}\u${reset}"
    printf "%s" "${info}"
}

___mirage_prompt_host_info() {
    info="on $bold_purple\h$reset"
    printf "%s" "${info}"
}

___mirage_prompt_dir() {
    info="in ${bold_cyan}\W${reset}"
    printf "%s" "${info}"
}

___mirage_prompt_exitcode() {
    color=$bold_green
    if [ "${THEME_SHOW_EXITCODE}" == true ]; then
        if [ "$exitcode" -ne 0 ]; then
            color=$bold_red
        fi
    fi

    info="${color}❯${reset}"
    printf "%s" "${info}"
}

# CLI

__mirage_show() {
	typeset _seg=${1:-}
	shift
	export "THEME_SHOW_${_seg}"=true
}

__mirage_hide() {
	typeset _seg=${1:-}
	shift
	export "THEME_SHOW_${_seg}"=false
}

_mirage_completion() {
    local cur _action actions segments
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    _action="${COMP_WORDS[1]}"
    actions="show hide"
    segments="exitcode sudo scm venv"
    case "${_action}" in
        show | hide)
            mapfile -t COMPREPLY <<< "$(compgen -W "${segments}" -- "${cur}")"
            return 0
            ;;
    esac

    mapfile -t COMPREPLY <<< "$(compgen -W "${actions}" -- "${cur}")"
    return 0
}

mirage() {
    typeset action=${1:-}
    shift
    typeset segs=${*:-}
    typeset func
    case $action in
        show)
            func=__mirage_show
            ;;
        hide)
            func=__mirage_hide
            ;;
    esac
    for seg in ${segs}; do
        seg=$(printf "%s" "${seg}" | tr '[:lower:]' '[:upper:]')
        $func "${seg}"
    done
}

complete -F _mirage_completion mirage

# Variables

reset="${reset_color}${normal}"

export VIRTUALENV_THEME_PROMPT_PREFIX=""
export VIRTUALENV_THEME_PROMPT_SUFFIX=""

export SCM_THEME_PROMPT_DIRTY=" ${bold_yellow}±${reset}"
export SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${reset}"
export SCM_THEME_PROMPT_PREFIX="${bold_blue}scm:(${reset}"
export SCM_THEME_PROMPT_SUFFIX="${bold_blue})${reset}"

export GIT_THEME_PROMPT_DIRTY=" ${bold_yellow}±${reset}"
export GIT_THEME_PROMPT_CLEAN=" ${bold_green}✓${reset}"
export GIT_THEME_PROMPT_PREFIX="${bold_blue}git:(${reset}"
export GIT_THEME_PROMPT_SUFFIX="${bold_blue})${reset}"

THEME_SHOW_SUDO=${THEME_SHOW_SUDO:-true}
THEME_SHOW_EXITCODE=${THEME_SHOW_EXITCODE:-true}
THEME_SHOW_SCM=${THEME_SHOW_SCM:-true}
THEME_SHOW_VENV=${THEME_SHOW_VENV:-true}

___MIRAGE_VENV=${___MIRAGE_VENV:-"python"}

___MIRAGE=${___MIRAGE:-"exitcode user_info host_info dir scm venv"}

# Prompt

__mirage_ps1() {
    printf "%s" "$(____mirage)"
}

_mirage_prompt() {
    exitcode="$?"

    PS1="$(__mirage_ps1)"
}

safe_append_prompt_command _mirage_prompt
