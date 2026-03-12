#!/bin/sh -e

rootDir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd -P 2>/dev/null || pwd -P)"
pwdDir="$(pwd)"

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

if [ ! -d "$rootDir/env" ]; then
    echo "$rootDir/env does not exist!"
    if [ -f "$rootDir/environment.sh" ]; then
      cd "$rootDir" || { echo "Unable to enter directory: $rootDir"; exit 1; }
      echo "run $rootDir/environment.sh..."
      bash "$rootDir/environment.sh"
    fi
fi

if [ ! -f "$rootDir/activate.sh" ]; then
    echo "$rootDir/activate.sh does not exist!"
else
    echo "run $rootDir/activate.sh..."
    source "$rootDir/activate.sh"
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

if [ -f "$rootDir/local_setup.sh" ]; then
    echo "source $rootDir/local_setup.sh..."
    source "$rootDir/local_setup.sh"
elif [ -f "$pwdDir/local_setup.sh" ]; then
    echo "source $pwdDir/local_setup.sh..."
    source "$pwdDir/local_setup.sh"
fi

export DYLD_LIBRARY_PATH=$rootDir/env/lib:$DYLD_LIBRARY_PATH
cd "$pwdDir" || { echo "Unable to enter directory: $pwdDir"; exit 1; }