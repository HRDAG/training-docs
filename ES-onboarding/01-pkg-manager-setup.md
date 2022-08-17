# Setting up a package manager

Package managers are useful for installing and updating command-line tools. Instead of having to go through lots of complicated steps, you can execute one simple command. Here's an example:

Without a package manager:
```
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar xzf nvim-macos.tar.gz
./nvim-osx64/bin/nvim
```

With a package manager:
```
brew install neovim
```

## MacOS: Installing homebrew

Homebrew is the most popular package manager for macOS. To install, copy and paste the following into the terminal and hit enter:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

## Linux: TODO

## Windows: TODO

<!-- give up, maybe -->
