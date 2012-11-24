#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import sys
import shlex

from subprocess import Popen, PIPE, \
    check_call, CalledProcessError


def run_cmd(cmd):
    cmd = shlex.split(cmd)
    out, error = Popen(cmd, stdout=PIPE, stderr=PIPE).communicate()
    check_error(error)
    if out:
        return out.decode('utf-8')
    return ''


def check_error(error):
    if error:
        print('Error:', error.decode('utf-8'), file=sys.stderr)
        sys.exit(1)


def check_before_running():
    try:
        check_call('type git >/dev/null 2>&1', shell=True)
    except CalledProcessError:
        check_error('Error: Git is not installed')

    output = run_cmd('git rev-parse --is-inside-work-tree')
    if output == 'false':
        check_error('Error: Not inside git work tree')


def main():
    #check_before_running()

    branch = run_cmd('git symbolic-ref HEAD')
    branch = branch.strip()[11:]

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
    import re
    remote_ahead = ''
    remote_behind = ''
    git_status = run_cmd('git status --porcelain -b')
    status = git_status.splitlines()[0]
    status = re.search('(?<= \[).*(?=])', status)
    if status:
        ahead = re.search('(?<=ahead )\d*', status.group())
        if ahead:
            remote_ahead = ahead.group()

        behind = re.search('(?<=behind )\d*', status.group())
        if behind:
            remote_behind = behind.group()

    # Result
    out = '\n'.join([
        branch,
        remote_ahead,
        remote_behind,
        str(staged),
        str(conflicts),
        str(unstaged),
        str(untracked),
        str(stashed),
        clean])
    print(out)


if __name__ == '__main__':
    main()
