#!/usr/bin/env zsh

# Colours
eval col_grey='$FG[240]'
eval col_orange='$FG[214]'
eval col_yellow='$FG[190]'
eval col_blue='$FG[075]'
eval col_pastel_blue='$FG[153]'
eval col_pastel_gold='$FG[143]'
eval col_pastel_brown='$FG[138]'
eval col_gold='$FG[100]'
eval col_forest='$FG[101]'
eval col_green='$FG[034]'

local col_path='${col_forest}'
local col_ip='${col_pastel_brown}'
local col_git='${col_pastel_blue}'

# Define prompts
local current_dir='%~%'
local cur_ip="[`ifconfig | grep 'inet'| grep -Ev '(127.0.0.1|inet6)' | head -1 | awk '{print $2}'`]"
local time="`date  +"%d-%b-%y %T"`"
local user_host='%n@%m'

PROMPT="%(?.${col_main}.%F{red})❯%f " # Display a red prompt char on failure

# Output additional information about paths, repos and user
precmd() {
    print -P "\n%{$terminfo[bold]%{${col_path}%}[${user_host}:${current_dir} ]%{$reset_color%} $terminfo[bold] %{${col_ip}%}${cur_ip}%{$reset_color%}  $(kube_ps1)  %{${col_git}%}$(git_prompt_info)$(git_prompt_status)$(git_prompt_ahead)"
}


# GIT status
ZSH_THEME_GIT_PROMPT_PREFIX="   "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ☂"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ☀"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ⚡"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ♒"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%} 𝝙"
