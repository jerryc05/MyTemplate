# MyTemplate - Environment Settings

This is a personal environment configuration for development.

Use at your **OWN** risk.

## Table of Contents

0. [Terminal](#terminal)
    - [Commonly used scripts](#commonly-used-scripts)
    - [Still Bash? No! Try Zsh! (Unix-like)](#still-bash-no-try-zsh-unix-like)
        - [Set as default shell](#set-as-default-shell)
        - [Configure plugins](#configure-plugins)
        - [Configure themes](#configure-themes)
        - [Wrap up](#wrap-up)
        - [Summary](#summary)
0. [Git](#git)
    - [Config](#git-config)

## Terminal

### Commonly used scripts

- Aliases: [`.aliases.sh`](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.aliases.sh)
- Environment Variables: [`.env-vars.sh`](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.env-vars.sh)

### Still Bash? No! Try Zsh! (Unix-like)

#### Set as default shell

0. What shell am I using? Run `echo $0`
0. If you are already running `zsh`, skip this section.
0. Install `zsh` by yourself.
    - Linux (`apt`): `apt install zsh`
    - Linux (`pacman`): `pacman -S zsh`
    - MacOS (`brew`): `brew install zsh`
0. Set `zsh` as default:
    - If you are using MacOS, run this first: `echo $(which zsh) | sudo tee -a /etc/shells`
    - Run `chsh -s $(which zsh)` (you might want to `cat /etc/shells`)
0. **[OPTIONAL]** Now, you might want to copy (or link) your previous settings to `zsh`.
    0. `~/.zshenv` contains environment variables.
    0. `~/.zshrc` contains aliases, functions, and key bindings.
    0. Ask for help if you are confused.
0. Restart your terminal.
0. You will be prompted with `zsh`'s first-use wizard.
    - Enter `0` if it asks whether to create files like `.zshrc`

#### Configure plugins

##### Plugin manager: [`antigen`](https://github.com/zsh-users/antigen)

- Installation:
  ```sh
  curl -L git.io/antigen-nightly --output ~/antigen.zsh

  scr="\
  -e 's/git clone /git clone --single-branch --depth=1 /g' \
  -e 's/\([ -]\)git pull/\1git pull --depth=1/g'"
  eval "sed $scr -i ./antigen.zsh || sed $scr -i '' ./antigen.zsh"
  ```

<details><summary>Plugins detail (you can safely ignore these)</summary><p>

##### Syntax highlighting: [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)

- Installation:
    - Append `antigen bundle zsh-users/zsh-syntax-highlighting` as the **LAST** (**LAST!** **LAST!**) `antigen bundle ...` in `~/.antigen-conf.sh`.
- Configuration:
    - Maybe you will like to enable async mode:
        - Append `export ZSH_AUTOSUGGEST_USE_ASYNC=1` as well.

##### Automatic suggestions: [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)

- Installation:
    - Append `antigen bundle zsh-users/zsh-autosuggestions` to `~/.antigen-conf.sh`.

##### Zsh completion: [`zsh-completions`](https://github.com/zsh-users/zsh-completions)

- Installation:
    - Append `antigen bundle zsh-users/zsh-completions` to `~/.antigen-conf.sh`.

##### Safer command pasting: [`safe-paste`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/safe-paste)

- Installation:
    - Append `antigen bundle safe-paste` to `~/.antigen-conf.sh`.

##### Filesystem navigation: [`z`](https://github.com/rupa/z)

- Installation:
    - Append `antigen bundle z` to `~/.antigen-conf.sh`.

##### Invalid command helper: [`command-not-found`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/command-not-found)

- Installation:
    - Append `antigen bundle command-not-found` to `~/.antigen-conf.sh`.

##### Automatic update: [`autoupdate-antigen.zshplugin`](https://github.com/unixorn/autoupdate-antigen.zshplugin)

- Installation:
    - Append `antigen bundle unixorn/autoupdate-antigen.zshplugin` to `~/.antigen-conf.sh`.

##### Directory listing: [`k`](https://github.com/supercrabtree/k)

- Installation:
    - Append `antigen bundle supercrabtree/k` to `~/.antigen-conf.sh`.
    - MacOS users might want to install `coreutils` to show file sizes in human-readable format. [More info](https://github.com/supercrabtree/k#file-weight-colours).
        - Append `which numfmt >/dev/null || { which brew >/dev/null && brew install coreutils }` as well.

##### Pip autocomplete: [`pip`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/pip)

- Installation:
    - Append `antigen bundle pip` to `~/.antigen-conf.sh`.

##### Terminal 256-color: [`zsh-256color`](https://github.com/chrissicool/zsh-256color)

- Installation:
    - Append `antigen bundle chrissicool/zsh-256color` to `~/.antigen-conf.sh`.

</p></details>

#### Configure themes

<details><summary>Themes detail (you can safely ignore these)</summary><p>

##### [`powerlevel10k`](https://github.com/romkatv/powerlevel10k)

- Installation:
    - Append `antigen bundle romkatv/powerlevel10k` to `~/.antigen-conf.sh`.

</p></details>

#### Wrap up

<details><summary>Wrap up detail (you can safely ignore these)</summary><p>

- Append `antigen apply` to `~/.antigen-conf.sh`.

</p></details>

#### Summary

- Make sure you have `git`, `less`, `tar`, `gzip` installed
- Make sure `echo $langinfo[CODESET]` prints someting like `UTF-8`
- Your `~/.antigen-conf.sh` file should be very similar to [`.antigen-conf.sh` in the repo](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.antigen-conf.sh).
    - If you don't have `~/.antigen-conf.sh` file, create one
- Append these lines to `~/.zshrc` to enable `antigen`:
  ```sh
  [ -f $HOME/.antigen-conf.sh ] && . $HOME/.antigen-conf.sh
  ```
- **[OPTIONAL]** Change terminal's font to one that supports **Emoji** (or at least **Unicode**) characters.
    - Some recommended font-families:
        - [Cascadia Code](https://github.com/microsoft/cascadia-code) (my top choice)
        - [Fira Code](https://github.com/tonsky/FiraCode) (quite good)
        - [MesloLGS NF](https://github.com/romkatv/powerlevel10k/blob/master/font.md) (used by `p10k` theme, but not really recommended)
    - If you decided to change terminal's font, make sure to:
        - Download all fonts in the font-family (e.g. `Regular`, `Bold`, etc).
        - Install all fonts in the font-family.
        - Change the font of the terminal.
- Restart terminal.
- If you are using `powerlevel10k` (default theme of this tutorial):
    -   Run the following script in terminal (just for customization):
        ```sh
        scr="\
        -e 's/# *node_version/node_version/g' \
        -e 's/# *go_version/go_version/g' \
        -e 's/# *rust_version/rust_version/g' \
        -e 's/# *dotnet_version/dotnet_version/g' \
        -e 's/# *php_version/php_version/g' \
        -e 's/# *laravel_version/laravel_version/g' \
        -e 's/# *java_version/java_version/g' \
        -e 's/# *package/package/g' \
        -e 's/# *vpn_ip/vpn_ip/g' \
        -e 's/# *load/load/g' \
        -e 's/# *disk_usage/disk_usage/g' \
        -e 's/# *ram/ram/g' \
        -e 's/# *battery/battery/g' \
        -e 's/# *wifi  /wifi  /g' \
        -e 's/^\( *\)context/#\1context/g'"
        eval "sed $scr -i ~/.p10k.zsh || sed $scr -i '' ~/.p10k.zsh"
        . ~/.p10k.zsh
        ```
    -   You can tweak `~/.p10k.zsh` yourself as well if you are interested.
        -   Don't forget to run `. ~/.p10k.zsh` afterwards to apply changes.

## Git

### Git Config
```sh
git config --global user.name   'Ziyan "Jerry" Chen'
git config --global user.email  "jerryc443@gmail.com"
git config --get-regexp user.*

git config --global core.autocrlf   input
git config --global core.eol        lf
git config --global core.fileMode   true
git config --global core.safecrlf   true
git config --global core.longpaths  true
git config --get-regexp core.*

#git config --global commit.gpgsign  true
#git config --global tag.gpgsign     true
#git config --global user.signingkey 9611836BA79323A18C3B0ED9B965A9B81A81CA96

git config --global init.defaultBranch          main
git config --global push.recursesubmodules      check
git config --global core.usebuiltinfsmonitor    true

pacman -S kdiff3 || apt install kdiff3 || brew install --cask kdiff3
git config --global merge.tool kdiff3
```
