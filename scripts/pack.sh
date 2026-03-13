#!/bin/sh -e

rootDir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd -P 2>/dev/null || pwd -P)"
pwdDirName="$(basename "$rootDir")"
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
    -C $rootDir/.. $pwdDirName