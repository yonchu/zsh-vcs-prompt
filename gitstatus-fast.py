#!/usr/bin/env python
# -*- coding: utf-8 -*-

# https://github.com/olivierverdier/zsh-git-prompt

import sys
from subprocess import Popen, PIPE, \
    check_call, CalledProcessError

## change those symbols to whatever you prefer
symbols = {'ahead of': '↑ ', 'behind': '↓ ', 'prehash ': ':'}


def check_error(error):
    if error:
        print >> sys.stderr, 'Error:', error.decode('utf-8')
        sys.exit(1)


def check_before_running():
    try:
        check_call('type git >/dev/null 2>&1', shell=True)
    except CalledProcessError:
        print >> sys.stderr, 'Error: Git is not installed'
        sys.exit(1)

    output, error = Popen(['git', 'rev-parse', '--is-inside-work-tree'],
                          stdout=PIPE, stderr=PIPE).communicate()
    check_error(error)
    if output == 'false':
        print >> sys.stderr, 'Error: Not inside git work tree'
        sys.exit(1)


def main():
    #check_before_running()

    branch, error = Popen(['git', 'symbolic-ref', 'HEAD'],
                          stdout=PIPE, stderr=PIPE).communicate()
    check_error(error)
    branch = branch.strip()[11:]

    # unstaged
    unstaged_files, error = Popen(
        ['git', 'diff', '--name-status'],
        stdout=PIPE, stderr=PIPE).communicate()
    check_error(error)
    unstaged_files = [namestat[0] for namestat in unstaged_files.splitlines()]
    unstaged = len(unstaged_files) - unstaged_files.count('U')

    # staged
    staged_files, error = Popen(
        ['git', 'diff', '--staged', '--name-status'],
        stdout=PIPE, stderr=PIPE).communicate()
    check_error(error)
    staged_files = [namestat[0] for namestat in staged_files.splitlines()]
    # conflicts
    conflicts = staged_files.count('U')
    staged = len(staged_files) - conflicts

    # untracked
    untracked_files, error = Popen(
        ['git', 'ls-files', '--others', '--exclude-standard'],
        stdout=PIPE, stderr=PIPE).communicate()
    check_error(error)
    untracked_files = untracked_files.splitlines()
    untracked = len(untracked_files)

    # stash
    stash_list, error = Popen(
        ['git', 'stash', 'list'],
        stdout=PIPE, stderr=PIPE).communicate()
    check_error(error)
    stashed = len(stash_list.splitlines())

    # checking clean
    if not unstaged and not staged and not conflicts and not untracked:
        clean = '1'
    else:
        clean = '0'

    # remote
    import re
    remote = ''
    git_status, error = Popen(
        ['git', 'status', '--porcelain', '-b'],
        stdout=PIPE, stderr=PIPE).communicate()
    check_error(error)
    status = git_status.splitlines()[0]
    status = re.search('(?<= \[).*(?=])', status)
    if status:
        ahead = re.search('(?<=ahead )\d*', status.group())
        if ahead:
            remote += '%s%s' % (symbols['ahead of'], ahead.group())

        behind = re.search('(?<=behind )\d*', status.group())
        if behind:
            remote += '%s%s' % (symbols['behind'], behind.group())

    # Result
    out = '\n'.join([
        branch,
        remote,
        str(staged),
        str(conflicts),
        str(unstaged),
        str(untracked),
        str(stashed),
        clean])
    print out


if __name__ == '__main__':
    main()
