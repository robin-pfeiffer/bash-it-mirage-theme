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

# Segments

___mirage_prompt_venv() {
    ("$THEME_SHOW_VENV") &&
        [[ -n "$VIRTUAL_ENV" ]] &&
        build_segment "${white}venv:(${reset}$(basename "$VIRTUAL_ENV")${white})$reset"
}

___mirage_prompt_scm() {
    ("$THEME_SHOW_SCM") &&
        build_segment "$(scm_prompt_info)"
}

___mirage_prompt_user_info() {
    local color=$blue

    # Shows if sudo has a timestamp file (sudo has been used within 
    # this session and is still valid)
    # activate: sudo su
    # reset: sudo -k
    ("$THEME_SHOW_SUDO") &&
        sudo -vn 1> /dev/null 2>&1 &&
        color=$red

    build_segment "${color}\u${reset}"
}

___mirage_prompt_host_info() {
    build_segment "at ${purple}\h${reset}"
}

___mirage_prompt_dir() {
    build_segment "in ${cyan}\W${reset}"
}

___mirage_prompt_exitcode() {
    local color=$green

    ("$THEME_SHOW_EXITCODE") && 
        [[ "$exitcode" -ne 0 ]] && 
        color=$red

    build_segment "${color}❯${reset}"
}

# Variables

reset="${reset_color}${normal}"

# Version control

export SCM_THEME_PROMPT_DIRTY=" ${yellow}±${reset}"
export SCM_THEME_PROMPT_CLEAN=" ${green}✓${reset}"
export SCM_THEME_PROMPT_PREFIX="on ${blue}"
export SCM_THEME_PROMPT_SUFFIX="${reset}"

export SCM_GIT_SHOW_MINIMAL_INFO=true

THEME_SHOW_SUDO=${THEME_SHOW_SUDO:-true}
THEME_SHOW_EXITCODE=${THEME_SHOW_EXITCODE:-true}
THEME_SHOW_SCM=${THEME_SHOW_SCM:-true}
THEME_SHOW_VENV=${THEME_SHOW_VENV:-true}

___MIRAGE=${___MIRAGE:-"exitcode user_info host_info dir scm venv"}

# Prompt

___mirage() {
    ___mirage_prompt_reset

    for seg in ${___MIRAGE}; do
        ___mirage_prompt_"$seg"
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
