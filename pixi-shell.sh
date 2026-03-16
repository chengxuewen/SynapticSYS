if [ -n "$BASH_SOURCE" ]; then
    scriptPath="$BASH_SOURCE"
    echo "1=$BASH_SOURCE"
elif [ -n "$ZSH_VERSION" ]; then
    scriptPath="${(%):-%x}"
else
    scriptPath="$0"
fi
[ -z "$scriptPath" ] && scriptPath="$0"
if __dir="$(cd -- "$(dirname -- "$scriptPath" 2>/dev/null)" && pwd -P 2>/dev/null)"; then
    scriptDir="$__dir"
elif __dir="$(cd -- "$(dirname -- "$0")" && pwd -P 2>/dev/null)"; then
    scriptDir="$__dir"
else
    scriptDir="$(pwd -P 2>/dev/null || echo "/tmp")"
fi

eval "$(pixi shell-hook --manifest-path $scriptDir/pixi.toml)"