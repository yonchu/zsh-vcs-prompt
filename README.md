zsh-vcs-prompt
======================

A ``zsh`` prompt that displays information about the current vcs(git/svn/hg) repository.
In particular the branch name, difference with remote branch, number of files staged, changed, etc.

(an original idea from this [olivierverdier/zsh-git-prompt](https://github.com/olivierverdier/zsh-git-prompt)).

### Screenshot

![Screenshot1](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample01.png)

![Screenshot2](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample02.png)

![Screenshot3](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample03.png)

![Screenshot4](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample04.png)

![Screenshot5](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample05.png)

![Screenshot6](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample06.png)

## Features

 - Displays the various vcs status.
 - Displays the vcs action (merge, rebase, rebase-i, etc).
 - Displays unmerged commits count (to master) (e.g. branch(3) is 3 unmerged commits).
 - Use python scripts (it is a little faster than shell scripts).
 - Formats can be readily customized.
 - It works on bash prompt (if zsh is installed).

## About status

Remote status:

- ↑ n : ahead
- ↓ n : behind

Local status:

- ✔  :  repository clean
- ● n : there are n staged files
- ✖ n : there are n unmerged files
- ✚ n : there are n changed but unstaged files
- … n : there are n untracked files
- ⚑n  : there are n stashed
- branch(n) : there are n unmerged commits to master

Installation
---------------

1.Create the directory ``~/.zsh`` if it does not exist (this location is customizable).

```bash
$ mkdir ~/.zsh
```

2.Clone from github

```console
$ cd ~/.zsh
$ git clone git://github.com/yonchu/zsh-vcs-prompt.git
```

3.Source the file ``zshrc.sh`` from your ``~/.zshrc`` config file, and, configure your prompt. So, somewhere in ``~/.zshrc``, you should have:

```bash
source ~/.zsh/zsh-vcs-prompt/zshrc.sh
ZSH_VCS_PROMPT_ENABLE_CACHING='true'
RPROMPT='$(vcs_super_info)'
```

Note that enclosed ``$(vcs_super_info)`` in double quotation. If call ``vcs_super_info`` in other functions (like hook functions), not set ZSH_VCS_PROMPT_ENABLE_CACHING.


## Python or Shell scripts?

By default uses the python script (lib/gitstatus-fast.py). But if you don't want to use the python script, you can use only shell scripts.
In that case, you should have in ```~/.zshrc```:

```bash
ZSH_VCS_PROMPT_USING_PYTHON='false'
```

The shell scripts is more portable than python scripts (as it has no dependencies).
However, the python script runs a little faster than the shell scripts.
If the python script is not available, it works on shell scripts without the python script automatically.
Therefore, you apply the above only when you want to use explicitly shell scripts.

## Use on bash

The ``zsh-vcs-prompt`` can also be used on ``bash``.

![Screenshot](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample01_bash.png)

Source the file ``zshrc.sh`` from your ``~/.bashrc`` config file, and, configure your prompt in same way as ``zsh``.

```bash
if [ -f ~/.zsh/zsh-vcs-prompt/zshrc.sh ]; then
    source ~/.zsh/zsh-vcs-prompt/zshrc.sh 2> /dev/null \
        && PS1="$PS1"'\[\e[1;31m\]$(vcs_super_info)\[\e[0;m\]'
fi
```

However, unable to colorize the prompt like ``zsh``.

## Customizing prompt

You can change the appearance of the prompt.

The variables is defined as follows by default.
If you chage it, configures the variables in your ``~/.zshrc``.


**Change the symbols:**

```bash
## The symbols.
ZSH_VCS_PROMPT_AHEAD_SIGIL='↑ '
ZSH_VCS_PROMPT_BEHIND_SIGIL='↓ '
ZSH_VCS_PROMPT_STAGED_SIGIL='● '
ZSH_VCS_PROMPT_CONFLICTS_SIGIL='✖ '
ZSH_VCS_PROMPT_UNSTAGED_SIGIL='✚ '
ZSH_VCS_PROMPT_UNTRACKED_SIGIL='… '
ZSH_VCS_PROMPT_STASHED_SIGIL='⚑'
ZSH_VCS_PROMPT_CLEAN_SIGIL='✔ '
```

**Hide count:**

```bash
ZSH_VCS_PROMPT_HIDE_COUNT='true'
```

![hide_count](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample_hide_count.png)

**Change the branch which count unmerged commits to:**

```bash
# Default
#ZSH_VCS_PROMPT_MERGE_BRANCH=master
ZSH_VCS_PROMPT_MERGE_BRANCH=develop
```

If you hide it, set the following:

```bash
ZSH_VCS_PROMPT_MERGE_BRANCH=
```

**Format string:**

```
#s : The VCS name (e.g. git svn hg).
#a : The action name (e.g. merge, rebase, rebase_i)
#b : The current branch name.

#c : The ahead status.
#d : The behind status.

#e : The staged status.
#f : The conflicted status.
#g : The unstaged status.
#h : The untracked status.
#i : The stashed status.
#j : The clean status.
```

**Change the format for ``git`` without Action:**

```bash
## Git without Action.
# VCS name
ZSH_VCS_PROMPT_GIT_FORMATS='(%{%B%F{yellow}%}#s%{%f%b%})'
# Branch name
ZSH_VCS_PROMPT_GIT_FORMATS+='[%{%B%F{red}%}#b%{%f%b%}'
# Ahead and Behind
ZSH_VCS_PROMPT_GIT_FORMATS+='#c#d|'
# Staged
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{blue}%}#e%{%f%b%}'
# Conflicts
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{red}%}#f%{%f%b%}'
# Unstaged
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{yellow}%}#g%{%f%b%}'
# Untracked
ZSH_VCS_PROMPT_GIT_FORMATS+='#h'
# Stashed
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{cyan}%}#i%{%f%b%}'
# Clean
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{green}%}#j%{%f%b%}]'
```

**Change the format for ``git`` with Action:**

```bash
### Git with Action.
# VCS name
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS='(%{%B%F{yellow}%}#s%{%f%b%})'
# Branch name
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='[%{%B%F{red}%}#b%{%f%b%}'
# Action
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+=':%{%B%F{red}%}#a%{%f%b%}'
# Ahead and Behind
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='#c#d|'
# Staged
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{blue}%}#e%{%f%}'
# Conflicts
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{red}%}#f%{%f%}'
# Unstaged
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{yellow}%}#g%{%f%}'
# Untracked
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='#h'
# Stashed
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{cyan}%}#i%{%f%}'
# Clean
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{green}%}#j%{%f%}]'
```

**Change the format for other VCS without Action:**

```bash
## Other VCS without Action.
# VCS name
ZSH_VCS_PROMPT_VCS_FORMATS='(%{%B%F{yellow}%}#s%{%f%b%})'
# Branch name
ZSH_VCS_PROMPT_VCS_FORMATS+='[%{%B%F{red}%}#b%{%f%b%}]'
```

**Change the format for other VCS with Action:**

```bash
## Other VCS with Action.
# VCS name
ZSH_VCS_PROMPT_VCS_ACTION_FORMATS='(%{%B%F{yellow}%}#s%{%f%b%})'
# Branch name
ZSH_VCS_PROMPT_VCS_ACTION_FORMATS+='[%{%B%F{red}%}#b%{%f%b%}'
# Action
ZSH_VCS_PROMPT_VCS_ACTION_FORMATS+=':%{%B%F{red}%}#a%{%f%b%}]'
```

See also
---------------

* [よんちゅBlog](http://yonchu.hatenablog.com/)
