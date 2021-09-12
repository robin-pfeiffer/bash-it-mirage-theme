#!/usr/bin/env bash

# Mirage for Bash-it
# by Robin Pfeiffer

build_segment() {
    local segment

    [ -n "$1" ] && segment="$1 " || segment=""

    echo -n "$segment"
}

___mirage_prompt_reset() {
    echo -n "$reset"
}

# Subsegments

___mirage_prompt_sub_venv_python() {
    info="$(virtualenv_prompt)"
    build_segment "${info}"
}

# Segments

___mirage_prompt_venv() {
    _LINE=""
    [ "${THEME_SHOW_VENV}" != true ] && return
    for seg in ${___MIRAGE_VENV}; do
        info="$(___mirage_prompt_sub_venv_"${seg}")"
		[ -n "${info}" ] && _LINE+="${info}"
    done
    [ -z "${_LINE}" ] && return
    
    build_segment "${bold_white}venv:($reset${_LINE::${#_LINE}-1}$bold_white)$reset"
}

___mirage_prompt_scm() {
    [ "${THEME_SHOW_SCM}" != true ] && return
    info="$(scm_prompt_info)"
    build_segment "${info}"
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
    build_segment "${info}"
}

___mirage_prompt_host_info() {
    info="on $bold_purple\h$reset"
    build_segment "${info}"
}

___mirage_prompt_dir() {
    info="in ${bold_cyan}\W${reset}"
    build_segment "${info}"
}

___mirage_prompt_exitcode() {
    color=$bold_green
    if [ "${THEME_SHOW_EXITCODE}" == true ]; then
        if [ "$exitcode" -ne 0 ]; then
            color=$bold_red
        fi
    fi

    info="${color}❯${reset}"
    build_segment "${info}"
}

# Variables

reset="${reset_color}${normal}"

export VIRTUALENV_THEME_PROMPT_PREFIX=""
export VIRTUALENV_THEME_PROMPT_SUFFIX=""

# Default to git as scm
export SCM_THEME_PROMPT_DIRTY=" ${bold_yellow}±${reset}"
export SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${reset}"
export SCM_THEME_PROMPT_PREFIX="${bold_blue}git:(${reset}"
export SCM_THEME_PROMPT_SUFFIX="${bold_blue})${reset}"

export SCM_GIT_SHOW_MINIMAL_INFO=true

THEME_SHOW_SUDO=${THEME_SHOW_SUDO:-true}
THEME_SHOW_EXITCODE=${THEME_SHOW_EXITCODE:-true}
THEME_SHOW_SCM=${THEME_SHOW_SCM:-true}
THEME_SHOW_VENV=${THEME_SHOW_VENV:-true}

___MIRAGE_VENV=${___MIRAGE_VENV:-"python"}

___MIRAGE=${___MIRAGE:-"exitcode user_info host_info dir scm venv"}

# Prompt

___mirage() {
    ___mirage_prompt_reset

    for seg in ${___MIRAGE}; do
        ___mirage_prompt_$seg
    done

    ___mirage_prompt_reset
}

__mirage_ps1() {
    ___mirage
}

_mirage_prompt() {
    exitcode="$?"

    PS1="$(__mirage_ps1)"
}

safe_append_prompt_command _mirage_prompt
