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

argBuildMode="upto"
argVCSMode="init"
argPackEnv="base"

argSkipFinished=false
argSkipPackEnv=true
argCleanCache=false
argPackages=""

argInstallDir="$scriptDir/install"
argBuildDir="$scriptDir/build"
argDistDir="$scriptDir/dist"
argWorkDir="$scriptDir/src"
argLogDir="$scriptDir/log"
argEnvDir="$scriptDir"

while [ $# -gt 0 ]; do
    case "$1" in
        --build-mode)
            if [ "$2" = "select" ] || [ "$2" = "upto" ]; then
                argBuildMode="$2"
                shift 2
            else
                echo "Error: Invalid build mode. Use 'select', 'upto'."
                exit 1
            fi
            ;;
        --vcs-mode)
            if [ "$2" = "force" ] || [ "$2" = "init" ] || [ "$2" = "ignore" ]; then
                argVCSMode="$2"
                shift 2
            else
                echo "Error: Invalid VCS mode. Use 'force', 'init', or 'ignore'."
                exit 1
            fi
            ;;
        --pack-env)
            if [ -n "$2" ]; then
                argPackEnv="$2"
                shift 2
            else
                echo "Error: Invalid pack env. Use 'base', 'extensions', or other env."
                exit 1
            fi
            ;;
        --env-dir)
            if [ -n "$2" ]; then
                argEnvDir="$(realpath "$2")"
                shift 2
            else
                echo "Error: Invalid env dir."
                exit 1
            fi
            ;;
        --log-dir)
            if [ -n "$2" ]; then
                mkdir -p "$2"
                argLogDir="$(realpath "$2")"
                shift 2
            else
                echo "Error: Invalid log dir."
                exit 1
            fi
            ;;
        --dist-dir)
            if [ -n "$2" ]; then
                mkdir -p "$2"
                argDistDir="$(realpath "$2")"
                shift 2
            else
                echo "Error: Invalid dist dir."
                exit 1
            fi
            ;;
        --work-dir)
            if [ -n "$2" ]; then
                mkdir -p "$2"
                argWorkDir="$(realpath "$2")"
                shift 2
            else
                echo "Error: Invalid work dir."
                exit 1
            fi
            ;;
        --build-dir)
            if [ -n "$2" ]; then
                mkdir -p "$2"
                argBuildDir="$(realpath "$2")"
                shift 2
            else
                echo "Error: Invalid build dir."
                exit 1
            fi
            ;;
        --install-dir)
            if [ -n "$2" ]; then
                mkdir -p "$2"
                argInstallDir="$(realpath "$2")"
                shift 2
            else
                echo "Error: Invalid install dir."
                exit 1
            fi
            ;;
        --packages)
            shift
            while [ $# -gt 0 ] && ! echo "$1" | grep -q "^--"; do
                if [ -z "$argPackages" ]; then
                    argPackages="$1"
                else
                    argPackages="$argPackages $1"
                fi
                shift
            done
            if [ -z "$argPackages" ]; then
                echo "Error: --packages requires at least one value"
                exit 1
            fi
            ;;
        --skip-finished)
            if [ "$2" = "true" ] || [ "$2" = "false" ]; then
                argSkipFinished="$2"
                shift 2
            else
                echo "Error: Invalid skip finished option. Use 'true', or 'false'."
                exit 1
            fi
            ;;
        --skip-pack-env)
            if [ "$2" = "true" ] || [ "$2" = "false" ]; then
                argSkipPackEnv="$2"
                shift 2
            else
                echo "Error: Invalid skip packenv option. Use 'true', or 'false'."
                exit 1
            fi
            ;;
        --clean-cache)
            if [ "$2" = "true" ] || [ "$2" = "false" ]; then
                argCleanCache="$2"
                shift 2
            else
                echo "Error: Invalid clean cache option. Use 'true', or 'false'."
                exit 1
            fi
            ;;
        *)
            echo "Error: Unknown parameter $1"
            exit 1
            ;;
    esac
done

echo "Set install dir as:$argInstallDir"
echo "Set build dir as:$argBuildDir"
echo "Set work dir as:$argWorkDir"

# reset dyld path environment
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
export DYLD_LIBRARY_PATH=""
export DYLD_FALLBACK_LIBRARY_PATH=/usr/lib:/usr/local/lib

export PATH="$HOME/.pixi/bin:$PATH"
if command -v pixi >/dev/null 2>&1; then
    echo "pixi is installed"
