###############################################################################
#
#  VCS INFO
#
#  How to install:
#
#    1.Source this file in your .zshrc.
#      # e.g.
#      source ~/.zsh/zsh-vcs-prompt/zshrc.sh
#
#    2.Add the following in your .zshrc:
#      # e.g.
#      RPROMPT='$(vcs_super_info)'
#
###############################################################################

### Set default values.
#
#  If you want to customize the appearance of the prompt,
#  try to change the values in the following variables in your zshrc file.
#

## Use the python script (gitstatus-fast.py) by default.
ZSH_VCS_PROMPT_USING_PYTHON=${ZSH_VCS_PROMPT_USING_PYTHON:-'true'}

## Prompt formats.
#   %s : The VCS name (e.g. git svn hg).
#   %a : The action name.
#   %b : The current branch name.
#
#   %c : The ahead status.
#   %d : The behind status.
#
#   %e : The staged status.
#   %f : The conflicted status.
#   %g : The unstaged status.
#   %h : The untracked status.
#   %i : The stashed status.
#   %j : The clean status.
#
# Git.
ZSH_VCS_PROMPT_GIT_FORMATS=${ZSH_VCS_PROMPT_GIT_FORMATS:-'(%s)-[%b%c%d|%e%f%g%h%i%j]'}
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS=${ZSH_VCS_PROMPT_GIT_ACTION_FORMATS:-'(%s)-[%b:%a%c%d|%e%f%g%h%i%j]'}
# Other vcs.
ZSH_VCS_PROMPT_VCS_FORMATS=${ZSH_VCS_PROMPT_VCS_FORMATS:-'(%s)-[%b]'}
ZSH_VCS_PROMPT_VCS_ACTION_FORMATS=${ZSH_VCS_PROMPT_VCS_ACTION_FORMATS:-'(%s)-[%b:%a]'}

## The symbols.
ZSH_VCS_PROMPT_AHEAD_SIGIL=${ZSH_VCS_PROMPT_AHEAD_SIGIL:-'↑ '}
ZSH_VCS_PROMPT_BEHIND_SIGIL=${ZSH_VCS_PROMPT_BEHIND_SIGIL:-'↓ '}
ZSH_VCS_PROMPT_STAGED_SIGIL=${ZSH_VCS_PROMPT_STAGED_SIGIL:-'● '}
ZSH_VCS_PROMPT_CONFLICTS_SIGIL=${ZSH_VCS_PROMPT_CONFLICTS_SIGIL:-'✖ '}
ZSH_VCS_PROMPT_UNSTAGED_SIGIL=${ZSH_VCS_PROMPT_UNSTAGED_SIGIL:-'✚ '}
ZSH_VCS_PROMPT_UNTRACKED_SIGIL=${ZSH_VCS_PROMPT_UNTRACKED_SIGIL:-'… '}
ZSH_VCS_PROMPT_STASHED_SIGIL=${ZSH_VCS_PROMPT_STASHED_SIGIL:-'⚑'}
ZSH_VCS_PROMPT_CLEAN_SIGIL=${ZSH_VCS_PROMPT_CLEAN_SIGIL:-'✔ '}

