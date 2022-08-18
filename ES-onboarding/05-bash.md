# Bash

Bash is a language to interact with the Unix/Linux file system and process tree. It’s a sort of meta-language, within which everything else on your computer lives.

Here are some things to try to get started with Bash:

Open up your terminal, and type in `cd`. This will change directories (folders are called directories in Unix) to the 'home' directory, which is unique for each user. Now, if you type `ls`, it should list all the files and directories inside your home directory. This should list all your non-hidden files and directories in whatever directory you're in. But what about the hidden files? Those files are just the files that start with dots (.). To see them, use `ls -a`. These hidden 'dotfiles' will come up later, when you’re customizing your environment.

You’ve probably noticed something else by now too, which is the prompt. This is the text that is displayed before your commands. For you it probably looks like: `<machine-name>:<directory> <account-name>$`. This prompt is bad for a couple of reasons: it has no color, which helps your eye differentiate between values; it's laid out poorly, so it's hard to read; and it doesn't have your complete path. 

With a complete path, I can tell who I am, where I am (eleanor for example) and where I am specifically (`~/git/GT-fingerprints/individual`). I then have my command on its own line so if I have an especially long path, the command I type in will still have room. You should figure out what prompt you'd like to have, and then program it in! Here's some basic tips:

1. Assign whatever formula to the `PS1` variable in bash
2. Do all your work in `~/.bashrc`. This is one of those dotfiles—it's run automatically for bash to see your preferences–backslashed characters are your friends! They’re how you can put variables into your prompt. Check out this list for some: https://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html

This links are useful for getting started with Bash:

- http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html
- http://cs.lmu.edu/~ray/notes/bash/
- https://programminghistorian.org/en/lessons/intro-to-bash (spanish: https://programminghistorian.org/es/lecciones/introduccion-a-bash)
- https://www.digitalocean.com/community/tutorials/an-introduction-to-the-linux-terminal
 https://www.tjhsst.edu/~dhyatt/superap/unixcmd.html (essential, valuable, and useful lists are good—the rest are a tad out of date)
- https://softcover.s3.amazonaws.com/636/learn_enough_command_line/images/figures/anatomy.png (an image explaining bash's structure)
- http://tldp.org/LDP/abs/html/ (way too in depth, and focused on scripting, not command line. Could be useful as a 'dictionary')
- https://www.youtube.com/watch?v=oxuRxtrO2Ag&t=3922s (highly recommend 1.5-2x speed)


