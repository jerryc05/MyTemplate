# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ]        && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Cargo
[ -d $HOME/.cargo/bin ] && export PATH="$HOME/.cargo/bin:$PATH"

# LLVM Clang for Mac
if [ "$(uname -s)" = "Darwin" ] && [ -d "/usr/local/opt/llvm" ]; then
  export PATH="/usr/local/opt/llvm/bin:$PATH"
  [ -f /usr/local/opt/llvm/bin/llvm-clang   ] || ln -s /usr/local/opt/llvm/bin/clang   /usr/local/opt/llvm/bin/llvm-clang
  [ -f /usr/local/opt/llvm/bin/llvm-clang++ ] || ln -s /usr/local/opt/llvm/bin/clang++ /usr/local/opt/llvm/bin/llvm-clang++

      __lib="-L/usr/local/opt/llvm/lib"     && { [[ ! "$LFDLAGS"  == *"$__lib"*     ]] && export  LDFLAGS="$LDFLAGS $__lib";      unset __lib }
  __include="-I/usr/local/opt/llvm/include" && { [[ ! $"CPPFLAGS" == *"$__include"* ]] && export CPPFLAGS="$CPPFLAGS $__include"; unset __include }
fi