else
    echo "pixi is not installed, start install pixi..."
    wget -qO- https://pixi.sh/install.sh | sh
    if [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
fi

# install platform dependency packages
echo "enter pixi environment dir $argEnvDir..."
cd "$argEnvDir" || { echo "Unable to enter directory: $argEnvDir"; exit 1; }
echo "pixi lock..."
pixi lock
echo "pixi install..."
pixi install --use-environment-activation-cache
echo "pixi install pixi-pack..."
pixi global install pixi-pack
PIXI_ENV_PATH=$(pixi run bash -c "echo \$CONDA_PREFIX")
PIXI_LIB_PATH="${PIXI_ENV_PATH}/lib"

if [ ! -f "$argEnvDir/dist/environment-$argPackEnv.sh" ]; then
    echo "pixi runtime $argEnvDir/dist/environment-$argPackEnv.sh does not exist, creating..."
    argSkipPackEnv="false"
fi
if [ "$argSkipPackEnv" != "true" ]; then
    echo "pixi pack $argPackEnv environment..."
    mkdir -p "$argDistDir"
    pixi-pack --environment $argPackEnv \
        --create-executable \
        -o $argDistDir/environment-$argPackEnv.sh \
        --use-cache $argEnvDir/.pixi-pack/cache
fi
mkdir -p "$argInstallDir"
cp "$argDistDir/environment-$argPackEnv.sh" "$argInstallDir/environment.sh"
cp "$scriptDir/scripts/install.sh" "$argInstallDir/install.sh"
cp "$scriptDir/scripts/pack.sh" "$argInstallDir/pack.sh"

mkdir -p "$scriptDir/src/deps"
if [ "$argVCSMode" = "force" ]; then
    echo "vcs update deps..."
    pixi run vcs import --input $scriptDir/src/base.repos $scriptDir/src/deps --force
    pixi run vcs import --input $scriptDir/src/extensions.repos $scriptDir/src/deps --force
elif [ "$argVCSMode" = "init" ]; then
    echo "vcs check deps..."
    pixi run vcs import --input $scriptDir/src/base.repos $scriptDir/src/deps
    pixi run vcs import --input $scriptDir/src/extensions.repos $scriptDir/src/deps
elif [ "$argVCSMode" = "ignore" ]; then
    echo "vcs ignore..."
fi

if [ "$argVCSMode" != "ignore" ]; then
    # Apply patches from src/patches directory
    echo "Applying patches from src/patches directory..."
    # Recursively find all patch files in src/patches
    find "$scriptDir/src/patches" -name "*.patch" | while read -r patch_file; do
        # Get relative path from src/patches to the patch file
        relative_path=$(echo "$patch_file" | sed "s|^$scriptDir/src/patches/||")
        # Extract repository path by removing the patch file name
        repo_path=$(dirname "$relative_path")
        # Full path to the repository in src/deps
        full_repo_path="$scriptDir/src/deps/$repo_path"
        # Check if the repository directory exists
        if [ -d "$full_repo_path" ]; then
            cd "$full_repo_path"
            if git apply --check "$patch_file" 2>/dev/null; then
                echo "Applying patch $patch_file to $repo_path"
                # Change to the repository directory and apply the patch
                git apply "$patch_file" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo "✓ Successfully applied patch to $repo_path"
                else
                    echo "✗ Failed to apply patch to $repo_path"
                fi
            else
                echo "✓ Already applied patch $patch_file to $repo_path"
            fi
        else
            echo "⚠ Repository directory $full_repo_path does not exist, skipping patch"
        fi
    done
fi

echo "Enter root directory $argEnvDir..."
cd "$argEnvDir" || { echo "Unable to enter directory: $argEnvDir"; exit 1; }
basePaths="$scriptDir/src/deps/base $scriptDir/src/base"
addonCMDS=""
if [ -n "$argPackages" ]; then
    basePaths="$basePaths $scriptDir/src $argWorkDir"
    if [ "$argBuildMode" = "select" ]; then
        echo "Set packages select $argPackages..."
        addonCMDS="$addonCMDS --packages-select $argPackages"
    elif [ "$argBuildMode" = "upto" ]; then
        echo "Set packages up to $argPackages..."
        addonCMDS="$addonCMDS --packages-up-to $argPackages"
    else
        echo "unknown build mode $argBuildMode..."
        exit 1
    fi
else
    echo "Set packages up to synapticsys_base..."
    addonCMDS="$addonCMDS --packages-up-to synapticsys_base"
fi
if [ "$argSkipFinished" = "true" ]; then
    echo "Set packages skip build finished..."
    addonCMDS="$addonCMDS --packages-skip-build-finished"
fi
if [ "$argCleanCache" = "true" ]; then
    echo "Set packages cmake clean cache..."
    addonCMDS="$addonCMDS --cmake-clean-cache"
fi
if [ -e "$argInstallDir/local_setup.bash" ]; then
    echo "bash $argInstallDir/local_setup.bash..."
    bash "$argInstallDir/local_setup.bash"
fi
export CPLUS_INCLUDE_PATH="$PIXI_ENV_PATH/include:$CPLUS_INCLUDE_PATH"
export PKG_CONFIG_PATH="$PIXI_LIB_PATH/pkgconfig:$PKG_CONFIG_PATH"
export C_INCLUDE_PATH="$PIXI_ENV_PATH/include:$C_INCLUDE_PATH"
export CMAKE_INCLUDE_PATH="$PIXI_ENV_PATH/include"
export LD_LIBRARY_PATH="$PIXI_LIB_PATH"
export LIBRARY_PATH="$PIXI_LIB_PATH"
export CMAKE_FIND_ROOT_PATH="$PIXI_ENV_PATH;$argBuildDir"
export CMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
export CMAKE_PREFIX_PATH="$PIXI_ENV_PATH"
export PIXI_ENV_PATH="$PIXI_ENV_PATH"
echo "Building packages..."
pixi run colcon \
    --log-base $argLogDir \
    build \
    --merge-install \
    --base-path $basePaths \
    --build-base $argBuildDir \
    --install-base $argInstallDir \
    --metas $scriptDir/packages.meta \
    --packages-ignore lttngpy \
    $addonCMDS \
    --cmake-args \
    -DBUILD_TESTING=OFF
#    -DCMAKE_TOOLCHAIN_FILE=$scriptDir/cmake/pixi-toolchain.cmake
#    -DCMAKE_PREFIX_PATH="$PIXI_ENV_PATH;$argInstallDir"
