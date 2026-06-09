# Environment for Homebrew's icu4c (needed by marksman LSP)
if command -v brew &>/dev/null; then
  export LDFLAGS="-L$(brew --prefix icu4c)/lib"
  export CPPFLAGS="-I$(brew --prefix icu4c)/include"
  export LD_LIBRARY_PATH="$(brew --prefix icu4c)/lib:$LD_LIBRARY_PATH"
fi
