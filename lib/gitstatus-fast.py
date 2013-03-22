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
ERRO_MSG_AMBIGUOUS_ARGUMENT = \
    "fatal: ambiguous argument '%s..%s': " \
    + "unknown revision or path not in the working tree."


class Cmd(object):
    def __init__(self, cmd, exargs=None, ignore_error=False):
        self.ignore_error = ignore_error
        cmd = shlex.split(cmd)
        if exargs:
            cmd.extend(exargs)
        self.cmd = cmd
        self.process = Popen(self.cmd, stdout=PIPE, stderr=PIPE)

    def get_result(self):
        out, error = self.process.communicate()
        if not self.ignore_error:
            self._check_error(error)
        if out:
            try:
                out = str(out, 'utf-8')
            except TypeError:
                pass
            return out
        return ''

    def _check_error(self, error):
        returncode = self.process.returncode
        if returncode == 0:
            return
        if error:
            try:
                error = str(error, 'utf-8')
            except TypeError:
                pass
        else:
            error = 'Unknown error'
        message = 'Error(%d): %s' % (returncode, error)
        raise Exception(message)


def check_before_running():
    try:
        check_call('type git >/dev/null 2>&1', shell=True)
    except CalledProcessError as e:
        info = sys.exc_info()
        raise Exception('Git is not installed (%s)\n%s: %s'
                        % (e.returncode, info[0].__name__, info[1]))

    output = Cmd('git rev-parse --is-inside-work-tree').get_result()
    if output == 'false':
        raise Exception('Not inside git work tree')


def main():
    #check_before_running()

    # Start proess to get full name of the current branch (like refs/heads/master).
    p_branch_ref = Cmd('git symbolic-ref HEAD')
    # Start process to get the git top directory.
    p_top_dir = Cmd('git rev-parse --show-toplevel')
    # Start proess to get the current branch name.
    p_branch = Cmd('git symbolic-ref --short HEAD')

    # Get full name of the current barnch (like refs/heads/master).
    try:
        branch_ref = p_branch_ref.get_result().strip()
    except Exception as e:
        if ERR_MSG_NO_BRANCH in str(e):
            # If not on any branch.
            return 1
        raise

    # Start proess to get the tracking branch.
    p_tracking_branch = Cmd('git for-each-ref --format="%%(upstream:short)" %s'
                            % branch_ref, ignore_error=True)

    # Get merge branch from environmental variable.
    merge_branch = ENV_MERGE_BRANCH in os.environ \
        and os.environ[ENV_MERGE_BRANCH]

    # Change directory to git top.
    os.chdir(p_top_dir.get_result().strip())

    # Get the current branch name.
    branch = ''
    try:
        # Old version git does not suppoert the option --short.
        branch = p_branch.get_result().strip()
    except Exception as e:
        if ERR_MSG_NO_BRANCH in str(e):
            # If not on any branch.
            return 1
        elif ERR_MSG_UNKNOWN_OPTION_SHORT in str(e):
            branch = branch_ref[11:]
        else:
            raise

    # Get the tracking branch.
    tracking_branch = p_tracking_branch.get_result().strip()

    # Start processes.
    p_staged_files = Cmd('git diff --staged --name-status')
    p_unstaged_files = Cmd('git diff --name-status')
    p_untracked_files = Cmd('git ls-files --others --exclude-standard')
    p_stash_list = Cmd('git stash list')

    p_unmerged_list = None
    if merge_branch and not branch == merge_branch:
        p_unmerged_list = Cmd('git rev-list %s..%s' % (merge_branch, branch))

    p_behind_ahead = None
    if tracking_branch:
        p_behind_ahead = Cmd('git rev-list --left-right --count %s...HEAD'
                             % tracking_branch)

    # Count staged files.
    try:
        staged_files = p_staged_files.get_result().splitlines()
        staged_files = [namestat[0] for namestat in staged_files]
    except:
        staged_files = []
        git_status = Cmd('git status --short --porcelain').get_result().splitlines()
        for namestat in git_status:
            if namestat[0] in ['U', 'M', 'A', 'D', 'R', 'C']:
                staged_files.append(namestat[0])

    # Count conflicts.
    conflicts = staged_files.count('U')
    if conflicts > 0:
        return 1
    staged = len(staged_files) - conflicts

    # Count unstaged files.
    unstaged_files = p_unstaged_files.get_result()
    unstaged_files = [namestat[0] for namestat in unstaged_files.splitlines()]
    unstaged = len(unstaged_files) - unstaged_files.count('U')

    # Count untracked files.
    untracked_files = p_untracked_files.get_result()
    untracked_files = untracked_files.splitlines()
    untracked = len(untracked_files)

    # Count stashed files.
    stash_list = p_stash_list.get_result()
    stashed = len(stash_list.splitlines())

    # Check if clean.
    if not unstaged and not staged and not conflicts and not untracked:
        clean = '1'
    else:
        clean = '0'

    # Count difference commits between the current branch and the remote branch.
    ahead = '0'
    behind = '0'
    if p_behind_ahead:
        try:
            behind_ahead = p_behind_ahead.get_result().split()
            behind = behind_ahead[0]
            ahead = behind_ahead[1]
        except:
            # If the option --count is unsupported.
            behind_ahead = Cmd('git rev-list --left-right %s...HEAD'
                               % tracking_branch).get_result().splitlines()
            ahead = len([x for x in behind_ahead if x[0] == '>'])
            behind = len(behind_ahead) - ahead

    # Count unmerged commits.
    unmerged = '0'
    if p_unmerged_list:
        try:
            unmerged_list = p_unmerged_list.get_result().splitlines()
        except Exception as e:
            err_msg = ERRO_MSG_AMBIGUOUS_ARGUMENT % (merge_branch, branch)
            if not err_msg in str(e):
                raise
        else:
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
