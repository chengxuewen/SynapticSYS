#!/bin/sh -e

rootDir=$(X= cd -- "$(dirname -- "$0")" && pwd -P)

argBuildMode="upto"
argVCSMode="init"
argPackEnv="base"

argSkipFinished=false
argSkipPackEnv=true
argCleanCache=false
argPackages=""

argInstallDir="$rootDir/install"
argBuildDir="$rootDir/build"
argWorkDir="$rootDir/src"

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
            if [ "$2" = "base" ] || [ "$2" = "extensions" ]; then
                argPackEnv="$2"
                shift 2
            else
                echo "Error: Invalid pack env. Use 'base', or 'extensions'."
                exit 1
            fi
            ;;
        --work-dir)
            if [ -n "$2" ]; then
                argWorkDir="$2"
                shift 2
            else
                echo "Error: Invalid work dir."
                exit 1
            fi
            ;;
        --build-dir)
            if [ -n "$2" ]; then
                argBuildDir="$2"
                shift 2
            else
                echo "Error: Invalid build dir."
                exit 1
            fi
            ;;
        --install-dir)
            if [ -n "$2" ]; then
                argInstallDir="$2"
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
cd "$rootDir" || { echo "Unable to enter directory: $rootDir"; exit 1; }
echo "pixi lock..."
pixi lock
echo "pixi install..."
pixi install
echo "pixi install pixi-pack..."
pixi global install pixi-pack
PIXI_ENV_PATH=$(pixi run bash -c "echo \$CONDA_PREFIX")
PIXI_LIB_PATH="${PIXI_ENV_PATH}/lib"

if [ ! -f "$rootDir/dist/environment.sh" ]; then
    echo "pixi runtime environment.sh does not exist, creating..."
    argSkipPackEnv="false"
fi
mkdir -p "$argInstallDir"
if [ "$argSkipPackEnv" != "true" ]; then
    echo "pixi pack $argPackEnv environment..."
    mkdir -p "$rootDir/dist"
    pixi-pack --environment $argPackEnv \
        --create-executable \
        -o $rootDir/dist/environment.sh \
        --use-cache $rootDir/.pixi-pack/cache
fi
cp "$rootDir/dist/environment.sh" "$argInstallDir/environment.sh"
cp "$rootDir/scripts/install.sh" "$argInstallDir/install.sh"
cp "$rootDir/scripts/pack.sh" "$argInstallDir/pack.sh"

mkdir -p "$rootDir/src/deps"
if [ "$argVCSMode" = "force" ]; then
    echo "vcs update deps..."
    pixi run vcs import --input $rootDir/src/base.repos $rootDir/src/deps --force
    pixi run vcs import --input $rootDir/src/extensions.repos $rootDir/src/deps --force
elif [ "$argVCSMode" = "init" ]; then
    echo "vcs check deps..."
    pixi run vcs import --input $rootDir/src/base.repos $rootDir/src/deps
    pixi run vcs import --input $rootDir/src/extensions.repos $rootDir/src/deps
elif [ "$argVCSMode" = "ignore" ]; then
    echo "vcs ignore..."
fi

if [ "$argVCSMode" != "ignore" ]; then
    # Apply patches from src/patches directory
    echo "Applying patches from src/patches directory..."
    # Recursively find all patch files in src/patches
    find "$rootDir/src/patches" -name "*.patch" | while read -r patch_file; do
        # Get relative path from src/patches to the patch file
        relative_path=$(echo "$patch_file" | sed "s|^$rootDir/src/patches/||")
        # Extract repository path by removing the patch file name
        repo_path=$(dirname "$relative_path")
        # Full path to the repository in src/deps
        full_repo_path="$rootDir/src/deps/$repo_path"
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

echo "Enter root directory $rootDir..."
cd "$rootDir" || { echo "Unable to enter directory: $rootDir"; exit 1; }
echo "bash $argInstallDir/local_setup.bash"
basePaths="$rootDir/src/deps/base $rootDir/src/base"
addonCMDS=""
if [ -n "$argPackages" ]; then
    basePaths="$basePaths $rootDir/src $argWorkDir"
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
    echo "Set base packages select ..."
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
echo "Building packages..."
pixi run colcon build \
    --merge-install \
    --base-path $basePaths \
    --build-base $argBuildDir \
    --install-base $argInstallDir \
    --metas $rootDir/packages.meta \
    --packages-ignore lttngpy \
    $addonCMDS \
    --cmake-args \
    -DBUILD_TESTING=OFF