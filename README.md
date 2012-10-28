zsh-vcs-prompt
======================
A ``zsh`` prompt that displays information about the current vcs(git/svn/hg) repository.
In particular the branch name, difference with remote branch, number of files staged, changed, etc.

(an original idea from this [olivierverdier/zsh-git-prompt](https://github.com/olivierverdier/zsh-git-prompt)).

### Screenshot
![Screenshot](https://raw.github.com/yonchu/zsh-vcs-prompt/master/img/sample01.png)

* Installation
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
RPROMPT='$(git_super_status)'
```

See also
---------------
* [よんちゅBlog](http://yonchu.hatenablog.com/)