## Color settings.
ZSH_VCS_PROMPT_VCS_NAME_COLOR=${ZSH_VCS_PROMPT_VCS_NAME_COLOR:-'%{%B%F{green}%}'}
ZSH_VCS_PROMPT_VCS_NAME_COLOR_USING_PYTHON=${ZSH_VCS_PROMPT_VCS_NAME_COLOR_USING_PYTHON:-'%{%F{yellow}%}'}
ZSH_VCS_PROMPT_BRANCH_COLOR=${ZSH_VCS_PROMPT_BRANCH_COLOR:-'%{%B%F{red}%}'}
ZSH_VCS_PROMPT_ACTION_COLOR=${ZSH_VCS_PROMPT_ACTION_COLOR:-'%{%B%F{red}%}'}
ZSH_VCS_PROMPT_AHEAD_COLOR=${ZSH_VCS_PROMPT_AHEAD_COLOR:-}
ZSH_VCS_PROMPT_BEHIND_COLOR=${ZSH_VCS_PROMPT_BEHIND_COLOR:-}
ZSH_VCS_PROMPT_STAGED_COLOR=${ZSH_VCS_PROMPT_STAGED_COLOR:-'%{%F{blue}%}'}
ZSH_VCS_PROMPT_CONFLICTS_COLOR=${ZSH_VCS_PROMPT_CONFLICTS_COLOR:-'%{%F{red}%}'}
ZSH_VCS_PROMPT_UNSTAGED_COLOR=${ZSH_VCS_PROMPT_UNSTAGED_COLOR:-'%{%F{yellow}%}'}
ZSH_VCS_PROMPT_UNTRACKED_COLOR=${ZSH_VCS_PROMPT_UNTRACKED_COLOR:-}
ZSH_VCS_PROMPT_STASHED_COLOR=${ZSH_VCS_PROMPT_STASHED_COLOR:-'%{%F{cyan}%}'}
ZSH_VCS_PROMPT_CLEAN_COLOR=${ZSH_VCS_PROMPT_CLEAN_COLOR:-'%{%F{green}%}'}


## The exe directory.
ZSH_VCS_PROMPT_DIR=$(cd $(dirname $0) && pwd)

## The VCS_INFO configurations.
#  http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#SEC273
#  https://github.com/olivierverdier/zsh-git-prompt
#  http://d.hatena.ne.jp/mollifier/20100906/p1
#  http://d.hatena.ne.jp/yuroyoro/20110219/1298089409
#  http://d.hatena.ne.jp/pasela/20110216/git_not_pushed
#  http://liosk.blog103.fc2.com/blog-entry-209.html
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg bzr

# Specify the command path to git used by VCS_INFO.
zstyle ':vcs_info:git:*:-all-' command =git

# The maximum number of vcs_info_msg_*_ variables.
zstyle ':vcs_info:*' max-exports 5

# To be enable check-for-changes with hg.
zstyle ':vcs_info:hg:*' get-revision true
zstyle ':vcs_info:(hg|bzr):*' use-simple true

## Set formats.
#
# Escape string.
# In normal formats and actionformats the following replacements are done:
#   %s : The VCS in use (git, hg, svn, etc.).
#   %b : Information about the current branch.
#   %a : An identifier that describes the action. Only makes sense in actionformats.
#   %r : The repository name. If %R is /foo/bar/repoXY, %r is repoXY.
#   %c : The string from the stagedstr style if there are staged changes in the repository.
#   %u : The string from the unstagedstr style if there are unstaged changes in the repository.
#
# Put the data into vcs_info_msg_*_ variables.
zstyle ':vcs_info:*' formats '%s' '%b'
zstyle ':vcs_info:*' actionformats '%s' '%b' '%a'

autoload -Uz is-at-least
if is-at-least 4.3.10; then
    # In the case of zsh version >= 4.3.10.
    zstyle ':vcs_info:(git|hg):*' check-for-changes true
fi


