zsh-vcs-prompt
======================
A ``zsh`` prompt that displays information about the current vcs(git/svn/hg) repository.
In particular the branch name, difference with remote branch, number of files staged, changed, etc.

(an original idea from this [olivierverdier/zsh-git-prompt](https://github.com/olivierverdier/zsh-git-prompt)).

### Screenshot
![Screenshot](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample01.png)

Remote
- ↑ : ahead
- ↓ : behind

Local
- ✔ : repository clean
- ● n: there are n staged files
- ✖ n: there are n unmerged files
- ✚ n: there are n changed but unstaged files
- … n: there are n untracked files

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

By default uses the python script (gitstatus-fast.py). But if don't use python script, you can use only shell script.
In that case, you should have in ```~/.zshrc```:

```bash
ZSH_VCS_PROMPT_USING_PYTHON='false'
```

### Customizing prompt

You can change the appearance of the prompt.

The variables is defined as follows by default.
If you chage it, configures the variables in your ``~/.zshrc``.

```bash
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
ZSH_VCS_PROMPT_GIT_FORMATS='(%s)-[%b%c%d|%e%f%g%h%i%j]'
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS='(%s)-[%b:%a%c%d|%e%f%g%h%i%j]'
# Other vcs.
ZSH_VCS_PROMPT_VCS_FORMATS='(%s)-[%b]'
ZSH_VCS_PROMPT_VCS_ACTION_FORMATS='(%s)-[%b:%a]'

## The symbols.
ZSH_VCS_PROMPT_AHEAD_SIGIL='↑ '
ZSH_VCS_PROMPT_BEHIND_SIGIL='↓ '
ZSH_VCS_PROMPT_STAGED_SIGIL='● '
ZSH_VCS_PROMPT_CONFLICTS_SIGIL='✖ '
ZSH_VCS_PROMPT_UNSTAGED_SIGIL='✚ '
ZSH_VCS_PROMPT_UNTRACKED_SIGIL='… '
ZSH_VCS_PROMPT_STASHED_SIGIL='⚑'
ZSH_VCS_PROMPT_CLEAN_SIGIL='✔ '

## Color settings.
ZSH_VCS_PROMPT_VCS_NAME_COLOR='%{%B%F{green}%}'
ZSH_VCS_PROMPT_VCS_NAME_COLOR_USING_PYTHON='%{%F{yellow}%}'
ZSH_VCS_PROMPT_BRANCH_COLOR='%{%B%F{red}%}'
ZSH_VCS_PROMPT_ACTION_COLOR='%{%B%F{red}%}'
ZSH_VCS_PROMPT_AHEAD_COLOR=''
ZSH_VCS_PROMPT_BEHIND_COLOR=''
ZSH_VCS_PROMPT_STAGED_COLOR='%{%F{blue}%}'
ZSH_VCS_PROMPT_CONFLICTS_COLOR='%{%F{red}%}'
ZSH_VCS_PROMPT_UNSTAGED_COLOR='%{%F{yellow}%}'
ZSH_VCS_PROMPT_UNTRACKED_COLOR=''
ZSH_VCS_PROMPT_STASHED_COLOR='%{%F{cyan}%}'
ZSH_VCS_PROMPT_CLEAN_COLOR='%{%F{green}%}'
```

See also
---------------
* [よんちゅBlog](http://yonchu.hatenablog.com/)
