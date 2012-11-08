#!/usr/bin/env python
# -*- coding: utf-8 -*-

#
# https://github.com/olivierverdier/zsh-git-prompt
#

from __future__ import print_function

## change those symbols to whatever you prefer
symbols = {'ahead of': '↑ ', 'behind': '↓ ', 'prehash':':'}

from subprocess import Popen, PIPE

import sys
import os

gitsym = Popen(['git', 'symbolic-ref', 'HEAD'], stdout=PIPE, stderr=PIPE)
branch, error = gitsym.communicate()

error_string = error.decode('utf-8')

if 'fatal: Not a git repository' in error_string:
    sys.exit(0)

branch = branch.strip()[11:]

res, err = Popen(['git','diff','--name-status'], stdout=PIPE, stderr=PIPE).communicate()
err_string = err.decode('utf-8')
if 'fatal' in err_string:
    sys.exit(0)


# files
changed_files = [namestat[0] for namestat in res.splitlines()]
staged_files = [namestat[0] for namestat in Popen(['git','diff', '--staged','--name-status'], stdout=PIPE).communicate()[0].splitlines()]

# git status
nb_changed = len(changed_files) - changed_files.count('U')
nb_U = staged_files.count('U')
nb_staged = len(staged_files) - nb_U
staged = str(nb_staged)
conflicts = str(nb_U)
changed = str(nb_changed)
nb_untracked = len(Popen(['git','ls-files','--others','--exclude-standard'],stdout=PIPE).communicate()[0].splitlines())
untracked = str(nb_untracked)

# stash
nb_stashed = len(Popen(['git','stash','list'],stdout=PIPE).communicate()[0].splitlines())
stashed = str(nb_stashed)

# checking clean
if not nb_changed and not nb_staged and not nb_U and not nb_untracked:
    clean = '1'
else:
    clean = '0'


## git remote status
#
import re

remote = ''
status = Popen(['git','status', '--porcelain', '-b'], stdout=PIPE).communicate()[0].strip().splitlines()[0]
status = re.search('(?<= \[).*(?=])', status)
if status:
    ahead = re.search('(?<=ahead )\d*', status.group())
    if ahead:
        remote += '%s%s' % (symbols['ahead of'], ahead.group())

    behind = re.search('(?<=behind )\d*', status.group())
    if behind:
        remote += '%s%s' % (symbols['behind'], behind.group())

## Result
#
out = '\n'.join([
    str(branch),
    remote,
    staged,
    conflicts,
    changed,
    untracked,
    stashed,
    clean])
print(out)

