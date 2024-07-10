# Put your custom themes in this folder.
# Example:
#PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

######### Functions ########

function directory() {
	local directory="%1~"
  local icon=""
	echo "%B%F{yellow}$icon $directory%f%b"
}
prompt_segment() {
  local fg=${1}
	echo -n " %F{$fg} "
  
}
# Git: branch/detached head, dirty status
prompt_git() {
	(( $+commands[git] )) || return
	if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
		return
	fi
	local PL_BRANCH_CHAR
	() {
		local LC_ALL="" LC_CTYPE="en_US.UTF-8"
		PL_BRANCH_CHAR=$'\ue0a0'         # 
	}
	local ref dirty mode repo_path

	if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
		repo_path=$(git rev-parse --git-dir 2>/dev/null)
		dirty=$(parse_git_dirty)
		ref=$(git symbolic-ref HEAD 2> /dev/null) || \
			ref="◈ $(git describe --exact-match --tags HEAD 2> /dev/null)" || \
			ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
		if [[ -n $dirty ]]; then
			prompt_segment blue
		else
			prompt_segment red
		fi

		local ahead behind
		ahead=$(git log --oneline @{upstream}.. 2>/dev/null)
		behind=$(git log --oneline ..@{upstream} 2>/dev/null)
		if [[ -n "$ahead" ]] && [[ -n "$behind" ]]; then
			PL_BRANCH_CHAR=$'\u21c5'
		elif [[ -n "$ahead" ]]; then
			PL_BRANCH_CHAR=$'\u21b1'
		elif [[ -n "$behind" ]]; then
			PL_BRANCH_CHAR=$'\u21b0'
		fi

		if [[ -e "${repo_path}/BISECT_LOG" ]]; then
			mode=" <B>"
		elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
			mode=" >M<"
		elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
			mode=" >R>"
		fi

		setopt promptsubst
		autoload -Uz vcs_info

		zstyle ':vcs_info:*' enable git
		zstyle ':vcs_info:*' get-revision true
		zstyle ':vcs_info:*' check-for-changes true
		zstyle ':vcs_info:*' stagedstr '✚'
		zstyle ':vcs_info:*' unstagedstr '±'
		zstyle ':vcs_info:*' formats ' %u%c'
		zstyle ':vcs_info:*' actionformats ' %u%c'
		vcs_info
		echo -n "${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
	fi
}

function myUser(){
	echo "%B%F{green}%n%f%b"
}

function prompt_char() {
#  󰐊 ▶ ⮞ 
	local char='%B%F{white}󰐊%f%b'
	# if [ $(id -u) -eq 0 ] ; then
	# 	local char='  '
	# else
	# 	local char='  '
	# fi
	local p_true="%B%F{green}{%f%b$char%B%F{green}}%f%b"
	local p_false="%B%F{red}{%f%b$char%B%F{red}}%f%b"
	echo "%(?.$p_true.$p_false)"
}
############################

PROMPT='$(prompt_char) $(directory)$(prompt_git)%f '
#PROMPT='%B$(directory)$(git_prompt_info)%b '
