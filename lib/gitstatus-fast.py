#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import os
import shlex
import sys

from subprocess import Popen, PIPE, \
    check_call, CalledProcessError

# The name of environmental variable
# for branch name on which count unmerged commits count.
ENV_MERGE_BRANCH = 'ZSH_VCS_PROMPT_MERGE_BRANCH'

# Git error messages.
ERR_MSG_NO_BRANCH = 'fatal: ref HEAD is not a symbolic ref'
ERR_MSG_UNKNOWN_OPTION_SHORT = "error: unknown option `short'"


def run_cmd(cmd, ignore_error=False, exargs=None):
    cmd = shlex.split(cmd)
    if exargs:
        cmd.extend(exargs)
    p = Popen(cmd, stdout=PIPE, stderr=PIPE)
    out, error = p.communicate()

    if not ignore_error:
        check_error(error, p.returncode)
    if out:
        if isinstance(out, bytes):
            out = out.decode('utf-8')
        return str(out.encode('utf-8'))
    return ''


def check_error(error, returncode=1):
    if returncode == 0:
        return
    message = ''
    if error:
        if isinstance(error, bytes):
            error = error.decode('utf-8')
        message = str(error)
    else:
        message = 'Unknown error'
    message = 'Error(%d): %s' % (returncode, message)
    raise Exception(message)


def check_before_running():
    try:
        check_call('type git >/dev/null 2>&1', shell=True)
    except CalledProcessError as e:
        check_error('Git is not installed', e.returncode)

    output = run_cmd('git rev-parse --is-inside-work-tree')
    if output == 'false':
        check_error('Not inside git work tree')


def main():
    #check_before_running()

    # Git top directory.
    top_dir = run_cmd('git rev-parse --show-toplevel').strip()
    os.chdir(top_dir)

    # Current branch name.
    branch = ''
    try:
        # Old version git does not suppoert the option --short.
        branch = run_cmd('git symbolic-ref --short HEAD').strip()
    except Exception as e:
        if ERR_MSG_NO_BRANCH in str(e):
            # If not on any branch.
            return 1
        elif ERR_MSG_UNKNOWN_OPTION_SHORT in str(e):
            # If the option --short is unsupported.
            try:
                branch = run_cmd('git symbolic-ref HEAD').strip()[11:]
            except Exception as ex:
                if ERR_MSG_NO_BRANCH in str(ex):
                    # If not on any branch.
                    return 1
        else:
            raise

    # Count staged files.
    try:
        staged_files = run_cmd('git diff --staged --name-status').splitlines()
        staged_files = [namestat[0] for namestat in staged_files]
    except:
        staged_files = []
        git_status = run_cmd('git status --short --porcelain').splitlines()
        for namestat in git_status:
            if namestat[0] in ['U', 'M', 'A', 'D', 'R', 'C']:
                staged_files.append(namestat[0])

    # Count conflicts.
    conflicts = staged_files.count('U')
    if conflicts > 0:
        return 1
    staged = len(staged_files) - conflicts

    # Count unstaged files.
    unstaged_files = run_cmd('git diff --name-status')
    unstaged_files = [namestat[0] for namestat in unstaged_files.splitlines()]
    unstaged = len(unstaged_files) - unstaged_files.count('U')

    # Count untracked files.
    untracked_files = run_cmd('git ls-files --others --exclude-standard')
    untracked_files = untracked_files.splitlines()
    untracked = len(untracked_files)

    # Count stashed files.
    stash_list = run_cmd('git stash list')
    stashed = len(stash_list.splitlines())

    # Check if clean.
    if not unstaged and not staged and not conflicts and not untracked:
        clean = '1'
    else:
        clean = '0'

    # Count difference commits between the current branch and the remote branch.
    ahead = '0'
    behind = '0'
    head_branch = run_cmd('git symbolic-ref HEAD').strip()
    tracking_branch = run_cmd('git for-each-ref --format="%(upstream:short)" '
                              + head_branch, ignore_error=True).strip()
    if tracking_branch:
        try:
            behind_ahead = run_cmd('git rev-list --left-right --count %s...HEAD'
                                   % tracking_branch).split()
            behind = behind_ahead[0]
            ahead = behind_ahead[1]
        except:
            # If the option --count is unsupported.
            behind_ahead = run_cmd('git rev-list --left-right %s...HEAD'
                                   % tracking_branch).splitlines()
            ahead = len([x for x in behind_ahead if x[0] == '>'])
            behind = len(behind_ahead) - ahead

    # Count unmerged commits.
    unmerged = '0'
    merge_branch = ENV_MERGE_BRANCH in os.environ \
        and os.environ[ENV_MERGE_BRANCH]
    if merge_branch and not branch == merge_branch:
        unmerged_list = run_cmd('git rev-list %s..%s'
                                % (merge_branch, branch)).splitlines()
        unmerged = len(unmerged_list)

    # Result
    out = '\n'.join([
        branch,
        str(ahead),
        str(behind),
        str(staged),
        str(conflicts),
        str(unstaged),
        str(untracked),
        str(stashed),
        clean,
        str(unmerged)])
    print(out)


if __name__ == '__main__':
    sys.exit(main())
