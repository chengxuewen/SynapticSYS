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

unset ROS_DISTRO
unset ROS_PACKAGE_PATH
unset ROS_ETC_DIR
unset ROS_ROOT
unset ROS_MASTER_URI
unset ROS_PYTHON_VERSION
unset PYTHONPATH
unset LD_LIBRARY_PATH
unset AMENT_PREFIX_PATH
unset COLCON_PREFIX_PATH
unset COLCON_CURRENT_PREFIX

if [ ! -d "$scriptDir/env" ]; then
    echo "$scriptDir/env does not exist!"
    if [ -f "$scriptDir/environment.sh" ]; then
      cd "$scriptDir" || { echo "Unable to enter directory: $scriptDir"; exit 1; }
      echo "run $scriptDir/environment.sh..."
      bash "$scriptDir/environment.sh"
    fi
fi

if [ ! -f "$scriptDir/activate.sh" ]; then
    echo "$scriptDir/activate.sh does not exist!"
else
    echo "run $scriptDir/activate.sh..."
    source "$scriptDir/activate.sh"
fi

if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz compinit bashcompinit
    compinit -i 2>/dev/null
    bashcompinit -i 2>/dev/null
    if ! type _ros2_completion &>/dev/null; then
      eval "$(register-python-argcomplete ros2)" 2>/dev/null
      eval "$(register-python-argcomplete colcon)" 2>/dev/null
      echo "register-python-argcomplete (Zsh)"
    fi

elif [ -n "$BASH_VERSION" ]; then
    if ! type _python_argcomplete &>/dev/null; then
        eval "$(register-python-argcomplete ros2)" 2>/dev/null
        eval "$(register-python-argcomplete colcon)" 2>/dev/null
        echo "register-python-argcomplete (Bash)"
    fi
else
    echo "unknown shell type，skip completion registration"
fi

if [ -f "$scriptDir/local_setup.sh" ]; then
    echo "source $scriptDir/local_setup.sh..."
    source "$scriptDir/local_setup.sh"
elif [ -f "$pwdDir/local_setup.sh" ]; then
    echo "source $pwdDir/local_setup.sh..."
    source "$pwdDir/local_setup.sh"
fi


export LD_LIBRARY_PATH="$scriptDir/env/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH=$(echo "$LD_LIBRARY_PATH" | awk -v RS=':' '!a[$1]++' | paste -sd: -)

export DYLD_LIBRARY_PATH="$scriptDir/env/lib:$DYLD_LIBRARY_PATH"
export DYLD_LIBRARY_PATH=$(echo "$DYLD_LIBRARY_PATH" | awk -v RS=':' '!a[$1]++' | paste -sd: -)

cd "$pwdDir" || { echo "Unable to enter directory: $pwdDir"; exit 1; }