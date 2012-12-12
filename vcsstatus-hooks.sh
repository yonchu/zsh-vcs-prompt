#!/usr/bin/env zsh
#
#  vcsstatus.sh
#
#    Output:
#      vcs_name  : The vcs name string.
#      action    : Action name string. (No action : 0)
#      branch    : Branch name string.
#      ahead     : Ahead count. (No ahead : 0)
#      behind    : Behind count. (No behind : 0)
#      staged    : Staged count. (No staged : 0)
#      conflicts : Conflicts count. (No conflicts : 0)
#      unstaged  : Unstaged count. (No unstaged : 0)
#      untracked : Untracked count.(No untracked : 0)
#      stashed   : Stashed count.(No stashed : 0)
#      clean     : Clean flag. (Clean is 1, Not clean is 0, Unknown is ?)
#

# Check zsh version.
autoload -Uz is-at-least || exit 1
if ! is-at-least 4.3.11; then
    echo 'Can not run this script because zsh vesion is old (< 4.3.11).' 1>&2
    exit 1
fi

## VCS_INFO configurations.
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
zstyle ':vcs_info:*' formats '%s' '%b' '%m'
zstyle ':vcs_info:*' actionformats '%s' '%b' '%m' '%a'

zstyle ':vcs_info:(git|hg):*' check-for-changes false

# Register the hook function.
zstyle ':vcs_info:git+set-message:*' hooks git-hook-detail-info


# The hook function.
# If return the value except 0, subsequent hook functions is not called.
function +vi-git-hook-detail-info() {
    # Execute only when vcs_info_msg_2_.
    if [ "$1" != '2' ]; then
        return 0
    fi
    local git_status="$(get_git_status)"
    hook_com[misc]+="$git_status"
    return 0
}

function vcs_detail_info() {
    local vcs_name
    local vcs_branch_name
    local vcs_action=0
    local git_status

    psvar=()
    LANG=en_US.UTF-8 vcs_info
    if [ -z "$vcs_info_msg_0_" ]; then
        return 0
    fi

    vcs_name=$vcs_info_msg_0_
    vcs_branch_name=$vcs_info_msg_1_
    git_status="$vcs_info_msg_2_"
    vcs_action=${vcs_info_msg_3_:-$vcs_action}

    # Output result.
    echo "$vcs_name\n$vcs_action\n$vcs_branch_name\n$git_status"

    return 0
}

function get_git_status() {
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

    if [ "$(command git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        is_inside_work_tree='true'
        staged_files="$(command git diff --staged --name-status)"
        unstaged_files="$(command git diff --name-status)"
        untracked_files="$(command git ls-files --others --exclude-standard)"
        stash_list="$(command git stash list)"
    else
        clean='?'
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

## Main
vcs_detail_info

# vim: ft=zsh

