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
0. Todo ...

## Terminal

### Commonly used scripts

- Aliases: [`.sh-aliases`](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.sh-aliases)
- Environment Variables: [`.sh-env-vars`](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.sh-env.vars)

### Still Bash? No! Try Zsh! (Unix-like)

#### Set as default shell

0. What shell am I using? Run `echo $0`
0. If you are already running `zsh`, skip this section.
0. Install `zsh` by yourself.
    - Linux (`apt`): `apt install zsh`
    - MacOS (`brew`): `brew install zsh`
0. Set `zsh` as default:
    - If you are using MacOS, run this first: `echo $(which zsh) | sudo tee -a /etc/shells`
    - Run `chsh -s $(which zsh)`
0. **[OPTIONAL]** Now, you might want to copy (or link) your previous settings to `zsh`.
    0. `~/.zshenv` contains environment variables.
    0. `~/.zshrc` contains aliases, functions, and key bindings.
    0. Ask for help if you are confused.
0. Restart your terminal.
0. You will be prompted with `zsh`'s first-use wizard.
    - Enter `0` if it asks whether to create files like `.zshrc`

#### Configure plugins

##### Plugin manager: [`antigen`](https://github.com/zsh-users/antigen)

- Installation: `curl -L git.io/antigen-nightly --output ~/antigen.zsh`

<details><summary>Plugins detail (you can safely ignore these)</summary><p>

##### Syntax highlighting: [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)

- Installation:
    - Append `antigen bundle zsh-users/zsh-syntax-highlighting` as the **LAST** (**LAST!** **LAST!**) `antigen bundle ...` in `~/.sh-antigen`.
- Configuration:
    - Maybe you will like to enable async mode:
        - Append `export ZSH_AUTOSUGGEST_USE_ASYNC=1` as well.

##### Automatic suggestions: [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)

- Installation:
    - Append `antigen bundle zsh-users/zsh-autosuggestions` to `~/.sh-antigen`.

##### Zsh completion: [`zsh-completions`](https://github.com/zsh-users/zsh-completions)

- Installation:
    - Append `antigen bundle zsh-users/zsh-completions` to `~/.sh-antigen`.

##### Safer command pasting: [`safe-paste`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/safe-paste)

- Installation:
    - Append `antigen bundle safe-paste` to `~/.sh-antigen`.

##### Filesystem navigation: [`z`](https://github.com/rupa/z)

- Installation:
    - Append `antigen bundle z` to `~/.sh-antigen`.

##### Invalid command helper: [`command-not-found`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/command-not-found)

- Installation:
    - Append `antigen bundle command-not-found` to `~/.sh-antigen`.

##### Automatic update: [`autoupdate-antigen.zshplugin`](https://github.com/unixorn/autoupdate-antigen.zshplugin)

- Installation:
    - Append `antigen bundle unixorn/autoupdate-antigen.zshplugin` to `~/.sh-antigen`.

##### Directory listing: [`k`](https://github.com/supercrabtree/k)

- Installation:
    - Append `antigen bundle supercrabtree/k` to `~/.sh-antigen`.
    - MacOS users might want to install `coreutils` to show file sizes in human-readable format. [More info](https://github.com/supercrabtree/k#file-weight-colours).
        - Append `which numfmt >/dev/null || { which brew >/dev/null && brew install coreutils }` as well.

##### Pip autocomplete: [`pip`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/pip)

- Installation:
    - Append `antigen bundle pip` to `~/.sh-antigen`.

##### Terminal 256-color: [`zsh-256color`](https://github.com/chrissicool/zsh-256color)

- Installation:
    - Append `antigen bundle chrissicool/zsh-256color` to `~/.sh-antigen`.

</p></details>

#### Configure themes

<details><summary>Themes detail (you can safely ignore these)</summary><p>

##### [`powerlevel10k`](https://github.com/romkatv/powerlevel10k)

- Installation:
    - Append `antigen bundle romkatv/powerlevel10k` to `~/.sh-antigen`.

</p></details>

#### Wrap up

<details><summary>Wrap up detail (you can safely ignore these)</summary><p>

- Append `antigen apply` to `~/.sh-antigen`.

</p></details>

#### Summary

- Your `~/.sh-antigen` file should be very similar to [`.sh-antigen` in the repo](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.sh-antigen).
    - If you don't have `~/.sh-antigen` file:
        - Download it using `curl -LOJ https://raw.githubusercontent.com/jerryc05/MyTemplate/__env-settings/.sh-antigen`
- Append these lines to `~/.zshrc` to enable `antigen`:
  ```sh
  [ -f $HOME/.sh-antigen ] && . $HOME/.sh-antigen
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
    - Run the following script in terminal (just for customization):
        - Linux:
        ```sh
        sed -i \
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
        ~/.p10k.zsh && \
        . ~/.p10k.zsh
        ```
        - MacOS:
        ```sh
        sed \
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
        -i '' ~/.p10k.zsh && \
        . ~/.p10k.zsh
        ```
    - You can tweak `~/.p10k.zsh` yourself as well if you are interested.
        - Don't forget to run `. ~/.p10k.zsh` afterwards to apply changes.