## The function called in PROMPT or RPROMPT.
function vcs_super_info() {
    # Parse raw data.
    local raw_data="$(vcs_super_info_raw_data)"
    if [ -z "$raw_data" ]; then
        return 0
    fi
    local -a vcs_status
    vcs_status=("${(f)raw_data}")

    local using_python=${vcs_status[1]}
    local vcs_name=${vcs_status[2]}
    local action=${vcs_status[3]}
    local branch=${vcs_status[4]}
    local ahead=${vcs_status[5]}
    local behind=${vcs_status[6]}
    local staged=${vcs_status[7]}
    local conflicts=${vcs_status[8]}
    local unstaged=${vcs_status[9]}
    local untracked=${vcs_status[10]}
    local stashed=${vcs_status[11]}
    local clean=${vcs_status[12]}

    # Select formats.
    local used_formats
    if [ "$vcs_name" = 'git' ]; then
        used_formats="$ZSH_VCS_PROMPT_GIT_ACTION_FORMATS"
        if [ -z "$action" -o "$action" = '0' ]; then
            used_formats="$ZSH_VCS_PROMPT_GIT_FORMATS"
        fi
    else
        used_formats="$ZSH_VCS_PROMPT_VCS_ACTION_FORMATS"
        if [ -z "$action" -o "$action" = '0' ]; then
            used_formats="$ZSH_VCS_PROMPT_VCS_FORMATS"
        fi
    fi

    # Escape slash '/'.
    branch=$(echo "$branch" | sed 's%/%\\/%')

    # Set color and sigil.
    local vcs_name_color=$ZSH_VCS_PROMPT_VCS_NAME_COLOR
    if [ "$using_python" = '1' ]; then
        vcs_name_color=$ZSH_VCS_PROMPT_VCS_NAME_COLOR_USING_PYTHON
    fi
    vcs_name=$(_zsh_vcs_prompt_set_color_and_sigil "$vcs_name" "$vcs_name_color")
    action=$(_zsh_vcs_prompt_set_color_and_sigil "$action" "$ZSH_VCS_PROMPT_ACTION_COLOR")
    branch=$(_zsh_vcs_prompt_set_color_and_sigil "$branch" "$ZSH_VCS_PROMPT_BRANCH_COLOR")
    ahead=$(_zsh_vcs_prompt_set_color_and_sigil "$ahead" "$ZSH_VCS_PROMPT_AHEAD_COLOR" "$ZSH_VCS_PROMPT_AHEAD_SIGIL")
    behind=$(_zsh_vcs_prompt_set_color_and_sigil "$behind" "$ZSH_VCS_PROMPT_BEHIND_COLOR" "$ZSH_VCS_PROMPT_BEHIND_SIGIL")
    staged=$(_zsh_vcs_prompt_set_color_and_sigil "$staged" "$ZSH_VCS_PROMPT_STAGED_COLOR" "$ZSH_VCS_PROMPT_STAGED_SIGIL")
    conflicts=$(_zsh_vcs_prompt_set_color_and_sigil "$conflicts" "$ZSH_VCS_PROMPT_CONFLICTS_COLOR" "$ZSH_VCS_PROMPT_CONFLICTS_SIGIL")
    unstaged=$(_zsh_vcs_prompt_set_color_and_sigil "$unstaged" "$ZSH_VCS_PROMPT_UNSTAGED_COLOR" "$ZSH_VCS_PROMPT_UNSTAGED_SIGIL")
    untracked=$(_zsh_vcs_prompt_set_color_and_sigil "$untracked" "$ZSH_VCS_PROMPT_UNTRACKED_COLOR" "$ZSH_VCS_PROMPT_UNTRACKED_SIGIL")
    stashed=$(_zsh_vcs_prompt_set_color_and_sigil "$stashed" "$ZSH_VCS_PROMPT_STASHED_COLOR" "$ZSH_VCS_PROMPT_STASHED_SIGIL")
    if [ "$clean" -eq 1 ]; then
        clean="$ZSH_VCS_PROMPT_CLEAN_COLOR$ZSH_VCS_PROMPT_CLEAN_SIGIL%{${reset_color}%}"
    else
        clean=''
    fi

    # Compose prompt status.
    echo "$used_formats" | sed -e "s/%s/$vcs_name/" \
        -e "s/%a/$action/" \
        -e "s/%b/$branch/" \
        -e "s/%c/$ahead/" \
        -e "s/%d/$behind/" \
        -e "s/%e/$staged/" \
        -e "s/%f/$conflicts/" \
        -e "s/%g/$unstaged/" \
        -e "s/%h/$untracked/" \
        -e "s/%i/$stashed/" \
        -e "s/%j/$clean/"
}

# Helper function.
function _zsh_vcs_prompt_set_color_and_sigil() {
    if [ -z "$1" -o "$1" = '0' ]; then
        return
    fi
    echo "$2$3$1%{${reset_color}%}"
}


