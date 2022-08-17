# Living in the terminal

Here's a collection of tips to help you when you spend time in the terminal.

## `alias`

This command lets you easily create shortcuts for other commands. It's especially useful to ensure you don't forget an option. Here are some examples:

`alias ll="ls -AlFGgh --color='always'"`. This binds `ll` to a more featured version of `ls`. It shows permissions, puts each file or directory on its own line, color codes different kinds of files, and more!

`ls` output:
```
README.md  bash  setup.md  setup.sh  vim
```

`ll` output: (pretend there are colors, too)
```
total 28K
-rw-r--r--  1 8.1K Aug  4  2017 .DS_Store
drwxr-xr-x 16  512 Aug 29  2019 .git/
-rw-r--r--  1   35 Jun 21  2018 .gitignore
-rw-r--r--  1   27 Jun 26  2017 README.md
drwxr-xr-x  7  224 Aug 29  2019 bash/
-rw-r--r--  1  494 Jul 12  2018 setup.md
-rw-r--r--  1 3.2K Jul 28  2017 setup.sh
drwxr-xr-x 11  352 Jul 22  2019 vim/
```

I've found this block especially useful:
```
alias gs="git status"
alias gc="git commit -m"
alias gA="git add -A && git status"
```
This enforces good git hygiene--I can't commit without a commit message, because if I try to just `gc`, it throws an error!

Be sure to place these in your bashrc so they are there every time you open your terminal.

## `tree`

`tree` is an awesome command that gives you a more visual look at your file structure. Here's its output on the same directory as above:
```
.
├── README.md
├── bash
│   ├── bashrc
│   ├── featherhead.py
│   ├── fromproj.py
│   ├── projpath.py
│   └── toproj.py
├── setup.md
├── setup.sh
└── vim
    ├── UltiSnips
    │   ├── make.snippets
    │   ├── python.snippets
    │   └── yaml.snippets
    ├── ftplugin
    │   ├── make.vim
    │   ├── markdown.vim
    │   └── text.vim
    ├── hi-output
    ├── hi-presets.vim
    ├── parens.vim
    ├── plugs.vim
    ├── process-hi.py
    ├── vimconfigs.sh
    └── vimrc

4 directories, 21 files
```
Two great options for `tree` are `-C`, which adds color, and `-L NUMBER`, which makes tree only look NUMBER layers down. So, `tree -L 1` to the same directory gives:
```
.
├── README.md
├── bash
├── setup.md
├── setup.sh
└── vim

2 directories, 3 files
```

## vim keybindings in bash

Add `set -o vi` to your bashrc. It's vi, not vim, so it's missing some features that you might be used to (the most noticeable for me is the lack of text objects, so `ciw` or `da"` don't work). The one other issue is that there isn't a great way to tell which mode you're in (you default to insert), so sometimes you get confused.

## `cd -`

`cd -` jumps back to the last directory you were in. So, if you're in `~/git/HRDAG-training`, and you `cd /etc`, then `cd -`, you'll be back at `~/git/HRDAG-training`. It's helpful if you want to jump into another place briefly to get something done.

## searching past bash commands

When you're on the command line, typing CTRL-r triggers a search mode. Essentially, it takes whatever you type and finds the most recent command you executed that contains that string. It's super useful for when you want to run a long command that you ran awhile ago again.

<!-- done. -->
