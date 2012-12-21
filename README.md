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
source ~/zsh/zsh-vcs-prompt/zshrc.sh
RPROMPT='$(vcs_super_info)'
```

### Python or Shell scripts?

By default uses the python script (lib/gitstatus-fast.py). But if don't use python script, you can use only shell script.
In that case, you should have in ```~/.zshrc```:

```bash
ZSH_VCS_PROMPT_USING_PYTHON='false'
```
### On bash

The ``zsh-vcs-prompt`` can also be used on ``bash``.

![Screenshot](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample01_bash.png)

Source the file ``zshrc.sh`` from your ``~/.bashrc`` config file, and, configure your prompt in same way as ``zsh``.

```bash
source ~/.zsh/zsh-vcs-prompt/zshrc.sh
PS1="$PS1"'\[\e[1;31m\]$(vcs_super_info)\[\e[0;m\]'
```
However, unable to colorize the prompt like ``zsh``.

If ``zsh-vcs-prompt`` directory is put except in the default location (~/.zsh),
 configures the following settings in your ``~/.bashrc``.

```bash
ZSH_VCS_PROMPT_DIR=/path/to/zsh-vcs-prompt
```

### Customizing prompt

You can change the appearance of the prompt.

The variables is defined as follows by default.
If you chage it, configures the variables in your ``~/.zshrc``.

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

```bash
## Prompt formats.
#   #s : The VCS name (e.g. git svn hg).
#   #a : The action name.
#   #b : The current branch name.
#
#   #c : The ahead status.
#   #d : The behind status.
#
#   #e : The staged status.
#   #f : The conflicted status.
#   #g : The unstaged status.
#   #h : The untracked status.
#   #i : The stashed status.
#   #j : The clean status.

### Git.
## No action.
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

## No action using python.
# If this variable is empty, ZSH_VCS_PROMPT_GIT_FORMATS is used instead of it.
ZSH_VCS_PROMPT_GIT_FORMATS_USING_PYTHON=''

## Action.
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


### Other vcs.
## No action.
# VCS name
ZSH_VCS_PROMPT_VCS_FORMATS='(%{%B%F{yellow}%}#s%{%f%b%})'
# Branch name
ZSH_VCS_PROMPT_VCS_FORMATS+='[%{%B%F{red}%}#b%{%f%b%}]'

## Action.
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
