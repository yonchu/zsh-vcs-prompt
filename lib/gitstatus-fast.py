#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import sys
import shlex

from subprocess import Popen, PIPE, \
    check_call, CalledProcessError


def run_cmd(cmd, ignore_error=False):
    cmd = shlex.split(cmd)
    p = Popen(cmd, stdout=PIPE, stderr=PIPE)
    out, error = p.communicate()
    if not ignore_error:
        check_error(error, p.returncode)
    if out:
        if isinstance(out, bytes):
            out = out.decode('utf-8')
        return str(out)

    return ''


def check_error(error, returncode=1):
    if returncode == 0:
        return
    message = 'Unknown error'
    if error:
        if isinstance(error, bytes):
            error = error.decode('utf-8')
        message = str(error)
    message += '(%d)' % returncode
    print('Error(%d):' % returncode, message, file=sys.stderr)
    sys.exit(1)


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

    # branch
    branch = run_cmd('git symbolic-ref --short HEAD').strip()

    # unstaged
    unstaged_files = run_cmd('git diff --name-status')
    unstaged_files = [namestat[0] for namestat in unstaged_files.splitlines()]
    unstaged = len(unstaged_files) - unstaged_files.count('U')

    # staged
    staged_files = run_cmd('git diff --staged --name-status')
    staged_files = [namestat[0] for namestat in staged_files.splitlines()]
    # conflicts
    conflicts = staged_files.count('U')
    staged = len(staged_files) - conflicts

    # untracked
    untracked_files = run_cmd('git ls-files --others --exclude-standard')
    untracked_files = untracked_files.splitlines()
    untracked = len(untracked_files)

    # stash
    stash_list = run_cmd('git stash list')
    stashed = len(stash_list.splitlines())

    # checking clean
    if not unstaged and not staged and not conflicts and not untracked:
        clean = '1'
    else:
        clean = '0'

    # remote
    ahead = '0'
    behind = '0'
    head_branch = run_cmd('git symbolic-ref HEAD').strip()
    tracking_branch = run_cmd('git for-each-ref --format="%(upstream:short)" '
                              + head_branch, ignore_error=True).strip()
    if tracking_branch:
        behind_ahead = run_cmd('git rev-list --left-right --count %s...HEAD'
                               % tracking_branch).split()
        behind = behind_ahead[0]
        ahead = behind_ahead[1]

    # Result
    out = '\n'.join([
        branch,
        ahead,
        behind,
        str(staged),
        str(conflicts),
        str(unstaged),
        str(untracked),
        str(stashed),
        clean])
    print(out)


if __name__ == '__main__':
    main()