## Get the raw data of vcs info.
#
# Output:
#   using_python : Using python flag. (Using python : 1, Not using python : 0)
#   vcs_name  : The vcs name string.
#   action    : Action name string. (No action : 0)
#   branch    : Branch name string.
#   ahead     : Ahead count. (No ahead : 0)
#   behind    : Behind count. (No behind : 0)
#   staged    : Staged count. (No staged : 0)
#   conflicts : Conflicts count. (No conflicts : 0)
#   unstaged  : Unstaged count. (No unstaged : 0)
#   untracked : Untracked count.(No untracked : 0)
#   stashed   : Stashed count.(No stashed : 0)
#   clean     : Clean flag. (Clean is 1, Not clean is 0)
#
function vcs_super_info_raw_data() {
    local using_python=0
    local vcs_name
    local vcs_branch_name
    local vcs_action=0
    local vcs_status

    # Use python
    if [ "$ZSH_VCS_PROMPT_USING_PYTHON" = 'true' ] \
        && type python > /dev/null 2>&1 \
        && type git > /dev/null 2>&1 \
        && [ "$(command git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then

        # Check python command.
        local cmd_gitstatus="${ZSH_VCS_PROMPT_DIR}/gitstatus-fast.py"
        if [ ! -f "$cmd_gitstatus" ]; then
            echo '[ zsh-vcs-prompt error: gitstatus-fast.py is not found ]'
            return 1
        fi

        # Get vcs status.
        vcs_status="$(python "$cmd_gitstatus" 2>/dev/null)"
        if [ -n "$vcs_status" ];then
            using_python=1
            vcs_name='git'
            # Output result.
            echo "$using_python\n$vcs_name\n$vcs_action\n$vcs_status"
            return 0
        fi
    fi

    # Don't use python.
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    if [ -z "$vcs_info_msg_0_" ]; then
        return 0
    fi

    vcs_name=$vcs_info_msg_0_
    vcs_branch_name=$vcs_info_msg_1_
    vcs_action=${vcs_info_msg_2_:-$vcs_action}
    if [ "$vcs_name" = 'git' ]; then
        vcs_status="$(_zsh_vcs_prompt_git_status)"
    fi

    # Output result.
    echo "$using_python\n$vcs_name\n$vcs_action\n$vcs_branch_name\n$vcs_status"

    return 0
}

function _zsh_vcs_prompt_git_status() {
    # Define variables for git status.
    local ahead=0
    local behind=0
    local staged=0
    local conflicts=0
    local unstaged=0
    local untracked=0
    local stashed=0
    local clean=0

    # Get changed files and stash list.
    local staged_files
    local unstaged_files
    local untracked_files
    local stash_list
    local is_inside_work_tree
    if [ "$(command git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
        is_inside_work_tree='true'
        staged_files="$(command git diff --staged --name-status)"
        unstaged_files="$(command git diff --name-status)"
        untracked_files="$(command git ls-files --others --exclude-standard)"
        stash_list="$(command git stash list)"
    fi

    # Count staged and conflicts files.
    if [ -n "$staged_files" ];then
        conflicts=$(echo "$staged_files" | sed '/^[^U]/d' | wc -l | sed 's/ //g')

        staged=$(echo "$staged_files" | wc -l | sed 's/ //g')
        staged=$(($staged - $conflicts))
    fi

    # Count unstaged files.
    if [ -n "$unstaged_files" ]; then
        unstaged=$(echo "$unstaged_files" | sed '/^U/d' | wc -l | sed 's/ //g')
    fi

    # Count untracked files.
    if [ -n "$untracked_files" ]; then
        untracked=$(echo "$untracked_files" | wc -l | sed 's/ //g')
    fi

    # Count commits not pushed.
    local tracking_branch=$(command git for-each-ref --format='%(upstream:short)' \
        "$(command git symbolic-ref -q HEAD)" 2> /dev/null)
    if [ -n "$tracking_branch" ]; then
        local -a behind_ahead
        behind_ahead=($(command git rev-list --left-right --count $tracking_branch...HEAD))
        behind=${behind_ahead[1]}
        ahead=${behind_ahead[2]}
    fi

    # Count stash.
    if [ -n "$stash_list" ]; then
        stashed=$(echo "$stash_list" | wc -l | sed 's/ //g')
    fi

    # Check clean.
    if [ "$is_inside_work_tree" = 'true' ]; then
        if (($staged + $unstaged + $untracked + $conflicts == 0)); then
            clean=1
        fi
    fi

    # Output result.
    echo "$ahead\n$behind\n$staged\n$conflicts\n$unstaged\n$untracked\n$stashed\n$clean"
}

# vim: ft=zsh
