#!/bin/sh -e

rootDir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd -P 2>/dev/null || pwd -P)"
pwdDir="$(pwd)"

eval "$(pixi shell-hook --manifest-path $rootDir/pixi.toml)"