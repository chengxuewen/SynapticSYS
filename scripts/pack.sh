

if [ -n "$BASH_SOURCE" ]; then
    scriptPath="$BASH_SOURCE"
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
pwdDirName="$(basename "$scriptDir")"
pwdDir="$(pwd)"

argPackName="$pwdDirName"
while [ $# -gt 0 ]; do
    case "$1" in
        --pack-name)
            if [ -n "$2" ]; then
                argPackName="$2"
                shift 2
            else
                echo "Error: Invalid pack name."
                exit 1
            fi
            ;;
        *)
            echo "Error: Unknown parameter $1"
            exit 1
            ;;
    esac
done

tar -czvf $pwdDir/../$argPackName.tar.gz \
    --exclude="env" \
    --exclude="log" \
    --exclude="data" \
    --exclude="storage" \
    --exclude="activate.sh" \
    -s "/^$pwdDirName/$argPackName/" \
    -C $scriptDir/.. $pwdDirName