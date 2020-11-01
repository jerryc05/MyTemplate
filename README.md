# MyTemplate - Environment Settings

This is a personal environment configuration for development.

Use at your **OWN** risk.

## Table of Contents

1. [Terminal](#terminal)
    - [Handy aliases/vars/cmds/...](#handy-aliases/vars/cmds/)
    - [Still Bash? No! Try Zsh! (Unix-like)](#still-bash-no-try-zsh-unix-like)
        - [Set as default shell](#set-as-default-shell)
        - [Configure plugins](#configure-plugins)
        - [Configure themes](#configure-themes)
        - [Wrap up](#wrap-up)
        - [Summary](#summary)

## Terminal

### Handy aliases/vars/cmds/...

- Check out [`.sh-aliases`](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.sh-aliases) and [`.sh-env-vars`](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.sh-env.vars) in the repo.
- Copy anything at your will.

### Still Bash? No! Try Zsh! (Unix-like)

#### Set as default shell

1. What shell am I using? Run `echo $0`
2. If you are already running `zsh`, skip this section.
3. Install `zsh` by yourself.
    - Linux(`apt`): `apt install zsh`
    - MacOS(`brew`): `brew install zsh`
4. Set `zsh` as default:
    - If you are on MacOS, run this first: `echo $(which zsh) | sudo tee -a /etc/shells`
    - Run `chsh -s $(which zsh)`
5. **[RECOMMENDED]** Copy all env variables statements (e.g. `$PATH`) from `~/.bash_profile` (or other profile like `~/.profile`).
6. **[RECOMMENDED]** Paste them to `~/.zshenv` (create the file if you don’t have it).
7. **[RECOMMENDED]** Copy your alias, functions, key bindings and more from `~/.bash_profile` (or other profile like `~/.profile`).
8. **[RECOMMENDED]** Paste them to `~/.zshrc` (create the file if you don’t have it), or link them to `~/.zshrc` accordingly if you don't want to.
9. Restart your terminal.
10. You will be prompted with `zsh`'s first-use wizard.
    - Prompt `0` if the wizard asks whether to create files like `.zshrc`

#### Configure plugins

##### Plugin manager: [`antigen`](https://github.com/zsh-users/antigen)

- Installation:
    - Linux(`apt`): `apt install zsh-antigen`
    - MacOS(`brew`): `brew install antigen`

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

- Your `~/.sh-antigen` file shall look very similar to [`.sh-antigen` in the repo](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.sh-antigen).
    - If you don't have `~/.sh-antigen` file:
        - Create it by running: `nano ~/.sh-antigen`
        - Copy-paste the contents from [`.sh-antigen` in the repo](https://github.com/jerryc05/MyTemplate/blob/__env-settings/.sh-antigen).
- Append these lines to `~/.zshrc` to enable `antigen`:
  ```sh
  if [ -f $HOME/.sh-antigen ]; then
    source $HOME/.sh-antigen
  fi
  ```
- **[RECOMMENDED]** Change terminal's font to one that supports **Emoji** (or at least **Unicode**) characters.
    - Some recommended font-families:
        - [Cascadia Code](https://github.com/microsoft/cascadia-code)
        - [MesloLGS NF (used by `p10k` theme)](https://github.com/romkatv/powerlevel10k/blob/master/font.md)
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
        -e 's/# *load/load/g' \
        -e 's/# *disk_usage/disk_usage/g' \
        -e 's/# *ram/ram/g' \
        -e 's/# *battery/battery/g' \
        -e 's/# *wifi  /wifi  /g' \
        ~/.p10k.zsh && \
        source ~/.p10k.zsh
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
        -e 's/# *load/load/g' \
        -e 's/# *disk_usage/disk_usage/g' \
        -e 's/# *ram/ram/g' \
        -e 's/# *battery/battery/g' \
        -e 's/# *wifi  /wifi  /g' \
        -i '' ~/.p10k.zsh && \
        source ~/.p10k.zsh
        ```
    - You can tweak `~/.p10k.zsh` yourself as well if you are interested.
        - Don't forget to run `source ~/.p10k.zsh` afterwards to apply changes.
